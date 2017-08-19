From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH nft-sync] fix build
Date: Sat, 19 Aug 2017 14:41:45 +0200
Message-ID: <20170819124145.7283-1-pablombg@gmail.com>
Cc: pablo@netfilter.org, "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:33701 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751114AbdHSMmW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Aug 2017 08:42:22 -0400
Received: by mail-wr0-f195.google.com with SMTP id b65so456881wrd.0
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Aug 2017 05:42:21 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft-sync development has been stalled for two years. Since then the
libnftnl API has changed, breaking the build.

Apply the required changes to make the project build again.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 include/mnl.h |  13 +++--
 src/mnl.c     | 178 +++++++++++++++++++++++++++++-----------------------------
 2 files changed, 96 insertions(+), 95 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index cd146bd..21c43d4 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -11,12 +11,13 @@
 
 #include "config.h"
 
-struct nft_rule_list *mnl_rule_dump(struct mnl_socket *nf_sock, int family);
-struct nft_chain_list *mnl_chain_dump(struct mnl_socket *nf_sock,  int family);
-struct nft_table_list *mnl_table_dump(struct mnl_socket *nf_sock, int family);
-struct nft_set_list *mnl_set_dump(struct mnl_socket *nf_sock, int family, const char *table);
-int mnl_setelem_get(struct mnl_socket *nf_sock, struct nft_set *nls);
-struct nft_ruleset *mnl_ruleset_dump(struct mnl_socket *nf_sock);
+struct nftnl_rule_list *mnl_rule_dump(struct mnl_socket *nf_sock, int family);
+struct nftnl_chain_list *mnl_chain_dump(struct mnl_socket *nf_sock, int family);
+struct nftnl_table_list *mnl_table_dump(struct mnl_socket *nf_sock, int family);
+struct nftnl_set_list *mnl_set_dump(struct mnl_socket *nf_sock, int family,
+				    const char *table);
+int mnl_setelem_get(struct mnl_socket *nf_sock, struct nftnl_set *nls);
+struct nftnl_ruleset *mnl_ruleset_dump(struct mnl_socket *nf_sock);
 int nfts_socket_open(struct nft_sync_inst *nfts_inst);
 void nfts_socket_close(struct nft_sync_inst *nfts_inst);
 const char *netlink_dump_ruleset(struct mnl_socket *s);
diff --git a/src/mnl.c b/src/mnl.c
index 3bb3ade..6cd0f23 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -52,36 +52,36 @@ out:
  */
 static int rule_cb(const struct nlmsghdr *nlh, void *data)
 {
-	struct nft_rule_list *nlr_list = data;
-	struct nft_rule *r;
+	struct nftnl_rule_list *nlr_list = data;
+	struct nftnl_rule *r;
 
-	r = nft_rule_alloc();
+	r = nftnl_rule_alloc();
 	if (r == NULL)
 		return -1;
 
-	if (nft_rule_nlmsg_parse(nlh, r) < 0)
+	if (nftnl_rule_nlmsg_parse(nlh, r) < 0)
 		goto err_free;
 
-	nft_rule_list_add_tail(r, nlr_list);
+	nftnl_rule_list_add_tail(r, nlr_list);
 	return MNL_CB_OK;
 
 err_free:
-	nft_rule_free(r);
+	nftnl_rule_free(r);
 	return MNL_CB_OK;
 }
 
-struct nft_rule_list *mnl_rule_dump(struct mnl_socket *nf_sock, int family)
+struct nftnl_rule_list *mnl_rule_dump(struct mnl_socket *nf_sock, int family)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
-	struct nft_rule_list *nlr_list;
+	struct nftnl_rule_list *nlr_list;
 	int ret;
 
-	nlr_list = nft_rule_list_alloc();
+	nlr_list = nftnl_rule_list_alloc();
 	if (nlr_list == NULL)
 		return NULL;
 
-	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_GETRULE, family,
+	nlh = nftnl_rule_nlmsg_build_hdr(buf, NFT_MSG_GETRULE, family,
 				       NLM_F_DUMP, seq);
 
 	ret = nfts_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, rule_cb, nlr_list);
@@ -90,7 +90,7 @@ struct nft_rule_list *mnl_rule_dump(struct mnl_socket *nf_sock, int family)
 
 	return nlr_list;
 err:
-	nft_rule_list_free(nlr_list);
+	nftnl_rule_list_free(nlr_list);
 	return NULL;
 }
 
