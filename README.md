# reactappcontrol

# React docker,proxy control

Welcome to the React app control repository! This project aims to simplify the setup and management of React applications, server configuration with Nginx upstream, Docker image creation, and deployment using various tools and services.

## Features

- Create a new React app or preconfigure an existing app
- Generate servers with Nginx upstream for domain or subdomain configuration
- Build Docker images with options for production or development environments
- Create additional images for staging purposes
- Deploy servers with the ability to manage images and enable smooth transitions with minimal downtime
- Utilize Nginx upstream, HAProxy, or Apache proxy for load balancing and reverse proxying
- Initialize Git or push Docker images to the desired repository
- Configure Docker context, network, and registry settings
- Organize files into folders for better project structure
- Integration with DigitalOcean, Git, GoDaddy, and other platforms
- Special configuration settings available in `api_keys.conf` file

## Getting Started

To get started with this project, please follow the steps below:

1. Clone this repository to your local machine.
2. Navigate to the project root directory.
3. Review the project structure and organization of files in the respective folders (`nginx`, `pm2`, `docker`, `digitalocean`, `git`, `godaddy`, `version`).
4. Customize the configuration files based on your requirements. Pay special attention to the `api_keys.conf` file for specific API key configurations.
5. Use the provided Makefile to perform various tasks and manage your project.

## Usage

To use the Makefile commands, open a terminal and navigate to the project root directory. Here are some common commands:

- `make create_react_app`: Create a new React app.
- `make preconfig`: Preconfigure an existing React app.
- `make create_nginx`: Generate a server configuration with Nginx upstream for a domain or subdomain.
- `make rebuild`: Build Docker image with options for production or development.
- `make deploy_stg`: Build staging Docker image.
- `make deploy`: Deploy the server and manage images for smooth transitions.
- `make git_init`: Initialize Git repository.
- `make push_image`: Push Docker image to the desired repository.
- `make create_context`: Configure Docker context settings.
- `make create_network`: Configure Docker network settings.
- `make setup_registry`: Configure Docker registry settings.

Please refer to the Makefile for more detailed command descriptions and options.

## Contributing

Contributions to this project are welcome! If you find any issues or have ideas for improvements, please open an issue or submit a pull request. Let's collaborate and make this project even better together!

## License

This project is licensed under the [MIT License](LICENSE). Feel free to use, modify, and distribute it as per the license terms.

## Acknowledgements

We would like to express our gratitude to the open-source community for their contributions and support.

## Contact

For any inquiries or support, please contact us at [adalbertbarta@gmail.com](mailto:adalbertbarta@gmail.com).

Happy coding!
