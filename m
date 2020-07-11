Return-Path: <SRS0=5odi=AW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B699DC433E4
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 10:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E6AD20725
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 10:20:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgGKKUO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Jul 2020 06:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgGKKUO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Jul 2020 06:20:14 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5EEC08C5DD
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Jul 2020 03:20:14 -0700 (PDT)
Received: from localhost ([::1]:59516 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1juCc8-0007Kf-7i; Sat, 11 Jul 2020 12:20:12 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 02/18] nft: Be lazy when flushing
Date:   Sat, 11 Jul 2020 12:18:15 +0200
Message-Id: <20200711101831.29506-3-phil@nwl.cc>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200711101831.29506-1-phil@nwl.cc>
References: <20200711101831.29506-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If neither chain nor verbose flag was specified and the table to flush
doesn't exist yet, no action is needed (as there is nothing to flush
anyway).

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index c5ab0dbe8d6e7..52ee809b6bc07 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1699,16 +1699,18 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
 	struct nftnl_chain *c = NULL;
 	int ret = 0;
 
-	nft_xt_builtin_init(h, table);
-
 	nft_fn = nft_rule_flush;
 
 	if (chain || verbose) {
+		nft_xt_builtin_init(h, table);
+
 		list = nft_chain_list_get(h, table, chain);
 		if (list == NULL) {
 			ret = 1;
 			goto err;
 		}
+	} else if (!nft_table_find(h, table)) {
+		return 1;
 	}
 
 	if (chain) {
-- 
2.27.0