@@ -99,36 +99,36 @@ err:
  */
 static int chain_cb(const struct nlmsghdr *nlh, void *data)
 {
-	struct nft_chain_list *nlc_list = data;
-	struct nft_chain *c;
+	struct nftnl_chain_list *nlc_list = data;
+	struct nftnl_chain *c;
 
-	c = nft_chain_alloc();
+	c = nftnl_chain_alloc();
 	if (c == NULL)
 		return -1;
 
-	if (nft_chain_nlmsg_parse(nlh, c) < 0)
+	if (nftnl_chain_nlmsg_parse(nlh, c) < 0)
 		goto err_free;
 
-	nft_chain_list_add_tail(c, nlc_list);
+	nftnl_chain_list_add_tail(c, nlc_list);
 	return MNL_CB_OK;
 
 err_free:
-	nft_chain_free(c);
+	nftnl_chain_free(c);
 	return MNL_CB_OK;
 }
 
-struct nft_chain_list *mnl_chain_dump(struct mnl_socket *nf_sock, int family)
+struct nftnl_chain_list *mnl_chain_dump(struct mnl_socket *nf_sock, int family)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
-	struct nft_chain_list *nlc_list;
+	struct nftnl_chain_list *nlc_list;
 	int ret;
 
-	nlc_list = nft_chain_list_alloc();
+	nlc_list = nftnl_chain_list_alloc();
 	if (nlc_list == NULL)
 		return NULL;
 
-	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, family,
+	nlh = nftnl_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, family,
 					NLM_F_DUMP, seq);
 
 	ret = nfts_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, chain_cb, nlc_list);
@@ -137,7 +137,7 @@ struct nft_chain_list *mnl_chain_dump(struct mnl_socket *nf_sock, int family)
 
 	return nlc_list;
 err:
-	nft_chain_list_free(nlc_list);
+	nftnl_chain_list_free(nlc_list);
 	return NULL;
 }
 
@@ -147,36 +147,36 @@ err:
 
 static int table_cb(const struct nlmsghdr *nlh, void *data)
 {
-	struct nft_table_list *nlt_list = data;
-	struct nft_table *t;
+	struct nftnl_table_list *nlt_list = data;
+	struct nftnl_table *t;
 
-	t = nft_table_alloc();
+	t = nftnl_table_alloc();
 	if (t == NULL)
 		return -1;
 
-	if (nft_table_nlmsg_parse(nlh, t) < 0)
+	if (nftnl_table_nlmsg_parse(nlh, t) < 0)
 		goto err_free;
 
-	nft_table_list_add_tail(t, nlt_list);
+	nftnl_table_list_add_tail(t, nlt_list);
 	return MNL_CB_OK;
 
 err_free:
-	nft_table_free(t);
+	nftnl_table_free(t);
 	return MNL_CB_OK;
 }
 
-struct nft_table_list *mnl_table_dump(struct mnl_socket *nf_sock, int family)
+struct nftnl_table_list *mnl_table_dump(struct mnl_socket *nf_sock, int family)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
-	struct nft_table_list *nlt_list;
+	struct nftnl_table_list *nlt_list;
 	int ret;
 
-	nlt_list = nft_table_list_alloc();
+	nlt_list = nftnl_table_list_alloc();
 	if (nlt_list == NULL)
 		return NULL;
 
-	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, family,
+	nlh = nftnl_table_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, family,
 					NLM_F_DUMP, seq);
 
 	ret = nfts_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, table_cb, nlt_list);
@@ -185,7 +185,7 @@ struct nft_table_list *mnl_table_dump(struct mnl_socket *nf_sock, int family)
 
 	return nlt_list;
 err:
-	nft_table_list_free(nlt_list);
+	nftnl_table_list_free(nlt_list);
 	return NULL;
 }
 
@@ -195,44 +195,44 @@ err:
 
 static int set_cb(const struct nlmsghdr *nlh, void *data)
 {
-	struct nft_set_list *nls_list = data;
-	struct nft_set *s;
+	struct nftnl_set_list *nls_list = data;
+	struct nftnl_set *s;
 
-	s = nft_set_alloc();
+	s = nftnl_set_alloc();
 	if (s == NULL)
 		return -1;
 
-	if (nft_set_nlmsg_parse(nlh, s) < 0)
+	if (nftnl_set_nlmsg_parse(nlh, s) < 0)
 		goto err_free;
 
-	nft_set_list_add_tail(s, nls_list);
+	nftnl_set_list_add_tail(s, nls_list);
 	return MNL_CB_OK;
 
 err_free:
-	nft_set_free(s);
+	nftnl_set_free(s);
 	return MNL_CB_OK;
 }
 
