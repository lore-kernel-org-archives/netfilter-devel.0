From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] modification in current protocol helper API to handle
 error/unclean packets
Date: Thu, 17 Jun 2004 14:09:47 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40D18A0B.2070101@eurodev.net>
References: <Pine.LNX.4.33.0406141551410.12847-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020101080807020505020909"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
 Patrick McHardy <kaber@trash.net>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.33.0406141551410.12847-100000@blackhole.kfki.hu>
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
--------------020101080807020505020909
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Attached the patch to add the error function to the current protocol 
helper API. Some comments:

- Patrick, I had to copy and paste the icmp_error_track function to 
ip_fw_compat_masq.c because new error function returns an int and we 
need to return the conntrack associated to inner protocol embedded in 
the icmp message. I know that replicating code is not a good idea but 
that compatibility layer will disappear some day... any idea? I also 
rename some functions (invert_tuple and get_tuple) as you pointed out.
- Jozsef, I resolve to use your inverse return value but I must confess 
that I'm still thinking about another way to do that with no sucess, 
well this issue is not important. BTW, you also modified conntrack core 
in your tcp-window-tracking patch, do you think that I could add that 
part to my patch since I think that it's more related stuff and your 
patch will go on top of this?
- I'll work on that extra patch to check for malformed udp/icmp packets 
these days.

If any comment or any indentation problem, please let me know.

regards,
Pablo

--------------020101080807020505020909
Content-Type: text/x-patch;
 name="protocol_helper-error.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="protocol_helper-error.patch"

diff -u -r1.1.1.1 ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	11 May 2004 13:07:08 -0000	1.1.1.1
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	16 Jun 2004 12:59:39 -0000
@@ -126,11 +126,11 @@
 }
 
 int
-get_tuple(const struct iphdr *iph,
-	  const struct sk_buff *skb,
-	  unsigned int dataoff,
-	  struct ip_conntrack_tuple *tuple,
-	  const struct ip_conntrack_protocol *protocol)
+ip_ct_get_tuple(const struct iphdr *iph,
+		const struct sk_buff *skb,
+		unsigned int dataoff,
+		struct ip_conntrack_tuple *tuple,
+		const struct ip_conntrack_protocol *protocol)
 {
 	/* Never happen */
 	if (iph->frag_off & htons(IP_OFFSET)) {
@@ -146,10 +146,10 @@
 	return protocol->pkt_to_tuple(skb, dataoff, tuple);
 }
 
-static int
-invert_tuple(struct ip_conntrack_tuple *inverse,
-	     const struct ip_conntrack_tuple *orig,
-	     const struct ip_conntrack_protocol *protocol)
+int
+ip_ct_invert_tuple(struct ip_conntrack_tuple *inverse,
+		   const struct ip_conntrack_tuple *orig,
+		   const struct ip_conntrack_protocol *protocol)
 {
 	inverse->src.ip = orig->dst.ip;
 	inverse->dst.ip = orig->src.ip;
@@ -495,83 +495,6 @@
 	return h != NULL;
 }
 
-/* Returns conntrack if it dealt with ICMP, and filled in skb fields */
-struct ip_conntrack *
-icmp_error_track(struct sk_buff *skb,
-		 enum ip_conntrack_info *ctinfo,
-		 unsigned int hooknum)
-{
-	struct ip_conntrack_tuple innertuple, origtuple;
-	struct {
-		struct icmphdr icmp;
-		struct iphdr ip;
-	} inside;
-	struct ip_conntrack_protocol *innerproto;
-	struct ip_conntrack_tuple_hash *h;
-	int dataoff;
-
-	IP_NF_ASSERT(skb->nfct == NULL);
-
-	/* Not enough header? */
-	if (skb_copy_bits(skb, skb->nh.iph->ihl*4, &inside, sizeof(inside))!=0)
-		return NULL;
-
-	if (inside.icmp.type != ICMP_DEST_UNREACH
-	    && inside.icmp.type != ICMP_SOURCE_QUENCH
-	    && inside.icmp.type != ICMP_TIME_EXCEEDED
-	    && inside.icmp.type != ICMP_PARAMETERPROB
-	    && inside.icmp.type != ICMP_REDIRECT)
-		return NULL;
-
-	/* Ignore ICMP's containing fragments (shouldn't happen) */
-	if (inside.ip.frag_off & htons(IP_OFFSET)) {
-		DEBUGP("icmp_error_track: fragment of proto %u\n",
-		       inside.ip.protocol);
-		return NULL;
-	}
-
-	innerproto = ip_ct_find_proto(inside.ip.protocol);
-	dataoff = skb->nh.iph->ihl*4 + sizeof(inside.icmp) + inside.ip.ihl*4;
-	/* Are they talking about one of our connections? */
-	if (!get_tuple(&inside.ip, skb, dataoff, &origtuple, innerproto)) {
-		DEBUGP("icmp_error: ! get_tuple p=%u", inside.ip.protocol);
-		return NULL;
-	}
-
-	/* Ordinarily, we'd expect the inverted tupleproto, but it's
-	   been preserved inside the ICMP. */
-	if (!invert_tuple(&innertuple, &origtuple, innerproto)) {
-		DEBUGP("icmp_error_track: Can't invert tuple\n");
-		return NULL;
-	}
-
-	*ctinfo = IP_CT_RELATED;
-
-	h = ip_conntrack_find_get(&innertuple, NULL);
-	if (!h) {
-		/* Locally generated ICMPs will match inverted if they
-		   haven't been SNAT'ed yet */
-		/* FIXME: NAT code has to handle half-done double NAT --RR */
-		if (hooknum == NF_IP_LOCAL_OUT)
-			h = ip_conntrack_find_get(&origtuple, NULL);
-
-		if (!h) {
-			DEBUGP("icmp_error_track: no match\n");
-			return NULL;
-		}
-		/* Reverse direction from that found */
-		if (DIRECTION(h) != IP_CT_DIR_REPLY)
-			*ctinfo += IP_CT_IS_REPLY;
-	} else {
-		if (DIRECTION(h) == IP_CT_DIR_REPLY)
-			*ctinfo += IP_CT_IS_REPLY;
-	}
-
-	/* Update skb to refer to this connection */
-	skb->nfct = &h->ctrack->infos[*ctinfo];
-	return h->ctrack;
-}
-
 /* There's a small race here where we may free a just-assured
    connection.  Too bad: we're in trouble anyway. */
 static inline int unreplied(const struct ip_conntrack_tuple_hash *i)
@@ -653,7 +576,7 @@
 		}
 	}
 
