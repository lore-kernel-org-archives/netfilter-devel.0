Return-Path: <SRS0=iiCe=TW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 728B2C282DD
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 May 2019 15:30:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E0D120868
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 May 2019 15:30:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729515AbfEVPar (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 May 2019 11:30:47 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:42618 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729495AbfEVPaq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 May 2019 11:30:46 -0400
Received: from localhost ([::1]:55708 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hTTCX-0007zj-8L; Wed, 22 May 2019 17:30:45 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Eric Garver <e@erig.me>, netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/3] src: Fix cache_flush() in cache_needs_more() logic
Date:   Wed, 22 May 2019 17:30:33 +0200
Message-Id: <20190522153035.19806-2-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190522153035.19806-1-phil@nwl.cc>
References: <20190522153035.19806-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Commit 34a20645d54fa enabled cache updates depending on command causing
it. As a side-effect, this disabled measures in cache_flush() preventing
a later cache update. Re-establish this by setting cache->cmd in
addition to cache->genid after dropping cache entries.

Fixes: 34a20645d54fa ("src: update cache if cmd is more specific")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/rule.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/rule.c b/src/rule.c
index 4f015fc5354b7..6bb8b34202b4b 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -365,6 +365,7 @@ void cache_flush(struct nft_ctx *nft, enum cmd_ops cmd, struct list_head *msgs)
 
 	__cache_flush(&cache->list);
 	cache->genid = mnl_genid_get(&ctx);
+	cache->cmd = CMD_LIST;
 }
 
 void cache_release(struct nft_cache *cache)
-- 
2.21.0

