Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6474A339B1
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Aug 2024 14:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723041178; cv=none; b=i9BCDhGMpUxe/XKSi454h/jeelLbYEkvlEMZMhbOqBfZo57Ov3D0rx7J2AK1UbUBVcHQOnxebkA4HEV4fMudLSLfTc2CifCUDRt7Bf8qOdIFV0qnMS9xXhQuPgZ1uFp+sgJ2eN70D2dX9cus427PYG6q9K4JFOwsClkMBCuzdM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723041178; c=relaxed/simple;
	bh=VhNcfrYZJVkYjuDubeh9AW1wznyV4NZMp4xOPPlGWVY=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=lWUdkNW0KypqTyRfqMK9U64fXpEeJ/LHUxSzXq4VALeR1U8tfQiZSxRbcguhlvEpVJ8ajUpgHD87+YLI03IKRLm6mVPWEG3dbRuP7a2jGDRN4UYhOfCxf2FB747jrpsuKMltNG5EuwU7TH9Euo1Tm+wsGYyfjaajvR8kRhPv/K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] src: add never expires marker for element timeout
Date: Wed,  7 Aug 2024 16:32:52 +0200
Message-Id: <20240807143252.150702-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow to specify elements that never expire in sets with global
timeout.

    set x {
        typeof ip saddr
        timeout 1m
        elements = { 1.1.1.1 timeout never,
                     2.2.2.2,
                     3.3.3.3 timeout 2m }
    }

in this example above:

 - 1.1.1.1 is a permanent element
 - 2.2.2.2 expires after 1 minute (uses default set timeout)
 - 3.3.3.3 expires after 2 minutes (uses specified timeout override)

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
This is the userspace dependency for:

https://patchwork.ozlabs.org/project/netfilter-devel/list/?series=418393

Note that no updates are required to support for set element timeout
updates.

 src/expression.c   | 11 +++++++++--
 src/parser_bison.y | 29 ++++++++++++++++++++++++++---
 2 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/src/expression.c b/src/expression.c
index 992f51064051..54b539be89d5 100644
--- a/src/expression.c
+++ b/src/expression.c
@@ -25,6 +25,8 @@
 #include <erec.h>
 #include <json.h>
 
+#define NFT_NEVER_EXPIRES      UINT64_MAX
+
 extern const struct expr_ops ct_expr_ops;
 extern const struct expr_ops fib_expr_ops;
 extern const struct expr_ops hash_expr_ops;
@@ -1314,9 +1316,14 @@ static void set_elem_expr_print(const struct expr *expr,
 	}
 	if (expr->timeout) {
 		nft_print(octx, " timeout ");
-		time_print(expr->timeout, octx);
+		if (expr->timeout == NFT_NEVER_EXPIRES)
+			nft_print(octx, "never");
+		else
+			time_print(expr->timeout, octx);
 	}
-	if (!nft_output_stateless(octx) && expr->expiration) {
+	if (!nft_output_stateless(octx) &&
+	    expr->timeout != NFT_NEVER_EXPIRES &&
+	    expr->expiration) {
 		nft_print(octx, " expires ");
 		time_print(expr->expiration, octx);
 	}
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 10105f153aa0..b5a4588fb675 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -45,6 +45,8 @@
 
 #include "parser_bison.h"
 
+#define NFT_NEVER_EXPIRES      UINT64_MAX
+
 void parser_init(struct nft_ctx *nft, struct parser_state *state,
 		 struct list_head *msgs, struct list_head *cmds,
 		 struct scope *top_scope)
@@ -695,7 +697,7 @@ int nft_lex(void *, void *, void *);
 %type <string>			identifier type_identifier string comment_spec
 %destructor { free_const($$); }	identifier type_identifier string comment_spec
 
-%type <val>			time_spec time_spec_or_num_s quota_used
+%type <val>			time_spec time_spec_or_num_s set_elem_time_spec quota_used
 
 %type <expr>			data_type_expr data_type_atom_expr
 %destructor { expr_free($$); }  data_type_expr data_type_atom_expr
@@ -4545,7 +4547,28 @@ set_elem_options	:	set_elem_option
 			|	set_elem_options	set_elem_option
 			;
 
-set_elem_option		:	TIMEOUT			time_spec
+set_elem_time_spec	:	STRING
+			{
+				struct error_record *erec;
+				uint64_t res;
+
+				if (!strcmp("never", $1)) {
+					free_const($1);
+					$$ = NFT_NEVER_EXPIRES;
+					break;
+				}
+
+				erec = time_parse(&@1, $1, &res);
+				free_const($1);
+				if (erec != NULL) {
+					erec_queue(erec, state->msgs);
+					YYERROR;
+				}
+				$$ = res;
+			}
+			;
+
+set_elem_option		:	TIMEOUT		time_spec
 			{
 				$<expr>0->timeout = $2;
 			}
@@ -4660,7 +4683,7 @@ set_elem_stmt		:	COUNTER	close_scope_counter
 			}
 			;
 
-set_elem_expr_option	:	TIMEOUT			time_spec
+set_elem_expr_option	:	TIMEOUT		set_elem_time_spec
 			{
 				$<expr>0->timeout = $2;
 			}
-- 
2.30.2

