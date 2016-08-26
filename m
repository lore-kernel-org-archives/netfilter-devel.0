From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH iptables v3 2/2] xtables-compat: add rule cache
Date: Fri, 26 Aug 2016 18:58:44 +0200
Message-ID: <20160826165844.6849-2-pablombg@gmail.com>
References: <20160826165844.6849-1-pablombg@gmail.com>
Cc: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33865 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754684AbcHZQ7X (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Aug 2016 12:59:23 -0400
Received: by mail-wm0-f65.google.com with SMTP id q128so64568wma.1
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Aug 2016 09:59:22 -0700 (PDT)
In-Reply-To: <20160826165844.6849-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a cache of rules within the nft handle. This feature is
useful since the whole ruleset was brought from the kernel for every
chain during listing operations. In addition with the new checks of
ruleset compatibility, the rule list is loaded one more time.

Now all the operations causing changes in the ruleset must invalidate
the cache, a function called flush_rule_cache has been introduced for
this purpose.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---

Changes in V3:
    - Simplify code.
    - Update commit message.

 iptables/nft.c | 36 ++++++++++++++++++++++++------------
 iptables/nft.h |  1 +
 2 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index f1f0d9d..fee91bc 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -780,8 +780,18 @@ int nft_init(struct nft_handle *h, struct builtin_table *t)
 	return 0;
 }
 
+static void flush_rule_cache(struct nft_handle *h)
+{
+	if (!h->rule_cache)
+		return;
+
+	nftnl_rule_list_free(h->rule_cache);
+	h->rule_cache = NULL;
+}
+
 void nft_fini(struct nft_handle *h)
 {
+	flush_rule_cache(h);
 	mnl_socket_close(h->nl);
 	free(mnl_nlmsg_batch_head(h->batch));
 	mnl_nlmsg_batch_stop(h->batch);
@@ -1121,6 +1131,7 @@ nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
 	if (batch_rule_add(h, type, r) < 0)
 		nftnl_rule_free(r);
 
+	flush_rule_cache(h);
 	return 1;
 }
 
@@ -1284,6 +1295,9 @@ static struct nftnl_rule_list *nft_rule_list_get(struct nft_handle *h)
 	struct nftnl_rule_list *list;
 	int ret;
 
+	if (h->rule_cache)
+		return h->rule_cache;
+
 	list = nftnl_rule_list_alloc();
 	if (list == NULL)
 		return 0;
@@ -1297,6 +1311,7 @@ static struct nftnl_rule_list *nft_rule_list_get(struct nft_handle *h)
 		return NULL;
 	}
 
+	h->rule_cache = list;
 	return list;
 }
 
@@ -1333,7 +1348,6 @@ next:
 	}
 
 	nftnl_rule_list_iter_destroy(iter);
-	nftnl_rule_list_free(list);
 
 	/* the core expects 1 for success and 0 for error */
 	return 1;
@@ -1396,6 +1410,7 @@ next:
 	}
 
 	nftnl_chain_list_iter_destroy(iter);
+	flush_rule_cache(h);
 err:
 	nftnl_chain_list_free(list);
 
@@ -1829,8 +1844,6 @@ int nft_rule_check(struct nft_handle *h, const char *chain,
 	if (ret == 0)
 		errno = ENOENT;
 
-	nftnl_rule_list_free(list);
-
 	return ret;
 }
 
@@ -1855,7 +1868,7 @@ int nft_rule_delete(struct nft_handle *h, const char *chain,
 	} else
 		errno = ENOENT;
 
-	nftnl_rule_list_free(list);
+	flush_rule_cache(h);
 
 	return ret;
 }
@@ -1879,6 +1892,7 @@ nft_rule_add(struct nft_handle *h, const char *chain,
 		return 0;
 	}
 
+	flush_rule_cache(h);
 	return 1;
 }
 
@@ -1908,7 +1922,7 @@ int nft_rule_insert(struct nft_handle *h, const char *chain,
 			r = nft_rule_find(h, list, chain, table, data,
 					  rulenum - 1);
 			if (r != NULL) {
-				nftnl_rule_list_free(list);
+				flush_rule_cache(h);
 				return nft_rule_append(h, chain, table, data,
 						       0, verbose);
 			}
@@ -1920,12 +1934,12 @@ int nft_rule_insert(struct nft_handle *h, const char *chain,
 		handle = nftnl_rule_get_u64(r, NFTNL_RULE_HANDLE);
 		DEBUGP("adding after rule handle %"PRIu64"\n", handle);
 
-		nftnl_rule_list_free(list);
+		flush_rule_cache(h);
 	}
 
 	return nft_rule_add(h, chain, table, data, handle, verbose);
 err:
-	nftnl_rule_list_free(list);
+	flush_rule_cache(h);
 	return 0;
 }
 
@@ -1953,7 +1967,7 @@ int nft_rule_delete_num(struct nft_handle *h, const char *chain,
 	} else
 		errno = ENOENT;
 
-	nftnl_rule_list_free(list);
+	flush_rule_cache(h);
 
 	return ret;
 }
@@ -1983,7 +1997,7 @@ int nft_rule_replace(struct nft_handle *h, const char *chain,
 	} else
 		errno = ENOENT;
 
-	nftnl_rule_list_free(list);
+	flush_rule_cache(h);
 
 	return ret;
 }
@@ -2037,8 +2051,6 @@ next:
 
 	nftnl_rule_list_iter_destroy(iter);
 err:
-	nftnl_rule_list_free(list);
-
 	if (ret == 0)
 		errno = ENOENT;
 
@@ -2266,7 +2278,7 @@ int nft_rule_zero_counters(struct nft_handle *h, const char *chain,
 			       false);
 
 error:
-	nftnl_rule_list_free(list);
+	flush_rule_cache(h);
 
 	return ret;
 }
diff --git a/iptables/nft.h b/iptables/nft.h
index f5449db..4126593 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -35,6 +35,7 @@ struct nft_handle {
 	struct mnl_nlmsg_batch	*batch;
 	struct nft_family_ops	*ops;
 	struct builtin_table	*tables;
+	struct nftnl_rule_list	*rule_cache;
 	bool			restore;
 	bool			batch_support;
 };
-- 
2.9.3

