
# Install Go language server
go install golang.org/x/tools/gopls@latest

# Install JavaScript/TypeScript language server
npm install -g typescript typescript-language-server

# Install Python language server
pip install 'python-lsp-server[all]'

# Install CSS language server
npm install -g vscode-langservers-extracted

# Install HTML language server
npm install -g vscode-langservers-extracted

# Install Angular language server
npm install -g @angular/language-server

# Required in the Angular project
npm install --save-dev @angular/language-service

# Install Erlang language server
git clone https://github.com/erlang-ls/erlang_ls.git
cd erlang_ls
make
# Make sure erlang_ls is in your PATH
