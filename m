Return-Path: <SRS0=ghWo=UD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A9E7C28CC3
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Jun 2019 17:32:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4ED7F208E3
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Jun 2019 17:32:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfFDRcM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Jun 2019 13:32:12 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:56446 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726238AbfFDRcL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Jun 2019 13:32:11 -0400
Received: from localhost ([::1]:41304 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hYDIA-0000kx-Cc; Tue, 04 Jun 2019 19:32:10 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: [nft PATCH v5 01/10] src: Fix cache_flush() in cache_needs_more() logic
Date:   Tue,  4 Jun 2019 19:31:49 +0200
Message-Id: <20190604173158.1184-2-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190604173158.1184-1-phil@nwl.cc>
References: <20190604173158.1184-1-phil@nwl.cc>
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

While being at it, set cache->cmd in cache_release() as well. This
shouldn't be necessary since zeroing cache->genid should suffice for
cache_update(), but better be consistent (and future-proof) here.

Fixes: 34a20645d54fa ("src: update cache if cmd is more specific")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/rule.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/rule.c b/src/rule.c
index 326edb5dd459a..966948cd7ae90 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -299,12 +299,15 @@ void cache_flush(struct nft_ctx *nft, enum cmd_ops cmd, struct list_head *msgs)
 
 	__cache_flush(&cache->list);
 	cache->genid = mnl_genid_get(&ctx);
+	cache->cmd = CMD_LIST;
 }
 
 void cache_release(struct nft_cache *cache)
 {
 	__cache_flush(&cache->list);
 	cache->genid = 0;
+	cache->cmd = CMD_INVALID;
+
 }
 
 /* internal ID to uniquely identify a set in the batch */
-- 
2.21.0

