# Overview:

//insert video link here

- A simple, elegant password manager application built using Flutter. 

## Features:
- A 'zero-knowledge' system with a master password.
- AES encryption using the [dart encrypt package](https://pub.dev/packages/encrypt). 
- Secure, memorizable passwords using [Diceware](https://theworld.com/~reinhold/diceware.html) and the [EFF Wordlist](https://www.eff.org/deeplinks/2016/07/new-wordlists-random-passphrases).
- SHA256 hashing via the [dart crypto package](https://pub.dev/packages/crypto).
- Local SQL storage with the [flutter SQFlite package](https://pub.dev/packages/sqflite).

## Screenshots:

# Purpose:
- I undertook this project for a number of reasons. Primarily, I have been trying to learn Dart and Flutter for a while and such a build seemed like a good way to test out my knowledge so far as well as learn through a challenging project. I was able to construct a relatively clean and scalable architecture that form the core principles of the build and I could code efficiently, bearing in mind readability and effectiveness. Through the build, I was able to understand how to better manage state in Flutter using the BLOC pattern and how to combine StatefulWidgets with the aforementioned approach in order to achieve a balance of simplicity and use. I could work with many external packages such as rxdart, sqflite as well as leverage the OOP and typed nature of dart to arrive at work that was of a decent quality.
- Secondly, a password manager is something that I have been meaning to use for a while, and before I dove into any, I wanted to try to understand how they work so that I would be better suited to make a decision on any particular technology. **My intention with this build wasn't ever and isn't to make a functioning password manager that could compete with existing solutions like LastPass and PassKey**. 
- I wanted to build a barebones password manager that did not require a large amount of cryptography knowledge but could still offer some protection and so I researched the different techniques that password managers used and decided to rely on a 'zero knowledge system' where the programmer cannot decrypt users passwords even if they wanted to because a key piece of data is missing: the master password. In implementing such a system, understanding some fundamental ideas about hashing, encryption and getting exposed to emerging concepts such as Diceware, this build has allowed me to further my infantile knowledge about cryptography and its applications. 
- Read the section below to understand the workings of the project - both in terms of the Flutter aspect as well as the cryptography. 

# Description: