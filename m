From: Denis Vlasenko <vda@port.imtp.ilyichevsk.odessa.ua>
Subject: I see wrong ip on icmp_need_fragment. MASQ+1442_MTU_link+nfs
Date: Fri, 15 Aug 2003 11:07:30 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200308150807.h7F87Ud08929@Port.imtp.ilyichevsk.odessa.ua>
Reply-To: vda@port.imtp.ilyichevsk.odessa.ua
Mime-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 8bit
Cc: coreteam@netfilter.org, vda@port.imtp.ilyichevsk.odessa.ua
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi folks,

Please CC me, I'm not on the list.

I think I see a bug.
I have a network with one segment going through cipe
tunnel which has MTU 1442. There is a box at the end
of a tunnel which MASQUERADE everything:

                                 |
me===(1500)===router===(<1442)===|guard===(1500)===pegasus
                                 |

MTU is in (), vertical bar depicts firewall.
Pegasus does not see anything behind guard.
At least in theory.

When I try to mount NFS shares on pegasus from my box,
NFS traffic halts after some 30-60 seconds.

tcpdump (done on pegasus) revealed the problem.

Note: bird = ip address of guard's cipe tunnel iface:

           |
...=== bird|guard ===...
           |

It should not be visible at all because on guard:

Chain POSTROUTING (policy ACCEPT)
MASQUERADE  all  --  *      eth0    0.0.0.0/0            0.0.0.0/0

On with tcpdump -vvv -s0:

10:30:48.138431 guard.2396687304 > pegasus.2049: 100 access fh Unknown/1 0002 (DF) (ttl 62, id 0, len 128)
10:30:48.138905 pegasus.2049 > guard.2396687304: reply ok 120 access attr: DIR 40755 ids 0/0 sz 0x000001000 nlink 2 rdev 0/0 fsid 0x000000000 nodeid 0x000000000 a/m/ctime 1056102599.000000 1056102596.000000 1060767151.000000  c 0002 (DF) (ttl 64, id 0, len 148)
10:30:48.162176 guard.2413464520 > pegasus.2049: 100 getattr fh Unknown/1 (DF) (ttl 62, id 0, len 128)
10:30:48.162640 pegasus.2049 > guard.2413464520: reply ok 112 getattr REG 100444 ids 0/0 sz 0x000000524  (DF) (ttl 64, id 0, len 140)
10:30:48.182178 guard.2430241736 > pegasus.2049: 104 access fh Unknown/1 0001 (DF) (ttl 62, id 0, len 132)
10:30:48.182651 pegasus.2049 > guard.2430241736: reply ok 120 access attr: REG 100444 ids 0/0 sz 0x000000524 nlink 1 rdev 0/0 fsid 0x000000000 nodeid 0x000000000 a/m/ctime 1056100000.000000 1056100000.000000 1060767135.000000  c 0001 (DF) (ttl 64, id 0, len 148)

    so far it worked ok

10:30:48.198185 guard.2447018952 > pegasus.2049: 112 read fh Unknown/1 4096 bytes @ 0x000000000 (DF) (ttl 62, id 0, len 140)
10:30:48.199214 pegasus.2049 > guard.2447018952: reply ok 1444 read REG 100444 ids 0/0 sz 0x000000524 nlink 1 rdev 0/0 fsid 0x000000000 nodeid 0x000000000 a/m/ctime 1056100000.000000 1056100000.000000 1060767135.000000 1316 bytes EOF (DF) (ttl 64, id 0, len 1472)
10:30:48.200415 guard > pegasus: icmp: bird unreachable - need to frag (mtu 1442) for pegasus.2049 > bird.2447018952: reply ok 1444 (DF) (ttl 63, id 0, len 1472) [tos 0xc0]  (ttl 64, id 6058, len 576)
                                       ^^^^                                                          ^^^^
    trouble. bird is not supposed to be visible.
    note that there are two instances of bird
    in the icmp reply, second one is definitely bogus.
    pegasus obviosly ignore this icmp.

    now client will retry forever:

