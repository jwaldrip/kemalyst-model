# kemalyst-model

[![Build Status](https://travis-ci.org/drujensen/kemalyst-model.svg)](https://travis-ci.org/drujensen/kemalyst-model)

[![docrystal.org](http://www.docrystal.org/badge.svg)](http://www.docrystal.org/github.com/drujensen/kemalyst-model)

[Kemalyst](https://github.com/drujensen/kemalyst) is a web framework written in
the [Crystal](https://github.com/manastech/crystal) language. 

This project is to provide an ORM Model for Kemalyst.

## Installation

Add this library to your projects dependencies along with the driver in
your `shard.yml`.  This can be used with any framework but was originally
designed to work with kemalyst in mind.  This library will work with kemal as
well.

```yaml
dependencies:
  # Kemalyst Model
  kemalyst-model:
    github: drujensen/kemalyst-model
    branch: master

  # Pick your database
  sqlite3:
    github: manastech/crystal-sqlite3
    branch: master
  mysql:
    github: waterlink/crystal-mysql
    branch: master
  pg:
    github: will/crystal-pg
    branch: master

  #...
```

Next you will need to create a `config/database.yml`
You can leverage environment variables using ${} syntax.

```yaml
mysql:
  database: blog_test
  host: 127.0.0.1
  port: 3306
  username: blog
  password: ${DB_PASSWORD}
pg:
  database: "${DATABASE_URL}"
sqlite:
  database: config/blog_test.db
```

## Usage

Here is an example using Kemalyst Model

```crystal
require "kemalyst-model/adapter/mysql"

class Post < Kemalyst::Model
  adapter mysql
  
  sql_mapping({ 
    name: ["VARCHAR(255)", String],
    body: ["TEXT", String]
  })

end
```

```crystal
require "kemalyst-model/adapter/sqlite"

class Comment < Kemalyst::Model
  adapter sqlite

  # table name is set to post_comments and timestamps are disabled.
  sql_mapping({ 
    name: ["VARCHAR(255)", String], 
    body: ["TEXT", String]
  }, "post_comments", false)

end
```
### Fields

To define the fields for this model, you need to provide a hash with the name
of the field as a `Symbol` and an array of the datbase type as a `String` and
the type.  This can include any other options that the database provides to you.

3 Fields are automatically created for you:  id, created_at, updated_at.

MySQL field definitions for id, created_at, updated_at

```mysql
  id INT NOT NULL AUTO_INCREMENT
  # Your fields go here
  created_at DATE
  updated_at DATE 
  PRIMARY KEY (id)
```

### DDL Built in

```crystal
Post.drop #drop the table

Post.create #create the table

Post.clear #truncate the table

Post.migrate #safe migration of fields. Fields will be renamed to `old_\*`
before migrated.

Post.prune #clean up any fields not defined in model.  DANGER!!!!
```

### DML

#### Find All

```crystal
posts = Post.all
if posts
  posts.each do |post|
    puts post.name
  end
end
```

#### Find One

```crystal
post = Post.find 1
if post
  puts post.name
end
```

#### Insert

```crystal
post = Post.new
post.name = "Kemalyst Rocks!"
post.body = "Check this out."
post.save
```

#### Update

```crystal
post = Post.find 1
post.name = "Kemalyst Really Rocks!"
post.save
```

#### Delete

```crystal
post = Post.find 1
post.destroy
puts "deleted" unless post
```

### Where 

The where clause will give you full control over your query. 

When using the `all` method, the SQL selected fields will always match the
fields specified in the model.  If you need different fields, consider
creating a new model.

Always pass in parameters to avoid SQL Injection.  Use a symbol in your query
i.e. `:param` for parameter replacement.  Check out
[waterlink/crystal-mysql](https://github.com/waterlink/crystal-mysql) for more
details.

```crystal
posts = Post.all("WHERE name LIKE :name", {"name" => "Joe%"})
if posts
  posts.each do |post|
    puts post.name
  end
end

# ORDER BY Example
posts = Post.all("ORDER BY created_at DESC")

# JOIN Example
posts = Post.all("JOIN comments c ON c.post_id = post.id 
                  WHERE c.name = :name 
                  ORDER BY post.created_at DESC", 
                  {"name" => "Joe"})

```
## RoadMap
- Expose Transactions

## Contributing

1. Fork it ( https://github.com/drujensen/kemalyst-model/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [drujensen](https://github.com/drujensen) drujensen - creator, maintainer
