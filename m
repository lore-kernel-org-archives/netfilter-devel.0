From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] modification in current protocol helper API to handle
 error/unclean packets
Date: Mon, 21 Jun 2004 00:05:33 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40D60A2D.2080800@eurodev.net>
References: <Pine.LNX.4.33.0406141551410.12847-100000@blackhole.kfki.hu>	 <40D18A0B.2070101@eurodev.net> <1087759076.9146.32.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030603050006070404070404"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>,
 Patrick McHardy <kaber@trash.net>,
 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <1087759076.9146.32.camel@tux.rsn.bth.se>
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
--------------030603050006070404070404
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Martin,

Martin Josefsson wrote:

>>- Jozsef, I resolve to use your inverse return value but I must confess 
>>that I'm still thinking about another way to do that with no sucess, 
>>    
>>
>
>Instead of checking for a negative returnvalue as we do today we check
>!= CONNTRACK_CONT and then return the value previously returned to us.
>
>In my oppinion that would greatly improve the readability of the code.
>The mixing of negative and positive values using the same macro 
>confuses me sometimes to say the least. I bet I'm not the only one that
>sometimes has to look twice at the return value.
>  
>

sure, I like it. If Jozsef don't tell us that we are missing something, 
I will be fine with that.

>>well this issue is not important. BTW, you also modified conntrack core 
>>in your tcp-window-tracking patch, do you think that I could add that 
>>part to my patch since I think that it's more related stuff and your 
>>patch will go on top of this?
>>- I'll work on that extra patch to check for malformed udp/icmp packets 
>>these days.
>>    
>>
>
>I fixed the length checking in the udp part of the second patch.
>It compared lengths in network byteorder, added two missing ntohs()
>Now udp works again :)
>  
>

thanks for that Martin.

Would you be willing to apply the patch attached to pom-ng? It applies 
to linux-2.6.patch_02-udp-icmp and it adds more checkings for invalid 
icmp combinations.

regards,
Pablo

--------------030603050006070404070404
Content-Type: text/x-patch;
 name="linux-2.6.patch_02-udp-icmp-CVS.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6.patch_02-udp-icmp-CVS.patch"

--- linux-2.6.patch_02-udp-icmp	2004-06-19 18:45:11.000000000 +0200
+++ patch	2004-06-20 23:40:08.000000000 +0200
@@ -1,6 +1,6 @@
-diff -urN --exclude-from=/usr/src/diff.exclude linux-2.6.6-ct_error_api/net/ipv4/netfilter/ip_conntrack_proto_icmp.c linux-2.6.6-ct_error_api-udp/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
---- linux-2.6.6-ct_error_api/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2004-06-18 08:13:51.000000000 +0200
-+++ linux-2.6.6-ct_error_api-udp/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2004-06-18 15:14:01.000000000 +0200
+diff -u -r1.4 ip_conntrack_proto_icmp.c
+--- a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	20 Jun 2004 21:22:07 -0000	1.4
++++ b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	20 Jun 2004 21:39:49 -0000
 @@ -13,6 +13,8 @@
  #include <linux/in.h>
  #include <linux/icmp.h>
@@ -10,7 +10,73 @@
  #include <linux/netfilter_ipv4/ip_conntrack.h>
  #include <linux/netfilter_ipv4/ip_conntrack_core.h>
  #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
