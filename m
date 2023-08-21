Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B795EE49A6
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Aug 2023 20:04:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbjHUUE3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjHUUE2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2023 16:04:28 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB36E4
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Aug 2023 13:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5QSTSn0jFBRjamqBSaz1fATHnsIlmgJqYc9S0NWcnXg=; b=MB8LYLCqz3UWUrPwDy5kn3MMCL
        rxkK27XiP/64MX44HeD5SnvcayjGs8F0g0BV7mCCCRLJrEVKV4kHPzQOKjrx3sbKANbmySQ3CgDgh
        zKswcZhviODzl0CSZwP7jO2MOKU/j4syJycE9n8M0BzSSHJQ8ENne4xV0Czpy78l5AUYjlNbOph/1
        oFkEIE/FFYjlttqeYYd+J4uylNjEUBag8cerK4+T7NsBSUHiR8cOT4pNze0IacayJB0vUHpjXJPMd
        r2SwzpkTFH9b30GQai6DjULdWRQfDDM12rpXqYnHcEWLRnK5ZqXzuhem+9Vyy+wtwKodb23rKhqMm
        u3cUw5sQ==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qYAnn-00909U-31
        for netfilter-devel@vger.kernel.org;
        Mon, 21 Aug 2023 20:43:03 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 v3 11/11] db: insert ipv6 addresses in the same format as ip2bin
Date:   Mon, 21 Aug 2023 20:42:37 +0100
Message-Id: <20230821194237.51139-12-jeremy@azazel.net>
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

Move a `ULOGD_RET_BOOL` case for consistency.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 filter/ulogd_filter_IP2BIN.c | 33 +----------------------------
 include/ulogd/ulogd.h        | 41 ++++++++++++++++++++++++++++++++++++
 util/db.c                    | 19 +++++++++++++----
 3 files changed, 57 insertions(+), 36 deletions(-)

