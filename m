Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97430C433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Nov 2022 21:48:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236903AbiK2Vr7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:47:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236671AbiK2Vr5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2022 16:47:57 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852C664555
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2022 13:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6noJsTOyqUezVS6FsV6Zw6qeff7qlt+y6Zg4kKR9ywA=; b=qLy6OX67j6JQU4+pUCmqWd3dsk
        pO4+8sWhg2x7zGOzJjEVGg1wdFXJiGtDqELTU22/SvY56jTgGaS1p9ZgPkxcXuyBng0BDAzJFxUly
        6AIztASRWCgUi3oSQfDbif09v4VBf5WtouRynLro99HJZltFne5/NtKsBP5yv0B7fyF221dZXgVdb
        VVVRz75sjyq6EQvoSpy6BKjSNaScmAh9/SGXxViI0o4oLCJygQT32T+Woy9yh8VKwxMUMPg6xQVmw
        RvYWAf3zBOBuBmG9j6CMmPlaq3NS/HU6IUq3nuQ+q1oFZvpjvBLJhak6JzZEaI5KkBBeg0QAwhCkk
        5UBGmoiA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p08SI-00DjQp-NB
        for netfilter-devel@vger.kernel.org; Tue, 29 Nov 2022 21:47:54 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 v2 v2 02/34] filter: fix buffer sizes in filter plug-ins
Date:   Tue, 29 Nov 2022 21:47:17 +0000
Message-Id: <20221129214749.247878-3-jeremy@azazel.net>
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

In the case of `IP2BIN` and `IP2HBIN`, there is no overrun, but only
because they use the wrong upper bound when looping over the keys, and
thus don't assign a value to the last key.  Correct the bound.

Also some small white-space tweaks.

Link: https://bugzilla.netfilter.org/show_bug.cgi?id=890
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 filter/ulogd_filter_HWHDR.c   |  4 ++--
 filter/ulogd_filter_IP2BIN.c  | 14 +++++++-------
 filter/ulogd_filter_IP2HBIN.c |  2 +-
 filter/ulogd_filter_IP2STR.c  |  6 +++---
 4 files changed, 13 insertions(+), 13 deletions(-)

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
index 2172d93506d5..42bcd7c15f1b 100644
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
@@ -205,13 +205,13 @@ static int interp_ip2bin(struct ulogd_pluginstance *pi)
 	int fret;
 
 	/* Iter on all addr fields */
-	for(i = START_KEY; i < MAX_KEY; i++) {
+	for(i = START_KEY; i <= MAX_KEY; i++) {
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
 
diff --git a/filter/ulogd_filter_IP2HBIN.c b/filter/ulogd_filter_IP2HBIN.c
index 087e824ae94b..2711f9c3e12a 100644
--- a/filter/ulogd_filter_IP2HBIN.c
+++ b/filter/ulogd_filter_IP2HBIN.c
@@ -153,7 +153,7 @@ static int interp_ip2hbin(struct ulogd_pluginstance *pi)
 	}
 
 	/* Iter on all addr fields */
-	for(i = START_KEY; i < MAX_KEY; i++) {
+	for(i = START_KEY; i <= MAX_KEY; i++) {
 		if (pp_is_valid(inp, i)) {
 			switch (convfamily) {
 			case AF_INET:
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

