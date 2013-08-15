From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] nftables: allow protocols by number in
 inet_protocol_type_parse
Date: Thu, 15 Aug 2013 16:09:07 -0700
Message-ID: <20130815230906.GA22230@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="LZvS9be/3tNcYl/X"
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:57110 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376Ab3HOXJC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Aug 2013 19:09:02 -0400
Received: by mail-pb0-f54.google.com with SMTP id ro12so1333586pbb.41
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Aug 2013 16:09:01 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

nftables does not currently allow specifying protocols by number.  Below
patch adds this capability.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>

---
Note the errno include is duplicated in this patch and my earlier
"nftables: validate port number in inet_service_type_parse" patch.

--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-nft-inet_protocol_type_parse

diff --git a/src/datatype.c b/src/datatype.c
index 55368ee..0a1cf2d 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -11,6 +11,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <inttypes.h>
+#include <errno.h>
 #include <netdb.h>
 #include <arpa/inet.h>
 #include <linux/types.h>
@@ -457,14 +458,28 @@ static struct error_record *inet_protocol_type_parse(const struct expr *sym,
 						     struct expr **res)
 {
 	struct protoent *p;
-
-	p = getprotobyname(sym->identifier);
-	if (p == NULL)
-		return error(&sym->location, "Could not resolve protocol name");
+	uint8_t proto;
+	uintmax_t i;
+	char *end;
+
+	errno = 0;
+	i = strtoumax(sym->identifier, &end, 0);
+	if (sym->identifier != end && *end == '\0') {
+		if (errno == ERANGE || i > UINT8_MAX)
+			return error(&sym->location, "Protocol out of range");
+
+		proto = i;
+	} else {
+		p = getprotobyname(sym->identifier);
+		if (p == NULL)
+			return error(&sym->location, "Could not resolve protocol name");
+
+		proto = p->p_proto;
+	}
 
 	*res = constant_expr_alloc(&sym->location, &inet_protocol_type,
 				   BYTEORDER_HOST_ENDIAN, BITS_PER_BYTE,
-				   &p->p_proto);
+				   &proto);
 	return NULL;
 }
 

--LZvS9be/3tNcYl/X--
