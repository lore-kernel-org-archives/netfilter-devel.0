From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] REJECT for 2.6.9+
Date: Wed, 30 Mar 2005 11:05:40 +0900 (JST)
Message-ID: <200503300205.j2U25fCc021930@toshiba.co.jp>
References: <423BF227.8030502@outerspace.dyndns.org> <423DA194.40100@trash.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Wed_Mar_30_11:05:40_2005_026)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <423DA194.40100@trash.net>
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

----Next_Part(Wed_Mar_30_11:05:40_2005_026)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi,

From: Patrick McHardy <kaber@trash.net>
Date: Sun, 20 Mar 2005 17:15:16 +0100

> Why add a new branch instead of simply restoring that file?
> Even better, I think I'm simply going to submit the IPv6
> REJECT target of nobody objects.

I have some thoughts.

I wrote ip6t_REJECT so that the source address of ICMPv6 error was
destination address of original packet. Because of this behavior,
send_unreach could not use icmpv6_send().
But now I have found that the behavior of ipt_REJECT is different.
The source address of ICMP error is its node. I think the behavior of them
should be same. Moreover, ipt_REJECT has changed to use icmp_send() recently.

Then I think ip6t_REJECT can use icmpv6_send() like ipt_REJECT.
Please consider applying attached patch to REJECT in pom-ng.

Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>

Regards,
-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Wed_Mar_30_11:05:40_2005_026)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="reject.patch"

diff -Nur -x.svn REJECT/linux-2.4.patch REJECT-changed/linux-2.4.patch
--- REJECT/linux-2.4.patch	1970-01-01 09:00:00.000000000 +0900
+++ REJECT-changed/linux-2.4.patch	2005-03-30 00:52:52.000000000 +0900
@@ -0,0 +1,28 @@
+diff -Nru linux-2.4.0-test8-ipv6updates/include/linux/netfilter_ipv6/ip6t_REJECT.h linux-2.4.0-test8-REJECTv6/include/linux/netfilter_ipv6/ip6t_REJECT.h
+--- linux-2.4.0-test8-ipv6updates/include/linux/netfilter_ipv6/ip6t_REJECT.h	Sun Nov 12 13:40:30 2000
++++ linux-2.4.0-test8-REJECTv6/include/linux/netfilter_ipv6/ip6t_REJECT.h	Sun Nov 12 13:38:25 2000
+@@ -2,15 +2,17 @@
+ #define _IP6T_REJECT_H
+ 
+ enum ip6t_reject_with {
+-	IP6T_ICMP_NET_UNREACHABLE,
+-	IP6T_ICMP_HOST_UNREACHABLE,
+-	IP6T_ICMP_PROT_UNREACHABLE,
+-	IP6T_ICMP_PORT_UNREACHABLE,
+-	IP6T_ICMP_ECHOREPLY
++	IP6T_ICMP6_NO_ROUTE,
++	IP6T_ICMP6_ADM_PROHIBITED,
++	IP6T_ICMP6_NOT_NEIGHBOUR,
++	IP6T_ICMP6_ADDR_UNREACH,
++	IP6T_ICMP6_PORT_UNREACH,
++	IP6T_ICMP6_ECHOREPLY,
++	IP6T_TCP_RESET
+ };
+ 
+ struct ip6t_reject_info {
+ 	enum ip6t_reject_with with;      /* reject type */
+ };
+ 
+-#endif /*_IPT_REJECT_H*/
++#endif /*_IP6T_REJECT_H*/
+
diff -Nur -x.svn REJECT/linux-2.6/include/linux/netfilter_ipv6/ip6t_REJECT.h REJECT-changed/linux-2.6/include/linux/netfilter_ipv6/ip6t_REJECT.h
--- REJECT/linux-2.6/include/linux/netfilter_ipv6/ip6t_REJECT.h	1970-01-01 09:00:00.000000000 +0900
+++ REJECT-changed/linux-2.6/include/linux/netfilter_ipv6/ip6t_REJECT.h	2005-03-30 00:52:51.000000000 +0900
@@ -0,0 +1,18 @@
+#ifndef _IP6T_REJECT_H
+#define _IP6T_REJECT_H
+
+enum ip6t_reject_with {
+	IP6T_ICMP6_NO_ROUTE,
+	IP6T_ICMP6_ADM_PROHIBITED,
+	IP6T_ICMP6_NOT_NEIGHBOUR,
+	IP6T_ICMP6_ADDR_UNREACH,
+	IP6T_ICMP6_PORT_UNREACH,
+	IP6T_ICMP6_ECHOREPLY,
+	IP6T_TCP_RESET
+};
+
+struct ip6t_reject_info {
+	enum ip6t_reject_with with;      /* reject type */
+};
+
+#endif /*_IP6T_REJECT_H*/
diff -Nur -x.svn REJECT/linux-2.6/net/ipv6/ipv6_syms.c.ladd REJECT-changed/linux-2.6/net/ipv6/ipv6_syms.c.ladd
--- REJECT/linux-2.6/net/ipv6/ipv6_syms.c.ladd	2005-03-30 00:46:26.000000000 +0900
+++ REJECT-changed/linux-2.6/net/ipv6/ipv6_syms.c.ladd	2005-03-30 01:04:42.000000000 +0900
@@ -1 +1,2 @@
+EXPORT_SYMBOL(ipv6_push_nfrag_opts);
 EXPORT_SYMBOL(ip6_dst_lookup);
