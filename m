Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A051F4CB3
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Jun 2025 18:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750789425; cv=none; b=a+mCnynlTHJLWow0j44/1oakMIZatskoemNopdXuZvQEZOWPsDTztvBoyVQBF9GNTNiW34tidp1FLDlPNLez5A/249Lzbalj8yfbiuHPcGgLtGOg20e/cWTmKCf3Dm/i6KJEtxHxnjAzgVe99ud5L5wT3f28xVHFL2LSAPcxQzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750789425; c=relaxed/simple;
	bh=s6ACoQdckEcyHVjALEAzFLIC6pmjZ56QieKSa8L4XLk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KnHblS6tepk3zxwPvdolcIFJvKLpGByzuoV4eaQQHQSpua0oKSPM52iYAMNmr4Z8Iw79kymk/GGy8WNsZJKmmNUy0+SIKZo9wdlAaBhXyfaJGfsXMn8dp8ClkrPcp9by+bYstrGwACOuXOnDttlget8NV6wR8ZCzAX2vfeI0T40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DKUSWGBe; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gOpYD071; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DKUSWGBe";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gOpYD071"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 31E1460265; Tue, 24 Jun 2025 20:23:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750789420;
	bh=bOyQZN+ilOU5xrpWuKAhw2bAY+QG/CB2NwFT1VMQDao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DKUSWGBetZXxIcVJSl8lMcCaWuOY+oYujU4rcpHpsKGLUGhFgfbFr8o147/Yp2DNS
	 7vVt5ExDDpQ17sFvUnp+YlhZ1bVjH2HTQPXAtjG2qcIItnyJZ4+ZAl8RG25HPqlfF1
	 PpI8Ufq/NvtsAOD+V+3fPKYgA7t4QG5mWpDJDtrdJBbb2W2OsQ8e6QdOu5865ndB/y
	 FIIhp3Jlib+vJvyfiGoV5S8/gPfoAQJ1wmyz+4Z6wvGPIoQ3gg9QF3hvFf4r9qifpH
	 ICv/2ngYyz8W5dcgnn5mdZNjRWiLGP97cCudyPwP854eHCEdqqsBBLGbkHxzhBaZw9
	 6Z0TYYnrmiLiQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5722A60265;
	Tue, 24 Jun 2025 20:23:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750789416;
	bh=bOyQZN+ilOU5xrpWuKAhw2bAY+QG/CB2NwFT1VMQDao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gOpYD071zVeKBfuTYm0YwT+wCuxQK4NObhqh48RYmf8CdfHCw+qIVvLGDMX85tMgp
	 lPKhSqBcXY5Mt8CB/FC+UGMWR+jNzGHN3mjyzaKZLdpm3PPzzYAiJbEcdxnJnmO1dX
	 vrkZrgdvmRd7rAwuv8T8kl+s80AxVoigaT4H6wNki7RywyzCU2HAs24CwjtTc6sxK/
	 FmkIst3a62n84t7AXn1R09mBY/ByTjyb5BLlbR0qD1WKNRUvqSqYOkF2FhOADUICnX
	 QUzuHDvPpW7Cnf6BvBv9IN2trdMLbM6CK8w6HyXWyMgeVRYaEiOeX0J6PtEYIqQeiL
	 FldApg2RZTvXQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	phil@nwl.cc
Subject: [PATCH nft,v2 2/2] fib: allow to use it in set statements
Date: Tue, 24 Jun 2025 20:23:30 +0200
Message-Id: <20250624182330.673905-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250624182330.673905-1-pablo@netfilter.org>
References: <20250624182330.673905-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow to use fib expression in set statements, eg.

 meta mark set ip saddr . fib daddr check map { 1.2.3.4 . exists : 0x00000001 }