-	if (!invert_tuple(&repl_tuple, tuple, protocol)) {
+	if (!ip_ct_invert_tuple(&repl_tuple, tuple, protocol)) {
 		DEBUGP("Can't invert tuple.\n");
 		return NULL;
 	}
@@ -743,7 +666,8 @@
 
 	IP_NF_ASSERT((skb->nh.iph->frag_off & htons(IP_OFFSET)) == 0);
 
-	if (!get_tuple(skb->nh.iph, skb, skb->nh.iph->ihl*4, &tuple, proto))
+	if (!ip_ct_get_tuple(skb->nh.iph, skb, skb->nh.iph->ihl*4, 
+				&tuple,proto))
 		return NULL;
 
 	/* look for tuple match */
@@ -828,10 +752,11 @@
 
 	proto = ip_ct_find_proto((*pskb)->nh.iph->protocol);
 
-	/* It may be an icmp error... */
-	if ((*pskb)->nh.iph->protocol == IPPROTO_ICMP 
-	    && icmp_error_track(*pskb, &ctinfo, hooknum))
-		return NF_ACCEPT;
+	/* It may be an special packet, error, unclean...
+	 * inverse of the return code tells to the netfilter
+	 * core what to do with the packet. */
+	if ((ret = proto->error(*pskb, &ctinfo, hooknum)) <= 0)
+		return -ret;
 
 	if (!(ct = resolve_normal_ct(*pskb, proto,&set_reply,hooknum,&ctinfo)))
 		/* Not valid part of a connection */
@@ -869,7 +794,8 @@
 int invert_tuplepr(struct ip_conntrack_tuple *inverse,
 		   const struct ip_conntrack_tuple *orig)
 {
-	return invert_tuple(inverse, orig, ip_ct_find_proto(orig->dst.protonum));
+	return ip_ct_invert_tuple(inverse, orig, 
+				  ip_ct_find_proto(orig->dst.protonum));
 }
 
 static inline int resent_expect(const struct ip_conntrack_expect *i,
diff -u -r1.1.1.1 ip_conntrack_proto_generic.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_generic.c	11 May 2004 13:07:08 -0000	1.1.1.1
+++ b/net/ipv4/netfilter/ip_conntrack_proto_generic.c	16 Jun 2004 12:58:02 -0000
@@ -62,8 +62,15 @@
 	return 1;
 }
 
+static int
+error(struct sk_buff *skb, enum ip_conntrack_info *ctinfo, 
+      unsigned int hooknum)
+{
+	return NF_ACCEPT;
+}
+
 struct ip_conntrack_protocol ip_conntrack_generic_protocol
 = { { NULL, NULL }, 0, "unknown",
     generic_pkt_to_tuple, generic_invert_tuple, generic_print_tuple,
-    generic_print_conntrack, packet, new, NULL, NULL, NULL };
+    generic_print_conntrack, packet, new, NULL, NULL, error, NULL };
 
