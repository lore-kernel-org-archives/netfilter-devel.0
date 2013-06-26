From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH 09/21] ct: xml: add extra dir check
Date: Wed, 26 Jun 2013 13:37:07 +0200
Message-ID: <20130626113707.23511.14221.stgit@nfdev.cica.es>
References: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:54679 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751817Ab3FZLhP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:37:15 -0400
In-Reply-To: <20130626113509.23511.14359.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds an extra dir check.

0 means original.
1 means a reply.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/ct.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/expr/ct.c b/src/expr/ct.c
index 61a8fef..3605ecc 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -14,6 +14,7 @@
 #include <arpa/inet.h>
 #include <errno.h>
 #include <linux/netfilter/nf_tables.h>
+#include <linux/netfilter/nf_conntrack_tuple_common.h>
 
 #include "internal.h"
 #include <libmnl/libmnl.h>
@@ -202,6 +203,9 @@ static int nft_rule_expr_ct_xml_parse(struct nft_rule_expr *e, char *xml)
 	if (tmp > UINT8_MAX || tmp < 0 || *endptr)
 		goto err;
 
+	if (tmp != IP_CT_DIR_ORIGINAL && tmp != IP_CT_DIR_REPLY)
+		goto err;
+
 	ct->dir = tmp;
 	e->flags |= (1 << NFT_EXPR_CT_DIR);
 

