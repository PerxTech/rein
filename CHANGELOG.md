# Changelog

## 3.1.0
- Add length constraint.

## 3.0.0

- Dropped MySQL support.
- Reversible migrations.
- Add `index` option to `add_foreign_key_constraint`.

## 2.1.0

- Add `if` option to inclusion constraints.
- Add `name` option to constraints.
- Add null constraint.
- Ensure presence constraint enforces not null.

## 2.0.0

- Add support for enumerated types.
- Add `if` option to numericality constraints.
- Add `if` option to presence constraints.
- Fix a bug in presence contraints.

## 1.1.0

- Update README.
- Code cleanups.
- Disable monkey patching in rspec.

## 1.0.0

- Fix `Mysql2Adapter` for Rails 3.2.
- Add `column` option to `add_primary_key`.
