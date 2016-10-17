From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] meta: permit numeric interface type
Date: Mon, 17 Oct 2016 10:53:37 +0200
Message-ID: <1476694417-14583-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46690 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932306AbcJQIzD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2016 04:55:03 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If we can't translate an interface index back to a name
we just print the number.

This change allows using a number instead of an interface index to
make this symmetric.

If we can't find an interface with the given name check
if its a numeric string and then use it instead.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/meta.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/src/meta.c b/src/meta.c
index 87eafeead389..34f9ee8e36e2 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -11,6 +11,7 @@
  */
 
 #include <errno.h>
+#include <limits.h>
 #include <stddef.h>
 #include <stdlib.h>
 #include <stdio.h>
@@ -166,8 +167,18 @@ static struct error_record *ifindex_type_parse(const struct expr *sym,
 	int ifindex;
 
 	ifindex = nft_if_nametoindex(sym->identifier);
-	if (ifindex == 0)
-		return error(&sym->location, "Interface does not exist");
+	if (ifindex == 0) {
+		char *end;
+		long res;
+
+		errno = 0;
+		res = strtol(sym->identifier, &end, 10);
+
+		if (res < 0 || res > INT_MAX || *end || errno)
+			return error(&sym->location, "Interface does not exist");
+
+		ifindex = (int)res;
+	}
 
 	*res = constant_expr_alloc(&sym->location, sym->dtype,
 				   BYTEORDER_HOST_ENDIAN,
-- 
2.7.3

