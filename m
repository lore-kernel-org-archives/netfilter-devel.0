From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 7/12]: Keep conntrack/nat protocols in array instead of
 linked list
Date: Tue, 21 Sep 2004 05:22:51 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <414F9E8B.1030003@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010106070603050309020308"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------010106070603050309020308
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

ChangeSet@1.1935.1.7, 2004-09-19 16:28:21+02:00, kaber@coreworks.de
  [NETFILTER]: Keep conntrack/nat protocols in array instead of linked list
 
  Signed-off-by: Patrick McHardy <kaber@trash.net>



--------------010106070603050309020308
Content-Type: text/x-patch;
 name="07.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="07.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/09/19 16:28:21+02:00 kaber@coreworks.de 
#   [NETFILTER]: Keep conntrack/nat protocols in array instead of linked list
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_standalone.c
#   2004/09/19 16:27:55+02:00 kaber@coreworks.de +5 -10
#   [NETFILTER]: Keep conntrack/nat protocols in array instead of linked list
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_proto_unknown.c
#   2004/09/19 16:27:55+02:00 kaber@coreworks.de +2 -2
#   [NETFILTER]: Keep conntrack/nat protocols in array instead of linked list
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_proto_udp.c
#   2004/09/19 16:27:55+02:00 kaber@coreworks.de +1 -1
#   [NETFILTER]: Keep conntrack/nat protocols in array instead of linked list
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_proto_tcp.c
#   2004/09/19 16:27:55+02:00 kaber@coreworks.de +1 -1
#   [NETFILTER]: Keep conntrack/nat protocols in array instead of linked list
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_proto_icmp.c
#   2004/09/19 16:27:55+02:00 kaber@coreworks.de +1 -1
#   [NETFILTER]: Keep conntrack/nat protocols in array instead of linked list
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_core.c
#   2004/09/19 16:27:55+02:00 kaber@coreworks.de +11 -28
#   [NETFILTER]: Keep conntrack/nat protocols in array instead of linked list
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_standalone.c
#   2004/09/19 16:27:55+02:00 kaber@coreworks.de +8 -17
#   [NETFILTER]: Keep conntrack/nat protocols in array instead of linked list
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_proto_sctp.c
#   2004/09/19 16:27:55+02:00 kaber@coreworks.de +0 -1
#   [NETFILTER]: Keep conntrack/nat protocols in array instead of linked list
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_core.c
#   2004/09/19 16:27:55+02:00 kaber@coreworks.de +6 -35
#   [NETFILTER]: Keep conntrack/nat protocols in array instead of linked list
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv4/ip_nat_protocol.h
#   2004/09/19 16:27:55+02:00 kaber@coreworks.de +14 -2
#   [NETFILTER]: Keep conntrack/nat protocols in array instead of linked list
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv4/ip_nat_core.h
#   2004/09/19 16:27:55+02:00 kaber@coreworks.de +0 -6
#   [NETFILTER]: Keep conntrack/nat protocols in array instead of linked list
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv4/ip_conntrack_protocol.h
#   2004/09/19 16:27:55+02:00 kaber@coreworks.de +9 -3
#   [NETFILTER]: Keep conntrack/nat protocols in array instead of linked list
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv4/ip_conntrack_core.h
#   2004/09/19 16:27:55+02:00 kaber@coreworks.de +0 -4
#   [NETFILTER]: Keep conntrack/nat protocols in array instead of linked list
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/include/linux/netfilter_ipv4/ip_conntrack_core.h b/include/linux/netfilter_ipv4/ip_conntrack_core.h
--- a/include/linux/netfilter_ipv4/ip_conntrack_core.h	2004-09-20 11:58:29 +02:00
+++ b/include/linux/netfilter_ipv4/ip_conntrack_core.h	2004-09-20 11:58:29 +02:00
@@ -16,10 +16,6 @@
 extern void ip_conntrack_cleanup(void);
 
 struct ip_conntrack_protocol;
