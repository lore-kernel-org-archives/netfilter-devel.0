From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft] datatype: Replace getaddrinfo() by internal lookup table
Date: Mon, 6 Feb 2017 13:53:40 -0200
Message-ID: <20170206155339.GA9984@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:32778 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754126AbdBFPxr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Feb 2017 10:53:47 -0500
Received: by mail-qk0-f194.google.com with SMTP id 11so9078422qkl.0
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Feb 2017 07:53:46 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Nftables uses a internal service table to print service names. This
very table should be used when parsing new rules, to avoid conflicts
between nft service table and the local /etc/services, when loading
an exported ruleset.

Complements the commit:
(ccc5da4: datatype: Replace getnameinfo() by internal lookup table)

Fixes(Bug 1118 - nft: nft -f and nft list ruleset use different sets of
service -> port mappings)

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---
 src/datatype.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index d697a07..f1388dc 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -597,10 +597,9 @@ static void inet_service_type_print(const struct expr *expr)
 static struct error_record *inet_service_type_parse(const struct expr *sym,
 						    struct expr **res)
 {
-	struct addrinfo *ai;
+	const struct symbolic_constant *s;
 	uint16_t port;
 	uintmax_t i;
-	int err;
 	char *end;
 
 	errno = 0;
@@ -611,13 +610,16 @@ static struct error_record *inet_service_type_parse(const struct expr *sym,
 
 		port = htons(i);
 	} else {
-		err = getaddrinfo(NULL, sym->identifier, NULL, &ai);
-		if (err != 0)
-			return error(&sym->location, "Could not resolve service: %s",
-				     gai_strerror(err));
+		for (s = inet_service_tbl.symbols; s->identifier != NULL; s++) {
+			if (!strcmp(sym->identifier, s->identifier))
+				break;
+		}
 
-		port = ((struct sockaddr_in *)ai->ai_addr)->sin_port;
-		freeaddrinfo(ai);
+		if (s->identifier == NULL)
+			return error(&sym->location, "Could not resolve service: "
+				     "Servname not found in nft services list");
+
+		port = s->value;
 	}
 
 	*res = constant_expr_alloc(&sym->location, &inet_service_type,
-- 
2.7.4

