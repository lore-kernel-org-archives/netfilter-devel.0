Return-Path: <SRS0=M2Uw=SZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC58C10F14
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 13:22:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48ADA20645
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 13:22:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbfDWNWk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Apr 2019 09:22:40 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57326 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726421AbfDWNWk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Apr 2019 09:22:40 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hIvNc-0000q1-P1; Tue, 23 Apr 2019 15:22:36 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH xtables-nft 5/6] xtables: handle concurrent ruleset modifications
Date:   Tue, 23 Apr 2019 15:16:24 +0200
Message-Id: <20190423131625.23377-6-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190423131625.23377-1-fw@strlen.de>
References: <20190423131625.23377-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We currently race when several xtables-nft-restore processes attempt to
handle rules in parallel.  For instance, when no rules are present at
all, then

iptables-nft-restore < X & iptables-nft-restore < X

... can cause rules to be restored twice.

Reason is that both processes might detect 'no rules exist', so
neither issues a flush operation.

We can't unconditionally issue the flush, because it would
cause kernel to fail with -ENOENT unless the to-be-flushed table
exists.

This change passes the generation id that was used to build
the transaction to the kernel.

In case another process changed *any* rule somewhere, the transaction
will now fail with -ERESTART.

We then flush the cache, re-fetch the ruleset and refresh
our transaction.

For example, in the above 'parallel restore' case, the iptables-restore
instance that lost the race would detect that the table has been created
already, and would add the needed flush.

In a similar vein, in case --noflush is used, we will add the flush
op for user-defined chains that were created in the mean-time.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/nft.c | 131 +++++++++++++++++++++++++++++++++++++++++++++++--
 iptables/nft.h |   1 +
 2 files changed, 128 insertions(+), 4 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index da73e87011db..6354b7e8e72f 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -41,6 +41,7 @@
 #include <linux/netfilter/xt_limit.h>
 
 #include <libmnl/libmnl.h>
+#include <libnftnl/gen.h>
 #include <libnftnl/table.h>
 #include <libnftnl/chain.h>
 #include <libnftnl/rule.h>
@@ -60,6 +61,36 @@
 
 static void *nft_fn;
 
+static int genid_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nft_handle *h = data;
+	struct nftnl_gen *gen;
+
+	gen = nftnl_gen_alloc();
+	if (!gen)
+		return MNL_CB_ERROR;
+
+	if (nftnl_gen_nlmsg_parse(nlh, gen) < 0)
+		goto out;
+
+	h->nft_genid = nftnl_gen_get_u32(gen, NFTNL_GEN_ID);
+
+	nftnl_gen_free(gen);
+	return MNL_CB_STOP;
+out:
+	nftnl_gen_free(gen);
+	return MNL_CB_ERROR;
+}
+
+static int mnl_genid_get(struct nft_handle *h)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETGEN, 0, 0, h->seq);
+	return mnl_talk(h, nlh, genid_cb, h);
+}
+
 int mnl_talk(struct nft_handle *h, struct nlmsghdr *nlh,
 	     int (*cb)(const struct nlmsghdr *nlh, void *data),
 	     void *data)
@@ -109,9 +140,14 @@ static void mnl_nft_batch_continue(struct nftnl_batch *batch)
 	assert(nftnl_batch_update(batch) >= 0);
 }
 
