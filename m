Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5BB5C4708C
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Nov 2022 21:58:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236901AbiK2V6I (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:58:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237112AbiK2V5y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2022 16:57:54 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE7A6DCE7
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2022 13:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XjeXIdhBBpw19KAycAh3UCIZxi9ZCF6GJhernFI5USc=; b=fNEHlISrlXpDtj0AVcW5h7T+vd
        yHsrGZOONsmS3BBr/1gmhUVazznGTt4wTXNb0wt3tv8D1BAG5l3d1KDRZHZIk0w7igJskOjVftLHK
        qbuUxgGv18skODLaU4N4XGIAkHWQ6eF3L+Z+HVvQEn6XPtXpps9zRzJKB1N1SK7Q3ASPpVIU7Qzm/
        pve3WsLuD6C/UoltEWZx/5Qs9P/vtKCAFkB4Gi/nXNmCYBFOzoR08D0ALfyy3pN0iSm1vhMmJ/aMS
        /IbkGE8oJUM/3oYP1h5V/DKAo/pSo/h5P5ulHKpGlZpje1Lv1vqqE7G/J5d5v/bE5L7jvfMlGhlO9
        Y9hFkM4w==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p08SM-00DjQp-0W
        for netfilter-devel@vger.kernel.org; Tue, 29 Nov 2022 21:47:58 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 v2 v2 27/34] db, IP2BIN: defer formatting of raw strings
Date:   Tue, 29 Nov 2022 21:47:42 +0000
Message-Id: <20221129214749.247878-28-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221129214749.247878-1-jeremy@azazel.net>
References: <20221129214749.247878-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently, the only use of the output of IP2BIN is embedding in literal
SQL strings, so it converts the binary data to a suitably formatted
hexadecimal string and propagates that.  However, we will shortly
introduce prep & exec support to the DB API, at which point we may want
the raw binary data in the output plug-ins.  Therefore, in order to
avoid having to decode the hex back to binary, defer the hex encoding to
where it is used.

At the same time, resize the buffers.  IPv6 addresses are 128 *bits*, so the
buffers do not need to be 128 *bytes*.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 filter/ulogd_filter_IP2BIN.c | 61 +++++++++++++-----------------------
 util/db.c                    | 10 +++++-
 2 files changed, 31 insertions(+), 40 deletions(-)

diff --git a/filter/ulogd_filter_IP2BIN.c b/filter/ulogd_filter_IP2BIN.c
index ca6d3abae884..6a4e10e4fb58 100644
--- a/filter/ulogd_filter_IP2BIN.c
+++ b/filter/ulogd_filter_IP2BIN.c
@@ -28,8 +28,6 @@
 #include <ulogd/ulogd.h>
 #include <netinet/if_ether.h>
 
