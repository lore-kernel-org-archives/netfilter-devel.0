From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 19/41]: nf_nat: move NAT ctnetlink helpers to nf_nat_proto_common
Date: Mon, 14 Apr 2008 12:16:44 +0200 (MEST)
Message-ID: <20080414101641.32717.67013.sendpatchset@localhost.localdomain>
References: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36289 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbYDNKQp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:16:45 -0400
In-Reply-To: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_nat: move NAT ctnetlink helpers to nf_nat_proto_common

Move to nf_nat_proto_common and rename to nf_nat_proto_... since they're
also used by protocols that don't have port numbers.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 89cebbb26f6542cdeb224adc6c871150221dd0c9
tree 881669d5955c28cb3a3ab0f9e0af939312e58559
parent 2cfcdfef4681d3fc734f0c8e11c78425098731c6
author Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:49 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:49 +0200

 include/net/netfilter/nf_nat_protocol.h  |    8 +++---
 net/ipv4/netfilter/nf_nat_core.c         |   40 ------------------------------
 net/ipv4/netfilter/nf_nat_proto_common.c |   38 +++++++++++++++++++++++++++++
 net/ipv4/netfilter/nf_nat_proto_gre.c    |    4 ++-
 net/ipv4/netfilter/nf_nat_proto_icmp.c   |    4 ++-
 net/ipv4/netfilter/nf_nat_proto_tcp.c    |    4 ++-
 net/ipv4/netfilter/nf_nat_proto_udp.c    |    4 ++-
 7 files changed, 50 insertions(+), 52 deletions(-)

diff --git a/include/net/netfilter/nf_nat_protocol.h b/include/net/netfilter/nf_nat_protocol.h
index fa06f6d..8ce2276 100644
--- a/include/net/netfilter/nf_nat_protocol.h
+++ b/include/net/netfilter/nf_nat_protocol.h
@@ -73,9 +73,9 @@ extern int nf_nat_proto_unique_tuple(struct nf_conntrack_tuple *tuple,
 				     const struct nf_conn *ct,
 				     u_int16_t *rover);
 
-extern int nf_nat_port_range_to_nlattr(struct sk_buff *skb,
-				       const struct nf_nat_range *range);
-extern int nf_nat_port_nlattr_to_range(struct nlattr *tb[],
-				       struct nf_nat_range *range);
+extern int nf_nat_proto_range_to_nlattr(struct sk_buff *skb,
+					const struct nf_nat_range *range);
+extern int nf_nat_proto_nlattr_to_range(struct nlattr *tb[],
+					struct nf_nat_range *range);
 
 #endif /*_NF_NAT_PROTO_H*/
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 37b7125..105bf61 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -544,46 +544,6 @@ void nf_nat_protocol_unregister(const struct nf_nat_protocol *proto)
 }
 EXPORT_SYMBOL(nf_nat_protocol_unregister);
 