diff -Nur -x.svn REJECT/linux-2.6/net/ipv6/netfilter/Makefile.ladd REJECT-changed/linux-2.6/net/ipv6/netfilter/Makefile.ladd
--- REJECT/linux-2.6/net/ipv6/netfilter/Makefile.ladd	1970-01-01 09:00:00.000000000 +0900
+++ REJECT-changed/linux-2.6/net/ipv6/netfilter/Makefile.ladd	2005-03-30 01:49:48.000000000 +0900
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP6_NF_MATCH_HL) += ip6t_hl.o
+obj-$(CONFIG_IP6_NF_TARGET_REJECT) += ip6t_REJECT.o
diff -Nur -x.svn REJECT/linux-2.6/net/ipv6/netfilter/ip6t_REJECT.c REJECT-changed/linux-2.6/net/ipv6/netfilter/ip6t_REJECT.c
--- REJECT/linux-2.6/net/ipv6/netfilter/ip6t_REJECT.c	2005-03-30 00:54:14.000000000 +0900
+++ REJECT-changed/linux-2.6/net/ipv6/netfilter/ip6t_REJECT.c	2005-03-30 00:52:51.000000000 +0900
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/icmpv6.h>
+#include <linux/netdevice.h>
 #include <net/ipv6.h>
 #include <net/tcp.h>
 #include <net/icmp.h>
@@ -39,17 +40,6 @@
 #define DEBUGP(format, args...)
 #endif
 
-#if 0
-static void connection_attach(struct sk_buff *new_skb, struct nf_ct_info *nfct)
-{
-	void (*attach)(struct sk_buff *, struct nf_ct_info *);
-	if (nfct && (attach = ip6_ct_attach) != NULL) {
-		mb();
-		attach(new_skb, nfct);
-	}
-}
-#endif
-
 static int maybe_reroute(struct sk_buff *skb)
 {
 	if (skb->nfcache & NFC_ALTERED){
@@ -73,7 +63,6 @@
 	struct dst_entry *dst = NULL;
 	u8 proto;
 	struct flowi fl;
-	proto = oip6h->nexthdr;
 	int err;
 
 	if ((!(ipv6_addr_type(&oip6h->saddr) & IPV6_ADDR_UNICAST)) ||
@@ -82,6 +71,7 @@
 		return;
 	}
 
+	proto = oip6h->nexthdr;
 	tcphoff = ipv6_skip_exthdr(oldskb, ((u8*)(oip6h+1) - oldskb->data),
 				   &proto, oldskb->len - ((u8*)(oip6h+1)
 							  - oldskb->data));
@@ -190,171 +180,25 @@
 				      csum_partial((char *)tcph,
 						   sizeof(struct tcphdr), 0));
 
-#if 0
-	connection_attach(nskb, oldskb->nfct);
-#endif
-
 	NF_HOOK(PF_INET6, NF_IP6_LOCAL_OUT, nskb, NULL, nskb->dst->dev,
 		maybe_reroute);
 
 	dst_release(dst);
 }
 