diff --git a/filter/ulogd_filter_IP2BIN.c b/filter/ulogd_filter_IP2BIN.c
index 74e46835ae53..7f7bea5071a7 100644
--- a/filter/ulogd_filter_IP2BIN.c
+++ b/filter/ulogd_filter_IP2BIN.c
@@ -116,27 +116,12 @@ static struct ulogd_key ip2bin_keys[] = {
 
 static char ipbin_array[MAX_KEY - START_KEY + 1][IPADDR_LENGTH];
 
-/**
- * Convert IPv4 address (as 32-bit unsigned integer) to IPv6 address:
- * add 96 bits prefix "::ffff:" to get IPv6 address "::ffff:a.b.c.d".
- */
-static inline void uint32_to_ipv6(const uint32_t ipv4, struct in6_addr *ipv6)
-{
-	ipv6->s6_addr32[0] = 0x00000000;
-	ipv6->s6_addr32[1] = 0x00000000;
-	ipv6->s6_addr32[2] = htonl(0xffff);
-	ipv6->s6_addr32[3] = ipv4;
-}
-
 static int ip2bin(struct ulogd_key *inp, int index, int oindex)
 {
 	char family = ikey_get_u8(&inp[KEY_OOB_FAMILY]);
 	char convfamily = family;
-	unsigned char *addr8;
 	struct in6_addr *addr;
 	struct in6_addr ip4_addr;
-	char *buffer;
-	int i, written;
 
 	if (family == AF_BRIDGE) {
 		if (!pp_is_valid(inp, KEY_OOB_PROTOCOL)) {
@@ -176,23 +161,7 @@ static int ip2bin(struct ulogd_key *inp, int index, int oindex)
 			return ULOGD_IRET_ERR;
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
+	format_ipv6(ipbin_array[oindex], IPADDR_LENGTH, addr);
 
 	return ULOGD_IRET_OK;
 }
diff --git a/include/ulogd/ulogd.h b/include/ulogd/ulogd.h
index cb0174042235..c7cf40277fcb 100644
--- a/include/ulogd/ulogd.h
+++ b/include/ulogd/ulogd.h
@@ -18,6 +18,7 @@
 #include <signal.h>	/* need this because of extension-sighandler */
 #include <sys/types.h>
 #include <inttypes.h>
+#include <netinet/in.h>
 #include <string.h>
 #include <config.h>
 
@@ -208,6 +209,46 @@ static inline void *ikey_get_ptr(struct ulogd_key *key)
 	return key->u.source->u.value.ptr;
 }
 
+/**
+ * Convert IPv4 address (as 32-bit unsigned integer) to IPv6 address: add 96-bit
+ * prefix "::ffff" to get IPv6 address "::ffff:a.b.c.d".
+ */
+static inline struct in6_addr *
+uint32_to_ipv6(uint32_t ipv4, struct in6_addr *ipv6)
+{
+	static const uint8_t IPV4_IN_IPV6_PREFIX[12] = {
+		[10] = 0xff,
+		[11] = 0xff,
+	};
+	uint8_t *p = ipv6->s6_addr;
+
+	memcpy(p, IPV4_IN_IPV6_PREFIX, sizeof(IPV4_IN_IPV6_PREFIX));
+	p += sizeof(IPV4_IN_IPV6_PREFIX);
+	memcpy(p, &ipv4, sizeof(ipv4));
+
+	return ipv6;
+}
+
+static inline void
+format_ipv6(char *buf, size_t size, const struct in6_addr *ipv6)
+{
+	unsigned i = 0;
+
+	if (size > 2 + sizeof (*ipv6) * 2) {
+		buf[i++] = '0';
+		buf[i++] = 'x';
+
+		for (unsigned j = 0; i < sizeof(*ipv6); j += 4, i += 8) {
+			sprintf(buf + i, "%02hhx%02hhx%02hhx%02hhx",
+				ipv6->s6_addr[j + 0],
+				ipv6->s6_addr[j + 1],
+				ipv6->s6_addr[j + 2],
+				ipv6->s6_addr[j + 3]);
+		}
+	}
+	buf[i] = '\0';
+}
+
 struct ulogd_pluginstance_stack;
 struct ulogd_pluginstance;
 
diff --git a/util/db.c b/util/db.c
index ebd9f152ed83..749a45ff5cd5 100644
--- a/util/db.c
+++ b/util/db.c
@@ -344,6 +344,9 @@ static void __format_query_db(struct ulogd_pluginstance *upi, char *start)
 		}
 
 		switch (res->type) {
+		case ULOGD_RET_BOOL:
+			sprintf(stmt_ins, "'%d',", res->u.value.b);
+			break;
 		case ULOGD_RET_INT8:
 			sprintf(stmt_ins, "%d,", res->u.value.i8);
 			break;
@@ -363,16 +366,24 @@ static void __format_query_db(struct ulogd_pluginstance *upi, char *start)
 			sprintf(stmt_ins, "%u,", res->u.value.ui16);
 			break;
 		case ULOGD_RET_IPADDR:
-			/* fallthrough when logging IP as uint32_t */
+			if (res->len == sizeof(struct in_addr))
+				sprintf(stmt_ins, "%u,", res->u.value.ui32);
+			else {
+				struct in6_addr ipv6;
+				char addrbuf[2 + sizeof(ipv6) * 2  + 1];
+
+				memcpy(ipv6.s6_addr, res->u.value.ui128,
+				       sizeof(ipv6.s6_addr));
+				format_ipv6(addrbuf, sizeof(addrbuf), &ipv6);
+				sprintf(stmt_ins, "%s,", addrbuf);
+			}
+			break;
 		case ULOGD_RET_UINT32:
 			sprintf(stmt_ins, "%u,", res->u.value.ui32);
 			break;
 		case ULOGD_RET_UINT64:
 			sprintf(stmt_ins, "%" PRIu64 ",", res->u.value.ui64);
 			break;
-		case ULOGD_RET_BOOL:
-			sprintf(stmt_ins, "'%d',", res->u.value.b);
-			break;
 		case ULOGD_RET_STRING:
 			*(stmt_ins++) = '\'';
 			if (res->u.value.ptr) {
-- 
2.40.1

