Return-Path: <SRS0=6IYx=TT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09241C04E87
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 May 2019 17:48:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE7C120645
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 May 2019 17:48:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727734AbfESRsd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 May 2019 13:48:33 -0400
Received: from mail.us.es ([193.147.175.20]:42148 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726739AbfESRsd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 May 2019 13:48:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E1BC8C4149
        for <netfilter-devel@vger.kernel.org>; Sun, 19 May 2019 13:51:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D4AA9DA709
        for <netfilter-devel@vger.kernel.org>; Sun, 19 May 2019 13:51:28 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CA655DA707; Sun, 19 May 2019 13:51:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CE31ADA702;
        Sun, 19 May 2019 13:51:26 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 19 May 2019 13:51:26 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A1F364265A32;
        Sun, 19 May 2019 13:51:26 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc, fw@strlen.de
Subject: [PATCH iptables 4/4] nft: keep old cache around until batch is refreshed in case of ERESTART
Date:   Sun, 19 May 2019 13:51:21 +0200
Message-Id: <20190519115121.32490-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190519115121.32490-1-pablo@netfilter.org>
References: <20190519115121.32490-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter says:

"The problem is that data in h->obj_list potentially sits in cache, too.
At least rules have to be there so insert with index works correctly. If
the cache is flushed before regenerating the batch, use-after-free
occurs which crashes the program."

This patch keeps the old cache around until we have refreshed the batch.

Fixes: 862818ac3a0de ("xtables: add and use nft_build_cache")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Phil: I'd like to avoid the refcount infrastructure in libnftnl.

Compile tested-only.

 iptables/nft.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 14141bb7dbcf..51f05b6a6267 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -798,7 +798,10 @@ static int nft_restart(struct nft_handle *h)
 	return 0;
 }
 
-static struct nft_cache cache;
+struct {
+	struct nft_cache 	cache[2];
+	unsigned int		index;
+} pool;
 
 int nft_init(struct nft_handle *h, const struct builtin_table *t)
 {
@@ -813,7 +816,7 @@ int nft_init(struct nft_handle *h, const struct builtin_table *t)
 
 	h->portid = mnl_socket_get_portid(h->nl);
 	h->tables = t;
-	h->cache = &cache;
+	h->cache = &pool.cache[0];
 
 	INIT_LIST_HEAD(&h->obj_list);
 	INIT_LIST_HEAD(&h->err_list);
@@ -1555,12 +1558,25 @@ void nft_build_cache(struct nft_handle *h)
 		__nft_build_cache(h);
 }
 
-static void nft_rebuild_cache(struct nft_handle *h)
+static struct nft_cache *nft_get_cache_next(void)
 {
-	if (!h->have_cache)
-		flush_chain_cache(h, NULL);
+	if (++pool.index > 1)
+		pool.index = 0;
 
+	return &pool.cache[pool.index];
+}
+
+static struct nft_cache *nft_rebuild_cache(struct nft_handle *h)
+{
+	struct nft_cache *cache = NULL;
+
+	if (h->have_cache) {
+		cache = h->cache;
+		h->cache = nft_get_cache_next();
+	}
 	__nft_build_cache(h);
+
+	return cache;
 }
 
 struct nftnl_chain_list *nft_chain_list_get(struct nft_handle *h,
@@ -2902,10 +2918,13 @@ retry:
 	errno = 0;
 	ret = mnl_batch_talk(h->nl, h->batch, &h->err_list);
 	if (ret && errno == ERESTART) {
-		nft_rebuild_cache(h);
+		struct nft_cache *old_cache = nft_rebuild_cache(h);
 
 		nft_refresh_transaction(h);
 
+		if (old_cache)
+			flush_cache(old_cache, h->tables, NULL);
+
 		i=0;
 		list_for_each_entry_safe(err, ne, &h->err_list, head)
 			mnl_err_list_free(err);
-- 
2.11.0

