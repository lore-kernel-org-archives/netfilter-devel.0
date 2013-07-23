From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [xtables-arptables PATCH v2 4/5] nft: make functions public
Date: Tue, 23 Jul 2013 18:12:59 +0200
Message-ID: <20130723161258.10040.44522.stgit@localhost>
References: <20130723161017.10040.6256.stgit@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62101 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933293Ab3GWQNV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:13:21 -0400
Received: by mail-wi0-f178.google.com with SMTP id k10so3237934wiv.11
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jul 2013 09:13:19 -0700 (PDT)
Received: from [127.0.0.1] (adsl-ull-226-41.46-151.net24.it. [151.46.41.226])
        by mx.google.com with ESMTPSA id f8sm4585764wiv.0.2013.07.23.09.13.17
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Tue, 23 Jul 2013 09:13:18 -0700 (PDT)
In-Reply-To: <20130723161017.10040.6256.stgit@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft.c |   18 +++++++++---------
 iptables/nft.h |   22 ++++++++++++++++++++++
 2 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 589cba7..682c192 100644
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
@@ -210,7 +210,7 @@ struct builtin_table tables[TABLES_MAX] = {
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
@@ -288,7 +288,7 @@ nft_chain_builtin_add(struct nft_handle *h, struct builtin_table *table,
 }
 
 /* find if built-in table already exists */
-static struct builtin_table *
+struct builtin_table *
 nft_table_builtin_find(struct nft_handle *h, const char *table)
 {
 	int i;
@@ -306,7 +306,7 @@ nft_table_builtin_find(struct nft_handle *h, const char *table)
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
index abf0463..877fadc 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -33,6 +33,28 @@ struct nft_handle {
 	struct builtin_table	*tables;
 };
 
+int mnl_talk(struct nft_handle *h, struct nlmsghdr *nlh,
+	     int (*cb)(const struct nlmsghdr *nlh, void *data),
+	     void *data);
+
+int nft_table_builtin_add(struct nft_handle *h, struct builtin_table *_t,
+			  bool dormant);
+
+struct nft_chain *nft_chain_builtin_alloc(struct builtin_table *table,
+					  struct builtin_chain *chain, int policy);
+
+void nft_chain_builtin_add(struct nft_handle *h, struct builtin_table *table,
+			   struct builtin_chain *chain, int policy);
+
+struct builtin_table *nft_table_builtin_find(struct nft_handle *h,
+					     const char *table);
+
+struct builtin_chain *nft_chain_builtin_find(struct builtin_table *t,
+					     const char *chain);
+
+int nft_chain_builtin_init(struct nft_handle *h, const char *table,
+			   const char *chain, int policy);
+
 int nft_init(struct nft_handle *h, struct builtin_table *t, const char *filename);
 void nft_fini(struct nft_handle *h);
 

