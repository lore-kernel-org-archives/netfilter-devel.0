From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 1/6] mxml: add error reference of the top node
Date: Tue, 07 Jan 2014 12:47:16 +0100
Message-ID: <20140107114716.12841.65206.stgit@nfdev.cica.es>
References: <20140107114518.12841.35778.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:56522 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751697AbaAGMsF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:48:05 -0500
In-Reply-To: <20140107114518.12841.35778.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We know the top node we are building. Let the user also know it.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 0 files changed

diff --git a/src/mxml.c b/src/mxml.c
index bd09bb3..bc0f084 100644
--- a/src/mxml.c
+++ b/src/mxml.c
@@ -30,16 +30,19 @@ mxml_node_t *nft_mxml_build_tree(const char *xml, const char *treename,
 	tree = mxmlLoadString(NULL, xml, MXML_OPAQUE_CALLBACK);
 	if (tree == NULL) {
 		err->error = NFT_PARSE_EBADINPUT;
-		err->line = 0;
-		err->column = 0;
 		goto err;
 	}
 
 	if (strcmp(tree->value.opaque, treename) == 0)
 		return tree;
 
+	err->error = NFT_PARSE_EMISSINGNODE;
+	err->node_name = treename;
+
 	mxmlDelete(tree);
 err:
+	err->line = 0;
+	err->column = 0;
 	errno = EINVAL;
 	return NULL;
 }

