From: "dravya" <dravya@magma.ca>
Subject: ICMP echo-requests picking wrong src ip addr: "if
	(!(info->initialized & (1 << maniptype)))" is failing
Date: Thu, 11 Nov 2004 10:36:15 -0500 (EST)
Message-ID: <200411111536.iABFaFbw013154@webmail1.magma.ca>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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


Hi all,
 
To follow up on the ICMP (echo-requests) going on the wrong link:
 
again the setup is as follows:
 
SETUP:
                      ppp0     ppp1
                       |        |
                  ---------------------
                 | Linux box (2.4.20)  |
                  ---------------------
                            |
                            |
      Laptop (Any client with the Linux box as gateway)

ppp0: 204.101.96.124 
ppp1: 204.101.89.67

>From the Laptop, I am pinging an external site (www.nba.com) and there are some
echo-requests that pick the wrong src address for the given interface in outdev/out.

After much testing, I have narrowed down the problem to the ip_nat_fn() function in
ip_nat_standalone.c file. In ip_nat_fn(), the if condition "if (!(info->initialized & (1
<< maniptype)))" returns a false for some type=8 ICMP packets and therefore bypasses the
call to ip_nat_rule_find() (which eventually calls the MASQUERADE code). 

Once the output interface is chosen (ppp0 or ppp1), I feel the packet should follow the
following path:

nf_hook_slow() -> nf_iterate() -> ip_nat_out()/ip_nat_local_fn() (depending on which chain
we are in) -> ip_nat_fn() -> ip_nat_rule_find() -> ipt_do_table() -> TARGET (MASQERADE in
this case)


The following is a packet that has followed the above path and has picked the correct IP
address for the specified interface (in this case ppp0):

===============================================================================
Nov 10 12:15:18 localhost kernel: netfilter.c: nf_hook_slow(): About to call nf_iterate()
-- prot:1 | src=192.168.1.85:17664
| dst=65.216.78.74:60|outdev=ppp0
Nov 10 12:15:18 localhost kernel: netfilter.c: nf_iterate(): Entered nf_iterate() --
prot:1 | src=192.168.1.85:17664 | dst=65.216.78.74:60|outdev=ppp0
Nov 10 12:15:18 localhost kernel: ip_nat_standalone.c:ip_nat_out():About to call
ip_nat_fn(), in NF_IP_POST_ROUTING--
prot:1|src=192.168.1.85:17664|dst=65.216.78.74:60|type=8 seq=59652|out=ppp0
Nov 10 12:15:18 localhost kernel: ip_nat_standalone.c: ip_nat_fn(): Entered ip_nat_fn() --
prot:1 | src=192.168.1.85:17664 |
dst=65.216.78.74:60 | type=8 seq=59652|out=ppp0
Nov 10 12:15:18 localhost kernel: ip_nat_standalone.c:ip_nat_fn(): ctinfo is IP_CT_NEW--
prot:1|src=192.168.1.85:17664|dst=65.216.78.74:60|type=8 seq=59652|out=ppp0
Nov 10 12:15:18 localhost kernel: ip_nat_standalone.c:ip_nat_fn():About to call
ip_nat_rule_find()-- prot:1|src=192.168.1.85:17664|dst=65.216.78.74:60|type=8
seq=59652|out=ppp0
Nov 10 12:15:18 localhost kernel: ip_tables.c: ipt_do_table():  Entered ipt_do_table() --
prot:1 | src=192.168.1.85:17664 | dst=65.216.78.74:60
Nov 10 12:15:18 localhost kernel: ip_tables.c: ipt_do_table():  Target MASQUERADE entered!
-- prot:1 | src=192.168.1.85:17664 | dst=65.216.78.74:60
Nov 10 12:15:18 localhost kernel: MASQ_NEW: Did IP_NF_ASSERT().
Nov 10 12:15:18 localhost kernel: MASQ_NEW: '(*pskb)->sk' does not exist.
Nov 10 12:15:18 localhost kernel: MASQ_NEW: prot:1 | src=192.168.1.85:17664 |
dst=65.216.78.74:60
Nov 10 12:15:18 localhost kernel: MASQ_NEW: ICMP PACKET: type is 8 and sequence num is 59652
Nov 10 12:15:18 localhost kernel: MASQ_NEW: out->name is ppp0
Nov 10 12:15:18 localhost kernel: MASQ_NEW: newsrc = 204.101.96.124
Nov 10 12:15:18 localhost kernel: MASQ_NEW: About to call ip_nat_setup_info() .
Nov 10 12:15:18 localhost kernel: ip_tables.c: ipt_do_table():  Target MASQUERADE exited!
-- prot:1 | src=192.168.1.85:17664
| dst=65.216.78.74:60
Nov 10 12:15:18 localhost kernel: ip_nat_standalone.c:ip_nat_fn():Returned from
ip_nat_rule_find()-- prot:1|src=192.168.1.85:17664|dst=65.216.78.74:60|type=8
seq=59652|out=ppp0
Nov 10 12:15:18 localhost kernel: netfilter.c: nf_hook_slow(): Returned from nf_iterate()
-- prot:1 | src=204.101.96.124:17664 | dst=65.216.78.74:60|outdev=ppp0
                   |          					|
                   |          					|
		   -----------------------------------------------------> ppp0 = 204.101.96.124 



