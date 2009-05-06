From: Manu <manuprivat@gmx.de>
Subject: Re: iptables
Date: Wed, 06 May 2009 09:53:06 +0200
Message-ID: <4A0141E2.4080206@gmx.de>
References: <49F56742.7080309@gmx.de> <alpine.LSU.2.00.0904292232050.9772@fbirervta.pbzchgretzou.qr> <4A004140.30805@trash.net> <alpine.LSU.2.00.0905052125240.22475@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020104010403010004020302"
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60677 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752676AbZEFHxa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 May 2009 03:53:30 -0400
In-Reply-To: <alpine.LSU.2.00.0905052125240.22475@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020104010403010004020302
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Jan Engelhardt schrieb:
> On Tuesday 2009-05-05 15:38, Patrick McHardy wrote:
>   
>> Jan Engelhardt wrote:
>>     
>>> On Monday 2009-04-27 10:05, Manu wrote:
>>>       
>>>> #iptables -nvL -t mangle
>>>>
>>>> Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
>>>> pkts bytes target     prot opt in     out     source
>>>> destination
>>>> insmod: ip_tables.ko: no module by that name found
>>>> modprobe: failed to load module ip_tables
>>>>  0     0 MARK       all  --  *      *       10.0.20.2            0.0.0.0/0
>>>> MARK set 0x14
>>>>
>>>> My kernel is built with every point of iptables stuff included, not as
>>>> module.
>>>>         
>>> I cannot reproduce this :/
>>>       
>> Well, the message obviously originates from modprobe. So it seems
>> to ignore the "-q" option set by iptables.
>>     
>
> Now that you mention that, perhaps it's an incomplete modprobe
> copy in busybox?
>
>   
many thanks for your response.
I think the problem could be the module-init-tools of busybox 1.00 - it 
is really an old version.
I will upgrade to a newer one.


--------------020104010403010004020302
Content-Type: text/plain;
 name="strace_iptables"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="strace_iptables"

