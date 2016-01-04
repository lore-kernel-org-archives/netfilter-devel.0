From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 3/4] rule: delete extra space in sets printing
Date: Mon, 04 Jan 2016 13:18:37 +0100
Message-ID: <145190991706.22285.17585254866421222372.stgit@r2d2.cica.es>
References: <145190990642.22285.2420592085262978551.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:47723 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751603AbcADMSq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jan 2016 07:18:46 -0500
In-Reply-To: <145190990642.22285.2420592085262978551.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The extra space is printed when sets are printed in tabulated format.
However, the space is still required in printing in plain format (ie, monitor).

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 0 files changed

diff --git a/src/rule.c b/src/rule.c
index c0e45aa..ab39513 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -267,7 +267,10 @@ static void set_print_declaration(const struct set *set,
 	if (opts->table != NULL)
 		printf(" %s", opts->table);
 
-	printf(" %s { %s", set->handle.set, opts->nl);
+	printf(" %s {%s", set->handle.set, opts->nl);
+
+	if (!strcmp(opts->nl, ""))
+		printf(" ");
 
 	printf("%s%stype %s", opts->tab, opts->tab, set->keytype->name);
 	if (set->flags & SET_F_MAP)

