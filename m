Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37D2BC4338F
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Jul 2021 13:14:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B6B560F5C
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Jul 2021 13:14:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238893AbhG3NOo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Jul 2021 09:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238887AbhG3NOo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Jul 2021 09:14:44 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF59C06175F
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Jul 2021 06:14:39 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1m9SLW-0004NT-AE; Fri, 30 Jul 2021 15:14:38 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/2] netfilter: ctnetlink: allow to filter dump by status bits
Date:   Fri, 30 Jul 2021 15:14:22 +0200
Message-Id: <20210730131422.16958-3-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210730131422.16958-1-fw@strlen.de>
References: <20210730131422.16958-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If CTA_STATUS is present, but CTA_STATUS_MASK is not, then the
mask is automatically set to 'status', so that kernel returns those
entries that have all of the requested bits set.

This makes more sense than using a all-one mask since we'd hardly
ever find a match.

There are no other checks for status bits, so if e.g. userspace
sets impossible combinations it will get an empty dump.

If kernel would reject unknown status bits, then a program that works on
a future kernel that has IPS_FOO bit fails on old kernels.

Same for 'impossible' combinations:

Kernel never sets ASSURED without first having set SEEN_REPLY, but its
possible that a future kernel could do so.

Therefore no sanity tests other than a 0-mask.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../linux/netfilter/nfnetlink_conntrack.h     |  1 +
 net/netfilter/nf_conntrack_netlink.c          | 34 ++++++++++++++++++-
 2 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nfnetlink_conntrack.h b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
index d8484be72fdc..c6e6d7d7d538 100644
--- a/include/uapi/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
@@ -56,6 +56,7 @@ enum ctattr_type {
 	CTA_LABELS_MASK,
 	CTA_SYNPROXY,
 	CTA_FILTER,
+	CTA_STATUS_MASK,
 	__CTA_MAX
 };
 #define CTA_MAX (__CTA_MAX - 1)
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index e8368e66b0f5..eb35c6151fb0 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -868,6 +868,7 @@ struct ctnetlink_filter {
 	struct nf_conntrack_zone zone;
 
 	struct ctnetlink_filter_u32 mark;
+	struct ctnetlink_filter_u32 status;
 };
 
 static const struct nla_policy cta_filter_nla_policy[CTA_FILTER_MAX + 1] = {
@@ -927,6 +928,28 @@ static int ctnetlink_filter_parse_mark(struct ctnetlink_filter_u32 *mark,
 	return 0;
 }
 
+static int ctnetlink_filter_parse_status(struct ctnetlink_filter_u32 *status,
+					 const struct nlattr * const cda[])
+{
+	if (cda[CTA_STATUS]) {
+		status->val = ntohl(nla_get_be32(cda[CTA_STATUS]));
+		if (cda[CTA_STATUS_MASK])
+			status->mask = ntohl(nla_get_be32(cda[CTA_STATUS_MASK]));
+		else
+			status->mask = status->val;
+
+		/* status->val == 0? always true, else always false. */
+		if (status->mask == 0)
+			return -EINVAL;
+	} else if (cda[CTA_STATUS_MASK]) {
+		return -EINVAL;
+	}
+
+	/* CTA_STATUS is NLA_U32, if this fires UAPI needs to be extended */
+	BUILD_BUG_ON(__IPS_MAX_BIT >= 32);
+	return 0;
+}
+
 static struct ctnetlink_filter *
 ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 {
@@ -948,6 +971,10 @@ ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 	if (err)
 		goto err_filter;
 
+	err = ctnetlink_filter_parse_status(&filter->status, cda);
+	if (err)
+		goto err_filter;
+
 	if (!cda[CTA_FILTER])
 		return filter;
 
@@ -1001,7 +1028,7 @@ ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 
 static bool ctnetlink_needs_filter(u8 family, const struct nlattr * const *cda)
 {
-	return family || cda[CTA_MARK] || cda[CTA_FILTER];
+	return family || cda[CTA_MARK] || cda[CTA_FILTER] || cda[CTA_STATUS];
 }
 
 static int ctnetlink_start(struct netlink_callback *cb)
@@ -1094,6 +1121,7 @@ static int ctnetlink_filter_match(struct nf_conn *ct, void *data)
 {
 	struct ctnetlink_filter *filter = data;
 	struct nf_conntrack_tuple *tuple;
+	u32 status;
 
 	if (filter == NULL)
 		goto out;
@@ -1125,6 +1153,9 @@ static int ctnetlink_filter_match(struct nf_conn *ct, void *data)
 	if ((ct->mark & filter->mark.mask) != filter->mark.val)
 		goto ignore_entry;
 #endif
+	status = (u32)READ_ONCE(ct->status);
+	if ((status & filter->status.mask) != filter->status.val)
+		goto ignore_entry;
 
 out:
 	return 1;
@@ -1507,6 +1538,7 @@ static const struct nla_policy ct_nla_policy[CTA_MAX+1] = {
 	[CTA_LABELS_MASK]	= { .type = NLA_BINARY,
 				    .len = NF_CT_LABELS_MAX_SIZE },
 	[CTA_FILTER]		= { .type = NLA_NESTED },
+	[CTA_STATUS_MASK]	= { .type = NLA_U32 },
 };
 
 static int ctnetlink_flush_iterate(struct nf_conn *ct, void *data)
-- 
2.31.1

