From: Patrick McHardy <kaber@trash.net>
Subject: Re: Bug with netfilter and NFS server on same machine (fwd)
Date: Mon, 09 Dec 2002 16:17:24 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DF4B404.6050609@trash.net>
References: <Pine.LNX.4.44.0211231342530.3237-100000@sparrow> <20021205202119.GH11068@naboo.club.berlin.ccc.de> <3DEFF5B2.1050106@trash.net> <20021209141801.GD2223@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000105020702010005070801"
Cc: William Stearns <wstearns@pobox.com>,
   ML-netfilter-devel <netfilter-devel@lists.netfilter.org>,
   Lars Knudsen <gandalfit@virgilio.it>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20021209141801.GD2223@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------000105020702010005070801
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Harald,

Harald Welte wrote:

>On Fri, Dec 06, 2002 at 01:56:18AM +0100, Patrick McHardy wrote:
>  
>
>>Hi,
>>
>>Harald Welte wrote:
>>    
>>
>>I experienced the same problem since almost 6 months with nfs and netfilter,
>>nfs was veery slow, it wasn't even possible to listen to mp3s over nfs.
>>    
>>
>
>I have experienced the problem the last two days, which I was running a
>debian woody system with an 2.4.18-k7 kernel.  I've now compiled my own
>kernel again (2.4.20-final with lots of patch-o-matic stuff) and the
>problem is gone again [nothing but the kernel on the conntracking
>nfs-serve was changed].
>
The machine making troubles here only runs self-compiled kernels.
IIRC it started with 2.4.18, also lots of patch-o-matic stuff applied.
Since then i've tried a lot kernels, with- and without pom,
atm i'm running 2.4.19-rc4-ac1, attached is a list of applied pom-patches.
If you send me a list of your patches i can try if it helps here.
Also if you would like to have a look for yourself i could create an 
account for you ...

>I'm running lots of Conectiva and Redhat systems with 2.4.18+ kernels
>and don't have this particular conntrack problem on any machine.
>
Here is how tcpdump looks with nfs-server(+conntrack) mtu set to 1500:

0:e0:7d:74:ab:cc 0:e0:7d:74:ab:cd 0800 1514: 192.168.0.1 > 192.168.0.23: 
(frag 16283:1480@4440+) (ttl 64, len 1500)
0:e0:7d:74:ab:cc 0:e0:7d:74:ab:cd 0800 1514: 192.168.0.1 > 192.168.0.23: 
(frag 16284:1480@2960+) (ttl 64, len 1500)
0:e0:7d:74:ab:cc 0:e0:7d:74:ab:cd 0800 1514: 192.168.0.1 > 192.168.0.23: 
(frag 16284:1480@4440+) (ttl 64, len 1500)
0:e0:7d:74:ab:cc 0:e0:7d:74:ab:cd 0800 1514: 192.168.0.1 > 192.168.0.23: 
(frag 16284:1480@5920+) (ttl 64, len 1500)
0:e0:7d:74:ab:cc 0:e0:7d:74:ab:cd 0800 962: 192.168.0.1 > 192.168.0.23: 
(frag 16284:928@7400) (ttl 64, len 948)
0:e0:7d:74:ab:cd 0:e0:7d:74:ab:cc 0800 154: 192.168.0.23.359760184 > 
192.168.0.1.2049: 112 read [|nfs] (DF) (ttl 64, id 0, len 140)
0:e0:7d:74:ab:cc 0:e0:7d:74:ab:cd 0800 1514: 192.168.0.1.2049 > 
192.168.0.23.359760184: reply ok 1472 read REG 100644 ids 0/0 [|nfs] 
(frag 16285:1480@0+) (ttl 64, len 1500)
0:e0:7d:74:ab:cc 0:e0:7d:74:ab:cd 0800 1514: 192.168.0.1 > 192.168.0.23: 
(frag 16284:1480@4440+) (ttl 64, len 1500)
0:e0:7d:74:ab:cc 0:e0:7d:74:ab:cd 0800 1514: 192.168.0.1 > 192.168.0.23: 
(frag 16285:1480@2960+) (ttl 64, len 1500)
0:e0:7d:74:ab:cc 0:e0:7d:74:ab:cd 0800 1514: 192.168.0.1 > 192.168.0.23: 
(frag 16285:1480@4440+) (ttl 64, len 1500)
0:e0:7d:74:ab:cc 0:e0:7d:74:ab:cd 0800 1514: 192.168.0.1 > 192.168.0.23: 
(frag 16285:1480@5920+) (ttl 64, len 1500)
0:e0:7d:74:ab:cc 0:e0:7d:74:ab:cd 0800 962: 192.168.0.1 > 192.168.0.23: 
(frag 16285:928@7400) (ttl 64, len 948)
0:e0:7d:74:ab:cd 0:e0:7d:74:ab:cc 0800 590: 192.168.0.23 > 192.168.0.1: 
icmp: ip reassembly time exceeded [tos 0xc0]  (ttl 64, id 18135, len 576)
0:e0:7d:74:ab:cd 0:e0:7d:74:ab:cc 0800 590: 192.168.0.23 > 192.168.0.1: 
icmp: ip reassembly time exceeded [tos 0xc0]  (ttl 64, id 18136, len 576)
0:e0:7d:74:ab:cd 0:e0:7d:74:ab:cc 0800 590: 192.168.0.23 > 192.168.0.1: 
icmp: ip reassembly time exceeded [tos 0xc0]  (ttl 64, id 18137, len 576)
0:e0:7d:74:ab:cd 0:e0:7d:74:ab:cc 0800 590: 192.168.0.23 > 192.168.0.1: 
icmp: ip reassembly time exceeded [tos 0xc0]  (ttl 64, id 18138, len 576)
0:e0:7d:74:ab:cd 0:e0:7d:74:ab:cc 0800 590: 192.168.0.23 > 192.168.0.1: 
icmp: ip reassembly time exceeded [tos 0xc0]  (ttl 64, id 18139, len 576)
0:e0:7d:74:ab:cd 0:e0:7d:74:ab:cc 0800 590: 192.168.0.23 > 192.168.0.1: 
icmp: ip reassembly time exceeded [tos 0xc0]  (ttl 64, id 18140, len 576)
0:e0:7d:74:ab:cd 0:e0:7d:74:ab:cc 0800 590: 192.168.0.23 > 192.168.0.1: 
icmp: ip reassembly time exceeded [tos 0xc0]  (ttl 64, id 18141, len 576)
0:e0:7d:74:ab:cd 0:e0:7d:74:ab:cc 0800 590: 192.168.0.23 > 192.168.0.1: 
icmp: ip reassembly time exceeded [tos 0xc0]  (ttl 64, id 18142, len 576)
...

