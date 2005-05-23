From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 6/9]: Drop conntrack reference when packet
 leaves IPv6
Date: Mon, 23 May 2005 15:20:10 +0900 (JST)
Message-ID: <200505230620.j4N6KAve018200@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Mon_May_23_15:20:10_2005_281)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
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

----Next_Part(Mon_May_23_15:20:10_2005_281)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

This patch is for IPv6 and same change as follows.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

===========

    [NETFILTER]: Drop conntrack reference when packet leaves IP

    In the event a raw socket is created for sending purposes only, the creator
    never bothers to check the socket's receive queue.  But we continue to
    add skbs to its queue until it fills up.

    Unfortunately, if ip_conntrack is loaded on the box, each skb we add to the
    queue potentially holds a reference to a conntrack.  If the user attempts
    to unload ip_conntrack, we will spin around forever since the queued skbs
    are pinned.

    Signed-off-by: Patrick McHardy <kaber@trash.net>
    Signed-off-by: David S. Miller <davem@davemloft.net>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Mon_May_23_15:20:10_2005_281)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="06-drop-ref6.patch"

diff -Nur linux-2.6.12-rc4-nfct-5-drop-ref/net/ipv6/ip6_input.c linux-2.6.12-rc4-nfct-6-drop-ref6/net/ipv6/ip6_input.c
--- linux-2.6.12-rc4-nfct-5-drop-ref/net/ipv6/ip6_input.c	2005-05-20 03:29:38.000000000 +0900
+++ linux-2.6.12-rc4-nfct-6-drop-ref6/net/ipv6/ip6_input.c	2005-05-19 21:28:26.000000000 +0900
@@ -176,6 +176,11 @@
 		if (ipprot->flags & INET6_PROTO_FINAL) {
 			struct ipv6hdr *hdr;	
 
+			/* Free reference early: we don't need it any more,
+			   and it may hold ip_conntrack module loaded
+			   indefinitely. */
+			nf_reset(skb);
+
 			skb_postpull_rcsum(skb, skb->nh.raw,
 					   skb->h.raw - skb->nh.raw);
 			hdr = skb->nh.ipv6h;
diff -Nur linux-2.6.12-rc4-nfct-5-drop-ref/net/ipv6/ip6_output.c linux-2.6.12-rc4-nfct-6-drop-ref6/net/ipv6/ip6_output.c
--- linux-2.6.12-rc4-nfct-5-drop-ref/net/ipv6/ip6_output.c	2005-05-19 20:45:22.000000000 +0900
+++ linux-2.6.12-rc4-nfct-6-drop-ref6/net/ipv6/ip6_output.c	2005-05-19 20:47:01.000000000 +0900
@@ -76,6 +76,8 @@
 	struct dst_entry *dst = skb->dst;
 	struct hh_cache *hh = dst->hh;
 
+	nf_reset(skb);
+
 	if (hh) {
 		int hh_alen;
 
diff -Nur linux-2.6.12-rc4-nfct-5-drop-ref/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c linux-2.6.12-rc4-nfct-6-drop-ref6/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
--- linux-2.6.12-rc4-nfct-5-drop-ref/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c	2005-05-19 14:30:09.000000000 +0900
+++ linux-2.6.12-rc4-nfct-6-drop-ref6/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c	2005-05-19 20:47:15.000000000 +0900
@@ -224,10 +224,6 @@
 {
 	struct sk_buff *reasm;
 
-	/* Previously seen (loopback)?  */
-	if ((*pskb)->nfct)
-		return NF_ACCEPT;
-
 	reasm = nf_ct_frag6_gather(*pskb);
 
 	/* queued */
diff -Nur linux-2.6.12-rc4-nfct-5-drop-ref/net/ipv6/raw.c linux-2.6.12-rc4-nfct-6-drop-ref6/net/ipv6/raw.c
--- linux-2.6.12-rc4-nfct-5-drop-ref/net/ipv6/raw.c	2005-05-20 03:29:46.000000000 +0900
+++ linux-2.6.12-rc4-nfct-6-drop-ref6/net/ipv6/raw.c	2005-05-19 21:51:35.000000000 +0900
@@ -167,8 +167,10 @@
 			struct sk_buff *clone = skb_clone(skb, GFP_ATOMIC);
 
 			/* Not releasing hash table! */
-			if (clone)
+			if (clone) {
+				nf_reset(clone);
 				rawv6_rcv(sk, clone);
+			}
 		}
 		sk = __raw_v6_lookup(sk_next(sk), nexthdr, daddr, saddr);
 	}

----Next_Part(Mon_May_23_15:20:10_2005_281)----
