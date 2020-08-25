Return-Path: <SRS0=A2+c=CD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5A95C433DF
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Aug 2020 22:54:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FBAF2075F
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Aug 2020 22:54:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgHYWyB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Aug 2020 18:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbgHYWyB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Aug 2020 18:54:01 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28472C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Aug 2020 15:54:01 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kAhpE-00066M-Nd; Wed, 26 Aug 2020 00:53:57 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH conntrack-tools] conntrack: add support for CLASH_RESOLVED counter
Date:   Wed, 26 Aug 2020 00:53:51 +0200
Message-Id: <20200825225351.8631-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

While at it, also allow to display up to 4 counters that are sent
by kernel but that we do not know.

This is useful to list counters that a new kernel supports with
and older release of conntrack-tools.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/conntrack.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index fb4e5be86ed8..a26fa60bbbc9 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -1986,11 +1986,13 @@ static int nfct_stats_attr_cb(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
+#define UNKNOWN_STATS_NUM 4
+
 static int nfct_stats_cb(const struct nlmsghdr *nlh, void *data)
 {
-	struct nlattr *tb[CTA_STATS_MAX+1] = {};
+	struct nlattr *tb[CTA_STATS_MAX + UNKNOWN_STATS_NUM + 1] = {};
 	struct nfgenmsg *nfg = mnl_nlmsg_get_payload(nlh);
-	const char *attr2name[CTA_STATS_MAX+1] = {
+	const char *attr2name[CTA_STATS_MAX + UNKNOWN_STATS_NUM + 1] = {
 		[CTA_STATS_SEARCHED]	= "searched",
 		[CTA_STATS_FOUND]	= "found",
 		[CTA_STATS_NEW]		= "new",
@@ -2004,6 +2006,15 @@ static int nfct_stats_cb(const struct nlmsghdr *nlh, void *data)
 		[CTA_STATS_EARLY_DROP]	= "early_drop",
 		[CTA_STATS_ERROR]	= "error",
 		[CTA_STATS_SEARCH_RESTART] = "search_restart",
+		[CTA_STATS_CLASH_RESOLVE] = "clash_resolve",
+
+		/* leave at end.  Allows to show counters supported
+		 * by newer kernel with older conntrack-tools release.
+		 */
+		[CTA_STATS_MAX + 1] = "unknown1",
+		[CTA_STATS_MAX + 2] = "unknown2",
+		[CTA_STATS_MAX + 3] = "unknown3",
+		[CTA_STATS_MAX + 4] = "unknown4",
 	};
 	int i;
 
@@ -2011,7 +2022,7 @@ static int nfct_stats_cb(const struct nlmsghdr *nlh, void *data)
 
 	printf("cpu=%-4u\t", ntohs(nfg->res_id));
 
-	for (i=0; i<CTA_STATS_MAX+1; i++) {
+	for (i=0; i <= CTA_STATS_MAX + UNKNOWN_STATS_NUM; i++) {
 		if (tb[i]) {
 			printf("%s=%u ",
 				attr2name[i], ntohl(mnl_attr_get_u32(tb[i])));
-- 
2.26.2

