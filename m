From: David Fabian <david.fabian@cldn.cz>
Subject: question about UNDEFINE/REDEFINE
Date: Mon, 22 Jan 2018 14:53:09 +0100
Message-ID: <3622208.jy4NlOniyd@voxel>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart4411373.MzzAX4Gdtr"
Content-Transfer-Encoding: 7Bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailalternative.uvtmail.cz ([109.205.75.52]:43375 "EHLO
        mail.hosting.cldn.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750955AbeAVN7e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jan 2018 08:59:34 -0500
Received: from voxel.localnet (linux.uvt.cz [178.17.1.67])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: fabian@bosson.cz)
        by mail.hosting.cldn.cz (Postfix) with ESMTPSA id 4069120359
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jan 2018 14:53:09 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.

--nextPart4411373.MzzAX4Gdtr
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

Hello,

we have a firewall written in bash (using iptables) that is organized by 
customer VLANs. Each VLAN has its own set of bash variables holding things 
like uplink iface names, gateway IPs, etc. We want to rewrite the firewall to 
nftables but are stuck on the fact that nft variables cannot be overridden in 
the same scope. We have each VLAN configuration in a separate file containing 
pre/post-routing, input, output and forward rules,and we include those files to 
a master firewall configuration. One solution is to rename all the variables 
with some VLAN specific (pre/su)ffix. But that is cumbersome.

I have made a small patch to nft which adds two new keywords - undefine and 
redefine. undefine simply undefines a variable from the current scope. redefine 
allows one to change a variable definition. The patch works against the latest 
fedora nft (version 0.7) but I believe it should work against master as well. 
I don't know how to properly send the patch to the project so I am attaching 
it here. I would like to know your opinion.

-- 
Best regards,

David Fabian
Cluster Design, s.r.o.

--nextPart4411373.MzzAX4Gdtr
Content-Disposition: attachment; filename="0001-Added-undefine-redefine-keywords.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="utf-8"; name="0001-Added-undefine-redefine-keywords.patch"

>From 43abd3a12670b54739f0a7f6500aa315b3905f08 Mon Sep 17 00:00:00 2001
From: David Fabian <david.fabian@bosson.cz>
Date: Mon, 22 Jan 2018 14:02:11 +0100
Subject: [PATCH] Added undefine/redefine keywords

---
 include/rule.h     |  1 +
 src/parser_bison.y | 23 +++++++++++++++++++++++
 src/rule.c         | 16 ++++++++++++++++
 src/scanner.l      |  2 ++
 4 files changed, 42 insertions(+)

diff --git a/include/rule.h b/include/rule.h
index b9b4a19..4524b4d 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -80,6 +80,7 @@ struct symbol {
 
 extern void symbol_bind(struct scope *scope, const char *identifier,
 			struct expr *expr);
+extern int symbol_unbind(struct scope *scope, const char *identifier);
 extern struct symbol *symbol_lookup(const struct scope *scope,
 				    const char *identifier);
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index deaaf06..4cc1b47 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -167,6 +167,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
 
 %token INCLUDE			"include"
 %token DEFINE			"define"
+%token REDEFINE			"redefine"
+%token UNDEFINE			"undefine"
 
 %token FIB			"fib"
 
@@ -661,6 +663,27 @@ common_block		:	INCLUDE		QUOTED_STRING	stmt_seperator
 				symbol_bind(scope, $2, $4);
 				xfree($2);
 			}
+			|       REDEFINE                identifier      '='     initializer_expr        stmt_seperator
+			{
+				struct scope *scope = current_scope(state);
+
+				/* ignore missing identifier */
+				symbol_unbind(scope, $2);
+				symbol_bind(scope, $2, $4);
+				xfree($2);
+			}
+			|       UNDEFINE                identifier      stmt_seperator
+			{
+				struct scope *scope = current_scope(state);
+
+				if (symbol_unbind(scope, $2) < 0) {
+					erec_queue(error(&@2, "undefined symbol '%s'", $2),
+						   state->msgs);
+					YYERROR;
+			}
+
+				xfree($2);
+			}
 			|	error		stmt_seperator
 			{
 				if (++state->nerrs == max_errors)
diff --git a/src/rule.c b/src/rule.c
index f1bb6cf..f97c8e5 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -447,6 +447,22 @@ void symbol_bind(struct scope *scope, const char *identifier, struct expr *expr)
 	list_add_tail(&sym->list, &scope->symbols);
 }
 
+int symbol_unbind(struct scope *scope, const char *identifier)
+{
+	struct symbol *sym;
+
+	if ((sym = symbol_lookup(scope, identifier)) == NULL)
+	{
+		return -1;
+	}
+	list_del(&sym->list);
+	xfree(sym->identifier);
+	expr_free(sym->expr);
+	xfree(sym);
+	return 0;
+}
+
+
 struct symbol *symbol_lookup(const struct scope *scope, const char *identifier)
 {
 	struct symbol *sym;
diff --git a/src/scanner.l b/src/scanner.l
index 625023f..2000554 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -231,6 +231,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 "include"		{ return INCLUDE; }
 "define"		{ return DEFINE; }
+"redefine"		{ return REDEFINE; }
+"undefine"		{ return UNDEFINE; }
 
 "describe"		{ return DESCRIBE; }
 
-- 
2.14.3


--nextPart4411373.MzzAX4Gdtr--

