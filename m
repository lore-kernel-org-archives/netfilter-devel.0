Return-Path: <SRS0=+tY6=XU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F48DC432C2
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 21:27:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4082F21783
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 21:27:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfIYV1Q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:27:16 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45854 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbfIYV1P (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Sep 2019 17:27:15 -0400
Received: from localhost ([::1]:58944 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iDEoc-0005Fk-BK; Wed, 25 Sep 2019 23:27:14 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 07/24] nft: Support fetch_rule_cache() per chain
Date:   Wed, 25 Sep 2019 23:25:48 +0200
Message-Id: <20190925212605.1005-8-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190925212605.1005-1-phil@nwl.cc>
References: <20190925212605.1005-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Support passing an nftnl_chain to fetch its rules from kernel.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 02da53e60bc83..7c974af8b4141 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1575,10 +1575,13 @@ static int nft_rule_list_update(struct nftnl_chain *c, void *data)
 	return 0;
 }
 
-static int fetch_rule_cache(struct nft_handle *h)
+static int fetch_rule_cache(struct nft_handle *h, struct nftnl_chain *c)
 {
 	int i;
 
+	if (c)
+		return nft_rule_list_update(c, h);
+
 	for (i = 0; i < NFT_TABLE_MAX; i++) {
 		enum nft_table_type type = h->tables[i].type;
 
@@ -1599,7 +1602,7 @@ static void __nft_build_cache(struct nft_handle *h)
 retry:
 	mnl_genid_get(h, &genid_start);
 	fetch_chain_cache(h);
-	fetch_rule_cache(h);
+	fetch_rule_cache(h, NULL);
 	h->have_cache = true;
 	mnl_genid_get(h, &genid_stop);
 
-- 
2.23.0

