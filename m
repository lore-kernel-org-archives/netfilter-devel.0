Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2426C4320A
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Jul 2021 13:14:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDB1960F6B
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Jul 2021 13:14:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238909AbhG3NOk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Jul 2021 09:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238893AbhG3NOk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Jul 2021 09:14:40 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947E6C06175F
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Jul 2021 06:14:35 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1m9SLS-0004NI-4p; Fri, 30 Jul 2021 15:14:34 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/2] netfilter: ctnetlink: add and use a helper for mark parsing
Date:   Fri, 30 Jul 2021 15:14:21 +0200
Message-Id: <20210730131422.16958-2-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210730131422.16958-1-fw@strlen.de>
References: <20210730131422.16958-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

ctnetlink dumps can be filtered based on the connmark.

Prepare for status bit filtering by using a named structure and by
moving the mark parsing code to a helper.

Else ctnetlink_alloc_filter size grows a bit too big for my taste
when status handling is added.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_netlink.c | 42 ++++++++++++++++++----------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index e81af33b233b..e8368e66b0f5 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -852,6 +852,11 @@ static int ctnetlink_done(struct netlink_callback *cb)
 	return 0;
 }
 
+struct ctnetlink_filter_u32 {
+	u32 val;
+	u32 mask;
+};
+
 struct ctnetlink_filter {
 	u8 family;
 
@@ -862,10 +867,7 @@ struct ctnetlink_filter {
 	struct nf_conntrack_tuple reply;
 	struct nf_conntrack_zone zone;
 
-	struct {
-		u_int32_t val;
-		u_int32_t mask;
-	} mark;
+	struct ctnetlink_filter_u32 mark;
 };
 
 static const struct nla_policy cta_filter_nla_policy[CTA_FILTER_MAX + 1] = {
@@ -907,6 +909,24 @@ static int ctnetlink_parse_tuple_filter(const struct nlattr * const cda[],
 					 struct nf_conntrack_zone *zone,
 					 u_int32_t flags);
 
+static int ctnetlink_filter_parse_mark(struct ctnetlink_filter_u32 *mark,
+				       const struct nlattr * const cda[])
+{
+#ifdef CONFIG_NF_CONNTRACK_MARK
+	if (cda[CTA_MARK]) {
+		mark->val = ntohl(nla_get_be32(cda[CTA_MARK]));
+
+		if (cda[CTA_MARK_MASK])
+			mark->mask = ntohl(nla_get_be32(cda[CTA_MARK_MASK]));
+		else
+			mark->mask = 0xffffffff;
+	} else if (cda[CTA_MARK_MASK]) {
+		return -EINVAL;
+	}
+#endif
+	return 0;
+}
+
 static struct ctnetlink_filter *
 ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 {
@@ -924,18 +944,10 @@ ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 
 	filter->family = family;
 
-#ifdef CONFIG_NF_CONNTRACK_MARK
-	if (cda[CTA_MARK]) {
-		filter->mark.val = ntohl(nla_get_be32(cda[CTA_MARK]));
-		if (cda[CTA_MARK_MASK])
-			filter->mark.mask = ntohl(nla_get_be32(cda[CTA_MARK_MASK]));
-		else
-			filter->mark.mask = 0xffffffff;
-	} else if (cda[CTA_MARK_MASK]) {
-		err = -EINVAL;
+	err = ctnetlink_filter_parse_mark(&filter->mark, cda);
+	if (err)
 		goto err_filter;
-	}
-#endif
+
 	if (!cda[CTA_FILTER])
 		return filter;
 
-- 
2.31.1

