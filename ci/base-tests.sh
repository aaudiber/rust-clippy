set -ex
cargo install rustup-toolchain-install-master || echo "rustup-toolchain-install-master already installed"
RUSTC_HEAD=`git ls-remote https://github.com/rust-lang/rust.git HEAD | tr -d ",." | tr " \t" "\n" | grep -e "HEAD" -v`
rustup-toolchain-install-master $RUSTC_HEAD
rustup default $RUSTC_HEAD
PATH=$PATH:./node_modules/.bin
remark -f *.md > /dev/null
cargo build --features debugging
cargo test --features debugging
mkdir -p ~/rust/cargo/bin
cp target/debug/cargo-clippy ~/rust/cargo/bin/cargo-clippy
cp target/debug/clippy-driver ~/rust/cargo/bin/clippy-driver
rm ~/.cargo/bin/cargo-clippy
PATH=$PATH:~/rust/cargo/bin cargo clippy --all -- -D clippy
cd clippy_workspace_tests && PATH=$PATH:~/rust/cargo/bin cargo clippy -- -D clippy && cd ..
cd clippy_workspace_tests/src && PATH=$PATH:~/rust/cargo/bin cargo clippy -- -D clippy && cd ../..
cd clippy_workspace_tests/subcrate && PATH=$PATH:~/rust/cargo/bin cargo clippy -- -D clippy && cd ../..
cd clippy_workspace_tests/subcrate/src && PATH=$PATH:~/rust/cargo/bin cargo clippy -- -D clippy && cd ../../..
PATH=$PATH:~/rust/cargo/bin cargo clippy --manifest-path=clippy_workspace_tests/Cargo.toml -- -D clippy
cd clippy_workspace_tests/subcrate && PATH=$PATH:~/rust/cargo/bin cargo clippy --manifest-path=../Cargo.toml -- -D clippy && cd ../..
set +x
