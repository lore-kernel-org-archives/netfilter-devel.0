Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A959C77B73
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jun 2023 19:20:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbjFETUs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Jun 2023 15:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235801AbjFETUA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jun 2023 15:20:00 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C181709
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Jun 2023 12:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Qq3/KVxbeCGcAIcy4c9zmqmbPDZWXYx5/1f0cUEOzeE=; b=HNxJTuZST0RXgfiwuH9IYQCSJ8
        mG8COB27CYe30rcet4aPCkR0SK5/h/qsVXHjtyqmFoi9ltxe8N2k86XIsiqYOjlP7vySXPZyqenh+
        Rx4ff0LeSxQggQJC5+hwGvKKTBqqEdKsUslbi9cmAN4jfsQPvh/lkJsbwX0d4FFdNDN5U7MM5xZEc
        mumxe4owbBRnRxRESVht48dae/zCTJE43UvwhoVp4rI0mcBjw95VKJP/IkcJ1TFutr9xjDhOzS7J0
        LEmaMVs6je6nXEHyr4ktF3gikbL1pLlf6Kye/HD9RFHpnVyuJYnwCnRAmPPUecDIcWysYYAlfuKPo
        S5WvrWGg==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q6FjL-00H0rc-B0
        for netfilter-devel@vger.kernel.org; Mon, 05 Jun 2023 20:19:03 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 6/8] xt_ipp2p: use textsearch API for substring searching
Date:   Mon,  5 Jun 2023 20:17:33 +0100
Message-Id: <20230605191735.119210-7-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230605191735.119210-1-jeremy@azazel.net>
References: <20230605191735.119210-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Some of the matchers have hand-rolled substring search implementations.
Replace them with the kernel's textsearch API.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/xt_ipp2p.c | 312 +++++++++++++++++++++++++++++++-----------
 extensions/xt_ipp2p.h |  10 ++
 2 files changed, 245 insertions(+), 77 deletions(-)

diff --git a/extensions/xt_ipp2p.c b/extensions/xt_ipp2p.c
index ae9a3dd2a920..1378701605c3 100644
--- a/extensions/xt_ipp2p.c
+++ b/extensions/xt_ipp2p.c
@@ -1,4 +1,6 @@
+#include <linux/gfp.h>
 #include <linux/module.h>
+#include <linux/textsearch.h>
 #include <linux/version.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <net/tcp.h>