-#define IPADDR_LENGTH 128
-
 enum input_keys {
 	KEY_OOB_FAMILY,
 	KEY_OOB_PROTOCOL,
@@ -89,32 +87,38 @@ static struct ulogd_key ip2bin_inp[] = {
 static struct ulogd_key ip2bin_keys[] = {
 	{
 		.type = ULOGD_RET_RAWSTR,
+		.len  = sizeof(struct in6_addr),
 		.name = "ip.saddr.bin",
 	},
 	{
 		.type = ULOGD_RET_RAWSTR,
+		.len  = sizeof(struct in6_addr),
 		.name = "ip.daddr.bin",
 	},
 	{
 		.type = ULOGD_RET_RAWSTR,
+		.len  = sizeof(struct in6_addr),
 		.name = "orig.ip.saddr.bin",
 	},
 	{
 		.type = ULOGD_RET_RAWSTR,
+		.len  = sizeof(struct in6_addr),
 		.name = "orig.ip.daddr.bin",
 	},
 	{
 		.type = ULOGD_RET_RAWSTR,
+		.len  = sizeof(struct in6_addr),
 		.name = "reply.ip.saddr.bin",
 	},
 	{
 		.type = ULOGD_RET_RAWSTR,
+		.len  = sizeof(struct in6_addr),
 		.name = "reply.ip.daddr.bin",
 	},
 
 };
 
-static char ipbin_array[MAX_KEY - START_KEY + 1][IPADDR_LENGTH];
+static unsigned char ipbin_array[MAX_KEY - START_KEY + 1][sizeof(struct in6_addr)];
 
 /**
  * Convert IPv4 address (as 32-bit unsigned integer) to IPv6 address:
@@ -130,13 +134,8 @@ static inline void uint32_to_ipv6(const uint32_t ipv4, struct in6_addr *ipv6)
 
 static int ip2bin(struct ulogd_key *inp, int index, int oindex)
 {
-	char family = ikey_get_u8(&inp[KEY_OOB_FAMILY]);
-	char convfamily = family;
-	unsigned char *addr8;
-	struct in6_addr *addr;
-	struct in6_addr ip4_addr;
-	char *buffer;
-	int i, written;
+	char family = ikey_get_u8(&inp[KEY_OOB_FAMILY]), convfamily = family;
+	struct in6_addr *addr, ip4_addr;
 
 	if (family == AF_BRIDGE) {
 		if (!pp_is_valid(inp, KEY_OOB_PROTOCOL)) {
@@ -162,37 +161,21 @@ static int ip2bin(struct ulogd_key *inp, int index, int oindex)
 	}
 
 	switch (convfamily) {
-		case AF_INET6:
-			addr = (struct in6_addr *)ikey_get_u128(&inp[index]);
-			break;
-		case AF_INET:
-			/* Convert IPv4 to IPv4 in IPv6 */
-			addr = &ip4_addr;
-			uint32_to_ipv6(ikey_get_u32(&inp[index]), addr);
-			break;
-		default:
-			/* TODO handle error */
-			ulogd_log(ULOGD_NOTICE, "Unknown protocol family\n");
-			return ULOGD_IRET_ERR;
+	case AF_INET6:
+		addr = (struct in6_addr *)ikey_get_u128(&inp[index]);
+		break;
+	case AF_INET:
+		/* Convert IPv4 to IPv4 in IPv6 */
+		addr = &ip4_addr;
+		uint32_to_ipv6(ikey_get_u32(&inp[index]), addr);
+		break;
+	default:
+		/* TODO handle error */
+		ulogd_log(ULOGD_NOTICE, "Unknown protocol family\n");
+		return ULOGD_IRET_ERR;
 	}
 
-	buffer = ipbin_array[oindex];
-	/* format IPv6 to BINARY(16) as "0x..." */
-	buffer[0] = '0';
-	buffer[1] = 'x';
-	buffer += 2;
-	addr8 = &addr->s6_addr[0];
-	for (i = 0; i < 4; i++) {
-		written = sprintf(buffer, "%02x%02x%02x%02x",
-				  addr8[0], addr8[1], addr8[2], addr8[3]);
-		if (written != 2 * 4) {
-			buffer[0] = 0;
-			return ULOGD_IRET_ERR;
-		}
-		buffer += written;
-		addr8 += 4;
-	}
-	buffer[0] = 0;
+	memcpy(ipbin_array[oindex], &addr->s6_addr, sizeof(addr->s6_addr));
 
 	return ULOGD_IRET_OK;
 }
diff --git a/util/db.c b/util/db.c
index 42b59cc6284c..271cd25efeaf 100644
--- a/util/db.c
+++ b/util/db.c
@@ -594,7 +594,15 @@ _bind_sql_stmt(struct ulogd_pluginstance *upi, struct db_stmt *stmt)
 			sqlp += sprintf(sqlp, "',");
 			break;
 		case ULOGD_RET_RAWSTR:
-			sqlp += sprintf(sqlp, "%s,", (char *) res->u.value.ptr);
+			strcpy(sqlp, "0x");
+			sqlp += 2;
+			{
+				unsigned char *cp = res->u.value.ptr;
+				unsigned int j;
+				for (j = 0; j < res->len; ++j)
+					sqlp += sprintf(sqlp, "%02x", cp[j]);
+			}
+			*sqlp++ = ',';
 			break;
 		case ULOGD_RET_RAW:
 			ulogd_log(ULOGD_NOTICE,
-- 
2.35.1

