# Path of Building with noVNC

This Docker image allows you to run Path of Building through a web browser using noVNC.

**CURRENT VERSION OF POB : 2.45.0**

## How to Use

1. Pull the Docker image from Docker Hub:

    ```bash
    docker pull monsieurgui/pathofbuilding-novnc:latest
    ```

2. Run the Docker container:

    ```bash
    docker run -it --rm -p 6080:6080 monsieurgui/pathofbuilding-novnc:latest
    ```

3. Open your web browser and navigate to `http://localhost:6080`. You will be redirected to the noVNC interface, where you can interact with Path of Building.

## Notes

- This setup does not require a VNC password.
- The application runs in a web browser via noVNC.
- Ensure that your system meets the necessary requirements to run Docker.

## Issues and Contributions

If you encounter any issues or have suggestions for improvements, please open an issue or submit a pull request on the [GitHub repository](https://github.com/monsieurgui/pob-crossplatform).

## License

This project is licensed under the MIT License.
