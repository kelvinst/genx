# Genx

Genx is a template project with everything configured so that one can just
copy the whole folder structure, change `template` to the project name on file
names and contents and call it a startup for a brand new project.

## Using

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Contributing

If you want to contribute to this repo, the process is simple:

1. Go to master branch with `git checkout master`
2. Update it with `git pull`
3. Create a new branch for your feature with `git checkout -b <your-branch>`
4. Do you changes, keeping the change set small for each commit
5. Run the tasks that update the code (like the formatter) with `mix code.update`
6. Check your code with `mix code.check`. If this one fails and you have to fix 
the code, go back to step 4
7. Stage and commit your changes with `git add . & git commit`
8. Push the changes to origin with `git push -u origin <your-branch>`
9. Repeat steps 4 to 9 until it's done
10. Open a pull request

There is also a useful `pre-commit` git hook that runs `mix code.check` before a 
commit. If it fails it will block the commit. To install it just:

```shell
cp .git_hooks/pre-commit .git/hooks/
chmod +x .git/hooks/pre-commit
```