Fixes: 4a75ed32132d ("src: add fib expression")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes.

 src/parser_bison.y          |  1 +
 src/parser_json.c           |  2 +-
 tests/py/inet/fib.t         |  2 ++
 tests/py/inet/fib.t.json    | 45 +++++++++++++++++++++++++++++++++++++
 tests/py/inet/fib.t.payload |  8 +++++++
 5 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index e1afbbb6e56e..f9cc909836bc 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3873,6 +3873,7 @@ primary_stmt_expr	:	symbol_expr			{ $$ = $1; }
 			|	payload_expr			{ $$ = $1; }
 			|	keyword_expr			{ $$ = $1; }
 			|	socket_expr			{ $$ = $1; }
+			|	fib_expr			{ $$ = $1; }
 			|	osf_expr			{ $$ = $1; }
 			|	'('	basic_stmt_expr	')'	{ $$ = $2; }
 			;
diff --git a/src/parser_json.c b/src/parser_json.c
index a8724a0c5af5..62e3a0cfd4f4 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1627,7 +1627,7 @@ static struct expr *json_parse_expr(struct json_ctx *ctx, json_t *root)
 		/* below two are hash expr */
 		{ "jhash", json_parse_hash_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
 		{ "symhash", json_parse_hash_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
-		{ "fib", json_parse_fib_expr, CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
+		{ "fib", json_parse_fib_expr, CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
 		{ "|", json_parse_binop_expr, CTX_F_RHS | CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
 		{ "^", json_parse_binop_expr, CTX_F_RHS | CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
 		{ "&", json_parse_binop_expr, CTX_F_RHS | CTX_F_STMT | CTX_F_PRIMARY | CTX_F_SET_RHS | CTX_F_SES | CTX_F_MAP | CTX_F_CONCAT },
diff --git a/tests/py/inet/fib.t b/tests/py/inet/fib.t
index f9c03b3ad2be..60b77a4ac00a 100644
--- a/tests/py/inet/fib.t
+++ b/tests/py/inet/fib.t
@@ -17,3 +17,5 @@ fib daddr check missing;ok
 fib daddr oif exists;ok;fib daddr check exists
 
 fib daddr check vmap { missing : drop, exists : accept };ok
+
+meta mark set fib daddr check . ct mark map { exists . 0x00000000 : 0x00000001 };ok
diff --git a/tests/py/inet/fib.t.json b/tests/py/inet/fib.t.json
index c2e9d4548a06..14a6249ad9b2 100644
--- a/tests/py/inet/fib.t.json
+++ b/tests/py/inet/fib.t.json
@@ -159,3 +159,48 @@
         }
     }
 ]
+
+# meta mark set fib daddr check . ct mark map { exists . 0x00000000 : 0x00000001 }
+[
+    {
+        "mangle": {
+            "key": {
+                "meta": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "map": {
+                    "data": {
+                        "set": [
+                            [
+                                {
+                                    "concat": [
+                                        true,
+                                        0
+                                    ]
+                                },
+                                1
+                            ]
+                        ]
+                    },
+                    "key": {
+                        "concat": [
+                            {
+                                "fib": {
+                                    "flags": "daddr",
+                                    "result": "check"
+                                }
+                            },
+                            {
+                                "ct": {
+                                    "key": "mark"
+                                }
+                            }
+                        ]
+                    }
+                }
+            }
+        }
+    }
+]
diff --git a/tests/py/inet/fib.t.payload b/tests/py/inet/fib.t.payload
index e09a260cc41e..02d92b57a477 100644
--- a/tests/py/inet/fib.t.payload
+++ b/tests/py/inet/fib.t.payload
@@ -36,3 +36,11 @@ ip test-ip prerouting
 ip test-ip prerouting
   [ fib daddr oif present => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
+
+# meta mark set fib daddr check . ct mark map { exists . 0x00000000 : 0x00000001 }
+        element 00000001 00000000  : 00000001 0 [end]
+ip test-ip prerouting
+  [ fib daddr oif present => reg 1 ]
+  [ ct load mark => reg 9 ]
+  [ lookup reg 1 set __map%d dreg 1 ]
+  [ meta set mark with reg 1 ]
-- 
2.30.2

