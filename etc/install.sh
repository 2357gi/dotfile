#!bin/bash

set -eu

SPACER="================================================="



cat << END
${SPACER}
DOTFILES SETUP START!
${SPACER}
END

cd $HOME

echo 'clone 2357gi/dotfiles?'
read ANSWER
case $ANSWER in
	"" | "Y" | "y" )
		git clone --depth-1 https://github.com/2357gi/dotfiles.git $HOME/dotfiles
		DOTFILES_PATH=$HOME/dotfiles ;;
	* ) echo "skip" ;;
esac

DOTFILES_PATH=$HOME/dotfiles

echo '********* generate a new SSH key?[Y/n]'
read ANSWER
case $ANSWER in
	"" | "Y" | "y" )
		ssh-keygen -t rsa -b 4096 ;;
	* ) echo 'skip' ;;
esac


echo '********* install homebrew?[Y/n]'
read ANSWER
case $ANSWER in
	"" | "Y" | "y" )
		which brew >/dev/null 2>&1 || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" ;;
	* ) echo "skip" ;;
esac


echo "${SPACER}"
echo "make links"
echo "${SPACER}"
cd $DOTFILES_PATH
for f in .??*; do
	[[ "$f" = ".tmux" ]] && continue
	[[ "$f" = ".git" ]] && continue
	[[ "$f" = ".gitconfig.local.template" ]] && continue
	[[ "$f" = ".gitignore" ]] && continue
	[[ "$f" = ".commit_template" ]] && continue

	ln -snfv ~/dotfiles/"$f" ~/
done

echo "${SPACER}"
echo "brew install"
echo "${SPACER}"
brew bundle --global


echo "${SPACER}"
echo "linked dotfiles/bin"
echo "${SPACER}"
ln -snfv ~/dotfiles/bin $HOME/bin

if [[ -e ~/.gitconfig.local ]];then
   cp -f ~/dotfiles/.gitconfig.local.template ~/.gitconfig
fi


eval git config --global commit.template .commit_template
eval git config --global core.excludesfile ~/.gitignore_global


echo "${SPACER}"
echo "install docker"
echo "${SPACER}"
mkdir -p ~/.zsh/completions
ln -s /Applications/Docker.app/Contents/Resources/etc/docker.zsh-completion ~/.zsh/completions/_docker
ln -s /Applications/Docker.app/Contents/Resources/etc/docker-compose.zsh-completion ~/.zsh/completions/_docker-compose

cat << END

${SPACER}
DOTFILES SETUP FINISHED! bye.
${SPACER}

END
