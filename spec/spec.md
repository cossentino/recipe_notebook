# Specifications for the Sinatra Assessment

Specs:
- [x] Use Sinatra to build the app
    -- Controllers inherit from Sinatra::Base

- [x] Use ActiveRecord for storing information in a database
    -- Models inherit from ActiveRecord::Base

- [x] Include more than one model class (e.g. User, Post, Category)
    -- Current models include User, Recipe, Ingredient, Instruction, Meal, and two join tables Recipe-Ingredient and Recipe-Meal

- [x] Include at least one has_many relationship on your User model (e.g. User has_many Posts)
    -- User has many Recipes

- [x] Include at least one belongs_to relationship on another model (e.g. Post belongs_to User)
        e.g. Instruction belongs to a Recipe

- [x] Include user accounts with unique login attribute (username or email)
        -- App uses Bcrypt gem to create secure password; username attribute used to uniquely identify and log in each user

- [x] Ensure that the belongs_to resource has routes for Creating, Reading, Updating and Destroying
        -- Recipe controller has Get, Post, Patch, and Delete routes, with corresponding forms and/or views

- [x] Ensure that users can't modify content created by other users
        -- Session hash stores a user's User ID upon login -- recipe show/index pages can only be accessed by validating user input

- [x] Include user input validations
        -- Certain fields are mandatory when creating a new recipe. If a user does not fill out a mandatory field, they are returned to the form with a message asking them to fill in the mandatory fields.

- [x] BONUS - not required - Display validation failures to user with error message (example form URL e.g. /posts/new)
        -- Certain fields are mandatory when creating a new recipe. If a user does not fill out a mandatory field, they are returned to the form with a message asking them to fill in the mandatory fields.

- [ ] Your README.md includes a short description, install instructions, a contributors guide and a link to the license for your code

Confirm
- [x] You have a large number of small Git commits
- [x] Your commit messages are meaningful
- [x] You made the changes in a commit that relate to the commit message
- [x] You don't include changes in a commit that aren't related to the commit message
