From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] modification in current protocol helper API to handle
 error/unclean packets
Date: Thu, 17 Jun 2004 15:46:58 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40D1A0D2.10705@eurodev.net>
References: <Pine.LNX.4.33.0406141551410.12847-100000@blackhole.kfki.hu> <40D18A0B.2070101@eurodev.net> <40D19288.3010103@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040103060703010408060102"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <40D19288.3010103@trash.net>
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
--------------040103060703010408060102
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Patrick,

Patrick McHardy wrote:

> What about this:
>
> ===== net/ipv4/netfilter/ip_fw_compat_masq.c 1.14 vs edited =====
> --- 1.14/net/ipv4/netfilter/ip_fw_compat_masq.c    2004-03-23 02:17:04 
> +01:00
> +++ edited/net/ipv4/netfilter/ip_fw_compat_masq.c    2004-06-17 
> 14:33:49 +02:00
> @@ -143,7 +143,9 @@
>      switch ((*pskb)->nh.iph->protocol) {
>      case IPPROTO_ICMP:
>          /* ICMP errors. */
> -        ct = icmp_error_track(*pskb, &ctinfo, NF_IP_PRE_ROUTING);
> +        ip_ct_find_proto(IPPROTO_ICMP)->error(*pskb, &ctinfo,
> +                                              NF_IP_PRE_ROUTING);
> +        ct = (struct ip_conntrack *)skb->nfct->master;


sure! I like it. I added it to this new patch.

> You could make transition for existing protocols easier by makeing the
> error function optional:
>
> if (proto->error != NULL && ret = proto->error(....))


I also added that. If any last issue, please let me know.

regards,
Pablo

--------------040103060703010408060102
Content-Type: text/x-patch;
 name="protocol_helper-error.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="protocol_helper-error.patch"

diff -u -r1.1.1.1 ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	11 May 2004 13:07:08 -0000	1.1.1.1
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	17 Jun 2004 13:39:21 -0000
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
@@ -828,10 +752,12 @@
 
 	proto = ip_ct_find_proto((*pskb)->nh.iph->protocol);
 
-	/* It may be an icmp error... */
-	if ((*pskb)->nh.iph->protocol == IPPROTO_ICMP 
-	    && icmp_error_track(*pskb, &ctinfo, hooknum))
-		return NF_ACCEPT;
+	/* It may be an special packet, error, unclean...
+	 * inverse of the return code tells to the netfilter
+	 * core what to do with the packet. */
+	if (proto->error != NULL 
+	    && (ret = proto->error(*pskb, &ctinfo, hooknum)) <= 0)
+		return -ret;
 
 	if (!(ct = resolve_normal_ct(*pskb, proto,&set_reply,hooknum,&ctinfo)))
 		/* Not valid part of a connection */
@@ -869,7 +795,8 @@
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
+++ b/net/ipv4/netfilter/ip_conntrack_proto_generic.c	17 Jun 2004 13:19:48 -0000
@@ -65,5 +65,5 @@
 struct ip_conntrack_protocol ip_conntrack_generic_protocol
 = { { NULL, NULL }, 0, "unknown",
     generic_pkt_to_tuple, generic_invert_tuple, generic_print_tuple,
-    generic_print_conntrack, packet, new, NULL, NULL, NULL };
+    generic_print_conntrack, packet, new, NULL, NULL, NULL, NULL };
 
diff -u -r1.1.1.1 ip_conntrack_proto_icmp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	11 May 2004 13:07:08 -0000	1.1.1.1
+++ b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	17 Jun 2004 13:22:23 -0000
@@ -12,6 +12,8 @@
 #include <linux/netfilter.h>
 #include <linux/in.h>
 #include <linux/icmp.h>
+#include <net/ip.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
 
 unsigned long ip_ct_icmp_timeout = 30*HZ;
@@ -122,7 +124,83 @@
 	return 1;
 }
 
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
+++ b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	17 Jun 2004 13:19:20 -0000
@@ -269,4 +269,4 @@
 struct ip_conntrack_protocol ip_conntrack_protocol_tcp
 = { { NULL, NULL }, IPPROTO_TCP, "tcp",
     tcp_pkt_to_tuple, tcp_invert_tuple, tcp_print_tuple, tcp_print_conntrack,
-    tcp_packet, tcp_new, NULL, tcp_exp_matches_pkt, NULL };
+    tcp_packet, tcp_new, NULL, tcp_exp_matches_pkt, NULL, NULL };
diff -u -r1.1.1.1 ip_conntrack_proto_udp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_udp.c	11 May 2004 13:07:08 -0000	1.1.1.1
+++ b/net/ipv4/netfilter/ip_conntrack_proto_udp.c	17 Jun 2004 13:19:36 -0000
@@ -83,4 +83,4 @@
 struct ip_conntrack_protocol ip_conntrack_protocol_udp
 = { { NULL, NULL }, IPPROTO_UDP, "udp",
     udp_pkt_to_tuple, udp_invert_tuple, udp_print_tuple, udp_print_conntrack,
-    udp_packet, udp_new, NULL, NULL, NULL };
+    udp_packet, udp_new, NULL, NULL, NULL, NULL };
diff -u -r1.1.1.1 ip_fw_compat_masq.c
--- a/net/ipv4/netfilter/ip_fw_compat_masq.c	11 May 2004 13:07:08 -0000	1.1.1.1
+++ b/net/ipv4/netfilter/ip_fw_compat_masq.c	17 Jun 2004 13:18:41 -0000
@@ -24,12 +24,14 @@
 #include <linux/proc_fs.h>
 #include <linux/module.h>
 #include <net/route.h>
+#include <net/ip.h>
 
 #define ASSERT_READ_LOCK(x) MUST_BE_READ_LOCKED(&ip_conntrack_lock)
 #define ASSERT_WRITE_LOCK(x) MUST_BE_WRITE_LOCKED(&ip_conntrack_lock)
 
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_core.h>
+#include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
 #include <linux/netfilter_ipv4/ip_nat.h>
 #include <linux/netfilter_ipv4/ip_nat_core.h>
 #include <linux/netfilter_ipv4/listhelp.h>
@@ -143,7 +145,8 @@
 	switch ((*pskb)->nh.iph->protocol) {
 	case IPPROTO_ICMP:
 		/* ICMP errors. */
-		ct = icmp_error_track(*pskb, &ctinfo, NF_IP_PRE_ROUTING);
+		protocol->error(*pskb, &ctinfo, NF_IP_PRE_ROUTING);
+		ct = (struct ip_conntrack *)(*pskb)->nfct->master;
 		if (ct) {
 			/* We only do SNAT in the compatibility layer.
 			   So we can manipulate ICMP errors from
@@ -164,7 +167,7 @@
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

--------------040103060703010408060102--
