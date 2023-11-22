Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8559C61DA7
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 21:45:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344312AbjKVVpF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 16:45:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344379AbjKVVpD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 16:45:03 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EDAEA9
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 13:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=a7dnBRgKsRt3OHYJlROxvHWcMlmyZCQvqB8kJkzxIqQ=; b=lyJ0ZBmW1xZ9bsF3eCNtmAAdrI
        /VH+O3SHrIJr92y7UgI8T3TqcKfzJPgSi7Xr+Ynsazaaau9LX2xsLkr/CRthV56I3rnWSnkJ/TbL0
        gbFJICrnhrfNovUZRX4N4dbWF3AOz6UPgHrXuhsUVoR2f2w24qE4vX6bzhvBTRsUra/neSUTdVb7T
        KUwECnGe0dYXnoy2nTNLf+jpv78zW2OE0e5WC3RAY3jwxnpClH3dKtjkdsTe5hNxnMxbkAx26slgm
        +fmHG/TclaJJavomDals1/CAEwB+zFiBzZ0GJsgeEw8K4eToB2KtP1wNgiWF5s2jJdDrQO9gpyLRc
        Iveixkcg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1r5v1l-0003hy-Gg
        for netfilter-devel@vger.kernel.org; Wed, 22 Nov 2023 22:44:57 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/6] libxtables: Combine the two extension option mergers
Date:   Wed, 22 Nov 2023 22:52:56 +0100
Message-ID: <20231122215301.15725-2-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231122215301.15725-1-phil@nwl.cc>
References: <20231122215301.15725-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

For extending the command parser's struct option array, there is
xtables_merge_options() and xtables_options_xfrm(). Since their bodies
were almost identical, make the latter a wrapper of the former by
transforming the passed struct xt_option_entry array into a temporary
struct option one before handing over.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 libxtables/xtoptions.c | 51 +++++++-----------------------------------
 1 file changed, 8 insertions(+), 43 deletions(-)

diff --git a/libxtables/xtoptions.c b/libxtables/xtoptions.c
index b16bbfbe32311..0667315ceccf8 100644
--- a/libxtables/xtoptions.c
+++ b/libxtables/xtoptions.c
@@ -73,56 +73,21 @@ struct option *
 xtables_options_xfrm(struct option *orig_opts, struct option *oldopts,
 		     const struct xt_option_entry *entry, unsigned int *offset)
 {
-	unsigned int num_orig, num_old = 0, num_new, i;
+	int num_new, i;
 	struct option *merge, *mp;
 
-	if (entry == NULL)
-		return oldopts;
-	for (num_orig = 0; orig_opts[num_orig].name != NULL; ++num_orig)
-		;
-	if (oldopts != NULL)
-		for (num_old = 0; oldopts[num_old].name != NULL; ++num_old)
-			;
 	for (num_new = 0; entry[num_new].name != NULL; ++num_new)
 		;
 
-	/*
-	 * Since @oldopts also has @orig_opts already (and does so at the
-	 * start), skip these entries.
-	 */
-	if (oldopts != NULL) {
-		oldopts += num_orig;
-		num_old -= num_orig;
-	}
-
-	merge = malloc(sizeof(*mp) * (num_orig + num_old + num_new + 1));
-	if (merge == NULL)
-		return NULL;
-
-	/* Let the base options -[ADI...] have precedence over everything */
-	memcpy(merge, orig_opts, sizeof(*mp) * num_orig);
-	mp = merge + num_orig;
-
-	/* Second, the new options */
-	xt_params->option_offset += XT_OPTION_OFFSET_SCALE;
-	*offset = xt_params->option_offset;
-
-	for (i = 0; i < num_new; ++i, ++mp, ++entry) {
-		mp->name         = entry->name;
-		mp->has_arg      = entry->type != XTTYPE_NONE;
-		mp->flag         = NULL;
-		mp->val          = entry->id + *offset;
-	}
-
-	/* Third, the old options */
-	if (oldopts != NULL) {
-		memcpy(mp, oldopts, sizeof(*mp) * num_old);
-		mp += num_old;
+	mp = xtables_calloc(num_new, sizeof(*mp));
+	for (i = 0; i < num_new; i++) {
+		mp[i].name	= entry[i].name;
+		mp[i].has_arg	= entry[i].type != XTTYPE_NONE;
+		mp[i].val	= entry[i].id;
 	}
-	xtables_free_opts(0);
+	merge = xtables_merge_options(orig_opts, oldopts, mp, offset);
 
-	/* Clear trailing entry */
-	memset(mp, 0, sizeof(*mp));
+	free(mp);
 	return merge;
 }
 
-- 
2.41.0

