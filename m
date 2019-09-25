Return-Path: <SRS0=+tY6=XU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2FE6C432C2
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 21:28:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C63220673
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 21:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfIYV2L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Sep 2019 17:28:11 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45914 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbfIYV2K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Sep 2019 17:28:10 -0400
Received: from localhost ([::1]:59004 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iDEpV-0005JJ-2z; Wed, 25 Sep 2019 23:28:09 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 06/24] xtables-restore: Minimize caching when flushing
Date:   Wed, 25 Sep 2019 23:25:47 +0200
Message-Id: <20190925212605.1005-7-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190925212605.1005-1-phil@nwl.cc>
References: <20190925212605.1005-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Unless --noflush was given, xtables-restore merely needs the list of
tables to decide whether to delete it or not. Introduce nft_fake_cache()
function which populates table list, initializes chain lists (so
nft_chain_list_get() returns an empty list instead of NULL) and sets
'have_cache' to turn any later calls to nft_build_cache() into nops.

If --noflush was given, call nft_build_cache() just once instead of for
each table line in input.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c             | 17 +++++++++++++++++
 iptables/nft.h             |  1 +
 iptables/xtables-restore.c |  7 +++++--
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 695758831047a..02da53e60bc83 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1611,6 +1611,23 @@ retry:
 	h->nft_genid = genid_start;
 }
 
+void nft_fake_cache(struct nft_handle *h)
+{
+	int i;
+
+	fetch_table_cache(h);
+	for (i = 0; i < NFT_TABLE_MAX; i++) {
+		enum nft_table_type type = h->tables[i].type;
+
+		if (!h->tables[i].name)
+			continue;
+
+		h->cache->table[type].chains = nftnl_chain_list_alloc();
+	}
+	h->have_cache = true;
+	mnl_genid_get(h, &h->nft_genid);
+}
+
 void nft_build_cache(struct nft_handle *h)
 {
 	if (!h->have_cache)
diff --git a/iptables/nft.h b/iptables/nft.h
index 43463d7f262e8..bcac8e228c787 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -73,6 +73,7 @@ int mnl_talk(struct nft_handle *h, struct nlmsghdr *nlh,
 	     void *data);
 int nft_init(struct nft_handle *h, const struct builtin_table *t);
 void nft_fini(struct nft_handle *h);
+void nft_fake_cache(struct nft_handle *h);
 void nft_build_cache(struct nft_handle *h);
 
 /*
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 27e65b971727e..7f28a05c68619 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -96,6 +96,11 @@ void xtables_restore_parse(struct nft_handle *h,
 
 	line = 0;
 
+	if (!h->noflush)
+		nft_fake_cache(h);
+	else
+		nft_build_cache(h);
+
 	/* Grab standard input. */
 	while (fgets(buffer, sizeof(buffer), p->in)) {
 		int ret = 0;
@@ -145,8 +150,6 @@ void xtables_restore_parse(struct nft_handle *h,
 			if (p->tablename && (strcmp(p->tablename, table) != 0))
 				continue;
 
-			nft_build_cache(h);
-
 			if (h->noflush == 0) {
 				DEBUGP("Cleaning all chains of table '%s'\n",
 					table);
-- 
2.23.0

