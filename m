Return-Path: <SRS0=EuAs=XL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3861DC49ED7
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 16:50:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0994A206C2
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 16:50:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390257AbfIPQu6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Sep 2019 12:50:58 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:51202 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729084AbfIPQu6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Sep 2019 12:50:58 -0400
Received: from localhost ([::1]:36060 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1i9uDI-0003pq-TR; Mon, 16 Sep 2019 18:50:56 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 05/14] nft: Introduce nft_bridge_commit()
Date:   Mon, 16 Sep 2019 18:49:51 +0200
Message-Id: <20190916165000.18217-6-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190916165000.18217-1-phil@nwl.cc>
References: <20190916165000.18217-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No need to check family value from nft_commit() if we can have a
dedicated callback for bridge family.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c                   | 8 ++++++--
 iptables/nft.h                   | 1 +
 iptables/xtables-eb-standalone.c | 2 +-
 iptables/xtables-restore.c       | 2 +-
 4 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 81d01310c7f8c..77ebc4f651e15 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -3069,11 +3069,15 @@ static void nft_bridge_commit_prepare(struct nft_handle *h)
 
 int nft_commit(struct nft_handle *h)
 {
-	if (h->family == NFPROTO_BRIDGE)
-		nft_bridge_commit_prepare(h);
 	return nft_action(h, NFT_COMPAT_COMMIT);
 }
 
+int nft_bridge_commit(struct nft_handle *h)
+{
+	nft_bridge_commit_prepare(h);
+	return nft_commit(h);
+}
+
 int nft_abort(struct nft_handle *h)
 {
 	return nft_action(h, NFT_COMPAT_ABORT);
diff --git a/iptables/nft.h b/iptables/nft.h
index 5e5e765b0d043..43463d7f262e8 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -147,6 +147,7 @@ uint32_t nft_invflags2cmp(uint32_t invflags, uint32_t flag);
  * global commit and abort
  */
 int nft_commit(struct nft_handle *h);
+int nft_bridge_commit(struct nft_handle *h);
 int nft_abort(struct nft_handle *h);
 int nft_abort_policy_rule(struct nft_handle *h, const char *table);
 
diff --git a/iptables/xtables-eb-standalone.c b/iptables/xtables-eb-standalone.c
index fb3daba0bd604..a9081c78c3bc3 100644
--- a/iptables/xtables-eb-standalone.c
+++ b/iptables/xtables-eb-standalone.c
@@ -51,7 +51,7 @@ int xtables_eb_main(int argc, char *argv[])
 
 	ret = do_commandeb(&h, argc, argv, &table, false);
 	if (ret)
-		ret = nft_commit(&h);
+		ret = nft_bridge_commit(&h);
 
 	if (!ret)
 		fprintf(stderr, "ebtables: %s\n", nft_strerror(errno));
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 601c842feab38..f930f5ba2d167 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -463,7 +463,7 @@ static int ebt_table_flush(struct nft_handle *h, const char *table)
 
 struct nft_xt_restore_cb ebt_restore_cb = {
 	.chain_list	= get_chain_list,
-	.commit		= nft_commit,
+	.commit		= nft_bridge_commit,
 	.table_new	= nft_table_new,
 	.table_flush	= ebt_table_flush,
 	.do_command	= do_commandeb,
-- 
2.23.0

