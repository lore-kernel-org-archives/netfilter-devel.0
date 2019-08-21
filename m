Return-Path: <SRS0=lxoE=WR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51509C3A5A1
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 09:26:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DBFF22D6D
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 09:26:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbfHUJ0p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Aug 2019 05:26:45 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:43778 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbfHUJ0p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Aug 2019 05:26:45 -0400
Received: from localhost ([::1]:56868 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1i0MtA-00055o-Mf; Wed, 21 Aug 2019 11:26:44 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 05/14] nft: Fetch sets when updating rule cache
Date:   Wed, 21 Aug 2019 11:25:53 +0200
Message-Id: <20190821092602.16292-6-phil@nwl.cc>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190821092602.16292-1-phil@nwl.cc>
References: <20190821092602.16292-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In order to support anonymous sets, cache them along with their
elements.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 108 +++++++++++++++++++++++++++++++++++++++++++++++++
 iptables/nft.h |   7 ++++
 2 files changed, 115 insertions(+)

diff --git a/iptables/nft.c b/iptables/nft.c
index 28e63aad15878..633c33ddddb15 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -857,6 +857,14 @@ static int __flush_chain_cache(struct nftnl_chain *c, void *data)
 	return 0;
 }
 
+static int __flush_set_cache(struct nftnl_set *s, void *data)
+{
+	nftnl_set_list_del(s);
+	nftnl_set_free(s);
+
+	return 0;
+}
+
 static int flush_cache(struct nft_cache *c, const struct builtin_table *tables,
 		       const char *tablename)
 {
@@ -869,6 +877,8 @@ static int flush_cache(struct nft_cache *c, const struct builtin_table *tables,
 			return 0;
 		nftnl_chain_list_foreach(c->table[table->type].chains,
 					 __flush_chain_cache, NULL);
+		nftnl_set_list_foreach(c->table[table->type].sets,
+				       __flush_set_cache, NULL);
 		return 0;
 	}
 
@@ -881,6 +891,8 @@ static int flush_cache(struct nft_cache *c, const struct builtin_table *tables,
 
 		nftnl_chain_list_free(c->table[i].chains);
 		c->table[i].chains = NULL;
+		nftnl_set_list_free(c->table[i].sets);
+		c->table[i].sets = NULL;
 	}
 	nftnl_table_list_free(c->tables);
 	c->tables = NULL;
@@ -1414,6 +1426,86 @@ static int fetch_table_cache(struct nft_handle *h)
 	return 1;
 }
 
+static int nftnl_set_list_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nft_handle *h = data;
+	const struct builtin_table *t;
+	struct nftnl_set *s;
+
+	s = nftnl_set_alloc();
+	if (s == NULL)
+		return MNL_CB_OK;
+
+	if (nftnl_set_nlmsg_parse(nlh, s) < 0)
+		goto out_free;
+
+	t = nft_table_builtin_find(h, nftnl_set_get_str(s, NFTNL_SET_TABLE));
+	if (!t)
+		goto out_free;
+
+	nftnl_set_list_add_tail(s, h->cache->table[t->type].sets);
+	return MNL_CB_OK;
+out_free:
+	nftnl_set_free(s);
+	return MNL_CB_OK;
+}
+
+static int set_elem_cb(const struct nlmsghdr *nlh, void *data)
+{
+	return nftnl_set_elems_nlmsg_parse(nlh, data) ? -1 : MNL_CB_OK;
+}
+
+static int set_list_fetch_elem_cb(struct nftnl_set *s, void *data)
+{
+        char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nft_handle *h = data;
+        struct nlmsghdr *nlh;
+
+	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_GETSETELEM, h->family,
+				    NLM_F_DUMP, h->seq);
+        nftnl_set_elems_nlmsg_build_payload(nlh, s);
+
+	return mnl_talk(h, nlh, set_elem_cb, s);
+}
+
+static int fetch_set_cache(struct nft_handle *h)
+{
+	struct nlmsghdr *nlh;
+	char buf[16536];
+	int i, ret;
+
+	for (i = 0; i < NFT_TABLE_MAX; i++) {
+		enum nft_table_type type = h->tables[i].type;
+
+		if (!h->tables[i].name)
+			continue;
+
+		h->cache->table[type].sets = nftnl_set_list_alloc();
+		if (!h->cache->table[type].sets)
+			return -1;
+	}
+
+	nlh = nftnl_set_nlmsg_build_hdr(buf, NFT_MSG_GETSET, h->family,
+					NLM_F_DUMP, h->seq);
+
+	ret = mnl_talk(h, nlh, nftnl_set_list_cb, h);
+	if (ret < 0 && errno == EINTR) {
+		assert(nft_restart(h) >= 0);
+		return ret;
+	}
+
+	for (i = 0; i < NFT_TABLE_MAX; i++) {
+		enum nft_table_type type = h->tables[i].type;
+
+		if (!h->tables[i].name)
+			continue;
+
+		nftnl_set_list_foreach(h->cache->table[type].sets,
+				       set_list_fetch_elem_cb, h);
+	}
+	return ret;
+}
+
 static int fetch_chain_cache(struct nft_handle *h)
 {
 	char buf[16536];
@@ -1579,6 +1671,8 @@ static int fetch_rule_cache(struct nft_handle *h)
 {
 	int i;
 
+	fetch_set_cache(h);
+
 	for (i = 0; i < NFT_TABLE_MAX; i++) {
 		enum nft_table_type type = h->tables[i].type;
 
@@ -1655,6 +1749,20 @@ struct nftnl_chain_list *nft_chain_list_get(struct nft_handle *h,
 	return h->cache->table[t->type].chains;
 }
 
+struct nftnl_set_list *nft_set_list_get(struct nft_handle *h,
+					const char *table)
+{
+	const struct builtin_table *t;
+
+	t = nft_table_builtin_find(h, table);
+	if (!t)
+		return NULL;
+
+	nft_build_cache(h);
+
+	return h->cache->table[t->type].sets;
+}
+
 static const char *policy_name[NF_ACCEPT+1] = {
 	[NF_DROP] = "DROP",
 	[NF_ACCEPT] = "ACCEPT",
diff --git a/iptables/nft.h b/iptables/nft.h
index 5e5e765b0d043..2f929a15f98df 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -31,6 +31,7 @@ struct nft_cache {
 	struct nftnl_table_list		*tables;
 	struct {
 		struct nftnl_chain_list *chains;
+		struct nftnl_set_list	*sets;
 		bool			initialized;
 	} table[NFT_TABLE_MAX];
 };
@@ -88,6 +89,12 @@ int nft_table_flush(struct nft_handle *h, const char *table);
 void nft_table_new(struct nft_handle *h, const char *table);
 const struct builtin_table *nft_table_builtin_find(struct nft_handle *h, const char *table);
 
+/*
+ * Operations with sets.
+ */
+struct nftnl_set_list *nft_set_list_get(struct nft_handle *h,
+					const char *table);
+
 /*
  * Operations with chains.
  */
-- 
2.22.0

