vagrant-guest-msys2
==============

A plugin for Windows guests running sshd from [MSYS2](https://sourceforge.net/p/msys2/wiki/Home/).

Implemented capabilities:
 * `halt` with `shutdown -a` and `shutdown -s -t 1 -c "Vagrant Halt" -f -d p:4:1`
   * This is needed to avoid path automagical argument conversion (e.g. `/s` would by default be converted to `c:\msys32\s` )
   * See 
     * http://www.mingw.org/wiki/Posix_path_conversion
     * https://sourceforge.net/p/msys2/wiki/Porting/#filesystem-namespaces
     * https://github.com/Alexpux/MSYS2-packages/issues/84

 * `insert_public_key` and `remove_public_key` are inherited from `linux` guest and should be correct
 * `rsync` is unfortunately not yet ready as MSYS2 rsync does not support compression and parameter "-z" is hard-coded in Vagrant code

### Usage

 * Build
   * `gem build vagrant-guest-msys2.gemspec`
 * Install locally
   * `vagrant plugin install vagrant-guest-msys2-*.gem`
 * Publish
   * `gem push vagrant-guest-msys2-*.gem`
