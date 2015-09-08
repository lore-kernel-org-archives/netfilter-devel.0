From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC 1/3] netfilter: ctnetlink: remove ctnetlink_nfqueue_build_size()
Date: Tue,  8 Sep 2015 18:54:49 +0200
Message-ID: <1441731291-21342-2-git-send-email-pablo@netfilter.org>
References: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
Cc: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37662 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755142AbbIHQsY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Sep 2015 12:48:24 -0400
In-Reply-To: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Factor out code from netlink_nlmsg_size() to consolidate ctnetlink message size
calculation. Don't inline these functions so the compiler decides for us.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c |   42 ++++++++--------------------------
 1 file changed, 9 insertions(+), 33 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 94a6654..5fd3d48 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -596,11 +596,9 @@ ctnetlink_timestamp_size(const struct nf_conn *ct)
 #endif
 }
 
-static inline size_t
-ctnetlink_nlmsg_size(const struct nf_conn *ct)
+static size_t ctnetlink_nlmsg_payload_size(const struct nf_conn *ct)
 {
-	return NLMSG_ALIGN(sizeof(struct nfgenmsg))
-	       + 3 * nla_total_size(0) /* CTA_TUPLE_ORIG|REPL|MASTER */
+	return   3 * nla_total_size(0) /* CTA_TUPLE_ORIG|REPL|MASTER */
 	       + 3 * nla_total_size(0) /* CTA_TUPLE_IP */
 	       + 3 * nla_total_size(0) /* CTA_TUPLE_PROTO */
 	       + 3 * nla_total_size(sizeof(u_int8_t)) /* CTA_PROTO_NUM */
@@ -628,6 +626,12 @@ ctnetlink_nlmsg_size(const struct nf_conn *ct)
 	       ;
 }
 
+static size_t ctnetlink_nlmsg_size(const struct nf_conn *ct)
+{
+	return NLMSG_ALIGN(sizeof(struct nfgenmsg)) +
+	       ctnetlink_nlmsg_payload_size(ct);
+}
+
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 static int
 ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
@@ -2134,34 +2138,6 @@ ctnetlink_alloc_expect(const struct nlattr *const cda[], struct nf_conn *ct,
 		       struct nf_conntrack_tuple *mask);
 
 #ifdef CONFIG_NETFILTER_NETLINK_QUEUE_CT
-static size_t
-ctnetlink_nfqueue_build_size(const struct nf_conn *ct)
-{
-	return 3 * nla_total_size(0) /* CTA_TUPLE_ORIG|REPL|MASTER */
-	       + 3 * nla_total_size(0) /* CTA_TUPLE_IP */
-	       + 3 * nla_total_size(0) /* CTA_TUPLE_PROTO */
-	       + 3 * nla_total_size(sizeof(u_int8_t)) /* CTA_PROTO_NUM */
-	       + nla_total_size(sizeof(u_int32_t)) /* CTA_ID */
-	       + nla_total_size(sizeof(u_int32_t)) /* CTA_STATUS */
-	       + nla_total_size(sizeof(u_int32_t)) /* CTA_TIMEOUT */
-	       + nla_total_size(0) /* CTA_PROTOINFO */
-	       + nla_total_size(0) /* CTA_HELP */
-	       + nla_total_size(NF_CT_HELPER_NAME_LEN) /* CTA_HELP_NAME */
-	       + ctnetlink_secctx_size(ct)
-#ifdef CONFIG_NF_NAT_NEEDED
-	       + 2 * nla_total_size(0) /* CTA_NAT_SEQ_ADJ_ORIG|REPL */
-	       + 6 * nla_total_size(sizeof(u_int32_t)) /* CTA_NAT_SEQ_OFFSET */
-#endif
-#ifdef CONFIG_NF_CONNTRACK_MARK
-	       + nla_total_size(sizeof(u_int32_t)) /* CTA_MARK */
-#endif
-#ifdef CONFIG_NF_CONNTRACK_ZONES
-	       + nla_total_size(sizeof(u_int16_t)) /* CTA_ZONE|CTA_TUPLE_ZONE */
-#endif
-	       + ctnetlink_proto_size(ct)
-	       ;
-}
-
 static int
 ctnetlink_nfqueue_build(struct sk_buff *skb, struct nf_conn *ct)
 {
@@ -2351,7 +2327,7 @@ ctnetlink_nfqueue_attach_expect(const struct nlattr *attr, struct nf_conn *ct,
 }
 
 static struct nfq_ct_hook ctnetlink_nfqueue_hook = {
-	.build_size	= ctnetlink_nfqueue_build_size,
+	.build_size	= ctnetlink_nlmsg_payload_size,
 	.build		= ctnetlink_nfqueue_build,
 	.parse		= ctnetlink_nfqueue_parse,
 	.attach_expect	= ctnetlink_nfqueue_attach_expect,
-- 
1.7.10.4

