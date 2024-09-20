# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## v0.2.0
### Changed
- Re-raise exceptions by default during delivering. If you prefer the previous behavior, define an empty `notify_error` method in a subclass of `Maillog::Mail`.

## v0.1.9
### Fixed
- Support mail gem >= 2.8.0.

## v0.1.8
### Fixed
- Support Rails 5.1 (or later) migration file

## v0.1.7
### Fixed
- fix gemspec

## v0.1.6
### Added
- Add `after_create_maillog` to get maillog model for delivery.

## v0.1.5
### Fixed
- Supprt mail gem >= 2.5.5, >= 2.6.6.

## v0.1.4
### Fixed
- Support Rails 5.

## v0.1.3
### Added
- Add `Maillog::Mail#notify_error` method that called when exception raised while deliverying.

## v0.1.2
### Added
- Add `Maillog::Mail#wait` method to wait before actual delivery.
- Add `processing` state that indicates waiting and deliverying.

## v0.1.1
### Changed
- Save BCC. Please create migration that contains `add_column :maillogs, :bcc, :string` to existed table.

## v0.1.0
### Added
- Initial release.
