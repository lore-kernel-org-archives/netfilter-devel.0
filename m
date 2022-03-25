Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E61AC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Mar 2022 10:50:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241781AbiCYKvt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Mar 2022 06:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352220AbiCYKvq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Mar 2022 06:51:46 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14FE2369C0
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Mar 2022 03:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HkrW2kMcsPQ2aIowPqzq4BuxaSAUVQZN9sNO5jQ9kGk=; b=JSU0XXWIGS7g/92vpZ1Vnm9XlU
        NuQpNsKkfZSCW8QmQK9CdRm9W5fxt0q37sFWFtEC8QZeIymDlZ5++Tt6PNltL+vkn6A8yy8B6Czxy
        a5NE8IXkRzTR5dBtR41uJtUSPGueZdaiY1hVmz8zR66aORaki3jRyC4ABvBdJrDn93LxnedoL6+3m
        y7V1KVtU52vdSC3lV0/GhD0DGSQIJLNOb0pL4Zh/vxDtnCU3tAYuT+mCQVPPqG9mVGaw+dNXQoAjq
        Fp8t1MwNR50qWOWUtCa8SgtU9+QRAkSgyJc2uE6gSSxL84qm856BgNjvWBBSeqJ6F2XufaQywbcB9
        lglYL6vw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nXhW8-0007y0-Ej; Fri, 25 Mar 2022 11:50:04 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [conntrack-tools PATCH 2/8] cache: Fix features array allocation
Date:   Fri, 25 Mar 2022 11:49:57 +0100
Message-Id: <20220325105003.26621-3-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220325105003.26621-1-phil@nwl.cc>
References: <20220325105003.26621-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

struct cache::features is of type struct cache_feature **, allocate and
populate accordingly.

Fixes: ad31f852c3454 ("initial import of the conntrack daemon to Netfilter SVN")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/cache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/cache.c b/src/cache.c
index 79a024f8b6bb0..9bc8d0f5bf34a 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -69,12 +69,12 @@ struct cache *cache_create(const char *name, enum cache_type type,
 
 	memcpy(c->feature_type, feature_type, sizeof(feature_type));
 
-	c->features = malloc(sizeof(struct cache_feature) * j);
+	c->features = malloc(sizeof(struct cache_feature *) * j);
 	if (!c->features) {
 		free(c);
 		return NULL;
 	}
-	memcpy(c->features, feature_array, sizeof(struct cache_feature) * j);
+	memcpy(c->features, feature_array, sizeof(struct cache_feature *) * j);
 	c->num_features = j;
 
 	c->extra_offset = size;
-- 
2.34.1

