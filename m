From: Alistair Tonner <Alistair@nerdnet.ca>
Subject: FYI only - bug filed downstream - Gentoo-dev-sources 2.6.10-r5
	iptables 1.2.11 kernel panic udp_manip_pkt
Date: Sat, 5 Feb 2005 17:54:23 -0500
Message-ID: <200502051754.24311.Alistair@nerdnet.ca>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


 Please note I am filing this downstream first -- this is an FYI

 kernel 2.6.10 (gentoo-dev-sources gentoo-2.6.10-r5) 
 iptables 1.2.11 
 
 kernel built, booted and running,  iptables REBUILT after kernel build, 
pointing into new kernel

 Kernel Panic, not syncing:
 
 EIP upd_manip_pkt + 0xbb/0xd0 -- iptable_nat
 eax: c9eb3f44 ebx: d21c4844  ecx: 00000001 edx: 00000000
 esi: d2592858 edi: c05c2ddc ebp: c05c2cd8 esp: c05c2cc0
 ds 007b es 007b ss0068

 process swapper pid 0 threadinfo c05c2000 task c04dcba0

 results from a downstream windows 2k system logging onto MSN

 This box is using ip route2 dual routing loadbalanced through two upstream 
providers successfully.  The same signon is successfull on gentoo-dev-sources 
2.6.9-r11 with iptables 1.2.11 (even after the rebuild of iptables against 
2.6.9-r5!)

 I don't have a ksymoops breakdown yet -- the oops doesn't get saved of course 
and I'm not 100% on using ksymoops manually yet. *grin*

 the backtrace shows 
 icmp_reply_translation -> manip_pkt -> error_code -> OOPS.

 I see only a few changes between the two kernels in ip_nat_proto_udp.c:

diff 
ip_nat_proto_udp.c /usr/src/linux-2.6.9-gentoo-r11/net/ipv4/netfilter/ip_nat_proto_udp.c
86c86
<             unsigned int iphdroff,
---
        >             unsigned int hdroff,
90d89
<       struct iphdr *iph = (struct iphdr *)((*pskb)->data + iphdroff);
92d90
<       unsigned int hdroff = iphdroff + iph->ihl*4;
102c100
<               oldip = iph->saddr;
---
      >               oldip = (*pskb)->nh.iph->saddr;
106c104
<               oldip = iph->daddr;
---
      >               oldip = (*pskb)->nh.iph->daddr;


 I'm still looking, but if anyone sees anything glaringly obvious, please 
holler at me on netfilter@lists.netfilter.org 

 Thanks for all the great work Netfilter

 Alistair Tonner
 RSO Unix support admin

 and linux addict.



 
