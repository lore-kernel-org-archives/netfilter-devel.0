Return-Path: <SRS0=M2Uw=SZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 771C9C10F14
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 13:22:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5074320645
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 13:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbfDWNW0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Apr 2019 09:22:26 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57314 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726421AbfDWNW0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Apr 2019 09:22:26 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hIvNP-0000pP-CF; Tue, 23 Apr 2019 15:22:23 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH xtables-nft 2/6] xtables: add skip flag to objects
Date:   Tue, 23 Apr 2019 15:16:21 +0200
Message-Id: <20190423131625.23377-3-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190423131625.23377-1-fw@strlen.de>
References: <20190423131625.23377-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This will be used to skip transaction objects when committing to
kernel.  This is needed for example when we restore a table that
doesn't exist yet.  In such a case we would already build a flush
operation so we can just enable it when we hit problem with the
generation id and we find that the table/chain was already created
in the mean time.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/nft.c | 49 +++++++++++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 18 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 16d7b7951969..1cef7a13c90d 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -264,7 +264,8 @@ enum obj_action {
 
 struct obj_update {
 	struct list_head	head;
-	enum obj_update_type	type;
+	enum obj_update_type	type:8;
+	uint8_t			skip:1;
 	unsigned int		seq;
 	union {
 		struct nftnl_table	*table;
@@ -342,13 +343,13 @@ static int mnl_append_error(const struct nft_handle *h,
 	return snprintf(buf, len, "%s: %s", errmsg, tcr);
 }
 
-static int batch_add(struct nft_handle *h, enum obj_update_type type, void *ptr)
+static struct obj_update *batch_add(struct nft_handle *h, enum obj_update_type type, void *ptr)
 {
 	struct obj_update *obj;
 
 	obj = calloc(1, sizeof(struct obj_update));
 	if (obj == NULL)
-		return -1;
+		return NULL;
 
 	obj->ptr = ptr;
 	obj->error.lineno = h->error.lineno;
@@ -356,11 +357,12 @@ static int batch_add(struct nft_handle *h, enum obj_update_type type, void *ptr)
 	list_add_tail(&obj->head, &h->obj_list);
 	h->obj_list_num++;
 
-	return 0;
+	return obj;
 }
 
-static int batch_table_add(struct nft_handle *h, enum obj_update_type type,
-			   struct nftnl_table *t)
+static struct obj_update *
+batch_table_add(struct nft_handle *h, enum obj_update_type type,
+		struct nftnl_table *t)
 {
 	return batch_add(h, type, t);
 }
@@ -368,13 +370,13 @@ static int batch_table_add(struct nft_handle *h, enum obj_update_type type,
 static int batch_chain_add(struct nft_handle *h, enum obj_update_type type,
 			   struct nftnl_chain *c)
 {
-	return batch_add(h, type, c);
+	return batch_add(h, type, c) ? 0 : -1;
 }
 
 static int batch_rule_add(struct nft_handle *h, enum obj_update_type type,
 			  struct nftnl_rule *r)
 {
-	return batch_add(h, type, r);
+	return batch_add(h, type, r) ? 0 : -1;
 }
 
 const struct builtin_table xtables_ipv4[NFT_TABLE_MAX] = {
@@ -609,7 +611,7 @@ static int nft_table_builtin_add(struct nft_handle *h,
 
 	nftnl_table_set(t, NFTNL_TABLE_NAME, (char *)_t->name);
 
-	ret = batch_table_add(h, NFT_COMPAT_TABLE_ADD, t);
+	ret = batch_table_add(h, NFT_COMPAT_TABLE_ADD, t) ? 0 : - 1;
 
 	return ret;
 }
@@ -2000,9 +2002,10 @@ int nft_for_each_table(struct nft_handle *h,
 	return 0;
 }
 
-static int __nft_table_flush(struct nft_handle *h, const char *table)
+static int __nft_table_flush(struct nft_handle *h, const char *table, bool exists)
 {
 	const struct builtin_table *_t;
+	struct obj_update *obj;
 	struct nftnl_table *t;
 
 	t = nftnl_table_alloc();
@@ -2011,7 +2014,14 @@ static int __nft_table_flush(struct nft_handle *h, const char *table)
 
 	nftnl_table_set_str(t, NFTNL_TABLE_NAME, table);
 
-	batch_table_add(h, NFT_COMPAT_TABLE_FLUSH, t);
+	obj = batch_table_add(h, NFT_COMPAT_TABLE_FLUSH, t);
+	if (!obj) {
+		nftnl_table_free(t);
+		return -1;
+	}
+
+	if (!exists)
+		obj->skip = 1;
 
 	_t = nft_table_builtin_find(h, table);
 	assert(_t);
@@ -2027,6 +2037,7 @@ int nft_table_flush(struct nft_handle *h, const char *table)
 	struct nftnl_table_list_iter *iter;
 	struct nftnl_table_list *list;
 	struct nftnl_table *t;
+	bool exists = false;
 	int ret = 0;
 
 	nft_fn = nft_table_flush;
@@ -2048,17 +2059,15 @@ int nft_table_flush(struct nft_handle *h, const char *table)
 		const char *table_name =
 			nftnl_table_get_str(t, NFTNL_TABLE_NAME);
 
-		if (strcmp(table_name, table) != 0)
-			goto next;
+		if (strcmp(table_name, table) == 0) {
+			exists = true;
+			break;
+		}
 
-		ret = __nft_table_flush(h, table);
-		if (ret < 0)
-			goto err_table_iter;
-next:
 		t = nftnl_table_list_iter_next(iter);
 	}
 
-err_table_iter:
+	ret = __nft_table_flush(h, table, exists);
 	nftnl_table_list_iter_destroy(iter);
 err_table_list:
 	nftnl_table_list_free(list);
@@ -2658,6 +2667,10 @@ static int nft_action(struct nft_handle *h, int action)
 	mnl_batch_begin(h->batch, seq++);
 
 	list_for_each_entry(n, &h->obj_list, head) {
+
+		if (n->skip)
+			continue;
+
 		n->seq = seq++;
 		switch (n->type) {
 		case NFT_COMPAT_TABLE_ADD:
-- 
2.21.0