10:30:48.512224 guard.2447018952 > pegasus.2049: 112 read fh Unknown/1 4096 bytes @ 0x000000000 (DF) (ttl 62, id 0, len 140)
10:30:48.512750 pegasus.2049 > guard.2447018952: reply ok 1444 read REG 100444 ids 0/0 sz 0x000000524 nlink 1 rdev 0/0 fsid 0x000000000 nodeid 0x000000000 a/m/ctime 1056100000.000000 1056100000.000000 1060767135.000000 1316 bytes EOF (DF) (ttl 64, id 0, len 1472)
10:30:48.513744 guard > pegasus: icmp: bird unreachable - need to frag (mtu 1442) for pegasus.2049 > bird.2447018952: reply ok 1444 (DF) (ttl 63, id 0, len 1472) [tos 0xc0]  (ttl 64, id 6059, len 576)

10:30:49.162199 guard.2447018952 > pegasus.2049: 112 read fh Unknown/1 4096 bytes @ 0x000000000 (DF) (ttl 62, id 0, len 140)
10:30:49.163172 pegasus.2049 > guard.2447018952: reply ok 1444 read REG 100444 ids 0/0 sz 0x000000524 nlink 1 rdev 0/0 fsid 0x000000000 nodeid 0x000000000 a/m/ctime 1056100000.000000 1056100000.000000 1060767135.000000 1316 bytes EOF (DF) (ttl 64, id 0, len 1472)
10:30:49.164208 guard > pegasus: icmp: bird unreachable - need to frag (mtu 1442) for pegasus.2049 > bird.2447018952: reply ok 1444 (DF) (ttl 63, id 0, len 1472) [tos 0xc0]  (ttl 64, id 6060, len 576)

10:30:50.432154 guard.2447018952 > pegasus.2049: 112 read fh Unknown/1 4096 bytes @ 0x000000000 (DF) (ttl 62, id 0, len 140)
10:30:50.433050 pegasus.2049 > guard.2447018952: reply ok 1444 read REG 100444 ids 0/0 sz 0x000000524 nlink 1 rdev 0/0 fsid 0x000000000 nodeid 0x000000000 a/m/ctime 1056100000.000000 1056100000.000000 1060767135.000000 1316 bytes EOF (DF) (ttl 64, id 0, len 1472)
10:30:50.434006 guard > pegasus: icmp: bird unreachable - need to frag (mtu 1442) for pegasus.2049 > bird.2447018952: reply ok 1444 (DF) (ttl 63, id 0, len 1472) [tos 0xc0]  (ttl 64, id 6061, len 576)
...

guard:/# uname -a;lsmod
Linux guard 2.4.20 #4 SMP Tue Feb 4 16:40:52 GMT-2 2003 i586 unknown
Module                  Size  Used by    Not tainted
ipt_LOG                 3352   1  (autoclean)
nls_cp866               3836   0  (autoclean)
nls_koi8-r              3836   0  (autoclean)
smbfs                  34352   0  (autoclean)
af_packet              10024   0  (autoclean)
nls_iso8859-1           2844   0  (autoclean)
nls_cp437               4348   0  (autoclean)
autofs                 10356   1
ipt_MASQUERADE          1368   2  (autoclean)
ipt_REDIRECT             728  11  (autoclean)
ipt_state                536   1  (autoclean)
iptable_mangle          2072   1  (autoclean)
iptable_filter          1644   0  (autoclean) (unused)
ip_nat_ftp              2992   0  (unused)
iptable_nat            15256   2  [ipt_MASQUERADE ipt_REDIRECT ip_nat_ftp]
ip_tables              11480   9  [ipt_LOG ipt_MASQUERADE ipt_REDIRECT ipt_state iptable_mangle iptable_filter iptable_nat]
ip_conntrack_ftp        3888   1  [ip_nat_ftp]
ip_conntrack           19808   3  [ipt_MASQUERADE ipt_REDIRECT ipt_state ip_nat_ftp iptable_nat ip_conntrack_ftp]
cipcb                  28136   1

pegasus:/# uname -a;lsmod
Linux pegasus 2.4.21-ep #1 SMP Thu Jul 17 14:04:00 GMT-3 2003 i686 unknown
Module                  Size  Used by    Not tainted
iptable_mangle          2104   0  (autoclean) (unused)
iptable_nat            16216   0  (autoclean) (unused)
ip_conntrack           19976   1  (autoclean) [iptable_nat]
nfsd                   64624   4
iptable_filter          1644   0  (autoclean) (unused)
ip_tables              11640   5  [iptable_mangle iptable_nat iptable_filter]
autofs                 10356   1
cipcb                  28136   1
af_packet              10024   1  (autoclean)
--
vda
