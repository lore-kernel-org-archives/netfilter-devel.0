Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80F25C432C3
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Jan 2021 22:40:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53D40230FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Jan 2021 22:40:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732773AbhASOhZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Jan 2021 09:37:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732638AbhASJXO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Jan 2021 04:23:14 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8976FC06179F
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Jan 2021 01:21:56 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1l1nD0-0006sX-Gh; Tue, 19 Jan 2021 10:21:54 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: ctnetlink: remove get_ct indirection
Date:   Tue, 19 Jan 2021 10:21:14 +0100
Message-Id: <20210119092114.29786-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use nf_ct_get() directly, its a small inline helper without dependencies.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter.h            | 2 --
 net/netfilter/nf_conntrack_netlink.c | 7 -------
 net/netfilter/nfnetlink_log.c        | 6 +++++-
 net/netfilter/nfnetlink_queue.c      | 4 ++--
 4 files changed, 7 insertions(+), 12 deletions(-)

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
index b35e8d9a5b37..4a7f1d122e58 100644
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
@@ -736,7 +740,7 @@ nfulnl_log_packet(struct net *net,
 	if (inst->flags & NFULNL_CFG_F_CONNTRACK) {
 		nfnl_ct = rcu_dereference(nfnl_ct_hook);
 		if (nfnl_ct != NULL) {
-			ct = nfnl_ct->get_ct(skb, &ctinfo);
+			ct = nf_ct_get(skb, &ctinfo);
 			if (ct != NULL)
 				size += nfnl_ct->build_size(ct);
 		}
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index d1d8bca03b4f..a8bb23881ab3 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -446,7 +446,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 
 	if (queue->flags & NFQA_CFG_F_CONNTRACK) {
 		if (nfnl_ct != NULL) {
-			ct = nfnl_ct->get_ct(entskb, &ctinfo);
+			ct = nf_ct_get(entskb, &ctinfo);
 			if (ct != NULL)
 				size += nfnl_ct->build_size(ct);
 		}
@@ -1106,7 +1106,7 @@ static struct nf_conn *nfqnl_ct_parse(struct nfnl_ct_hook *nfnl_ct,
 {
 	struct nf_conn *ct;
 
-	ct = nfnl_ct->get_ct(entry->skb, ctinfo);
+	ct = nf_ct_get(entry->skb, ctinfo);
 	if (ct == NULL)
 		return NULL;
 
-- 
2.26.2

