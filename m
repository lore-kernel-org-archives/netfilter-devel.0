From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] mnl: split talk() and recv() functions
Date: Mon, 28 Apr 2014 16:48:09 +0200
Message-ID: <20140428144709.20021.74777.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:34345 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751460AbaD1OsW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:48:22 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's split talk() and recv() functions, so they can be used independently.

While at it, lets rename mnl_talk() to nft_mnl_talk() so we avoid potential
clashes with other functions in external libs.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
@pablo: this patch is needed and was missing in the monitor series. I'm sorry.

 src/mnl.c |   68 ++++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 38 insertions(+), 30 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index d19b521..4d60d64 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -34,24 +34,15 @@ uint32_t mnl_seqnum_alloc(void)
 }
 
 static int
-mnl_talk(struct mnl_socket *nf_sock, const void *data, unsigned int len,
-	 int (*cb)(const struct nlmsghdr *nlh, void *data), void *cb_data)
+nft_mnl_recv(struct mnl_socket *nf_sock, uint32_t seqnum, uint32_t portid,
+	     int (*cb)(const struct nlmsghdr *nlh, void *data), void *cb_data)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
-	uint32_t portid = mnl_socket_get_portid(nf_sock);
 	int ret;
 
-#ifdef DEBUG
-	if (debug_level & DEBUG_MNL)
-		mnl_nlmsg_fprintf(stdout, data, len, sizeof(struct nfgenmsg));
-#endif
-
-	if (mnl_socket_sendto(nf_sock, data, len) < 0)
-		return -1;
-
 	ret = mnl_socket_recvfrom(nf_sock, buf, sizeof(buf));
 	while (ret > 0) {
-		ret = mnl_cb_run(buf, ret, seq, portid, cb, cb_data);
+		ret = mnl_cb_run(buf, ret, seqnum, portid, cb, cb_data);
 		if (ret <= 0)
 			goto out;
 
@@ -64,6 +55,23 @@ out:
 	return ret;
 }
 
+static int
+nft_mnl_talk(struct mnl_socket *nf_sock, const void *data, unsigned int len,
+	     int (*cb)(const struct nlmsghdr *nlh, void *data), void *cb_data)
+{
+	uint32_t portid = mnl_socket_get_portid(nf_sock);
+
+#ifdef DEBUG
+	if (debug_level & DEBUG_MNL)
+		mnl_nlmsg_fprintf(stdout, data, len, sizeof(struct nfgenmsg));
+#endif
+
+	if (mnl_socket_sendto(nf_sock, data, len) < 0)
+		return -1;
+
+	return nft_mnl_recv(nf_sock, seq, portid, cb, cb_data);
+}
+
 /*
  * Batching
  */
@@ -333,7 +341,7 @@ int mnl_nft_rule_add(struct mnl_socket *nf_sock, struct nft_rule *nlr,
 			NLM_F_ACK | NLM_F_CREATE | flags, seq);
 	nft_rule_nlmsg_build_payload(nlh, nlr);
 
-	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
 int mnl_nft_rule_delete(struct mnl_socket *nf_sock, struct nft_rule *nlr,
@@ -347,7 +355,7 @@ int mnl_nft_rule_delete(struct mnl_socket *nf_sock, struct nft_rule *nlr,
 			NLM_F_ACK, seq);
 	nft_rule_nlmsg_build_payload(nlh, nlr);
 
-	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
 static int rule_cb(const struct nlmsghdr *nlh, void *data)
@@ -384,7 +392,7 @@ struct nft_rule_list *mnl_nft_rule_dump(struct mnl_socket *nf_sock, int family)
 	nlh = nft_rule_nlmsg_build_hdr(buf, NFT_MSG_GETRULE, family,
 				       NLM_F_DUMP, seq);
 
-	ret = mnl_talk(nf_sock, nlh, nlh->nlmsg_len, rule_cb, nlr_list);
+	ret = nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, rule_cb, nlr_list);
 	if (ret < 0)
 		goto err;
 
@@ -409,7 +417,7 @@ int mnl_nft_chain_add(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 			NLM_F_CREATE | NLM_F_ACK | flags, seq);
 	nft_chain_nlmsg_build_payload(nlh, nlc);
 
-	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
 int mnl_nft_chain_delete(struct mnl_socket *nf_sock, struct nft_chain *nlc,
@@ -423,7 +431,7 @@ int mnl_nft_chain_delete(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 			NLM_F_ACK, seq);
 	nft_chain_nlmsg_build_payload(nlh, nlc);
 
-	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
 static int chain_cb(const struct nlmsghdr *nlh, void *data)
@@ -460,7 +468,7 @@ struct nft_chain_list *mnl_nft_chain_dump(struct mnl_socket *nf_sock, int family
 	nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_GETCHAIN, family,
 					NLM_F_DUMP, seq);
 
-	ret = mnl_talk(nf_sock, nlh, nlh->nlmsg_len, chain_cb, nlc_list);
+	ret = nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, chain_cb, nlc_list);
 	if (ret < 0)
 		goto err;
 
