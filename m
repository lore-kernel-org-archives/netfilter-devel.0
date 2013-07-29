From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables PATCH 4/5] nft: export functions reusability
Date: Mon, 29 Jul 2013 11:24:16 +0300
Message-ID: <1375086256-3994-1-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1374836719-27596-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11047 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284Ab3G2IYm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Jul 2013 04:24:42 -0400
In-Reply-To: <1374836719-27596-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Giuseppe Longo <giuseppelng@gmail.com>

This permit to reuse some functions in other tool (like arptables)

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---

Hi Giuseppe,

For some reason patch 4 does not apply properly. And the conflict is a non-sense, I mean:
I don't see any conflict. With git am --reject <your patch>,  the iptables/nft.c.rej looks nothing special.
So I regenerated your patch. Please Pablo use this one.

Tomasz

 iptables/nft.c | 20 ++++++++++----------
 iptables/nft.h | 25 +++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 1b91691..16380d1 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -53,9 +53,9 @@
 
 static void *nft_fn;
 
-static int mnl_talk(struct nft_handle *h, struct nlmsghdr *nlh,
-		    int (*cb)(const struct nlmsghdr *nlh, void *data),
-		    void *data)
+int mnl_talk(struct nft_handle *h, struct nlmsghdr *nlh,
+	     int (*cb)(const struct nlmsghdr *nlh, void *data),
+	     void *data)
 {
 	int ret;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
@@ -210,7 +210,7 @@ struct builtin_table xtables_ipv4[TABLES_MAX] = {
 	},
 };
 
-static int
+int
 nft_table_builtin_add(struct nft_handle *h, struct builtin_table *_t,
 			bool dormant)
 {
@@ -242,7 +242,7 @@ nft_table_builtin_add(struct nft_handle *h, struct builtin_table *_t,
 	return ret;
 }
 
-static struct nft_chain *
+struct nft_chain *
 nft_chain_builtin_alloc(struct builtin_table *table,
 			struct builtin_chain *chain, int policy)
 {
@@ -262,7 +262,7 @@ nft_chain_builtin_alloc(struct builtin_table *table,
 	return c;
 }
 
-static void
+void
 nft_chain_builtin_add(struct nft_handle *h, struct builtin_table *table,
 		      struct builtin_chain *chain, int policy)
 {
@@ -288,8 +288,8 @@ nft_chain_builtin_add(struct nft_handle *h, struct builtin_table *table,
 }
 
 /* find if built-in table already exists */
-static struct builtin_table
-*nft_table_builtin_find(struct nft_handle *h, const char *table)
+struct builtin_table *
+nft_table_builtin_find(struct nft_handle *h, const char *table)
 {
 	int i;
 	bool found = false;
@@ -306,7 +306,7 @@ static struct builtin_table
 }
 
 /* find if built-in chain already exists */
-static struct builtin_chain *
+struct builtin_chain *
 nft_chain_builtin_find(struct builtin_table *t, const char *chain)
 {
 	int i;
@@ -343,7 +343,7 @@ __nft_chain_builtin_init(struct nft_handle *h,
 	}
 }
 
-static int
+int
 nft_chain_builtin_init(struct nft_handle *h, const char *table,
 		       const char *chain, int policy)
 {
diff --git a/iptables/nft.h b/iptables/nft.h
index f3317c9..734b852 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -35,6 +35,31 @@ struct nft_handle {
 
 extern struct builtin_table xtables_ipv4[TABLES_MAX];
 
+int mnl_talk(struct nft_handle *h, struct nlmsghdr *nlh,
+	     int (*cb)(const struct nlmsghdr *nlh, void *data),
+	     void *data);
+
+int nft_table_builtin_add(struct nft_handle *h, struct builtin_table *_t,
+			  bool dormant);
+
+struct nft_chain *
+nft_chain_builtin_alloc(struct builtin_table *table,
+			struct builtin_chain *chain, int policy);
+
+void
+nft_chain_builtin_add(struct nft_handle *h, struct builtin_table *table,
+		      struct builtin_chain *chain, int policy);
+
+struct builtin_table *
+nft_table_builtin_find(struct nft_handle *h, const char *table);
+
+struct builtin_chain *
+nft_chain_builtin_find(struct builtin_table *t, const char *chain);
+
+int
+nft_chain_builtin_init(struct nft_handle *h, const char *table,
+		       const char *chain, int policy);
+
 int nft_init(struct nft_handle *h, struct builtin_table *t);
 void nft_fini(struct nft_handle *h);
 
-- 
1.8.3.2

