From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 42/64]: nf_nat: mark NAT protocols const
Date: Tue, 18 Dec 2007 00:47:10 +0100 (MET)
Message-ID: <20071217234710.23601.59954.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39011 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700AbXLQXrL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:47:11 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_nat: mark NAT protocols const

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7f35f5edca069881dc4bf771d08e192cd8704483
tree 6396e734ccaf658b46560c5fa3ac6b464ef5dcdd
parent 11f11327057d79cd000efab9e70585fb3a356fa6
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:30 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:57 +0100

 include/net/netfilter/nf_nat_protocol.h   |   18 +++++++++---------
 net/ipv4/netfilter/nf_nat_core.c          |   20 ++++++++++----------
 net/ipv4/netfilter/nf_nat_proto_gre.c     |    2 +-
 net/ipv4/netfilter/nf_nat_proto_icmp.c    |    2 +-
 net/ipv4/netfilter/nf_nat_proto_tcp.c     |    2 +-
 net/ipv4/netfilter/nf_nat_proto_udp.c     |    2 +-
 net/ipv4/netfilter/nf_nat_proto_unknown.c |    2 +-
 net/netfilter/nf_conntrack_netlink.c      |    2 +-
 8 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/include/net/netfilter/nf_nat_protocol.h b/include/net/netfilter/nf_nat_protocol.h
index 04578bf..4aa0edb 100644
--- a/include/net/netfilter/nf_nat_protocol.h
+++ b/include/net/netfilter/nf_nat_protocol.h
@@ -46,21 +46,21 @@ struct nf_nat_protocol
 };
 
 /* Protocol registration. */
-extern int nf_nat_protocol_register(struct nf_nat_protocol *proto);
-extern void nf_nat_protocol_unregister(struct nf_nat_protocol *proto);
+extern int nf_nat_protocol_register(const struct nf_nat_protocol *proto);
+extern void nf_nat_protocol_unregister(const struct nf_nat_protocol *proto);
 
-extern struct nf_nat_protocol *nf_nat_proto_find_get(u_int8_t protocol);
-extern void nf_nat_proto_put(struct nf_nat_protocol *proto);
+extern const struct nf_nat_protocol *nf_nat_proto_find_get(u_int8_t protocol);
+extern void nf_nat_proto_put(const struct nf_nat_protocol *proto);
 
 /* Built-in protocols. */
-extern struct nf_nat_protocol nf_nat_protocol_tcp;
-extern struct nf_nat_protocol nf_nat_protocol_udp;
-extern struct nf_nat_protocol nf_nat_protocol_icmp;
-extern struct nf_nat_protocol nf_nat_unknown_protocol;
+extern const struct nf_nat_protocol nf_nat_protocol_tcp;
+extern const struct nf_nat_protocol nf_nat_protocol_udp;
+extern const struct nf_nat_protocol nf_nat_protocol_icmp;
+extern const struct nf_nat_protocol nf_nat_unknown_protocol;
 
 extern int init_protocols(void) __init;
 extern void cleanup_protocols(void);
-extern struct nf_nat_protocol *find_nat_proto(u_int16_t protonum);
+extern const struct nf_nat_protocol *find_nat_proto(u_int16_t protonum);
 
 extern int nf_nat_port_range_to_nlattr(struct sk_buff *skb,
 				       const struct nf_nat_range *range);
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 4ee67e9..a772445 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -42,18 +42,18 @@ static int nf_nat_vmalloced;
 static struct hlist_head *bysource;
 
 #define MAX_IP_NAT_PROTO 256
-static struct nf_nat_protocol *nf_nat_protos[MAX_IP_NAT_PROTO];
+static const struct nf_nat_protocol *nf_nat_protos[MAX_IP_NAT_PROTO];
 
-static inline struct nf_nat_protocol *
+static inline const struct nf_nat_protocol *
 __nf_nat_proto_find(u_int8_t protonum)
 {
 	return rcu_dereference(nf_nat_protos[protonum]);
 }
 