-extern struct ip_conntrack_protocol *ip_ct_find_proto(u_int8_t protocol);
-/* Like above, but you already have conntrack read lock. */
-extern struct ip_conntrack_protocol *__ip_ct_find_proto(u_int8_t protocol);
-extern struct list_head protocol_list;
 
 extern int
 ip_ct_get_tuple(const struct iphdr *iph,
diff -Nru a/include/linux/netfilter_ipv4/ip_conntrack_protocol.h b/include/linux/netfilter_ipv4/ip_conntrack_protocol.h
--- a/include/linux/netfilter_ipv4/ip_conntrack_protocol.h	2004-09-20 11:58:29 +02:00
+++ b/include/linux/netfilter_ipv4/ip_conntrack_protocol.h	2004-09-20 11:58:29 +02:00
@@ -7,9 +7,6 @@
 
 struct ip_conntrack_protocol
 {
-	/* Next pointer. */
-	struct list_head list;
-
 	/* Protocol number. */
 	u_int8_t proto;
 
@@ -58,14 +55,23 @@
 	struct module *me;
 };
 
+#define MAX_IP_CT_PROTO 256
+extern struct ip_conntrack_protocol *ip_ct_protos[MAX_IP_CT_PROTO];
+
 /* Protocol registration. */
 extern int ip_conntrack_protocol_register(struct ip_conntrack_protocol *proto);
 extern void ip_conntrack_protocol_unregister(struct ip_conntrack_protocol *proto);
 
+static inline struct ip_conntrack_protocol *ip_ct_find_proto(u_int8_t protocol)
+{
+	return ip_ct_protos[protocol];
+}
+
 /* Existing built-in protocols */
 extern struct ip_conntrack_protocol ip_conntrack_protocol_tcp;
 extern struct ip_conntrack_protocol ip_conntrack_protocol_udp;
 extern struct ip_conntrack_protocol ip_conntrack_protocol_icmp;
+extern struct ip_conntrack_protocol ip_conntrack_generic_protocol;
 extern int ip_conntrack_protocol_tcp_init(void);
 
 /* Log invalid packets */
diff -Nru a/include/linux/netfilter_ipv4/ip_nat_core.h b/include/linux/netfilter_ipv4/ip_nat_core.h
--- a/include/linux/netfilter_ipv4/ip_nat_core.h	2004-09-20 11:58:29 +02:00
+++ b/include/linux/netfilter_ipv4/ip_nat_core.h	2004-09-20 11:58:29 +02:00
@@ -14,8 +14,6 @@
 				unsigned int hooknum,
 				struct sk_buff **pskb);
 
-extern struct list_head protos;
-
 extern int icmp_reply_translation(struct sk_buff **pskb,
 				  struct ip_conntrack *conntrack,
 				  unsigned int hooknum,
@@ -26,8 +24,4 @@
 extern void place_in_hashes(struct ip_conntrack *conntrack,
 			    struct ip_nat_info *info);
 
-/* Built-in protocols. */
-extern struct ip_nat_protocol ip_nat_protocol_tcp;
-extern struct ip_nat_protocol ip_nat_protocol_udp;
-extern struct ip_nat_protocol ip_nat_protocol_icmp;
 #endif /* _IP_NAT_CORE_H */
diff -Nru a/include/linux/netfilter_ipv4/ip_nat_protocol.h b/include/linux/netfilter_ipv4/ip_nat_protocol.h
--- a/include/linux/netfilter_ipv4/ip_nat_protocol.h	2004-09-20 11:58:29 +02:00
+++ b/include/linux/netfilter_ipv4/ip_nat_protocol.h	2004-09-20 11:58:29 +02:00
@@ -9,8 +9,6 @@
 
 struct ip_nat_protocol
 {
-	struct list_head list;
-
 	/* Protocol name */
 	const char *name;
 
@@ -47,9 +45,23 @@
 				    const struct ip_nat_range *range);
 };
 