-@@ -126,9 +128,9 @@
+@@ -25,6 +27,65 @@
+ #define DEBUGP(format, args...)
+ #endif
+ 
++#define OK 1
++#define IV 0
++
++/* ICMP types and codes described in RFC's:
++ * 	- 792: Internet Control Message Protocol. Most types.
++ * 	- 1256: ICMP Router Discovery Messages. Types 9 and 10.
++ * 	- 950: Internet Standard Subnetting Procedure. Types 17 and 18.
++ * 	- 1812: Requirements for IP Version 4 Routers. Type 3. Section 5.2.7.1
++ */
++static unsigned char icmp_valid[19][16] = 
++{
++       /* 0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15*/
++/* 0 */ {OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV}, /* echo reply */
++	
++	/* Type 1,2 don't exist */
++/* 1 */	{IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
++/* 2 */	{IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
++
++	/* destination host unreachable */
++/* 3 */ {OK,OK,OK,OK,OK,OK,OK,OK,OK,OK,OK,OK,OK,OK,OK,OK},
++
++	/* source quench */
++/* 4 */ {OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
++
++	/* redirect */
++/* 5 */ {OK,OK,OK,OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
++
++	/* Type 6,7 don't exist */
++/* 6 */	{IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
++/* 7 */	{IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
++
++	/* echo request */
++/* 8 */	{OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
++
++	/* router advertisement */
++/* 9 */ {OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
++	/* router selection */
++/* 10*/ {OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
++
++	/* time exceeded */
++/* 11*/ {OK,OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
++
++	/* Parameter problem */
++/* 12*/ {OK,OK,OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
++
++	/* timestamp */
++/* 13*/ {OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
++	/* timestamp reply */
++/* 14*/ {OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
++	/* Information request */
++/* 15*/ {OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
++	/* Information reply */
++/* 16*/ {OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
++	/* Address Mask request */
++/* 17*/ {OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
++	/* Address Mask reply */
++/* 18*/ {OK,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV,IV},
++};
++
+ static int icmp_pkt_to_tuple(const struct sk_buff *skb,
+ 			     unsigned int dataoff,
+ 			     struct ip_conntrack_tuple *tuple)
+@@ -126,9 +187,9 @@
  }
  
  static int
@@ -23,7 +89,7 @@
  {
  	struct ip_conntrack_tuple innertuple, origtuple;
  	struct {
-@@ -145,13 +147,6 @@
+@@ -145,13 +206,6 @@
  	if (skb_copy_bits(skb, skb->nh.iph->ihl*4, &inside, sizeof(inside))!=0)
  		return NF_ACCEPT;
  
@@ -37,7 +103,7 @@
  	/* Ignore ICMP's containing fragments (shouldn't happen) */
  	if (inside.ip.frag_off & htons(IP_OFFSET)) {
  		DEBUGP("icmp_error_track: fragment of proto %u\n",
-@@ -201,6 +196,69 @@
+@@ -201,6 +255,85 @@
  	return -NF_ACCEPT;
  }
  
@@ -93,6 +159,22 @@
 +		return -NF_ACCEPT;
 +	}
 +
++	/* 15 is the highest 'known' ICMP code. See RFC 1812 */
++	if (icmph.code > 15) {
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
++		return -NF_ACCEPT;
++	}
++
 +	/* Need to track icmp error message? */
 +	if (icmph.type != ICMP_DEST_UNREACH
 +	    && icmph.type != ICMP_SOURCE_QUENCH
@@ -107,9 +189,9 @@
  struct ip_conntrack_protocol ip_conntrack_protocol_icmp =
  {
  	.proto 			= IPPROTO_ICMP,
-diff -urN --exclude-from=/usr/src/diff.exclude linux-2.6.6-ct_error_api/net/ipv4/netfilter/ip_conntrack_proto_udp.c linux-2.6.6-ct_error_api-udp/net/ipv4/netfilter/ip_conntrack_proto_udp.c
---- linux-2.6.6-ct_error_api/net/ipv4/netfilter/ip_conntrack_proto_udp.c	2004-06-18 07:37:24.000000000 +0200
-+++ linux-2.6.6-ct_error_api-udp/net/ipv4/netfilter/ip_conntrack_proto_udp.c	2004-06-18 15:39:58.000000000 +0200
+diff -u -r1.4 ip_conntrack_proto_udp.c
+--- a/net/ipv4/netfilter/ip_conntrack_proto_udp.c	20 Jun 2004 21:22:07 -0000	1.4
++++ b/net/ipv4/netfilter/ip_conntrack_proto_udp.c	20 Jun 2004 21:22:39 -0000
 @@ -12,6 +12,8 @@
  #include <linux/netfilter.h>
  #include <linux/in.h>

--------------030603050006070404070404--
