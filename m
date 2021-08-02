Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4A73C4338F
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Aug 2021 09:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DE76604AC
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Aug 2021 09:12:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbhHBJM4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Aug 2021 05:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbhHBJMz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Aug 2021 05:12:55 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FD6C06175F
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Aug 2021 02:12:46 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mAU05-0002dE-55; Mon, 02 Aug 2021 11:12:45 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH lnf-conntrack 2/4] src: add support for status dump filter
Date:   Mon,  2 Aug 2021 11:12:29 +0200
Message-Id: <20210802091231.1486-3-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210802091231.1486-1-fw@strlen.de>
References: <20210802091231.1486-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This tells kernel to suppress conntrack entries that do not match
the status bits/bitmask filter.

This is useful to e.g. only list entries that are not assured
(value 0, mask == ASSUED) or entries that only saw one-way traffic
(value 0, mask == SEEN_REPLY).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/internal/object.h                       |  1 +
 .../libnetfilter_conntrack.h                    |  5 +++--
 src/conntrack/filter_dump.c                     | 17 +++++++++++++++++
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/internal/object.h b/include/internal/object.h
index 3f6904f16d8b..75ffdbe97229 100644
--- a/include/internal/object.h
+++ b/include/internal/object.h
@@ -287,6 +287,7 @@ struct nfct_filter {
 
 struct nfct_filter_dump {
 	struct nfct_filter_dump_mark	mark;
+	struct nfct_filter_dump_mark	status;
 	uint8_t				l3num;
 	uint32_t			set;
 };
diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack.h b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
index f02d827761a8..6233434cfeb8 100644
--- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
+++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
@@ -137,11 +137,11 @@ enum nf_conntrack_attr {
 	ATTR_HELPER_INFO,			/* variable length */
 	ATTR_CONNLABELS,			/* variable length */
 	ATTR_CONNLABELS_MASK,			/* variable length */
-	ATTR_ORIG_ZONE,				/* u16 bits */
+	ATTR_ORIG_ZONE = 68,			/* u16 bits */
 	ATTR_REPL_ZONE,				/* u16 bits */
 	ATTR_SNAT_IPV6,				/* u128 bits */
 	ATTR_DNAT_IPV6,				/* u128 bits */
-	ATTR_SYNPROXY_ISN,			/* u32 bits */
+	ATTR_SYNPROXY_ISN = 72,			/* u32 bits */
 	ATTR_SYNPROXY_ITS,			/* u32 bits */
 	ATTR_SYNPROXY_TSOFF,			/* u32 bits */
 	ATTR_MAX
@@ -546,6 +546,7 @@ struct nfct_filter_dump_mark {
 enum nfct_filter_dump_attr {
 	NFCT_FILTER_DUMP_MARK = 0,	/* struct nfct_filter_dump_mark */
 	NFCT_FILTER_DUMP_L3NUM,		/* uint8_t */
+	NFCT_FILTER_DUMP_STATUS,	/* struct nfct_filter_dump_mark */
 	NFCT_FILTER_DUMP_MAX
 };
 
diff --git a/src/conntrack/filter_dump.c b/src/conntrack/filter_dump.c
index 158b4cb1155d..3894d0638a72 100644
--- a/src/conntrack/filter_dump.c
+++ b/src/conntrack/filter_dump.c
@@ -19,6 +19,16 @@ set_filter_dump_attr_mark(struct nfct_filter_dump *filter_dump,
 	filter_dump->mark.mask = this->mask;
 }
 
+static void
+set_filter_dump_attr_status(struct nfct_filter_dump *filter_dump,
+			    const void *value)
+{
+	const struct nfct_filter_dump_mark *this = value;
+
+	filter_dump->status.val = this->val;
+	filter_dump->status.mask = this->mask;
+}
+
 static void
 set_filter_dump_attr_family(struct nfct_filter_dump *filter_dump,
 			    const void *value)
@@ -29,6 +39,7 @@ set_filter_dump_attr_family(struct nfct_filter_dump *filter_dump,
 const set_filter_dump_attr set_filter_dump_attr_array[NFCT_FILTER_DUMP_MAX] = {
 	[NFCT_FILTER_DUMP_MARK]		= set_filter_dump_attr_mark,
 	[NFCT_FILTER_DUMP_L3NUM]	= set_filter_dump_attr_family,
+	[NFCT_FILTER_DUMP_STATUS]	= set_filter_dump_attr_status,
 };
 
 void __build_filter_dump(struct nfnlhdr *req, size_t size,
@@ -44,4 +55,10 @@ void __build_filter_dump(struct nfnlhdr *req, size_t size,
 		struct nfgenmsg *nfg = NLMSG_DATA(&req->nlh);
 		nfg->nfgen_family = filter_dump->l3num;
 	}
+	if (filter_dump->set & (1 << NFCT_FILTER_DUMP_STATUS)) {
+		nfnl_addattr32(&req->nlh, size, CTA_STATUS,
+				htonl(filter_dump->status.val));
+		nfnl_addattr32(&req->nlh, size, CTA_STATUS_MASK,
+				htonl(filter_dump->status.mask));
+	}
 }
-- 
2.31.1