with mtu 1486 tcpdump looks like this (no icmp reassemly time exceeded):
0:e0:7d:74:ab:cc 0:e0:7d:74:ab:cd 0800 1498: 192.168.0.1 > 192.168.0.23: 
(frag 16436:1464@1464+) (ttl 64, len 1484)
0:e0:7d:74:ab:cc 0:e0:7d:74:ab:cd 0800 1498: 192.168.0.1 > 192.168.0.23: 
(frag 16436:1464@2928+) (ttl 64, len 1484)
0:e0:7d:74:ab:cc 0:e0:7d:74:ab:cd 0800 1498: 192.168.0.1 > 192.168.0.23: 
(frag 16436:1464@4392+) (ttl 64, len 1484)
0:e0:7d:74:ab:cc 0:e0:7d:74:ab:cd 0800 1498: 192.168.0.1 > 192.168.0.23: 
(frag 16436:1464@5856+) (ttl 64, len 1484)
0:e0:7d:74:ab:cd 0:e0:7d:74:ab:cc 0800 154: 192.168.0.23.2339471672 > 
192.168.0.1.2049: 112 read [|nfs] (DF) (ttl 64, id 0, len 140)
0:e0:7d:74:ab:cc 0:e0:7d:74:ab:cd 0800 1042: 192.168.0.1 > 192.168.0.23: 
(frag 16436:1008@7320) (ttl 64, len 1028)
0:e0:7d:74:ab:cc 0:e0:7d:74:ab:cd 0800 1498: 192.168.0.1.2049 > 
192.168.0.23.2339471672: reply ok 1456 read REG 100644 ids 0/0 [|nfs] 
(frag 16437:1464@0+) (ttl 64, len 1484)
...

Bye,
Patrick

--------------000105020702010005070801
Content-Type: text/plain;
 name="ipt_patch_list"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_patch_list"