-#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
-int
-nf_nat_port_range_to_nlattr(struct sk_buff *skb,
-			    const struct nf_nat_range *range)
-{
-	NLA_PUT_BE16(skb, CTA_PROTONAT_PORT_MIN, range->min.tcp.port);
-	NLA_PUT_BE16(skb, CTA_PROTONAT_PORT_MAX, range->max.tcp.port);
-
-	return 0;
-
-nla_put_failure:
-	return -1;
-}
-EXPORT_SYMBOL_GPL(nf_nat_port_nlattr_to_range);
-
-int
-nf_nat_port_nlattr_to_range(struct nlattr *tb[], struct nf_nat_range *range)
-{
-	int ret = 0;
-
-	/* we have to return whether we actually parsed something or not */
-
-	if (tb[CTA_PROTONAT_PORT_MIN]) {
-		ret = 1;
-		range->min.tcp.port = nla_get_be16(tb[CTA_PROTONAT_PORT_MIN]);
-	}
-
-	if (!tb[CTA_PROTONAT_PORT_MAX]) {
-		if (ret)
-			range->max.tcp.port = range->min.tcp.port;
-	} else {
-		ret = 1;
-		range->max.tcp.port = nla_get_be16(tb[CTA_PROTONAT_PORT_MAX]);
-	}
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(nf_nat_port_range_to_nlattr);
-#endif
-
 /* Noone using conntrack by the time this called. */
 static void nf_nat_cleanup_conntrack(struct nf_conn *ct)
 {
diff --git a/net/ipv4/netfilter/nf_nat_proto_common.c b/net/ipv4/netfilter/nf_nat_proto_common.c
index 871ab0e..ef4dc39 100644
--- a/net/ipv4/netfilter/nf_nat_proto_common.c
+++ b/net/ipv4/netfilter/nf_nat_proto_common.c
@@ -88,3 +88,41 @@ int nf_nat_proto_unique_tuple(struct nf_conntrack_tuple *tuple,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nf_nat_proto_unique_tuple);
+
+#if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
+int nf_nat_proto_range_to_nlattr(struct sk_buff *skb,
+				 const struct nf_nat_range *range)
+{
+	NLA_PUT_BE16(skb, CTA_PROTONAT_PORT_MIN, range->min.all);
+	NLA_PUT_BE16(skb, CTA_PROTONAT_PORT_MAX, range->max.all);
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+EXPORT_SYMBOL_GPL(nf_nat_proto_nlattr_to_range);
+
+int nf_nat_proto_nlattr_to_range(struct nlattr *tb[],
+				 struct nf_nat_range *range)
+{
+	int ret = 0;
+
+	/* we have to return whether we actually parsed something or not */
+
+	if (tb[CTA_PROTONAT_PORT_MIN]) {
+		ret = 1;
+		range->min.all = nla_get_be16(tb[CTA_PROTONAT_PORT_MIN]);
+	}
+
+	if (!tb[CTA_PROTONAT_PORT_MAX]) {
+		if (ret)
+			range->max.all = range->min.all;
+	} else {
+		ret = 1;
+		range->max.all = nla_get_be16(tb[CTA_PROTONAT_PORT_MAX]);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nf_nat_proto_range_to_nlattr);
+#endif
diff --git a/net/ipv4/netfilter/nf_nat_proto_gre.c b/net/ipv4/netfilter/nf_nat_proto_gre.c
index 87af63d..71b0935 100644
--- a/net/ipv4/netfilter/nf_nat_proto_gre.c
+++ b/net/ipv4/netfilter/nf_nat_proto_gre.c
@@ -125,8 +125,8 @@ static const struct nf_nat_protocol gre = {
 	.in_range		= nf_nat_proto_in_range,
 	.unique_tuple		= gre_unique_tuple,
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
-	.range_to_nlattr	= nf_nat_port_range_to_nlattr,
-	.nlattr_to_range	= nf_nat_port_nlattr_to_range,
+	.range_to_nlattr	= nf_nat_proto_range_to_nlattr,
+	.nlattr_to_range	= nf_nat_proto_nlattr_to_range,
 #endif
 };
 
diff --git a/net/ipv4/netfilter/nf_nat_proto_icmp.c b/net/ipv4/netfilter/nf_nat_proto_icmp.c
index 03a0296..ca601f8 100644
--- a/net/ipv4/netfilter/nf_nat_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_icmp.c
@@ -79,7 +79,7 @@ const struct nf_nat_protocol nf_nat_protocol_icmp = {
 	.in_range		= icmp_in_range,
 	.unique_tuple		= icmp_unique_tuple,
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
-	.range_to_nlattr	= nf_nat_port_range_to_nlattr,
-	.nlattr_to_range	= nf_nat_port_nlattr_to_range,
+	.range_to_nlattr	= nf_nat_proto_range_to_nlattr,
+	.nlattr_to_range	= nf_nat_proto_nlattr_to_range,
 #endif
 };
diff --git a/net/ipv4/netfilter/nf_nat_proto_tcp.c b/net/ipv4/netfilter/nf_nat_proto_tcp.c
index f8c498f..1d73a11 100644
--- a/net/ipv4/netfilter/nf_nat_proto_tcp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_tcp.c
@@ -88,7 +88,7 @@ const struct nf_nat_protocol nf_nat_protocol_tcp = {
 	.in_range		= nf_nat_proto_in_range,
 	.unique_tuple		= tcp_unique_tuple,
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
-	.range_to_nlattr	= nf_nat_port_range_to_nlattr,
-	.nlattr_to_range	= nf_nat_port_nlattr_to_range,
+	.range_to_nlattr	= nf_nat_proto_range_to_nlattr,
+	.nlattr_to_range	= nf_nat_proto_nlattr_to_range,
 #endif
 };
diff --git a/net/ipv4/netfilter/nf_nat_proto_udp.c b/net/ipv4/netfilter/nf_nat_proto_udp.c
index a182f5a..f36ce55 100644
--- a/net/ipv4/netfilter/nf_nat_proto_udp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_udp.c
@@ -79,7 +79,7 @@ const struct nf_nat_protocol nf_nat_protocol_udp = {
 	.in_range		= nf_nat_proto_in_range,
 	.unique_tuple		= udp_unique_tuple,
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
-	.range_to_nlattr	= nf_nat_port_range_to_nlattr,
-	.nlattr_to_range	= nf_nat_port_nlattr_to_range,
+	.range_to_nlattr	= nf_nat_proto_range_to_nlattr,
+	.nlattr_to_range	= nf_nat_proto_nlattr_to_range,
 #endif
 };