execve("/usr/bin/iptables", ["iptables", "-nvL", "-t", "mangle"], [/* 14 vars */]) = 0
uname({sys="Linux", node="kchtn", ...}) = 0
brk(0)                                  = 0x8051000
open("/etc/ld.so.preload", O_RDONLY)    = -1 ENOENT (No such file or directory)
open("/lib/i686/mmx/libiptc.so.0", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/i686/mmx", 0xbfa06c90)     = -1 ENOENT (No such file or directory)
open("/lib/i686/libiptc.so.0", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/i686", 0xbfa06c90)         = -1 ENOENT (No such file or directory)
open("/lib/mmx/libiptc.so.0", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/lib/mmx", 0xbfa06c90)          = -1 ENOENT (No such file or directory)
open("/lib/libiptc.so.0", O_RDONLY)     = -1 ENOENT (No such file or directory)
stat64("/lib", {st_mode=S_IFDIR|0755, st_size=220, ...}) = 0
open("/usr/lib/i686/mmx/libiptc.so.0", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/i686/mmx", 0xbfa06c90) = -1 ENOENT (No such file or directory)
open("/usr/lib/i686/libiptc.so.0", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/i686", 0xbfa06c90)     = -1 ENOENT (No such file or directory)
open("/usr/lib/mmx/libiptc.so.0", O_RDONLY) = -1 ENOENT (No such file or directory)
stat64("/usr/lib/mmx", 0xbfa06c90)      = -1 ENOENT (No such file or directory)
open("/usr/lib/libiptc.so.0", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0@\31\0\000"..., 1024) = 1024
fstat64(3, {st_mode=S_IFREG|0755, st_size=136574, ...}) = 0
old_mmap(NULL, 43048, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) = 0xb7faa000
mprotect(0xb7fb4000, 2088, PROT_NONE)   = 0
old_mmap(0xb7fb4000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 3, 0x9000) = 0xb7fb4000
close(3)                                = 0
open("/lib/libxtables.so.2", O_RDONLY)  = -1 ENOENT (No such file or directory)
open("/usr/lib/libxtables.so.2", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0`\34\0\000"..., 1024) = 1024
fstat64(3, {st_mode=S_IFREG|0755, st_size=81681, ...}) = 0
old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7fa9000
old_mmap(NULL, 22620, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) = 0xb7fa3000
mprotect(0xb7fa8000, 2140, PROT_NONE)   = 0
old_mmap(0xb7fa8000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 3, 0x5000) = 0xb7fa8000
close(3)                                = 0
open("/lib/libm.so.6", O_RDONLY)        = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\3605\0"..., 1024) = 1024
fstat64(3, {st_mode=S_IFREG|0755, st_size=184056, ...}) = 0
old_mmap(NULL, 138416, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) = 0xb7f81000
mprotect(0xb7fa2000, 3248, PROT_NONE)   = 0
old_mmap(0xb7fa2000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 3, 0x20000) = 0xb7fa2000
close(3)                                = 0
open("/lib/libc.so.6", O_RDONLY)        = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0pY\1\000"..., 1024) = 1024
fstat64(3, {st_mode=S_IFREG|0755, st_size=1491599, ...}) = 0
old_mmap(NULL, 1268004, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) = 0xb7e4b000
mprotect(0xb7f7a000, 26916, PROT_NONE)  = 0
old_mmap(0xb7f7a000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 3, 0x12f000) = 0xb7f7a000
old_mmap(0xb7f7e000, 10532, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7f7e000
close(3)                                = 0
open("/lib/libdl.so.2", O_RDONLY)       = -1 ENOENT (No such file or directory)
open("/usr/lib/libdl.so.2", O_RDONLY)   = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\260\31"..., 1024) = 1024
fstat64(3, {st_mode=S_IFREG|0755, st_size=12392, ...}) = 0
old_mmap(NULL, 11588, PROT_READ|PROT_EXEC, MAP_PRIVATE, 3, 0) = 0xb7e48000
mprotect(0xb7e4a000, 3396, PROT_NONE)   = 0
old_mmap(0xb7e4a000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 3, 0x1000) = 0xb7e4a000
close(3)                                = 0
socket(PF_INET, SOCK_RAW, IPPROTO_RAW)  = 3
getsockopt(3, SOL_IP, 0x40 /* IP_??? */, "mangle\0\0\0\0\0\0D~\231\331\377\n\21\300\0\0\0\0\210\327"..., [84]) = 0
brk(0)                                  = 0x8051000
brk(0x8052000)                          = 0x8052000
brk(0)                                  = 0x8052000
brk(0)                                  = 0x8052000
brk(0x8053000)                          = 0x8053000
getsockopt(3, SOL_IP, 0x41 /* IP_??? */, "mangle\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., [3992]) = 0
brk(0)                                  = 0x8053000
brk(0x8054000)                          = 0x8054000
fstat64(1, {st_mode=S_IFREG|0644, st_size=4634, ...}) = 0
old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7e47000
open("/usr/lib/iptables/libxt_MARK.so", O_RDONLY) = 4
read(4, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\300\10"..., 1024) = 1024
fstat64(4, {st_mode=S_IFREG|0755, st_size=32646, ...}) = 0
old_mmap(NULL, 10880, PROT_READ|PROT_EXEC, MAP_PRIVATE, 4, 0) = 0xb7e44000
mprotect(0xb7e46000, 2688, PROT_NONE)   = 0
old_mmap(0xb7e46000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 4, 0x1000) = 0xb7e46000
close(4)                                = 0
socket(PF_INET, SOCK_RAW, IPPROTO_RAW)  = 4
open("/proc/sys/kernel/modprobe", O_RDONLY|O_LARGEFILE) = 5
read(5, "/sbin/modprobe\n", 1024)       = 15
close(5)                                = 0
write(1, "Chain PREROUTING (policy ACCEPT "..., 439Chain PREROUTING (policy ACCEPT 30566 packets, 3141K bytes)
 pkts bytes target     prot opt in     out     source               destination         

Chain INPUT (policy ACCEPT 27853 packets, 2924K bytes)
 pkts bytes target     prot opt in     out     source               destination         

Chain FORWARD (policy ACCEPT 1931 packets, 147K bytes)
 pkts bytes target     prot opt in     out     source               destination         
) = 439
fork()                                  = 18449
[pid 18448] wait4(-1,  <unfinished ...>
[pid 18449] execve("/sbin/modprobe", ["/sbin/modprobe", "ip_tables", "-q"], [/* 14 vars */]) = 0
[pid 18449] uname({sys="Linux", node="kchtn", ...}) = 0
[pid 18449] brk(0)                      = 0x817b000
[pid 18449] open("/etc/ld.so.preload", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18449] open("/lib/i686/mmx/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18449] stat64("/lib/i686/mmx", 0xbfe6e910) = -1 ENOENT (No such file or directory)
[pid 18449] open("/lib/i686/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18449] stat64("/lib/i686", 0xbfe6e910) = -1 ENOENT (No such file or directory)
[pid 18449] open("/lib/mmx/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18449] stat64("/lib/mmx", 0xbfe6e910) = -1 ENOENT (No such file or directory)
[pid 18449] open("/lib/libm.so.6", O_RDONLY) = 5
[pid 18449] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\3605\0"..., 1024) = 1024
[pid 18449] fstat64(5, {st_mode=S_IFREG|0755, st_size=184056, ...}) = 0
[pid 18449] old_mmap(NULL, 138416, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7ecb000
[pid 18449] mprotect(0xb7eec000, 3248, PROT_NONE) = 0
[pid 18449] old_mmap(0xb7eec000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x20000) = 0xb7eec000
[pid 18449] close(5)                    = 0
[pid 18449] open("/lib/libcrypt.so.1", O_RDONLY) = 5
[pid 18449] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\220\n\0"..., 1024) = 1024
[pid 18449] fstat64(5, {st_mode=S_IFREG|0755, st_size=43933, ...}) = 0
[pid 18449] old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7eca000
[pid 18449] old_mmap(NULL, 197728, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7e99000
[pid 18449] mprotect(0xb7ea1000, 164960, PROT_NONE) = 0
[pid 18449] old_mmap(0xb7ea1000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x8000) = 0xb7ea1000
[pid 18449] old_mmap(0xb7ea3000, 156768, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7ea3000
[pid 18449] close(5)                    = 0
[pid 18449] open("/lib/libc.so.6", O_RDONLY) = 5
[pid 18449] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0pY\1\000"..., 1024) = 1024
[pid 18449] fstat64(5, {st_mode=S_IFREG|0755, st_size=1491599, ...}) = 0
[pid 18449] old_mmap(NULL, 1268004, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7d63000
[pid 18449] mprotect(0xb7e92000, 26916, PROT_NONE) = 0
[pid 18449] old_mmap(0xb7e92000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x12f000) = 0xb7e92000
[pid 18449] old_mmap(0xb7e96000, 10532, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7e96000
[pid 18449] close(5)                    = 0
[pid 18449] uname({sys="Linux", node="kchtn", ...}) = 0
[pid 18449] open("/lib/modules/2.6.23.9-default/modules.dep", O_RDONLY) = 5
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 256
[pid 18449] lseek(5, 62, SEEK_SET)      = 62
[pid 18449] brk(0)                      = 0x817b000
[pid 18449] brk(0x817c000)              = 0x817c000
[pid 18449] brk(0)                      = 0x817c000
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 318
[pid 18449] lseek(5, 126, SEEK_SET)     = 126
[pid 18449] read(5, "\n/lib/modules/2.6.23.9-default/k"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 382
[pid 18449] lseek(5, 127, SEEK_SET)     = 127
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 383
[pid 18449] lseek(5, 192, SEEK_SET)     = 192
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 448
[pid 18449] lseek(5, 251, SEEK_SET)     = 251
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 507
[pid 18449] lseek(5, 313, SEEK_SET)     = 313
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 569
[pid 18449] lseek(5, 371, SEEK_SET)     = 371
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 627
[pid 18449] lseek(5, 493, SEEK_SET)     = 493
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 749
[pid 18449] lseek(5, 558, SEEK_SET)     = 558
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 814
[pid 18449] lseek(5, 621, SEEK_SET)     = 621
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 877
[pid 18449] lseek(5, 686, SEEK_SET)     = 686
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 942
[pid 18449] lseek(5, 743, SEEK_SET)     = 743
[pid 18449] read(5, "\n/lib/modules/2.6.23.9-default/k"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 999
[pid 18449] lseek(5, 744, SEEK_SET)     = 744
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 1000
[pid 18449] lseek(5, 801, SEEK_SET)     = 801
[pid 18449] read(5, "\n/lib/modules/2.6.23.9-default/k"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 1057
[pid 18449] lseek(5, 802, SEEK_SET)     = 802
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 1058
[pid 18449] lseek(5, 861, SEEK_SET)     = 861
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 1117
[pid 18449] lseek(5, 933, SEEK_SET)     = 933
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 1189
[pid 18449] lseek(5, 1005, SEEK_SET)    = 1005
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 1261
[pid 18449] lseek(5, 1075, SEEK_SET)    = 1075
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 1331
[pid 18449] lseek(5, 1150, SEEK_SET)    = 1150
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 1406
[pid 18449] lseek(5, 1221, SEEK_SET)    = 1221
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 1477
[pid 18449] lseek(5, 1290, SEEK_SET)    = 1290
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 1546
[pid 18449] lseek(5, 1364, SEEK_SET)    = 1364
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 1620
[pid 18449] lseek(5, 1438, SEEK_SET)    = 1438
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 1694
[pid 18449] lseek(5, 1510, SEEK_SET)    = 1510
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 1766
[pid 18449] lseek(5, 1580, SEEK_SET)    = 1580
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 1836
[pid 18449] lseek(5, 1651, SEEK_SET)    = 1651
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 1907
[pid 18449] lseek(5, 1724, SEEK_SET)    = 1724
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 1980
[pid 18449] lseek(5, 1798, SEEK_SET)    = 1798
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 2054
[pid 18449] lseek(5, 1873, SEEK_SET)    = 1873
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 2129
[pid 18449] lseek(5, 1944, SEEK_SET)    = 1944
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 2200
[pid 18449] lseek(5, 2014, SEEK_SET)    = 2014
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 2270
[pid 18449] lseek(5, 2085, SEEK_SET)    = 2085
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 2341
[pid 18449] lseek(5, 2162, SEEK_SET)    = 2162
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 2418
[pid 18449] lseek(5, 2239, SEEK_SET)    = 2239
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 2495
[pid 18449] lseek(5, 2313, SEEK_SET)    = 2313
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 2569
[pid 18449] lseek(5, 2384, SEEK_SET)    = 2384
[pid 18449] read(5, "\n/lib/modules/2.6.23.9-default/k"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 2640
[pid 18449] lseek(5, 2385, SEEK_SET)    = 2385
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 2641
[pid 18449] lseek(5, 2457, SEEK_SET)    = 2457
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 2713
[pid 18449] lseek(5, 2604, SEEK_SET)    = 2604
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 2860
[pid 18449] lseek(5, 2751, SEEK_SET)    = 2751
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 3007
[pid 18449] lseek(5, 2829, SEEK_SET)    = 2829
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 3085
[pid 18449] lseek(5, 2907, SEEK_SET)    = 2907
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 3163
[pid 18449] lseek(5, 2984, SEEK_SET)    = 2984
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 3240
[pid 18449] lseek(5, 3061, SEEK_SET)    = 3061
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 3317
[pid 18449] lseek(5, 3132, SEEK_SET)    = 3132
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 3388
[pid 18449] lseek(5, 3203, SEEK_SET)    = 3203
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 3459
[pid 18449] lseek(5, 3278, SEEK_SET)    = 3278
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 3534
[pid 18449] lseek(5, 3336, SEEK_SET)    = 3336
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 3592
[pid 18449] lseek(5, 3397, SEEK_SET)    = 3397
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 3653
[pid 18449] lseek(5, 3460, SEEK_SET)    = 3460
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 3716
[pid 18449] lseek(5, 3519, SEEK_SET)    = 3519
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 3775
[pid 18449] lseek(5, 3578, SEEK_SET)    = 3578
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 3834
[pid 18449] lseek(5, 3637, SEEK_SET)    = 3637
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 3893
[pid 18449] lseek(5, 3699, SEEK_SET)    = 3699
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 3955
[pid 18449] lseek(5, 3759, SEEK_SET)    = 3759
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 4015
[pid 18449] lseek(5, 3819, SEEK_SET)    = 3819
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 4075
[pid 18449] lseek(5, 3878, SEEK_SET)    = 3878
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 4134
[pid 18449] lseek(5, 3941, SEEK_SET)    = 3941
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 4197
[pid 18449] lseek(5, 4001, SEEK_SET)    = 4001
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 4257
[pid 18449] lseek(5, 4060, SEEK_SET)    = 4060
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 4316
[pid 18449] lseek(5, 4119, SEEK_SET)    = 4119
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 4375
[pid 18449] lseek(5, 4178, SEEK_SET)    = 4178
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 4434
[pid 18449] lseek(5, 4238, SEEK_SET)    = 4238
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 4494
[pid 18449] lseek(5, 4295, SEEK_SET)    = 4295
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 4551
[pid 18449] lseek(5, 4348, SEEK_SET)    = 4348
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 4604
[pid 18449] lseek(5, 4419, SEEK_SET)    = 4419
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 4675
[pid 18449] lseek(5, 4490, SEEK_SET)    = 4490
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 222
[pid 18449] lseek(5, 0, SEEK_CUR)       = 4712
[pid 18449] lseek(5, 4548, SEEK_SET)    = 4548
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 164
[pid 18449] lseek(5, 0, SEEK_CUR)       = 4712
[pid 18449] lseek(5, 4604, SEEK_SET)    = 4604
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 108
[pid 18449] lseek(5, 0, SEEK_CUR)       = 4712
[pid 18449] lseek(5, 4660, SEEK_SET)    = 4660
[pid 18449] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 52
[pid 18449] lseek(5, 0, SEEK_CUR)       = 4712
[pid 18449] lseek(5, 4712, SEEK_SET)    = 4712
[pid 18449] read(5, "", 256)            = 0
[pid 18449] close(5)                    = 0
[pid 18449] open("/etc/modules.conf", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18449] open("/etc/conf.modules", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18449] open("/proc/modules", O_RDONLY) = 5
[pid 18449] read(5, "ebt_ip 2208 2 - Live 0xdc86b000\n"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 256
[pid 18449] lseek(5, 32, SEEK_SET)      = 32
[pid 18449] read(5, "ebtable_nat 2144 1 - Live 0xdc83"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 288
[pid 18449] lseek(5, 69, SEEK_SET)      = 69
[pid 18449] read(5, "ebtables 17088 2 ebt_ip,ebtable_"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 325
[pid 18449] lseek(5, 122, SEEK_SET)     = 122
[pid 18449] read(5, "sch_sfq 4928 40 - Live 0xdc85c00"..., 256) = 256
[pid 18449] lseek(5, 0, SEEK_CUR)       = 378
[pid 18449] lseek(5, 156, SEEK_SET)     = 156
[pid 18449] read(5, "cls_fw 3808 1 - Live 0xdc81c000\n"..., 256) = 227
[pid 18449] lseek(5, 0, SEEK_CUR)       = 383
[pid 18449] lseek(5, 188, SEEK_SET)     = 188
[pid 18449] read(5, "cls_u32 6244 1 - Live 0xdc84c000"..., 256) = 195
[pid 18449] lseek(5, 0, SEEK_CUR)       = 383
[pid 18449] lseek(5, 221, SEEK_SET)     = 221
[pid 18449] read(5, "sch_htb 13920 2 - Live 0xdc86200"..., 256) = 162
[pid 18449] lseek(5, 0, SEEK_CUR)       = 383
[pid 18449] lseek(5, 255, SEEK_SET)     = 255
[pid 18449] read(5, "tun 7872 0 - Live 0xdc849000\n802"..., 256) = 128
[pid 18449] lseek(5, 0, SEEK_CUR)       = 383
[pid 18449] lseek(5, 284, SEEK_SET)     = 284
[pid 18449] read(5, "8021q 17224 0 - Live 0xdc850000\n"..., 256) = 99
[pid 18449] lseek(5, 0, SEEK_CUR)       = 383
[pid 18449] lseek(5, 316, SEEK_SET)     = 316
[pid 18449] read(5, "8139too 22032 0 - Live 0xdc84200"..., 256) = 67
[pid 18449] lseek(5, 0, SEEK_CUR)       = 383
[pid 18449] lseek(5, 350, SEEK_SET)     = 350
[pid 18449] read(5, "cramfs 39796 6 - Live 0xdc820000"..., 256) = 33
[pid 18449] lseek(5, 0, SEEK_CUR)       = 383
[pid 18449] lseek(5, 383, SEEK_SET)     = 383
[pid 18449] read(5, "", 256)            = 0
[pid 18449] close(5)                    = 0
[pid 18449] rt_sigaction(SIGINT, {SIG_IGN}, {SIG_DFL}, 8) = 0
[pid 18449] rt_sigaction(SIGQUIT, {SIG_IGN}, {SIG_DFL}, 8) = 0
[pid 18449] rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
[pid 18449] fork()                      = 18453
[pid 18449] wait4(18453,  <unfinished ...>
[pid 18453] rt_sigaction(SIGINT, {SIG_DFL}, NULL, 8) = 0
[pid 18453] rt_sigaction(SIGQUIT, {SIG_DFL}, NULL, 8) = 0
[pid 18453] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 18453] execve("/bin/sh", ["sh", "-c", "insmod   -q ip_tables "], [/* 14 vars */]) = 0
[pid 18453] uname({sys="Linux", node="kchtn", ...}) = 0
[pid 18453] brk(0)                      = 0x817b000
[pid 18453] open("/etc/ld.so.preload", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18453] open("/lib/i686/mmx/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18453] stat64("/lib/i686/mmx", 0xbfc1aec0) = -1 ENOENT (No such file or directory)
[pid 18453] open("/lib/i686/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18453] stat64("/lib/i686", 0xbfc1aec0) = -1 ENOENT (No such file or directory)
[pid 18453] open("/lib/mmx/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18453] stat64("/lib/mmx", 0xbfc1aec0) = -1 ENOENT (No such file or directory)
[pid 18453] open("/lib/libm.so.6", O_RDONLY) = 5
[pid 18453] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\3605\0"..., 1024) = 1024
[pid 18453] fstat64(5, {st_mode=S_IFREG|0755, st_size=184056, ...}) = 0
[pid 18453] old_mmap(NULL, 138416, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7f46000
[pid 18453] mprotect(0xb7f67000, 3248, PROT_NONE) = 0
[pid 18453] old_mmap(0xb7f67000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x20000) = 0xb7f67000
[pid 18453] close(5)                    = 0
[pid 18453] open("/lib/libcrypt.so.1", O_RDONLY) = 5
[pid 18453] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\220\n\0"..., 1024) = 1024
[pid 18453] fstat64(5, {st_mode=S_IFREG|0755, st_size=43933, ...}) = 0
[pid 18453] old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f45000
[pid 18453] old_mmap(NULL, 197728, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7f14000
[pid 18453] mprotect(0xb7f1c000, 164960, PROT_NONE) = 0
[pid 18453] old_mmap(0xb7f1c000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x8000) = 0xb7f1c000
[pid 18453] old_mmap(0xb7f1e000, 156768, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7f1e000
[pid 18453] close(5)                    = 0
[pid 18453] open("/lib/libc.so.6", O_RDONLY) = 5
[pid 18453] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0pY\1\000"..., 1024) = 1024
[pid 18453] fstat64(5, {st_mode=S_IFREG|0755, st_size=1491599, ...}) = 0
[pid 18453] old_mmap(NULL, 1268004, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7dde000
[pid 18453] mprotect(0xb7f0d000, 26916, PROT_NONE) = 0
[pid 18453] old_mmap(0xb7f0d000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x12f000) = 0xb7f0d000
[pid 18453] old_mmap(0xb7f11000, 10532, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7f11000
[pid 18453] close(5)                    = 0
[pid 18453] getpid()                    = 18453
[pid 18453] rt_sigaction(SIGCHLD, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 18453] geteuid32()                 = 0
[pid 18453] brk(0)                      = 0x817b000
[pid 18453] brk(0x817c000)              = 0x817c000
[pid 18453] brk(0)                      = 0x817c000
[pid 18453] getppid()                   = 18449
[pid 18453] brk(0)                      = 0x817c000
[pid 18453] brk(0x817d000)              = 0x817d000
[pid 18453] getcwd("/root", 4096)       = 6
[pid 18453] rt_sigaction(SIGINT, NULL, {SIG_DFL}, 8) = 0
[pid 18453] rt_sigaction(SIGINT, {0x807ecd1, ~[], SA_RESTORER, 0xb7e075c8}, NULL, 8) = 0
[pid 18453] rt_sigaction(SIGQUIT, NULL, {SIG_DFL}, 8) = 0
[pid 18453] rt_sigaction(SIGQUIT, {SIG_DFL}, NULL, 8) = 0
[pid 18453] rt_sigaction(SIGTERM, NULL, {SIG_DFL}, 8) = 0
[pid 18453] rt_sigaction(SIGTERM, {SIG_DFL}, NULL, 8) = 0
[pid 18453] stat64("/bin/insmod", 0xbfc1b6b4) = -1 ENOENT (No such file or directory)
[pid 18453] stat64("/sbin/insmod", {st_mode=S_IFREG|0755, st_size=358124, ...}) = 0
[pid 18453] fork()                      = 18454
[pid 18453] wait4(-1,  <unfinished ...>
[pid 18454] execve("/sbin/insmod", ["insmod", "-q", "ip_tables"], [/* 14 vars */]) = 0
[pid 18454] uname({sys="Linux", node="kchtn", ...}) = 0
[pid 18454] brk(0)                      = 0x817b000
[pid 18454] open("/etc/ld.so.preload", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18454] open("/lib/i686/mmx/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18454] stat64("/lib/i686/mmx", 0xbfafbda0) = -1 ENOENT (No such file or directory)
[pid 18454] open("/lib/i686/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18454] stat64("/lib/i686", 0xbfafbda0) = -1 ENOENT (No such file or directory)
[pid 18454] open("/lib/mmx/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18454] stat64("/lib/mmx", 0xbfafbda0) = -1 ENOENT (No such file or directory)
[pid 18454] open("/lib/libm.so.6", O_RDONLY) = 5
[pid 18454] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\3605\0"..., 1024) = 1024
[pid 18454] fstat64(5, {st_mode=S_IFREG|0755, st_size=184056, ...}) = 0
[pid 18454] old_mmap(NULL, 138416, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7f01000
[pid 18454] mprotect(0xb7f22000, 3248, PROT_NONE) = 0
[pid 18454] old_mmap(0xb7f22000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x20000) = 0xb7f22000
[pid 18454] close(5)                    = 0
[pid 18454] open("/lib/libcrypt.so.1", O_RDONLY) = 5
[pid 18454] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\220\n\0"..., 1024) = 1024
[pid 18454] fstat64(5, {st_mode=S_IFREG|0755, st_size=43933, ...}) = 0
[pid 18454] old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f00000
[pid 18454] old_mmap(NULL, 197728, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7ecf000
[pid 18454] mprotect(0xb7ed7000, 164960, PROT_NONE) = 0
[pid 18454] old_mmap(0xb7ed7000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x8000) = 0xb7ed7000
[pid 18454] old_mmap(0xb7ed9000, 156768, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7ed9000
[pid 18454] close(5)                    = 0
[pid 18454] open("/lib/libc.so.6", O_RDONLY) = 5
[pid 18454] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0pY\1\000"..., 1024) = 1024
[pid 18454] fstat64(5, {st_mode=S_IFREG|0755, st_size=1491599, ...}) = 0
[pid 18454] old_mmap(NULL, 1268004, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7d99000
[pid 18454] mprotect(0xb7ec8000, 26916, PROT_NONE) = 0
[pid 18454] old_mmap(0xb7ec8000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x12f000) = 0xb7ec8000
[pid 18454] old_mmap(0xb7ecc000, 10532, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7ecc000
[pid 18454] close(5)                    = 0
[pid 18454] brk(0)                      = 0x817b000
[pid 18454] brk(0x817c000)              = 0x817c000
[pid 18454] brk(0)                      = 0x817c000
[pid 18454] uname({sys="Linux", node="kchtn", ...}) = 0
[pid 18454] stat64("ip_tables", 0xbfafa3e0) = -1 ENOENT (No such file or directory)
[pid 18454] lstat64("/lib", {st_mode=S_IFDIR|0755, st_size=220, ...}) = 0
[pid 18454] lstat64("/lib/modules", {st_mode=S_IFDIR|0755, st_size=28, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default", {st_mode=S_IFDIR|0755, st_size=44, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default", {st_mode=S_IFDIR|0755, st_size=44, ...}) = 0
[pid 18454] open("/dev/null", O_RDONLY|O_NONBLOCK|O_DIRECTORY) = -1 ENOTDIR (Not a directory)
[pid 18454] open("/lib/modules/2.6.23.9-default", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 5
[pid 18454] fstat64(5, {st_mode=S_IFDIR|0755, st_size=44, ...}) = 0
[pid 18454] fcntl64(5, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] brk(0)                      = 0x817c000
[pid 18454] brk(0x817d000)              = 0x817d000
[pid 18454] getdents64(5, /* 2 entries */, 4096) = 64
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel", {st_mode=S_IFDIR|0755, st_size=68, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 6
[pid 18454] fstat64(6, {st_mode=S_IFDIR|0755, st_size=68, ...}) = 0
[pid 18454] fcntl64(6, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] brk(0)                      = 0x817d000
[pid 18454] brk(0x817e000)              = 0x817e000
[pid 18454] getdents64(6, /* 4 entries */, 4096) = 104
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers", {st_mode=S_IFDIR|0755, st_size=64, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/drivers", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 7
[pid 18454] fstat64(7, {st_mode=S_IFDIR|0755, st_size=64, ...}) = 0
[pid 18454] fcntl64(7, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] brk(0)                      = 0x817e000
[pid 18454] brk(0x817f000)              = 0x817f000
[pid 18454] getdents64(7, /* 4 entries */, 4096) = 96
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi", {st_mode=S_IFDIR|0755, st_size=184, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/drivers/acpi", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18454] fstat64(8, {st_mode=S_IFDIR|0755, st_size=184, ...}) = 0
[pid 18454] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] brk(0)                      = 0x817f000
[pid 18454] brk(0x8180000)              = 0x8180000
[pid 18454] getdents64(8, /* 8 entries */, 4096) = 256
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/ac.ko", {st_mode=S_IFREG|0644, st_size=6132, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/asus_acpi.ko", {st_mode=S_IFREG|0644, st_size=21711, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/battery.ko", {st_mode=S_IFREG|0644, st_size=14467, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/button.ko", {st_mode=S_IFREG|0644, st_size=9165, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/container.ko", {st_mode=S_IFREG|0644, st_size=5791, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/fan.ko", {st_mode=S_IFREG|0644, st_size=6034, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/processor.ko", {st_mode=S_IFREG|0644, st_size=34510, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/thermal.ko", {st_mode=S_IFREG|0644, st_size=21465, ...}) = 0
[pid 18454] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18454] close(8)                    = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/char", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/drivers/char", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18454] fstat64(8, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18454] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18454] close(8)                    = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net", {st_mode=S_IFDIR|0755, st_size=268, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/drivers/net", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18454] fstat64(8, {st_mode=S_IFDIR|0755, st_size=268, ...}) = 0
[pid 18454] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(8, /* 11 entries */, 4096) = 384
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/8139too.ko", {st_mode=S_IFREG|0755, st_size=29763, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/bsd_comp.ko", {st_mode=S_IFREG|0644, st_size=6735, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/dummy.ko", {st_mode=S_IFREG|0755, st_size=4402, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/netconsole.ko", {st_mode=S_IFREG|0644, st_size=4059, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_async.ko", {st_mode=S_IFREG|0755, st_size=10569, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_deflate.ko", {st_mode=S_IFREG|0755, st_size=6468, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_generic.ko", {st_mode=S_IFREG|0755, st_size=24315, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_mppe.ko", {st_mode=S_IFREG|0755, st_size=8202, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_synctty.ko", {st_mode=S_IFREG|0755, st_size=9096, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/slhc.ko", {st_mode=S_IFREG|0755, st_size=6592, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/tun.ko", {st_mode=S_IFREG|0755, st_size=10595, ...}) = 0
[pid 18454] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18454] close(8)                    = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/usb", {st_mode=S_IFDIR|0755, st_size=16, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/drivers/usb", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18454] fstat64(8, {st_mode=S_IFDIR|0755, st_size=16, ...}) = 0
[pid 18454] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(8, /* 1 entries */, 4096) = 24
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/usb/net", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/drivers/usb/net", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18454] fstat64(9, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18454] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] brk(0)                      = 0x8180000
[pid 18454] brk(0x8181000)              = 0x8181000
[pid 18454] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18454] close(9)                    = 0
[pid 18454] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18454] close(8)                    = 0
[pid 18454] getdents64(7, /* 0 entries */, 4096) = 0
[pid 18454] close(7)                    = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/fs", {st_mode=S_IFDIR|0755, st_size=96, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/fs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 7
[pid 18454] fstat64(7, {st_mode=S_IFDIR|0755, st_size=96, ...}) = 0
[pid 18454] fcntl64(7, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(7, /* 5 entries */, 4096) = 152
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/cramfs", {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/fs/cramfs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18454] fstat64(8, {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18454] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(8, /* 1 entries */, 4096) = 32
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/cramfs/cramfs.ko", {st_mode=S_IFREG|0755, st_size=9380, ...}) = 0
[pid 18454] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18454] close(8)                    = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/isofs", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/fs/isofs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18454] fstat64(8, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18454] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18454] close(8)                    = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/reiserfs", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/fs/reiserfs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18454] fstat64(8, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18454] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18454] close(8)                    = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/smbfs", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/fs/smbfs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18454] fstat64(8, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18454] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18454] close(8)                    = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/udf", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/fs/udf", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18454] fstat64(8, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18454] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18454] close(8)                    = 0
[pid 18454] getdents64(7, /* 0 entries */, 4096) = 0
[pid 18454] close(7)                    = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/lib", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/lib", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 7
[pid 18454] fstat64(7, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18454] fcntl64(7, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(7, /* 0 entries */, 4096) = 0
[pid 18454] close(7)                    = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net", {st_mode=S_IFDIR|0755, st_size=108, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/net", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 7
[pid 18454] fstat64(7, {st_mode=S_IFDIR|0755, st_size=108, ...}) = 0
[pid 18454] fcntl64(7, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(7, /* 6 entries */, 4096) = 168
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/8021q", {st_mode=S_IFDIR|0755, st_size=20, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/net/8021q", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18454] fstat64(8, {st_mode=S_IFDIR|0755, st_size=20, ...}) = 0
[pid 18454] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(8, /* 1 entries */, 4096) = 32
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/8021q/8021q.ko", {st_mode=S_IFREG|0755, st_size=21970, ...}) = 0
[pid 18454] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18454] close(8)                    = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/atm", {st_mode=S_IFDIR|0755, st_size=64, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/net/atm", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18454] fstat64(8, {st_mode=S_IFDIR|0755, st_size=64, ...}) = 0
[pid 18454] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(8, /* 3 entries */, 4096) = 96
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/atm/atm.ko", {st_mode=S_IFREG|0755, st_size=45039, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/atm/br2684.ko", {st_mode=S_IFREG|0755, st_size=9197, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/atm/clip.ko", {st_mode=S_IFREG|0755, st_size=14837, ...}) = 0
[pid 18454] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18454] close(8)                    = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge", {st_mode=S_IFDIR|0755, st_size=48, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/net/bridge", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18454] fstat64(8, {st_mode=S_IFDIR|0755, st_size=48, ...}) = 0
[pid 18454] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(8, /* 2 entries */, 4096) = 64
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/bridge.ko", {st_mode=S_IFREG|0755, st_size=58477, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter", {st_mode=S_IFDIR|0755, st_size=572, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18454] fstat64(9, {st_mode=S_IFDIR|0755, st_size=572, ...}) = 0
[pid 18454] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(9, /* 22 entries */, 4096) = 776
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_802_3.ko", {st_mode=S_IFREG|0755, st_size=2837, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_among.ko", {st_mode=S_IFREG|0755, st_size=4508, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_arp.ko", {st_mode=S_IFREG|0755, st_size=3726, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_arpreply.ko", {st_mode=S_IFREG|0755, st_size=3416, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_dnat.ko", {st_mode=S_IFREG|0755, st_size=3221, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_ip.ko", {st_mode=S_IFREG|0755, st_size=3439, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_ipdaddr.ko", {st_mode=S_IFREG|0755, st_size=4409, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_ipsaddr.ko", {st_mode=S_IFREG|0755, st_size=4409, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_limit.ko", {st_mode=S_IFREG|0755, st_size=3369, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_log.ko", {st_mode=S_IFREG|0755, st_size=5332, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_mark.ko", {st_mode=S_IFREG|0755, st_size=2839, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_mark_m.ko", {st_mode=S_IFREG|0755, st_size=2774, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_pkttype.ko", {st_mode=S_IFREG|0755, st_size=2723, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_redirect.ko", {st_mode=S_IFREG|0755, st_size=3288, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_snat.ko", {st_mode=S_IFREG|0755, st_size=3378, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_stp.ko", {st_mode=S_IFREG|0755, st_size=3992, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_ulog.ko", {st_mode=S_IFREG|0755, st_size=7733, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_vlan.ko", {st_mode=S_IFREG|0755, st_size=4997, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebtable_broute.ko", {st_mode=S_IFREG|0755, st_size=3234, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebtable_filter.ko", {st_mode=S_IFREG|0755, st_size=3584, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebtable_nat.ko", {st_mode=S_IFREG|0755, st_size=3613, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebtables.ko", {st_mode=S_IFREG|0755, st_size=21295, ...}) = 0
[pid 18454] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18454] close(9)                    = 0
[pid 18454] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18454] close(8)                    = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/core", {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/net/core", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18454] fstat64(8, {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18454] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(8, /* 1 entries */, 4096) = 32
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/core/pktgen.ko", {st_mode=S_IFREG|0755, st_size=44932, ...}) = 0
[pid 18454] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18454] close(8)                    = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/ipv4", {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/net/ipv4", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18454] fstat64(8, {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18454] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(8, /* 1 entries */, 4096) = 32
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/ipv4/netfilter", {st_mode=S_IFDIR|0755, st_size=28, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/net/ipv4/netfilter", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18454] fstat64(9, {st_mode=S_IFDIR|0755, st_size=28, ...}) = 0
[pid 18454] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(9, /* 1 entries */, 4096) = 40
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/ipv4/netfilter/ipt_CLUSTERIP.ko", {st_mode=S_IFREG|0755, st_size=9564, ...}) = 0
[pid 18454] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18454] close(9)                    = 0
[pid 18454] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18454] close(8)                    = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched", {st_mode=S_IFDIR|0755, st_size=648, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/net/sched", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18454] fstat64(8, {st_mode=S_IFDIR|0755, st_size=648, ...}) = 0
[pid 18454] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(8, /* 26 entries */, 4096) = 880
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_gact.ko", {st_mode=S_IFREG|0755, st_size=4973, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_ipt.ko", {st_mode=S_IFREG|0755, st_size=6243, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_mirred.ko", {st_mode=S_IFREG|0755, st_size=5582, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_pedit.ko", {st_mode=S_IFREG|0755, st_size=5510, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_police.ko", {st_mode=S_IFREG|0755, st_size=6451, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_simple.ko", {st_mode=S_IFREG|0755, st_size=5001, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_basic.ko", {st_mode=S_IFREG|0755, st_size=5729, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_fw.ko", {st_mode=S_IFREG|0755, st_size=5396, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_route.ko", {st_mode=S_IFREG|0755, st_size=7185, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_rsvp.ko", {st_mode=S_IFREG|0755, st_size=7095, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_tcindex.ko", {st_mode=S_IFREG|0755, st_size=7627, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_u32.ko", {st_mode=S_IFREG|0755, st_size=8276, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_atm.ko", {st_mode=S_IFREG|0755, st_size=8177, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_cbq.ko", {st_mode=S_IFREG|0755, st_size=16919, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_csz.ko", {st_mode=S_IFREG|0755, st_size=8449, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_dsmark.ko", {st_mode=S_IFREG|0755, st_size=6721, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_gred.ko", {st_mode=S_IFREG|0755, st_size=8798, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_hfsc.ko", {st_mode=S_IFREG|0755, st_size=18166, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_htb.ko", {st_mode=S_IFREG|0755, st_size=16942, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_ingress.ko", {st_mode=S_IFREG|0755, st_size=4347, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_netem.ko", {st_mode=S_IFREG|0755, st_size=8878, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_prio.ko", {st_mode=S_IFREG|0755, st_size=6453, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_red.ko", {st_mode=S_IFREG|0755, st_size=6816, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_sfq.ko", {st_mode=S_IFREG|0755, st_size=6416, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_tbf.ko", {st_mode=S_IFREG|0755, st_size=6140, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_teql.ko", {st_mode=S_IFREG|0755, st_size=7072, ...}) = 0
[pid 18454] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18454] close(8)                    = 0
[pid 18454] getdents64(7, /* 0 entries */, 4096) = 0
[pid 18454] close(7)                    = 0
[pid 18454] getdents64(6, /* 0 entries */, 4096) = 0
[pid 18454] close(6)                    = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/modules.dep", {st_mode=S_IFREG|0755, st_size=4712, ...}) = 0
[pid 18454] getdents64(5, /* 0 entries */, 4096) = 0
[pid 18454] close(5)                    = 0
[pid 18454] lstat64("/lib", {st_mode=S_IFDIR|0755, st_size=220, ...}) = 0
[pid 18454] lstat64("/lib/modules", {st_mode=S_IFDIR|0755, st_size=28, ...}) = 0
[pid 18454] lstat64("/lib/modules", {st_mode=S_IFDIR|0755, st_size=28, ...}) = 0
[pid 18454] open("/lib/modules", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 5
[pid 18454] fstat64(5, {st_mode=S_IFDIR|0755, st_size=28, ...}) = 0
[pid 18454] fcntl64(5, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(5, /* 1 entries */, 4096) = 40
[pid 18454] lstat64("/lib/modules/2.6.23.9-default", {st_mode=S_IFDIR|0755, st_size=44, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 6
[pid 18454] fstat64(6, {st_mode=S_IFDIR|0755, st_size=44, ...}) = 0
[pid 18454] fcntl64(6, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(6, /* 2 entries */, 4096) = 64
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel", {st_mode=S_IFDIR|0755, st_size=68, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 7
[pid 18454] fstat64(7, {st_mode=S_IFDIR|0755, st_size=68, ...}) = 0
[pid 18454] fcntl64(7, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(7, /* 4 entries */, 4096) = 104
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers", {st_mode=S_IFDIR|0755, st_size=64, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/drivers", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18454] fstat64(8, {st_mode=S_IFDIR|0755, st_size=64, ...}) = 0
[pid 18454] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(8, /* 4 entries */, 4096) = 96
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi", {st_mode=S_IFDIR|0755, st_size=184, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/drivers/acpi", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18454] fstat64(9, {st_mode=S_IFDIR|0755, st_size=184, ...}) = 0
[pid 18454] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(9, /* 8 entries */, 4096) = 256
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/ac.ko", {st_mode=S_IFREG|0644, st_size=6132, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/asus_acpi.ko", {st_mode=S_IFREG|0644, st_size=21711, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/battery.ko", {st_mode=S_IFREG|0644, st_size=14467, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/button.ko", {st_mode=S_IFREG|0644, st_size=9165, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/container.ko", {st_mode=S_IFREG|0644, st_size=5791, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/fan.ko", {st_mode=S_IFREG|0644, st_size=6034, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/processor.ko", {st_mode=S_IFREG|0644, st_size=34510, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/thermal.ko", {st_mode=S_IFREG|0644, st_size=21465, ...}) = 0
[pid 18454] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18454] close(9)                    = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/char", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/drivers/char", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18454] fstat64(9, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18454] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18454] close(9)                    = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net", {st_mode=S_IFDIR|0755, st_size=268, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/drivers/net", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18454] fstat64(9, {st_mode=S_IFDIR|0755, st_size=268, ...}) = 0
[pid 18454] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(9, /* 11 entries */, 4096) = 384
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/8139too.ko", {st_mode=S_IFREG|0755, st_size=29763, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/bsd_comp.ko", {st_mode=S_IFREG|0644, st_size=6735, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/dummy.ko", {st_mode=S_IFREG|0755, st_size=4402, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/netconsole.ko", {st_mode=S_IFREG|0644, st_size=4059, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_async.ko", {st_mode=S_IFREG|0755, st_size=10569, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_deflate.ko", {st_mode=S_IFREG|0755, st_size=6468, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_generic.ko", {st_mode=S_IFREG|0755, st_size=24315, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_mppe.ko", {st_mode=S_IFREG|0755, st_size=8202, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_synctty.ko", {st_mode=S_IFREG|0755, st_size=9096, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/slhc.ko", {st_mode=S_IFREG|0755, st_size=6592, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/tun.ko", {st_mode=S_IFREG|0755, st_size=10595, ...}) = 0
[pid 18454] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18454] close(9)                    = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/usb", {st_mode=S_IFDIR|0755, st_size=16, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/drivers/usb", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18454] fstat64(9, {st_mode=S_IFDIR|0755, st_size=16, ...}) = 0
[pid 18454] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(9, /* 1 entries */, 4096) = 24
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/usb/net", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/drivers/usb/net", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 10
[pid 18454] fstat64(10, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18454] fcntl64(10, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] brk(0)                      = 0x8181000
[pid 18454] brk(0x8182000)              = 0x8182000
[pid 18454] getdents64(10, /* 0 entries */, 4096) = 0
[pid 18454] close(10)                   = 0
[pid 18454] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18454] close(9)                    = 0
[pid 18454] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18454] close(8)                    = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/fs", {st_mode=S_IFDIR|0755, st_size=96, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/fs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18454] fstat64(8, {st_mode=S_IFDIR|0755, st_size=96, ...}) = 0
[pid 18454] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(8, /* 5 entries */, 4096) = 152
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/cramfs", {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/fs/cramfs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18454] fstat64(9, {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18454] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(9, /* 1 entries */, 4096) = 32
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/cramfs/cramfs.ko", {st_mode=S_IFREG|0755, st_size=9380, ...}) = 0
[pid 18454] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18454] close(9)                    = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/isofs", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/fs/isofs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18454] fstat64(9, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18454] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18454] close(9)                    = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/reiserfs", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/fs/reiserfs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18454] fstat64(9, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18454] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18454] close(9)                    = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/smbfs", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/fs/smbfs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18454] fstat64(9, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18454] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18454] close(9)                    = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/udf", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/fs/udf", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18454] fstat64(9, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18454] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18454] close(9)                    = 0
[pid 18454] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18454] close(8)                    = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/lib", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/lib", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18454] fstat64(8, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18454] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18454] close(8)                    = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net", {st_mode=S_IFDIR|0755, st_size=108, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/net", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18454] fstat64(8, {st_mode=S_IFDIR|0755, st_size=108, ...}) = 0
[pid 18454] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(8, /* 6 entries */, 4096) = 168
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/8021q", {st_mode=S_IFDIR|0755, st_size=20, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/net/8021q", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18454] fstat64(9, {st_mode=S_IFDIR|0755, st_size=20, ...}) = 0
[pid 18454] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(9, /* 1 entries */, 4096) = 32
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/8021q/8021q.ko", {st_mode=S_IFREG|0755, st_size=21970, ...}) = 0
[pid 18454] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18454] close(9)                    = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/atm", {st_mode=S_IFDIR|0755, st_size=64, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/net/atm", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18454] fstat64(9, {st_mode=S_IFDIR|0755, st_size=64, ...}) = 0
[pid 18454] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(9, /* 3 entries */, 4096) = 96
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/atm/atm.ko", {st_mode=S_IFREG|0755, st_size=45039, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/atm/br2684.ko", {st_mode=S_IFREG|0755, st_size=9197, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/atm/clip.ko", {st_mode=S_IFREG|0755, st_size=14837, ...}) = 0
[pid 18454] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18454] close(9)                    = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge", {st_mode=S_IFDIR|0755, st_size=48, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/net/bridge", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18454] fstat64(9, {st_mode=S_IFDIR|0755, st_size=48, ...}) = 0
[pid 18454] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(9, /* 2 entries */, 4096) = 64
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/bridge.ko", {st_mode=S_IFREG|0755, st_size=58477, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter", {st_mode=S_IFDIR|0755, st_size=572, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 10
[pid 18454] fstat64(10, {st_mode=S_IFDIR|0755, st_size=572, ...}) = 0
[pid 18454] fcntl64(10, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(10, /* 22 entries */, 4096) = 776
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_802_3.ko", {st_mode=S_IFREG|0755, st_size=2837, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_among.ko", {st_mode=S_IFREG|0755, st_size=4508, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_arp.ko", {st_mode=S_IFREG|0755, st_size=3726, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_arpreply.ko", {st_mode=S_IFREG|0755, st_size=3416, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_dnat.ko", {st_mode=S_IFREG|0755, st_size=3221, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_ip.ko", {st_mode=S_IFREG|0755, st_size=3439, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_ipdaddr.ko", {st_mode=S_IFREG|0755, st_size=4409, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_ipsaddr.ko", {st_mode=S_IFREG|0755, st_size=4409, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_limit.ko", {st_mode=S_IFREG|0755, st_size=3369, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_log.ko", {st_mode=S_IFREG|0755, st_size=5332, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_mark.ko", {st_mode=S_IFREG|0755, st_size=2839, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_mark_m.ko", {st_mode=S_IFREG|0755, st_size=2774, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_pkttype.ko", {st_mode=S_IFREG|0755, st_size=2723, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_redirect.ko", {st_mode=S_IFREG|0755, st_size=3288, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_snat.ko", {st_mode=S_IFREG|0755, st_size=3378, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_stp.ko", {st_mode=S_IFREG|0755, st_size=3992, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_ulog.ko", {st_mode=S_IFREG|0755, st_size=7733, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_vlan.ko", {st_mode=S_IFREG|0755, st_size=4997, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebtable_broute.ko", {st_mode=S_IFREG|0755, st_size=3234, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebtable_filter.ko", {st_mode=S_IFREG|0755, st_size=3584, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebtable_nat.ko", {st_mode=S_IFREG|0755, st_size=3613, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebtables.ko", {st_mode=S_IFREG|0755, st_size=21295, ...}) = 0
[pid 18454] getdents64(10, /* 0 entries */, 4096) = 0
[pid 18454] close(10)                   = 0
[pid 18454] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18454] close(9)                    = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/core", {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/net/core", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18454] fstat64(9, {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18454] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(9, /* 1 entries */, 4096) = 32
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/core/pktgen.ko", {st_mode=S_IFREG|0755, st_size=44932, ...}) = 0
[pid 18454] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18454] close(9)                    = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/ipv4", {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/net/ipv4", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18454] fstat64(9, {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18454] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(9, /* 1 entries */, 4096) = 32
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/ipv4/netfilter", {st_mode=S_IFDIR|0755, st_size=28, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/net/ipv4/netfilter", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 10
[pid 18454] fstat64(10, {st_mode=S_IFDIR|0755, st_size=28, ...}) = 0
[pid 18454] fcntl64(10, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(10, /* 1 entries */, 4096) = 40
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/ipv4/netfilter/ipt_CLUSTERIP.ko", {st_mode=S_IFREG|0755, st_size=9564, ...}) = 0
[pid 18454] getdents64(10, /* 0 entries */, 4096) = 0
[pid 18454] close(10)                   = 0
[pid 18454] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18454] close(9)                    = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched", {st_mode=S_IFDIR|0755, st_size=648, ...}) = 0
[pid 18454] open("/lib/modules/2.6.23.9-default/kernel/net/sched", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18454] fstat64(9, {st_mode=S_IFDIR|0755, st_size=648, ...}) = 0
[pid 18454] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18454] getdents64(9, /* 26 entries */, 4096) = 880
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_gact.ko", {st_mode=S_IFREG|0755, st_size=4973, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_ipt.ko", {st_mode=S_IFREG|0755, st_size=6243, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_mirred.ko", {st_mode=S_IFREG|0755, st_size=5582, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_pedit.ko", {st_mode=S_IFREG|0755, st_size=5510, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_police.ko", {st_mode=S_IFREG|0755, st_size=6451, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_simple.ko", {st_mode=S_IFREG|0755, st_size=5001, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_basic.ko", {st_mode=S_IFREG|0755, st_size=5729, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_fw.ko", {st_mode=S_IFREG|0755, st_size=5396, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_route.ko", {st_mode=S_IFREG|0755, st_size=7185, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_rsvp.ko", {st_mode=S_IFREG|0755, st_size=7095, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_tcindex.ko", {st_mode=S_IFREG|0755, st_size=7627, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_u32.ko", {st_mode=S_IFREG|0755, st_size=8276, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_atm.ko", {st_mode=S_IFREG|0755, st_size=8177, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_cbq.ko", {st_mode=S_IFREG|0755, st_size=16919, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_csz.ko", {st_mode=S_IFREG|0755, st_size=8449, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_dsmark.ko", {st_mode=S_IFREG|0755, st_size=6721, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_gred.ko", {st_mode=S_IFREG|0755, st_size=8798, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_hfsc.ko", {st_mode=S_IFREG|0755, st_size=18166, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_htb.ko", {st_mode=S_IFREG|0755, st_size=16942, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_ingress.ko", {st_mode=S_IFREG|0755, st_size=4347, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_netem.ko", {st_mode=S_IFREG|0755, st_size=8878, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_prio.ko", {st_mode=S_IFREG|0755, st_size=6453, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_red.ko", {st_mode=S_IFREG|0755, st_size=6816, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_sfq.ko", {st_mode=S_IFREG|0755, st_size=6416, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_tbf.ko", {st_mode=S_IFREG|0755, st_size=6140, ...}) = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_teql.ko", {st_mode=S_IFREG|0755, st_size=7072, ...}) = 0
[pid 18454] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18454] close(9)                    = 0
[pid 18454] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18454] close(8)                    = 0
[pid 18454] getdents64(7, /* 0 entries */, 4096) = 0
[pid 18454] close(7)                    = 0
[pid 18454] lstat64("/lib/modules/2.6.23.9-default/modules.dep", {st_mode=S_IFREG|0755, st_size=4712, ...}) = 0
[pid 18454] getdents64(6, /* 0 entries */, 4096) = 0
[pid 18454] close(6)                    = 0
[pid 18454] getdents64(5, /* 0 entries */, 4096) = 0
[pid 18454] close(5)                    = 0
[pid 18454] write(2, "insmod: ", 8insmod: )     = 8
[pid 18454] write(2, "ip_tables.ko: no module by that "..., 42ip_tables.ko: no module by that name found) = 42
[pid 18454] write(2, "\n", 1
)           = 1
[pid 18454] exit_group(1)               = ?
[pid 18453] <... wait4 resumed> [WIFEXITED(s) && WEXITSTATUS(s) == 1], 0, NULL) = 18454
[pid 18453] --- SIGCHLD (Child exited) @ 0 (0) ---
[pid 18453] exit_group(1)               = ?
[pid 18449] <... wait4 resumed> [WIFEXITED(s) && WEXITSTATUS(s) == 1], 0, NULL) = 18453
[pid 18449] rt_sigaction(SIGINT, {SIG_DFL}, NULL, 8) = 0
[pid 18449] rt_sigaction(SIGQUIT, {SIG_DFL}, NULL, 8) = 0
[pid 18449] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 18449] --- SIGCHLD (Child exited) @ 0 (0) ---
[pid 18449] write(2, "modprobe: ", 10modprobe: )  = 10
[pid 18449] write(2, "failed to load module ip_tables", 31failed to load module ip_tables) = 31
[pid 18449] write(2, "\n", 1
)           = 1
[pid 18449] exit_group(1)               = ?
<... wait4 resumed> [WIFEXITED(s) && WEXITSTATUS(s) == 1], 0, NULL) = 18449
--- SIGCHLD (Child exited) @ 0 (0) ---
getsockopt(4, SOL_IP, 0x43 /* IP_??? */, "MARK\0\201\372\267\0h\344\267\225w\372\267\270O\240\277"..., [30]) = 0
close(4)                                = 0
socket(PF_INET, SOCK_RAW, IPPROTO_RAW)  = 4
open("/proc/sys/kernel/modprobe", O_RDONLY|O_LARGEFILE) = 5
read(5, "/sbin/modprobe\n", 1024)       = 15
close(5)                                = 0
fork()                                  = 18462
[pid 18448] wait4(-1,  <unfinished ...>
[pid 18462] execve("/sbin/modprobe", ["/sbin/modprobe", "ip_tables", "-q"], [/* 14 vars */]) = 0
[pid 18462] uname({sys="Linux", node="kchtn", ...}) = 0
[pid 18462] brk(0)                      = 0x817b000
[pid 18462] open("/etc/ld.so.preload", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18462] open("/lib/i686/mmx/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18462] stat64("/lib/i686/mmx", 0xbf9553f0) = -1 ENOENT (No such file or directory)
[pid 18462] open("/lib/i686/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18462] stat64("/lib/i686", 0xbf9553f0) = -1 ENOENT (No such file or directory)
[pid 18462] open("/lib/mmx/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18462] stat64("/lib/mmx", 0xbf9553f0) = -1 ENOENT (No such file or directory)
[pid 18462] open("/lib/libm.so.6", O_RDONLY) = 5
[pid 18462] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\3605\0"..., 1024) = 1024
[pid 18462] fstat64(5, {st_mode=S_IFREG|0755, st_size=184056, ...}) = 0
[pid 18462] old_mmap(NULL, 138416, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7eda000
[pid 18462] mprotect(0xb7efb000, 3248, PROT_NONE) = 0
[pid 18462] old_mmap(0xb7efb000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x20000) = 0xb7efb000
[pid 18462] close(5)                    = 0
[pid 18462] open("/lib/libcrypt.so.1", O_RDONLY) = 5
[pid 18462] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\220\n\0"..., 1024) = 1024
[pid 18462] fstat64(5, {st_mode=S_IFREG|0755, st_size=43933, ...}) = 0
[pid 18462] old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7ed9000
[pid 18462] old_mmap(NULL, 197728, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7ea8000
[pid 18462] mprotect(0xb7eb0000, 164960, PROT_NONE) = 0
[pid 18462] old_mmap(0xb7eb0000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x8000) = 0xb7eb0000
[pid 18462] old_mmap(0xb7eb2000, 156768, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7eb2000
[pid 18462] close(5)                    = 0
[pid 18462] open("/lib/libc.so.6", O_RDONLY) = 5
[pid 18462] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0pY\1\000"..., 1024) = 1024
[pid 18462] fstat64(5, {st_mode=S_IFREG|0755, st_size=1491599, ...}) = 0
[pid 18462] old_mmap(NULL, 1268004, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7d72000
[pid 18462] mprotect(0xb7ea1000, 26916, PROT_NONE) = 0
[pid 18462] old_mmap(0xb7ea1000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x12f000) = 0xb7ea1000
[pid 18462] old_mmap(0xb7ea5000, 10532, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7ea5000
[pid 18462] close(5)                    = 0
[pid 18462] uname({sys="Linux", node="kchtn", ...}) = 0
[pid 18462] open("/lib/modules/2.6.23.9-default/modules.dep", O_RDONLY) = 5
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 256
[pid 18462] lseek(5, 62, SEEK_SET)      = 62
[pid 18462] brk(0)                      = 0x817b000
[pid 18462] brk(0x817c000)              = 0x817c000
[pid 18462] brk(0)                      = 0x817c000
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 318
[pid 18462] lseek(5, 126, SEEK_SET)     = 126
[pid 18462] read(5, "\n/lib/modules/2.6.23.9-default/k"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 382
[pid 18462] lseek(5, 127, SEEK_SET)     = 127
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 383
[pid 18462] lseek(5, 192, SEEK_SET)     = 192
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 448
[pid 18462] lseek(5, 251, SEEK_SET)     = 251
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 507
[pid 18462] lseek(5, 313, SEEK_SET)     = 313
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 569
[pid 18462] lseek(5, 371, SEEK_SET)     = 371
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 627
[pid 18462] lseek(5, 493, SEEK_SET)     = 493
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 749
[pid 18462] lseek(5, 558, SEEK_SET)     = 558
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 814
[pid 18462] lseek(5, 621, SEEK_SET)     = 621
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 877
[pid 18462] lseek(5, 686, SEEK_SET)     = 686
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 942
[pid 18462] lseek(5, 743, SEEK_SET)     = 743
[pid 18462] read(5, "\n/lib/modules/2.6.23.9-default/k"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 999
[pid 18462] lseek(5, 744, SEEK_SET)     = 744
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 1000
[pid 18462] lseek(5, 801, SEEK_SET)     = 801
[pid 18462] read(5, "\n/lib/modules/2.6.23.9-default/k"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 1057
[pid 18462] lseek(5, 802, SEEK_SET)     = 802
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 1058
[pid 18462] lseek(5, 861, SEEK_SET)     = 861
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 1117
[pid 18462] lseek(5, 933, SEEK_SET)     = 933
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 1189
[pid 18462] lseek(5, 1005, SEEK_SET)    = 1005
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 1261
[pid 18462] lseek(5, 1075, SEEK_SET)    = 1075
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 1331
[pid 18462] lseek(5, 1150, SEEK_SET)    = 1150
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 1406
[pid 18462] lseek(5, 1221, SEEK_SET)    = 1221
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 1477
[pid 18462] lseek(5, 1290, SEEK_SET)    = 1290
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 1546
[pid 18462] lseek(5, 1364, SEEK_SET)    = 1364
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 1620
[pid 18462] lseek(5, 1438, SEEK_SET)    = 1438
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 1694
[pid 18462] lseek(5, 1510, SEEK_SET)    = 1510
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 1766
[pid 18462] lseek(5, 1580, SEEK_SET)    = 1580
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 1836
[pid 18462] lseek(5, 1651, SEEK_SET)    = 1651
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 1907
[pid 18462] lseek(5, 1724, SEEK_SET)    = 1724
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 1980
[pid 18462] lseek(5, 1798, SEEK_SET)    = 1798
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 2054
[pid 18462] lseek(5, 1873, SEEK_SET)    = 1873
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 2129
[pid 18462] lseek(5, 1944, SEEK_SET)    = 1944
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 2200
[pid 18462] lseek(5, 2014, SEEK_SET)    = 2014
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 2270
[pid 18462] lseek(5, 2085, SEEK_SET)    = 2085
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 2341
[pid 18462] lseek(5, 2162, SEEK_SET)    = 2162
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 2418
[pid 18462] lseek(5, 2239, SEEK_SET)    = 2239
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 2495
[pid 18462] lseek(5, 2313, SEEK_SET)    = 2313
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 2569
[pid 18462] lseek(5, 2384, SEEK_SET)    = 2384
[pid 18462] read(5, "\n/lib/modules/2.6.23.9-default/k"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 2640
[pid 18462] lseek(5, 2385, SEEK_SET)    = 2385
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 2641
[pid 18462] lseek(5, 2457, SEEK_SET)    = 2457
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 2713
[pid 18462] lseek(5, 2604, SEEK_SET)    = 2604
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 2860
[pid 18462] lseek(5, 2751, SEEK_SET)    = 2751
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 3007
[pid 18462] lseek(5, 2829, SEEK_SET)    = 2829
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 3085
[pid 18462] lseek(5, 2907, SEEK_SET)    = 2907
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 3163
[pid 18462] lseek(5, 2984, SEEK_SET)    = 2984
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 3240
[pid 18462] lseek(5, 3061, SEEK_SET)    = 3061
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 3317
[pid 18462] lseek(5, 3132, SEEK_SET)    = 3132
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 3388
[pid 18462] lseek(5, 3203, SEEK_SET)    = 3203
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 3459
[pid 18462] lseek(5, 3278, SEEK_SET)    = 3278
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 3534
[pid 18462] lseek(5, 3336, SEEK_SET)    = 3336
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 3592
[pid 18462] lseek(5, 3397, SEEK_SET)    = 3397
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 3653
[pid 18462] lseek(5, 3460, SEEK_SET)    = 3460
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 3716
[pid 18462] lseek(5, 3519, SEEK_SET)    = 3519
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 3775
[pid 18462] lseek(5, 3578, SEEK_SET)    = 3578
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 3834
[pid 18462] lseek(5, 3637, SEEK_SET)    = 3637
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 3893
[pid 18462] lseek(5, 3699, SEEK_SET)    = 3699
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 3955
[pid 18462] lseek(5, 3759, SEEK_SET)    = 3759
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 4015
[pid 18462] lseek(5, 3819, SEEK_SET)    = 3819
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 4075
[pid 18462] lseek(5, 3878, SEEK_SET)    = 3878
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 4134
[pid 18462] lseek(5, 3941, SEEK_SET)    = 3941
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 4197
[pid 18462] lseek(5, 4001, SEEK_SET)    = 4001
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 4257
[pid 18462] lseek(5, 4060, SEEK_SET)    = 4060
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 4316
[pid 18462] lseek(5, 4119, SEEK_SET)    = 4119
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 4375
[pid 18462] lseek(5, 4178, SEEK_SET)    = 4178
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 4434
[pid 18462] lseek(5, 4238, SEEK_SET)    = 4238
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 4494
[pid 18462] lseek(5, 4295, SEEK_SET)    = 4295
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 4551
[pid 18462] lseek(5, 4348, SEEK_SET)    = 4348
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 4604
[pid 18462] lseek(5, 4419, SEEK_SET)    = 4419
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 4675
[pid 18462] lseek(5, 4490, SEEK_SET)    = 4490
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 222
[pid 18462] lseek(5, 0, SEEK_CUR)       = 4712
[pid 18462] lseek(5, 4548, SEEK_SET)    = 4548
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 164
[pid 18462] lseek(5, 0, SEEK_CUR)       = 4712
[pid 18462] lseek(5, 4604, SEEK_SET)    = 4604
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 108
[pid 18462] lseek(5, 0, SEEK_CUR)       = 4712
[pid 18462] lseek(5, 4660, SEEK_SET)    = 4660
[pid 18462] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 52
[pid 18462] lseek(5, 0, SEEK_CUR)       = 4712
[pid 18462] lseek(5, 4712, SEEK_SET)    = 4712
[pid 18462] read(5, "", 256)            = 0
[pid 18462] close(5)                    = 0
[pid 18462] open("/etc/modules.conf", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18462] open("/etc/conf.modules", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18462] open("/proc/modules", O_RDONLY) = 5
[pid 18462] read(5, "ebt_ip 2208 2 - Live 0xdc86b000\n"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 256
[pid 18462] lseek(5, 32, SEEK_SET)      = 32
[pid 18462] read(5, "ebtable_nat 2144 1 - Live 0xdc83"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 288
[pid 18462] lseek(5, 69, SEEK_SET)      = 69
[pid 18462] read(5, "ebtables 17088 2 ebt_ip,ebtable_"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 325
[pid 18462] lseek(5, 122, SEEK_SET)     = 122
[pid 18462] read(5, "sch_sfq 4928 40 - Live 0xdc85c00"..., 256) = 256
[pid 18462] lseek(5, 0, SEEK_CUR)       = 378
[pid 18462] lseek(5, 156, SEEK_SET)     = 156
[pid 18462] read(5, "cls_fw 3808 1 - Live 0xdc81c000\n"..., 256) = 227
[pid 18462] lseek(5, 0, SEEK_CUR)       = 383
[pid 18462] lseek(5, 188, SEEK_SET)     = 188
[pid 18462] read(5, "cls_u32 6244 1 - Live 0xdc84c000"..., 256) = 195
[pid 18462] lseek(5, 0, SEEK_CUR)       = 383
[pid 18462] lseek(5, 221, SEEK_SET)     = 221
[pid 18462] read(5, "sch_htb 13920 2 - Live 0xdc86200"..., 256) = 162
[pid 18462] lseek(5, 0, SEEK_CUR)       = 383
[pid 18462] lseek(5, 255, SEEK_SET)     = 255
[pid 18462] read(5, "tun 7872 0 - Live 0xdc849000\n802"..., 256) = 128
[pid 18462] lseek(5, 0, SEEK_CUR)       = 383
[pid 18462] lseek(5, 284, SEEK_SET)     = 284
[pid 18462] read(5, "8021q 17224 0 - Live 0xdc850000\n"..., 256) = 99
[pid 18462] lseek(5, 0, SEEK_CUR)       = 383
[pid 18462] lseek(5, 316, SEEK_SET)     = 316
[pid 18462] read(5, "8139too 22032 0 - Live 0xdc84200"..., 256) = 67
[pid 18462] lseek(5, 0, SEEK_CUR)       = 383
[pid 18462] lseek(5, 350, SEEK_SET)     = 350
[pid 18462] read(5, "cramfs 39796 6 - Live 0xdc820000"..., 256) = 33
[pid 18462] lseek(5, 0, SEEK_CUR)       = 383
[pid 18462] lseek(5, 383, SEEK_SET)     = 383
[pid 18462] read(5, "", 256)            = 0
[pid 18462] close(5)                    = 0
[pid 18462] rt_sigaction(SIGINT, {SIG_IGN}, {SIG_DFL}, 8) = 0
[pid 18462] rt_sigaction(SIGQUIT, {SIG_IGN}, {SIG_DFL}, 8) = 0
[pid 18462] rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
[pid 18462] fork()                      = 18463
[pid 18462] wait4(18463,  <unfinished ...>
[pid 18463] rt_sigaction(SIGINT, {SIG_DFL}, NULL, 8) = 0
[pid 18463] rt_sigaction(SIGQUIT, {SIG_DFL}, NULL, 8) = 0
[pid 18463] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 18463] execve("/bin/sh", ["sh", "-c", "insmod   -q ip_tables "], [/* 14 vars */]) = 0
[pid 18463] uname({sys="Linux", node="kchtn", ...}) = 0
[pid 18463] brk(0)                      = 0x817b000
[pid 18463] open("/etc/ld.so.preload", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18463] open("/lib/i686/mmx/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18463] stat64("/lib/i686/mmx", 0xbfd79820) = -1 ENOENT (No such file or directory)
[pid 18463] open("/lib/i686/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18463] stat64("/lib/i686", 0xbfd79820) = -1 ENOENT (No such file or directory)
[pid 18463] open("/lib/mmx/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18463] stat64("/lib/mmx", 0xbfd79820) = -1 ENOENT (No such file or directory)
[pid 18463] open("/lib/libm.so.6", O_RDONLY) = 5
[pid 18463] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\3605\0"..., 1024) = 1024
[pid 18463] fstat64(5, {st_mode=S_IFREG|0755, st_size=184056, ...}) = 0
[pid 18463] old_mmap(NULL, 138416, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7f89000
[pid 18463] mprotect(0xb7faa000, 3248, PROT_NONE) = 0
[pid 18463] old_mmap(0xb7faa000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x20000) = 0xb7faa000
[pid 18463] close(5)                    = 0
[pid 18463] open("/lib/libcrypt.so.1", O_RDONLY) = 5
[pid 18463] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\220\n\0"..., 1024) = 1024
[pid 18463] fstat64(5, {st_mode=S_IFREG|0755, st_size=43933, ...}) = 0
[pid 18463] old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f88000
[pid 18463] old_mmap(NULL, 197728, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7f57000
[pid 18463] mprotect(0xb7f5f000, 164960, PROT_NONE) = 0
[pid 18463] old_mmap(0xb7f5f000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x8000) = 0xb7f5f000
[pid 18463] old_mmap(0xb7f61000, 156768, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7f61000
[pid 18463] close(5)                    = 0
[pid 18463] open("/lib/libc.so.6", O_RDONLY) = 5
[pid 18463] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0pY\1\000"..., 1024) = 1024
[pid 18463] fstat64(5, {st_mode=S_IFREG|0755, st_size=1491599, ...}) = 0
[pid 18463] old_mmap(NULL, 1268004, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7e21000
[pid 18463] mprotect(0xb7f50000, 26916, PROT_NONE) = 0
[pid 18463] old_mmap(0xb7f50000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x12f000) = 0xb7f50000
[pid 18463] old_mmap(0xb7f54000, 10532, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7f54000
[pid 18463] close(5)                    = 0
[pid 18463] getpid()                    = 18463
[pid 18463] rt_sigaction(SIGCHLD, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 18463] geteuid32()                 = 0
[pid 18463] brk(0)                      = 0x817b000
[pid 18463] brk(0x817c000)              = 0x817c000
[pid 18463] brk(0)                      = 0x817c000
[pid 18463] getppid()                   = 18462
[pid 18463] brk(0)                      = 0x817c000
[pid 18463] brk(0x817d000)              = 0x817d000
[pid 18463] getcwd("/root", 4096)       = 6
[pid 18463] rt_sigaction(SIGINT, NULL, {SIG_DFL}, 8) = 0
[pid 18463] rt_sigaction(SIGINT, {0x807ecd1, ~[], SA_RESTORER, 0xb7e4a5c8}, NULL, 8) = 0
[pid 18463] rt_sigaction(SIGQUIT, NULL, {SIG_DFL}, 8) = 0
[pid 18463] rt_sigaction(SIGQUIT, {SIG_DFL}, NULL, 8) = 0
[pid 18463] rt_sigaction(SIGTERM, NULL, {SIG_DFL}, 8) = 0
[pid 18463] rt_sigaction(SIGTERM, {SIG_DFL}, NULL, 8) = 0
[pid 18463] stat64("/bin/insmod", 0xbfd7a014) = -1 ENOENT (No such file or directory)
[pid 18463] stat64("/sbin/insmod", {st_mode=S_IFREG|0755, st_size=358124, ...}) = 0
[pid 18463] fork()                      = 18464
[pid 18463] wait4(-1,  <unfinished ...>
[pid 18464] execve("/sbin/insmod", ["insmod", "-q", "ip_tables"], [/* 14 vars */]) = 0
[pid 18464] uname({sys="Linux", node="kchtn", ...}) = 0
[pid 18464] brk(0)                      = 0x817b000
[pid 18464] open("/etc/ld.so.preload", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18464] open("/lib/i686/mmx/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18464] stat64("/lib/i686/mmx", 0xbfd407f0) = -1 ENOENT (No such file or directory)
[pid 18464] open("/lib/i686/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18464] stat64("/lib/i686", 0xbfd407f0) = -1 ENOENT (No such file or directory)
[pid 18464] open("/lib/mmx/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18464] stat64("/lib/mmx", 0xbfd407f0) = -1 ENOENT (No such file or directory)
[pid 18464] open("/lib/libm.so.6", O_RDONLY) = 5
[pid 18464] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\3605\0"..., 1024) = 1024
[pid 18464] fstat64(5, {st_mode=S_IFREG|0755, st_size=184056, ...}) = 0
[pid 18464] old_mmap(NULL, 138416, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7f19000
[pid 18464] mprotect(0xb7f3a000, 3248, PROT_NONE) = 0
[pid 18464] old_mmap(0xb7f3a000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x20000) = 0xb7f3a000
[pid 18464] close(5)                    = 0
[pid 18464] open("/lib/libcrypt.so.1", O_RDONLY) = 5
[pid 18464] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\220\n\0"..., 1024) = 1024
[pid 18464] fstat64(5, {st_mode=S_IFREG|0755, st_size=43933, ...}) = 0
[pid 18464] old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f18000
[pid 18464] old_mmap(NULL, 197728, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7ee7000
[pid 18464] mprotect(0xb7eef000, 164960, PROT_NONE) = 0
[pid 18464] old_mmap(0xb7eef000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x8000) = 0xb7eef000
[pid 18464] old_mmap(0xb7ef1000, 156768, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7ef1000
[pid 18464] close(5)                    = 0
[pid 18464] open("/lib/libc.so.6", O_RDONLY) = 5
[pid 18464] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0pY\1\000"..., 1024) = 1024
[pid 18464] fstat64(5, {st_mode=S_IFREG|0755, st_size=1491599, ...}) = 0
[pid 18464] old_mmap(NULL, 1268004, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7db1000
[pid 18464] mprotect(0xb7ee0000, 26916, PROT_NONE) = 0
[pid 18464] old_mmap(0xb7ee0000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x12f000) = 0xb7ee0000
[pid 18464] old_mmap(0xb7ee4000, 10532, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7ee4000
[pid 18464] close(5)                    = 0
[pid 18464] brk(0)                      = 0x817b000
[pid 18464] brk(0x817c000)              = 0x817c000
[pid 18464] brk(0)                      = 0x817c000
[pid 18464] uname({sys="Linux", node="kchtn", ...}) = 0
[pid 18464] stat64("ip_tables", 0xbfd3ee30) = -1 ENOENT (No such file or directory)
[pid 18464] lstat64("/lib", {st_mode=S_IFDIR|0755, st_size=220, ...}) = 0
[pid 18464] lstat64("/lib/modules", {st_mode=S_IFDIR|0755, st_size=28, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default", {st_mode=S_IFDIR|0755, st_size=44, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default", {st_mode=S_IFDIR|0755, st_size=44, ...}) = 0
[pid 18464] open("/dev/null", O_RDONLY|O_NONBLOCK|O_DIRECTORY) = -1 ENOTDIR (Not a directory)
[pid 18464] open("/lib/modules/2.6.23.9-default", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 5
[pid 18464] fstat64(5, {st_mode=S_IFDIR|0755, st_size=44, ...}) = 0
[pid 18464] fcntl64(5, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] brk(0)                      = 0x817c000
[pid 18464] brk(0x817d000)              = 0x817d000
[pid 18464] getdents64(5, /* 2 entries */, 4096) = 64
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel", {st_mode=S_IFDIR|0755, st_size=68, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 6
[pid 18464] fstat64(6, {st_mode=S_IFDIR|0755, st_size=68, ...}) = 0
[pid 18464] fcntl64(6, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] brk(0)                      = 0x817d000
[pid 18464] brk(0x817e000)              = 0x817e000
[pid 18464] getdents64(6, /* 4 entries */, 4096) = 104
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers", {st_mode=S_IFDIR|0755, st_size=64, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/drivers", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 7
[pid 18464] fstat64(7, {st_mode=S_IFDIR|0755, st_size=64, ...}) = 0
[pid 18464] fcntl64(7, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] brk(0)                      = 0x817e000
[pid 18464] brk(0x817f000)              = 0x817f000
[pid 18464] getdents64(7, /* 4 entries */, 4096) = 96
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi", {st_mode=S_IFDIR|0755, st_size=184, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/drivers/acpi", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18464] fstat64(8, {st_mode=S_IFDIR|0755, st_size=184, ...}) = 0
[pid 18464] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] brk(0)                      = 0x817f000
[pid 18464] brk(0x8180000)              = 0x8180000
[pid 18464] getdents64(8, /* 8 entries */, 4096) = 256
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/ac.ko", {st_mode=S_IFREG|0644, st_size=6132, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/asus_acpi.ko", {st_mode=S_IFREG|0644, st_size=21711, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/battery.ko", {st_mode=S_IFREG|0644, st_size=14467, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/button.ko", {st_mode=S_IFREG|0644, st_size=9165, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/container.ko", {st_mode=S_IFREG|0644, st_size=5791, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/fan.ko", {st_mode=S_IFREG|0644, st_size=6034, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/processor.ko", {st_mode=S_IFREG|0644, st_size=34510, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/thermal.ko", {st_mode=S_IFREG|0644, st_size=21465, ...}) = 0
[pid 18464] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18464] close(8)                    = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/char", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/drivers/char", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18464] fstat64(8, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18464] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18464] close(8)                    = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net", {st_mode=S_IFDIR|0755, st_size=268, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/drivers/net", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18464] fstat64(8, {st_mode=S_IFDIR|0755, st_size=268, ...}) = 0
[pid 18464] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(8, /* 11 entries */, 4096) = 384
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/8139too.ko", {st_mode=S_IFREG|0755, st_size=29763, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/bsd_comp.ko", {st_mode=S_IFREG|0644, st_size=6735, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/dummy.ko", {st_mode=S_IFREG|0755, st_size=4402, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/netconsole.ko", {st_mode=S_IFREG|0644, st_size=4059, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_async.ko", {st_mode=S_IFREG|0755, st_size=10569, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_deflate.ko", {st_mode=S_IFREG|0755, st_size=6468, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_generic.ko", {st_mode=S_IFREG|0755, st_size=24315, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_mppe.ko", {st_mode=S_IFREG|0755, st_size=8202, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_synctty.ko", {st_mode=S_IFREG|0755, st_size=9096, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/slhc.ko", {st_mode=S_IFREG|0755, st_size=6592, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/tun.ko", {st_mode=S_IFREG|0755, st_size=10595, ...}) = 0
[pid 18464] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18464] close(8)                    = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/usb", {st_mode=S_IFDIR|0755, st_size=16, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/drivers/usb", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18464] fstat64(8, {st_mode=S_IFDIR|0755, st_size=16, ...}) = 0
[pid 18464] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(8, /* 1 entries */, 4096) = 24
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/usb/net", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/drivers/usb/net", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18464] fstat64(9, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18464] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] brk(0)                      = 0x8180000
[pid 18464] brk(0x8181000)              = 0x8181000
[pid 18464] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18464] close(9)                    = 0
[pid 18464] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18464] close(8)                    = 0
[pid 18464] getdents64(7, /* 0 entries */, 4096) = 0
[pid 18464] close(7)                    = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/fs", {st_mode=S_IFDIR|0755, st_size=96, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/fs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 7
[pid 18464] fstat64(7, {st_mode=S_IFDIR|0755, st_size=96, ...}) = 0
[pid 18464] fcntl64(7, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(7, /* 5 entries */, 4096) = 152
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/cramfs", {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/fs/cramfs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18464] fstat64(8, {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18464] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(8, /* 1 entries */, 4096) = 32
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/cramfs/cramfs.ko", {st_mode=S_IFREG|0755, st_size=9380, ...}) = 0
[pid 18464] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18464] close(8)                    = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/isofs", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/fs/isofs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18464] fstat64(8, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18464] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18464] close(8)                    = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/reiserfs", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/fs/reiserfs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18464] fstat64(8, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18464] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18464] close(8)                    = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/smbfs", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/fs/smbfs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18464] fstat64(8, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18464] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18464] close(8)                    = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/udf", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/fs/udf", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18464] fstat64(8, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18464] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18464] close(8)                    = 0
[pid 18464] getdents64(7, /* 0 entries */, 4096) = 0
[pid 18464] close(7)                    = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/lib", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/lib", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 7
[pid 18464] fstat64(7, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18464] fcntl64(7, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(7, /* 0 entries */, 4096) = 0
[pid 18464] close(7)                    = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net", {st_mode=S_IFDIR|0755, st_size=108, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/net", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 7
[pid 18464] fstat64(7, {st_mode=S_IFDIR|0755, st_size=108, ...}) = 0
[pid 18464] fcntl64(7, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(7, /* 6 entries */, 4096) = 168
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/8021q", {st_mode=S_IFDIR|0755, st_size=20, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/net/8021q", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18464] fstat64(8, {st_mode=S_IFDIR|0755, st_size=20, ...}) = 0
[pid 18464] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(8, /* 1 entries */, 4096) = 32
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/8021q/8021q.ko", {st_mode=S_IFREG|0755, st_size=21970, ...}) = 0
[pid 18464] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18464] close(8)                    = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/atm", {st_mode=S_IFDIR|0755, st_size=64, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/net/atm", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18464] fstat64(8, {st_mode=S_IFDIR|0755, st_size=64, ...}) = 0
[pid 18464] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(8, /* 3 entries */, 4096) = 96
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/atm/atm.ko", {st_mode=S_IFREG|0755, st_size=45039, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/atm/br2684.ko", {st_mode=S_IFREG|0755, st_size=9197, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/atm/clip.ko", {st_mode=S_IFREG|0755, st_size=14837, ...}) = 0
[pid 18464] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18464] close(8)                    = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge", {st_mode=S_IFDIR|0755, st_size=48, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/net/bridge", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18464] fstat64(8, {st_mode=S_IFDIR|0755, st_size=48, ...}) = 0
[pid 18464] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(8, /* 2 entries */, 4096) = 64
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/bridge.ko", {st_mode=S_IFREG|0755, st_size=58477, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter", {st_mode=S_IFDIR|0755, st_size=572, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18464] fstat64(9, {st_mode=S_IFDIR|0755, st_size=572, ...}) = 0
[pid 18464] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(9, /* 22 entries */, 4096) = 776
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_802_3.ko", {st_mode=S_IFREG|0755, st_size=2837, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_among.ko", {st_mode=S_IFREG|0755, st_size=4508, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_arp.ko", {st_mode=S_IFREG|0755, st_size=3726, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_arpreply.ko", {st_mode=S_IFREG|0755, st_size=3416, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_dnat.ko", {st_mode=S_IFREG|0755, st_size=3221, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_ip.ko", {st_mode=S_IFREG|0755, st_size=3439, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_ipdaddr.ko", {st_mode=S_IFREG|0755, st_size=4409, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_ipsaddr.ko", {st_mode=S_IFREG|0755, st_size=4409, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_limit.ko", {st_mode=S_IFREG|0755, st_size=3369, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_log.ko", {st_mode=S_IFREG|0755, st_size=5332, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_mark.ko", {st_mode=S_IFREG|0755, st_size=2839, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_mark_m.ko", {st_mode=S_IFREG|0755, st_size=2774, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_pkttype.ko", {st_mode=S_IFREG|0755, st_size=2723, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_redirect.ko", {st_mode=S_IFREG|0755, st_size=3288, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_snat.ko", {st_mode=S_IFREG|0755, st_size=3378, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_stp.ko", {st_mode=S_IFREG|0755, st_size=3992, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_ulog.ko", {st_mode=S_IFREG|0755, st_size=7733, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_vlan.ko", {st_mode=S_IFREG|0755, st_size=4997, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebtable_broute.ko", {st_mode=S_IFREG|0755, st_size=3234, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebtable_filter.ko", {st_mode=S_IFREG|0755, st_size=3584, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebtable_nat.ko", {st_mode=S_IFREG|0755, st_size=3613, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebtables.ko", {st_mode=S_IFREG|0755, st_size=21295, ...}) = 0
[pid 18464] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18464] close(9)                    = 0
[pid 18464] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18464] close(8)                    = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/core", {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/net/core", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18464] fstat64(8, {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18464] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(8, /* 1 entries */, 4096) = 32
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/core/pktgen.ko", {st_mode=S_IFREG|0755, st_size=44932, ...}) = 0
[pid 18464] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18464] close(8)                    = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/ipv4", {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/net/ipv4", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18464] fstat64(8, {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18464] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(8, /* 1 entries */, 4096) = 32
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/ipv4/netfilter", {st_mode=S_IFDIR|0755, st_size=28, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/net/ipv4/netfilter", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18464] fstat64(9, {st_mode=S_IFDIR|0755, st_size=28, ...}) = 0
[pid 18464] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(9, /* 1 entries */, 4096) = 40
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/ipv4/netfilter/ipt_CLUSTERIP.ko", {st_mode=S_IFREG|0755, st_size=9564, ...}) = 0
[pid 18464] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18464] close(9)                    = 0
[pid 18464] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18464] close(8)                    = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched", {st_mode=S_IFDIR|0755, st_size=648, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/net/sched", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18464] fstat64(8, {st_mode=S_IFDIR|0755, st_size=648, ...}) = 0
[pid 18464] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(8, /* 26 entries */, 4096) = 880
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_gact.ko", {st_mode=S_IFREG|0755, st_size=4973, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_ipt.ko", {st_mode=S_IFREG|0755, st_size=6243, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_mirred.ko", {st_mode=S_IFREG|0755, st_size=5582, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_pedit.ko", {st_mode=S_IFREG|0755, st_size=5510, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_police.ko", {st_mode=S_IFREG|0755, st_size=6451, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_simple.ko", {st_mode=S_IFREG|0755, st_size=5001, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_basic.ko", {st_mode=S_IFREG|0755, st_size=5729, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_fw.ko", {st_mode=S_IFREG|0755, st_size=5396, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_route.ko", {st_mode=S_IFREG|0755, st_size=7185, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_rsvp.ko", {st_mode=S_IFREG|0755, st_size=7095, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_tcindex.ko", {st_mode=S_IFREG|0755, st_size=7627, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_u32.ko", {st_mode=S_IFREG|0755, st_size=8276, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_atm.ko", {st_mode=S_IFREG|0755, st_size=8177, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_cbq.ko", {st_mode=S_IFREG|0755, st_size=16919, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_csz.ko", {st_mode=S_IFREG|0755, st_size=8449, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_dsmark.ko", {st_mode=S_IFREG|0755, st_size=6721, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_gred.ko", {st_mode=S_IFREG|0755, st_size=8798, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_hfsc.ko", {st_mode=S_IFREG|0755, st_size=18166, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_htb.ko", {st_mode=S_IFREG|0755, st_size=16942, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_ingress.ko", {st_mode=S_IFREG|0755, st_size=4347, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_netem.ko", {st_mode=S_IFREG|0755, st_size=8878, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_prio.ko", {st_mode=S_IFREG|0755, st_size=6453, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_red.ko", {st_mode=S_IFREG|0755, st_size=6816, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_sfq.ko", {st_mode=S_IFREG|0755, st_size=6416, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_tbf.ko", {st_mode=S_IFREG|0755, st_size=6140, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_teql.ko", {st_mode=S_IFREG|0755, st_size=7072, ...}) = 0
[pid 18464] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18464] close(8)                    = 0
[pid 18464] getdents64(7, /* 0 entries */, 4096) = 0
[pid 18464] close(7)                    = 0
[pid 18464] getdents64(6, /* 0 entries */, 4096) = 0
[pid 18464] close(6)                    = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/modules.dep", {st_mode=S_IFREG|0755, st_size=4712, ...}) = 0
[pid 18464] getdents64(5, /* 0 entries */, 4096) = 0
[pid 18464] close(5)                    = 0
[pid 18464] lstat64("/lib", {st_mode=S_IFDIR|0755, st_size=220, ...}) = 0
[pid 18464] lstat64("/lib/modules", {st_mode=S_IFDIR|0755, st_size=28, ...}) = 0
[pid 18464] lstat64("/lib/modules", {st_mode=S_IFDIR|0755, st_size=28, ...}) = 0
[pid 18464] open("/lib/modules", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 5
[pid 18464] fstat64(5, {st_mode=S_IFDIR|0755, st_size=28, ...}) = 0
[pid 18464] fcntl64(5, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(5, /* 1 entries */, 4096) = 40
[pid 18464] lstat64("/lib/modules/2.6.23.9-default", {st_mode=S_IFDIR|0755, st_size=44, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 6
[pid 18464] fstat64(6, {st_mode=S_IFDIR|0755, st_size=44, ...}) = 0
[pid 18464] fcntl64(6, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(6, /* 2 entries */, 4096) = 64
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel", {st_mode=S_IFDIR|0755, st_size=68, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 7
[pid 18464] fstat64(7, {st_mode=S_IFDIR|0755, st_size=68, ...}) = 0
[pid 18464] fcntl64(7, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(7, /* 4 entries */, 4096) = 104
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers", {st_mode=S_IFDIR|0755, st_size=64, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/drivers", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18464] fstat64(8, {st_mode=S_IFDIR|0755, st_size=64, ...}) = 0
[pid 18464] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(8, /* 4 entries */, 4096) = 96
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi", {st_mode=S_IFDIR|0755, st_size=184, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/drivers/acpi", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18464] fstat64(9, {st_mode=S_IFDIR|0755, st_size=184, ...}) = 0
[pid 18464] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(9, /* 8 entries */, 4096) = 256
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/ac.ko", {st_mode=S_IFREG|0644, st_size=6132, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/asus_acpi.ko", {st_mode=S_IFREG|0644, st_size=21711, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/battery.ko", {st_mode=S_IFREG|0644, st_size=14467, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/button.ko", {st_mode=S_IFREG|0644, st_size=9165, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/container.ko", {st_mode=S_IFREG|0644, st_size=5791, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/fan.ko", {st_mode=S_IFREG|0644, st_size=6034, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/processor.ko", {st_mode=S_IFREG|0644, st_size=34510, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/thermal.ko", {st_mode=S_IFREG|0644, st_size=21465, ...}) = 0
[pid 18464] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18464] close(9)                    = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/char", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/drivers/char", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18464] fstat64(9, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18464] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18464] close(9)                    = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net", {st_mode=S_IFDIR|0755, st_size=268, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/drivers/net", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18464] fstat64(9, {st_mode=S_IFDIR|0755, st_size=268, ...}) = 0
[pid 18464] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(9, /* 11 entries */, 4096) = 384
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/8139too.ko", {st_mode=S_IFREG|0755, st_size=29763, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/bsd_comp.ko", {st_mode=S_IFREG|0644, st_size=6735, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/dummy.ko", {st_mode=S_IFREG|0755, st_size=4402, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/netconsole.ko", {st_mode=S_IFREG|0644, st_size=4059, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_async.ko", {st_mode=S_IFREG|0755, st_size=10569, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_deflate.ko", {st_mode=S_IFREG|0755, st_size=6468, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_generic.ko", {st_mode=S_IFREG|0755, st_size=24315, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_mppe.ko", {st_mode=S_IFREG|0755, st_size=8202, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_synctty.ko", {st_mode=S_IFREG|0755, st_size=9096, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/slhc.ko", {st_mode=S_IFREG|0755, st_size=6592, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/tun.ko", {st_mode=S_IFREG|0755, st_size=10595, ...}) = 0
[pid 18464] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18464] close(9)                    = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/usb", {st_mode=S_IFDIR|0755, st_size=16, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/drivers/usb", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18464] fstat64(9, {st_mode=S_IFDIR|0755, st_size=16, ...}) = 0
[pid 18464] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(9, /* 1 entries */, 4096) = 24
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/usb/net", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/drivers/usb/net", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 10
[pid 18464] fstat64(10, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18464] fcntl64(10, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] brk(0)                      = 0x8181000
[pid 18464] brk(0x8182000)              = 0x8182000
[pid 18464] getdents64(10, /* 0 entries */, 4096) = 0
[pid 18464] close(10)                   = 0
[pid 18464] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18464] close(9)                    = 0
[pid 18464] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18464] close(8)                    = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/fs", {st_mode=S_IFDIR|0755, st_size=96, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/fs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18464] fstat64(8, {st_mode=S_IFDIR|0755, st_size=96, ...}) = 0
[pid 18464] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(8, /* 5 entries */, 4096) = 152
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/cramfs", {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/fs/cramfs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18464] fstat64(9, {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18464] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(9, /* 1 entries */, 4096) = 32
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/cramfs/cramfs.ko", {st_mode=S_IFREG|0755, st_size=9380, ...}) = 0
[pid 18464] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18464] close(9)                    = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/isofs", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/fs/isofs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18464] fstat64(9, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18464] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18464] close(9)                    = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/reiserfs", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/fs/reiserfs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18464] fstat64(9, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18464] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18464] close(9)                    = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/smbfs", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/fs/smbfs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18464] fstat64(9, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18464] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18464] close(9)                    = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/udf", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/fs/udf", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18464] fstat64(9, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18464] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18464] close(9)                    = 0
[pid 18464] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18464] close(8)                    = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/lib", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/lib", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18464] fstat64(8, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18464] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18464] close(8)                    = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net", {st_mode=S_IFDIR|0755, st_size=108, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/net", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18464] fstat64(8, {st_mode=S_IFDIR|0755, st_size=108, ...}) = 0
[pid 18464] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(8, /* 6 entries */, 4096) = 168
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/8021q", {st_mode=S_IFDIR|0755, st_size=20, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/net/8021q", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18464] fstat64(9, {st_mode=S_IFDIR|0755, st_size=20, ...}) = 0
[pid 18464] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(9, /* 1 entries */, 4096) = 32
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/8021q/8021q.ko", {st_mode=S_IFREG|0755, st_size=21970, ...}) = 0
[pid 18464] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18464] close(9)                    = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/atm", {st_mode=S_IFDIR|0755, st_size=64, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/net/atm", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18464] fstat64(9, {st_mode=S_IFDIR|0755, st_size=64, ...}) = 0
[pid 18464] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(9, /* 3 entries */, 4096) = 96
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/atm/atm.ko", {st_mode=S_IFREG|0755, st_size=45039, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/atm/br2684.ko", {st_mode=S_IFREG|0755, st_size=9197, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/atm/clip.ko", {st_mode=S_IFREG|0755, st_size=14837, ...}) = 0
[pid 18464] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18464] close(9)                    = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge", {st_mode=S_IFDIR|0755, st_size=48, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/net/bridge", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18464] fstat64(9, {st_mode=S_IFDIR|0755, st_size=48, ...}) = 0
[pid 18464] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(9, /* 2 entries */, 4096) = 64
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/bridge.ko", {st_mode=S_IFREG|0755, st_size=58477, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter", {st_mode=S_IFDIR|0755, st_size=572, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 10
[pid 18464] fstat64(10, {st_mode=S_IFDIR|0755, st_size=572, ...}) = 0
[pid 18464] fcntl64(10, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(10, /* 22 entries */, 4096) = 776
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_802_3.ko", {st_mode=S_IFREG|0755, st_size=2837, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_among.ko", {st_mode=S_IFREG|0755, st_size=4508, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_arp.ko", {st_mode=S_IFREG|0755, st_size=3726, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_arpreply.ko", {st_mode=S_IFREG|0755, st_size=3416, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_dnat.ko", {st_mode=S_IFREG|0755, st_size=3221, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_ip.ko", {st_mode=S_IFREG|0755, st_size=3439, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_ipdaddr.ko", {st_mode=S_IFREG|0755, st_size=4409, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_ipsaddr.ko", {st_mode=S_IFREG|0755, st_size=4409, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_limit.ko", {st_mode=S_IFREG|0755, st_size=3369, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_log.ko", {st_mode=S_IFREG|0755, st_size=5332, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_mark.ko", {st_mode=S_IFREG|0755, st_size=2839, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_mark_m.ko", {st_mode=S_IFREG|0755, st_size=2774, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_pkttype.ko", {st_mode=S_IFREG|0755, st_size=2723, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_redirect.ko", {st_mode=S_IFREG|0755, st_size=3288, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_snat.ko", {st_mode=S_IFREG|0755, st_size=3378, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_stp.ko", {st_mode=S_IFREG|0755, st_size=3992, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_ulog.ko", {st_mode=S_IFREG|0755, st_size=7733, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_vlan.ko", {st_mode=S_IFREG|0755, st_size=4997, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebtable_broute.ko", {st_mode=S_IFREG|0755, st_size=3234, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebtable_filter.ko", {st_mode=S_IFREG|0755, st_size=3584, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebtable_nat.ko", {st_mode=S_IFREG|0755, st_size=3613, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebtables.ko", {st_mode=S_IFREG|0755, st_size=21295, ...}) = 0
[pid 18464] getdents64(10, /* 0 entries */, 4096) = 0
[pid 18464] close(10)                   = 0
[pid 18464] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18464] close(9)                    = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/core", {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/net/core", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18464] fstat64(9, {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18464] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(9, /* 1 entries */, 4096) = 32
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/core/pktgen.ko", {st_mode=S_IFREG|0755, st_size=44932, ...}) = 0
[pid 18464] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18464] close(9)                    = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/ipv4", {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/net/ipv4", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18464] fstat64(9, {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18464] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(9, /* 1 entries */, 4096) = 32
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/ipv4/netfilter", {st_mode=S_IFDIR|0755, st_size=28, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/net/ipv4/netfilter", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 10
[pid 18464] fstat64(10, {st_mode=S_IFDIR|0755, st_size=28, ...}) = 0
[pid 18464] fcntl64(10, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(10, /* 1 entries */, 4096) = 40
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/ipv4/netfilter/ipt_CLUSTERIP.ko", {st_mode=S_IFREG|0755, st_size=9564, ...}) = 0
[pid 18464] getdents64(10, /* 0 entries */, 4096) = 0
[pid 18464] close(10)                   = 0
[pid 18464] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18464] close(9)                    = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched", {st_mode=S_IFDIR|0755, st_size=648, ...}) = 0
[pid 18464] open("/lib/modules/2.6.23.9-default/kernel/net/sched", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18464] fstat64(9, {st_mode=S_IFDIR|0755, st_size=648, ...}) = 0
[pid 18464] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18464] getdents64(9, /* 26 entries */, 4096) = 880
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_gact.ko", {st_mode=S_IFREG|0755, st_size=4973, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_ipt.ko", {st_mode=S_IFREG|0755, st_size=6243, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_mirred.ko", {st_mode=S_IFREG|0755, st_size=5582, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_pedit.ko", {st_mode=S_IFREG|0755, st_size=5510, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_police.ko", {st_mode=S_IFREG|0755, st_size=6451, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_simple.ko", {st_mode=S_IFREG|0755, st_size=5001, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_basic.ko", {st_mode=S_IFREG|0755, st_size=5729, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_fw.ko", {st_mode=S_IFREG|0755, st_size=5396, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_route.ko", {st_mode=S_IFREG|0755, st_size=7185, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_rsvp.ko", {st_mode=S_IFREG|0755, st_size=7095, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_tcindex.ko", {st_mode=S_IFREG|0755, st_size=7627, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_u32.ko", {st_mode=S_IFREG|0755, st_size=8276, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_atm.ko", {st_mode=S_IFREG|0755, st_size=8177, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_cbq.ko", {st_mode=S_IFREG|0755, st_size=16919, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_csz.ko", {st_mode=S_IFREG|0755, st_size=8449, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_dsmark.ko", {st_mode=S_IFREG|0755, st_size=6721, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_gred.ko", {st_mode=S_IFREG|0755, st_size=8798, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_hfsc.ko", {st_mode=S_IFREG|0755, st_size=18166, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_htb.ko", {st_mode=S_IFREG|0755, st_size=16942, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_ingress.ko", {st_mode=S_IFREG|0755, st_size=4347, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_netem.ko", {st_mode=S_IFREG|0755, st_size=8878, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_prio.ko", {st_mode=S_IFREG|0755, st_size=6453, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_red.ko", {st_mode=S_IFREG|0755, st_size=6816, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_sfq.ko", {st_mode=S_IFREG|0755, st_size=6416, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_tbf.ko", {st_mode=S_IFREG|0755, st_size=6140, ...}) = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_teql.ko", {st_mode=S_IFREG|0755, st_size=7072, ...}) = 0
[pid 18464] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18464] close(9)                    = 0
[pid 18464] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18464] close(8)                    = 0
[pid 18464] getdents64(7, /* 0 entries */, 4096) = 0
[pid 18464] close(7)                    = 0
[pid 18464] lstat64("/lib/modules/2.6.23.9-default/modules.dep", {st_mode=S_IFREG|0755, st_size=4712, ...}) = 0
[pid 18464] getdents64(6, /* 0 entries */, 4096) = 0
[pid 18464] close(6)                    = 0
[pid 18464] getdents64(5, /* 0 entries */, 4096) = 0
[pid 18464] close(5)                    = 0
[pid 18464] write(2, "insmod: ", 8insmod: )     = 8
[pid 18464] write(2, "ip_tables.ko: no module by that "..., 42ip_tables.ko: no module by that name found) = 42
[pid 18464] write(2, "\n", 1
)           = 1
[pid 18464] exit_group(1)               = ?
[pid 18463] <... wait4 resumed> [WIFEXITED(s) && WEXITSTATUS(s) == 1], 0, NULL) = 18464
[pid 18463] --- SIGCHLD (Child exited) @ 0 (0) ---
[pid 18463] exit_group(1)               = ?
[pid 18462] <... wait4 resumed> [WIFEXITED(s) && WEXITSTATUS(s) == 1], 0, NULL) = 18463
[pid 18462] rt_sigaction(SIGINT, {SIG_DFL}, NULL, 8) = 0
[pid 18462] rt_sigaction(SIGQUIT, {SIG_DFL}, NULL, 8) = 0
[pid 18462] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 18462] --- SIGCHLD (Child exited) @ 0 (0) ---
[pid 18462] write(2, "modprobe: ", 10modprobe: )  = 10
[pid 18462] write(2, "failed to load module ip_tables", 31failed to load module ip_tables) = 31
[pid 18462] write(2, "\n", 1
)           = 1
[pid 18462] exit_group(1)               = ?
<... wait4 resumed> [WIFEXITED(s) && WEXITSTATUS(s) == 1], 0, NULL) = 18462
--- SIGCHLD (Child exited) @ 0 (0) ---
getsockopt(4, SOL_IP, 0x43 /* IP_??? */, "MARK\0\201\372\267\0h\344\267\225w\372\267\270O\240\277"..., [30]) = 0
close(4)                                = 0
socket(PF_INET, SOCK_RAW, IPPROTO_RAW)  = 4
open("/proc/sys/kernel/modprobe", O_RDONLY|O_LARGEFILE) = 5
read(5, "/sbin/modprobe\n", 1024)       = 15
close(5)                                = 0
fork()                                  = 18465
[pid 18448] wait4(-1,  <unfinished ...>
[pid 18465] execve("/sbin/modprobe", ["/sbin/modprobe", "ip_tables", "-q"], [/* 14 vars */]) = 0
[pid 18465] uname({sys="Linux", node="kchtn", ...}) = 0
[pid 18465] brk(0)                      = 0x817b000
[pid 18465] open("/etc/ld.so.preload", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18465] open("/lib/i686/mmx/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18465] stat64("/lib/i686/mmx", 0xbfbd4670) = -1 ENOENT (No such file or directory)
[pid 18465] open("/lib/i686/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18465] stat64("/lib/i686", 0xbfbd4670) = -1 ENOENT (No such file or directory)
[pid 18465] open("/lib/mmx/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18465] stat64("/lib/mmx", 0xbfbd4670) = -1 ENOENT (No such file or directory)
[pid 18465] open("/lib/libm.so.6", O_RDONLY) = 5
[pid 18465] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\3605\0"..., 1024) = 1024
[pid 18465] fstat64(5, {st_mode=S_IFREG|0755, st_size=184056, ...}) = 0
[pid 18465] old_mmap(NULL, 138416, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7fb6000
[pid 18465] mprotect(0xb7fd7000, 3248, PROT_NONE) = 0
[pid 18465] old_mmap(0xb7fd7000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x20000) = 0xb7fd7000
[pid 18465] close(5)                    = 0
[pid 18465] open("/lib/libcrypt.so.1", O_RDONLY) = 5
[pid 18465] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\220\n\0"..., 1024) = 1024
[pid 18465] fstat64(5, {st_mode=S_IFREG|0755, st_size=43933, ...}) = 0
[pid 18465] old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7fb5000
[pid 18465] old_mmap(NULL, 197728, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7f84000
[pid 18465] mprotect(0xb7f8c000, 164960, PROT_NONE) = 0
[pid 18465] old_mmap(0xb7f8c000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x8000) = 0xb7f8c000
[pid 18465] old_mmap(0xb7f8e000, 156768, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7f8e000
[pid 18465] close(5)                    = 0
[pid 18465] open("/lib/libc.so.6", O_RDONLY) = 5
[pid 18465] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0pY\1\000"..., 1024) = 1024
[pid 18465] fstat64(5, {st_mode=S_IFREG|0755, st_size=1491599, ...}) = 0
[pid 18465] old_mmap(NULL, 1268004, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7e4e000
[pid 18465] mprotect(0xb7f7d000, 26916, PROT_NONE) = 0
[pid 18465] old_mmap(0xb7f7d000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x12f000) = 0xb7f7d000
[pid 18465] old_mmap(0xb7f81000, 10532, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7f81000
[pid 18465] close(5)                    = 0
[pid 18465] uname({sys="Linux", node="kchtn", ...}) = 0
[pid 18465] open("/lib/modules/2.6.23.9-default/modules.dep", O_RDONLY) = 5
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 256
[pid 18465] lseek(5, 62, SEEK_SET)      = 62
[pid 18465] brk(0)                      = 0x817b000
[pid 18465] brk(0x817c000)              = 0x817c000
[pid 18465] brk(0)                      = 0x817c000
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 318
[pid 18465] lseek(5, 126, SEEK_SET)     = 126
[pid 18465] read(5, "\n/lib/modules/2.6.23.9-default/k"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 382
[pid 18465] lseek(5, 127, SEEK_SET)     = 127
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 383
[pid 18465] lseek(5, 192, SEEK_SET)     = 192
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 448
[pid 18465] lseek(5, 251, SEEK_SET)     = 251
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 507
[pid 18465] lseek(5, 313, SEEK_SET)     = 313
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 569
[pid 18465] lseek(5, 371, SEEK_SET)     = 371
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 627
[pid 18465] lseek(5, 493, SEEK_SET)     = 493
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 749
[pid 18465] lseek(5, 558, SEEK_SET)     = 558
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 814
[pid 18465] lseek(5, 621, SEEK_SET)     = 621
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 877
[pid 18465] lseek(5, 686, SEEK_SET)     = 686
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 942
[pid 18465] lseek(5, 743, SEEK_SET)     = 743
[pid 18465] read(5, "\n/lib/modules/2.6.23.9-default/k"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 999
[pid 18465] lseek(5, 744, SEEK_SET)     = 744
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 1000
[pid 18465] lseek(5, 801, SEEK_SET)     = 801
[pid 18465] read(5, "\n/lib/modules/2.6.23.9-default/k"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 1057
[pid 18465] lseek(5, 802, SEEK_SET)     = 802
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 1058
[pid 18465] lseek(5, 861, SEEK_SET)     = 861
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 1117
[pid 18465] lseek(5, 933, SEEK_SET)     = 933
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 1189
[pid 18465] lseek(5, 1005, SEEK_SET)    = 1005
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 1261
[pid 18465] lseek(5, 1075, SEEK_SET)    = 1075
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 1331
[pid 18465] lseek(5, 1150, SEEK_SET)    = 1150
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 1406
[pid 18465] lseek(5, 1221, SEEK_SET)    = 1221
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 1477
[pid 18465] lseek(5, 1290, SEEK_SET)    = 1290
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 1546
[pid 18465] lseek(5, 1364, SEEK_SET)    = 1364
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 1620
[pid 18465] lseek(5, 1438, SEEK_SET)    = 1438
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 1694
[pid 18465] lseek(5, 1510, SEEK_SET)    = 1510
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 1766
[pid 18465] lseek(5, 1580, SEEK_SET)    = 1580
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 1836
[pid 18465] lseek(5, 1651, SEEK_SET)    = 1651
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 1907
[pid 18465] lseek(5, 1724, SEEK_SET)    = 1724
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 1980
[pid 18465] lseek(5, 1798, SEEK_SET)    = 1798
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 2054
[pid 18465] lseek(5, 1873, SEEK_SET)    = 1873
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 2129
[pid 18465] lseek(5, 1944, SEEK_SET)    = 1944
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 2200
[pid 18465] lseek(5, 2014, SEEK_SET)    = 2014
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 2270
[pid 18465] lseek(5, 2085, SEEK_SET)    = 2085
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 2341
[pid 18465] lseek(5, 2162, SEEK_SET)    = 2162
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 2418
[pid 18465] lseek(5, 2239, SEEK_SET)    = 2239
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 2495
[pid 18465] lseek(5, 2313, SEEK_SET)    = 2313
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 2569
[pid 18465] lseek(5, 2384, SEEK_SET)    = 2384
[pid 18465] read(5, "\n/lib/modules/2.6.23.9-default/k"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 2640
[pid 18465] lseek(5, 2385, SEEK_SET)    = 2385
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 2641
[pid 18465] lseek(5, 2457, SEEK_SET)    = 2457
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 2713
[pid 18465] lseek(5, 2604, SEEK_SET)    = 2604
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 2860
[pid 18465] lseek(5, 2751, SEEK_SET)    = 2751
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 3007
[pid 18465] lseek(5, 2829, SEEK_SET)    = 2829
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 3085
[pid 18465] lseek(5, 2907, SEEK_SET)    = 2907
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 3163
[pid 18465] lseek(5, 2984, SEEK_SET)    = 2984
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 3240
[pid 18465] lseek(5, 3061, SEEK_SET)    = 3061
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 3317
[pid 18465] lseek(5, 3132, SEEK_SET)    = 3132
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 3388
[pid 18465] lseek(5, 3203, SEEK_SET)    = 3203
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 3459
[pid 18465] lseek(5, 3278, SEEK_SET)    = 3278
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 3534
[pid 18465] lseek(5, 3336, SEEK_SET)    = 3336
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 3592
[pid 18465] lseek(5, 3397, SEEK_SET)    = 3397
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 3653
[pid 18465] lseek(5, 3460, SEEK_SET)    = 3460
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 3716
[pid 18465] lseek(5, 3519, SEEK_SET)    = 3519
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 3775
[pid 18465] lseek(5, 3578, SEEK_SET)    = 3578
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 3834
[pid 18465] lseek(5, 3637, SEEK_SET)    = 3637
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 3893
[pid 18465] lseek(5, 3699, SEEK_SET)    = 3699
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 3955
[pid 18465] lseek(5, 3759, SEEK_SET)    = 3759
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 4015
[pid 18465] lseek(5, 3819, SEEK_SET)    = 3819
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 4075
[pid 18465] lseek(5, 3878, SEEK_SET)    = 3878
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 4134
[pid 18465] lseek(5, 3941, SEEK_SET)    = 3941
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 4197
[pid 18465] lseek(5, 4001, SEEK_SET)    = 4001
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 4257
[pid 18465] lseek(5, 4060, SEEK_SET)    = 4060
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 4316
[pid 18465] lseek(5, 4119, SEEK_SET)    = 4119
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 4375
[pid 18465] lseek(5, 4178, SEEK_SET)    = 4178
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 4434
[pid 18465] lseek(5, 4238, SEEK_SET)    = 4238
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 4494
[pid 18465] lseek(5, 4295, SEEK_SET)    = 4295
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 4551
[pid 18465] lseek(5, 4348, SEEK_SET)    = 4348
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 4604
[pid 18465] lseek(5, 4419, SEEK_SET)    = 4419
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 4675
[pid 18465] lseek(5, 4490, SEEK_SET)    = 4490
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 222
[pid 18465] lseek(5, 0, SEEK_CUR)       = 4712
[pid 18465] lseek(5, 4548, SEEK_SET)    = 4548
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 164
[pid 18465] lseek(5, 0, SEEK_CUR)       = 4712
[pid 18465] lseek(5, 4604, SEEK_SET)    = 4604
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 108
[pid 18465] lseek(5, 0, SEEK_CUR)       = 4712
[pid 18465] lseek(5, 4660, SEEK_SET)    = 4660
[pid 18465] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 52
[pid 18465] lseek(5, 0, SEEK_CUR)       = 4712
[pid 18465] lseek(5, 4712, SEEK_SET)    = 4712
[pid 18465] read(5, "", 256)            = 0
[pid 18465] close(5)                    = 0
[pid 18465] open("/etc/modules.conf", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18465] open("/etc/conf.modules", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18465] open("/proc/modules", O_RDONLY) = 5
[pid 18465] read(5, "ebt_ip 2208 2 - Live 0xdc86b000\n"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 256
[pid 18465] lseek(5, 32, SEEK_SET)      = 32
[pid 18465] read(5, "ebtable_nat 2144 1 - Live 0xdc83"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 288
[pid 18465] lseek(5, 69, SEEK_SET)      = 69
[pid 18465] read(5, "ebtables 17088 2 ebt_ip,ebtable_"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 325
[pid 18465] lseek(5, 122, SEEK_SET)     = 122
[pid 18465] read(5, "sch_sfq 4928 40 - Live 0xdc85c00"..., 256) = 256
[pid 18465] lseek(5, 0, SEEK_CUR)       = 378
[pid 18465] lseek(5, 156, SEEK_SET)     = 156
[pid 18465] read(5, "cls_fw 3808 1 - Live 0xdc81c000\n"..., 256) = 227
[pid 18465] lseek(5, 0, SEEK_CUR)       = 383
[pid 18465] lseek(5, 188, SEEK_SET)     = 188
[pid 18465] read(5, "cls_u32 6244 1 - Live 0xdc84c000"..., 256) = 195
[pid 18465] lseek(5, 0, SEEK_CUR)       = 383
[pid 18465] lseek(5, 221, SEEK_SET)     = 221
[pid 18465] read(5, "sch_htb 13920 2 - Live 0xdc86200"..., 256) = 162
[pid 18465] lseek(5, 0, SEEK_CUR)       = 383
[pid 18465] lseek(5, 255, SEEK_SET)     = 255
[pid 18465] read(5, "tun 7872 0 - Live 0xdc849000\n802"..., 256) = 128
[pid 18465] lseek(5, 0, SEEK_CUR)       = 383
[pid 18465] lseek(5, 284, SEEK_SET)     = 284
[pid 18465] read(5, "8021q 17224 0 - Live 0xdc850000\n"..., 256) = 99
[pid 18465] lseek(5, 0, SEEK_CUR)       = 383
[pid 18465] lseek(5, 316, SEEK_SET)     = 316
[pid 18465] read(5, "8139too 22032 0 - Live 0xdc84200"..., 256) = 67
[pid 18465] lseek(5, 0, SEEK_CUR)       = 383
[pid 18465] lseek(5, 350, SEEK_SET)     = 350
[pid 18465] read(5, "cramfs 39796 6 - Live 0xdc820000"..., 256) = 33
[pid 18465] lseek(5, 0, SEEK_CUR)       = 383
[pid 18465] lseek(5, 383, SEEK_SET)     = 383
[pid 18465] read(5, "", 256)            = 0
[pid 18465] close(5)                    = 0
[pid 18465] rt_sigaction(SIGINT, {SIG_IGN}, {SIG_DFL}, 8) = 0
[pid 18465] rt_sigaction(SIGQUIT, {SIG_IGN}, {SIG_DFL}, 8) = 0
[pid 18465] rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
[pid 18465] fork()                      = 18466
[pid 18465] wait4(18466,  <unfinished ...>
[pid 18466] rt_sigaction(SIGINT, {SIG_DFL}, NULL, 8) = 0
[pid 18466] rt_sigaction(SIGQUIT, {SIG_DFL}, NULL, 8) = 0
[pid 18466] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 18466] execve("/bin/sh", ["sh", "-c", "insmod   -q ip_tables "], [/* 14 vars */]) = 0
[pid 18466] uname({sys="Linux", node="kchtn", ...}) = 0
[pid 18466] brk(0)                      = 0x817b000
[pid 18466] open("/etc/ld.so.preload", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18466] open("/lib/i686/mmx/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18466] stat64("/lib/i686/mmx", 0xbfb93e40) = -1 ENOENT (No such file or directory)
[pid 18466] open("/lib/i686/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18466] stat64("/lib/i686", 0xbfb93e40) = -1 ENOENT (No such file or directory)
[pid 18466] open("/lib/mmx/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18466] stat64("/lib/mmx", 0xbfb93e40) = -1 ENOENT (No such file or directory)
[pid 18466] open("/lib/libm.so.6", O_RDONLY) = 5
[pid 18466] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\3605\0"..., 1024) = 1024
[pid 18466] fstat64(5, {st_mode=S_IFREG|0755, st_size=184056, ...}) = 0
[pid 18466] old_mmap(NULL, 138416, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7f92000
[pid 18466] mprotect(0xb7fb3000, 3248, PROT_NONE) = 0
[pid 18466] old_mmap(0xb7fb3000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x20000) = 0xb7fb3000
[pid 18466] close(5)                    = 0
[pid 18466] open("/lib/libcrypt.so.1", O_RDONLY) = 5
[pid 18466] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\220\n\0"..., 1024) = 1024
[pid 18466] fstat64(5, {st_mode=S_IFREG|0755, st_size=43933, ...}) = 0
[pid 18466] old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f91000
[pid 18466] old_mmap(NULL, 197728, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7f60000
[pid 18466] mprotect(0xb7f68000, 164960, PROT_NONE) = 0
[pid 18466] old_mmap(0xb7f68000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x8000) = 0xb7f68000
[pid 18466] old_mmap(0xb7f6a000, 156768, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7f6a000
[pid 18466] close(5)                    = 0
[pid 18466] open("/lib/libc.so.6", O_RDONLY) = 5
[pid 18466] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0pY\1\000"..., 1024) = 1024
[pid 18466] fstat64(5, {st_mode=S_IFREG|0755, st_size=1491599, ...}) = 0
[pid 18466] old_mmap(NULL, 1268004, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7e2a000
[pid 18466] mprotect(0xb7f59000, 26916, PROT_NONE) = 0
[pid 18466] old_mmap(0xb7f59000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x12f000) = 0xb7f59000
[pid 18466] old_mmap(0xb7f5d000, 10532, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7f5d000
[pid 18466] close(5)                    = 0
[pid 18466] getpid()                    = 18466
[pid 18466] rt_sigaction(SIGCHLD, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 18466] geteuid32()                 = 0
[pid 18466] brk(0)                      = 0x817b000
[pid 18466] brk(0x817c000)              = 0x817c000
[pid 18466] brk(0)                      = 0x817c000
[pid 18466] getppid()                   = 18465
[pid 18466] brk(0)                      = 0x817c000
[pid 18466] brk(0x817d000)              = 0x817d000
[pid 18466] getcwd("/root", 4096)       = 6
[pid 18466] rt_sigaction(SIGINT, NULL, {SIG_DFL}, 8) = 0
[pid 18466] rt_sigaction(SIGINT, {0x807ecd1, ~[], SA_RESTORER, 0xb7e535c8}, NULL, 8) = 0
[pid 18466] rt_sigaction(SIGQUIT, NULL, {SIG_DFL}, 8) = 0
[pid 18466] rt_sigaction(SIGQUIT, {SIG_DFL}, NULL, 8) = 0
[pid 18466] rt_sigaction(SIGTERM, NULL, {SIG_DFL}, 8) = 0
[pid 18466] rt_sigaction(SIGTERM, {SIG_DFL}, NULL, 8) = 0
[pid 18466] stat64("/bin/insmod", 0xbfb94634) = -1 ENOENT (No such file or directory)
[pid 18466] stat64("/sbin/insmod", {st_mode=S_IFREG|0755, st_size=358124, ...}) = 0
[pid 18466] fork()                      = 18467
[pid 18466] wait4(-1,  <unfinished ...>
[pid 18467] execve("/sbin/insmod", ["insmod", "-q", "ip_tables"], [/* 14 vars */]) = 0
[pid 18467] uname({sys="Linux", node="kchtn", ...}) = 0
[pid 18467] brk(0)                      = 0x817b000
[pid 18467] open("/etc/ld.so.preload", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18467] open("/lib/i686/mmx/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18467] stat64("/lib/i686/mmx", 0xbfc72f20) = -1 ENOENT (No such file or directory)
[pid 18467] open("/lib/i686/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18467] stat64("/lib/i686", 0xbfc72f20) = -1 ENOENT (No such file or directory)
[pid 18467] open("/lib/mmx/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18467] stat64("/lib/mmx", 0xbfc72f20) = -1 ENOENT (No such file or directory)
[pid 18467] open("/lib/libm.so.6", O_RDONLY) = 5
[pid 18467] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\3605\0"..., 1024) = 1024
[pid 18467] fstat64(5, {st_mode=S_IFREG|0755, st_size=184056, ...}) = 0
[pid 18467] old_mmap(NULL, 138416, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7f24000
[pid 18467] mprotect(0xb7f45000, 3248, PROT_NONE) = 0
[pid 18467] old_mmap(0xb7f45000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x20000) = 0xb7f45000
[pid 18467] close(5)                    = 0
[pid 18467] open("/lib/libcrypt.so.1", O_RDONLY) = 5
[pid 18467] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\220\n\0"..., 1024) = 1024
[pid 18467] fstat64(5, {st_mode=S_IFREG|0755, st_size=43933, ...}) = 0
[pid 18467] old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f23000
[pid 18467] old_mmap(NULL, 197728, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7ef2000
[pid 18467] mprotect(0xb7efa000, 164960, PROT_NONE) = 0
[pid 18467] old_mmap(0xb7efa000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x8000) = 0xb7efa000
[pid 18467] old_mmap(0xb7efc000, 156768, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7efc000
[pid 18467] close(5)                    = 0
[pid 18467] open("/lib/libc.so.6", O_RDONLY) = 5
[pid 18467] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0pY\1\000"..., 1024) = 1024
[pid 18467] fstat64(5, {st_mode=S_IFREG|0755, st_size=1491599, ...}) = 0
[pid 18467] old_mmap(NULL, 1268004, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7dbc000
[pid 18467] mprotect(0xb7eeb000, 26916, PROT_NONE) = 0
[pid 18467] old_mmap(0xb7eeb000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x12f000) = 0xb7eeb000
[pid 18467] old_mmap(0xb7eef000, 10532, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7eef000
[pid 18467] close(5)                    = 0
[pid 18467] brk(0)                      = 0x817b000
[pid 18467] brk(0x817c000)              = 0x817c000
[pid 18467] brk(0)                      = 0x817c000
[pid 18467] uname({sys="Linux", node="kchtn", ...}) = 0
[pid 18467] stat64("ip_tables", 0xbfc71560) = -1 ENOENT (No such file or directory)
[pid 18467] lstat64("/lib", {st_mode=S_IFDIR|0755, st_size=220, ...}) = 0
[pid 18467] lstat64("/lib/modules", {st_mode=S_IFDIR|0755, st_size=28, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default", {st_mode=S_IFDIR|0755, st_size=44, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default", {st_mode=S_IFDIR|0755, st_size=44, ...}) = 0
[pid 18467] open("/dev/null", O_RDONLY|O_NONBLOCK|O_DIRECTORY) = -1 ENOTDIR (Not a directory)
[pid 18467] open("/lib/modules/2.6.23.9-default", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 5
[pid 18467] fstat64(5, {st_mode=S_IFDIR|0755, st_size=44, ...}) = 0
[pid 18467] fcntl64(5, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] brk(0)                      = 0x817c000
[pid 18467] brk(0x817d000)              = 0x817d000
[pid 18467] getdents64(5, /* 2 entries */, 4096) = 64
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel", {st_mode=S_IFDIR|0755, st_size=68, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 6
[pid 18467] fstat64(6, {st_mode=S_IFDIR|0755, st_size=68, ...}) = 0
[pid 18467] fcntl64(6, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] brk(0)                      = 0x817d000
[pid 18467] brk(0x817e000)              = 0x817e000
[pid 18467] getdents64(6, /* 4 entries */, 4096) = 104
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers", {st_mode=S_IFDIR|0755, st_size=64, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/drivers", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 7
[pid 18467] fstat64(7, {st_mode=S_IFDIR|0755, st_size=64, ...}) = 0
[pid 18467] fcntl64(7, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] brk(0)                      = 0x817e000
[pid 18467] brk(0x817f000)              = 0x817f000
[pid 18467] getdents64(7, /* 4 entries */, 4096) = 96
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi", {st_mode=S_IFDIR|0755, st_size=184, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/drivers/acpi", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18467] fstat64(8, {st_mode=S_IFDIR|0755, st_size=184, ...}) = 0
[pid 18467] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] brk(0)                      = 0x817f000
[pid 18467] brk(0x8180000)              = 0x8180000
[pid 18467] getdents64(8, /* 8 entries */, 4096) = 256
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/ac.ko", {st_mode=S_IFREG|0644, st_size=6132, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/asus_acpi.ko", {st_mode=S_IFREG|0644, st_size=21711, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/battery.ko", {st_mode=S_IFREG|0644, st_size=14467, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/button.ko", {st_mode=S_IFREG|0644, st_size=9165, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/container.ko", {st_mode=S_IFREG|0644, st_size=5791, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/fan.ko", {st_mode=S_IFREG|0644, st_size=6034, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/processor.ko", {st_mode=S_IFREG|0644, st_size=34510, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/thermal.ko", {st_mode=S_IFREG|0644, st_size=21465, ...}) = 0
[pid 18467] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18467] close(8)                    = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/char", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/drivers/char", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18467] fstat64(8, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18467] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18467] close(8)                    = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net", {st_mode=S_IFDIR|0755, st_size=268, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/drivers/net", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18467] fstat64(8, {st_mode=S_IFDIR|0755, st_size=268, ...}) = 0
[pid 18467] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(8, /* 11 entries */, 4096) = 384
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/8139too.ko", {st_mode=S_IFREG|0755, st_size=29763, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/bsd_comp.ko", {st_mode=S_IFREG|0644, st_size=6735, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/dummy.ko", {st_mode=S_IFREG|0755, st_size=4402, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/netconsole.ko", {st_mode=S_IFREG|0644, st_size=4059, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_async.ko", {st_mode=S_IFREG|0755, st_size=10569, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_deflate.ko", {st_mode=S_IFREG|0755, st_size=6468, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_generic.ko", {st_mode=S_IFREG|0755, st_size=24315, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_mppe.ko", {st_mode=S_IFREG|0755, st_size=8202, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_synctty.ko", {st_mode=S_IFREG|0755, st_size=9096, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/slhc.ko", {st_mode=S_IFREG|0755, st_size=6592, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/tun.ko", {st_mode=S_IFREG|0755, st_size=10595, ...}) = 0
[pid 18467] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18467] close(8)                    = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/usb", {st_mode=S_IFDIR|0755, st_size=16, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/drivers/usb", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18467] fstat64(8, {st_mode=S_IFDIR|0755, st_size=16, ...}) = 0
[pid 18467] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(8, /* 1 entries */, 4096) = 24
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/usb/net", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/drivers/usb/net", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18467] fstat64(9, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18467] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] brk(0)                      = 0x8180000
[pid 18467] brk(0x8181000)              = 0x8181000
[pid 18467] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18467] close(9)                    = 0
[pid 18467] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18467] close(8)                    = 0
[pid 18467] getdents64(7, /* 0 entries */, 4096) = 0
[pid 18467] close(7)                    = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/fs", {st_mode=S_IFDIR|0755, st_size=96, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/fs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 7
[pid 18467] fstat64(7, {st_mode=S_IFDIR|0755, st_size=96, ...}) = 0
[pid 18467] fcntl64(7, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(7, /* 5 entries */, 4096) = 152
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/cramfs", {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/fs/cramfs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18467] fstat64(8, {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18467] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(8, /* 1 entries */, 4096) = 32
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/cramfs/cramfs.ko", {st_mode=S_IFREG|0755, st_size=9380, ...}) = 0
[pid 18467] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18467] close(8)                    = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/isofs", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/fs/isofs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18467] fstat64(8, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18467] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18467] close(8)                    = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/reiserfs", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/fs/reiserfs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18467] fstat64(8, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18467] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18467] close(8)                    = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/smbfs", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/fs/smbfs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18467] fstat64(8, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18467] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18467] close(8)                    = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/udf", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/fs/udf", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18467] fstat64(8, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18467] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18467] close(8)                    = 0
[pid 18467] getdents64(7, /* 0 entries */, 4096) = 0
[pid 18467] close(7)                    = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/lib", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/lib", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 7
[pid 18467] fstat64(7, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18467] fcntl64(7, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(7, /* 0 entries */, 4096) = 0
[pid 18467] close(7)                    = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net", {st_mode=S_IFDIR|0755, st_size=108, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/net", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 7
[pid 18467] fstat64(7, {st_mode=S_IFDIR|0755, st_size=108, ...}) = 0
[pid 18467] fcntl64(7, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(7, /* 6 entries */, 4096) = 168
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/8021q", {st_mode=S_IFDIR|0755, st_size=20, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/net/8021q", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18467] fstat64(8, {st_mode=S_IFDIR|0755, st_size=20, ...}) = 0
[pid 18467] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(8, /* 1 entries */, 4096) = 32
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/8021q/8021q.ko", {st_mode=S_IFREG|0755, st_size=21970, ...}) = 0
[pid 18467] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18467] close(8)                    = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/atm", {st_mode=S_IFDIR|0755, st_size=64, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/net/atm", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18467] fstat64(8, {st_mode=S_IFDIR|0755, st_size=64, ...}) = 0
[pid 18467] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(8, /* 3 entries */, 4096) = 96
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/atm/atm.ko", {st_mode=S_IFREG|0755, st_size=45039, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/atm/br2684.ko", {st_mode=S_IFREG|0755, st_size=9197, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/atm/clip.ko", {st_mode=S_IFREG|0755, st_size=14837, ...}) = 0
[pid 18467] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18467] close(8)                    = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge", {st_mode=S_IFDIR|0755, st_size=48, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/net/bridge", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18467] fstat64(8, {st_mode=S_IFDIR|0755, st_size=48, ...}) = 0
[pid 18467] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(8, /* 2 entries */, 4096) = 64
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/bridge.ko", {st_mode=S_IFREG|0755, st_size=58477, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter", {st_mode=S_IFDIR|0755, st_size=572, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18467] fstat64(9, {st_mode=S_IFDIR|0755, st_size=572, ...}) = 0
[pid 18467] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(9, /* 22 entries */, 4096) = 776
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_802_3.ko", {st_mode=S_IFREG|0755, st_size=2837, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_among.ko", {st_mode=S_IFREG|0755, st_size=4508, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_arp.ko", {st_mode=S_IFREG|0755, st_size=3726, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_arpreply.ko", {st_mode=S_IFREG|0755, st_size=3416, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_dnat.ko", {st_mode=S_IFREG|0755, st_size=3221, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_ip.ko", {st_mode=S_IFREG|0755, st_size=3439, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_ipdaddr.ko", {st_mode=S_IFREG|0755, st_size=4409, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_ipsaddr.ko", {st_mode=S_IFREG|0755, st_size=4409, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_limit.ko", {st_mode=S_IFREG|0755, st_size=3369, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_log.ko", {st_mode=S_IFREG|0755, st_size=5332, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_mark.ko", {st_mode=S_IFREG|0755, st_size=2839, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_mark_m.ko", {st_mode=S_IFREG|0755, st_size=2774, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_pkttype.ko", {st_mode=S_IFREG|0755, st_size=2723, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_redirect.ko", {st_mode=S_IFREG|0755, st_size=3288, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_snat.ko", {st_mode=S_IFREG|0755, st_size=3378, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_stp.ko", {st_mode=S_IFREG|0755, st_size=3992, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_ulog.ko", {st_mode=S_IFREG|0755, st_size=7733, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_vlan.ko", {st_mode=S_IFREG|0755, st_size=4997, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebtable_broute.ko", {st_mode=S_IFREG|0755, st_size=3234, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebtable_filter.ko", {st_mode=S_IFREG|0755, st_size=3584, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebtable_nat.ko", {st_mode=S_IFREG|0755, st_size=3613, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebtables.ko", {st_mode=S_IFREG|0755, st_size=21295, ...}) = 0
[pid 18467] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18467] close(9)                    = 0
[pid 18467] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18467] close(8)                    = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/core", {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/net/core", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18467] fstat64(8, {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18467] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(8, /* 1 entries */, 4096) = 32
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/core/pktgen.ko", {st_mode=S_IFREG|0755, st_size=44932, ...}) = 0
[pid 18467] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18467] close(8)                    = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/ipv4", {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/net/ipv4", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18467] fstat64(8, {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18467] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(8, /* 1 entries */, 4096) = 32
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/ipv4/netfilter", {st_mode=S_IFDIR|0755, st_size=28, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/net/ipv4/netfilter", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18467] fstat64(9, {st_mode=S_IFDIR|0755, st_size=28, ...}) = 0
[pid 18467] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(9, /* 1 entries */, 4096) = 40
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/ipv4/netfilter/ipt_CLUSTERIP.ko", {st_mode=S_IFREG|0755, st_size=9564, ...}) = 0
[pid 18467] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18467] close(9)                    = 0
[pid 18467] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18467] close(8)                    = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched", {st_mode=S_IFDIR|0755, st_size=648, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/net/sched", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18467] fstat64(8, {st_mode=S_IFDIR|0755, st_size=648, ...}) = 0
[pid 18467] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(8, /* 26 entries */, 4096) = 880
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_gact.ko", {st_mode=S_IFREG|0755, st_size=4973, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_ipt.ko", {st_mode=S_IFREG|0755, st_size=6243, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_mirred.ko", {st_mode=S_IFREG|0755, st_size=5582, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_pedit.ko", {st_mode=S_IFREG|0755, st_size=5510, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_police.ko", {st_mode=S_IFREG|0755, st_size=6451, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_simple.ko", {st_mode=S_IFREG|0755, st_size=5001, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_basic.ko", {st_mode=S_IFREG|0755, st_size=5729, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_fw.ko", {st_mode=S_IFREG|0755, st_size=5396, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_route.ko", {st_mode=S_IFREG|0755, st_size=7185, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_rsvp.ko", {st_mode=S_IFREG|0755, st_size=7095, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_tcindex.ko", {st_mode=S_IFREG|0755, st_size=7627, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_u32.ko", {st_mode=S_IFREG|0755, st_size=8276, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_atm.ko", {st_mode=S_IFREG|0755, st_size=8177, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_cbq.ko", {st_mode=S_IFREG|0755, st_size=16919, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_csz.ko", {st_mode=S_IFREG|0755, st_size=8449, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_dsmark.ko", {st_mode=S_IFREG|0755, st_size=6721, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_gred.ko", {st_mode=S_IFREG|0755, st_size=8798, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_hfsc.ko", {st_mode=S_IFREG|0755, st_size=18166, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_htb.ko", {st_mode=S_IFREG|0755, st_size=16942, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_ingress.ko", {st_mode=S_IFREG|0755, st_size=4347, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_netem.ko", {st_mode=S_IFREG|0755, st_size=8878, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_prio.ko", {st_mode=S_IFREG|0755, st_size=6453, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_red.ko", {st_mode=S_IFREG|0755, st_size=6816, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_sfq.ko", {st_mode=S_IFREG|0755, st_size=6416, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_tbf.ko", {st_mode=S_IFREG|0755, st_size=6140, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_teql.ko", {st_mode=S_IFREG|0755, st_size=7072, ...}) = 0
[pid 18467] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18467] close(8)                    = 0
[pid 18467] getdents64(7, /* 0 entries */, 4096) = 0
[pid 18467] close(7)                    = 0
[pid 18467] getdents64(6, /* 0 entries */, 4096) = 0
[pid 18467] close(6)                    = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/modules.dep", {st_mode=S_IFREG|0755, st_size=4712, ...}) = 0
[pid 18467] getdents64(5, /* 0 entries */, 4096) = 0
[pid 18467] close(5)                    = 0
[pid 18467] lstat64("/lib", {st_mode=S_IFDIR|0755, st_size=220, ...}) = 0
[pid 18467] lstat64("/lib/modules", {st_mode=S_IFDIR|0755, st_size=28, ...}) = 0
[pid 18467] lstat64("/lib/modules", {st_mode=S_IFDIR|0755, st_size=28, ...}) = 0
[pid 18467] open("/lib/modules", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 5
[pid 18467] fstat64(5, {st_mode=S_IFDIR|0755, st_size=28, ...}) = 0
[pid 18467] fcntl64(5, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(5, /* 1 entries */, 4096) = 40
[pid 18467] lstat64("/lib/modules/2.6.23.9-default", {st_mode=S_IFDIR|0755, st_size=44, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 6
[pid 18467] fstat64(6, {st_mode=S_IFDIR|0755, st_size=44, ...}) = 0
[pid 18467] fcntl64(6, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(6, /* 2 entries */, 4096) = 64
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel", {st_mode=S_IFDIR|0755, st_size=68, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 7
[pid 18467] fstat64(7, {st_mode=S_IFDIR|0755, st_size=68, ...}) = 0
[pid 18467] fcntl64(7, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(7, /* 4 entries */, 4096) = 104
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers", {st_mode=S_IFDIR|0755, st_size=64, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/drivers", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18467] fstat64(8, {st_mode=S_IFDIR|0755, st_size=64, ...}) = 0
[pid 18467] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(8, /* 4 entries */, 4096) = 96
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi", {st_mode=S_IFDIR|0755, st_size=184, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/drivers/acpi", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18467] fstat64(9, {st_mode=S_IFDIR|0755, st_size=184, ...}) = 0
[pid 18467] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(9, /* 8 entries */, 4096) = 256
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/ac.ko", {st_mode=S_IFREG|0644, st_size=6132, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/asus_acpi.ko", {st_mode=S_IFREG|0644, st_size=21711, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/battery.ko", {st_mode=S_IFREG|0644, st_size=14467, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/button.ko", {st_mode=S_IFREG|0644, st_size=9165, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/container.ko", {st_mode=S_IFREG|0644, st_size=5791, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/fan.ko", {st_mode=S_IFREG|0644, st_size=6034, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/processor.ko", {st_mode=S_IFREG|0644, st_size=34510, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/thermal.ko", {st_mode=S_IFREG|0644, st_size=21465, ...}) = 0
[pid 18467] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18467] close(9)                    = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/char", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/drivers/char", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18467] fstat64(9, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18467] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18467] close(9)                    = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net", {st_mode=S_IFDIR|0755, st_size=268, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/drivers/net", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18467] fstat64(9, {st_mode=S_IFDIR|0755, st_size=268, ...}) = 0
[pid 18467] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(9, /* 11 entries */, 4096) = 384
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/8139too.ko", {st_mode=S_IFREG|0755, st_size=29763, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/bsd_comp.ko", {st_mode=S_IFREG|0644, st_size=6735, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/dummy.ko", {st_mode=S_IFREG|0755, st_size=4402, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/netconsole.ko", {st_mode=S_IFREG|0644, st_size=4059, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_async.ko", {st_mode=S_IFREG|0755, st_size=10569, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_deflate.ko", {st_mode=S_IFREG|0755, st_size=6468, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_generic.ko", {st_mode=S_IFREG|0755, st_size=24315, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_mppe.ko", {st_mode=S_IFREG|0755, st_size=8202, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_synctty.ko", {st_mode=S_IFREG|0755, st_size=9096, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/slhc.ko", {st_mode=S_IFREG|0755, st_size=6592, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/tun.ko", {st_mode=S_IFREG|0755, st_size=10595, ...}) = 0
[pid 18467] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18467] close(9)                    = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/usb", {st_mode=S_IFDIR|0755, st_size=16, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/drivers/usb", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18467] fstat64(9, {st_mode=S_IFDIR|0755, st_size=16, ...}) = 0
[pid 18467] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(9, /* 1 entries */, 4096) = 24
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/usb/net", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/drivers/usb/net", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 10
[pid 18467] fstat64(10, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18467] fcntl64(10, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] brk(0)                      = 0x8181000
[pid 18467] brk(0x8182000)              = 0x8182000
[pid 18467] getdents64(10, /* 0 entries */, 4096) = 0
[pid 18467] close(10)                   = 0
[pid 18467] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18467] close(9)                    = 0
[pid 18467] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18467] close(8)                    = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/fs", {st_mode=S_IFDIR|0755, st_size=96, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/fs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18467] fstat64(8, {st_mode=S_IFDIR|0755, st_size=96, ...}) = 0
[pid 18467] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(8, /* 5 entries */, 4096) = 152
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/cramfs", {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/fs/cramfs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18467] fstat64(9, {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18467] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(9, /* 1 entries */, 4096) = 32
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/cramfs/cramfs.ko", {st_mode=S_IFREG|0755, st_size=9380, ...}) = 0
[pid 18467] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18467] close(9)                    = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/isofs", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/fs/isofs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18467] fstat64(9, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18467] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18467] close(9)                    = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/reiserfs", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/fs/reiserfs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18467] fstat64(9, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18467] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18467] close(9)                    = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/smbfs", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/fs/smbfs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18467] fstat64(9, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18467] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18467] close(9)                    = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/udf", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/fs/udf", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18467] fstat64(9, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18467] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18467] close(9)                    = 0
[pid 18467] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18467] close(8)                    = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/lib", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/lib", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18467] fstat64(8, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18467] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18467] close(8)                    = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net", {st_mode=S_IFDIR|0755, st_size=108, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/net", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18467] fstat64(8, {st_mode=S_IFDIR|0755, st_size=108, ...}) = 0
[pid 18467] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(8, /* 6 entries */, 4096) = 168
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/8021q", {st_mode=S_IFDIR|0755, st_size=20, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/net/8021q", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18467] fstat64(9, {st_mode=S_IFDIR|0755, st_size=20, ...}) = 0
[pid 18467] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(9, /* 1 entries */, 4096) = 32
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/8021q/8021q.ko", {st_mode=S_IFREG|0755, st_size=21970, ...}) = 0
[pid 18467] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18467] close(9)                    = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/atm", {st_mode=S_IFDIR|0755, st_size=64, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/net/atm", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18467] fstat64(9, {st_mode=S_IFDIR|0755, st_size=64, ...}) = 0
[pid 18467] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(9, /* 3 entries */, 4096) = 96
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/atm/atm.ko", {st_mode=S_IFREG|0755, st_size=45039, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/atm/br2684.ko", {st_mode=S_IFREG|0755, st_size=9197, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/atm/clip.ko", {st_mode=S_IFREG|0755, st_size=14837, ...}) = 0
[pid 18467] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18467] close(9)                    = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge", {st_mode=S_IFDIR|0755, st_size=48, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/net/bridge", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18467] fstat64(9, {st_mode=S_IFDIR|0755, st_size=48, ...}) = 0
[pid 18467] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(9, /* 2 entries */, 4096) = 64
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/bridge.ko", {st_mode=S_IFREG|0755, st_size=58477, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter", {st_mode=S_IFDIR|0755, st_size=572, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 10
[pid 18467] fstat64(10, {st_mode=S_IFDIR|0755, st_size=572, ...}) = 0
[pid 18467] fcntl64(10, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(10, /* 22 entries */, 4096) = 776
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_802_3.ko", {st_mode=S_IFREG|0755, st_size=2837, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_among.ko", {st_mode=S_IFREG|0755, st_size=4508, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_arp.ko", {st_mode=S_IFREG|0755, st_size=3726, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_arpreply.ko", {st_mode=S_IFREG|0755, st_size=3416, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_dnat.ko", {st_mode=S_IFREG|0755, st_size=3221, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_ip.ko", {st_mode=S_IFREG|0755, st_size=3439, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_ipdaddr.ko", {st_mode=S_IFREG|0755, st_size=4409, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_ipsaddr.ko", {st_mode=S_IFREG|0755, st_size=4409, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_limit.ko", {st_mode=S_IFREG|0755, st_size=3369, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_log.ko", {st_mode=S_IFREG|0755, st_size=5332, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_mark.ko", {st_mode=S_IFREG|0755, st_size=2839, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_mark_m.ko", {st_mode=S_IFREG|0755, st_size=2774, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_pkttype.ko", {st_mode=S_IFREG|0755, st_size=2723, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_redirect.ko", {st_mode=S_IFREG|0755, st_size=3288, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_snat.ko", {st_mode=S_IFREG|0755, st_size=3378, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_stp.ko", {st_mode=S_IFREG|0755, st_size=3992, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_ulog.ko", {st_mode=S_IFREG|0755, st_size=7733, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_vlan.ko", {st_mode=S_IFREG|0755, st_size=4997, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebtable_broute.ko", {st_mode=S_IFREG|0755, st_size=3234, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebtable_filter.ko", {st_mode=S_IFREG|0755, st_size=3584, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebtable_nat.ko", {st_mode=S_IFREG|0755, st_size=3613, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebtables.ko", {st_mode=S_IFREG|0755, st_size=21295, ...}) = 0
[pid 18467] getdents64(10, /* 0 entries */, 4096) = 0
[pid 18467] close(10)                   = 0
[pid 18467] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18467] close(9)                    = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/core", {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/net/core", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18467] fstat64(9, {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18467] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(9, /* 1 entries */, 4096) = 32
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/core/pktgen.ko", {st_mode=S_IFREG|0755, st_size=44932, ...}) = 0
[pid 18467] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18467] close(9)                    = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/ipv4", {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/net/ipv4", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18467] fstat64(9, {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18467] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(9, /* 1 entries */, 4096) = 32
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/ipv4/netfilter", {st_mode=S_IFDIR|0755, st_size=28, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/net/ipv4/netfilter", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 10
[pid 18467] fstat64(10, {st_mode=S_IFDIR|0755, st_size=28, ...}) = 0
[pid 18467] fcntl64(10, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(10, /* 1 entries */, 4096) = 40
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/ipv4/netfilter/ipt_CLUSTERIP.ko", {st_mode=S_IFREG|0755, st_size=9564, ...}) = 0
[pid 18467] getdents64(10, /* 0 entries */, 4096) = 0
[pid 18467] close(10)                   = 0
[pid 18467] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18467] close(9)                    = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched", {st_mode=S_IFDIR|0755, st_size=648, ...}) = 0
[pid 18467] open("/lib/modules/2.6.23.9-default/kernel/net/sched", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18467] fstat64(9, {st_mode=S_IFDIR|0755, st_size=648, ...}) = 0
[pid 18467] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18467] getdents64(9, /* 26 entries */, 4096) = 880
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_gact.ko", {st_mode=S_IFREG|0755, st_size=4973, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_ipt.ko", {st_mode=S_IFREG|0755, st_size=6243, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_mirred.ko", {st_mode=S_IFREG|0755, st_size=5582, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_pedit.ko", {st_mode=S_IFREG|0755, st_size=5510, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_police.ko", {st_mode=S_IFREG|0755, st_size=6451, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_simple.ko", {st_mode=S_IFREG|0755, st_size=5001, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_basic.ko", {st_mode=S_IFREG|0755, st_size=5729, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_fw.ko", {st_mode=S_IFREG|0755, st_size=5396, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_route.ko", {st_mode=S_IFREG|0755, st_size=7185, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_rsvp.ko", {st_mode=S_IFREG|0755, st_size=7095, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_tcindex.ko", {st_mode=S_IFREG|0755, st_size=7627, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_u32.ko", {st_mode=S_IFREG|0755, st_size=8276, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_atm.ko", {st_mode=S_IFREG|0755, st_size=8177, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_cbq.ko", {st_mode=S_IFREG|0755, st_size=16919, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_csz.ko", {st_mode=S_IFREG|0755, st_size=8449, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_dsmark.ko", {st_mode=S_IFREG|0755, st_size=6721, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_gred.ko", {st_mode=S_IFREG|0755, st_size=8798, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_hfsc.ko", {st_mode=S_IFREG|0755, st_size=18166, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_htb.ko", {st_mode=S_IFREG|0755, st_size=16942, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_ingress.ko", {st_mode=S_IFREG|0755, st_size=4347, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_netem.ko", {st_mode=S_IFREG|0755, st_size=8878, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_prio.ko", {st_mode=S_IFREG|0755, st_size=6453, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_red.ko", {st_mode=S_IFREG|0755, st_size=6816, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_sfq.ko", {st_mode=S_IFREG|0755, st_size=6416, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_tbf.ko", {st_mode=S_IFREG|0755, st_size=6140, ...}) = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_teql.ko", {st_mode=S_IFREG|0755, st_size=7072, ...}) = 0
[pid 18467] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18467] close(9)                    = 0
[pid 18467] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18467] close(8)                    = 0
[pid 18467] getdents64(7, /* 0 entries */, 4096) = 0
[pid 18467] close(7)                    = 0
[pid 18467] lstat64("/lib/modules/2.6.23.9-default/modules.dep", {st_mode=S_IFREG|0755, st_size=4712, ...}) = 0
[pid 18467] getdents64(6, /* 0 entries */, 4096) = 0
[pid 18467] close(6)                    = 0
[pid 18467] getdents64(5, /* 0 entries */, 4096) = 0
[pid 18467] close(5)                    = 0
[pid 18467] write(2, "insmod: ", 8insmod: )     = 8
[pid 18467] write(2, "ip_tables.ko: no module by that "..., 42ip_tables.ko: no module by that name found) = 42
[pid 18467] write(2, "\n", 1
)           = 1
[pid 18467] exit_group(1)               = ?
[pid 18466] <... wait4 resumed> [WIFEXITED(s) && WEXITSTATUS(s) == 1], 0, NULL) = 18467
[pid 18466] --- SIGCHLD (Child exited) @ 0 (0) ---
[pid 18466] exit_group(1)               = ?
[pid 18465] <... wait4 resumed> [WIFEXITED(s) && WEXITSTATUS(s) == 1], 0, NULL) = 18466
[pid 18465] rt_sigaction(SIGINT, {SIG_DFL}, NULL, 8) = 0
[pid 18465] rt_sigaction(SIGQUIT, {SIG_DFL}, NULL, 8) = 0
[pid 18465] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 18465] --- SIGCHLD (Child exited) @ 0 (0) ---
[pid 18465] write(2, "modprobe: ", 10modprobe: )  = 10
[pid 18465] write(2, "failed to load module ip_tables", 31failed to load module ip_tables) = 31
[pid 18465] write(2, "\n", 1
)           = 1
[pid 18465] exit_group(1)               = ?
<... wait4 resumed> [WIFEXITED(s) && WEXITSTATUS(s) == 1], 0, NULL) = 18465
--- SIGCHLD (Child exited) @ 0 (0) ---
getsockopt(4, SOL_IP, 0x43 /* IP_??? */, "MARK\0\201\372\267\0h\344\267\225w\372\267\270O\240\277"..., [30]) = 0
close(4)                                = 0
socket(PF_INET, SOCK_RAW, IPPROTO_RAW)  = 4
open("/proc/sys/kernel/modprobe", O_RDONLY|O_LARGEFILE) = 5
read(5, "/sbin/modprobe\n", 1024)       = 15
close(5)                                = 0
fork()                                  = 18468
[pid 18448] wait4(-1,  <unfinished ...>
[pid 18468] execve("/sbin/modprobe", ["/sbin/modprobe", "ip_tables", "-q"], [/* 14 vars */]) = 0
[pid 18468] uname({sys="Linux", node="kchtn", ...}) = 0
[pid 18468] brk(0)                      = 0x817b000
[pid 18468] open("/etc/ld.so.preload", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18468] open("/lib/i686/mmx/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18468] stat64("/lib/i686/mmx", 0xbf8f6b90) = -1 ENOENT (No such file or directory)
[pid 18468] open("/lib/i686/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18468] stat64("/lib/i686", 0xbf8f6b90) = -1 ENOENT (No such file or directory)
[pid 18468] open("/lib/mmx/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18468] stat64("/lib/mmx", 0xbf8f6b90) = -1 ENOENT (No such file or directory)
[pid 18468] open("/lib/libm.so.6", O_RDONLY) = 5
[pid 18468] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\3605\0"..., 1024) = 1024
[pid 18468] fstat64(5, {st_mode=S_IFREG|0755, st_size=184056, ...}) = 0
[pid 18468] old_mmap(NULL, 138416, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7f49000
[pid 18468] mprotect(0xb7f6a000, 3248, PROT_NONE) = 0
[pid 18468] old_mmap(0xb7f6a000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x20000) = 0xb7f6a000
[pid 18468] close(5)                    = 0
[pid 18468] open("/lib/libcrypt.so.1", O_RDONLY) = 5
[pid 18468] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\220\n\0"..., 1024) = 1024
[pid 18468] fstat64(5, {st_mode=S_IFREG|0755, st_size=43933, ...}) = 0
[pid 18468] old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f48000
[pid 18468] old_mmap(NULL, 197728, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7f17000
[pid 18468] mprotect(0xb7f1f000, 164960, PROT_NONE) = 0
[pid 18468] old_mmap(0xb7f1f000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x8000) = 0xb7f1f000
[pid 18468] old_mmap(0xb7f21000, 156768, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7f21000
[pid 18468] close(5)                    = 0
[pid 18468] open("/lib/libc.so.6", O_RDONLY) = 5
[pid 18468] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0pY\1\000"..., 1024) = 1024
[pid 18468] fstat64(5, {st_mode=S_IFREG|0755, st_size=1491599, ...}) = 0
[pid 18468] old_mmap(NULL, 1268004, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7de1000
[pid 18468] mprotect(0xb7f10000, 26916, PROT_NONE) = 0
[pid 18468] old_mmap(0xb7f10000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x12f000) = 0xb7f10000
[pid 18468] old_mmap(0xb7f14000, 10532, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7f14000
[pid 18468] close(5)                    = 0
[pid 18468] uname({sys="Linux", node="kchtn", ...}) = 0
[pid 18468] open("/lib/modules/2.6.23.9-default/modules.dep", O_RDONLY) = 5
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 256
[pid 18468] lseek(5, 62, SEEK_SET)      = 62
[pid 18468] brk(0)                      = 0x817b000
[pid 18468] brk(0x817c000)              = 0x817c000
[pid 18468] brk(0)                      = 0x817c000
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 318
[pid 18468] lseek(5, 126, SEEK_SET)     = 126
[pid 18468] read(5, "\n/lib/modules/2.6.23.9-default/k"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 382
[pid 18468] lseek(5, 127, SEEK_SET)     = 127
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 383
[pid 18468] lseek(5, 192, SEEK_SET)     = 192
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 448
[pid 18468] lseek(5, 251, SEEK_SET)     = 251
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 507
[pid 18468] lseek(5, 313, SEEK_SET)     = 313
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 569
[pid 18468] lseek(5, 371, SEEK_SET)     = 371
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 627
[pid 18468] lseek(5, 493, SEEK_SET)     = 493
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 749
[pid 18468] lseek(5, 558, SEEK_SET)     = 558
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 814
[pid 18468] lseek(5, 621, SEEK_SET)     = 621
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 877
[pid 18468] lseek(5, 686, SEEK_SET)     = 686
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 942
[pid 18468] lseek(5, 743, SEEK_SET)     = 743
[pid 18468] read(5, "\n/lib/modules/2.6.23.9-default/k"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 999
[pid 18468] lseek(5, 744, SEEK_SET)     = 744
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 1000
[pid 18468] lseek(5, 801, SEEK_SET)     = 801
[pid 18468] read(5, "\n/lib/modules/2.6.23.9-default/k"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 1057
[pid 18468] lseek(5, 802, SEEK_SET)     = 802
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 1058
[pid 18468] lseek(5, 861, SEEK_SET)     = 861
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 1117
[pid 18468] lseek(5, 933, SEEK_SET)     = 933
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 1189
[pid 18468] lseek(5, 1005, SEEK_SET)    = 1005
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 1261
[pid 18468] lseek(5, 1075, SEEK_SET)    = 1075
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 1331
[pid 18468] lseek(5, 1150, SEEK_SET)    = 1150
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 1406
[pid 18468] lseek(5, 1221, SEEK_SET)    = 1221
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 1477
[pid 18468] lseek(5, 1290, SEEK_SET)    = 1290
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 1546
[pid 18468] lseek(5, 1364, SEEK_SET)    = 1364
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 1620
[pid 18468] lseek(5, 1438, SEEK_SET)    = 1438
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 1694
[pid 18468] lseek(5, 1510, SEEK_SET)    = 1510
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 1766
[pid 18468] lseek(5, 1580, SEEK_SET)    = 1580
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 1836
[pid 18468] lseek(5, 1651, SEEK_SET)    = 1651
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 1907
[pid 18468] lseek(5, 1724, SEEK_SET)    = 1724
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 1980
[pid 18468] lseek(5, 1798, SEEK_SET)    = 1798
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 2054
[pid 18468] lseek(5, 1873, SEEK_SET)    = 1873
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 2129
[pid 18468] lseek(5, 1944, SEEK_SET)    = 1944
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 2200
[pid 18468] lseek(5, 2014, SEEK_SET)    = 2014
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 2270
[pid 18468] lseek(5, 2085, SEEK_SET)    = 2085
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 2341
[pid 18468] lseek(5, 2162, SEEK_SET)    = 2162
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 2418
[pid 18468] lseek(5, 2239, SEEK_SET)    = 2239
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 2495
[pid 18468] lseek(5, 2313, SEEK_SET)    = 2313
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 2569
[pid 18468] lseek(5, 2384, SEEK_SET)    = 2384
[pid 18468] read(5, "\n/lib/modules/2.6.23.9-default/k"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 2640
[pid 18468] lseek(5, 2385, SEEK_SET)    = 2385
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 2641
[pid 18468] lseek(5, 2457, SEEK_SET)    = 2457
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 2713
[pid 18468] lseek(5, 2604, SEEK_SET)    = 2604
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 2860
[pid 18468] lseek(5, 2751, SEEK_SET)    = 2751
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 3007
[pid 18468] lseek(5, 2829, SEEK_SET)    = 2829
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 3085
[pid 18468] lseek(5, 2907, SEEK_SET)    = 2907
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 3163
[pid 18468] lseek(5, 2984, SEEK_SET)    = 2984
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 3240
[pid 18468] lseek(5, 3061, SEEK_SET)    = 3061
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 3317
[pid 18468] lseek(5, 3132, SEEK_SET)    = 3132
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 3388
[pid 18468] lseek(5, 3203, SEEK_SET)    = 3203
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 3459
[pid 18468] lseek(5, 3278, SEEK_SET)    = 3278
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 3534
[pid 18468] lseek(5, 3336, SEEK_SET)    = 3336
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 3592
[pid 18468] lseek(5, 3397, SEEK_SET)    = 3397
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 3653
[pid 18468] lseek(5, 3460, SEEK_SET)    = 3460
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 3716
[pid 18468] lseek(5, 3519, SEEK_SET)    = 3519
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 3775
[pid 18468] lseek(5, 3578, SEEK_SET)    = 3578
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 3834
[pid 18468] lseek(5, 3637, SEEK_SET)    = 3637
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 3893
[pid 18468] lseek(5, 3699, SEEK_SET)    = 3699
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 3955
[pid 18468] lseek(5, 3759, SEEK_SET)    = 3759
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 4015
[pid 18468] lseek(5, 3819, SEEK_SET)    = 3819
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 4075
[pid 18468] lseek(5, 3878, SEEK_SET)    = 3878
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 4134
[pid 18468] lseek(5, 3941, SEEK_SET)    = 3941
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 4197
[pid 18468] lseek(5, 4001, SEEK_SET)    = 4001
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 4257
[pid 18468] lseek(5, 4060, SEEK_SET)    = 4060
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 4316
[pid 18468] lseek(5, 4119, SEEK_SET)    = 4119
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 4375
[pid 18468] lseek(5, 4178, SEEK_SET)    = 4178
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 4434
[pid 18468] lseek(5, 4238, SEEK_SET)    = 4238
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 4494
[pid 18468] lseek(5, 4295, SEEK_SET)    = 4295
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 4551
[pid 18468] lseek(5, 4348, SEEK_SET)    = 4348
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 4604
[pid 18468] lseek(5, 4419, SEEK_SET)    = 4419
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 4675
[pid 18468] lseek(5, 4490, SEEK_SET)    = 4490
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 222
[pid 18468] lseek(5, 0, SEEK_CUR)       = 4712
[pid 18468] lseek(5, 4548, SEEK_SET)    = 4548
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 164
[pid 18468] lseek(5, 0, SEEK_CUR)       = 4712
[pid 18468] lseek(5, 4604, SEEK_SET)    = 4604
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 108
[pid 18468] lseek(5, 0, SEEK_CUR)       = 4712
[pid 18468] lseek(5, 4660, SEEK_SET)    = 4660
[pid 18468] read(5, "/lib/modules/2.6.23.9-default/ke"..., 256) = 52
[pid 18468] lseek(5, 0, SEEK_CUR)       = 4712
[pid 18468] lseek(5, 4712, SEEK_SET)    = 4712
[pid 18468] read(5, "", 256)            = 0
[pid 18468] close(5)                    = 0
[pid 18468] open("/etc/modules.conf", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18468] open("/etc/conf.modules", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18468] open("/proc/modules", O_RDONLY) = 5
[pid 18468] read(5, "ebt_ip 2208 2 - Live 0xdc86b000\n"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 256
[pid 18468] lseek(5, 32, SEEK_SET)      = 32
[pid 18468] read(5, "ebtable_nat 2144 1 - Live 0xdc83"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 288
[pid 18468] lseek(5, 69, SEEK_SET)      = 69
[pid 18468] read(5, "ebtables 17088 2 ebt_ip,ebtable_"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 325
[pid 18468] lseek(5, 122, SEEK_SET)     = 122
[pid 18468] read(5, "sch_sfq 4928 40 - Live 0xdc85c00"..., 256) = 256
[pid 18468] lseek(5, 0, SEEK_CUR)       = 378
[pid 18468] lseek(5, 156, SEEK_SET)     = 156
[pid 18468] read(5, "cls_fw 3808 1 - Live 0xdc81c000\n"..., 256) = 227
[pid 18468] lseek(5, 0, SEEK_CUR)       = 383
[pid 18468] lseek(5, 188, SEEK_SET)     = 188
[pid 18468] read(5, "cls_u32 6244 1 - Live 0xdc84c000"..., 256) = 195
[pid 18468] lseek(5, 0, SEEK_CUR)       = 383
[pid 18468] lseek(5, 221, SEEK_SET)     = 221
[pid 18468] read(5, "sch_htb 13920 2 - Live 0xdc86200"..., 256) = 162
[pid 18468] lseek(5, 0, SEEK_CUR)       = 383
[pid 18468] lseek(5, 255, SEEK_SET)     = 255
[pid 18468] read(5, "tun 7872 0 - Live 0xdc849000\n802"..., 256) = 128
[pid 18468] lseek(5, 0, SEEK_CUR)       = 383
[pid 18468] lseek(5, 284, SEEK_SET)     = 284
[pid 18468] read(5, "8021q 17224 0 - Live 0xdc850000\n"..., 256) = 99
[pid 18468] lseek(5, 0, SEEK_CUR)       = 383
[pid 18468] lseek(5, 316, SEEK_SET)     = 316
[pid 18468] read(5, "8139too 22032 0 - Live 0xdc84200"..., 256) = 67
[pid 18468] lseek(5, 0, SEEK_CUR)       = 383
[pid 18468] lseek(5, 350, SEEK_SET)     = 350
[pid 18468] read(5, "cramfs 39796 6 - Live 0xdc820000"..., 256) = 33
[pid 18468] lseek(5, 0, SEEK_CUR)       = 383
[pid 18468] lseek(5, 383, SEEK_SET)     = 383
[pid 18468] read(5, "", 256)            = 0
[pid 18468] close(5)                    = 0
[pid 18468] rt_sigaction(SIGINT, {SIG_IGN}, {SIG_DFL}, 8) = 0
[pid 18468] rt_sigaction(SIGQUIT, {SIG_IGN}, {SIG_DFL}, 8) = 0
[pid 18468] rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
[pid 18468] fork()                      = 18469
[pid 18468] wait4(18469,  <unfinished ...>
[pid 18469] rt_sigaction(SIGINT, {SIG_DFL}, NULL, 8) = 0
[pid 18469] rt_sigaction(SIGQUIT, {SIG_DFL}, NULL, 8) = 0
[pid 18469] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 18469] execve("/bin/sh", ["sh", "-c", "insmod   -q ip_tables "], [/* 14 vars */]) = 0
[pid 18469] uname({sys="Linux", node="kchtn", ...}) = 0
[pid 18469] brk(0)                      = 0x817b000
[pid 18469] open("/etc/ld.so.preload", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18469] open("/lib/i686/mmx/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18469] stat64("/lib/i686/mmx", 0xbfe95140) = -1 ENOENT (No such file or directory)
[pid 18469] open("/lib/i686/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18469] stat64("/lib/i686", 0xbfe95140) = -1 ENOENT (No such file or directory)
[pid 18469] open("/lib/mmx/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18469] stat64("/lib/mmx", 0xbfe95140) = -1 ENOENT (No such file or directory)
[pid 18469] open("/lib/libm.so.6", O_RDONLY) = 5
[pid 18469] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\3605\0"..., 1024) = 1024
[pid 18469] fstat64(5, {st_mode=S_IFREG|0755, st_size=184056, ...}) = 0
[pid 18469] old_mmap(NULL, 138416, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7f02000
[pid 18469] mprotect(0xb7f23000, 3248, PROT_NONE) = 0
[pid 18469] old_mmap(0xb7f23000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x20000) = 0xb7f23000
[pid 18469] close(5)                    = 0
[pid 18469] open("/lib/libcrypt.so.1", O_RDONLY) = 5
[pid 18469] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\220\n\0"..., 1024) = 1024
[pid 18469] fstat64(5, {st_mode=S_IFREG|0755, st_size=43933, ...}) = 0
[pid 18469] old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7f01000
[pid 18469] old_mmap(NULL, 197728, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7ed0000
[pid 18469] mprotect(0xb7ed8000, 164960, PROT_NONE) = 0
[pid 18469] old_mmap(0xb7ed8000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x8000) = 0xb7ed8000
[pid 18469] old_mmap(0xb7eda000, 156768, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7eda000
[pid 18469] close(5)                    = 0
[pid 18469] open("/lib/libc.so.6", O_RDONLY) = 5
[pid 18469] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0pY\1\000"..., 1024) = 1024
[pid 18469] fstat64(5, {st_mode=S_IFREG|0755, st_size=1491599, ...}) = 0
[pid 18469] old_mmap(NULL, 1268004, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7d9a000
[pid 18469] mprotect(0xb7ec9000, 26916, PROT_NONE) = 0
[pid 18469] old_mmap(0xb7ec9000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x12f000) = 0xb7ec9000
[pid 18469] old_mmap(0xb7ecd000, 10532, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7ecd000
[pid 18469] close(5)                    = 0
[pid 18469] getpid()                    = 18469
[pid 18469] rt_sigaction(SIGCHLD, {SIG_DFL}, {SIG_DFL}, 8) = 0
[pid 18469] geteuid32()                 = 0
[pid 18469] brk(0)                      = 0x817b000
[pid 18469] brk(0x817c000)              = 0x817c000
[pid 18469] brk(0)                      = 0x817c000
[pid 18469] getppid()                   = 18468
[pid 18469] brk(0)                      = 0x817c000
[pid 18469] brk(0x817d000)              = 0x817d000
[pid 18469] getcwd("/root", 4096)       = 6
[pid 18469] rt_sigaction(SIGINT, NULL, {SIG_DFL}, 8) = 0
[pid 18469] rt_sigaction(SIGINT, {0x807ecd1, ~[], SA_RESTORER, 0xb7dc35c8}, NULL, 8) = 0
[pid 18469] rt_sigaction(SIGQUIT, NULL, {SIG_DFL}, 8) = 0
[pid 18469] rt_sigaction(SIGQUIT, {SIG_DFL}, NULL, 8) = 0
[pid 18469] rt_sigaction(SIGTERM, NULL, {SIG_DFL}, 8) = 0
[pid 18469] rt_sigaction(SIGTERM, {SIG_DFL}, NULL, 8) = 0
[pid 18469] stat64("/bin/insmod", 0xbfe95934) = -1 ENOENT (No such file or directory)
[pid 18469] stat64("/sbin/insmod", {st_mode=S_IFREG|0755, st_size=358124, ...}) = 0
[pid 18469] fork()                      = 18470
[pid 18469] wait4(-1,  <unfinished ...>
[pid 18470] execve("/sbin/insmod", ["insmod", "-q", "ip_tables"], [/* 14 vars */]) = 0
[pid 18470] uname({sys="Linux", node="kchtn", ...}) = 0
[pid 18470] brk(0)                      = 0x817b000
[pid 18470] open("/etc/ld.so.preload", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18470] open("/lib/i686/mmx/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18470] stat64("/lib/i686/mmx", 0xbfb1bdc0) = -1 ENOENT (No such file or directory)
[pid 18470] open("/lib/i686/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18470] stat64("/lib/i686", 0xbfb1bdc0) = -1 ENOENT (No such file or directory)
[pid 18470] open("/lib/mmx/libm.so.6", O_RDONLY) = -1 ENOENT (No such file or directory)
[pid 18470] stat64("/lib/mmx", 0xbfb1bdc0) = -1 ENOENT (No such file or directory)
[pid 18470] open("/lib/libm.so.6", O_RDONLY) = 5
[pid 18470] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\3605\0"..., 1024) = 1024
[pid 18470] fstat64(5, {st_mode=S_IFREG|0755, st_size=184056, ...}) = 0
[pid 18470] old_mmap(NULL, 138416, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7eee000
[pid 18470] mprotect(0xb7f0f000, 3248, PROT_NONE) = 0
[pid 18470] old_mmap(0xb7f0f000, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x20000) = 0xb7f0f000
[pid 18470] close(5)                    = 0
[pid 18470] open("/lib/libcrypt.so.1", O_RDONLY) = 5
[pid 18470] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\220\n\0"..., 1024) = 1024
[pid 18470] fstat64(5, {st_mode=S_IFREG|0755, st_size=43933, ...}) = 0
[pid 18470] old_mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb7eed000
[pid 18470] old_mmap(NULL, 197728, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7ebc000
[pid 18470] mprotect(0xb7ec4000, 164960, PROT_NONE) = 0
[pid 18470] old_mmap(0xb7ec4000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x8000) = 0xb7ec4000
[pid 18470] old_mmap(0xb7ec6000, 156768, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7ec6000
[pid 18470] close(5)                    = 0
[pid 18470] open("/lib/libc.so.6", O_RDONLY) = 5
[pid 18470] read(5, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0pY\1\000"..., 1024) = 1024
[pid 18470] fstat64(5, {st_mode=S_IFREG|0755, st_size=1491599, ...}) = 0
[pid 18470] old_mmap(NULL, 1268004, PROT_READ|PROT_EXEC, MAP_PRIVATE, 5, 0) = 0xb7d86000
[pid 18470] mprotect(0xb7eb5000, 26916, PROT_NONE) = 0
[pid 18470] old_mmap(0xb7eb5000, 16384, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 5, 0x12f000) = 0xb7eb5000
[pid 18470] old_mmap(0xb7eb9000, 10532, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7eb9000
[pid 18470] close(5)                    = 0
[pid 18470] brk(0)                      = 0x817b000
[pid 18470] brk(0x817c000)              = 0x817c000
[pid 18470] brk(0)                      = 0x817c000
[pid 18470] uname({sys="Linux", node="kchtn", ...}) = 0
[pid 18470] stat64("ip_tables", 0xbfb1a400) = -1 ENOENT (No such file or directory)
[pid 18470] lstat64("/lib", {st_mode=S_IFDIR|0755, st_size=220, ...}) = 0
[pid 18470] lstat64("/lib/modules", {st_mode=S_IFDIR|0755, st_size=28, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default", {st_mode=S_IFDIR|0755, st_size=44, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default", {st_mode=S_IFDIR|0755, st_size=44, ...}) = 0
[pid 18470] open("/dev/null", O_RDONLY|O_NONBLOCK|O_DIRECTORY) = -1 ENOTDIR (Not a directory)
[pid 18470] open("/lib/modules/2.6.23.9-default", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 5
[pid 18470] fstat64(5, {st_mode=S_IFDIR|0755, st_size=44, ...}) = 0
[pid 18470] fcntl64(5, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] brk(0)                      = 0x817c000
[pid 18470] brk(0x817d000)              = 0x817d000
[pid 18470] getdents64(5, /* 2 entries */, 4096) = 64
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel", {st_mode=S_IFDIR|0755, st_size=68, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 6
[pid 18470] fstat64(6, {st_mode=S_IFDIR|0755, st_size=68, ...}) = 0
[pid 18470] fcntl64(6, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] brk(0)                      = 0x817d000
[pid 18470] brk(0x817e000)              = 0x817e000
[pid 18470] getdents64(6, /* 4 entries */, 4096) = 104
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers", {st_mode=S_IFDIR|0755, st_size=64, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/drivers", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 7
[pid 18470] fstat64(7, {st_mode=S_IFDIR|0755, st_size=64, ...}) = 0
[pid 18470] fcntl64(7, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] brk(0)                      = 0x817e000
[pid 18470] brk(0x817f000)              = 0x817f000
[pid 18470] getdents64(7, /* 4 entries */, 4096) = 96
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi", {st_mode=S_IFDIR|0755, st_size=184, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/drivers/acpi", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18470] fstat64(8, {st_mode=S_IFDIR|0755, st_size=184, ...}) = 0
[pid 18470] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] brk(0)                      = 0x817f000
[pid 18470] brk(0x8180000)              = 0x8180000
[pid 18470] getdents64(8, /* 8 entries */, 4096) = 256
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/ac.ko", {st_mode=S_IFREG|0644, st_size=6132, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/asus_acpi.ko", {st_mode=S_IFREG|0644, st_size=21711, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/battery.ko", {st_mode=S_IFREG|0644, st_size=14467, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/button.ko", {st_mode=S_IFREG|0644, st_size=9165, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/container.ko", {st_mode=S_IFREG|0644, st_size=5791, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/fan.ko", {st_mode=S_IFREG|0644, st_size=6034, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/processor.ko", {st_mode=S_IFREG|0644, st_size=34510, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/thermal.ko", {st_mode=S_IFREG|0644, st_size=21465, ...}) = 0
[pid 18470] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18470] close(8)                    = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/char", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/drivers/char", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18470] fstat64(8, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18470] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18470] close(8)                    = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net", {st_mode=S_IFDIR|0755, st_size=268, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/drivers/net", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18470] fstat64(8, {st_mode=S_IFDIR|0755, st_size=268, ...}) = 0
[pid 18470] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(8, /* 11 entries */, 4096) = 384
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/8139too.ko", {st_mode=S_IFREG|0755, st_size=29763, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/bsd_comp.ko", {st_mode=S_IFREG|0644, st_size=6735, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/dummy.ko", {st_mode=S_IFREG|0755, st_size=4402, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/netconsole.ko", {st_mode=S_IFREG|0644, st_size=4059, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_async.ko", {st_mode=S_IFREG|0755, st_size=10569, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_deflate.ko", {st_mode=S_IFREG|0755, st_size=6468, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_generic.ko", {st_mode=S_IFREG|0755, st_size=24315, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_mppe.ko", {st_mode=S_IFREG|0755, st_size=8202, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_synctty.ko", {st_mode=S_IFREG|0755, st_size=9096, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/slhc.ko", {st_mode=S_IFREG|0755, st_size=6592, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/tun.ko", {st_mode=S_IFREG|0755, st_size=10595, ...}) = 0
[pid 18470] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18470] close(8)                    = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/usb", {st_mode=S_IFDIR|0755, st_size=16, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/drivers/usb", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18470] fstat64(8, {st_mode=S_IFDIR|0755, st_size=16, ...}) = 0
[pid 18470] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(8, /* 1 entries */, 4096) = 24
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/usb/net", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/drivers/usb/net", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18470] fstat64(9, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18470] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] brk(0)                      = 0x8180000
[pid 18470] brk(0x8181000)              = 0x8181000
[pid 18470] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18470] close(9)                    = 0
[pid 18470] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18470] close(8)                    = 0
[pid 18470] getdents64(7, /* 0 entries */, 4096) = 0
[pid 18470] close(7)                    = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/fs", {st_mode=S_IFDIR|0755, st_size=96, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/fs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 7
[pid 18470] fstat64(7, {st_mode=S_IFDIR|0755, st_size=96, ...}) = 0
[pid 18470] fcntl64(7, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(7, /* 5 entries */, 4096) = 152
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/cramfs", {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/fs/cramfs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18470] fstat64(8, {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18470] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(8, /* 1 entries */, 4096) = 32
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/cramfs/cramfs.ko", {st_mode=S_IFREG|0755, st_size=9380, ...}) = 0
[pid 18470] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18470] close(8)                    = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/isofs", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/fs/isofs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18470] fstat64(8, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18470] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18470] close(8)                    = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/reiserfs", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/fs/reiserfs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18470] fstat64(8, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18470] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18470] close(8)                    = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/smbfs", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/fs/smbfs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18470] fstat64(8, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18470] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18470] close(8)                    = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/udf", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/fs/udf", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18470] fstat64(8, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18470] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18470] close(8)                    = 0
[pid 18470] getdents64(7, /* 0 entries */, 4096) = 0
[pid 18470] close(7)                    = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/lib", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/lib", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 7
[pid 18470] fstat64(7, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18470] fcntl64(7, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(7, /* 0 entries */, 4096) = 0
[pid 18470] close(7)                    = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net", {st_mode=S_IFDIR|0755, st_size=108, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/net", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 7
[pid 18470] fstat64(7, {st_mode=S_IFDIR|0755, st_size=108, ...}) = 0
[pid 18470] fcntl64(7, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(7, /* 6 entries */, 4096) = 168
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/8021q", {st_mode=S_IFDIR|0755, st_size=20, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/net/8021q", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18470] fstat64(8, {st_mode=S_IFDIR|0755, st_size=20, ...}) = 0
[pid 18470] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(8, /* 1 entries */, 4096) = 32
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/8021q/8021q.ko", {st_mode=S_IFREG|0755, st_size=21970, ...}) = 0
[pid 18470] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18470] close(8)                    = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/atm", {st_mode=S_IFDIR|0755, st_size=64, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/net/atm", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18470] fstat64(8, {st_mode=S_IFDIR|0755, st_size=64, ...}) = 0
[pid 18470] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(8, /* 3 entries */, 4096) = 96
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/atm/atm.ko", {st_mode=S_IFREG|0755, st_size=45039, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/atm/br2684.ko", {st_mode=S_IFREG|0755, st_size=9197, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/atm/clip.ko", {st_mode=S_IFREG|0755, st_size=14837, ...}) = 0
[pid 18470] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18470] close(8)                    = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge", {st_mode=S_IFDIR|0755, st_size=48, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/net/bridge", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18470] fstat64(8, {st_mode=S_IFDIR|0755, st_size=48, ...}) = 0
[pid 18470] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(8, /* 2 entries */, 4096) = 64
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/bridge.ko", {st_mode=S_IFREG|0755, st_size=58477, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter", {st_mode=S_IFDIR|0755, st_size=572, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18470] fstat64(9, {st_mode=S_IFDIR|0755, st_size=572, ...}) = 0
[pid 18470] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(9, /* 22 entries */, 4096) = 776
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_802_3.ko", {st_mode=S_IFREG|0755, st_size=2837, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_among.ko", {st_mode=S_IFREG|0755, st_size=4508, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_arp.ko", {st_mode=S_IFREG|0755, st_size=3726, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_arpreply.ko", {st_mode=S_IFREG|0755, st_size=3416, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_dnat.ko", {st_mode=S_IFREG|0755, st_size=3221, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_ip.ko", {st_mode=S_IFREG|0755, st_size=3439, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_ipdaddr.ko", {st_mode=S_IFREG|0755, st_size=4409, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_ipsaddr.ko", {st_mode=S_IFREG|0755, st_size=4409, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_limit.ko", {st_mode=S_IFREG|0755, st_size=3369, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_log.ko", {st_mode=S_IFREG|0755, st_size=5332, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_mark.ko", {st_mode=S_IFREG|0755, st_size=2839, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_mark_m.ko", {st_mode=S_IFREG|0755, st_size=2774, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_pkttype.ko", {st_mode=S_IFREG|0755, st_size=2723, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_redirect.ko", {st_mode=S_IFREG|0755, st_size=3288, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_snat.ko", {st_mode=S_IFREG|0755, st_size=3378, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_stp.ko", {st_mode=S_IFREG|0755, st_size=3992, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_ulog.ko", {st_mode=S_IFREG|0755, st_size=7733, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_vlan.ko", {st_mode=S_IFREG|0755, st_size=4997, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebtable_broute.ko", {st_mode=S_IFREG|0755, st_size=3234, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebtable_filter.ko", {st_mode=S_IFREG|0755, st_size=3584, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebtable_nat.ko", {st_mode=S_IFREG|0755, st_size=3613, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebtables.ko", {st_mode=S_IFREG|0755, st_size=21295, ...}) = 0
[pid 18470] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18470] close(9)                    = 0
[pid 18470] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18470] close(8)                    = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/core", {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/net/core", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18470] fstat64(8, {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18470] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(8, /* 1 entries */, 4096) = 32
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/core/pktgen.ko", {st_mode=S_IFREG|0755, st_size=44932, ...}) = 0
[pid 18470] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18470] close(8)                    = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/ipv4", {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/net/ipv4", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18470] fstat64(8, {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18470] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(8, /* 1 entries */, 4096) = 32
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/ipv4/netfilter", {st_mode=S_IFDIR|0755, st_size=28, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/net/ipv4/netfilter", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18470] fstat64(9, {st_mode=S_IFDIR|0755, st_size=28, ...}) = 0
[pid 18470] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(9, /* 1 entries */, 4096) = 40
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/ipv4/netfilter/ipt_CLUSTERIP.ko", {st_mode=S_IFREG|0755, st_size=9564, ...}) = 0
[pid 18470] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18470] close(9)                    = 0
[pid 18470] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18470] close(8)                    = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched", {st_mode=S_IFDIR|0755, st_size=648, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/net/sched", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18470] fstat64(8, {st_mode=S_IFDIR|0755, st_size=648, ...}) = 0
[pid 18470] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(8, /* 26 entries */, 4096) = 880
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_gact.ko", {st_mode=S_IFREG|0755, st_size=4973, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_ipt.ko", {st_mode=S_IFREG|0755, st_size=6243, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_mirred.ko", {st_mode=S_IFREG|0755, st_size=5582, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_pedit.ko", {st_mode=S_IFREG|0755, st_size=5510, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_police.ko", {st_mode=S_IFREG|0755, st_size=6451, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_simple.ko", {st_mode=S_IFREG|0755, st_size=5001, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_basic.ko", {st_mode=S_IFREG|0755, st_size=5729, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_fw.ko", {st_mode=S_IFREG|0755, st_size=5396, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_route.ko", {st_mode=S_IFREG|0755, st_size=7185, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_rsvp.ko", {st_mode=S_IFREG|0755, st_size=7095, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_tcindex.ko", {st_mode=S_IFREG|0755, st_size=7627, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_u32.ko", {st_mode=S_IFREG|0755, st_size=8276, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_atm.ko", {st_mode=S_IFREG|0755, st_size=8177, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_cbq.ko", {st_mode=S_IFREG|0755, st_size=16919, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_csz.ko", {st_mode=S_IFREG|0755, st_size=8449, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_dsmark.ko", {st_mode=S_IFREG|0755, st_size=6721, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_gred.ko", {st_mode=S_IFREG|0755, st_size=8798, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_hfsc.ko", {st_mode=S_IFREG|0755, st_size=18166, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_htb.ko", {st_mode=S_IFREG|0755, st_size=16942, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_ingress.ko", {st_mode=S_IFREG|0755, st_size=4347, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_netem.ko", {st_mode=S_IFREG|0755, st_size=8878, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_prio.ko", {st_mode=S_IFREG|0755, st_size=6453, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_red.ko", {st_mode=S_IFREG|0755, st_size=6816, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_sfq.ko", {st_mode=S_IFREG|0755, st_size=6416, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_tbf.ko", {st_mode=S_IFREG|0755, st_size=6140, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_teql.ko", {st_mode=S_IFREG|0755, st_size=7072, ...}) = 0
[pid 18470] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18470] close(8)                    = 0
[pid 18470] getdents64(7, /* 0 entries */, 4096) = 0
[pid 18470] close(7)                    = 0
[pid 18470] getdents64(6, /* 0 entries */, 4096) = 0
[pid 18470] close(6)                    = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/modules.dep", {st_mode=S_IFREG|0755, st_size=4712, ...}) = 0
[pid 18470] getdents64(5, /* 0 entries */, 4096) = 0
[pid 18470] close(5)                    = 0
[pid 18470] lstat64("/lib", {st_mode=S_IFDIR|0755, st_size=220, ...}) = 0
[pid 18470] lstat64("/lib/modules", {st_mode=S_IFDIR|0755, st_size=28, ...}) = 0
[pid 18470] lstat64("/lib/modules", {st_mode=S_IFDIR|0755, st_size=28, ...}) = 0
[pid 18470] open("/lib/modules", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 5
[pid 18470] fstat64(5, {st_mode=S_IFDIR|0755, st_size=28, ...}) = 0
[pid 18470] fcntl64(5, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(5, /* 1 entries */, 4096) = 40
[pid 18470] lstat64("/lib/modules/2.6.23.9-default", {st_mode=S_IFDIR|0755, st_size=44, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 6
[pid 18470] fstat64(6, {st_mode=S_IFDIR|0755, st_size=44, ...}) = 0
[pid 18470] fcntl64(6, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(6, /* 2 entries */, 4096) = 64
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel", {st_mode=S_IFDIR|0755, st_size=68, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 7
[pid 18470] fstat64(7, {st_mode=S_IFDIR|0755, st_size=68, ...}) = 0
[pid 18470] fcntl64(7, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(7, /* 4 entries */, 4096) = 104
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers", {st_mode=S_IFDIR|0755, st_size=64, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/drivers", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18470] fstat64(8, {st_mode=S_IFDIR|0755, st_size=64, ...}) = 0
[pid 18470] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(8, /* 4 entries */, 4096) = 96
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi", {st_mode=S_IFDIR|0755, st_size=184, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/drivers/acpi", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18470] fstat64(9, {st_mode=S_IFDIR|0755, st_size=184, ...}) = 0
[pid 18470] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(9, /* 8 entries */, 4096) = 256
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/ac.ko", {st_mode=S_IFREG|0644, st_size=6132, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/asus_acpi.ko", {st_mode=S_IFREG|0644, st_size=21711, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/battery.ko", {st_mode=S_IFREG|0644, st_size=14467, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/button.ko", {st_mode=S_IFREG|0644, st_size=9165, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/container.ko", {st_mode=S_IFREG|0644, st_size=5791, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/fan.ko", {st_mode=S_IFREG|0644, st_size=6034, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/processor.ko", {st_mode=S_IFREG|0644, st_size=34510, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/acpi/thermal.ko", {st_mode=S_IFREG|0644, st_size=21465, ...}) = 0
[pid 18470] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18470] close(9)                    = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/char", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/drivers/char", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18470] fstat64(9, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18470] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18470] close(9)                    = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net", {st_mode=S_IFDIR|0755, st_size=268, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/drivers/net", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18470] fstat64(9, {st_mode=S_IFDIR|0755, st_size=268, ...}) = 0
[pid 18470] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(9, /* 11 entries */, 4096) = 384
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/8139too.ko", {st_mode=S_IFREG|0755, st_size=29763, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/bsd_comp.ko", {st_mode=S_IFREG|0644, st_size=6735, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/dummy.ko", {st_mode=S_IFREG|0755, st_size=4402, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/netconsole.ko", {st_mode=S_IFREG|0644, st_size=4059, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_async.ko", {st_mode=S_IFREG|0755, st_size=10569, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_deflate.ko", {st_mode=S_IFREG|0755, st_size=6468, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_generic.ko", {st_mode=S_IFREG|0755, st_size=24315, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_mppe.ko", {st_mode=S_IFREG|0755, st_size=8202, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/ppp_synctty.ko", {st_mode=S_IFREG|0755, st_size=9096, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/slhc.ko", {st_mode=S_IFREG|0755, st_size=6592, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/net/tun.ko", {st_mode=S_IFREG|0755, st_size=10595, ...}) = 0
[pid 18470] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18470] close(9)                    = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/usb", {st_mode=S_IFDIR|0755, st_size=16, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/drivers/usb", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18470] fstat64(9, {st_mode=S_IFDIR|0755, st_size=16, ...}) = 0
[pid 18470] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(9, /* 1 entries */, 4096) = 24
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/drivers/usb/net", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/drivers/usb/net", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 10
[pid 18470] fstat64(10, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18470] fcntl64(10, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] brk(0)                      = 0x8181000
[pid 18470] brk(0x8182000)              = 0x8182000
[pid 18470] getdents64(10, /* 0 entries */, 4096) = 0
[pid 18470] close(10)                   = 0
[pid 18470] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18470] close(9)                    = 0
[pid 18470] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18470] close(8)                    = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/fs", {st_mode=S_IFDIR|0755, st_size=96, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/fs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18470] fstat64(8, {st_mode=S_IFDIR|0755, st_size=96, ...}) = 0
[pid 18470] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(8, /* 5 entries */, 4096) = 152
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/cramfs", {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/fs/cramfs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18470] fstat64(9, {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18470] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(9, /* 1 entries */, 4096) = 32
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/cramfs/cramfs.ko", {st_mode=S_IFREG|0755, st_size=9380, ...}) = 0
[pid 18470] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18470] close(9)                    = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/isofs", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/fs/isofs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18470] fstat64(9, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18470] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18470] close(9)                    = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/reiserfs", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/fs/reiserfs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18470] fstat64(9, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18470] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18470] close(9)                    = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/smbfs", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/fs/smbfs", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18470] fstat64(9, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18470] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18470] close(9)                    = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/fs/udf", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/fs/udf", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18470] fstat64(9, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18470] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18470] close(9)                    = 0
[pid 18470] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18470] close(8)                    = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/lib", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/lib", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18470] fstat64(8, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
[pid 18470] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18470] close(8)                    = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net", {st_mode=S_IFDIR|0755, st_size=108, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/net", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 8
[pid 18470] fstat64(8, {st_mode=S_IFDIR|0755, st_size=108, ...}) = 0
[pid 18470] fcntl64(8, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(8, /* 6 entries */, 4096) = 168
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/8021q", {st_mode=S_IFDIR|0755, st_size=20, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/net/8021q", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18470] fstat64(9, {st_mode=S_IFDIR|0755, st_size=20, ...}) = 0
[pid 18470] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(9, /* 1 entries */, 4096) = 32
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/8021q/8021q.ko", {st_mode=S_IFREG|0755, st_size=21970, ...}) = 0
[pid 18470] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18470] close(9)                    = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/atm", {st_mode=S_IFDIR|0755, st_size=64, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/net/atm", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18470] fstat64(9, {st_mode=S_IFDIR|0755, st_size=64, ...}) = 0
[pid 18470] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(9, /* 3 entries */, 4096) = 96
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/atm/atm.ko", {st_mode=S_IFREG|0755, st_size=45039, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/atm/br2684.ko", {st_mode=S_IFREG|0755, st_size=9197, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/atm/clip.ko", {st_mode=S_IFREG|0755, st_size=14837, ...}) = 0
[pid 18470] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18470] close(9)                    = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge", {st_mode=S_IFDIR|0755, st_size=48, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/net/bridge", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18470] fstat64(9, {st_mode=S_IFDIR|0755, st_size=48, ...}) = 0
[pid 18470] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(9, /* 2 entries */, 4096) = 64
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/bridge.ko", {st_mode=S_IFREG|0755, st_size=58477, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter", {st_mode=S_IFDIR|0755, st_size=572, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 10
[pid 18470] fstat64(10, {st_mode=S_IFDIR|0755, st_size=572, ...}) = 0
[pid 18470] fcntl64(10, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(10, /* 22 entries */, 4096) = 776
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_802_3.ko", {st_mode=S_IFREG|0755, st_size=2837, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_among.ko", {st_mode=S_IFREG|0755, st_size=4508, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_arp.ko", {st_mode=S_IFREG|0755, st_size=3726, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_arpreply.ko", {st_mode=S_IFREG|0755, st_size=3416, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_dnat.ko", {st_mode=S_IFREG|0755, st_size=3221, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_ip.ko", {st_mode=S_IFREG|0755, st_size=3439, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_ipdaddr.ko", {st_mode=S_IFREG|0755, st_size=4409, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_ipsaddr.ko", {st_mode=S_IFREG|0755, st_size=4409, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_limit.ko", {st_mode=S_IFREG|0755, st_size=3369, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_log.ko", {st_mode=S_IFREG|0755, st_size=5332, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_mark.ko", {st_mode=S_IFREG|0755, st_size=2839, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_mark_m.ko", {st_mode=S_IFREG|0755, st_size=2774, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_pkttype.ko", {st_mode=S_IFREG|0755, st_size=2723, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_redirect.ko", {st_mode=S_IFREG|0755, st_size=3288, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_snat.ko", {st_mode=S_IFREG|0755, st_size=3378, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_stp.ko", {st_mode=S_IFREG|0755, st_size=3992, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_ulog.ko", {st_mode=S_IFREG|0755, st_size=7733, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebt_vlan.ko", {st_mode=S_IFREG|0755, st_size=4997, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebtable_broute.ko", {st_mode=S_IFREG|0755, st_size=3234, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebtable_filter.ko", {st_mode=S_IFREG|0755, st_size=3584, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebtable_nat.ko", {st_mode=S_IFREG|0755, st_size=3613, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/bridge/netfilter/ebtables.ko", {st_mode=S_IFREG|0755, st_size=21295, ...}) = 0
[pid 18470] getdents64(10, /* 0 entries */, 4096) = 0
[pid 18470] close(10)                   = 0
[pid 18470] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18470] close(9)                    = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/core", {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/net/core", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18470] fstat64(9, {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18470] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(9, /* 1 entries */, 4096) = 32
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/core/pktgen.ko", {st_mode=S_IFREG|0755, st_size=44932, ...}) = 0
[pid 18470] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18470] close(9)                    = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/ipv4", {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/net/ipv4", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18470] fstat64(9, {st_mode=S_IFDIR|0755, st_size=24, ...}) = 0
[pid 18470] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(9, /* 1 entries */, 4096) = 32
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/ipv4/netfilter", {st_mode=S_IFDIR|0755, st_size=28, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/net/ipv4/netfilter", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 10
[pid 18470] fstat64(10, {st_mode=S_IFDIR|0755, st_size=28, ...}) = 0
[pid 18470] fcntl64(10, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(10, /* 1 entries */, 4096) = 40
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/ipv4/netfilter/ipt_CLUSTERIP.ko", {st_mode=S_IFREG|0755, st_size=9564, ...}) = 0
[pid 18470] getdents64(10, /* 0 entries */, 4096) = 0
[pid 18470] close(10)                   = 0
[pid 18470] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18470] close(9)                    = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched", {st_mode=S_IFDIR|0755, st_size=648, ...}) = 0
[pid 18470] open("/lib/modules/2.6.23.9-default/kernel/net/sched", O_RDONLY|O_NONBLOCK|O_LARGEFILE|O_DIRECTORY) = 9
[pid 18470] fstat64(9, {st_mode=S_IFDIR|0755, st_size=648, ...}) = 0
[pid 18470] fcntl64(9, F_SETFD, FD_CLOEXEC) = 0
[pid 18470] getdents64(9, /* 26 entries */, 4096) = 880
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_gact.ko", {st_mode=S_IFREG|0755, st_size=4973, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_ipt.ko", {st_mode=S_IFREG|0755, st_size=6243, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_mirred.ko", {st_mode=S_IFREG|0755, st_size=5582, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_pedit.ko", {st_mode=S_IFREG|0755, st_size=5510, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_police.ko", {st_mode=S_IFREG|0755, st_size=6451, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/act_simple.ko", {st_mode=S_IFREG|0755, st_size=5001, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_basic.ko", {st_mode=S_IFREG|0755, st_size=5729, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_fw.ko", {st_mode=S_IFREG|0755, st_size=5396, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_route.ko", {st_mode=S_IFREG|0755, st_size=7185, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_rsvp.ko", {st_mode=S_IFREG|0755, st_size=7095, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_tcindex.ko", {st_mode=S_IFREG|0755, st_size=7627, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/cls_u32.ko", {st_mode=S_IFREG|0755, st_size=8276, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_atm.ko", {st_mode=S_IFREG|0755, st_size=8177, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_cbq.ko", {st_mode=S_IFREG|0755, st_size=16919, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_csz.ko", {st_mode=S_IFREG|0755, st_size=8449, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_dsmark.ko", {st_mode=S_IFREG|0755, st_size=6721, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_gred.ko", {st_mode=S_IFREG|0755, st_size=8798, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_hfsc.ko", {st_mode=S_IFREG|0755, st_size=18166, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_htb.ko", {st_mode=S_IFREG|0755, st_size=16942, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_ingress.ko", {st_mode=S_IFREG|0755, st_size=4347, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_netem.ko", {st_mode=S_IFREG|0755, st_size=8878, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_prio.ko", {st_mode=S_IFREG|0755, st_size=6453, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_red.ko", {st_mode=S_IFREG|0755, st_size=6816, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_sfq.ko", {st_mode=S_IFREG|0755, st_size=6416, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_tbf.ko", {st_mode=S_IFREG|0755, st_size=6140, ...}) = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/kernel/net/sched/sch_teql.ko", {st_mode=S_IFREG|0755, st_size=7072, ...}) = 0
[pid 18470] getdents64(9, /* 0 entries */, 4096) = 0
[pid 18470] close(9)                    = 0
[pid 18470] getdents64(8, /* 0 entries */, 4096) = 0
[pid 18470] close(8)                    = 0
[pid 18470] getdents64(7, /* 0 entries */, 4096) = 0
[pid 18470] close(7)                    = 0
[pid 18470] lstat64("/lib/modules/2.6.23.9-default/modules.dep", {st_mode=S_IFREG|0755, st_size=4712, ...}) = 0
[pid 18470] getdents64(6, /* 0 entries */, 4096) = 0
[pid 18470] close(6)                    = 0
[pid 18470] getdents64(5, /* 0 entries */, 4096) = 0
[pid 18470] close(5)                    = 0
[pid 18470] write(2, "insmod: ", 8insmod: )     = 8
[pid 18470] write(2, "ip_tables.ko: no module by that "..., 42ip_tables.ko: no module by that name found) = 42
[pid 18470] write(2, "\n", 1
)           = 1
[pid 18470] exit_group(1)               = ?
[pid 18469] <... wait4 resumed> [WIFEXITED(s) && WEXITSTATUS(s) == 1], 0, NULL) = 18470
[pid 18469] --- SIGCHLD (Child exited) @ 0 (0) ---
[pid 18469] exit_group(1)               = ?
[pid 18468] <... wait4 resumed> [WIFEXITED(s) && WEXITSTATUS(s) == 1], 0, NULL) = 18469
[pid 18468] rt_sigaction(SIGINT, {SIG_DFL}, NULL, 8) = 0
[pid 18468] rt_sigaction(SIGQUIT, {SIG_DFL}, NULL, 8) = 0
[pid 18468] rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
[pid 18468] --- SIGCHLD (Child exited) @ 0 (0) ---
[pid 18468] write(2, "modprobe: ", 10modprobe: )  = 10
[pid 18468] write(2, "failed to load module ip_tables", 31failed to load module ip_tables) = 31
[pid 18468] write(2, "\n", 1
)           = 1
[pid 18468] exit_group(1)               = ?
<... wait4 resumed> [WIFEXITED(s) && WEXITSTATUS(s) == 1], 0, NULL) = 18468
--- SIGCHLD (Child exited) @ 0 (0) ---
getsockopt(4, SOL_IP, 0x43 /* IP_??? */, 0xbfa04f60, 0xbfa04f5c) = -1 EPROTONOSUPPORT (Protocol not supported)
close(4)                                = 0
close(3)                                = 0
write(1, "    0     0 MARK       all  --  "..., 2342    0     0 MARK       all  --  *      *       10.0.20.2            0.0.0.0/0           MARK set 0x14 
    0     0 MARK       all  --  *      *       10.0.19.2            0.0.0.0/0           MARK set 0x13 
    0     0 MARK       all  --  *      *       10.0.18.2            0.0.0.0/0           MARK set 0x12 
    0     0 MARK       all  --  *      *       10.0.17.2            0.0.0.0/0           MARK set 0x11 
    0     0 MARK       all  --  *      *       10.0.16.2            0.0.0.0/0           MARK set 0x10 
    0     0 MARK       all  --  *      *       10.0.15.2            0.0.0.0/0           MARK set 0xf 
    0     0 MARK       all  --  *      *       10.0.14.2            0.0.0.0/0           MARK set 0xe 
    0     0 MARK       all  --  *      *       10.0.13.2            0.0.0.0/0           MARK set 0xd 
    0     0 MARK       all  --  *      *       10.0.12.2            0.0.0.0/0           MARK set 0xc 
    0     0 MARK       all  --  *      *       10.0.11.2            0.0.0.0/0           MARK set 0xb 
    0     0 MARK       all  --  *      *       10.0.10.2            0.0.0.0/0           MARK set 0xa 
    0     0 MARK       all  --  *      *       10.0.9.2             0.0.0.0/0           MARK set 0x9 
    0     0 MARK       all  --  *      *       10.0.8.2             0.0.0.0/0           MARK set 0x8 
    0     0 MARK       all  --  *      *       10.0.7.2             0.0.0.0/0           MARK set 0x7 
    0     0 MARK       all  --  *      *       10.0.6.2             0.0.0.0/0           MARK set 0x6 
    0     0 MARK       all  --  *      *       10.0.5.2             0.0.0.0/0           MARK set 0x5 
    0     0 MARK       all  --  *      *       10.0.4.2             0.0.0.0/0           MARK set 0x4 
    0     0 MARK       all  --  *      *       10.0.3.2             0.0.0.0/0           MARK set 0x3 
    0     0 MARK       all  --  *      *       10.0.2.2             0.0.0.0/0           MARK set 0x2 
    0     0 MARK       all  --  *      *       10.0.1.2             0.0.0.0/0           MARK set 0x1 

Chain OUTPUT (policy ACCEPT 18985 packets, 2739K bytes)
 pkts bytes target     prot opt in     out     source               destination         

Chain POSTROUTING (policy ACCEPT 18986 packets, 2739K bytes)
 pkts bytes target     prot opt in     out     source               destination         
) = 2342
munmap(0xb7e47000, 4096)                = 0
exit_group(0)                           = ?

--------------020104010403010004020302--
