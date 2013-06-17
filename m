From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [PATCH v3 1/2] iptables-nftables: function nft_chain_zero_counters
 added.
Date: Mon, 17 Jun 2013 11:26:00 +0200
Message-ID: <20130617092600.2814.15883.stgit@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:46603 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896Ab3FQJ0B (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Jun 2013 05:26:01 -0400
Received: by mail-we0-f175.google.com with SMTP id t59so2177200wes.34
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2013 02:26:00 -0700 (PDT)
Received: from [127.0.0.1] ([46.182.90.24])
        by mx.google.com with ESMTPSA id dz8sm20654890wib.11.2013.06.17.02.25.57
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Mon, 17 Jun 2013 02:25:58 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 iptables/nft.h |    1 +
 2 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 2b191c6..81729b4 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2845,3 +2845,57 @@ int nft_xtables_config_load(struct nft_handle *h, const char *filename,
 	}
 	return 0;
 }
+
+int nft_chain_zero_counters(struct nft_handle *h, const char *chain, const char *table)
+{
+	struct nft_chain_list *list;
+	struct nft_chain_list_iter *iter;
+	struct nft_chain *c;
+	struct nlmsghdr *nlh;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	int ret = 0;
+
+	list = nft_chain_dump(h);
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
+		nlh = nft_chain_nlmsg_build_hdr(buf, NFT_MSG_NEWCHAIN, h->family,
+						NLM_F_ACK, h->seq);
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
+	nft_chain_list_free(list);
+
+	return 1;
+}
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