The following packet did not follow the above path (did not go through MASQUERADE) and
PICKED the WRONG SRC IP ADDRESS for ppp1. The following is the packet:

===============================================================================
Nov 10 12:15:21 localhost kernel: netfilter.c: nf_hook_slow(): About to call nf_iterate()
-- prot:1 | src=192.168.1.85:17664
| dst=65.216.78.74:60|outdev=ppp1
Nov 10 12:15:21 localhost kernel: netfilter.c: nf_iterate(): Entered nf_iterate() --
prot:1 | src=192.168.1.85:17664 | dst=65.216.78.74:60|outdev=ppp1
Nov 10 12:15:21 localhost kernel: ip_nat_standalone.c:ip_nat_out():About to call
ip_nat_fn(), in NF_IP_POST_ROUTING--
prot:1|src=192.168.1.85:17664|dst=65.216.78.74:60|type=8 seq=59908|out=ppp1
Nov 10 12:15:21 localhost kernel: ip_nat_standalone.c: ip_nat_fn(): Entered ip_nat_fn() --
prot:1 | src=192.168.1.85:17664 |
dst=65.216.78.74:60 | type=8 seq=59908|out=ppp1
Nov 10 12:15:21 localhost kernel: ip_nat_standalone.c:ip_nat_fn(): ctinfo is IP_CT_NEW--
prot:1|src=192.168.1.85:17664|dst=65.216.78.74:60|type=8 seq=59908|out=ppp1
Nov 10 12:15:21 localhost kernel: ip_nat_standalone.c:ip_nat_fn():Already setup manip--
prot:1|src=192.168.1.85:17664|dst=65.216.78.74:60|type=8 seq=59908|out=ppp1
Nov 10 12:15:21 localhost kernel: netfilter.c: nf_hook_slow(): Returned from nf_iterate()
-- prot:1 | src=204.101.96.124:17664 | dst=65.216.78.74:60|outdev=ppp1
                   |          					|
                   |          					|
		   -----------------------------------------------------> ppp1 != 204.101.96.124 
									  ppp0 =  204.101.96.124 

 

"Nov 10 12:15:21 localhost kernel: ip_nat_standalone.c:ip_nat_fn():Already setup manip--
prot:1|src=192.168.1.85:17664|dst=65.216.78.74:60|type=8 seq=59908|out=ppp1" 

Doesn't the above kernel output suggest that it has seen the packet previously and hence
the "if (!(info->initialized & (1 << maniptype)))" condition is not satisfied? How can
that be? Surely there can be no retransmissions of an icmp packet right?? Has this problem
been addressed before? There have been modifications made to the kernel's load balancing
algorithm, however, once the interface has been selected and ip_output_finish() passes it
down (outdev), shouldn't the rest of the traversal just pick the corresponding IP Address?
This is exactly what the MASQUERADE code is doing (with Rusty's new patch), but some
packets are bypassing it. 

Any help/comments/lead is greatly appreciated.

Dravya