-struct nf_nat_protocol *
+const struct nf_nat_protocol *
 nf_nat_proto_find_get(u_int8_t protonum)
 {
-	struct nf_nat_protocol *p;
+	const struct nf_nat_protocol *p;
 
 	rcu_read_lock();
 	p = __nf_nat_proto_find(protonum);
@@ -66,7 +66,7 @@ nf_nat_proto_find_get(u_int8_t protonum)
 EXPORT_SYMBOL_GPL(nf_nat_proto_find_get);
 
 void
-nf_nat_proto_put(struct nf_nat_protocol *p)
+nf_nat_proto_put(const struct nf_nat_protocol *p)
 {
 	module_put(p->me);
 }
@@ -105,7 +105,7 @@ static int
 in_range(const struct nf_conntrack_tuple *tuple,
 	 const struct nf_nat_range *range)
 {
-	struct nf_nat_protocol *proto;
+	const struct nf_nat_protocol *proto;
 	int ret = 0;
 
 	/* If we are supposed to map IPs, then we must be in the
@@ -226,7 +226,7 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 		 struct nf_conn *ct,
 		 enum nf_nat_manip_type maniptype)
 {
-	struct nf_nat_protocol *proto;
+	const struct nf_nat_protocol *proto;
 
 	/* 1) If this srcip/proto/src-proto-part is currently mapped,
 	   and that same mapping gives a unique tuple within the given
@@ -355,7 +355,7 @@ manip_pkt(u_int16_t proto,
 	  enum nf_nat_manip_type maniptype)
 {
 	struct iphdr *iph;
-	struct nf_nat_protocol *p;
+	const struct nf_nat_protocol *p;
 
 	if (!skb_make_writable(skb, iphdroff + sizeof(*iph)))
 		return 0;
@@ -515,7 +515,7 @@ int nf_nat_icmp_reply_translation(struct nf_conn *ct,
 EXPORT_SYMBOL_GPL(nf_nat_icmp_reply_translation);
 
 /* Protocol registration. */
-int nf_nat_protocol_register(struct nf_nat_protocol *proto)
+int nf_nat_protocol_register(const struct nf_nat_protocol *proto)
 {
 	int ret = 0;
 
@@ -532,7 +532,7 @@ int nf_nat_protocol_register(struct nf_nat_protocol *proto)
 EXPORT_SYMBOL(nf_nat_protocol_register);
 
 /* Noone stores the protocol anywhere; simply delete it. */
-void nf_nat_protocol_unregister(struct nf_nat_protocol *proto)
+void nf_nat_protocol_unregister(const struct nf_nat_protocol *proto)
 {
 	write_lock_bh(&nf_nat_lock);
 	rcu_assign_pointer(nf_nat_protos[proto->protonum],
diff --git a/net/ipv4/netfilter/nf_nat_proto_gre.c b/net/ipv4/netfilter/nf_nat_proto_gre.c
index 945e0ae..9fa272e 100644
--- a/net/ipv4/netfilter/nf_nat_proto_gre.c
+++ b/net/ipv4/netfilter/nf_nat_proto_gre.c
@@ -135,7 +135,7 @@ gre_manip_pkt(struct sk_buff *skb, unsigned int iphdroff,
 	return 1;
 }
 
-static struct nf_nat_protocol gre __read_mostly = {
+static const struct nf_nat_protocol gre = {
 	.name			= "GRE",
 	.protonum		= IPPROTO_GRE,
 	.me			= THIS_MODULE,
diff --git a/net/ipv4/netfilter/nf_nat_proto_icmp.c b/net/ipv4/netfilter/nf_nat_proto_icmp.c
index 088bb14..a0e44c9 100644
--- a/net/ipv4/netfilter/nf_nat_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_icmp.c
@@ -71,7 +71,7 @@ icmp_manip_pkt(struct sk_buff *skb,
 	return 1;
 }
 
-struct nf_nat_protocol nf_nat_protocol_icmp = {
+const struct nf_nat_protocol nf_nat_protocol_icmp = {
 	.name			= "ICMP",
 	.protonum		= IPPROTO_ICMP,
 	.me			= THIS_MODULE,
diff --git a/net/ipv4/netfilter/nf_nat_proto_tcp.c b/net/ipv4/netfilter/nf_nat_proto_tcp.c
index 633c53f..da23e9f 100644
--- a/net/ipv4/netfilter/nf_nat_proto_tcp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_tcp.c
@@ -137,7 +137,7 @@ tcp_manip_pkt(struct sk_buff *skb,
 	return 1;
 }
 
-struct nf_nat_protocol nf_nat_protocol_tcp = {
+const struct nf_nat_protocol nf_nat_protocol_tcp = {
 	.name			= "TCP",
 	.protonum		= IPPROTO_TCP,
 	.me			= THIS_MODULE,
diff --git a/net/ipv4/netfilter/nf_nat_proto_udp.c b/net/ipv4/netfilter/nf_nat_proto_udp.c
index 9c6519c..10df4db 100644
--- a/net/ipv4/netfilter/nf_nat_proto_udp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_udp.c
@@ -127,7 +127,7 @@ udp_manip_pkt(struct sk_buff *skb,
 	return 1;
 }
 
-struct nf_nat_protocol nf_nat_protocol_udp = {
+const struct nf_nat_protocol nf_nat_protocol_udp = {
 	.name			= "UDP",
 	.protonum		= IPPROTO_UDP,
 	.me			= THIS_MODULE,
diff --git a/net/ipv4/netfilter/nf_nat_proto_unknown.c b/net/ipv4/netfilter/nf_nat_proto_unknown.c
index cfd2742..a26efeb 100644
--- a/net/ipv4/netfilter/nf_nat_proto_unknown.c
+++ b/net/ipv4/netfilter/nf_nat_proto_unknown.c
@@ -45,7 +45,7 @@ unknown_manip_pkt(struct sk_buff *skb,
 	return 1;
 }
 
-struct nf_nat_protocol nf_nat_unknown_protocol = {
+const struct nf_nat_protocol nf_nat_unknown_protocol = {
 	.name			= "unknown",
 	/* .me isn't set: getting a ref to this cannot fail. */
 	.manip_pkt		= unknown_manip_pkt,
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 7501258..7851065 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -695,7 +695,7 @@ static int nfnetlink_parse_nat_proto(struct nlattr *attr,
 				     struct nf_nat_range *range)
 {
 	struct nlattr *tb[CTA_PROTONAT_MAX+1];
-	struct nf_nat_protocol *npt;
+	const struct nf_nat_protocol *npt;
 	int err;
 
 	err = nla_parse_nested(tb, CTA_PROTONAT_MAX, attr, protonat_nla_policy);
