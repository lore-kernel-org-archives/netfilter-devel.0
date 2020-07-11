Return-Path: <SRS0=5odi=AW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CA43C433E5
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 10:19:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57763206F4
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 10:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgGKKTE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Jul 2020 06:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbgGKKTD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Jul 2020 06:19:03 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1EFBC08C5DD
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Jul 2020 03:19:03 -0700 (PDT)
Received: from localhost ([::1]:59430 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1juCb0-0007FF-Bu; Sat, 11 Jul 2020 12:19:02 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 03/18] nft: cache: Drop duplicate chain check
Date:   Sat, 11 Jul 2020 12:18:16 +0200
Message-Id: <20200711101831.29506-4-phil@nwl.cc>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200711101831.29506-1-phil@nwl.cc>
References: <20200711101831.29506-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When fetching chains from kernel, checking for duplicate chain names is
not needed: Nftables doesn't support them in the first place. This is
merely a leftover from when multiple cache fetches could happen and so a
bit of sanity checking was in order.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 638b18bc7e382..059f0a7f7891e 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -180,8 +180,8 @@ static int nftnl_chain_list_cb(const struct nlmsghdr *nlh, void *data)
 	const struct builtin_table *t = d->t;
 	struct nftnl_chain_list *list;
 	struct nft_handle *h = d->h;
-	const char *tname, *cname;
 	struct nftnl_chain *c;
+	const char *tname;
 
 	c = nftnl_chain_alloc();
 	if (c == NULL)
@@ -201,11 +201,6 @@ static int nftnl_chain_list_cb(const struct nlmsghdr *nlh, void *data)
 	}
 
 	list = h->cache->table[t->type].chains;
-	cname = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
-
-	if (nftnl_chain_list_lookup_byname(list, cname))
-		goto out;
-
 	nftnl_chain_list_add_tail(c, list);
 
 	return MNL_CB_OK;
-- 
2.27.0