+#define MAX_IP_NAT_PROTO 256
+extern struct ip_nat_protocol *ip_nat_protos[MAX_IP_NAT_PROTO];
+
 /* Protocol registration. */
 extern int ip_nat_protocol_register(struct ip_nat_protocol *proto);
 extern void ip_nat_protocol_unregister(struct ip_nat_protocol *proto);
+
+static inline struct ip_nat_protocol *ip_nat_find_proto(u_int8_t protocol)
+{
+	return ip_nat_protos[protocol];
+}
+
+/* Built-in protocols. */
+extern struct ip_nat_protocol ip_nat_protocol_tcp;
+extern struct ip_nat_protocol ip_nat_protocol_udp;
+extern struct ip_nat_protocol ip_nat_protocol_icmp;
+extern struct ip_nat_protocol ip_nat_unknown_protocol;
 
 extern int init_protocols(void) __init;
 extern void cleanup_protocols(void);
diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	2004-09-20 11:58:29 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	2004-09-20 11:58:29 +02:00
@@ -66,7 +66,7 @@
 
 void (*ip_conntrack_destroyed)(struct ip_conntrack *conntrack) = NULL;
 LIST_HEAD(ip_conntrack_expect_list);
-LIST_HEAD(protocol_list);
+struct ip_conntrack_protocol *ip_ct_protos[MAX_IP_CT_PROTO];
 static LIST_HEAD(helpers);
 unsigned int ip_conntrack_htable_size = 0;
 int ip_conntrack_max;
@@ -77,37 +77,6 @@
 
 DEFINE_PER_CPU(struct ip_conntrack_stat, ip_conntrack_stat);
 
