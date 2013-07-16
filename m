From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [xtables-arptables PATCH 4/4] nft: make functions public
Date: Wed, 17 Jul 2013 00:31:04 +0200
Message-ID: <20130716223104.13253.37312.stgit@nftables>
References: <20130716222925.13253.93123.stgit@nftables>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:65020 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755780Ab3GVOcU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Jul 2013 10:32:20 -0400
Received: by mail-ea0-f171.google.com with SMTP id m14so3866685eaj.2
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jul 2013 07:32:19 -0700 (PDT)
Received: from [127.0.1.1] ([37.77.121.31])
        by mx.google.com with ESMTPSA id n45sm51279230eew.1.2013.07.22.07.32.17
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 22 Jul 2013 07:32:19 -0700 (PDT)
In-Reply-To: <20130716222925.13253.93123.stgit@nftables>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft.c |   18 +++++++++---------
 iptables/nft.h |   22 ++++++++++++++++++++++
 2 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 198c41e..7224273 100644
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
@@ -210,7 +210,7 @@ static struct builtin_table tables[TABLES_MAX] = {
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
index 39ed7c0..3c52b3b 100644
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
 int nft_init(struct nft_handle *h);
 void nft_fini(struct nft_handle *h);
 

