Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D89C61D97
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 21:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344352AbjKVVpE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 16:45:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344326AbjKVVpC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 16:45:02 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 234751A5
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 13:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kxrMuE3iBGMLlD/zKsDtzMnhgyNBOoFgc7/flDisW8c=; b=j1LnEacuh0RTmexGAGqoG6KDRs
        piZdPb1/m6LgCi95RCyNU2iu9X/KUH59H1Whd6icFkXEQ3IVbz0w8p7Rf/lGp2US8ygSNme1+p6wK
        G3Hj6U1eo0i2/5QKu+/gE6OI9qXNj2W+WnT/yGQYnkg0UM7Aau/wDFKOw1Tpwuf12y4x+8JhlB5aq
        a7gzwxcSH7TZg+3qzuDVek1hO0FlvADaPcMJCeOitEJ5+0CROCV3cN3zbXWAu81QSCe9SoxSu/5bh
        uoQlTgFevJMcz3A4y5LgVf82bOkmEXyn3K/t/V2LXCgkdioWU31hgocg9lRTfIkJ69zYCyx0icpSQ
        sqK9jOMw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1r5v1k-0003hf-6z
        for netfilter-devel@vger.kernel.org; Wed, 22 Nov 2023 22:44:56 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 4/6] libxtables: Introduce struct xt_option_entry::base
Date:   Wed, 22 Nov 2023 22:52:59 +0100
Message-ID: <20231122215301.15725-5-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231122215301.15725-1-phil@nwl.cc>
References: <20231122215301.15725-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Enable guided option parser users to parse integer values with a fixed
base.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/xtables.h      | 3 ++-
 libxtables/xtoptions.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/xtables.h b/include/xtables.h
index 1a9e08bb131ab..b3c45c981b1c7 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -122,6 +122,7 @@ enum xt_option_flags {
  * @size:	size of the item pointed to by @ptroff; this is a safeguard
  * @min:	lowest allowed value (for singular integral types)
  * @max:	highest allowed value (for singular integral types)
+ * @base:	assumed base of parsed value for integer types (default 0)
  */
 struct xt_option_entry {
 	const char *name;
@@ -129,7 +130,7 @@ struct xt_option_entry {
 	unsigned int id, excl, also, flags;
 	unsigned int ptroff;
 	size_t size;
-	unsigned int min, max;
+	unsigned int min, max, base;
 };
 
 /**
diff --git a/libxtables/xtoptions.c b/libxtables/xtoptions.c
index 25540f8b88c6d..4fd0e70e6b555 100644
--- a/libxtables/xtoptions.c
+++ b/libxtables/xtoptions.c
@@ -161,7 +161,8 @@ static void xtopt_parse_int(struct xt_option_call *cb)
 	if (cb->entry->max != 0)
 		lmax = cb->entry->max;
 
-	if (!xtables_strtoul(cb->arg, NULL, &value, lmin, lmax))
+	if (!xtables_strtoul_base(cb->arg, NULL, &value,
+				  lmin, lmax, cb->entry->base))
 		xt_params->exit_err(PARAMETER_PROBLEM,
 			"%s: bad value for option \"--%s\", "
 			"or out of range (%ju-%ju).\n",
-- 
2.41.0

