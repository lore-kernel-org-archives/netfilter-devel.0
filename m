Return-Path: <SRS0=yhqN=4H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7BFEC34056
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Feb 2020 20:18:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9173724654
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Feb 2020 20:18:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgBSUSC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Feb 2020 15:18:02 -0500
Received: from correo.us.es ([193.147.175.20]:57074 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbgBSUSC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Feb 2020 15:18:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8BA0D6CB60
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Feb 2020 21:17:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7DA4FDA3C3
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Feb 2020 21:17:59 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 733ACDA3C2; Wed, 19 Feb 2020 21:17:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8905DDA7B6
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Feb 2020 21:17:57 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 19 Feb 2020 21:17:57 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 73D8B42EF52A
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Feb 2020 21:17:57 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2,v2] mnl: do not use expr->identifier to fetch device name
Date:   Wed, 19 Feb 2020 21:17:55 +0100
Message-Id: <20200219201755.1186617-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This string might not be nul-terminated, resulting in spurious errors
when adding netdev chains.

Fixes: 3fdc7541fba0 ("src: add multidevice support for netdev chain")
Fixes: 92911b362e90 ("src: add support to add flowtables")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: Use constant expression from flowtable_expr_member, otherwise
    expr->len is unset.

 src/mnl.c          | 33 +++++++++++++++++++++++++++++----
 src/parser_bison.y |  6 +++---
 2 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index 4f42795e0f12..bca5add0f8eb 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -26,6 +26,7 @@
 
 #include <mnl.h>
 #include <string.h>
+#include <net/if.h>
 #include <sys/socket.h>
 #include <arpa/inet.h>
 #include <fcntl.h>
@@ -609,7 +610,9 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 {
 	int priority, policy, i = 0;
 	struct nftnl_chain *nlc;
+	unsigned int ifname_len;
 	const char **dev_array;
+	char ifname[IFNAMSIZ];
 	struct nlmsghdr *nlh;
 	struct expr *expr;
 	int dev_array_len;
@@ -635,7 +638,12 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 			dev_array = xmalloc(sizeof(char *) * 8);
 			dev_array_len = 8;
 			list_for_each_entry(expr, &cmd->chain->dev_expr->expressions, list) {
-				dev_array[i++] = expr->identifier;
+				ifname_len = div_round_up(expr->len, BITS_PER_BYTE);
+				memset(ifname, 0, sizeof(ifname));
+				mpz_export_data(ifname, expr->value,
+						BYTEORDER_HOST_ENDIAN,
+						ifname_len);
+				dev_array[i++] = xstrdup(ifname);
 				if (i == dev_array_len) {
 					dev_array_len *= 2;
 					dev_array = xrealloc(dev_array,
@@ -650,6 +658,10 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 				nftnl_chain_set_data(nlc, NFTNL_CHAIN_DEVICES, dev_array,
 						     sizeof(char *) * dev_array_len);
 
+			i = 0;
+			while (dev_array[i] != NULL)
+				xfree(dev_array[i++]);
+
 			xfree(dev_array);
 		}
 	}
@@ -1565,7 +1577,9 @@ int mnl_nft_flowtable_add(struct netlink_ctx *ctx, struct cmd *cmd,
 			  unsigned int flags)
 {
 	struct nftnl_flowtable *flo;
+	unsigned int ifname_len;
 	const char **dev_array;
+	char ifname[IFNAMSIZ];
 	struct nlmsghdr *nlh;
 	int i = 0, len = 1;
 	struct expr *expr;
@@ -1586,13 +1600,24 @@ int mnl_nft_flowtable_add(struct netlink_ctx *ctx, struct cmd *cmd,
 	list_for_each_entry(expr, &cmd->flowtable->dev_expr->expressions, list)
 		len++;
 
-	dev_array = calloc(len, sizeof(char *));
-	list_for_each_entry(expr, &cmd->flowtable->dev_expr->expressions, list)
-		dev_array[i++] = expr->identifier;
+	dev_array = xmalloc(sizeof(char *) * len);
+
+	list_for_each_entry(expr, &cmd->flowtable->dev_expr->expressions, list) {
+		ifname_len = div_round_up(expr->len, BITS_PER_BYTE);
+		memset(ifname, 0, sizeof(ifname));
+		mpz_export_data(ifname, expr->value, BYTEORDER_HOST_ENDIAN,
+				ifname_len);
+		dev_array[i++] = xstrdup(ifname);
+	}
 
 	dev_array[i] = NULL;
 	nftnl_flowtable_set_data(flo, NFTNL_FLOWTABLE_DEVICES,
 				 dev_array, sizeof(char *) * len);
+
+	i = 0;
+	while (dev_array[i] != NULL)
+		xfree(dev_array[i++]);
+
 	free(dev_array);
 
 	netlink_dump_flowtable(flo, ctx);
diff --git a/src/parser_bison.y b/src/parser_bison.y
index ad512cdbb4c2..fd00b40a104a 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1909,9 +1909,9 @@ flowtable_list_expr	:	flowtable_expr_member
 
 flowtable_expr_member	:	STRING
 			{
-				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
-						       current_scope(state),
-						       $1);
+				$$ = constant_expr_alloc(&@$, &string_type,
+							 BYTEORDER_HOST_ENDIAN,
+							 strlen($1) * BITS_PER_BYTE, $1);
 				xfree($1);
 			}
 			;
-- 
2.11.0

