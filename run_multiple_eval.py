import os
import subprocess
import re


def extract_map(output):
    """Extracts mAP value from the output string."""
    match = re.search(r"mAP:\s*(\d+\.\d+)", output)
    return float(match.group(1)) if match else None


def run_test(dataset, model_arch, ckpt_path):
    """Runs the test_ssd.py script and returns the output."""
    command = [
        "python",
        "test_ssd.py",
        "--dataset",
        dataset,
        "--model_arch",
        model_arch,
        "--ckpt_path",
        ckpt_path,
        "--phase",
        "test",
    ]
    result = subprocess.run(command, capture_output=True, text=True)
    return result.stdout


def find_best_checkpoint(root_path, dataset):
    results = {}

    for model_arch in os.listdir(root_path):
        model_path = os.path.join(root_path, model_arch)
        if not os.path.isdir(model_path):
            continue

        best_map = -1
        best_output = ""
        best_checkpoint = ""

        for ckpt in os.listdir(model_path):
            ckpt_path = os.path.join(model_path, ckpt)
            if not ckpt_path.endswith(".pth"):
                continue

            print(f"Testing {ckpt_path}...")
            output = run_test(dataset, model_arch, ckpt_path)
            mAP = extract_map(output)

            if mAP is not None and mAP > best_map:
                best_map = mAP
                best_output = output
                best_checkpoint = ckpt_path

        if best_checkpoint:
            results[model_arch] = (best_checkpoint, best_map, best_output)

    # Save results to a file
    with open("best_results.txt", "w") as f:
        for model_arch, (ckpt, mAP, output) in results.items():
            f.write(f"Best model for {model_arch}: {ckpt}\n")
            f.write(f"mAP: {mAP}\n")
            f.write("Output:\n")
            f.write(output + "\n" + "=" * 80 + "\n")

    print("Results saved to best_results.txt")


if __name__ == "__main__":
    root_path = "save/CLCXray"
    dataset = "CLCXray"
    find_best_checkpoint("save/CLCXray", "CLCXray")
