From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/3] meta: add random expression key
Date: Tue,  5 Jul 2016 09:35:33 +0200
Message-ID: <1467704135-9154-2-git-send-email-fw@strlen.de>
References: <1467704135-9154-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55924 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754189AbcGEHfW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jul 2016 03:35:22 -0400
In-Reply-To: <1467704135-9154-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

meta random fills a 32bit register with a pseudo-random number.

For instance one can now use

meta random <= 2147483647

... to match every 2nd packet, on average.

A followup patch will add a short-hand version ('probability 0.5') so
that users do not have to deal with details.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/meta.c         | 6 ++++++
 src/parser_bison.y | 1 +
 2 files changed, 7 insertions(+)

diff --git a/src/meta.c b/src/meta.c
index 75431a2..8b1a2fc 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -10,11 +10,13 @@
  * Development of this code funded by Astaro AG (http://www.astaro.com/)
  */
 
+#include <errno.h>
 #include <stddef.h>
 #include <stdlib.h>
 #include <stdio.h>
 #include <stdint.h>
 #include <string.h>
+#include <limits.h>
 #include <net/if.h>
 #include <net/if_arp.h>
 #include <pwd.h>
@@ -418,6 +420,9 @@ static const struct meta_template meta_templates[] = {
 	[NFT_META_CGROUP]	= META_TEMPLATE("cgroup",    &integer_type,
 						4 * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
+	[NFT_META_PRANDOM]	= META_TEMPLATE("random",    &integer_type,
+						4 * BITS_PER_BYTE,
+						BYTEORDER_BIG_ENDIAN), /* avoid conversion; doesn't have endianess */
 };
 
 static bool meta_key_is_qualified(enum nft_meta_keys key)
@@ -428,6 +433,7 @@ static bool meta_key_is_qualified(enum nft_meta_keys key)
 	case NFT_META_L4PROTO:
 	case NFT_META_PROTOCOL:
 	case NFT_META_PRIORITY:
+	case NFT_META_PRANDOM:
 		return true;
 	default:
 		return false;
diff --git a/src/parser_bison.y b/src/parser_bison.y
index d7cba23..fdbfed9 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2336,6 +2336,7 @@ meta_key_qualified	:	LENGTH		{ $$ = NFT_META_LEN; }
 			|	L4PROTO		{ $$ = NFT_META_L4PROTO; }
 			|	PROTOCOL	{ $$ = NFT_META_PROTOCOL; }
 			|	PRIORITY	{ $$ = NFT_META_PRIORITY; }
+			|	RANDOM		{ $$ = NFT_META_PRANDOM; }
 			;
 
 meta_key_unqualified	:	MARK		{ $$ = NFT_META_MARK; }
-- 
2.7.3

