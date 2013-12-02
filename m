From: Ana Rey <anarey@gmail.com>
Subject: [PATCH v2] nft: fixed memory leaks in nft_xtables_config_load
Date: Mon,  2 Dec 2013 13:07:17 +0100
Message-ID: <1385986037-4236-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:34011 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab3LBMKL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Dec 2013 07:10:11 -0500
Received: by mail-wi0-f182.google.com with SMTP id en1so4664672wid.3
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Dec 2013 04:10:10 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Those errors are shown with the valgrind tool:

valgrind --leak-check=full xtables -A INPUT -i eth0 -p tcp --dport 80

==7377==
==7377== 16 bytes in 1 blocks are definitely lost in loss record 2 of 14
==7377==    at 0x4C2B514: calloc (vg_replace_malloc.c:593)
==7377==    by 0x5955B02: nft_table_list_alloc (table.c:425)
==7377==    by 0x4186EB: nft_xtables_config_load (nft.c:2427)
==7377==    by 0x4189E6: nft_rule_append (nft.c:991)
==7377==    by 0x413A7D: add_entry.isra.6 (xtables.c:424)
==7377==    by 0x41524A: do_commandx (xtables.c:1176)
==7377==    by 0x4134DC: xtables_main (xtables-standalone.c:72)
==7377==    by 0x5B87994: (below main) (libc-start.c:260)
==7377==
==7377== 16 bytes in 1 blocks are definitely lost in loss record 3 of 14
==7377==    at 0x4C2B514: calloc (vg_replace_malloc.c:593)
==7377==    by 0x5956A32: nft_chain_list_alloc (chain.c:888)
==7377==    by 0x4186F3: nft_xtables_config_load (nft.c:2428)
==7377==    by 0x4189E6: nft_rule_append (nft.c:991)
==7377==    by 0x413A7D: add_entry.isra.6 (xtables.c:424)
==7377==    by 0x41524A: do_commandx (xtables.c:1176)
==7377==    by 0x4134DC: xtables_main (xtables-standalone.c:72)
==7377==    by 0x5B87994: (below main) (libc-start.c:260)

Fix these leaks and consolidate error handling in the exit path of
nft_xtables_config_load
---
v2: Fixed a compilation error. I used a incorrect functions to free a chain iter
list.

 iptables/nft.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 2135b04..9a36a52 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2423,8 +2423,8 @@ int nft_xtables_config_load(struct nft_handle *h, const char *filename,
 {
 	struct nft_table_list *table_list = nft_table_list_alloc();
 	struct nft_chain_list *chain_list = nft_chain_list_alloc();
-	struct nft_table_list_iter *titer;
-	struct nft_chain_list_iter *citer;
+	struct nft_table_list_iter *titer = NULL;
+	struct nft_chain_list_iter *citer = NULL;
 	struct nft_table *table;
 	struct nft_chain *chain;
 	uint32_t table_family, chain_family;
@@ -2440,7 +2440,7 @@ int nft_xtables_config_load(struct nft_handle *h, const char *filename,
 				"Fatal error parsing config file: %s\n",
 				 strerror(errno));
 		}
-		return -1;
+		goto err;
 	}
 
 	/* Stage 1) create tables */
@@ -2463,9 +2463,7 @@ int nft_xtables_config_load(struct nft_handle *h, const char *filename,
 					"table `%s' cannot be create, reason `%s'. Exitting\n",
 					(char *)nft_table_attr_get(table, NFT_TABLE_ATTR_NAME),
 					strerror(errno));
-				nft_table_list_iter_destroy(titer);
-				nft_table_list_free(table_list);
-				return -1;
+				goto err;
 			}
 			continue;
 		}
@@ -2476,7 +2474,7 @@ int nft_xtables_config_load(struct nft_handle *h, const char *filename,
 	nft_table_list_free(table_list);
 
 	if (!found)
-		return -1;
+		goto err;
 
 	/* Stage 2) create chains */
 	citer = nft_chain_list_iter_create(chain_list);
@@ -2497,9 +2495,7 @@ int nft_xtables_config_load(struct nft_handle *h, const char *filename,
 					"chain `%s' cannot be create, reason `%s'. Exitting\n",
 					(char *)nft_chain_attr_get(chain, NFT_CHAIN_ATTR_NAME),
 					strerror(errno));
-				nft_chain_list_iter_destroy(citer);
-				nft_chain_list_free(chain_list);
-				return -1;
+				goto err;
 			}
 			continue;
 		}
@@ -2513,6 +2509,17 @@ int nft_xtables_config_load(struct nft_handle *h, const char *filename,
 	nft_chain_list_free(chain_list);
 
 	return 0;
+
+err:
+	nft_table_list_free(table_list);
+	nft_chain_list_free(chain_list);
+
+	if (titer != NULL)
+		nft_table_list_iter_destroy(titer);
+	if (citer != NULL)
+		nft_chain_list_iter_destroy(citer);
+
+	return -1;
 }
 
 int nft_chain_zero_counters(struct nft_handle *h, const char *chain, 
-- 
1.8.4.rc3