-static uint32_t mnl_batch_begin(struct nftnl_batch *batch, uint32_t seqnum)
+static uint32_t mnl_batch_begin(struct nftnl_batch *batch, uint32_t genid, uint32_t seqnum)
 {
-	nftnl_batch_begin(nftnl_batch_buffer(batch), seqnum);
+	struct nlmsghdr *nlh;
+
+	nlh = nftnl_batch_begin(nftnl_batch_buffer(batch), seqnum);
+
+	mnl_attr_put_u32(nlh, NFTA_GEN_ID, htonl(genid));
+
 	mnl_nft_batch_continue(batch);
 
 	return seqnum;
@@ -1490,6 +1526,7 @@ static int fetch_rule_cache(struct nft_handle *h)
 
 static void __nft_build_cache(struct nft_handle *h)
 {
+	mnl_genid_get(h);
 	fetch_chain_cache(h);
 	fetch_rule_cache(h);
 	h->have_cache = true;
@@ -2678,6 +2715,76 @@ static void batch_obj_del(struct nft_handle *h, struct obj_update *o)
 	free(o);
 }
 
+static void nft_refresh_transaction(struct nft_handle *h)
+{
+	const char *tablename, *chainname;
+	const struct nftnl_chain *c;
+	struct obj_update *n, *tmp;
+	bool exists;
+
+	h->error.lineno = 0;
+
+	list_for_each_entry_safe(n, tmp, &h->obj_list, head) {
+		if (n->implicit) {
+			batch_obj_del(h, n);
+			continue;
+		}
+
+		switch (n->type) {
+		case NFT_COMPAT_TABLE_FLUSH:
+			tablename = nftnl_table_get_str(n->table, NFTNL_TABLE_NAME);
+			if (!tablename)
+				continue;
+			exists = nft_table_find(h, tablename);
+			if (n->skip && exists)
+				n->skip = 0;
+			else if (!n->skip && !exists)
+				n->skip = 1;
+			break;
+		case NFT_COMPAT_TABLE_ADD:
+			tablename = nftnl_table_get_str(n->table, NFTNL_TABLE_NAME);
+			if (!tablename)
+				continue;
+
+			exists = nft_table_find(h, tablename);
+			if (n->skip && !exists)
+				n->skip = 0;
+			break;
+		case NFT_COMPAT_CHAIN_USER_ADD:
+			tablename = nftnl_chain_get_str(n->chain, NFTNL_CHAIN_TABLE);
+			if (!tablename)
+				continue;
+
+			chainname = nftnl_chain_get_str(n->chain, NFTNL_CHAIN_NAME);
+			if (!chainname)
+				continue;
+
+			c = nft_chain_find(h, tablename, chainname);
+			if (c && !n->skip) {
+				/* -restore -n flushes existing rules from redefined user-chain */
+				if (h->noflush)
+					__nft_rule_flush(h, tablename,
+							 chainname, false, true);
+			} else if (!c && n->skip) {
+				n->skip = 0;
+			}
+			break;
+		case NFT_COMPAT_CHAIN_ADD:
+		case NFT_COMPAT_CHAIN_ZERO:
+		case NFT_COMPAT_CHAIN_USER_DEL:
+		case NFT_COMPAT_CHAIN_USER_FLUSH:
+		case NFT_COMPAT_CHAIN_UPDATE:
+		case NFT_COMPAT_CHAIN_RENAME:
+		case NFT_COMPAT_RULE_APPEND:
+		case NFT_COMPAT_RULE_INSERT:
+		case NFT_COMPAT_RULE_REPLACE:
+		case NFT_COMPAT_RULE_DELETE:
+		case NFT_COMPAT_RULE_FLUSH:
+			break;
+		}
+	}
+}
+
 static int nft_action(struct nft_handle *h, int action)
 {
 	struct obj_update *n, *tmp;
@@ -2685,12 +2792,15 @@ static int nft_action(struct nft_handle *h, int action)
 	unsigned int buflen, i, len;
 	bool show_errors = true;
 	char errmsg[1024];
-	uint32_t seq = 1;
+	uint32_t seq;
 	int ret = 0;
 
+retry:
+	seq = 1;
 	h->batch = mnl_batch_init();
 
-	mnl_batch_begin(h->batch, seq++);
+	mnl_batch_begin(h->batch, h->nft_genid, seq++);
+	h->nft_genid++;
 
 	list_for_each_entry(n, &h->obj_list, head) {
 
@@ -2773,7 +2883,20 @@ static int nft_action(struct nft_handle *h, int action)
 		break;
 	}
 
+	errno = 0;
 	ret = mnl_batch_talk(h->nl, h->batch, &h->err_list);
+	if (ret && errno == ERESTART) {
+		nft_rebuild_cache(h);
+
+		nft_refresh_transaction(h);
+
+		i=0;
+		list_for_each_entry_safe(err, ne, &h->err_list, head)
+			mnl_err_list_free(err);
+
+		mnl_batch_reset(h->batch);
+		goto retry;
+	}
 
 	i = 0;
 	buflen = sizeof(errmsg);
diff --git a/iptables/nft.h b/iptables/nft.h
index 97c28b356a46..23bd2b79884c 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -32,6 +32,7 @@ struct nft_handle {
 	struct mnl_socket	*nl;
 	uint32_t		portid;
 	uint32_t		seq;
+	uint32_t		nft_genid;
 	uint32_t		rule_id;
 	struct list_head	obj_list;
 	int			obj_list_num;
-- 
2.21.0