diff -u -r1.1.1.1 ip_conntrack_proto_icmp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	11 May 2004 13:07:08 -0000	1.1.1.1
+++ b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	16 Jun 2004 18:06:57 -0000
@@ -12,6 +12,8 @@
 #include <linux/netfilter.h>
 #include <linux/in.h>
 #include <linux/icmp.h>
+#include <net/ip.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
 
 unsigned long ip_ct_icmp_timeout = 30*HZ;
@@ -122,7 +124,85 @@
 	return 1;
 }
 
+/* backwards compatibility: If you modify this function you should also do 
+ * the same for icmp_error_track in ip_fw_compat_masq.c */
+static int
+icmp_error(struct sk_buff *skb,
+		 enum ip_conntrack_info *ctinfo,
+		 unsigned int hooknum)
+{
+	struct ip_conntrack_tuple innertuple, origtuple;
+	struct {
+		struct icmphdr icmp;
+		struct iphdr ip;
+	} inside;
+	struct ip_conntrack_protocol *innerproto;
+	struct ip_conntrack_tuple_hash *h;
+	int dataoff;
+
+	IP_NF_ASSERT(skb->nfct == NULL);
+
+	/* Not enough header? */
+	if (skb_copy_bits(skb, skb->nh.iph->ihl*4, &inside, sizeof(inside))!=0)
+		return NF_ACCEPT;
+
+	if (inside.icmp.type != ICMP_DEST_UNREACH
+	    && inside.icmp.type != ICMP_SOURCE_QUENCH
+	    && inside.icmp.type != ICMP_TIME_EXCEEDED
+	    && inside.icmp.type != ICMP_PARAMETERPROB
+	    && inside.icmp.type != ICMP_REDIRECT)
+		return NF_ACCEPT;
+
+	/* Ignore ICMP's containing fragments (shouldn't happen) */
+	if (inside.ip.frag_off & htons(IP_OFFSET)) {
+		DEBUGP("icmp_error_track: fragment of proto %u\n",
+		       inside.ip.protocol);
+		return NF_ACCEPT;
+	}
+
+	innerproto = ip_ct_find_proto(inside.ip.protocol);
+	dataoff = skb->nh.iph->ihl*4 + sizeof(inside.icmp) + inside.ip.ihl*4;
+	/* Are they talking about one of our connections? */
+	if (!ip_ct_get_tuple(&inside.ip, skb, dataoff, &origtuple, innerproto)) {
+		DEBUGP("icmp_error: ! get_tuple p=%u", inside.ip.protocol);
+		return NF_ACCEPT;
+	}
+
+	/* Ordinarily, we'd expect the inverted tupleproto, but it's
+	   been preserved inside the ICMP. */
+	if (!ip_ct_invert_tuple(&innertuple, &origtuple, innerproto)) {
+		DEBUGP("icmp_error_track: Can't invert tuple\n");
+		return NF_ACCEPT;
+	}
+
+	*ctinfo = IP_CT_RELATED;
+
+	h = ip_conntrack_find_get(&innertuple, NULL);
+	if (!h) {
+		/* Locally generated ICMPs will match inverted if they
+		   haven't been SNAT'ed yet */
+		/* FIXME: NAT code has to handle half-done double NAT --RR */
+		if (hooknum == NF_IP_LOCAL_OUT)
+			h = ip_conntrack_find_get(&origtuple, NULL);
+
+		if (!h) {
+			DEBUGP("icmp_error_track: no match\n");
+			return NF_ACCEPT;
+		}
+		/* Reverse direction from that found */
+		if (DIRECTION(h) != IP_CT_DIR_REPLY)
+			*ctinfo += IP_CT_IS_REPLY;
+	} else {
+		if (DIRECTION(h) == IP_CT_DIR_REPLY)
+			*ctinfo += IP_CT_IS_REPLY;
+	}
+
+	/* Update skb to refer to this connection */
+	skb->nfct = &h->ctrack->infos[*ctinfo];
+	return -NF_ACCEPT;
+}
+
 struct ip_conntrack_protocol ip_conntrack_protocol_icmp
 = { { NULL, NULL }, IPPROTO_ICMP, "icmp",
     icmp_pkt_to_tuple, icmp_invert_tuple, icmp_print_tuple,
-    icmp_print_conntrack, icmp_packet, icmp_new, NULL, NULL, NULL };
+    icmp_print_conntrack, icmp_packet, icmp_new, NULL, NULL, icmp_error, NULL};
diff -u -r1.1.1.1 ip_conntrack_proto_tcp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	11 May 2004 13:07:08 -0000	1.1.1.1
+++ b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	16 Jun 2004 12:57:50 -0000
@@ -266,7 +266,14 @@
 	return between(exp->seq, ntohl(tcph.seq), ntohl(tcph.seq) + datalen);
 }
 
