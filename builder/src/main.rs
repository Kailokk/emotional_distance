use std::{
    process::{ self, Command, Output, ExitStatus, Child },
    io,
    fmt::format,
    env,
    path::PathBuf,
    os::windows::thread,
    thread::sleep,
    time::Duration,
};
use colored::Colorize;

fn main() {
    print_title("Compiling arduino code");
    if let Some(exit_status) = compile_arduino() {
        match exit_status.success() {
            true => (),
            false => {
                print_error("Arduino compilation failed");
                return;
            }
        }
    } else {
        print_error("Couldnt start arduino compilation process");
        return;
    }
    print_success("Arduino code compiled successfully");

    print_title("Uploading code to arduino unit");
    if let Some(exit_status) = upload_arduino() {
        match exit_status.success() {
            true => (),
            false => {
                print_error("Arduino upload failed");
                print_error(
                    "Please ensure the arduino is connected to the computer via a usb cable"
                );
                print_error("An orange light should be visible on the unit.");
                return;
            }
        }
    } else {
        print_error("Couldnt start arduino upload process");
        return;
    }

    print_success("Arduino code uploaded successfully");

    let mut current_dir = env::current_dir().unwrap();
    current_dir.pop();

    let mut sketch_dir = current_dir.clone();
    sketch_dir.push("processing_sketch");

    let mut output_dir = current_dir.clone();
    output_dir.push("output");

    print_title("Building processing sketch");
    if let Some(exit_status) = export_processing(&sketch_dir, &output_dir) {
        match exit_status.success() {
            true => (),
            false => {
                print_error("Processing build exited early due to an error");
                return;
            }
        }
    } else {
        print_error("Couldnt start processing build process");
        return;
    }

    print_success("Processing file succesfully built!");
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

fn export_processing(sketch_dir: &PathBuf, output_dir: &PathBuf) -> Option<ExitStatus> {
    let sketch_path = format!("--sketch={}", sketch_dir.to_string_lossy());
    let output_path = format!("--output={}", output_dir.to_string_lossy());

    let result = Command::new("processing-java")
        .arg("--force")
        .arg(sketch_path)
        .arg(output_path)
        .arg("--export")
        .status();

    match result {
        Ok(status) => {
            return Some(status);
        }
        Err(error) => eprintln!("{}", error),
    }
    return None;
}

fn print_display_line() {
    println!("{}", "------------".blue());
}

fn print_title(title: &str) {
    print_display_line();
    println!("{}", title.cyan());
    print_display_line();
}

fn print_success(success: &str) {
    println!();
    println!("~~~{}~~~", success.green());
    println!();
}

fn print_error(error: &str) {
    println!();
    eprintln!("~~~{}~~~", error.red());
    println!();
}
