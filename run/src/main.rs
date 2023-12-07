use std::{ process::{ self, Command, Output, ExitStatus, Child }, io };
fn main() {
    println!("------------");
    println!("Compiling arduino code");
    println!("------------");
    if let Some(exit_status) = compile_arduino() {
        match exit_status.success() {
            true => (),
            false => {
                eprintln!("Arduino compilation failed");
                return;
            }
        }
    } else {
        eprintln!("Couldnt start arduino compilation process");
        return;
    }
    println!("Arduino code compiled successfully");

    println!("------------");
    println!("Uploading code to arduino unit");
    println!("------------");
    if let Some(exit_status) = upload_arduino() {
        match exit_status.success() {
            true => (),
            false => {
                eprintln!("Arduino upload failed");
                eprintln!("Please ensure the arduino is connected to the computer via a usb cable");
                eprintln!("An orange light should be visible on the unit.");
                return;
            }
        }
    } else {
        eprintln!("Couldnt start arduino upload process");
        return;
    }

    println!("Arduino code uploaded successfully");

    println!("------------");
    println!("Launching processing sketch");
    println!("------------");
}

fn compile_arduino() -> Option<ExitStatus> {
    let result = Command::new("arduino-cli")
        .arg("compile")
        .arg("../arduino_sketch")
        .arg("-b")
        .arg("arduino:avr:uno")
        .status();
    match result {
        Ok(status) => {
            return Some(status);
        }
        Err(error) => eprintln!("{}", error),
    }
    return None;
}

fn upload_arduino() -> Option<ExitStatus> {
    let result = Command::new("arduino-cli")
        .arg("upload")
        .arg("../arduino_sketch")
        .arg("-b")
        .arg("arduino:avr:uno")
        .arg("-p")
        .arg("COM3")
        .status();
    match result {
        Ok(status) => {
            return Some(status);
        }
        Err(error) => eprintln!("{}", error),
    }
    return None;
}

fn launch_processing() {}