-struct nft_set_list *
+struct nftnl_set_list *
 mnl_set_dump(struct mnl_socket *nf_sock, int family, const char *table)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
-	struct nft_set *s;
-	struct nft_set_list *nls_list;
+	struct nftnl_set *s;
+	struct nftnl_set_list *nls_list;
 	int ret;
 
-	s = nft_set_alloc();
+	s = nftnl_set_alloc();
 	if (s == NULL)
 		return NULL;
 
-	nlh = nft_set_nlmsg_build_hdr(buf, NFT_MSG_GETSET, family,
+	nlh = nftnl_set_nlmsg_build_hdr(buf, NFT_MSG_GETSET, family,
 				      NLM_F_DUMP|NLM_F_ACK, seq);
-	nft_set_attr_set(s, NFT_SET_ATTR_TABLE, table);
-	nft_set_nlmsg_build_payload(nlh, s);
-	nft_set_free(s);
+	nftnl_set_set_str(s, NFTNL_SET_TABLE, table);
+	nftnl_set_nlmsg_build_payload(nlh, s);
+	nftnl_set_free(s);
 
-	nls_list = nft_set_list_alloc();
+	nls_list = nftnl_set_list_alloc();
 	if (nls_list == NULL)
 		goto err;
 
@@ -242,27 +242,27 @@ mnl_set_dump(struct mnl_socket *nf_sock, int family, const char *table)
 
 	return nls_list;
 err:
-	nft_set_list_free(nls_list);
+	nftnl_set_list_free(nls_list);
 	return NULL;
 }
 
 static void
-nft_set_list_merge(struct nft_set_list *dest, struct nft_set_list *orig)
+nftnl_set_list_merge(struct nftnl_set_list *dest, struct nftnl_set_list *orig)
 {
-	struct nft_set_list_iter *it;
-	struct nft_set *o;
+	struct nftnl_set_list_iter *it;
+	struct nftnl_set *o;
 
-	it = nft_set_list_iter_create(orig);
+	it = nftnl_set_list_iter_create(orig);
 	if (it == NULL)
 		return;
 
-	o = nft_set_list_iter_next(it);
+	o = nftnl_set_list_iter_next(it);
 	while (o != NULL) {
-		nft_set_list_add_tail(o, dest);
-		o = nft_set_list_iter_next(it);
+		nftnl_set_list_add_tail(o, dest);
+		o = nftnl_set_list_iter_next(it);
 	}
 
-	nft_set_list_iter_destroy(it);
+	nftnl_set_list_iter_destroy(it);
 }
 
 
@@ -272,19 +272,19 @@ nft_set_list_merge(struct nft_set_list *dest, struct nft_set_list *orig)
 
 static int set_elem_cb(const struct nlmsghdr *nlh, void *data)
 {
-	nft_set_elems_nlmsg_parse(nlh, data);
+	nftnl_set_elems_nlmsg_parse(nlh, data);
 	return MNL_CB_OK;
 }
 
-int mnl_setelem_get(struct mnl_socket *nf_sock, struct nft_set *nls)
+int mnl_setelem_get(struct mnl_socket *nf_sock, struct nftnl_set *nls)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
-	uint32_t family = nft_set_attr_get_u32(nls, NFT_SET_ATTR_FAMILY);
+	uint32_t family = nftnl_set_get_u32(nls, NFTNL_SET_FAMILY);
 
-	nlh = nft_set_nlmsg_build_hdr(buf, NFT_MSG_GETSETELEM, family,
+	nlh = nftnl_set_nlmsg_build_hdr(buf, NFT_MSG_GETSETELEM, family,
 				      NLM_F_DUMP|NLM_F_ACK, seq);
-	nft_set_nlmsg_build_payload(nlh, nls);
+	nftnl_set_nlmsg_build_payload(nlh, nls);
 
 	return nfts_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, set_elem_cb, nls);
 }
@@ -293,15 +293,15 @@ int mnl_setelem_get(struct mnl_socket *nf_sock, struct nft_set *nls)
  * ruleset
  */
 