@@ -55,7 +57,8 @@ print_result(const struct ipp2p_result_printer *rp, bool result,
 
 /* Search for UDP eDonkey/eMule/Kad commands */
 static unsigned int
-udp_search_edk(const unsigned char *t, const unsigned int packet_len)
+udp_search_edk(const unsigned char *t, const unsigned int packet_len,
+	       const struct ipt_p2p_info *info)
 {
 	if (packet_len < 4)
 		return 0;
@@ -173,7 +176,8 @@ udp_search_edk(const unsigned char *t, const unsigned int packet_len)
 
 /* Search for UDP Gnutella commands */
 static unsigned int
-udp_search_gnu(const unsigned char *t, const unsigned int packet_len)
+udp_search_gnu(const unsigned char *t, const unsigned int packet_len,
+	       const struct ipt_p2p_info *info)
 {
 	if (packet_len >= 3 && memcmp(t, "GND", 3) == 0)
 		return IPP2P_GNU * 100 + 51;
@@ -184,7 +188,8 @@ udp_search_gnu(const unsigned char *t, const unsigned int packet_len)
 
 /* Search for UDP KaZaA commands */
 static unsigned int
-udp_search_kazaa(const unsigned char *t, const unsigned int packet_len)
+udp_search_kazaa(const unsigned char *t, const unsigned int packet_len,
+		 const struct ipt_p2p_info *info)
 {
 	if (packet_len < 6)
 		return 0;
@@ -194,8 +199,9 @@ udp_search_kazaa(const unsigned char *t, const unsigned int packet_len)
 }
 
 /* Search for UDP DirectConnect commands */
-static unsigned int udp_search_directconnect(const unsigned char *t,
-                                             const unsigned int packet_len)
+static unsigned int
+udp_search_directconnect(const unsigned char *t, const unsigned int packet_len,
+			 const struct ipt_p2p_info *info)
 {
 	if (packet_len < 5)
 		return 0;
@@ -212,7 +218,8 @@ static unsigned int udp_search_directconnect(const unsigned char *t,
 
 /* Search for UDP BitTorrent commands */
 static unsigned int
-udp_search_bit(const unsigned char *haystack, const unsigned int packet_len)
+udp_search_bit(const unsigned char *haystack, const unsigned int packet_len,
+	       const struct ipt_p2p_info *info)
 {
 	switch (packet_len) {
 	case 16:
@@ -298,7 +305,8 @@ udp_search_bit(const unsigned char *haystack, const unsigned int packet_len)
 
 /* Search for Ares commands */
 static unsigned int
-search_ares(const unsigned char *payload, const unsigned int plen)
+search_ares(const unsigned char *payload, const unsigned int plen,
+	    const struct ipt_p2p_info *info)
 {
 	if (plen < 3)
 		return 0;
@@ -350,7 +358,8 @@ search_ares(const unsigned char *payload, const unsigned int plen)
 
 /* Search for SoulSeek commands */
 static unsigned int
-search_soul(const unsigned char *payload, const unsigned int plen)
+search_soul(const unsigned char *payload, const unsigned int plen,
+	    const struct ipt_p2p_info *info)
 {
 	if (plen < 8)
 		return 0;
@@ -474,8 +483,11 @@ search_soul(const unsigned char *payload, const unsigned int plen)
 
 /* Search for WinMX commands */
 static unsigned int
-search_winmx(const unsigned char *payload, const unsigned int plen)
+search_winmx(const unsigned char *payload, const unsigned int plen,
+	     const struct ipt_p2p_info *info)
 {
+	uint16_t start;
+
 	if (plen == 4 && memcmp(payload, "SEND", 4) == 0)
 		return IPP2P_WINMX * 100 + 1;
 	if (plen == 3 && memcmp(payload, "GET", 3) == 0)
@@ -487,20 +499,33 @@ search_winmx(const unsigned char *payload, const unsigned int plen)
 	if (plen < 10)
 		return 0;
 
-	if (memcmp(payload, "SEND", 4) == 0 || memcmp(payload, "GET", 3) == 0) {
-		uint16_t c = 4;
-		const uint16_t end = plen - 2;
+	if (memcmp(payload, "SEND", 4) == 0)
+		start = 4;
+	else if (memcmp(payload, "GET", 3) == 0)
+		start = 3;
+	else
+		start = 0;
+
+	if (start) {
 		uint8_t count = 0;
 
-		while (c < end) {
-			if (payload[c] == 0x20 && payload[c+1] == 0x22) {
-				c++;
-				count++;
-				if (count >= 2)
-					return IPP2P_WINMX * 100 + 3;
-			}
-			c++;
-		}
+		do {
+			struct ts_state state;
+			unsigned int pos;
+
+			pos = textsearch_find_continuous(info->ts_conf_winmx,
+							 &state,
+							 &payload[start],
+							 plen - start);
+			if (pos == UINT_MAX)
+				break;
+
+			count++;
+			if (count >= 2)
+				return IPP2P_WINMX * 100 + 3;
+
+			start = pos + 2;
+		} while (start < plen);
 	}
 
 	if (plen == 149 && payload[0] == '8') {
@@ -528,7 +553,8 @@ search_winmx(const unsigned char *payload, const unsigned int plen)
 
 /* Search for appleJuice commands */
 static unsigned int
-search_apple(const unsigned char *payload, const unsigned int plen)
+search_apple(const unsigned char *payload, const unsigned int plen,
+	     const struct ipt_p2p_info *info)
 {
 	if (plen < 8)
 		return 0;
@@ -539,8 +565,12 @@ search_apple(const unsigned char *payload, const unsigned int plen)
 
 /* Search for BitTorrent commands */
 static unsigned int
-search_bittorrent(const unsigned char *payload, const unsigned int plen)
+search_bittorrent(const unsigned char *payload, const unsigned int plen,
+		  const struct ipt_p2p_info *info)
 {
+	struct ts_state state;
+	unsigned int pos;
+
 	/*
 	 * bitcomet encrypts the first packet, so we have to detect another one
 	 * later in the flow.
@@ -567,11 +597,20 @@ search_bittorrent(const unsigned char *payload, const unsigned int plen)
 	 */
 	if (memcmp(payload, "GET /", 5) != 0)
 		return 0;
-	if (HX_memmem(payload, plen, "info_hash=", 10) != NULL)
+
+	pos = textsearch_find_continuous(info->ts_conf_bt_info_hash,
+					 &state, &payload[5], plen - 5);
+	if (pos != UINT_MAX)
 		return IPP2P_BIT * 100 + 1;
-	if (HX_memmem(payload, plen, "peer_id=", 8) != NULL)
+
+	pos = textsearch_find_continuous(info->ts_conf_bt_peer_id,
+					 &state, &payload[5], plen - 5);
+	if (pos != UINT_MAX)
 		return IPP2P_BIT * 100 + 2;
-	if (HX_memmem(payload, plen, "passkey=", 8) != NULL)
+
+	pos = textsearch_find_continuous(info->ts_conf_bt_passkey,
+					 &state, &payload[5], plen - 5);
+	if (pos != UINT_MAX)
 		return IPP2P_BIT * 100 + 4;
 
 	return 0;
@@ -579,7 +618,8 @@ search_bittorrent(const unsigned char *payload, const unsigned int plen)
 
 /* check for Kazaa get command */
 static unsigned int
-search_kazaa(const unsigned char *payload, const unsigned int plen)
+search_kazaa(const unsigned char *payload, const unsigned int plen,
+	     const struct ipt_p2p_info *info)
 {
 	if (plen < 13)
 		return 0;
@@ -592,7 +632,8 @@ search_kazaa(const unsigned char *payload, const unsigned int plen)
 
 /* check for gnutella get command */
 static unsigned int
-search_gnu(const unsigned char *payload, const unsigned int plen)
+search_gnu(const unsigned char *payload, const unsigned int plen,
+	   const struct ipt_p2p_info *info)
 {
 	if (plen < 11)
 		return 0;
@@ -607,9 +648,11 @@ search_gnu(const unsigned char *payload, const unsigned int plen)
 
 /* check for gnutella get commands and other typical data */
 static unsigned int
-search_all_gnu(const unsigned char *payload, const unsigned int plen)
+search_all_gnu(const unsigned char *payload, const unsigned int plen,
+	       const struct ipt_p2p_info *info)
 {
-	unsigned int c;
+	struct ts_state state;
+	unsigned int c, pos;
 
 	if (plen < 11)
 		return 0;
@@ -623,29 +666,34 @@ search_all_gnu(const unsigned char *payload, const unsigned int plen)
 	if (plen < 22)
 		return 0;
 
-	if (memcmp(payload, "GET /get/", 9) != 0 &&
-	    memcmp(payload, "GET /uri-res/", 13) != 0)
+	if (memcmp(payload, "GET /get/", 9) == 0)
+		c = 9;
+	else if (memcmp(payload, "GET /uri-res/", 13) == 0)
+		c = 13;
+	else
 		return 0;
 
-	for (c = 0; c < plen - 22; ++c) {
-		if (!iscrlf(&payload[c]))
-			continue;
+	pos = textsearch_find_continuous(info->ts_conf_gnu_x_gnutella,
+					 &state, &payload[c], plen - c);
+	if (pos != UINT_MAX)
+		return IPP2P_GNU * 100 + 3;
 
-		if (memcmp(&payload[c+2], "X-Gnutella-", 11) == 0)
-			return IPP2P_GNU * 100 + 3;
+	pos = textsearch_find_continuous(info->ts_conf_gnu_x_queue,
+					 &state, &payload[c], plen - c);
+	if (pos != UINT_MAX)
+		return IPP2P_GNU * 100 + 3;
 
-		if ( memcmp(&payload[c+2], "X-Queue:", 8) == 0)
-			return IPP2P_GNU * 100 + 3;
-	}
 	return 0;
 }
 
 /* check for KaZaA download commands and other typical data */
 /* plen is guaranteed to be >= 5 (see @matchlist) */
 static unsigned int
-search_all_kazaa(const unsigned char *payload, const unsigned int plen)
+search_all_kazaa(const unsigned char *payload, const unsigned int plen,
+		 const struct ipt_p2p_info *info)
 {
-	uint16_t c, end, rem;
+	struct ts_state state;
+	unsigned int pos;
 
 	if (plen < 7)
 		/* too short for anything we test for - early bailout */
@@ -664,25 +712,23 @@ search_all_kazaa(const unsigned char *payload, const unsigned int plen)
 		/* The next tests would not succeed anyhow. */
 		return 0;
 
-	end = plen - 18;
-	rem = plen - 5;
-	for (c = 5; c < end; ++c, --rem) {
-		if (!iscrlf(&payload[c]))
-			continue;
-		if (rem >= 18 &&
-		    memcmp(&payload[c+2], "X-Kazaa-Username: ", 18) == 0)
-			return IPP2P_KAZAA * 100 + 2;
-		if (rem >= 24 &&
-		    memcmp(&payload[c+2], "User-Agent: PeerEnabler/", 24) == 0)
-			return IPP2P_KAZAA * 100 + 2;
-	}
+	pos = textsearch_find_continuous(info->ts_conf_kz_x_kazaa_username,
+					 &state, &payload[5], plen - 5);
+	if (pos != UINT_MAX)
+		return IPP2P_KAZAA * 100 + 2;
+
+	pos = textsearch_find_continuous(info->ts_conf_kz_user_agent,
+					 &state, &payload[5], plen - 5);
+	if (pos != UINT_MAX)
+		return IPP2P_KAZAA * 100 + 2;
 
 	return 0;
 }
 
 /* fast check for edonkey file segment transfer command */
 static unsigned int
-search_edk(const unsigned char *payload, const unsigned int plen)
+search_edk(const unsigned char *payload, const unsigned int plen,
+	   const struct ipt_p2p_info *info)
 {
 	if (plen < 6)
 		return 0;
@@ -695,7 +741,8 @@ search_edk(const unsigned char *payload, const unsigned int plen)
 
 /* intensive but slower search for some edonkey packets including size-check */
 static unsigned int
-search_all_edk(const unsigned char *payload, const unsigned int plen)
+search_all_edk(const unsigned char *payload, const unsigned int plen,
+	       const struct ipt_p2p_info *info)
 {
 	unsigned int cmd;
 
@@ -721,7 +768,8 @@ search_all_edk(const unsigned char *payload, const unsigned int plen)
 
 /* fast check for Direct Connect send command */
 static unsigned int
-search_dc(const unsigned char *payload, const unsigned int plen)
+search_dc(const unsigned char *payload, const unsigned int plen,
+	  const struct ipt_p2p_info *info)
 {
 	if (plen < 6)
 		return 0;
@@ -734,7 +782,8 @@ search_dc(const unsigned char *payload, const unsigned int plen)
 
 /* intensive but slower check for all direct connect packets */
 static unsigned int
-search_all_dc(const unsigned char *payload, const unsigned int plen)
+search_all_dc(const unsigned char *payload, const unsigned int plen,
+	      const struct ipt_p2p_info *info)
 {
 	const unsigned char *t;
 
@@ -765,7 +814,8 @@ search_all_dc(const unsigned char *payload, const unsigned int plen)
 
 /* check for mute */
 static unsigned int
-search_mute(const unsigned char *payload, const unsigned int plen)
+search_mute(const unsigned char *payload, const unsigned int plen,
+	    const struct ipt_p2p_info *info)
 {
 	if (plen == 209 || plen == 345 || plen == 473 || plen == 609 ||
 	    plen == 1121) {
@@ -783,10 +833,11 @@ search_mute(const unsigned char *payload, const unsigned int plen)
 
 /* check for xdcc */
 static unsigned int
-search_xdcc(const unsigned char *payload, const unsigned int plen)
+search_xdcc(const unsigned char *payload, const unsigned int plen,
+	    const struct ipt_p2p_info *info)
 {
-	uint16_t x = 10;
-	const uint16_t end = plen - 13;
+	struct ts_state state;
+	unsigned int pos;
 
 	/* search in small packets only */
 	if (plen <= 20 || plen >= 200)
@@ -795,22 +846,19 @@ search_xdcc(const unsigned char *payload, const unsigned int plen)
 	if (memcmp(payload, "PRIVMSG ", 8) != 0 || !iscrlf(&payload[plen - 2]))
 		return 0;
 
-	/*
-	 * is seems to be a irc private massage, chedck for
-	 * xdcc command
-	 */
-	while (x < end)	{
-		if (payload[x] == ':' &&
-		    memcmp(&payload[x + 1], "xdcc send #", 11) == 0)
-			return IPP2P_XDCC * 100 + 0;
-		x++;
-	}
+	/* seems to be a irc private massage, check for xdcc command */
+	pos = textsearch_find_continuous(info->ts_conf_xdcc,
+					 &state, &payload[8], plen - 8);
+	if (pos != UINT_MAX)
+		return IPP2P_XDCC * 100 + 0;
+
 	return 0;
 }
 
 /* search for waste */
 static unsigned int
-search_waste(const unsigned char *payload, const unsigned int plen)
+search_waste(const unsigned char *payload, const unsigned int plen,
+	     const struct ipt_p2p_info *info)
 {
 	if (plen >= 9 && memcmp(payload, "GET.sha1:", 9) == 0)
 		return IPP2P_WASTE * 100 + 0;
@@ -821,7 +869,8 @@ search_waste(const unsigned char *payload, const unsigned int plen)
 static const struct {
 	unsigned int command;
 	unsigned int packet_len;
-	unsigned int (*function_name)(const unsigned char *, const unsigned int);
+	unsigned int (*function_name)(const unsigned char *, const unsigned int,
+				      const struct ipt_p2p_info *);
 } matchlist[] = {
 	{IPP2P_EDK,         20, search_all_edk},
 	{IPP2P_DATA_KAZAA, 200, search_kazaa}, /* exp */
@@ -845,7 +894,8 @@ static const struct {
 static const struct {
 	unsigned int command;
 	unsigned int packet_len;
-	unsigned int (*function_name)(const unsigned char *, const unsigned int);
+	unsigned int (*function_name)(const unsigned char *, const unsigned int,
+				      const struct ipt_p2p_info *);
 } udp_list[] = {
 	{IPP2P_KAZAA, 14, udp_search_kazaa},
 	{IPP2P_BIT,   23, udp_search_bit},
@@ -901,7 +951,7 @@ ipp2p_mt_tcp(const struct ipt_p2p_info *info, const struct tcphdr *tcph,
 			continue;
 		if (hlen <= matchlist[i].packet_len)
 			continue;
-		if (matchlist[i].function_name(haystack, hlen))	{
+		if (matchlist[i].function_name(haystack, hlen, info)) {
 			if (info->debug)
 				print_result(rp, true, hlen);
 			return true;
@@ -952,7 +1002,7 @@ ipp2p_mt_udp(const struct ipt_p2p_info *info, const struct udphdr *udph,
 			continue;
 		if (hlen <= udp_list[i].packet_len)
 			continue;
-		if (udp_list[i].function_name(haystack, hlen)) {
+		if (udp_list[i].function_name(haystack, hlen, info)) {
 			if (info->debug)
 				print_result(rp, true, hlen);
 			return true;
@@ -1041,12 +1091,118 @@ ipp2p_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	}
 }
 
+static int ipp2p_mt_check(const struct xt_mtchk_param *par)
+{
+	struct ipt_p2p_info *info = par->matchinfo;
+	struct ts_config *ts_conf;
+
+	ts_conf = textsearch_prepare("bm", "\x20\x22", 2,
+				     GFP_KERNEL, TS_AUTOLOAD);
+	if (IS_ERR(ts_conf))
+		goto err_return;
+	info->ts_conf_winmx = ts_conf;
+
+	ts_conf = textsearch_prepare("bm", "info_hash=", 10,
+				     GFP_KERNEL, TS_AUTOLOAD);
+	if (IS_ERR(ts_conf))
+		goto err_ts_destroy_winmx;
+	info->ts_conf_bt_info_hash = ts_conf;
+
+	ts_conf = textsearch_prepare("bm", "peer_id=", 8,
+				     GFP_KERNEL, TS_AUTOLOAD);
+	if (IS_ERR(ts_conf))
+		goto err_ts_destroy_bt_info_hash;
+	info->ts_conf_bt_peer_id = ts_conf;
+
+	ts_conf = textsearch_prepare("bm", "passkey", 8,
+				     GFP_KERNEL, TS_AUTOLOAD);
+	if (IS_ERR(ts_conf))
+		goto err_ts_destroy_bt_peer_id;
+	info->ts_conf_bt_passkey = ts_conf;
+
+	ts_conf = textsearch_prepare("bm", "\r\nX-Gnutella-", 13,
+				     GFP_KERNEL, TS_AUTOLOAD);
+	if (IS_ERR(ts_conf))
+		goto err_ts_destroy_bt_passkey;
+	info->ts_conf_gnu_x_gnutella = ts_conf;
+
+	ts_conf = textsearch_prepare("bm", "\r\nX-Queue-", 10,
+				     GFP_KERNEL, TS_AUTOLOAD);
+	if (IS_ERR(ts_conf))
+		goto err_ts_destroy_gnu_x_gnutella;
+	info->ts_conf_gnu_x_queue = ts_conf;
+
+	ts_conf = textsearch_prepare("bm", "\r\nX-Kazaa-Username: ", 20,
+				     GFP_KERNEL, TS_AUTOLOAD);
+	if (IS_ERR(ts_conf))
+		goto err_ts_destroy_gnu_x_queue;
+	info->ts_conf_kz_x_kazaa_username = ts_conf;
+
+	ts_conf = textsearch_prepare("bm", "\r\nUser-Agent: PeerEnabler/", 26,
+				     GFP_KERNEL, TS_AUTOLOAD);
+	if (IS_ERR(ts_conf))
+		goto err_ts_destroy_kazaa_x_kazaa_username;
+	info->ts_conf_kz_user_agent = ts_conf;
+
+	ts_conf = textsearch_prepare("bm", ":xdcc send #", 12,
+				     GFP_KERNEL, TS_AUTOLOAD);
+	if (IS_ERR(ts_conf))
+		goto err_ts_destroy_kazaa_user_agent;
+	info->ts_conf_xdcc = ts_conf;
+
+	return 0;
+
+err_ts_destroy_kazaa_user_agent:
+	textsearch_destroy(info->ts_conf_kz_user_agent);
+
+err_ts_destroy_kazaa_x_kazaa_username:
+	textsearch_destroy(info->ts_conf_kz_x_kazaa_username);
+
+err_ts_destroy_gnu_x_queue:
+	textsearch_destroy(info->ts_conf_gnu_x_queue);
+
+err_ts_destroy_gnu_x_gnutella:
+	textsearch_destroy(info->ts_conf_gnu_x_gnutella);
+
+err_ts_destroy_bt_passkey:
+	textsearch_destroy(info->ts_conf_bt_passkey);
+
+err_ts_destroy_bt_peer_id:
+	textsearch_destroy(info->ts_conf_bt_peer_id);
+
+err_ts_destroy_bt_info_hash:
+	textsearch_destroy(info->ts_conf_bt_info_hash);
+
+err_ts_destroy_winmx:
+	textsearch_destroy(info->ts_conf_winmx);
+
+err_return:
+	return PTR_ERR(ts_conf);
+}
+
+static void ipp2p_mt_destroy(const struct xt_mtdtor_param *par)
+{
+	struct ipt_p2p_info *info = (struct ipt_p2p_info *) par->matchinfo;
+
+	textsearch_destroy(info->ts_conf_winmx);
+	textsearch_destroy(info->ts_conf_bt_info_hash);
+	textsearch_destroy(info->ts_conf_bt_peer_id);
+	textsearch_destroy(info->ts_conf_bt_passkey);
+	textsearch_destroy(info->ts_conf_gnu_x_gnutella);
+	textsearch_destroy(info->ts_conf_gnu_x_queue);
+	textsearch_destroy(info->ts_conf_kz_x_kazaa_username);
+	textsearch_destroy(info->ts_conf_kz_user_agent);
+	textsearch_destroy(info->ts_conf_xdcc);
+}
+
 static struct xt_match ipp2p_mt_reg[] __read_mostly = {
 	{
 		.name       = "ipp2p",
 		.revision   = 1,
 		.family     = NFPROTO_IPV4,
+		.checkentry = ipp2p_mt_check,
 		.match      = ipp2p_mt,
+		.destroy    = ipp2p_mt_destroy,
 		.matchsize  = sizeof(struct ipt_p2p_info),
 		.me         = THIS_MODULE,
 	},
@@ -1054,7 +1210,9 @@ static struct xt_match ipp2p_mt_reg[] __read_mostly = {
 		.name       = "ipp2p",
 		.revision   = 1,
 		.family     = NFPROTO_IPV6,
+		.checkentry = ipp2p_mt_check,
 		.match      = ipp2p_mt,
+		.destroy    = ipp2p_mt_destroy,
 		.matchsize  = sizeof(struct ipt_p2p_info),
 		.me         = THIS_MODULE,
 	},
diff --git a/extensions/xt_ipp2p.h b/extensions/xt_ipp2p.h
index f463f7f6e630..b821d75220b6 100644
--- a/extensions/xt_ipp2p.h
+++ b/extensions/xt_ipp2p.h
@@ -39,4 +39,14 @@ enum {
 
 struct ipt_p2p_info {
 	int32_t cmd, debug;
+
+	struct ts_config *ts_conf_winmx;
+	struct ts_config *ts_conf_bt_info_hash;
+	struct ts_config *ts_conf_bt_peer_id;
+	struct ts_config *ts_conf_bt_passkey;
+	struct ts_config *ts_conf_gnu_x_gnutella;
+	struct ts_config *ts_conf_gnu_x_queue;
+	struct ts_config *ts_conf_kz_x_kazaa_username;
+	struct ts_config *ts_conf_kz_user_agent;
+	struct ts_config *ts_conf_xdcc;
 };
-- 
2.39.2