-extern struct ip_conntrack_protocol ip_conntrack_generic_protocol;
-
-static inline int proto_cmpfn(const struct ip_conntrack_protocol *curr,
-			      u_int8_t protocol)
-{
-	return protocol == curr->proto;
-}
-
-struct ip_conntrack_protocol *__ip_ct_find_proto(u_int8_t protocol)
-{
-	struct ip_conntrack_protocol *p;
-
-	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
-	p = LIST_FIND(&protocol_list, proto_cmpfn,
-		      struct ip_conntrack_protocol *, protocol);
-	if (!p)
-		p = &ip_conntrack_generic_protocol;
-
-	return p;
-}
-
-struct ip_conntrack_protocol *ip_ct_find_proto(u_int8_t protocol)
-{
-	struct ip_conntrack_protocol *p;
-
-	READ_LOCK(&ip_conntrack_lock);
-	p = __ip_ct_find_proto(protocol);
-	READ_UNLOCK(&ip_conntrack_lock);
-	return p;
-}
-
 inline void 
 ip_conntrack_put(struct ip_conntrack *ct)
 {
@@ -1397,10 +1366,12 @@
 
 	/* Don't NEED lock here, but good form anyway. */
 	WRITE_LOCK(&ip_conntrack_lock);
+	for (i = 0; i < MAX_IP_CT_PROTO; i++)
+		ip_ct_protos[i] = &ip_conntrack_generic_protocol;
 	/* Sew in builtin protocols. */
-	list_append(&protocol_list, &ip_conntrack_protocol_tcp);
-	list_append(&protocol_list, &ip_conntrack_protocol_udp);
-	list_append(&protocol_list, &ip_conntrack_protocol_icmp);
+	ip_ct_protos[IPPROTO_TCP] = &ip_conntrack_protocol_tcp;
+	ip_ct_protos[IPPROTO_UDP] = &ip_conntrack_protocol_udp;
+	ip_ct_protos[IPPROTO_ICMP] = &ip_conntrack_protocol_icmp;
 	WRITE_UNLOCK(&ip_conntrack_lock);
 
 	for (i = 0; i < ip_conntrack_htable_size; i++)
diff -Nru a/net/ipv4/netfilter/ip_conntrack_proto_sctp.c b/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2004-09-20 11:58:29 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2004-09-20 11:58:29 +02:00
@@ -496,7 +496,6 @@
 }
 
 struct ip_conntrack_protocol ip_conntrack_protocol_sctp = { 
-	.list 		 = { NULL, NULL }, 
 	.proto 		 = IPPROTO_SCTP, 
 	.name 		 = "sctp",
 	.pkt_to_tuple 	 = sctp_pkt_to_tuple, 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-09-20 11:58:29 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-09-20 11:58:29 +02:00
@@ -112,7 +112,7 @@
 	if (DIRECTION(hash))
 		return 0;
 
-	proto = __ip_ct_find_proto(conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
+	proto = ip_ct_find_proto(conntrack->tuplehash[IP_CT_DIR_ORIGINAL]
 			       .tuple.dst.protonum);
 	IP_NF_ASSERT(proto);
 
@@ -242,7 +242,7 @@
 		   expect->tuple.dst.protonum);
 
 	return print_tuple(s, &expect->tuple,
-			   __ip_ct_find_proto(expect->tuple.dst.protonum));
+			   ip_ct_find_proto(expect->tuple.dst.protonum));
 }
 
 static struct seq_operations exp_seq_ops = {
@@ -823,19 +823,13 @@
 int ip_conntrack_protocol_register(struct ip_conntrack_protocol *proto)
 {
 	int ret = 0;
-	struct list_head *i;
 
 	WRITE_LOCK(&ip_conntrack_lock);
-	list_for_each(i, &protocol_list) {
-		if (((struct ip_conntrack_protocol *)i)->proto
-		    == proto->proto) {
-			ret = -EBUSY;
-			goto out;
-		}
+	if (ip_ct_protos[proto->proto] != &ip_conntrack_generic_protocol) {
+		ret = -EBUSY;
+		goto out;
 	}
-
-	list_prepend(&protocol_list, proto);
-
+	ip_ct_protos[proto->proto] = proto;
  out:
 	WRITE_UNLOCK(&ip_conntrack_lock);
 	return ret;
@@ -844,10 +838,7 @@
 void ip_conntrack_protocol_unregister(struct ip_conntrack_protocol *proto)
 {
 	WRITE_LOCK(&ip_conntrack_lock);
-
-	/* ip_ct_find_proto() returns proto_generic in case there is no protocol 
-	 * helper. So this should be enough - HW */
-	LIST_DELETE(&protocol_list, proto);
+	ip_ct_protos[proto->proto] = &ip_conntrack_generic_protocol;
 	WRITE_UNLOCK(&ip_conntrack_lock);
 	
 	/* Somebody could be still looking at the proto in bh. */
@@ -887,8 +878,8 @@
 EXPORT_SYMBOL(ip_conntrack_helper_unregister);
 EXPORT_SYMBOL(ip_ct_selective_cleanup);
 EXPORT_SYMBOL(ip_ct_refresh_acct);
+EXPORT_SYMBOL(ip_ct_protos);
 EXPORT_SYMBOL(ip_ct_find_proto);
-EXPORT_SYMBOL(__ip_ct_find_proto);
 EXPORT_SYMBOL(ip_ct_find_helper);
 EXPORT_SYMBOL(ip_conntrack_expect_alloc);
 EXPORT_SYMBOL(ip_conntrack_expect_related);
diff -Nru a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_core.c
--- a/net/ipv4/netfilter/ip_nat_core.c	2004-09-20 11:58:29 +02:00
+++ b/net/ipv4/netfilter/ip_nat_core.c	2004-09-20 11:58:29 +02:00
@@ -48,9 +48,8 @@
 
 static struct list_head *bysource;
 static struct list_head *byipsproto;
-LIST_HEAD(protos);
+struct ip_nat_protocol *ip_nat_protos[MAX_IP_NAT_PROTO];
 
-extern struct ip_nat_protocol unknown_nat_protocol;
 
 /* We keep extra hashes for each conntrack, for fast searching. */
 static inline size_t
@@ -103,23 +102,6 @@
 				      oldcheck^0xFFFF));
 }
 
-static inline int cmp_proto(const struct ip_nat_protocol *i, int proto)
-{
-	return i->protonum == proto;
-}
-
-struct ip_nat_protocol *
-find_nat_proto(u_int16_t protonum)
-{
-	struct ip_nat_protocol *i;
-
-	MUST_BE_READ_LOCKED(&ip_nat_lock);
-	i = LIST_FIND(&protos, cmp_proto, struct ip_nat_protocol *, protonum);
-	if (!i)
-		i = &unknown_nat_protocol;
-	return i;
-}
-
 /* Is this tuple already taken? (not by us) */
 int
 ip_nat_used_tuple(const struct ip_conntrack_tuple *tuple,
@@ -142,7 +124,7 @@
 	 const struct ip_conntrack_manip *manip,
 	 const struct ip_nat_multi_range *mr)
 {
-	struct ip_nat_protocol *proto = find_nat_proto(tuple->dst.protonum);
+	struct ip_nat_protocol *proto = ip_nat_find_proto(tuple->dst.protonum);
 	unsigned int i;
 	struct ip_conntrack_tuple newtuple = { *manip, tuple->dst };
 
@@ -394,7 +376,7 @@
 		 unsigned int hooknum)
 {
 	struct ip_nat_protocol *proto
-		= find_nat_proto(orig_tuple->dst.protonum);
+		= ip_nat_find_proto(orig_tuple->dst.protonum);
 	struct ip_nat_range *rptr;
 	unsigned int i;
 	int ret;
@@ -705,9 +687,8 @@
 	iph = (void *)(*pskb)->data + iphdroff;
 
 	/* Manipulate protcol part. */
-	if (!find_nat_proto(proto)->manip_pkt(pskb,
-					      iphdroff + iph->ihl*4,
-					      manip, maniptype))
+	if (!ip_nat_find_proto(proto)->manip_pkt(pskb, iphdroff + iph->ihl*4,
+	                                         manip, maniptype))
 		return 0;
 
 	iph = (void *)(*pskb)->data + iphdroff;
@@ -731,7 +712,7 @@
 	int ret = 1;
 
 	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
-	proto = __ip_ct_find_proto(skb->nh.iph->protocol);
+	proto = ip_ct_find_proto(skb->nh.iph->protocol);
 	if (proto->exp_matches_pkt)
 		ret = proto->exp_matches_pkt(exp, skb);
 
@@ -976,9 +957,11 @@
 
 	/* Sew in builtin protocols. */
 	WRITE_LOCK(&ip_nat_lock);
-	list_append(&protos, &ip_nat_protocol_tcp);
-	list_append(&protos, &ip_nat_protocol_udp);
-	list_append(&protos, &ip_nat_protocol_icmp);
+	for (i = 0; i < MAX_IP_NAT_PROTO; i++)
+		ip_nat_protos[i] = &ip_nat_unknown_protocol;
+	ip_nat_protos[IPPROTO_TCP] = &ip_nat_protocol_tcp;
+	ip_nat_protos[IPPROTO_UDP] = &ip_nat_protocol_udp;
+	ip_nat_protos[IPPROTO_ICMP] = &ip_nat_protocol_icmp;
 	WRITE_UNLOCK(&ip_nat_lock);
 
 	for (i = 0; i < ip_nat_htable_size; i++) {
diff -Nru a/net/ipv4/netfilter/ip_nat_proto_icmp.c b/net/ipv4/netfilter/ip_nat_proto_icmp.c
--- a/net/ipv4/netfilter/ip_nat_proto_icmp.c	2004-09-20 11:58:29 +02:00
+++ b/net/ipv4/netfilter/ip_nat_proto_icmp.c	2004-09-20 11:58:29 +02:00
@@ -104,7 +104,7 @@
 }
 
 struct ip_nat_protocol ip_nat_protocol_icmp
-= { { NULL, NULL }, "ICMP", IPPROTO_ICMP,
+= { "ICMP", IPPROTO_ICMP,
     icmp_manip_pkt,
     icmp_in_range,
     icmp_unique_tuple,
diff -Nru a/net/ipv4/netfilter/ip_nat_proto_tcp.c b/net/ipv4/netfilter/ip_nat_proto_tcp.c
--- a/net/ipv4/netfilter/ip_nat_proto_tcp.c	2004-09-20 11:58:29 +02:00
+++ b/net/ipv4/netfilter/ip_nat_proto_tcp.c	2004-09-20 11:58:29 +02:00
@@ -162,7 +162,7 @@
 }
 
 struct ip_nat_protocol ip_nat_protocol_tcp
-= { { NULL, NULL }, "TCP", IPPROTO_TCP,
+= { "TCP", IPPROTO_TCP,
     tcp_manip_pkt,
     tcp_in_range,
     tcp_unique_tuple,
diff -Nru a/net/ipv4/netfilter/ip_nat_proto_udp.c b/net/ipv4/netfilter/ip_nat_proto_udp.c
--- a/net/ipv4/netfilter/ip_nat_proto_udp.c	2004-09-20 11:58:29 +02:00
+++ b/net/ipv4/netfilter/ip_nat_proto_udp.c	2004-09-20 11:58:29 +02:00
@@ -148,7 +148,7 @@
 }
 
 struct ip_nat_protocol ip_nat_protocol_udp
-= { { NULL, NULL }, "UDP", IPPROTO_UDP,
+= { "UDP", IPPROTO_UDP,
     udp_manip_pkt,
     udp_in_range,
     udp_unique_tuple,
diff -Nru a/net/ipv4/netfilter/ip_nat_proto_unknown.c b/net/ipv4/netfilter/ip_nat_proto_unknown.c
--- a/net/ipv4/netfilter/ip_nat_proto_unknown.c	2004-09-20 11:58:29 +02:00
+++ b/net/ipv4/netfilter/ip_nat_proto_unknown.c	2004-09-20 11:58:29 +02:00
@@ -60,8 +60,8 @@
 	return 0;
 }
 
-struct ip_nat_protocol unknown_nat_protocol = {
-	{ NULL, NULL }, "unknown", 0,
+struct ip_nat_protocol ip_nat_unknown_protocol = {
+	"unknown", 0,
 	unknown_manip_pkt,
 	unknown_in_range,
 	unknown_unique_tuple,
diff -Nru a/net/ipv4/netfilter/ip_nat_standalone.c b/net/ipv4/netfilter/ip_nat_standalone.c
--- a/net/ipv4/netfilter/ip_nat_standalone.c	2004-09-20 11:58:29 +02:00
+++ b/net/ipv4/netfilter/ip_nat_standalone.c	2004-09-20 11:58:29 +02:00
@@ -283,18 +283,13 @@
 int ip_nat_protocol_register(struct ip_nat_protocol *proto)
 {
 	int ret = 0;
-	struct list_head *i;
 
 	WRITE_LOCK(&ip_nat_lock);
-	list_for_each(i, &protos) {
-		if (((struct ip_nat_protocol *)i)->protonum
-		    == proto->protonum) {
-			ret = -EBUSY;
-			goto out;
-		}
+	if (ip_nat_protos[proto->protonum] != &ip_nat_unknown_protocol) {
+		ret = -EBUSY;
+		goto out;
 	}
-
-	list_prepend(&protos, proto);
+	ip_nat_protos[proto->protonum] = proto;
  out:
 	WRITE_UNLOCK(&ip_nat_lock);
 	return ret;
@@ -304,7 +299,7 @@
 void ip_nat_protocol_unregister(struct ip_nat_protocol *proto)
 {
 	WRITE_LOCK(&ip_nat_lock);
-	LIST_DELETE(&protos, proto);
+	ip_nat_protos[proto->protonum] = &ip_nat_unknown_protocol;
 	WRITE_UNLOCK(&ip_nat_lock);
 
 	/* Someone could be still looking at the proto in a bh. */

--------------010106070603050309020308--