+static int
+tcp_error(struct sk_buff *skb, enum ip_conntrack_info *ctinfo, 
+	   unsigned int hooknum)
+{
+	return NF_ACCEPT;
+}
+
 struct ip_conntrack_protocol ip_conntrack_protocol_tcp
 = { { NULL, NULL }, IPPROTO_TCP, "tcp",
     tcp_pkt_to_tuple, tcp_invert_tuple, tcp_print_tuple, tcp_print_conntrack,
-    tcp_packet, tcp_new, NULL, tcp_exp_matches_pkt, NULL };
+    tcp_packet, tcp_new, NULL, tcp_exp_matches_pkt, tcp_error, NULL };
diff -u -r1.1.1.1 ip_conntrack_proto_udp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_udp.c	11 May 2004 13:07:08 -0000	1.1.1.1
+++ b/net/ipv4/netfilter/ip_conntrack_proto_udp.c	16 Jun 2004 13:02:46 -0000
@@ -80,7 +80,14 @@
 	return 1;
 }
 
+static int
+udp_error(struct sk_buff *skb, enum ip_conntrack_info *ctinfo,
+	  unsigned int hooknum)
+{
+	return NF_ACCEPT;
+}
+
 struct ip_conntrack_protocol ip_conntrack_protocol_udp
 = { { NULL, NULL }, IPPROTO_UDP, "udp",
     udp_pkt_to_tuple, udp_invert_tuple, udp_print_tuple, udp_print_conntrack,
-    udp_packet, udp_new, NULL, NULL, NULL };
+    udp_packet, udp_new, NULL, NULL, udp_error, NULL };
diff -u -r1.1.1.1 ip_fw_compat_masq.c
--- a/net/ipv4/netfilter/ip_fw_compat_masq.c	11 May 2004 13:07:08 -0000	1.1.1.1
+++ b/net/ipv4/netfilter/ip_fw_compat_masq.c	16 Jun 2004 13:13:57 -0000
@@ -24,6 +24,7 @@
 #include <linux/proc_fs.h>
 #include <linux/module.h>
 #include <net/route.h>
+#include <net/ip.h>
 
 #define ASSERT_READ_LOCK(x) MUST_BE_READ_LOCKED(&ip_conntrack_lock)
 #define ASSERT_WRITE_LOCK(x) MUST_BE_WRITE_LOCKED(&ip_conntrack_lock)
@@ -41,6 +42,83 @@
 #define DEBUGP(format, args...)
 #endif
 
