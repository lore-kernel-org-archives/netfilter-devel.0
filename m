From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] mnl: delete useless parameter nf_sock in batch functions
Date: Tue, 21 Oct 2014 11:47:24 +0200
Message-ID: <20141021094724.7107.39795.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:41150 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751283AbaJUJrf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:47:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The 'struct mnl_socket *nf_sock' parameter is useless and perturbing.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/mnl.h |   16 ++++++++--------
 src/mnl.c     |   32 ++++++++++++++++----------------
 src/netlink.c |   20 ++++++++++----------
 3 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index 03d1876..a0dfa1b 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -36,11 +36,11 @@ struct nft_rule_list *mnl_nft_rule_dump(struct mnl_socket *nf_sock,
 
 int mnl_nft_chain_add(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 		      unsigned int flags);
-int mnl_nft_chain_batch_add(struct mnl_socket *nf_sock, struct nft_chain *nlc,
+int mnl_nft_chain_batch_add(struct nft_chain *nlc,
 			    unsigned int flags, uint32_t seq);
 int mnl_nft_chain_delete(struct mnl_socket *nf_sock, struct nft_chain *nlc,
                          unsigned int flags);
-int mnl_nft_chain_batch_del(struct mnl_socket *nf_sock, struct nft_chain *nlc,
+int mnl_nft_chain_batch_del(struct nft_chain *nlc,
 			    unsigned int flags, uint32_t seq);
 struct nft_chain_list *mnl_nft_chain_dump(struct mnl_socket *nf_sock,
 					  int family);
@@ -49,11 +49,11 @@ int mnl_nft_chain_get(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 
 int mnl_nft_table_add(struct mnl_socket *nf_sock, struct nft_table *nlt,
 		      unsigned int flags);
-int mnl_nft_table_batch_add(struct mnl_socket *nf_sock, struct nft_table *nlt,
+int mnl_nft_table_batch_add(struct nft_table *nlt,
 			    unsigned int flags, uint32_t seq);
 int mnl_nft_table_delete(struct mnl_socket *nf_sock, struct nft_table *nlt,
 			 unsigned int flags);
-int mnl_nft_table_batch_del(struct mnl_socket *nf_sock, struct nft_table *nlt,
+int mnl_nft_table_batch_del(struct nft_table *nlt,
 			    unsigned int flags, uint32_t seq);
 struct nft_table_list *mnl_nft_table_dump(struct mnl_socket *nf_sock,
 					  int family);
@@ -62,11 +62,11 @@ int mnl_nft_table_get(struct mnl_socket *nf_sock, struct nft_table *nlt,
 
 int mnl_nft_set_add(struct mnl_socket *nf_sock, struct nft_set *nls,
 		    unsigned int flags);
-int mnl_nft_set_batch_add(struct mnl_socket *nf_sock, struct nft_set *nls,
+int mnl_nft_set_batch_add(struct nft_set *nls,
 			  unsigned int flags, uint32_t seq);
 int mnl_nft_set_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
 		       unsigned int flags);
-int mnl_nft_set_batch_del(struct mnl_socket *nf_sock, struct nft_set *nls,
+int mnl_nft_set_batch_del(struct nft_set *nls,
 			  unsigned int flags, uint32_t seq);
 struct nft_set_list *mnl_nft_set_dump(struct mnl_socket *nf_sock, int family,
 				      const char *table);
@@ -74,11 +74,11 @@ int mnl_nft_set_get(struct mnl_socket *nf_sock, struct nft_set *nls);
 
 int mnl_nft_setelem_add(struct mnl_socket *nf_sock, struct nft_set *nls,
 			unsigned int flags);
-int mnl_nft_setelem_batch_add(struct mnl_socket *nf_sock, struct nft_set *nls,
+int mnl_nft_setelem_batch_add(struct nft_set *nls,
 			      unsigned int flags, uint32_t seq);
 int mnl_nft_setelem_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
 			   unsigned int flags);
-int mnl_nft_setelem_batch_del(struct mnl_socket *nf_sock, struct nft_set *nls,
+int mnl_nft_setelem_batch_del(struct nft_set *nls,
 			      unsigned int flags, uint32_t seq);
 int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nft_set *nls);
 
diff --git a/src/mnl.c b/src/mnl.c
index bc8b7ea..f48ead5 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -470,8 +470,8 @@ int mnl_nft_chain_add(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
-int mnl_nft_chain_batch_add(struct mnl_socket *nf_sock, struct nft_chain *nlc,
-			    unsigned int flags, uint32_t seqnum)
+int mnl_nft_chain_batch_add(struct nft_chain *nlc, unsigned int flags,
+			    uint32_t seqnum)
 
 {
 	struct nlmsghdr *nlh;
@@ -500,8 +500,8 @@ int mnl_nft_chain_delete(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
-int mnl_nft_chain_batch_del(struct mnl_socket *nf_sock, struct nft_chain *nlc,
-			    unsigned int flags, uint32_t seqnum)
+int mnl_nft_chain_batch_del(struct nft_chain *nlc, unsigned int flags,
+			    uint32_t seqnum)
 {
 	struct nlmsghdr *nlh;
 
@@ -599,8 +599,8 @@ int mnl_nft_table_add(struct mnl_socket *nf_sock, struct nft_table *nlt,
 	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
-int mnl_nft_table_batch_add(struct mnl_socket *nf_sock, struct nft_table *nlt,
-			    unsigned int flags, uint32_t seqnum)
+int mnl_nft_table_batch_add(struct nft_table *nlt, unsigned int flags,
+			    uint32_t seqnum)
 {
 	struct nlmsghdr *nlh;
 
@@ -628,8 +628,8 @@ int mnl_nft_table_delete(struct mnl_socket *nf_sock, struct nft_table *nlt,
 	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
-int mnl_nft_table_batch_del(struct mnl_socket *nf_sock, struct nft_table *nlt,
-			    unsigned int flags, uint32_t seqnum)
+int mnl_nft_table_batch_del(struct nft_table *nlt, unsigned int flags,
+			    uint32_t seqnum)
 {
 	struct nlmsghdr *nlh;
 
@@ -747,8 +747,8 @@ int mnl_nft_set_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
 	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
-int mnl_nft_set_batch_add(struct mnl_socket *nf_sock, struct nft_set *nls,
-			  unsigned int flags, uint32_t seqnum)
+int mnl_nft_set_batch_add(struct nft_set *nls, unsigned int flags,
+			  uint32_t seqnum)
 {
 	struct nlmsghdr *nlh;
 
@@ -762,8 +762,8 @@ int mnl_nft_set_batch_add(struct mnl_socket *nf_sock, struct nft_set *nls,
 	return 0;
 }
 
-int mnl_nft_set_batch_del(struct mnl_socket *nf_sock, struct nft_set *nls,
-			  unsigned int flags, uint32_t seqnum)
+int mnl_nft_set_batch_del(struct nft_set *nls, unsigned int flags,
+			  uint32_t seqnum)
 {
 	struct nlmsghdr *nlh;
 
@@ -906,8 +906,8 @@ static int set_elem_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
-int mnl_nft_setelem_batch_add(struct mnl_socket *nf_sock, struct nft_set *nls,
-			      unsigned int flags, uint32_t seqnum)
+int mnl_nft_setelem_batch_add(struct nft_set *nls, unsigned int flags,
+			      uint32_t seqnum)
 {
 	struct nlmsghdr *nlh;
 	struct nft_set_elems_iter *iter;
@@ -931,8 +931,8 @@ int mnl_nft_setelem_batch_add(struct mnl_socket *nf_sock, struct nft_set *nls,
 	return 0;
 }
 
-int mnl_nft_setelem_batch_del(struct mnl_socket *nf_sock, struct nft_set *nls,
-			      unsigned int flags, uint32_t seqnum)
+int mnl_nft_setelem_batch_del(struct nft_set *nls, unsigned int flags,
+			      uint32_t seqnum)
 {
 	struct nlmsghdr *nlh;
 
diff --git a/src/netlink.c b/src/netlink.c
index 0797174..33e77ab 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -531,7 +531,7 @@ static int netlink_add_chain_batch(struct netlink_ctx *ctx,
 				       chain->type);
 	}
 	netlink_dump_chain(nlc);
-	err = mnl_nft_chain_batch_add(nf_sock, nlc, excl ? NLM_F_EXCL : 0,
+	err = mnl_nft_chain_batch_add(nlc, excl ? NLM_F_EXCL : 0,
 				      ctx->seqnum);
 	nft_chain_free(nlc);
 
@@ -587,7 +587,7 @@ static int netlink_rename_chain_batch(struct netlink_ctx *ctx,
 	nlc = alloc_nft_chain(h);
 	nft_chain_attr_set_str(nlc, NFT_CHAIN_ATTR_NAME, name);
 	netlink_dump_chain(nlc);
-	err = mnl_nft_chain_batch_add(nf_sock, nlc, 0, ctx->seqnum);
+	err = mnl_nft_chain_batch_add(nlc, 0, ctx->seqnum);
 	nft_chain_free(nlc);
 
 	if (err < 0) {
@@ -638,7 +638,7 @@ static int netlink_del_chain_batch(struct netlink_ctx *ctx,
 
 	nlc = alloc_nft_chain(h);
 	netlink_dump_chain(nlc);
-	err = mnl_nft_chain_batch_del(nf_sock, nlc, 0, ctx->seqnum);
+	err = mnl_nft_chain_batch_del(nlc, 0, ctx->seqnum);
 	nft_chain_free(nlc);
 
 	if (err < 0) {
@@ -808,7 +808,7 @@ static int netlink_add_table_batch(struct netlink_ctx *ctx,
 	int err;
 
 	nlt = alloc_nft_table(h);
-	err = mnl_nft_table_batch_add(nf_sock, nlt, excl ? NLM_F_EXCL : 0,
+	err = mnl_nft_table_batch_add(nlt, excl ? NLM_F_EXCL : 0,
 				      ctx->seqnum);
 	nft_table_free(nlt);
 
@@ -858,7 +858,7 @@ static int netlink_del_table_batch(struct netlink_ctx *ctx,
 	int err;
 
 	nlt = alloc_nft_table(h);
-	err = mnl_nft_table_batch_del(nf_sock, nlt, 0, ctx->seqnum);
+	err = mnl_nft_table_batch_del(nlt, 0, ctx->seqnum);
 	nft_table_free(nlt);
 
 	if (err < 0) {
@@ -1130,7 +1130,7 @@ static int netlink_add_set_batch(struct netlink_ctx *ctx,
 
 	netlink_dump_set(nls);
 
-	err = mnl_nft_set_batch_add(nf_sock, nls, NLM_F_EXCL, ctx->seqnum);
+	err = mnl_nft_set_batch_add(nls, NLM_F_EXCL, ctx->seqnum);
 	if (err < 0) {
 		netlink_io_error(ctx, &set->location, "Could not add set: %s",
 				 strerror(errno));
@@ -1178,7 +1178,7 @@ static int netlink_del_set_batch(struct netlink_ctx *ctx,
 	int err;
 
 	nls = alloc_nft_set(h);
-	err = mnl_nft_set_batch_del(nf_sock, nls, 0, ctx->seqnum);
+	err = mnl_nft_set_batch_del(nls, 0, ctx->seqnum);
 	nft_set_free(nls);
 
 	if (err < 0)
@@ -1282,7 +1282,7 @@ static int netlink_add_setelems_batch(struct netlink_ctx *ctx,
 	alloc_setelem_cache(expr, nls);
 	netlink_dump_set(nls);
 
-	err = mnl_nft_setelem_batch_add(nf_sock, nls, 0, ctx->seqnum);
+	err = mnl_nft_setelem_batch_add(nls, 0, ctx->seqnum);
 	nft_set_free(nls);
 	if (err < 0)
 		netlink_io_error(ctx, &expr->location,
@@ -1335,7 +1335,7 @@ static int netlink_del_setelems_batch(struct netlink_ctx *ctx,
 	alloc_setelem_cache(expr, nls);
 	netlink_dump_set(nls);
 
-	err = mnl_nft_setelem_batch_del(nf_sock, nls, 0, ctx->seqnum);
+	err = mnl_nft_setelem_batch_del(nls, 0, ctx->seqnum);
 	nft_set_free(nls);
 	if (err < 0)
 		netlink_io_error(ctx, &expr->location,
@@ -1482,7 +1482,7 @@ int netlink_flush_ruleset(struct netlink_ctx *ctx, const struct handle *h,
 	}
 
 	nlt = alloc_nft_table(h);
-	err = mnl_nft_table_batch_del(nf_sock, nlt, 0, ctx->seqnum);
+	err = mnl_nft_table_batch_del(nlt, 0, ctx->seqnum);
 	nft_table_free(nlt);
 
 	if (err < 0)

