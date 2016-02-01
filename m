From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] meta: fix error checks in tc handle parser
Date: Mon,  1 Feb 2016 12:02:36 +0100
Message-ID: <1454324556-29019-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33284 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753328AbcBALFK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2016 06:05:10 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

'meta priority foobar' did not return an error -- instead
we used min/max values with undefined content.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/meta.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/meta.c b/src/meta.c
index 8cbc974..7f12f0c 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -100,17 +100,17 @@ static struct error_record *tchandle_type_parse(const struct expr *sym,
 	else if (strcmp(sym->identifier, "none") == 0)
 		handle = TC_H_UNSPEC;
 	else if (sym->identifier[0] == ':') {
-		if (sscanf(sym->identifier, ":%04x", &handle) < 0)
+		if (sscanf(sym->identifier, ":%04x", &handle) != 1)
 			goto err;
 	} else if (sym->identifier[strlen(sym->identifier)-1] == ':') {
-		if (sscanf(sym->identifier, "%04x:", &handle) < 0)
+		if (sscanf(sym->identifier, "%04x:", &handle) != 1)
 			goto err;
 
 		handle <<= 16;
 	} else {
 		uint32_t min, max;
 
-		if (sscanf(sym->identifier, "%04x:%04x", &min, &max) < 0)
+		if (sscanf(sym->identifier, "%04x:%04x", &min, &max) != 2)
 			goto err;
 
 		handle = max << 16 | min;
-- 
2.4.10