@@ -487,7 +495,7 @@ int mnl_nft_chain_get(struct mnl_socket *nf_sock, struct nft_chain *nlc,
 			NLM_F_ACK | flags, seq);
 	nft_chain_nlmsg_build_payload(nlh, nlc);
 
-	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, chain_get_cb, nlc);
+	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, chain_get_cb, nlc);
 }
 
 /*
@@ -504,7 +512,7 @@ int mnl_nft_table_add(struct mnl_socket *nf_sock, struct nft_table *nlt,
 			NLM_F_ACK | flags, seq);
 	nft_table_nlmsg_build_payload(nlh, nlt);
 
-	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
 int mnl_nft_table_delete(struct mnl_socket *nf_sock, struct nft_table *nlt,
@@ -518,7 +526,7 @@ int mnl_nft_table_delete(struct mnl_socket *nf_sock, struct nft_table *nlt,
 			NLM_F_ACK, seq);
 	nft_table_nlmsg_build_payload(nlh, nlt);
 
-	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
 static int table_cb(const struct nlmsghdr *nlh, void *data)
@@ -555,7 +563,7 @@ struct nft_table_list *mnl_nft_table_dump(struct mnl_socket *nf_sock, int family
 	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, family,
 					NLM_F_DUMP, seq);
 
-	ret = mnl_talk(nf_sock, nlh, nlh->nlmsg_len, table_cb, nlt_list);
+	ret = nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, table_cb, nlt_list);
 	if (ret < 0)
 		goto err;
 
@@ -582,7 +590,7 @@ int mnl_nft_table_get(struct mnl_socket *nf_sock, struct nft_table *nlt,
 	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE,
 					nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FAMILY),
 					NLM_F_ACK, seq);
-	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, table_get_cb, nlt);
+	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, table_get_cb, nlt);
 }
 
 /*
@@ -605,7 +613,7 @@ int mnl_nft_set_add(struct mnl_socket *nf_sock, struct nft_set *nls,
 			NLM_F_CREATE | NLM_F_ACK | flags, seq);
 	nft_set_nlmsg_build_payload(nlh, nls);
 
-	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, set_add_cb, nls);
+	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, set_add_cb, nls);
 }
 
 int mnl_nft_set_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
@@ -619,7 +627,7 @@ int mnl_nft_set_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
 			flags|NLM_F_ACK, seq);
 	nft_set_nlmsg_build_payload(nlh, nls);
 
-	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
 static int set_cb(const struct nlmsghdr *nlh, void *data)
@@ -666,7 +674,7 @@ mnl_nft_set_dump(struct mnl_socket *nf_sock, int family, const char *table)
 	if (nls_list == NULL)
 		memory_allocation_error();
 
-	ret = mnl_talk(nf_sock, nlh, nlh->nlmsg_len, set_cb, nls_list);
+	ret = nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, set_cb, nls_list);
 	if (ret < 0)
 		goto err;
 
@@ -694,7 +702,7 @@ int mnl_nft_set_get(struct mnl_socket *nf_sock, struct nft_set *nls)
 			NLM_F_ACK, seq);
 	nft_set_nlmsg_build_payload(nlh, nls);
 
-	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, set_get_cb, nls);
+	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, set_get_cb, nls);
 }
 
 /*
@@ -711,7 +719,7 @@ int mnl_nft_setelem_add(struct mnl_socket *nf_sock, struct nft_set *nls,
 			NLM_F_CREATE | NLM_F_ACK | flags, seq);
 	nft_set_elems_nlmsg_build_payload(nlh, nls);
 
-	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
 int mnl_nft_setelem_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
@@ -725,7 +733,7 @@ int mnl_nft_setelem_delete(struct mnl_socket *nf_sock, struct nft_set *nls,
 			NLM_F_ACK, seq);
 	nft_set_elems_nlmsg_build_payload(nlh, nls);
 
-	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
+	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, NULL, NULL);
 }
 
 static int set_elem_cb(const struct nlmsghdr *nlh, void *data)
@@ -744,7 +752,7 @@ int mnl_nft_setelem_get(struct mnl_socket *nf_sock, struct nft_set *nls)
 			NLM_F_DUMP|NLM_F_ACK, seq);
 	nft_set_nlmsg_build_payload(nlh, nls);
 
-	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, set_elem_cb, nls);
+	return nft_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, set_elem_cb, nls);
 }
 
 /*

