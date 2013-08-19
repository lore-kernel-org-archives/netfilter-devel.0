From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] utils: fix error path for nft_strtoi
Date: Mon, 19 Aug 2013 14:37:30 +0200
Message-ID: <20130819123729.21346.17925.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:55148 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751341Ab3HSMhk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Aug 2013 08:37:40 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id E782F51ED1B
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2013 12:37:37 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W7dNMjV8E25N for <netfilter-devel@vger.kernel.org>;
	Mon, 19 Aug 2013 14:37:32 +0200 (CEST)
Received: from nfdev.cica.es (nfdev.cica.es [IPv6:2a00:9ac0:c1ca:31::220])
	by smtp.cica.es (Postfix) with ESMTP id 831A751ECEF
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2013 14:37:32 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If the return of nft_get_value() is not evaluated, we don't know if the parsed
value is between the limits of his type.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 0 files changed

diff --git a/src/utils.c b/src/utils.c
index 848eba9..9a0bcfe 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -103,6 +103,7 @@ int nft_get_value(enum nft_type type, void *val, void *out)
 
 int nft_strtoi(const char *string, int base, void *out, enum nft_type type)
 {
+	int ret;
 	int64_t sval = 0;
 	uint64_t uval = -1;
 	char *endptr;
@@ -113,14 +114,14 @@ int nft_strtoi(const char *string, int base, void *out, enum nft_type type)
 	case NFT_TYPE_U32:
 	case NFT_TYPE_U64:
 		uval = strtoll(string, &endptr, base);
-		nft_get_value(type, &uval, out);
+		ret = nft_get_value(type, &uval, out);
 		break;
 	case NFT_TYPE_S8:
 	case NFT_TYPE_S16:
 	case NFT_TYPE_S32:
 	case NFT_TYPE_S64:
 		sval = strtoull(string, &endptr, base);
-		nft_get_value(type, &sval, out);
+		ret = nft_get_value(type, &sval, out);
 		break;
 	default:
 		errno = EINVAL;
@@ -132,7 +133,7 @@ int nft_strtoi(const char *string, int base, void *out, enum nft_type type)
 		return -1;
 	}
 
-	return 0;
+	return ret;
 }
 
 const char *nft_verdict2str(uint32_t verdict)

