Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 426C8C6FA82
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Sep 2022 08:01:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiIVIB0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Sep 2022 04:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbiIVIBZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Sep 2022 04:01:25 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324A12034A
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Sep 2022 01:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=y8wUficPcqnUzQdiDwbfIngUyZb1rS//ofruSGAjyJE=; b=g5qtgyB7bVKWS9EVVWLblyEBKJ
        yV53bOntP2b1BAHJXPJg0pw6jY818XwKRMYIhPLDKulqbyn15KSNHJ/g89Ua25zm0huwMZvcVwv5m
        SPo8hnsknjKPwaapcPrgnlTZJWSDM/RfiRInaw0QLgnsUobUJjiP0F2IwrTj8iCrIHYo3tRxlOc/v
        R3DzpL7hYdTmZPeo512mSKYZUOk/yQiyi8XpkuDiq5lEeRHS7VonLy5Fe0OljS/Ua24zDdBtkYdqS
        3DG+AqlDIrKGR7XQl0rRpzJLXJobLEk97OU/fC82YqgpCUykeyGJw2pCs8ukO27Uco5Rmt2sIum8s
        HuEidFtQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1obH97-007caZ-Oc
        for netfilter-devel@vger.kernel.org; Thu, 22 Sep 2022 09:01:21 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH] doc, src: make some spelling and grammatical improvements
Date:   Thu, 22 Sep 2022 09:00:42 +0100
Message-Id: <20220922080042.4064979-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fix a couple of spelling mistakes:

  'expresion' -> 'expression'

and correct some non-native usages:

  'allows to' -> 'allows one to'

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 doc/libnftables-json.adoc  |  2 +-
 doc/libnftables.adoc       | 10 +++++-----
 doc/nft.txt                |  6 +++---
 doc/primary-expression.txt |  4 ++--
 doc/statements.txt         |  6 +++---
 src/evaluate.c             |  4 ++--
 6 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/doc/libnftables-json.adoc b/doc/libnftables-json.adoc
index 9cc17ff26306..bb59945fc510 100644
--- a/doc/libnftables-json.adoc
+++ b/doc/libnftables-json.adoc
@@ -1172,7 +1172,7 @@ point (*base*). The following *base* values are accepted:
 *"th"*::
 	The offset is relative to Transport Layer header start offset.
 
-The second form allows to reference a field by name (*field*) in a named packet
+The second form allows one to reference a field by name (*field*) in a named packet
 header (*protocol*).
 
 === EXTHDR
diff --git a/doc/libnftables.adoc b/doc/libnftables.adoc
index 550012b45010..7ea0d56e9b1d 100644
--- a/doc/libnftables.adoc
+++ b/doc/libnftables.adoc
@@ -71,7 +71,7 @@ The *nft_ctx_free*() function frees the context object pointed to by 'ctx', incl
 
 === nft_ctx_get_dry_run() and nft_ctx_set_dry_run()
 Dry-run setting controls whether ruleset changes are actually committed on kernel side or not.
-It allows to check whether a given operation would succeed without making actual changes to the ruleset.
+It allows one to check whether a given operation would succeed without making actual changes to the ruleset.
 The default setting is *false*.
 
 The *nft_ctx_get_dry_run*() function returns the dry-run setting's value contained in 'ctx'.
@@ -121,7 +121,7 @@ NFT_CTX_OUTPUT_JSON::
 	This flag controls JSON output format, input is auto-detected.
 NFT_CTX_OUTPUT_ECHO::
 	The echo setting makes libnftables print the changes once they are committed to the kernel, just like a running instance of *nft monitor* would.
-	Amongst other things, this allows to retrieve an added rule's handle atomically.
+	Amongst other things, this allows one to retrieve an added rule's handle atomically.
 NFT_CTX_OUTPUT_GUID::
 	Display UID and GID as described in the /etc/passwd and /etc/group files.
 NFT_CTX_OUTPUT_NUMERIC_PROTO::
@@ -199,9 +199,9 @@ On failure, the functions return non-zero which may only happen if buffering was
 The *nft_ctx_get_output_buffer*() and *nft_ctx_get_error_buffer*() functions return a pointer to the buffered output (which may be empty).
 
 === nft_ctx_add_include_path() and nft_ctx_clear_include_path()
-The *include* command in nftables rulesets allows to outsource parts of the ruleset into a different file.
+The *include* command in nftables rulesets allows one to outsource parts of the ruleset into a different file.
 The include path defines where these files are searched for.
-Libnftables allows to have a list of those paths which are searched in order.
+Libnftables allows one to have a list of those paths which are searched in order.
 The default include path list contains a single compile-time defined entry (typically '/etc/').
 
 The *nft_ctx_add_include_path*() function extends the list of include paths in 'ctx' by the one given in 'path'.
@@ -210,7 +210,7 @@ The function returns zero on success or non-zero if memory allocation failed.
 The *nft_ctx_clear_include_paths*() function removes all include paths, even the built-in default one.
 
 === nft_ctx_add_var() and nft_ctx_clear_vars()
