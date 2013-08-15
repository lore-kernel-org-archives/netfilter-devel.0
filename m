From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] nftables: validate port number in inet_service_type_parse
Date: Thu, 15 Aug 2013 10:19:11 -0700
Message-ID: <20130815171911.GA15645@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="r5Pyd7+fXNt84Ff3"
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:49003 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758087Ab3HORTI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Aug 2013 13:19:08 -0400
Received: by mail-pd0-f170.google.com with SMTP id x10so1067980pdj.29
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Aug 2013 10:19:06 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

At present, nft accepts out of range port values such as in this example:

    nft add rule ip filter input tcp dport 123456 accept 

Attached patch adds checks for both integer overflow and 16 bit overflow,
and avoids getaddrinfo call in the (common) case of digit input. Example
above now produces this output:

    <cmdline>:1:36-41: Error: Service out of range
    add rule ip filter input tcp dport 123456 accept
                                       ^^^^^^

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>



--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-nft-inet_service_type_parse

diff --git a/src/datatype.c b/src/datatype.c
index 55368ee..be32851 100644
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
@@ -500,18 +501,30 @@ static struct error_record *inet_service_type_parse(const struct expr *sym,
 {
 	struct addrinfo *ai;
 	uint16_t port;
+	uintmax_t i;
 	int err;
+	char *end;
+
+	errno = 0;
+	i = strtoumax(sym->identifier, &end, 0);
+	if (sym->identifier != end && *end == '\0') {
+		if (errno == ERANGE || i > UINT16_MAX)
+			return error(&sym->location, "Service out of range");
+
+		port = i;
+	} else {
+		err = getaddrinfo(NULL, sym->identifier, NULL, &ai);
+		if (err != 0)
+			return error(&sym->location, "Could not resolve service: %s",
+				     gai_strerror(err));
+
+		port = ((struct sockaddr_in *)ai->ai_addr)->sin_port;
+		freeaddrinfo(ai);
+	}
 
-	err = getaddrinfo(NULL, sym->identifier, NULL, &ai);
-	if (err != 0)
-		return error(&sym->location, "Could not resolve service: %s",
-			     gai_strerror(err));
-
-	port = ((struct sockaddr_in *)ai->ai_addr)->sin_port;
 	*res = constant_expr_alloc(&sym->location, &inet_service_type,
 				   BYTEORDER_BIG_ENDIAN,
 				   sizeof(port) * BITS_PER_BYTE, &port);
-	freeaddrinfo(ai);
 	return NULL;
 }
 

--r5Pyd7+fXNt84Ff3--
