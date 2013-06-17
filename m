From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [PATCH v3] iptables-nftables: function nft_chain_zero_counters
 added.
Date: Tue, 18 Jun 2013 00:06:21 +0200
Message-ID: <20130617220621.3327.73213.stgit@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:38053 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab3FQWGX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Jun 2013 18:06:23 -0400
Received: by mail-wg0-f45.google.com with SMTP id j13so2843912wgh.0
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2013 15:06:21 -0700 (PDT)
Received: from [127.0.0.1] ([46.182.90.24])
        by mx.google.com with ESMTPSA id r9sm25117215wik.1.2013.06.17.15.06.19
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Mon, 17 Jun 2013 15:06:20 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Return of error code added

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft.c     |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 iptables/nft.h     |    1 +
 iptables/xtables.c |   27 ++++-------------------
 3 files changed, 67 insertions(+), 22 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 2b191c6..646a8ba 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2845,3 +2845,64 @@ int nft_xtables_config_load(struct nft_handle *h, const char *filename,
 	}
 	return 0;
 }
+
+int nft_chain_zero_counters(struct nft_handle *h, const char *chain, 
+			    const char *table)
+{
+	struct nft_chain_list *list;
+	struct nft_chain_list_iter *iter;
+	struct nft_chain *c;
+	struct nlmsghdr *nlh;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	int ret = 0;
+
+	list = nft_chain_list_get(h);
+	if (list == NULL)
+		goto err;
+
+	iter = nft_chain_list_iter_create(list);
+	if (iter == NULL) {
+		DEBUGP("cannot allocate rule list iterator\n");
+		return 0;
+	}
+
+	c = nft_chain_list_iter_next(iter);
+	while (c != NULL) {
+		const char *chain_name =
+			nft_chain_attr_get(c, NFT_CHAIN_ATTR_NAME);
+		const char *chain_table =
+			nft_chain_attr_get(c, NFT_CHAIN_ATTR_TABLE);
+
+		if (strcmp(table, chain_table) != 0)
+			goto next;
+
+		if (chain != NULL && strcmp(chain, chain_name) != 0)
+			goto next;
+
+		nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_PACKETS, 0);
+		nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_BYTES, 0);
+
+		nft_chain_attr_unset(c, NFT_CHAIN_ATTR_HANDLE);
+
+		nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN,
+						h->family, NLM_F_ACK, h->seq);
+
+		nft_chain_nlmsg_build_payload(nlh, c);
+
+		ret = mnl_talk(h, nlh, NULL, NULL);
+		if (ret < 0)
+			perror("mnl_talk:nft_chain_zero_counters");
+
+next:
+		c = nft_chain_list_iter_next(iter);
+	}
+
+	nft_chain_list_iter_destroy(iter);
+
+err:
+	nft_chain_list_free(list);
+
+	/* the core expects 1 for success and 0 for error */
+	return ret == 0 ? 1 : 0;
+}
+
diff --git a/iptables/nft.h b/iptables/nft.h
index 8d5881d..082260e 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -42,6 +42,7 @@ int nft_chain_save(struct nft_handle *h, struct nft_chain_list *list, const char
 int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *table);
 int nft_chain_user_del(struct nft_handle *h, const char *chain, const char *table);
 int nft_chain_user_rename(struct nft_handle *h, const char *chain, const char *table, const char *newname);
+int nft_chain_zero_counters(struct nft_handle *h, const char *chain, const char *table);
 
 /*
  * Operations with rule-set.
diff --git a/iptables/xtables.c b/iptables/xtables.c
index a06988e..e94dbf2 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -549,14 +549,6 @@ check_entry(const char *chain, const char *table,
 }
 
 static int
-zero_entries(const xt_chainlabel chain, int verbose,
-	     struct xtc_handle *handle)
-{
-	/* XXX iterate over chains and reset counters */
-	return 1;
-}
-
-static int
 list_entries(struct nft_handle *h, const char *chain, const char *table,
 	     int rulenum, int verbose, int numeric, int expanded,
 	     int linenumbers)
@@ -1171,8 +1163,7 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
 		ret = nft_rule_flush(h, chain, *table);
 		break;
 	case CMD_ZERO:
-		/* FIXME */
-//		ret = zero_entries(chain, cs.options&OPT_VERBOSE, *handle);
+		ret = nft_chain_zero_counters(h, chain, *table);
 		break;
 	case CMD_ZERO_NUM:
 		/* FIXME */
@@ -1181,29 +1172,21 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
 	case CMD_LIST:
 	case CMD_LIST|CMD_ZERO:
 	case CMD_LIST|CMD_ZERO_NUM:
-		/* FIXME */
 		ret = list_entries(h, chain, *table,
 				   rulenum,
 				   cs.options&OPT_VERBOSE,
 				   cs.options&OPT_NUMERIC,
 				   cs.options&OPT_EXPANDED,
 				   cs.options&OPT_LINENUMBERS);
-/*		if (ret && (command & CMD_ZERO))
-			ret = zero_entries(chain,
-					   cs.options&OPT_VERBOSE, *handle);
-		if (ret && (command & CMD_ZERO_NUM))
-			ret = iptc_zero_counter(chain, rulenum, *handle); */
+		if (ret && (command & CMD_ZERO))
+			ret = nft_chain_zero_counters(h, chain, *table);
 		break;
 	case CMD_LIST_RULES:
 	case CMD_LIST_RULES|CMD_ZERO:
 	case CMD_LIST_RULES|CMD_ZERO_NUM:
-		/* FIXME */
 		ret = list_rules(h, chain, *table, rulenum, cs.options&OPT_VERBOSE);
-/*		if (ret && (command & CMD_ZERO))
-			ret = zero_entries(chain,
-					   cs.options&OPT_VERBOSE, *handle);
-		if (ret && (command & CMD_ZERO_NUM))
-			ret = iptc_zero_counter(chain, rulenum, *handle); */
+		if (ret && (command & CMD_ZERO))
+			ret = nft_chain_zero_counters(h, chain, *table);
 		break;
 	case CMD_NEW_CHAIN:
 		ret = nft_chain_user_add(h, chain, *table);