+/* Returns conntrack if it dealt with ICMP, and filled in skb fields */
+struct ip_conntrack *
+icmp_error_track(struct sk_buff *skb,
+		 enum ip_conntrack_info *ctinfo,
+		 unsigned int hooknum)
+{
+	struct ip_conntrack_tuple innertuple, origtuple;
+	struct {
+		struct icmphdr icmp;
+		struct iphdr ip;
+	} inside;
+	struct ip_conntrack_protocol *innerproto;
+	struct ip_conntrack_tuple_hash *h;
+	int dataoff;
+
+	IP_NF_ASSERT(skb->nfct == NULL);
+
+	/* Not enough header? */
+	if (skb_copy_bits(skb, skb->nh.iph->ihl*4, &inside, sizeof(inside))!=0)
+		return NULL;
+
+	if (inside.icmp.type != ICMP_DEST_UNREACH
+	    && inside.icmp.type != ICMP_SOURCE_QUENCH
+	    && inside.icmp.type != ICMP_TIME_EXCEEDED
+	    && inside.icmp.type != ICMP_PARAMETERPROB
+	    && inside.icmp.type != ICMP_REDIRECT)
+		return NULL;
+
+	/* Ignore ICMP's containing fragments (shouldn't happen) */
+	if (inside.ip.frag_off & htons(IP_OFFSET)) {
+		DEBUGP("icmp_error_track: fragment of proto %u\n",
+		       inside.ip.protocol);
+		return NULL;
+	}
+
+	innerproto = ip_ct_find_proto(inside.ip.protocol);
+	dataoff = skb->nh.iph->ihl*4 + sizeof(inside.icmp) + inside.ip.ihl*4;
+	/* Are they talking about one of our connections? */
+	if (!ip_ct_get_tuple(&inside.ip, skb, dataoff, &origtuple, innerproto)) {
+		DEBUGP("icmp_error: ! get_tuple p=%u", inside.ip.protocol);
+		return NULL;
+	}
+
+	/* Ordinarily, we'd expect the inverted tupleproto, but it's
+	   been preserved inside the ICMP. */
+	if (!ip_ct_invert_tuple(&innertuple, &origtuple, innerproto)) {
+		DEBUGP("icmp_error_track: Can't invert tuple\n");
+		return NULL;
+	}
+
+	*ctinfo = IP_CT_RELATED;
+
+	h = ip_conntrack_find_get(&innertuple, NULL);
+	if (!h) {
+		/* Locally generated ICMPs will match inverted if they
+		   haven't been SNAT'ed yet */
+		/* FIXME: NAT code has to handle half-done double NAT --RR */
+		if (hooknum == NF_IP_LOCAL_OUT)
+			h = ip_conntrack_find_get(&origtuple, NULL);
+
+		if (!h) {
+			DEBUGP("icmp_error_track: no match\n");
+			return NULL;
+		}
+		/* Reverse direction from that found */
+		if (DIRECTION(h) != IP_CT_DIR_REPLY)
+			*ctinfo += IP_CT_IS_REPLY;
+	} else {
+		if (DIRECTION(h) == IP_CT_DIR_REPLY)
+			*ctinfo += IP_CT_IS_REPLY;
+	}
+
+	/* Update skb to refer to this connection */
+	skb->nfct = &h->ctrack->infos[*ctinfo];
+	return h->ctrack;
+}
+
 unsigned int
 do_masquerade(struct sk_buff **pskb, const struct net_device *dev)
 {
@@ -164,7 +242,7 @@
 	case IPPROTO_UDP:
 		IP_NF_ASSERT(((*pskb)->nh.iph->frag_off & htons(IP_OFFSET)) == 0);
 
-		if (!get_tuple((*pskb)->nh.iph, *pskb, (*pskb)->nh.iph->ihl*4, &tuple, protocol)) {
+		if (!ip_ct_get_tuple((*pskb)->nh.iph, *pskb, (*pskb)->nh.iph->ihl*4, &tuple, protocol)) {
 			if (net_ratelimit())
 				printk("ip_fw_compat_masq: Can't get tuple\n");
 			return NF_ACCEPT;
diff -u -r1.1.1.1 ip_conntrack.h
--- a/include/linux/netfilter_ipv4/ip_conntrack.h	11 May 2004 13:35:40 -0000	1.1.1.1
+++ b/include/linux/netfilter_ipv4/ip_conntrack.h	16 Jun 2004 13:20:51 -0000
@@ -264,6 +264,26 @@
 ip_ct_selective_cleanup(int (*kill)(const struct ip_conntrack *i, void *data),
 			void *data);
 
+extern struct ip_conntrack_protocol *
+ip_ct_find_proto(u_int8_t protocol);
+
+extern int
+ip_ct_get_tuple(const struct iphdr *iph,
+		const struct sk_buff *skb,
+		unsigned int dataoff,
+		struct ip_conntrack_tuple *tuple,
+		const struct ip_conntrack_protocol *protocol);
+
+extern int
+ip_ct_invert_tuple(struct ip_conntrack_tuple *inverse,
+		   const struct ip_conntrack_tuple *orig,
+		   const struct ip_conntrack_protocol *protocol);
+
+/* Find a connection corresponding to a tuple. */
+extern struct ip_conntrack_tuple_hash *
+ip_conntrack_find_get(const struct ip_conntrack_tuple *tuple,
+		      const struct ip_conntrack *ignored_conntrack);
+
 /* It's confirmed if it is, or has been in the hash table. */
 static inline int is_confirmed(struct ip_conntrack *ct)
 {
diff -u -r1.1.1.1 ip_conntrack_protocol.h
--- a/include/linux/netfilter_ipv4/ip_conntrack_protocol.h	11 May 2004 13:35:39 -0000	1.1.1.1
+++ b/include/linux/netfilter_ipv4/ip_conntrack_protocol.h	15 Jun 2004 18:00:54 -0000
@@ -50,6 +50,9 @@
 	int (*exp_matches_pkt)(struct ip_conntrack_expect *exp,
 			       const struct sk_buff *skb);
 
+	int (*error)(struct sk_buff *skb, enum ip_conntrack_info *ctinfo,
+		     unsigned int hooknum);
+
 	/* Module (if any) which this is connected to. */
 	struct module *me;
 };

--------------020101080807020505020909--