-struct nft_ruleset *mnl_ruleset_dump(struct mnl_socket *nf_sock)
+struct nftnl_ruleset *mnl_ruleset_dump(struct mnl_socket *nf_sock)
 {
-	struct nft_ruleset *rs;
-	struct nft_rule_list *r;
-	struct nft_chain_list *c;
-	struct nft_set_list *complete_set_list = NULL, *s;
-	struct nft_table_list *t;
-	struct nft_table_list_iter *it;
-	struct nft_table *o;
+	struct nftnl_ruleset *rs;
+	struct nftnl_rule_list *r;
+	struct nftnl_chain_list *c;
+	struct nftnl_set_list *complete_set_list = NULL, *s;
+	struct nftnl_table_list *t;
+	struct nftnl_table_list_iter *it;
+	struct nftnl_table *o;
 	const char *table;
 	uint16_t family;
 
@@ -309,46 +309,45 @@ struct nft_ruleset *mnl_ruleset_dump(struct mnl_socket *nf_sock)
 	if (t == NULL)
 		return NULL;
 
-	rs = nft_ruleset_alloc();
+	rs = nftnl_ruleset_alloc();
 	if (rs == NULL)
 		return NULL;
 
-	nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_TABLELIST, t);
+	nftnl_ruleset_set(rs, NFTNL_RULESET_TABLELIST, t);
 
 	c = mnl_chain_dump(nf_sock, NFPROTO_UNSPEC);
 	if (c != NULL)
-		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_CHAINLIST, c);
+		nftnl_ruleset_set(rs, NFTNL_RULESET_CHAINLIST, c);
 
 	r = mnl_rule_dump(nf_sock, NFPROTO_UNSPEC);
 	if (r != NULL)
-		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_RULELIST, r);
+		nftnl_ruleset_set(rs, NFTNL_RULESET_RULELIST, r);
 
-	it = nft_table_list_iter_create(t);
+	it = nftnl_table_list_iter_create(t);
 	if (it == NULL)
 		return NULL;
 
-	o = nft_table_list_iter_next(it);
+	o = nftnl_table_list_iter_next(it);
 	while (o != NULL) {
-		table = nft_table_attr_get_str(o, NFT_TABLE_ATTR_NAME);
-		family = nft_table_attr_get_u32(o, NFT_TABLE_ATTR_FAMILY);
+		table = nftnl_table_get_str(o, NFTNL_TABLE_NAME);
+		family = nftnl_table_get_u32(o, NFTNL_TABLE_FAMILY);
 
 		s = mnl_set_dump(nf_sock, family, table);
 		if (s != NULL) {
 			if (complete_set_list == NULL) {
-				complete_set_list = nft_set_list_alloc();
+				complete_set_list = nftnl_set_list_alloc();
 				if (complete_set_list == NULL)
 					return NULL;
 			}
 
-			nft_set_list_merge(complete_set_list, s);
+			nftnl_set_list_merge(complete_set_list, s);
 		}
-		o = nft_table_list_iter_next(it);
+		o = nftnl_table_list_iter_next(it);
 	}
-	nft_table_list_iter_destroy(it);
+	nftnl_table_list_iter_destroy(it);
 
 	if (complete_set_list != NULL)
-		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_SETLIST,
-				     complete_set_list);
+		nftnl_ruleset_set(rs, NFTNL_RULESET_SETLIST, complete_set_list);
 
 	return rs;
 }
@@ -380,7 +379,7 @@ void nfts_socket_close(struct nft_sync_inst *inst)
 
 const char *netlink_dump_ruleset(struct mnl_socket *s)
 {
-	struct nft_ruleset *rs;
+	struct nftnl_ruleset *rs;
 	size_t bufsiz = SNPRINTF_BUFSIZ;
 	char *buf;
 	int ret;
@@ -395,19 +394,20 @@ const char *netlink_dump_ruleset(struct mnl_socket *s)
 		return NULL;
 	}
 
-	ret = nft_ruleset_snprintf(buf, bufsiz, rs, NFT_OUTPUT_XML, 0);
+	ret = nftnl_ruleset_snprintf(buf, bufsiz, rs, NFTNL_OUTPUT_XML, 0);
 	if (ret > SNPRINTF_BUFSIZ) {
 		free(buf);
 		buf = calloc(1, ret);
 		if (buf == NULL) {
-			nft_ruleset_free(rs);
+			nftnl_ruleset_free(rs);
 			return NULL;
 		}
 
 		bufsiz = ret;
-		ret = nft_ruleset_snprintf(buf, bufsiz, rs, NFT_OUTPUT_XML, 0);
+		ret = nftnl_ruleset_snprintf(buf, bufsiz, rs,
+					     NFTNL_OUTPUT_XML, 0);
 	}
 
-	nft_ruleset_free(rs);
+	nftnl_ruleset_free(rs);
 	return buf;
 }
-- 
2.13.2