fuzzy.patch ALREADY APPLIED (0 rejects out of 2 hunks).
iplimit.patch ALREADY APPLIED (0 rejects out of 2 hunks).
ipt_unclean-ubit.patch ALREADY APPLIED (0 rejects out of 1 hunks).
ipv4options.patch ALREADY APPLIED (0 rejects out of 2 hunks).
NETMAP.patch ALREADY APPLIED (0 rejects out of 1 hunks).
nth.patch ALREADY APPLIED (0 rejects out of 2 hunks).
pool.patch ALREADY APPLIED (0 rejects out of 5 hunks).
quota.patch ALREADY APPLIED (0 rejects out of 2 hunks).
random.patch ALREADY APPLIED (0 rejects out of 2 hunks).
condition.patch ALREADY APPLIED (0 rejects out of 2 hunks).
CONNMARK.patch ALREADY APPLIED (0 rejects out of 7 hunks).
h323-conntrack-nat.patch ALREADY APPLIED (0 rejects out of 3 hunks).
ip_tables-proc.patch ALREADY APPLIED (0 rejects out of 5 hunks).
ROUTE.patch ALREADY APPLIED (0 rejects out of 2 hunks).
string.patch ALREADY APPLIED (0 rejects out of 2 hunks).
CONNMARK.patch ALREADY APPLIED (1 rejects out of 7 hunks).
ip_conntrack_find.patch ALREADY APPLIED (0 rejects out of 1 hunks).
ip_ct_refresh_optimization.patch ALREADY APPLIED (3 rejects out of 7 hunks).
newnat-udp-helper.patch ALREADY APPLIED (0 rejects out of 8 hunks).
2.4.18.patch ALREADY APPLIED (5 rejects out of 63 hunks).
ahesp-static.patch ALREADY APPLIED (0 rejects out of 1 hunks).
arptables.patch ALREADY APPLIED (1 rejects out of 4 hunks).
conntrack+nat-helper-unregister.patch ALREADY APPLIED (1 rejects out of 6 hunks).
conntrack.patch ALREADY APPLIED (0 rejects out of 2 hunks).
dscp.patch ALREADY APPLIED (0 rejects out of 2 hunks).
DSCP.patch ALREADY APPLIED (0 rejects out of 2 hunks).
ecn.patch ALREADY APPLIED (0 rejects out of 2 hunks).
ECN.patch ALREADY APPLIED (0 rejects out of 2 hunks).
helper.patch ALREADY APPLIED (0 rejects out of 2 hunks).
ip6tables-export-symbols.patch ALREADY APPLIED (1 rejects out of 2 hunks).
ip_conntrack_protocol_unregister.patch ALREADY APPLIED (2 rejects out of 5 hunks).
ip_nat_irc-srcaddr-fix.patch ALREADY APPLIED (2 rejects out of 4 hunks).
ipt_MIRROR-ttl.patch ALREADY APPLIED (0 rejects out of 3 hunks).
ipt_REJECT-checkentry.patch ALREADY APPLIED (0 rejects out of 1 hunks).
ipt_unclean-ecn.patch ALREADY APPLIED (0 rejects out of 2 hunks).
irc-dcc-mask.patch ALREADY APPLIED (1 rejects out of 2 hunks).
local-nat.patch ALREADY APPLIED (0 rejects out of 13 hunks).
macro-trailing-semicolon-fix.patch ALREADY APPLIED (0 rejects out of 4 hunks).
mangle5hooks.patch ALREADY APPLIED (0 rejects out of 16 hunks).
nat-export_symbols.patch ALREADY APPLIED (1 rejects out of 2 hunks).
nat-memoryleak-fix.patch ALREADY APPLIED (0 rejects out of 1 hunks).
netfilter-arp.patch ALREADY APPLIED (1 rejects out of 5 hunks).
ownercmd.patch ALREADY APPLIED (0 rejects out of 3 hunks).
pkttype.patch ALREADY APPLIED (0 rejects out of 2 hunks).
REJECT-dont_fragment.patch ALREADY APPLIED (0 rejects out of 1 hunks).
REJECT_mark.patch ALREADY APPLIED (0 rejects out of 1 hunks).
skb_clone_copy.patch ALREADY APPLIED (1 rejects out of 5 hunks).
TOS-oops-fix.patch ALREADY APPLIED (0 rejects out of 1 hunks).
ulog-module-unload.patch ALREADY APPLIED (1 rejects out of 2 hunks).
ulog-nlgroup-shift-fix.patch ALREADY APPLIED (1 rejects out of 11 hunks).
ulog-sparc-bitops-fix.patch ALREADY APPLIED (0 rejects out of 1 hunks).
unclean-udpchecksum.patch ALREADY APPLIED (0 rejects out of 2 hunks).
z-newnat16.patch ALREADY APPLIED (9 rejects out of 110 hunks).
z-newnat_assertfix.patch ALREADY APPLIED (0 rejects out of 7 hunks).
z-newnat_changeexpect-lockfix.patch ALREADY APPLIED (0 rejects out of 2 hunks).
ipt_REJECT-fake-source.patch ALREADY APPLIED (0 rejects out of 7 hunks).

--------------000105020702010005070801--
