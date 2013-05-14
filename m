From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables PATCH 2/6] xtables: destroy list iterator relevantly
Date: Tue, 14 May 2013 13:52:03 +0300
Message-ID: <1368528727-10127-3-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <519216B6.7060701@linux.intel.com>
 <1368528727-10127-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46611 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757037Ab3ENKwP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 May 2013 06:52:15 -0400
In-Reply-To: <1368528727-10127-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index f5d96bc..574383d 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1119,6 +1119,7 @@ next:
 		c = nft_chain_list_iter_next(iter);
 	}
 
+	nft_chain_list_iter_destroy(iter);
 	nft_chain_list_free(list);
 
 	return 1;
@@ -1248,7 +1249,7 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table)
 {
 	int ret;
 	struct nft_chain_list *list;
-	struct nft_chain_list_iter *iter;
+	struct nft_chain_list_iter *iter = NULL;
 	struct nft_chain *c;
 
 	nft_fn = nft_rule_flush;
@@ -1285,6 +1286,7 @@ next:
 	}
 
 err:
+	nft_chain_list_iter_destroy(iter);
 	nft_chain_list_free(list);
 
 	/* the core expects 1 for success and 0 for error */
@@ -1356,7 +1358,7 @@ static bool nft_chain_builtin(struct nft_chain *c)
 int nft_chain_user_del(struct nft_handle *h, const char *chain, const char *table)
 {
 	struct nft_chain_list *list;
-	struct nft_chain_list_iter *iter;
+	struct nft_chain_list_iter *iter = NULL;
 	struct nft_chain *c;
 	int ret = 0;
 	int deleted_ctr = 0;
@@ -1398,6 +1400,7 @@ next:
 	}
 
 err:
+	nft_chain_list_iter_destroy(iter);
 	nft_chain_list_free(list);
 
 	/* chain not found */
@@ -1580,6 +1583,7 @@ bool nft_table_find(struct nft_handle *h, const char *tablename)
 		t = nft_table_list_iter_next(iter);
 	}
 
+	nft_table_list_iter_destroy(iter);
 	nft_table_list_free(list);
 
 err:
@@ -1617,6 +1621,7 @@ int nft_for_each_table(struct nft_handle *h,
 		t = nft_table_list_iter_next(iter);
 	}
 
+	nft_table_list_iter_destroy(iter);
 	nft_table_list_free(list);
 
 err:
@@ -2521,6 +2526,7 @@ next:
 		c = nft_chain_list_iter_next(iter);
 	}
 
+	nft_chain_list_iter_destroy(iter);
 	nft_chain_list_free(list);
 
 	return 1;
@@ -2575,6 +2581,7 @@ next:
 		c = nft_chain_list_iter_next(iter);
 	}
 
+	nft_chain_list_iter_destroy(iter);
 	return 1;
 }
 
@@ -2615,6 +2622,7 @@ next:
 		c = nft_chain_list_iter_next(iter);
 	}
 
+	nft_chain_list_iter_destroy(iter);
 	nft_chain_list_free(list);
 
 	return 1;
@@ -2821,6 +2829,7 @@ int nft_xtables_config_load(struct nft_handle *h, const char *filename,
 		xtables_config_perror(flags, "table `%s' has been created\n",
 			(char *)nft_table_attr_get(table, NFT_TABLE_ATTR_NAME));
 	}
+	nft_table_list_iter_destroy(titer);
 
 	/* Stage 2) create chains */
 	citer = nft_chain_list_iter_create(chain_list);
@@ -2846,5 +2855,6 @@ int nft_xtables_config_load(struct nft_handle *h, const char *filename,
 			(char *)nft_chain_attr_get(chain, NFT_CHAIN_ATTR_NAME),
 			(char *)nft_chain_attr_get(chain, NFT_CHAIN_ATTR_TABLE));
 	}
+	nft_chain_list_iter_destroy(citer);
 	return 0;
 }
-- 
1.8.2.1

