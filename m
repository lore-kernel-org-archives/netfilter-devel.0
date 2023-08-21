Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E7FEEE49B3
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Aug 2023 19:43:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjHUTnL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Aug 2023 15:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbjHUTnI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2023 15:43:08 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350B510E
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Aug 2023 12:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8dVfOO4Ob6n5xzbDvWyWZ3sKMmoFoaawzeB4dTR3dho=; b=XxwNBHE+nK0GUb9tlIGznm9+Xi
        /yMNt3eF7+4/8SesomPm7QoZMkFM1KN2JFpwLKLQpl5jyVJbj25ufpnLXly3QDNU6wCCuUzXEMBug
        ygfZqEep7AQwE34+88piuZaBiK6GzDCDrPRACrzw+xsxGdoo2oTSpBTEgrjCxZxfNy8hBSwtjPF66
        z6iB65hxuBcmSYdJL+9lgp4lG/xCH2AHDqsrTajLGXWIjZdWr8JwDdzXoWfnFtd/EpmLXl99dzVpH
        jgm8yB3X7QkOqnQx6kBTyKuR4QVggpFcaAsnq0GxQqjUA2fXvdD8SeI1TvJdfaViNc8lCpSqJ3mv5
        a2nAVOSQ==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qYAnn-00909U-2Q
        for netfilter-devel@vger.kernel.org;
        Mon, 21 Aug 2023 20:43:03 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 v3 07/11] gprint, oprint: use inet_ntop to format ip addresses
Date:   Mon, 21 Aug 2023 20:42:33 +0100
Message-Id: <20230821194237.51139-8-jeremy@azazel.net>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230821194237.51139-1-jeremy@azazel.net>
References: <20230821194237.51139-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Replace hand-rolled ipv4-only formatting code in order to be able to
support ipv6 addresses.  This also changes the byte-order expected by
oprint from HBO to NBO.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/ulogd_output_GPRINT.c | 20 ++++++++++----------
 output/ulogd_output_OPRINT.c | 30 ++++++++++++++----------------
 2 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/output/ulogd_output_GPRINT.c b/output/ulogd_output_GPRINT.c
index eeeec6ac3eb0..093d3ea2b254 100644
--- a/output/ulogd_output_GPRINT.c
+++ b/output/ulogd_output_GPRINT.c
@@ -27,6 +27,8 @@
 #include <time.h>
 #include <errno.h>
 #include <inttypes.h>
+#include <arpa/inet.h>
+#include <netinet/in.h>
 #include <ulogd/ulogd.h>
 #include <ulogd/conffile.h>
 
@@ -69,12 +71,6 @@ static struct config_keyset gprint_kset = {
 	},
 };
 
-#define NIPQUAD(addr) \
-        ((unsigned char *)&addr)[0], \
-        ((unsigned char *)&addr)[1], \
-        ((unsigned char *)&addr)[2], \
-        ((unsigned char *)&addr)[3]
-
 static int gprint_interp(struct ulogd_pluginstance *upi)
 {
 	struct gprint_priv *opi = (struct gprint_priv *) &upi->private;
@@ -158,20 +154,24 @@ static int gprint_interp(struct ulogd_pluginstance *upi)
 			rem -= ret;
 			size += ret;
 			break;
-		case ULOGD_RET_IPADDR:
+		case ULOGD_RET_IPADDR: {
+			struct in_addr ipv4addr;
+
 			ret = snprintf(buf+size, rem, "%s=", key->name);
 			if (ret < 0)
 				break;
 			rem -= ret;
 			size += ret;
 
-			ret = snprintf(buf+size, rem, "%u.%u.%u.%u,",
-				NIPQUAD(key->u.value.ui32));
-			if (ret < 0)
+			ipv4addr.s_addr = key->u.value.ui32;
+			if (!inet_ntop(AF_INET, &ipv4addr, buf + size, rem))
 				break;
+			ret = strlen(buf + size);
+
 			rem -= ret;
 			size += ret;
 			break;
+		}
 		default:
 			/* don't know how to interpret this key. */
 			break;
diff --git a/output/ulogd_output_OPRINT.c b/output/ulogd_output_OPRINT.c
index 0409133e8227..b5586e850aa4 100644
--- a/output/ulogd_output_OPRINT.c
+++ b/output/ulogd_output_OPRINT.c
@@ -24,6 +24,8 @@
 #include <string.h>
 #include <errno.h>
 #include <inttypes.h>
+#include <arpa/inet.h>
+#include <netinet/in.h>
 #include <ulogd/ulogd.h>
 #include <ulogd/conffile.h>
 
@@ -31,18 +33,6 @@
 #define ULOGD_OPRINT_DEFAULT	"/var/log/ulogd_oprint.log"
 #endif
 
-#define NIPQUAD(addr) \
-	((unsigned char *)&addr)[0], \
-	((unsigned char *)&addr)[1], \
-        ((unsigned char *)&addr)[2], \
-        ((unsigned char *)&addr)[3]
-
-#define HIPQUAD(addr) \
-        ((unsigned char *)&addr)[3], \
-        ((unsigned char *)&addr)[2], \
-        ((unsigned char *)&addr)[1], \
-        ((unsigned char *)&addr)[0]
-
 struct oprint_priv {
 	FILE *of;
 };
@@ -59,7 +49,7 @@ static int oprint_interp(struct ulogd_pluginstance *upi)
 		if (!ret)
 			ulogd_log(ULOGD_NOTICE, "no result for %s ?!?\n",
 				  upi->input.keys[i].name);
-		
+
 		if (!IS_VALID(*ret))
 			continue;
 
@@ -85,10 +75,18 @@ static int oprint_interp(struct ulogd_pluginstance *upi)
 		case ULOGD_RET_UINT64:
 			fprintf(opi->of, "%" PRIu64 "\n", ret->u.value.ui64);
 			break;
-		case ULOGD_RET_IPADDR:
-			fprintf(opi->of, "%u.%u.%u.%u\n",
-				HIPQUAD(ret->u.value.ui32));
+		case ULOGD_RET_IPADDR: {
+			char addrbuf[INET_ADDRSTRLEN + 1] = "";
+			struct in_addr ipv4addr;
+
+			ipv4addr.s_addr = ret->u.value.ui32;
+			if (!inet_ntop(AF_INET, &ipv4addr, addrbuf,
+				       sizeof(addrbuf)))
+				break;
+
+			fprintf(opi->of, "%s\n", addrbuf);
 			break;
+		}
 		case ULOGD_RET_NONE:
 			fprintf(opi->of, "<none>\n");
 			break;
-- 
2.40.1