-The *define* command in nftables ruleset allows to define variables.
+The *define* command in nftables ruleset allows one to define variables.
 
 The *nft_ctx_add_var*() function extends the list of variables in 'ctx'. The variable must be given in the format 'key=value'.
 The function returns zero on success or non-zero if the variable is malformed.
diff --git a/doc/nft.txt b/doc/nft.txt
index 16c68322ffe5..02cf13a57c2e 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -411,7 +411,7 @@ statements for instance).
 |route | ip, ip6 | output |
 If a packet has traversed a chain of this type and is about to be accepted, a
 new route lookup is performed if relevant parts of the IP header have changed.
-This allows to e.g. implement policy routing selectors in nftables.
+This allows one to e.g. implement policy routing selectors in nftables.
 |=================
 
 Apart from the special cases illustrated above (e.g. *nat* type not supporting
@@ -472,7 +472,7 @@ with these standard names to ease relative prioritizing, e.g. *mangle - 5* stand
 for *-155*.  Values will also be printed like this until the value is not
 further than 10 from the standard value.
 
-Base chains also allow to set the chain's *policy*, i.e.  what happens to
+Base chains also allow one to set the chain's *policy*, i.e.  what happens to
 packets not explicitly accepted or refused in contained rules. Supported policy
 values are *accept* (which is the default) or *drop*.
 
@@ -660,7 +660,7 @@ ____
 'OPTIONS' := [*timeout* 'TIMESPEC'] [*expires* 'TIMESPEC'] [*comment* 'string']
 'TIMESPEC' := ['num'*d*]['num'*h*]['num'*m*]['num'[*s*]]
 ____
-Element-related commands allow to change contents of named sets and maps.
+Element-related commands allow one to change contents of named sets and maps.
 'key_expression' is typically a value matching the set type.
 'value_expression' is not allowed in sets but mandatory when adding to maps, where it
 matches the data part in its type definition. When deleting from maps, it may
diff --git a/doc/primary-expression.txt b/doc/primary-expression.txt
index 4d6b0878b252..e13970cfb650 100644
--- a/doc/primary-expression.txt
+++ b/doc/primary-expression.txt
@@ -442,7 +442,7 @@ Create a number generator. The *inc* or *random* keywords control its
 operation mode: In *inc* mode, the last returned value is simply incremented.
 In *random* mode, a new random number is returned. The value after *mod*
 keyword specifies an upper boundary (read: modulus) which is not reached by
-returned numbers. The optional *offset* allows to increment the returned value
+returned numbers. The optional *offset* allows one to increment the returned value
 by a fixed offset.
 
 A typical use-case for *numgen* is load-balancing:
@@ -472,7 +472,7 @@ header to apply the hashing, concatenations are possible as well. The value
 after *mod* keyword specifies an upper boundary (read: modulus) which is
 not reached by returned numbers. The optional *seed* is used to specify an
 init value used as seed in the hashing function. The optional *offset*
-allows to increment the returned value by a fixed offset.
+allows one to increment the returned value by a fixed offset.
 
 A typical use-case for *jhash* and *symhash* is load-balancing:
 
diff --git a/doc/statements.txt b/doc/statements.txt
index 6c6b1d8712d4..8076c21cded4 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -11,7 +11,7 @@ The verdict statement alters control flow in the ruleset and issues policy decis
 [horizontal]
 *accept*:: Terminate ruleset evaluation and accept the packet.
 The packet can still be dropped later by another hook, for instance accept
-in the forward hook still allows to drop the packet later in the postrouting hook,
+in the forward hook still allows one to drop the packet later in the postrouting hook,
 or another forward base chain that has a higher priority number and is evaluated
 afterwards in the processing pipeline.
 *drop*:: Terminate ruleset evaluation and drop the packet.
@@ -278,7 +278,7 @@ ct event set new,related,destroy
 
 NOTRACK STATEMENT
 ~~~~~~~~~~~~~~~~~
-The notrack statement allows to disable connection tracking for certain
+The notrack statement allows one to disable connection tracking for certain
 packets.
 
 [verse]
@@ -613,7 +613,7 @@ ____
 
 QUEUE_EXPRESSION can be used to compute a queue number
 at run-time with the hash or numgen expressions. It also
-allows to use the map statement to assign fixed queue numbers
+allows one to use the map statement to assign fixed queue numbers
 based on external inputs such as the source ip address or interface names.
 
 .queue statement values
diff --git a/src/evaluate.c b/src/evaluate.c
index edebd7bcd8ab..f4b16076fb19 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3725,7 +3725,7 @@ static int stmt_evaluate_log_prefix(struct eval_ctx *ctx, struct stmt *stmt)
 				       expr->sym->expr->identifier);
 			break;
 		default:
-			BUG("unknown expresion type %s\n", expr_name(expr));
+			BUG("unknown expression type %s\n", expr_name(expr));
 			break;
 		}
 		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
@@ -4335,7 +4335,7 @@ static bool evaluate_device_expr(struct eval_ctx *ctx, struct expr **dev_expr)
 		case EXPR_VALUE:
 			break;
 		default:
-			BUG("invalid expresion type %s\n", expr_name(expr));
+			BUG("invalid expression type %s\n", expr_name(expr));
 			break;
 		}
 
-- 
2.35.1

