From: =?UTF-8?B?QXJ0xatyYXMgxaBsYWp1cw==?= <x11@kitas.arturas.net>
Subject: Re: POM raw patch for 2.4.30
Date: Thu, 21 Apr 2005 20:21:09 +0300
Message-ID: <4267E105.7040304@kitas.arturas.net>
References: <4267B6FE.7000400@kitas.arturas.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4267B6FE.7000400@kitas.arturas.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Artūras Šlajus wrote:
> Hello,
> 
> Just including 'raw' patch for Linux 2.4.30. This works for me (original 
> did not..).

Hmm. I'm expierencing same errors as this guy:
https://lists.netfilter.org/pipermail/netfilter-devel/2003-November/013193.html

20:17 gw:/var/log# strace iptables -I FORWARD -d 192.168.0.3
execve("/sbin/iptables", ["iptables", "-I", "FORWARD", "-d", 
"192.168.0.3"], [/* 17 vars */]) = 0
uname({sys="Linux", node="gw.lan", ...}) = 0
brk(0)                                  = 0x8054834
old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x40017000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or 
directory)
open("/etc/ld.so.preload", O_RDONLY)    = -1 ENOENT (No such file or 
directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=11699, ...}) = 0
old_mmap(NULL, 11699, PROT_READ, MAP_PRIVATE, 3, 0) = 0x40018000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or 
directory)
open("/lib/libdl.so.2", O_RDONLY)       = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0p\34\0\000"..., 
512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=9872, ...}) = 0
old_mmap(NULL, 8632, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) = 0x4001b000
old_mmap(0x4001d000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 
3, 0x2000) = 0x4001d000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or 
directory)
open("/lib/libnsl.so.1", O_RDONLY)      = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0000<\0\000"..., 
512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=73528, ...}) = 0
old_mmap(NULL, 84864, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) = 0x4001e000
old_mmap(0x40030000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 
3, 0x11000) = 0x40030000
old_mmap(0x40031000, 7040, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x40031000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or 
directory)
open("/lib/libc.so.6", O_RDONLY)        = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\200^\1"..., 
512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=1244016, ...}) = 0
old_mmap(NULL, 1254180, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) = 0x40033000
old_mmap(0x4015b000, 32768, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 
3, 0x127000) = 0x4015b000
old_mmap(0x40163000, 8996, PROT_READ|PROT_WRITE, 
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x40163000
close(3)                                = 0
old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, 
-1, 0) = 0x40166000
munmap(0x40018000, 11699)               = 0
brk(0)                                  = 0x8054834
brk(0x8075834)                          = 0x8075834
brk(0)                                  = 0x8075834
brk(0x8076000)                          = 0x8076000
socket(PF_INET, SOCK_RAW, IPPROTO_RAW)  = 3
getsockopt(3, SOL_IP, 0x40 /* IP_??? */, 
"filter\0@p\373\377\277\26\272\0@\324o\1@h\177\1@\1\0\0"..., [84]) = 0
getsockopt(3, SOL_IP, 0x41 /* IP_??? */, 
"filter\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., [28112]) = 0
open("/lib/iptables/libipt_standard.so", O_RDONLY) = 4
read(4, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\220\3\0"..., 
512) = 512
fstat64(4, {st_mode=S_IFREG|0644, st_size=2136, ...}) = 0
old_mmap(NULL, 5596, PROT_READ|PROT_EXEC, MAP_PRIVATE, 4, 0) = 0x40018000
old_mmap(0x40019000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 
4, 0) = 0x40019000
close(4)                                = 0
setsockopt(3, SOL_IP, 0x40 /* IP_??? */, 
"filter\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 28324) = -1 
ELOOP (Too many levels of symbolic links)
write(2, "iptables: Too many levels of sym"..., 44iptables: Too many 
levels of symbolic links
) = 44
exit_group(1)                           = ?

But:
20:19 gw:/var/log# iptables -I FORWARD -d 192.168.0.3 -j ACCEPT
20:21 gw:/var/log#

and in my kern.log i've got:
Apr 21 20:16:01 gw kernel: ip_tables: table screwed up!
Apr 21 20:17:20 gw kernel: ip_tables: table screwed up!

Could anyone look up what's causing this?
