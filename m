From: Herve Eychenne <rv@wallfire.org>
Subject: iptables: memory allocation problem
Date: Tue, 16 Dec 2003 19:29:59 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031216182959.GA1216@eychenne.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

 Hi everyone,

I'm currently setting up a quiet big firewall, and I experience some
annoying problems. Here is what I get right now:
# iptables -A INPUT -j ACCEPT
iptables: Memory allocation problem

Well... something is going wrong, obviously.
But before that, I had some strange things happening. Here is my story.
I use a script which produces a rules file (in iptables-save/restore format),
and I apply it with iptables-restore.

But from time to time, I had the following error:
iptables-restore: line 2613 failed
where 2613 is the last line of the file (final filter COMMIT). As you can see,
the file is quite big, but anyway, it should work. And it worked, most of
the time, with the exactly same rules file.

So, to try to reproduce the problem, I ran :
# while iptables-restore < rules ; do : ; done
And could get no error. I had the intuition that the error showed up
more often when there was some traffic (and maybe such a heavy loop 
prevents connections from establishing properly).
So I ran:
# while iptables-restore < rules ; do sleep 10 ; done
and I finally got an error again (always the same: iptables-restore:
line 2613 failed), but only after hundreds of loops without any
problem.
Then I ran iptables-restore < rules manually a times by hand, and no
problem appeared. Then, I got the error again, each time, now.

After that, I can not even insert a single rule with the regular
iptables command.
Now I systematically get:
# iptables -A INPUT -j ACCEPT
iptables: Memory allocation problem

Syslog says nothing about this (if netfilter cannot allocate
enough kernel memory for rules, maybe it should report it with
a printk...), and userspace message is quite vague.

Note that the machine is still perfectly functionnal. I can log in
(remotely) and do whatever I want without any problem. I just seem to be
running out of kernel memory for the iptables rule insertion.

So I suspect there is a kind of memory leak somewhere.

Maybe I'll try to reproduce the leak on another machine by doing a
# while iptables-restore < rules ; do : ; done

What can I do to figure out where's the problem exactly, and what
caused it?

