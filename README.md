# Overview:

- A simple, elegant password manager application built using Flutter. 

## Features:
- A 'zero-knowledge' system with a master password.
- AES encryption using the [dart encrypt package](https://pub.dev/packages/encrypt). 
- Secure, memorizable passwords using [Diceware](https://theworld.com/~reinhold/diceware.html) and the [EFF Wordlist](https://www.eff.org/deeplinks/2016/07/new-wordlists-random-passphrases).
- SHA256 hashing via the [dart crypto package](https://pub.dev/packages/crypto).
- Local SQL storage with the [flutter SQFlite package](https://pub.dev/packages/sqflite).

## Screenshots:
- Here are some of the key shots of the app, you could observe the rest in the [screenshots](https://github.com/akashvshroff/Safe_Flutter_App/tree/master/screenshots) or simply watch the video above to see the app in action!

<img width="225" height="475" src="https://github.com/akashvshroff/Safe_Flutter_App/blob/master/screenshots/loading.png"> &nbsp; &nbsp; <img width="225" height="475" src="https://github.com/akashvshroff/Safe_Flutter_App/blob/master/screenshots/master_password.png"> &nbsp; &nbsp; <img width="225" height="475" src="https://github.com/akashvshroff/Safe_Flutter_App/blob/master/screenshots/verify_success.png">


<img width="225" height="475" src="https://github.com/akashvshroff/Safe_Flutter_App/blob/master/screenshots/details_list.png"> &nbsp; &nbsp; <img width="225" height="475" src="https://github.com/akashvshroff/Safe_Flutter_App/blob/master/screenshots/focus_visible.png"> &nbsp; &nbsp; <img width="225" height="475" src="https://github.com/akashvshroff/Safe_Flutter_App/blob/master/screenshots/edit.png">


<img width="225" height="475" src="https://github.com/akashvshroff/Safe_Flutter_App/blob/master/screenshots/add.png"> &nbsp; &nbsp; <img width="225" height="475" src="https://github.com/akashvshroff/Safe_Flutter_App/blob/master/screenshots/generate_memorizable.png"> &nbsp; &nbsp; <img width="225" height="475" src="https://github.com/akashvshroff/Safe_Flutter_App/blob/master/screenshots/add_password.png">


# Purpose:
- I undertook this project for a number of reasons. Primarily, I have been trying to learn Dart and Flutter for a while and such a build seemed like a good way to test out my knowledge so far as well as learn through a challenging project. I was able to construct a relatively clean and scalable architecture that form the core principles of the build and I could code efficiently, bearing in mind readability and effectiveness. Through the build, I was able to understand how to better manage state in Flutter using the BLOC pattern and how to combine StatefulWidgets with the aforementioned approach in order to achieve a balance of simplicity and use. I could work with many external packages such as rxdart, sqflite as well as leverage the OOP and typed nature of dart to arrive at work that was of a decent quality.
- Secondly, a password manager is something that I have been meaning to use for a while, and before I dove into any, I wanted to try to understand how they work so that I would be better suited to make a decision on any particular technology. **My intention with this build wasn't ever and isn't to make a functioning password manager that could compete with existing solutions like LastPass and PassKey**. 
- I wanted to build a barebones password manager that did not require a large amount of cryptography knowledge but could still offer some protection and so I researched the different techniques that password managers used and decided to rely on a 'zero knowledge system' where the programmer cannot decrypt users passwords even if they wanted to because a key piece of data is missing: the master password. In implementing such a system, understanding some fundamental ideas about hashing, encryption and getting exposed to emerging concepts such as Diceware, this build has allowed me to further my infantile knowledge about cryptography and its applications. 
- Read the section below to understand the workings of the project - both in terms of the Flutter aspect as well as the cryptography. 

# Description:
- While I will not try to explain the project complete with all its nuances, I don't believe there is a need to either since the build has a number of comments that adorn the code, I will cover the basics of the cryptographic process as well as the Flutter portion. 

## Flutter Build:
- When understanding the Flutter build, there are a few pieces that work together to help the project come to life. I will try to go through them with a pseudo bird's eye view. 

### Data Storage and Repository:
- The [repository](https://github.com/akashvshroff/Safe_Flutter_App/blob/master/lib/src/resources/repository.dart) is the crux of the project and ties together the cryptography portion - all housed in the [crypto_resources dir](https://github.com/akashvshroff/Safe_Flutter_App/tree/master/lib/src/crypto_resources) - and the [database provider](https://github.com/akashvshroff/Safe_Flutter_App/blob/master/lib/src/resources/safe_db_provider.dart). 
- For the most part, data moves in the build in the form of a DetailModel instance. This model reflects password data that is stored in the database and has properties of id, service, username and encryptedPassword. 
- The repository is responsible for calling upon all the cryptographic functions as and when required, be it hashing the master password, decrypting a password to display to the user or encrypting a password to store in the database. It also houses methods that conduct CRUD operations on the database by leveraging methods of the database provider. 
- This class is not ever called upon by the UI directly, and is insulated by the BLOC. 

### BLOC:
- The [BLOC Class](https://github.com/akashvshroff/Safe_Flutter_App/blob/master/lib/src/blocs/bloc.dart) handles the majority of data flow within the build and has a number of StreamControllers that are subscribed to by UI elements using StreamBuilders and this way changing data is reflected in the code. 
- The BLOC also has methods for CRUD operations that are called upon by the UI and this is turn calls upon the repository class. 
- A deeper analysis of the Bloc class as well as a quick glance at all the comments that litter the code will be more than explanatory as to how each StreamController works. 

### onGenerateRoute:
- The [onGenerateRoute callback](https://github.com/akashvshroff/Safe_Flutter_App/blob/master/lib/src/app.dart) is reposible for the navigation in the project and it does so by parsing the route names that it called using. 
- These names correspond to the different [screens](https://github.com/akashvshroff/Safe_Flutter_App/tree/master/lib/src/screens) in the project and some of them even contain additional data such as the id of the DetailModel. 
- The onGenerateCallback also accesses the BLOC through its Provider and does so in order to call methods that either add relevant data to StreamControllers or reset the stream in order to reset the associated UI element. 

## Cryptography:
- 