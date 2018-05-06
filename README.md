# OpenWhiskTalk
1. Use this command to install the Cloud Functions plugin for the IBM Cloud CLI.

   ```
   $ bx plugin install cloud-functions
   ```

   *This plugin provides the [Apache OpenWhisk CLI](https://github.com/apache/incubator-openwhisk/blob/master/docs/cli.md) as a sub-command under the IBM Cloud CLI. Platform credentials are provided automatically by the IBM Cloud CLI.*

   1. Run the following command to invoke a test function from the command-line.

   ```
   $ bx wsk action invoke whisk.system/utils/echo -p message hello --result
   {
       "message": "hello"
   }
   ```

   ### Background

   Actions are stateless code snippets that run on the OpenWhisk platform. An action can be written as a JavaScript, Swift, PHP, or Python function, a Java method, static binary or a custom executable packaged in a Docker container. For example, an action can be used to detect the faces in an image, respond to a database change, aggregate a set of API calls, or post a Tweet.

   Actions can be explicitly invoked, or run in response to an event. In either case, each run of an action results in an activation record that is identified by a unique activation ID. The input to an action and the result of an action are a dictionary of key-value pairs, where the key is a string and the value a valid JSON value. Actions can also be composed of calls to other actions or a defined sequence of actions.

   #### Creating Swift actions

   Review the following steps and examples to create your first Swift action.

   ```
   touch hello.swift
   open hello.swift
   ```

   1. Create a Swift file with the following content. For this example, the file name is 'hello.swift'.

   ```swift
   struct Output: Codable {
       let greeting: String
   }
   func main(completion: (Output?, Error?) -> Void) {
       let result = Output(greeting: "Hello World!")
       completion(result, nil)
   }
   ```

   The Swift file might contain additional functions. However, by convention, a function called `main` must exist to provide the entry point for the action.

   1. Create an action from the following Swift function. For this example, the action is called 'hello'.

   ```
   bx wsk action create hello hello.swift --kind swift:4.1
   ok: created action hello
   ```

   1. List the actions that you have created:

   ```
   $ bx wsk action list
   actions
   /user@host.com_dev/hello                                     
   ```

   You can see the `hello` action you just created.

   Invoking Actions

   After you create your action, you can run it on IBM Cloud Functions with the 'invoke' command.

   ```
   bx wsk action invoke --result helloSwift
   ```

   now we are going to add an input parameter to our action:

   ```swift
   struct input: Codable {
    let name: String?
    }
    func main(param: Input, completion: (Output?, Error?) -> Void) {
        let result = Output(greeting: "Hello \(param.name ?? "stranger")!")
    ```

    now we update our action on bluemix:

    ```
    bx wsk action update hello hello.swift
    bx wsk action invoke --result hello --param name Andy
    ```

    Show real example:

    ```
    open weather.swift
    ```

    create the action:

    ```
    bx wsk action create weather weather.swift
    bx wsk action invoke --result weather --param location "London"
