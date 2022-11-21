Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6888C43219
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Nov 2022 22:27:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbiKUW1k (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 17:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbiKUW1h (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 17:27:37 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B98DDF70
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2022 14:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=b0sVHAd5onJe9SHz84KxvZuyOcI0mzfa82fxsCc6b/Q=; b=Eqg0epRK0aUz73ykpUny3sCaUo
        2U94jbbuSuhMyOONCmoqNrhCCJTKocdGVcnYxM47YWuPmgaHsJMR+HeUCH9ADa9oZeJyMZb2SGrrE
        yHxsweeCx4MyZ/T2oxgRYANRjHGQq9wFO9guOFh8dw1JkLAeSPXhAd/JrfR/cV8oMGfhrp/xj58uA
        AaPSbWweX59j7CvhzPlEkThfVhv024br/ml2S9YTTd4H8Teh/A3P2vdq7v5LVA9qaqNQU4zy7nJ16
        2FYOOzDgbfSQrO40YFvn1m309IpCkxSudfRIeAJL6eSdtzIoenmyLgASG/rPON+7yO1zihV4X2Bv3
        1BLthjpA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oxFGC-005LgP-2F
        for netfilter-devel@vger.kernel.org; Mon, 21 Nov 2022 22:27:28 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 02/34] filter: fix buffer overruns in filter plug-ins
Date:   Mon, 21 Nov 2022 22:25:39 +0000
Message-Id: <20221121222611.3914559-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221121222611.3914559-1-jeremy@azazel.net>
References: <20221121222611.3914559-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Three of the filter plug-ins define arrays to hold output key values.
The arrays are sized based on the values of enums.  For example:

  enum output_keys {
    KEY_MAC_TYPE,
    KEY_MAC_PROTOCOL,
    KEY_MAC_SADDR,
    START_KEY = KEY_MAC_SADDR,
    KEY_MAC_DADDR,
    KEY_MAC_ADDR,
    MAX_KEY = KEY_MAC_ADDR,
  };

  static char hwmac_str[MAX_KEY - START_KEY][HWADDR_LENGTH];

The arrays are indexed by subtracting `START_KEY` from the enum value of
the key currently being processed: `hwmac_str[okey - START_KEY]`.
However, this means that the last key (`KEY_MAC_ADDR` in this example)
will run off the end of the array.  Increase the size of the arrays.

Also some small white-space tweaks.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 filter/ulogd_filter_HWHDR.c  |  4 ++--
 filter/ulogd_filter_IP2BIN.c | 12 ++++++------
 filter/ulogd_filter_IP2STR.c |  6 +++---
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/filter/ulogd_filter_HWHDR.c b/filter/ulogd_filter_HWHDR.c
index bbca5e9b92f2..a5ee60dea44b 100644
--- a/filter/ulogd_filter_HWHDR.c
+++ b/filter/ulogd_filter_HWHDR.c
@@ -109,7 +109,7 @@ static struct ulogd_key mac2str_keys[] = {
 	},
 };
 
-static char hwmac_str[MAX_KEY - START_KEY][HWADDR_LENGTH];
+static char hwmac_str[MAX_KEY - START_KEY + 1][HWADDR_LENGTH];
 
 static int parse_mac2str(struct ulogd_key *ret, unsigned char *mac,
 			 int okey, int len)
@@ -126,7 +126,7 @@ static int parse_mac2str(struct ulogd_key *ret, unsigned char *mac,
 	buf_cur = hwmac_str[okey - START_KEY];
 	for (i = 0; i < len; i++)
 		buf_cur += sprintf(buf_cur, "%02x%c", mac[i],
-				i == len - 1 ? 0 : ':');
+				   i == len - 1 ? 0 : ':');
 
 	okey_set_ptr(&ret[okey], hwmac_str[okey - START_KEY]);
 
diff --git a/filter/ulogd_filter_IP2BIN.c b/filter/ulogd_filter_IP2BIN.c
index 2172d93506d5..6d5a60abe85e 100644
--- a/filter/ulogd_filter_IP2BIN.c
+++ b/filter/ulogd_filter_IP2BIN.c
@@ -114,7 +114,7 @@ static struct ulogd_key ip2bin_keys[] = {
 
 };
 
-static char ipbin_array[MAX_KEY-START_KEY][IPADDR_LENGTH];
+static char ipbin_array[MAX_KEY - START_KEY + 1][IPADDR_LENGTH];
 
 /**
  * Convert IPv4 address (as 32-bit unsigned integer) to IPv6 address:
@@ -128,7 +128,7 @@ static inline void uint32_to_ipv6(const uint32_t ipv4, struct in6_addr *ipv6)
 	ipv6->s6_addr32[3] = ipv4;
 }
 
-static int ip2bin(struct ulogd_key* inp, int index, int oindex)
+static int ip2bin(struct ulogd_key *inp, int index, int oindex)
 {
 	char family = ikey_get_u8(&inp[KEY_OOB_FAMILY]);
 	char convfamily = family;
@@ -184,7 +184,7 @@ static int ip2bin(struct ulogd_key* inp, int index, int oindex)
 	addr8 = &addr->s6_addr[0];
 	for (i = 0; i < 4; i++) {
 		written = sprintf(buffer, "%02x%02x%02x%02x",
-				addr8[0], addr8[1], addr8[2], addr8[3]);
+				  addr8[0], addr8[1], addr8[2], addr8[3]);
 		if (written != 2 * 4) {
 			buffer[0] = 0;
 			return ULOGD_IRET_ERR;
@@ -207,11 +207,11 @@ static int interp_ip2bin(struct ulogd_pluginstance *pi)
 	/* Iter on all addr fields */
 	for(i = START_KEY; i < MAX_KEY; i++) {
 		if (pp_is_valid(inp, i)) {
-			fret = ip2bin(inp, i, i-START_KEY);
+			fret = ip2bin(inp, i, i - START_KEY);
 			if (fret != ULOGD_IRET_OK)
 				return fret;
-			okey_set_ptr(&ret[i-START_KEY],
-				     ipbin_array[i-START_KEY]);
+			okey_set_ptr(&ret[i - START_KEY],
+				     ipbin_array[i - START_KEY]);
 		}
 	}
 
diff --git a/filter/ulogd_filter_IP2STR.c b/filter/ulogd_filter_IP2STR.c
index 66324b0b3b22..4d0536817b6c 100644
--- a/filter/ulogd_filter_IP2STR.c
+++ b/filter/ulogd_filter_IP2STR.c
@@ -137,7 +137,7 @@ static struct ulogd_key ip2str_keys[] = {
 	},
 };
 
-static char ipstr_array[MAX_KEY-START_KEY][IPADDR_LENGTH];
+static char ipstr_array[MAX_KEY - START_KEY + 1][IPADDR_LENGTH];
 
 static int ip2str(struct ulogd_key *inp, int index, int oindex)
 {
@@ -197,10 +197,10 @@ static int interp_ip2str(struct ulogd_pluginstance *pi)
 	/* Iter on all addr fields */
 	for (i = START_KEY; i <= MAX_KEY; i++) {
 		if (pp_is_valid(inp, i)) {
-			fret = ip2str(inp, i, i-START_KEY);
+			fret = ip2str(inp, i, i - START_KEY);
 			if (fret != ULOGD_IRET_OK)
 				return fret;
-			okey_set_ptr(&ret[i-START_KEY],
+			okey_set_ptr(&ret[i - START_KEY],
 				     ipstr_array[i-START_KEY]);
 		}
 	}
-- 
2.35.1

