From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] modification in current protocol helper API to handle
 error/unclean packets
Date: Tue, 22 Jun 2004 14:19:57 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40D823ED.4000800@eurodev.net>
References: <Pine.LNX.4.33.0406141551410.12847-100000@blackhole.kfki.hu>	 <40D18A0B.2070101@eurodev.net> <1087759076.9146.32.camel@tux.rsn.bth.se> <40D60A2D.2080800@eurodev.net> <40D626CB.9090102@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030005070901030904030309"
Cc: Martin Josefsson <gandalf@wlug.westbo.se>,
 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <40D626CB.9090102@trash.net>
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
--------------030005070901030904030309
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Patrick,

Patrick McHardy wrote:

> You should use the defined types for better readability. Something like
> this ..


now it uses the defined types. It applies to pom-ng, thanks.

regards,
Pablo

--------------030005070901030904030309
Content-Type: text/x-patch;
 name="linux-2.6.patch_02-udp-icmp-CVS.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6.patch_02-udp-icmp-CVS.patch"

--- linux-2.6.patch_02-udp-icmp	2004-06-22 13:43:04.000000000 +0200
+++ patch	2004-06-22 13:53:02.000000000 +0200
@@ -1,6 +1,6 @@
-diff -urN --exclude-from=/usr/src/diff.exclude linux-2.6.6-ct_error_api/net/ipv4/netfilter/ip_conntrack_proto_icmp.c linux-2.6.6-ct_error_api-udp/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
---- linux-2.6.6-ct_error_api/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2004-06-18 08:13:51.000000000 +0200
-+++ linux-2.6.6-ct_error_api-udp/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2004-06-18 15:14:01.000000000 +0200
+diff -u -r1.2 ip_conntrack_proto_icmp.c
+--- a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	22 Jun 2004 11:44:08 -0000	1.2
++++ b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	22 Jun 2004 11:52:17 -0000
 @@ -13,6 +13,8 @@
  #include <linux/in.h>
  #include <linux/icmp.h>
@@ -10,7 +10,46 @@
  #include <linux/netfilter_ipv4/ip_conntrack.h>
  #include <linux/netfilter_ipv4/ip_conntrack_core.h>
  #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
-@@ -126,9 +128,9 @@
+@@ -25,6 +27,38 @@
+ #define DEBUGP(format, args...)
+ #endif
+ 
++#define OK 1
++#define IV 0
++
++#define ICMP_ROUTER_ADV	9
++#define ICMP_ROUTER_SEL	10
++
++/* ICMP types and codes described in RFC's:
++ * 	- 792: Internet Control Message Protocol. Most types.
++ * 	- 1256: ICMP Router Discovery Messages. Types 9 and 10.
++ * 	- 950: Internet Standard Subnetting Procedure. Types 17 and 18.
++ * 	- 1812: Requirements for IP Version 4 Routers. Type 3. Section 5.2.7.1
++ */
++static u_int8_t icmp_valid[NR_ICMP_TYPES+1][NR_ICMP_UNREACH+1] = 
++{
++	/*                          0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 */
++	[ICMP_ECHOREPLY]	= {OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
++	[ICMP_DEST_UNREACH]	= {OK,OK,OK,OK,OK,OK,OK,OK,OK,OK,OK,OK,OK,OK,OK,OK},
++	[ICMP_SOURCE_QUENCH]	= {OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
++	[ICMP_REDIRECT] 	= {OK,OK,OK,OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
++	[ICMP_ECHO]		= {OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
++	[ICMP_ROUTER_ADV]	= {OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
++	[ICMP_ROUTER_SEL]	= {OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
++	[ICMP_TIME_EXCEEDED]	= {OK,OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
++	[ICMP_PARAMETERPROB]	= {OK,OK,OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
++	[ICMP_TIMESTAMP]	= {OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
++	[ICMP_TIMESTAMPREPLY]	= {OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
++	[ICMP_INFO_REQUEST]	= {OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
++	[ICMP_INFO_REPLY]	= {OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
++	[ICMP_ADDRESS]		= {OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
++	[ICMP_ADDRESSREPLY]	= {OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
++};
++
+ static int icmp_pkt_to_tuple(const struct sk_buff *skb,
+ 			     unsigned int dataoff,
+ 			     struct ip_conntrack_tuple *tuple)
+@@ -126,9 +160,9 @@
  }
  
  static int
@@ -23,7 +62,7 @@
  {
  	struct ip_conntrack_tuple innertuple, origtuple;
  	struct {
-@@ -145,13 +147,6 @@
+@@ -145,13 +179,6 @@
  	if (skb_copy_bits(skb, skb->nh.iph->ihl*4, &inside, sizeof(inside))!=0)
  		return NF_ACCEPT;
  
@@ -37,7 +76,7 @@
  	/* Ignore ICMP's containing fragments (shouldn't happen) */
  	if (inside.ip.frag_off & htons(IP_OFFSET)) {
  		DEBUGP("icmp_error_track: fragment of proto %u\n",
-@@ -201,6 +196,69 @@
+@@ -201,6 +228,85 @@
  	return -NF_ACCEPT;
  }
  
@@ -93,6 +132,22 @@
 +		return -NF_ACCEPT;
 +	}
 +
++	/* 15 is the highest 'known' ICMP code. See RFC 1812 */
++	if (icmph.code > NR_ICMP_UNREACH) {
++		if (LOG_INVALID(IPPROTO_ICMP))
++			nf_log_packet(PF_INET, 0, skb, NULL, NULL,
++				      "ip_ct_icmp: invalid ICMP code ");
++		return -NF_ACCEPT;
++	}
++
++	/* check for invalid combinations */
++	if (!icmp_valid[icmph.type][icmph.code]) {
++		if (LOG_INVALID(IPPROTO_ICMP))
++			nf_log_packet(PF_INET, 0, skb, NULL, NULL,
++				      "ip_ct_icmp: invalid ICMP type/code ");
++ 		return -NF_ACCEPT;
++ 	}
++
 +	/* Need to track icmp error message? */
 +	if (icmph.type != ICMP_DEST_UNREACH
 +	    && icmph.type != ICMP_SOURCE_QUENCH
@@ -107,9 +162,9 @@
  struct ip_conntrack_protocol ip_conntrack_protocol_icmp =
  {
  	.proto 			= IPPROTO_ICMP,
-diff -urN --exclude-from=/usr/src/diff.exclude linux-2.6.6-ct_error_api/net/ipv4/netfilter/ip_conntrack_proto_udp.c linux-2.6.6-ct_error_api-udp/net/ipv4/netfilter/ip_conntrack_proto_udp.c
---- linux-2.6.6-ct_error_api/net/ipv4/netfilter/ip_conntrack_proto_udp.c	2004-06-18 07:37:24.000000000 +0200
-+++ linux-2.6.6-ct_error_api-udp/net/ipv4/netfilter/ip_conntrack_proto_udp.c	2004-06-18 15:39:58.000000000 +0200
+diff -u -r1.2 ip_conntrack_proto_udp.c
+--- a/net/ipv4/netfilter/ip_conntrack_proto_udp.c	22 Jun 2004 11:44:09 -0000	1.2
++++ b/net/ipv4/netfilter/ip_conntrack_proto_udp.c	22 Jun 2004 11:48:49 -0000
 @@ -12,6 +12,8 @@
  #include <linux/netfilter.h>
  #include <linux/in.h>

--------------030005070901030904030309--
