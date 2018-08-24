### v0.1.8

- Support Rails 5.1 (or later) migration file

### v0.1.7

- fix gemspec

### v0.1.6

- Add `after_create_maillog` to get maillog model for delivery.

### v0.1.5

- Supprt mail gem >= 2.5.5, >= 2.6.6.

### v0.1.4

- Support Rails 5.

### v0.1.3

- Add `Maillog::Mail#notify_error` method that called when exception raised while deliverying.

### v0.1.2

- Add `Maillog::Mail#wait` method to wait before actual delivery.
- Add `processing` state that indicates waiting and deliverying.

### v0.1.1

- Save BCC. Please create migration that contains `add_column :maillogs, :bcc, :string` to existed table.

### v0.1.0

- Initial release.
