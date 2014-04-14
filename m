From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 5/8] netlink: add netlink_delinearize_table() func
Date: Mon, 14 Apr 2014 12:17:30 +0200
Message-ID: <20140414101730.5018.95044.stgit@nfdev.cica.es>
References: <20140414101634.5018.86819.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:42777 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752045AbaDNKRc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 06:17:32 -0400
In-Reply-To: <20140414101634.5018.86819.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This code is suitable to be reusable.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/netlink.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 91f1304..f0ea6ca 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -656,9 +656,9 @@ void netlink_dump_table(struct nft_table *nlt)
 #endif
 }
 
-static int list_table_cb(struct nft_table *nlt, void *arg)
+static struct table *netlink_delinearize_table(struct netlink_ctx *ctx,
+					       struct nft_table *nlt)
 {
-	struct netlink_ctx *ctx = arg;
 	struct table *table;
 
 	netlink_dump_table(nlt);
@@ -669,6 +669,15 @@ static int list_table_cb(struct nft_table *nlt, void *arg)
 		xstrdup(nft_table_attr_get_str(nlt, NFT_TABLE_ATTR_NAME));
 	list_add_tail(&table->list, &ctx->list);
 
+	return table;
+}
+
+static int list_table_cb(struct nft_table *nlt, void *arg)
+{
+	struct netlink_ctx *ctx = arg;
+
+	netlink_delinearize_table(ctx, nlt);
+
 	return 0;
 }
 

