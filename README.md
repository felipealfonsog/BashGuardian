### BashGuardian 🛡️ [(Experimental Project)](#important-experimental-project)*

BashGuardian is a powerful bash script for backups and encryption on Unix-like (Linux & macOS) systems. It provides an easy-to-use and secure way to protect your important files and data. 🗂️🔒

![Version](https://img.shields.io/github/release/felipealfonsog/BashGuardian.svg?style=flat&color=blue)
![Main Language](https://img.shields.io/github/languages/top/felipealfonsog/BashGuardian.svg?style=flat&color=blue)
[![Open Source? Yes!](https://badgen.net/badge/Open%20Source%20%3F/Yes%21/blue?icon=github)](https://github.com/Naereen/badges/)

[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/)
<!-- 
[![GPL license](https://img.shields.io/badge/License-GPL-blue.svg)](http://perso.crans.org/besson/LICENSE.html)
-->

[![Vim Powered](https://img.shields.io/badge/Vim-Powered-%2311AB00.svg?logo=vim&logoColor=white)](https://www.vim.org)
[![VS Code Powered](https://img.shields.io/badge/VS%20Code-Powered-%23007ACC.svg?logo=visualstudiocode&logoColor=white)](https://code.visualstudio.com/)

<sub>* This is currently an experimental phase where the primary focus is on making the system functional and establishing a practical and logical pathway that aligns with both my vision and the project's goals. It might contain errors, bugs, etc. Many other non-core elements of the project are considered secondary.</sub>

#### How-to 🗝️📂

First download the main script: 

```
curl -O  https://raw.githubusercontent.com/felipealfonsog/BashGuardian/main/backups_stable.sh
```

then, 

```
chmod +x backups_stable.sh
```

and execute it:

```
./backups_stable.sh
```

<sub>
NOTE: Check out the crontab.txt file to adapt your crontab with your system. You can also adapt the code according to your needs. 
</sub>

#### Decrypt and Untar 🗝️📂

To decrypt and untar your files, you can use the following commands:


```
gpg --decrypt --batch --passphrase passphrase encrypted_file.tar.gz.gpg | tar xzvf -
```

```
gpg --decrypt --batch --passphrase "passphrase" "backup_20230723_000101.tar.gz.gpg" | tar xzvf - --directory "$HOME/Documents/backedup-unencryped
```

#### To extract a simple tarball, e.g. 

tar -xvzf backups_macos_20231107_050001.tar.gz. 

Command:

```
tar -xvzf 
```


#### License 📜

BashGuardian is licensed under the MIT License. See [LICENSE](LICENSE) for more information.

#### Contributing 🤝

Contributions to BashGuardian are more than welcome! Here's how you can contribute:

1. Fork the repository.
2. Create a new branch: `git checkout -b feature/your-feature-name`.
3. Make your changes and commit them: `git commit -m 'Add your feature'`.
4. Push the changes to your branch: `git push origin feature/your-feature-name`.
5. Create a new pull request.

- **Code Contributions**: If you're a developer, you can contribute by submitting pull requests with bug fixes, new features, or improvements. Feel free to fork the project and create your branch to work on.

- **Bug Reports and Feedback**: If you encounter any issues or have suggestions for improvement, please open an issue on the project's GitHub repository. Your feedback is valuable in making the project better.

- **Documentation**: Improving the documentation is always appreciated. If you find any gaps or have suggestions to enhance the project's documentation, please let me know.

#### 📝Important (Experimental Project)

[![Experimental Project](https://img.shields.io/badge/Project-Type%3A%20Experimental-blueviolet)](#)

<p>This project is still in its experimental stage and may have limitations in terms of features and compatibility. Use at your own discretion.</p>

#### Contact 📧

Hello! My name is Felipe, and I'm a passionate Computer Science Engineer. I'm also the creator of this project. If you have any questions, suggestions, or just want to chat, feel free to reach out to me. I'd be more than happy to help! 😊

- **Email:** f.alfonso@res-ear.ch
- **LinkedIn:** [felipealfonsog](https://www.linkedin.com/in/felipealfonsog/)
- **GitHub:** [felipealfonsog](https://github.com/felipealfonsog)

#### Support ☕

Your support and contributions are greatly appreciated! Thank you for your help in making this project better. 🙌

- [![Sponsor on Paypal](https://img.shields.io/badge/Sponsor%20on-Paypal-blue)](https://paypal.me/felipealfonsog)
- [![Buy me a coffee](https://img.shields.io/badge/Buy%20me%20a%20coffee-orange)](https://www.buymeacoffee.com/felipealfonsog)
- [![Sponsor on GitHub](https://img.shields.io/badge/Sponsor%20on-GitHub-green)](https://github.com/sponsors/felipealfonsog)

