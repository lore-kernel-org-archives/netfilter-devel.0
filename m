Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D2A0C4332B
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Jan 2021 15:33:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C34B23381
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Jan 2021 15:33:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732697AbhATPcB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Jan 2021 10:32:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390862AbhATPav (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Jan 2021 10:30:51 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3EEC061757
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Jan 2021 07:30:10 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1l2FQv-0006TR-DH; Wed, 20 Jan 2021 16:30:09 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2] netfilter: ctnetlink: remove get_ct indirection
Date:   Wed, 20 Jan 2021 16:30:03 +0100
Message-Id: <20210120153003.26111-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use nf_ct_get() directly, its a small inline helper without dependencies.

Add CONFIG_NF_CONNTRACK guards to elide the relevant part when conntrack
isn't available at all.

v2: add ifdef guard around nf_ct_get call (kernel test robot)
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter.h            |  2 --
 net/netfilter/nf_conntrack_netlink.c |  7 -------
 net/netfilter/nfnetlink_log.c        |  8 +++++++-
 net/netfilter/nfnetlink_queue.c      | 10 ++++++++--
 4 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 0101747de549..f0f3a8354c3c 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -463,8 +463,6 @@ extern struct nf_ct_hook __rcu *nf_ct_hook;
 struct nlattr;
 
 struct nfnl_ct_hook {
-	struct nf_conn *(*get_ct)(const struct sk_buff *skb,
-				  enum ip_conntrack_info *ctinfo);
 	size_t (*build_size)(const struct nf_conn *ct);
 	int (*build)(struct sk_buff *skb, struct nf_conn *ct,
 		     enum ip_conntrack_info ctinfo,
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 84caf3316946..1469365bac7e 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2686,12 +2686,6 @@ ctnetlink_glue_build_size(const struct nf_conn *ct)
 	       ;
 }
 
-static struct nf_conn *ctnetlink_glue_get_ct(const struct sk_buff *skb,
-					     enum ip_conntrack_info *ctinfo)
-{
-	return nf_ct_get(skb, ctinfo);
-}
-
 static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 {
 	const struct nf_conntrack_zone *zone;
@@ -2925,7 +2919,6 @@ static void ctnetlink_glue_seqadj(struct sk_buff *skb, struct nf_conn *ct,
 }
 
 static struct nfnl_ct_hook ctnetlink_glue_hook = {
-	.get_ct		= ctnetlink_glue_get_ct,
 	.build_size	= ctnetlink_glue_build_size,
 	.build		= ctnetlink_glue_build,
 	.parse		= ctnetlink_glue_parse,
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index b35e8d9a5b37..26776b88a539 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -43,6 +43,10 @@
 #include "../bridge/br_private.h"
 #endif
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+#include <net/netfilter/nf_conntrack.h>
+#endif
+
 #define NFULNL_COPY_DISABLED	0xff
 #define NFULNL_NLBUFSIZ_DEFAULT	NLMSG_GOODSIZE
 #define NFULNL_TIMEOUT_DEFAULT 	100	/* every second */
@@ -733,14 +737,16 @@ nfulnl_log_packet(struct net *net,
 		size += nla_total_size(sizeof(u_int32_t));
 	if (inst->flags & NFULNL_CFG_F_SEQ_GLOBAL)
 		size += nla_total_size(sizeof(u_int32_t));
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	if (inst->flags & NFULNL_CFG_F_CONNTRACK) {
 		nfnl_ct = rcu_dereference(nfnl_ct_hook);
 		if (nfnl_ct != NULL) {
-			ct = nfnl_ct->get_ct(skb, &ctinfo);
+			ct = nf_ct_get(skb, &ctinfo);
 			if (ct != NULL)
 				size += nfnl_ct->build_size(ct);
 		}
 	}
+#endif
 	if (pf == NFPROTO_NETDEV || pf == NFPROTO_BRIDGE)
 		size += nfulnl_get_bridge_size(skb);
 
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index d1d8bca03b4f..48a07914fd94 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -444,13 +444,15 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 
 	nfnl_ct = rcu_dereference(nfnl_ct_hook);
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	if (queue->flags & NFQA_CFG_F_CONNTRACK) {
 		if (nfnl_ct != NULL) {
-			ct = nfnl_ct->get_ct(entskb, &ctinfo);
+			ct = nf_ct_get(entskb, &ctinfo);
 			if (ct != NULL)
 				size += nfnl_ct->build_size(ct);
 		}
 	}
+#endif
 
 	if (queue->flags & NFQA_CFG_F_UID_GID) {
 		size += (nla_total_size(sizeof(u_int32_t))	/* uid */
@@ -1104,9 +1106,10 @@ static struct nf_conn *nfqnl_ct_parse(struct nfnl_ct_hook *nfnl_ct,
 				      struct nf_queue_entry *entry,
 				      enum ip_conntrack_info *ctinfo)
 {
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	struct nf_conn *ct;
 
-	ct = nfnl_ct->get_ct(entry->skb, ctinfo);
+	ct = nf_ct_get(entry->skb, ctinfo);
 	if (ct == NULL)
 		return NULL;
 
@@ -1118,6 +1121,9 @@ static struct nf_conn *nfqnl_ct_parse(struct nfnl_ct_hook *nfnl_ct,
 				      NETLINK_CB(entry->skb).portid,
 				      nlmsg_report(nlh));
 	return ct;
+#else
+	return NULL;
+#endif
 }
 
 static int nfqa_parse_bridge(struct nf_queue_entry *entry,
-- 
2.26.2