-static void send_unreach(struct sk_buff *skb_in, unsigned char code)
+static inline void
+send_unreach(struct sk_buff *skb_in, unsigned char code, unsigned int hooknum)
 {
-	struct ipv6hdr *ip6h, *hdr = skb_in->nh.ipv6h;
-	struct icmp6hdr *icmp6h;
-	struct dst_entry *dst = NULL;
-	struct rt6_info *rt;
-	int tmo;
-	__u32 csum;
-	unsigned int len, datalen, hh_len;
-	int saddr_type, daddr_type;
-	unsigned int ptr, ip6off;
-	u8 proto;
-	struct flowi fl;
-	struct sk_buff *nskb;
-	char *data;
-
-	saddr_type = ipv6_addr_type(&hdr->saddr);
-	daddr_type = ipv6_addr_type(&hdr->daddr);
-
-	if ((!(saddr_type & IPV6_ADDR_UNICAST)) ||
-	    (!(daddr_type & IPV6_ADDR_UNICAST))) {
-		DEBUGP("ip6t_REJECT: addr is not unicast.\n");
-		return;
-	}
-
-	ip6off = skb_in->nh.raw - skb_in->data;
-	proto = hdr->nexthdr;
-	ptr = ipv6_skip_exthdr(skb_in, ip6off + sizeof(struct ipv6hdr), &proto,
-			       skb_in->len - ip6off);
-
-	if ((ptr < 0) || (ptr > skb_in->len)) {
-		ptr = ip6off + sizeof(struct ipv6hdr);
-		proto = hdr->nexthdr;
-	} else if (proto == IPPROTO_ICMPV6) {
-                u8 type;
-
-                if (skb_copy_bits(skb_in, ptr + offsetof(struct icmp6hdr,
-						      icmp6_type), &type, 1)) {
-			DEBUGP("ip6t_REJECT: Can't get ICMPv6 type\n");
-			return;
-		}
+	if (hooknum == NF_IP6_LOCAL_OUT && skb_in->dev == NULL)
+		skb_in->dev = &loopback_dev;
 
-		if (!(type & ICMPV6_INFOMSG_MASK)) {
-			DEBUGP("ip6t_REJECT: no reply to icmp error\n");
-			return;
-		}
-        } else if (proto == IPPROTO_UDP) {
-		int plen = skb_in->len - (ptr - ip6off);
-		uint16_t check;
-
-		if (plen < sizeof(struct udphdr)) {
-			DEBUGP("ip6t_REJECT: too short\n");
-			return;
-		}
-
-		if (skb_copy_bits(skb_in, ptr + offsetof(struct udphdr, check),
-				  &check, 2)) {
-			if (net_ratelimit())
-				printk("ip6t_REJECT: can't get copy from skb");
-			return;
-		}
-
-		if (check &&
-		    csum_ipv6_magic(&hdr->saddr, &hdr->daddr, plen,
-				    IPPROTO_UDP,
-				    skb_checksum(skb_in, ptr, plen, 0))) {
-			DEBUGP("ip6t_REJECT: UDP checksum is invalid.\n");
-			return;
-		}
-	}
-
-	memset(&fl, 0, sizeof(fl));
-	fl.proto = IPPROTO_ICMPV6;
-	ipv6_addr_copy(&fl.fl6_src, &hdr->daddr);
-	ipv6_addr_copy(&fl.fl6_dst, &hdr->saddr);
-	fl.fl_icmp_type = ICMPV6_DEST_UNREACH;
-	fl.fl_icmp_code = code;
-
-	if (ip6_dst_lookup(NULL, &dst, &fl)) {
-		return;
-	}
-
-	rt = (struct rt6_info *)dst;
-	tmo = 1*HZ;
-
-	if (rt->rt6i_dst.plen < 128)
-		tmo >>= ((128 - rt->rt6i_dst.plen)>>5);
-
-	if (!xrlim_allow(dst, tmo)) {
-		if (net_ratelimit())
-			printk("ip6t_REJECT: rate limitted\n");
-		goto dst_release_out;
-	}
-
-	len = skb_in->len + sizeof(struct ipv6hdr) + sizeof(struct icmp6hdr);
-
-	if (len > dst_pmtu(dst))
-		len = dst_pmtu(dst);
-	if (len > IPV6_MIN_MTU)
-		len = IPV6_MIN_MTU;
-
-	datalen = len - sizeof(struct ipv6hdr) - sizeof(struct icmp6hdr);
-	hh_len = (rt->u.dst.dev->hard_header_len + 15)&~15;
-
-	nskb = alloc_skb(hh_len + 15 + dst->header_len + dst->trailer_len + len,
-			 GFP_ATOMIC);
-
-	if (!nskb) {
-		if (net_ratelimit())
-			printk("ip6t_REJECT: can't alloc skb\n");
-		goto dst_release_out;
-	}
-
-	nskb->priority = 0;
-	nskb->dst = dst;
-	dst_hold(dst);
-
-	skb_reserve(nskb, hh_len + dst->header_len);
-
-	ip6h = nskb->nh.ipv6h = (struct ipv6hdr *)
-					skb_put(nskb, sizeof(struct ipv6hdr));
-	ip6h->version = 6;
-	ip6h->hop_limit = dst_metric(dst, RTAX_HOPLIMIT);
-	ip6h->nexthdr = IPPROTO_ICMPV6;
-	ip6h->payload_len = htons(datalen + sizeof(struct icmp6hdr));
-	ipv6_addr_copy(&ip6h->saddr, &hdr->daddr);
-	ipv6_addr_copy(&ip6h->daddr, &hdr->saddr);
-
-	icmp6h = (struct icmp6hdr *) skb_put(nskb, sizeof(struct icmp6hdr));
-	icmp6h->icmp6_type = ICMPV6_DEST_UNREACH;
-	icmp6h->icmp6_code = code;
-	icmp6h->icmp6_cksum = 0;
-
-	data = skb_put(nskb, datalen);
-
-	csum = csum_partial((unsigned char *)icmp6h, sizeof(struct icmp6hdr), 0);
-	csum = skb_copy_and_csum_bits(skb_in, ip6off, data, datalen, csum);
-	icmp6h->icmp6_cksum = csum_ipv6_magic(&hdr->saddr, &hdr->daddr,
-					     datalen + sizeof(struct icmp6hdr),
-					     IPPROTO_ICMPV6, csum);
-
-#if 0
-	connection_attach(nskb, skb_in->nfct);
-#endif
-	NF_HOOK(PF_INET6, NF_IP6_LOCAL_OUT, nskb, NULL, nskb->dst->dev,
-		maybe_reroute);
-
-dst_release_out:
-	dst_release(dst);
+	icmpv6_send(skb_in, ICMPV6_DEST_UNREACH, code, 0, NULL);
 }
 
 static unsigned int reject6_target(struct sk_buff **pskb,
-			   unsigned int hooknum,
 			   const struct net_device *in,
 			   const struct net_device *out,
+			   unsigned int hooknum,
 			   const void *targinfo,
 			   void *userinfo)
 {
@@ -366,19 +210,19 @@
 	   must return an absolute verdict. --RR */
     	switch (reject->with) {
     	case IP6T_ICMP6_NO_ROUTE:
-    		send_unreach(*pskb, ICMPV6_NOROUTE);
+    		send_unreach(*pskb, ICMPV6_NOROUTE, hooknum);
     		break;
     	case IP6T_ICMP6_ADM_PROHIBITED:
-    		send_unreach(*pskb, ICMPV6_ADM_PROHIBITED);
+    		send_unreach(*pskb, ICMPV6_ADM_PROHIBITED, hooknum);
     		break;
     	case IP6T_ICMP6_NOT_NEIGHBOUR:
-    		send_unreach(*pskb, ICMPV6_NOT_NEIGHBOUR);
+    		send_unreach(*pskb, ICMPV6_NOT_NEIGHBOUR, hooknum);
     		break;
     	case IP6T_ICMP6_ADDR_UNREACH:
-    		send_unreach(*pskb, ICMPV6_ADDR_UNREACH);
+    		send_unreach(*pskb, ICMPV6_ADDR_UNREACH, hooknum);
     		break;
     	case IP6T_ICMP6_PORT_UNREACH:
-    		send_unreach(*pskb, ICMPV6_PORT_UNREACH);
+    		send_unreach(*pskb, ICMPV6_PORT_UNREACH, hooknum);
     		break;
     	case IP6T_ICMP6_ECHOREPLY:
 		/* Do nothing */
diff -Nur -x.svn REJECT/linux.patch REJECT-changed/linux.patch
--- REJECT/linux.patch	2005-03-30 00:54:14.000000000 +0900
+++ REJECT-changed/linux.patch	1970-01-01 09:00:00.000000000 +0900
@@ -1,28 +0,0 @@
-diff -Nru linux-2.4.0-test8-ipv6updates/include/linux/netfilter_ipv6/ip6t_REJECT.h linux-2.4.0-test8-REJECTv6/include/linux/netfilter_ipv6/ip6t_REJECT.h
---- linux-2.4.0-test8-ipv6updates/include/linux/netfilter_ipv6/ip6t_REJECT.h	Sun Nov 12 13:40:30 2000
-+++ linux-2.4.0-test8-REJECTv6/include/linux/netfilter_ipv6/ip6t_REJECT.h	Sun Nov 12 13:38:25 2000
-@@ -2,15 +2,17 @@
- #define _IP6T_REJECT_H
- 
- enum ip6t_reject_with {
--	IP6T_ICMP_NET_UNREACHABLE,
--	IP6T_ICMP_HOST_UNREACHABLE,
--	IP6T_ICMP_PROT_UNREACHABLE,
--	IP6T_ICMP_PORT_UNREACHABLE,
--	IP6T_ICMP_ECHOREPLY
-+	IP6T_ICMP6_NO_ROUTE,
-+	IP6T_ICMP6_ADM_PROHIBITED,
-+	IP6T_ICMP6_NOT_NEIGHBOUR,
-+	IP6T_ICMP6_ADDR_UNREACH,
-+	IP6T_ICMP6_PORT_UNREACH,
-+	IP6T_ICMP6_ECHOREPLY,
-+	IP6T_TCP_RESET
- };
- 
- struct ip6t_reject_info {
- 	enum ip6t_reject_with with;      /* reject type */
- };
- 
--#endif /*_IPT_REJECT_H*/
-+#endif /*_IP6T_REJECT_H*/
-

----Next_Part(Wed_Mar_30_11:05:40_2005_026)----