Here are things that may be relevant. I don't see any particular
problem... even if there is one, for sure. :-(
But I'm not a kernel guru, so please help me!

The machine is a SMP (4 processors) with Xeon 2.40GHz.

The host is running iptables-1.2.9 with 2.4.23 vanilla kernel (highmem
4Go activated, as there is 1.5G of RAM), and no real exotic
patch-o-matic module added (I'll provide the list on request if you
want) and no module support (I'll send .config on request as well).

# cat /proc/meminfo
        total:    used:    free:  shared: buffers:  cached:
Mem:  1586384896 607453184 978931712        0 104947712 296701952
Swap: 2055528448        0 2055528448
MemTotal:      1549204 kB
MemFree:        955988 kB
MemShared:           0 kB
Buffers:        102488 kB
Cached:         289748 kB
SwapCached:          0 kB
Active:         171476 kB
Inactive:       229480 kB
HighTotal:      655336 kB
HighFree:       269948 kB
LowTotal:       893868 kB
LowFree:        686040 kB
SwapTotal:     2007352 kB
SwapFree:      2007352 kB

# wc -l /proc/net/ip_conntrack
     700 /proc/net/ip_conntrack          # nothing particular

I tweaked the number of buckets (based on my document
http://www.wallfire.org/misc/netfilter_conntrack_perf.txt)
# cat /proc/sys/net/ipv4/netfilter/ip_conntrack_max
3579157
# cat /proc/sys/net/ipv4/netfilter/ip_conntrack_buckets
3579157
Note: maybe it's a little too much (there's no real memory consuming
userspace command running, so I want to reserve as much as possible for
conntrack), but I think I can recall having an iptables memory
allocation only one time (I was surprised, but forgot
about it) a long time ago on the same machine before I had set these
parameters to something else than the default.

# cat /proc/slabinfo
slabinfo - version: 1.1 (SMP)
kmem_cache            96     96    244    6    6    1 :  252  126
ip_fib_hash          452    452     32    4    4    1 :  252  126
ip_conntrack         218  19500    320   56 1625    1 :  124   62
ip_mrt_cache           0      0     96    0    0    1 :  252  126
tcp_tw_bucket        160    160     96    4    4    1 :  252  126
tcp_bind_bucket      452    452     32    4    4    1 :  252  126
tcp_open_request     464    590     64    9   10    1 :  252  126
inet_peer_cache      338    590     64   10   10    1 :  252  126
ip_dst_cache         354  75576    160   70 3149    1 :  252  126
arp_cache            324    450    128   15   15    1 :  252  126
blkdev_requests     4120   4120     96  103  103    1 :  252  126
journal_head         894  29874     48   15  383    1 :  252  126
revoke_table         252    253     12    1    1    1 :  252  126
revoke_record        535   1921     32   16   17    1 :  252  126
dnotify_cache          0      0     20    0    0    1 :  252  126
file_lock_cache      160    160     96    4    4    1 :  252  126
fasync_cache           0      0     16    0    0    1 :  252  126
uid_cache            339    339     32    3    3    1 :  252  126
skbuff_head_cache   1584   2340    192  113  117    1 :  252  126
sock                 370    432    832   48   48    2 :  124   62
sigqueue             376    754    132   17   26    1 :  252  126
kiobuf                 0      0     64    0    0    1 :  252  126
cdev_cache          1121   1121     64   19   19    1 :  252  126
bdev_cache           177    177     64    3    3    1 :  252  126
mnt_cache            118    118     64    2    2    1 :  252  126
inode_cache        33794  45822    512 4828 6546    1 :  124   62
dentry_cache       25494  47670    128  879 1589    1 :  252  126
filp                 570    570    128   19   19    1 :  252  126
names_cache           19     19   4096   19   19    1 :   60   30
buffer_head       150510 308640     96 6204 7716    1 :  252  126
mm_struct            642    768    160   30   32    1 :  252  126
vm_area_struct      1902   2280     96   52   57    1 :  252  126
fs_cache             641    767     64   12   13    1 :  252  126
files_cache          201    387    416   38   43    1 :  124   62
signal_act           159    219   1312   55   73    1 :   60   30
size-131072(DMA)       0      0 131072    0    0   32 :    0    0
size-131072            0      0 131072    0    0   32 :    0    0
size-65536(DMA)        0      0  65536    0    0   16 :    0    0
size-65536             0      1  65536    0    1   16 :    0    0
size-32768(DMA)        0      0  32768    0    0    8 :    0    0
size-32768             1      2  32768    1    2    8 :    0    0
size-16384(DMA)        0      0  16384    0    0    4 :    0    0
size-16384             0      4  16384    0    4    4 :    0    0
size-8192(DMA)         0      0   8192    0    0    2 :    0    0
size-8192             12     18   8192   12   18    2 :    0    0
size-4096(DMA)         0      0   4096    0    0    1 :   60   30
size-4096           1190   1250   4096 1190 1250    1 :   60   30
size-2048(DMA)         0      0   2048    0    0    1 :   60   30
size-2048            316    376   2048  158  188    1 :   60   30
size-1024(DMA)         0      0   1024    0    0    1 :  124   62
size-1024            450    512   1024  119  128    1 :  124   62
size-512(DMA)          0      0    512    0    0    1 :  124   62
size-512             230    416    512   35   52    1 :  124   62
size-256(DMA)          0      0    256    0    0    1 :  252  126
size-256             417    795    256   34   53    1 :  252  126
size-128(DMA)          0      0    128    0    0    1 :  252  126
size-128            1314   1440    128   48   48    1 :  252  126
size-64(DMA)           0      0     64    0    0    1 :  252  126
size-64              877   1003     64   17   17    1 :  252  126
size-32(DMA)           0      0     32    0    0    1 :  252  126
size-32             4594   4972     32   42   44    1 :  252  126

 Herve

-- 
 _
(°=  Hervé Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
