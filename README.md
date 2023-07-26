# BashGuardian 🛡️

BashGuardian is a powerful bash script for backups and encryption on Unix-like (Linux & macOS) systems. It provides an easy-to-use and secure way to protect your important files and data. 🗂️🔒

![Version](https://img.shields.io/github/release/felipealfonsog/BashGuardian.svg?style=flat&color=blue)
![Main Language](https://img.shields.io/github/languages/top/felipealfonsog/BashGuardian.svg?style=flat&color=blue)
[![Open Source? Yes!](https://badgen.net/badge/Open%20Source%20%3F/Yes%21/blue?icon=github)](https://github.com/Naereen/badges/)

[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/)
[![GPL license](https://img.shields.io/badge/License-GPL-blue.svg)](http://perso.crans.org/besson/LICENSE.html)

[![Vim](https://img.shields.io/badge/--019733?logo=vim)](https://www.vim.org/)
[![Visual Studio Code](https://img.shields.io/badge/--007ACC?logo=visual%20studio%20code&logoColor=ffffff)](https://code.visualstudio.com/)

## Decrypt and Untar 🗝️📂

To decrypt and untar your files, you can use the following commands:


```
gpg --decrypt --batch --passphrase passphrase encrypted_file.tar.gz.gpg | tar xzvf -
```

```
gpg --decrypt --batch --passphrase "passphrase" "backup_20230723_000101.tar.gz.gpg" | tar xzvf - --directory "$HOME/Documents/backedup-unencryped
``````

## License 📜

BashGuardian is licensed under the MIT License. See [LICENSE](LICENSE) for more information.

## Contributing 🤝

Contributions to BashGuardian are more than welcome! Here's how you can contribute:

1. Fork the repository.
2. Create a new branch: `git checkout -b feature/your-feature-name`.
3. Make your changes and commit them: `git commit -m 'Add your feature'`.
4. Push the changes to your branch: `git push origin feature/your-feature-name`.
5. Create a new pull request.

- **Code Contributions**: If you're a developer, you can contribute by submitting pull requests with bug fixes, new features, or improvements. Feel free to fork the project and create your branch to work on.

- **Bug Reports and Feedback**: If you encounter any issues or have suggestions for improvement, please open an issue on the project's GitHub repository. Your feedback is valuable in making the project better.

- **Documentation**: Improving the documentation is always appreciated. If you find any gaps or have suggestions to enhance the project's documentation, please let me know.


## Contact 📧

Hello! My name is Felipe, and I'm a passionate Computer Science Engineer. I'm also the creator of this project. If you have any questions, suggestions, or just want to chat, feel free to reach out to me. I'd be more than happy to help! 😊

- **Email:** f.alfonso@res-ear.ch
- **LinkedIn:** [felipealfonsog](https://www.linkedin.com/in/felipealfonsog/)
- **GitHub:** [felipealfonsog](https://github.com/felipealfonsog)

#### Support ☕

Your support and contributions are greatly appreciated! Thank you for your help in making this project better. 🙌

- [![Sponsor on Paypal](https://img.shields.io/badge/Sponsor%20on-Paypal-blue)](https://paypal.com/felipealfonsog)
- [![Buy me a coffee](https://img.shields.io/badge/Buy%20me%20a%20coffee-orange)](https://www.buymeacoffee.com/felipealfonsog)
- [![Sponsor on GitHub](https://img.shields.io/badge/Sponsor%20on-GitHub-green)](https://github.com/sponsors/felipealfonsog)

