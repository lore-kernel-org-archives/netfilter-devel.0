From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 3/4] datatype: revert "fix crash if wrong integer type is passed"
Date: Fri, 10 Jan 2014 09:31:33 +0000
Message-ID: <1389346294-7242-4-git-send-email-kaber@trash.net>
References: <1389346294-7242-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57692 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbaAJJc1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 04:32:27 -0500
In-Reply-To: <1389346294-7242-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Revert commit a320531e7:

We have generic type checks that handle this case just fine and indeed
the bugzilla entry mentioned in the reverted patch states:

BUG: invalid input descriptor type 538976288
nft: src/erec.c:100: erec_print: Assertion `0' failed.
Abandon

So the problem is not related to datatypes at all and generic type
checking works perfectly fine:

<cmdline>:1:52-57: Error: datatype mismatch, expected Ethernet protocol, expression has type Internet protocol
add rule ip6 filter input position 4 meta protocol icmpv6 accept
                                     ~~~~~~~~~~~~~ ^^^^^^

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 src/datatype.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index 2e5788d..9910a1b 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -230,10 +230,8 @@ static struct error_record *integer_type_parse(const struct expr *sym,
 	if (gmp_sscanf(sym->identifier, "%Zu%n", v, &len) != 1 ||
 	    (int)strlen(sym->identifier) != len) {
 		mpz_clear(v);
-		if (sym->dtype != &integer_type) {
-			return error(&sym->location, "This is not a valid %s",
-				     sym->dtype->desc);
-		}
+		if (sym->dtype != &integer_type)
+			return NULL;
 		return error(&sym->location, "Could not parse %s",
 			     sym->dtype->desc);
 	}
-- 
1.8.4.2

