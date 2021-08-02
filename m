Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03D9BC4338F
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Aug 2021 09:12:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7E8960FC1
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Aug 2021 09:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbhHBJMw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Aug 2021 05:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbhHBJMv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Aug 2021 05:12:51 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F9AC06175F
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Aug 2021 02:12:42 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mAU00-0002cu-VS; Mon, 02 Aug 2021 11:12:41 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH lnf-conntrack 1/4] include: sync uapi header with nf-next
Date:   Mon,  2 Aug 2021 11:12:28 +0200
Message-Id: <20210802091231.1486-2-fw@strlen.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210802091231.1486-1-fw@strlen.de>
References: <20210802091231.1486-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../linux_nfnetlink_conntrack.h               | 24 +++++++++++++++----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h b/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
index 0e9af6c1ebd7..6c8de4eb7472 100644
--- a/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
+++ b/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
@@ -58,6 +58,8 @@ enum ctattr_type {
 	CTA_LABELS,
 	CTA_LABELS_MASK,
 	CTA_SYNPROXY,
+	CTA_FILTER,
+	CTA_STATUS_MASK,
 	__CTA_MAX
 };
 #define CTA_MAX (__CTA_MAX - 1)
@@ -121,6 +123,7 @@ enum ctattr_protoinfo_dccp {
 	CTA_PROTOINFO_DCCP_STATE,
 	CTA_PROTOINFO_DCCP_ROLE,
 	CTA_PROTOINFO_DCCP_HANDSHAKE_SEQ,
+	CTA_PROTOINFO_DCCP_PAD,
 	__CTA_PROTOINFO_DCCP_MAX,
 };
 #define CTA_PROTOINFO_DCCP_MAX (__CTA_PROTOINFO_DCCP_MAX - 1)
@@ -140,6 +143,7 @@ enum ctattr_counters {
 	CTA_COUNTERS_BYTES,		/* 64bit counters */
 	CTA_COUNTERS32_PACKETS,		/* old 32bit counters, unused */
 	CTA_COUNTERS32_BYTES,		/* old 32bit counters, unused */
+	CTA_COUNTERS_PAD,
 	__CTA_COUNTERS_MAX
 };
 #define CTA_COUNTERS_MAX (__CTA_COUNTERS_MAX - 1)
@@ -148,6 +152,7 @@ enum ctattr_tstamp {
 	CTA_TIMESTAMP_UNSPEC,
 	CTA_TIMESTAMP_START,
 	CTA_TIMESTAMP_STOP,
+	CTA_TIMESTAMP_PAD,
 	__CTA_TIMESTAMP_MAX
 };
 #define CTA_TIMESTAMP_MAX (__CTA_TIMESTAMP_MAX - 1)
@@ -242,13 +247,13 @@ enum ctattr_secctx {
 
 enum ctattr_stats_cpu {
 	CTA_STATS_UNSPEC,
-	CTA_STATS_SEARCHED,
+	CTA_STATS_SEARCHED,	/* no longer used */
 	CTA_STATS_FOUND,
-	CTA_STATS_NEW,
+	CTA_STATS_NEW,		/* no longer used */
 	CTA_STATS_INVALID,
-	CTA_STATS_IGNORE,
-	CTA_STATS_DELETE,
-	CTA_STATS_DELETE_LIST,
+	CTA_STATS_IGNORE,	/* no longer used */
+	CTA_STATS_DELETE,	/* no longer used */
+	CTA_STATS_DELETE_LIST,	/* no longer used */
 	CTA_STATS_INSERT,
 	CTA_STATS_INSERT_FAILED,
 	CTA_STATS_DROP,
@@ -263,6 +268,7 @@ enum ctattr_stats_cpu {
 enum ctattr_stats_global {
 	CTA_STATS_GLOBAL_UNSPEC,
 	CTA_STATS_GLOBAL_ENTRIES,
+	CTA_STATS_GLOBAL_MAX_ENTRIES,
 	__CTA_STATS_GLOBAL_MAX,
 };
 #define CTA_STATS_GLOBAL_MAX (__CTA_STATS_GLOBAL_MAX - 1)
@@ -276,6 +282,14 @@ enum ctattr_expect_stats {
 };
 #define CTA_STATS_EXP_MAX (__CTA_STATS_EXP_MAX - 1)
 
+enum ctattr_filter {
+	CTA_FILTER_UNSPEC,
+	CTA_FILTER_ORIG_FLAGS,
+	CTA_FILTER_REPLY_FLAGS,
+	__CTA_FILTER_MAX
+};
+#define CTA_FILTER_MAX (__CTA_FILTER_MAX - 1)
+
 #ifdef __cplusplus
 }
 #endif
-- 
2.31.1

