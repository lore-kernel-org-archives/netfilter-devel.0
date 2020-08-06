Return-Path: <SRS0=eBSQ=BQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B53C7C433E0
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Aug 2020 17:14:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23E7B23119
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Aug 2020 17:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730120AbgHFRO0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Aug 2020 13:14:26 -0400
Received: from correo.us.es ([193.147.175.20]:58578 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730052AbgHFRJ4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Aug 2020 13:09:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EAAE2FB441
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Aug 2020 13:21:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DC375DA722
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Aug 2020 13:21:47 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D1C2BDA73F; Thu,  6 Aug 2020 13:21:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A109BDA722
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Aug 2020 13:21:45 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 06 Aug 2020 13:21:45 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (120.205.137.78.rev.vodafone.pt [78.137.205.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 2AD4C4265A2F
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Aug 2020 13:21:45 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: cache gets out of sync in interactive mode
Date:   Thu,  6 Aug 2020 13:21:39 +0200
Message-Id: <20200806112139.1977-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since 94a945ffa81b ("libnftables: Get rid of explicit cache flushes"),
the cache logic checks for the generation number to refresh the cache.

This breaks interactive mode when listing stateful objects though. This
patch adds a new flag to force a cache refresh when the user requests a
ruleset listing.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/cache.h | 1 +
 src/cache.c     | 2 ++
 src/rule.c      | 8 +++++++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/cache.h b/include/cache.h
index 86a7eff78055..213a6eaf9104 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -30,6 +30,7 @@ enum cache_level_flags {
 				  NFT_CACHE_CHAIN_BIT |
 				  NFT_CACHE_RULE_BIT,
 	NFT_CACHE_FULL		= __NFT_CACHE_MAX_BIT - 1,
+	NFT_CACHE_REFRESH	= (1 << 29),
 	NFT_CACHE_UPDATE	= (1 << 30),
 	NFT_CACHE_FLUSHED	= (1 << 31),
 };
diff --git a/src/cache.c b/src/cache.c
index a45111a7920e..7797ff6b0460 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -143,6 +143,8 @@ unsigned int cache_evaluate(struct nft_ctx *nft, struct list_head *cmds)
 			break;
 		case CMD_LIST:
 		case CMD_EXPORT:
+			flags |= NFT_CACHE_FULL | NFT_CACHE_REFRESH;
+			break;
 		case CMD_MONITOR:
 			flags |= NFT_CACHE_FULL;
 			break;
diff --git a/src/rule.c b/src/rule.c
index 6335aa2189ad..8dc1792b4e5a 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -237,6 +237,11 @@ static bool cache_is_complete(struct nft_cache *cache, unsigned int flags)
 	return (cache->flags & flags) == flags;
 }
 
+static bool cache_needs_refresh(struct nft_cache *cache)
+{
+	return cache->flags & NFT_CACHE_REFRESH;
+}
+
 static bool cache_is_updated(struct nft_cache *cache, uint16_t genid)
 {
 	return genid && genid == cache->genid;
@@ -261,7 +266,8 @@ int cache_update(struct nft_ctx *nft, unsigned int flags, struct list_head *msgs
 replay:
 	ctx.seqnum = cache->seqnum++;
 	genid = mnl_genid_get(&ctx);
-	if (cache_is_complete(cache, flags) &&
+	if (!cache_needs_refresh(cache) &&
+	    cache_is_complete(cache, flags) &&
 	    cache_is_updated(cache, genid))
 		return 0;
 
-- 
2.20.1

