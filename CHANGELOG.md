### v0.1.3

- Add `Maillog::Mail#notify_error` method that called when exception raised while deliverying.

### v0.1.2

- Add `Maillog::Mail#wait` method to wait before actual delivery.
- Add `processing` state that indicates waiting and deliverying.

### v0.1.1

- Save BCC. Please create migration that contains `add_column :maillogs, :bcc, :string` to existed table.

### v0.1.0

- Initial release.
