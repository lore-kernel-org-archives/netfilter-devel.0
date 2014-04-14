From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 6/8] netlink: refactorize set_elem conversion from netlink
Date: Mon, 14 Apr 2014 12:17:35 +0200
Message-ID: <20140414101735.5018.72797.stgit@nfdev.cica.es>
References: <20140414101634.5018.86819.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:42784 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752045AbaDNKRh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 06:17:37 -0400
In-Reply-To: <20140414101634.5018.86819.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Lets refactorize set_elem handling.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/netlink.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index f0ea6ca..84f2b7e 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -953,11 +953,10 @@ int netlink_delete_setelems(struct netlink_ctx *ctx, const struct handle *h,
 	return err;
 }
 
-static int list_setelem_cb(struct nft_set_elem *nlse, void *arg)
+static int netlink_delinearize_setelem(struct nft_set_elem *nlse,
+				       struct set *set)
 {
 	struct nft_data_delinearize nld;
-	struct netlink_ctx *ctx = arg;
-	struct set *set = ctx->set;
 	struct expr *expr, *data;
 	uint32_t flags = 0;
 
@@ -1001,6 +1000,12 @@ out:
 	return 0;
 }
 
+static int list_setelem_cb(struct nft_set_elem *nlse, void *arg)
+{
+	struct netlink_ctx *ctx = arg;
+	return netlink_delinearize_setelem(nlse, ctx->set);
+}
+
 extern void interval_map_decompose(struct expr *set);
 
 int netlink_get_setelems(struct netlink_ctx *ctx, const struct handle *h,

