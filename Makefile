build:
	docker build -t gleber:dotfiles .

test:
	docker run --rm -t -i gleber:dotfiles /bin/bash -c "set -x &&             \
		git clone https://github.com/gleber/dotfiles.git ~/dotfiles &&          \
		cd ~/dotfiles &&                                                        \
		sed -i 's#git@github.com:#https://github.com/#g' myrepos/.mrconfig &&   \
		./tests/replace-private.sh &&                                           \
		./install.sh &&                                                         \
		. $$HOME/.nix-profile/etc/profile.d/nix.sh &&                           \
		./uninstall.sh"
