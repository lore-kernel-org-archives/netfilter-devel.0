Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD35DC7EE25
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jun 2023 19:20:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233779AbjFETUS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Jun 2023 15:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235789AbjFETT5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jun 2023 15:19:57 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944B1170B
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Jun 2023 12:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=X1PLO31cYd1ePLbxVr66A+uIeB2VQYBsFpxqtS5/6hQ=; b=eD8eGibizk3fGZ8AdfE1oavSsn
        d2RUnlh2vpgAgRXuBt3SnXhwY+pNuAasayNH4mdM3bAbSghYBpIPjXSZWoxR899wyVg9av7SPzslX
        dE7DnVRTBHDjG58/xYXbycuxdcxSA/uHriMfDcKOQ9UUsDbd9x6MkGOmeMEmcKwhkuAwM2k0lXppF
        XtX0RC5byiON5NLtiEU6jZ/vOB/FlxUBQ+N4qXlIRBJDRoKMh9Q2pGOMbFWyUJQd2H+U9phQsbPSm
        hw//qnV31DHTJ790P4lMkSUeNoyl7JZMUnk5M2yQ53UAoZ8pY/Yibm2DmxK24inaUVC4xFi5p4R+2
        lu08lxFw==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q6FjL-00H0rc-D0
        for netfilter-devel@vger.kernel.org; Mon, 05 Jun 2023 20:19:03 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 7/8] xt_ipp2p: use `skb_header_pointer` and `skb_find_text`
Date:   Mon,  5 Jun 2023 20:17:34 +0100
Message-Id: <20230605191735.119210-8-jeremy@azazel.net>
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

Use `skb_header_pointer` to copy byte-ranges for matching and
`skb_find_text` for substring searches.  Doing so allows the module to
work with non-linear skbs.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/xt_ipp2p.c | 487 ++++++++++++++++++++++++++++++++----------
 1 file changed, 372 insertions(+), 115 deletions(-)

diff --git a/extensions/xt_ipp2p.c b/extensions/xt_ipp2p.c
index 1378701605c3..def2d1ffc7bf 100644
--- a/extensions/xt_ipp2p.c
+++ b/extensions/xt_ipp2p.c
@@ -1,5 +1,6 @@
 #include <linux/gfp.h>
 #include <linux/module.h>
+#include <linux/skbuff.h>
 #include <linux/textsearch.h>
 #include <linux/version.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
@@ -38,7 +39,9 @@ ipv6_transport_len(const struct sk_buff *skb)
 struct ipp2p_result_printer {
 	const union nf_inet_addr *saddr, *daddr;
 	short sport, dport;
-	void (*print)(const union nf_inet_addr *, short, const union nf_inet_addr *, short, bool, unsigned int);
+	void (*print)(const union nf_inet_addr *, short,
+		      const union nf_inet_addr *, short,
+		      bool, unsigned int);
 };
 
 static bool iscrlf(const unsigned char *str)
@@ -57,12 +60,23 @@ print_result(const struct ipp2p_result_printer *rp, bool result,
 
 /* Search for UDP eDonkey/eMule/Kad commands */
 static unsigned int
-udp_search_edk(const unsigned char *t, const unsigned int packet_len,
+udp_search_edk(const struct sk_buff *skb,
+	       const unsigned int packet_off,
+	       const unsigned int packet_len,
 	       const struct ipt_p2p_info *info)
 {
+	unsigned char buf[36], *t;
+
 	if (packet_len < 4)
 		return 0;
 
+	t = skb_header_pointer(skb, packet_off,
+			       packet_len < sizeof(buf) ?
+			       packet_len : sizeof(buf),
+			       buf);
+	if (t == NULL)
+		return 0;
+
 	switch (t[0]) {
 	case 0xe3:
 		/* edonkey */
@@ -176,9 +190,20 @@ udp_search_edk(const unsigned char *t, const unsigned int packet_len,
 
 /* Search for UDP Gnutella commands */
 static unsigned int
-udp_search_gnu(const unsigned char *t, const unsigned int packet_len,
+udp_search_gnu(const struct sk_buff *skb,
+	       const unsigned int packet_off,
+	       const unsigned int packet_len,
 	       const struct ipt_p2p_info *info)
 {
+	unsigned char buf[9], *t;
+
+	t = skb_header_pointer(skb, packet_off,
+			       packet_len < sizeof(buf) ?
+			       packet_len : sizeof(buf),
+			       buf);
+	if (t == NULL)
+		return 0;
+
 	if (packet_len >= 3 && memcmp(t, "GND", 3) == 0)
 		return IPP2P_GNU * 100 + 51;
 	if (packet_len >= 9 && memcmp(t, "GNUTELLA ", 9) == 0)
@@ -188,39 +213,73 @@ udp_search_gnu(const unsigned char *t, const unsigned int packet_len,
 
 /* Search for UDP KaZaA commands */
 static unsigned int
-udp_search_kazaa(const unsigned char *t, const unsigned int packet_len,
+udp_search_kazaa(const struct sk_buff *skb,
+		 const unsigned int packet_off,
+		 const unsigned int packet_len,
 		 const struct ipt_p2p_info *info)
 {
+	unsigned char buf[6], *t;
+
 	if (packet_len < 6)
 		return 0;
-	if (memcmp(t + packet_len - 6, "KaZaA\x00", 6) == 0)
+
+	t = skb_header_pointer(skb, packet_off + packet_len - 6, 6, buf);
+	if (t == NULL)
+		return 0;
+
+	if (memcmp(t, "KaZaA\x00", 6) == 0)
 		return IPP2P_KAZAA * 100 + 50;
 	return 0;
 }
 
 /* Search for UDP DirectConnect commands */
 static unsigned int
-udp_search_directconnect(const unsigned char *t, const unsigned int packet_len,
+udp_search_directconnect(const struct sk_buff *skb,
+			 const unsigned int packet_off,
+			 const unsigned int packet_len,
 			 const struct ipt_p2p_info *info)
 {
+	unsigned char hbuf[6], *head, tbuf, *tail;
+
 	if (packet_len < 5)
 		return 0;
-	if (t[0] != 0x24)
+
+	head = skb_header_pointer(skb, packet_off, packet_len < 7 ? 4 : 6,
+				  hbuf);
+	if (head == NULL)
 		return 0;
-	if (t[packet_len-1] != 0x7c)
+
+	tail = skb_header_pointer(skb, packet_off + packet_len - 1, 1, &tbuf);
+	if (tail == NULL)
 		return 0;
-	if (memcmp(&t[1], "SR ", 3) == 0)
+
+	if (head[0] != 0x24)
+		return 0;
+	if (tail[0] != 0x7c)
+		return 0;
+	if (memcmp(&head[1], "SR ", 3) == 0)
 		return IPP2P_DC * 100 + 60;
-	if (packet_len >= 7 && memcmp(&t[1], "Ping ", 5) == 0)
+	if (packet_len >= 7 && memcmp(&head[1], "Ping ", 5) == 0)
 		return IPP2P_DC * 100 + 61;
 	return 0;
 }
 
 /* Search for UDP BitTorrent commands */
 static unsigned int
-udp_search_bit(const unsigned char *haystack, const unsigned int packet_len,
+udp_search_bit(const struct sk_buff *skb,
+	       const unsigned int packet_off,
+	       const unsigned int packet_len,
 	       const struct ipt_p2p_info *info)
 {
+	unsigned char buf[32], *haystack;
+
+	haystack = skb_header_pointer(skb, packet_off,
+				      packet_len < sizeof(buf) ?
+				      packet_len : sizeof(buf),
+				      buf);
+	if (haystack == NULL)
+		return 0;
+
 	switch (packet_len) {
 	case 16:
 		/* ^ 00 00 04 17 27 10 19 80 */
@@ -305,11 +364,22 @@ udp_search_bit(const unsigned char *haystack, const unsigned int packet_len,
 
 /* Search for Ares commands */
 static unsigned int
-search_ares(const unsigned char *payload, const unsigned int plen,
+search_ares(const struct sk_buff *skb,
+	    const unsigned int poff,
+	    const unsigned int plen,
 	    const struct ipt_p2p_info *info)
 {
+	unsigned char buf[60], *payload;
+
 	if (plen < 3)
 		return 0;
+
+	payload = skb_header_pointer(skb, poff,
+				     plen < sizeof(buf) ? plen : sizeof(buf),
+				     buf);
+	if (payload == NULL)
+		return 0;
+
 	/* all ares packets start with  */
 	if (payload[1] == 0 && plen - payload[0] == 3) {
 		switch (payload[2]) {
@@ -358,11 +428,22 @@ search_ares(const unsigned char *payload, const unsigned int plen,
 
 /* Search for SoulSeek commands */
 static unsigned int
-search_soul(const unsigned char *payload, const unsigned int plen,
+search_soul(const struct sk_buff *skb,
+	    const unsigned int poff,
+	    const unsigned int plen,
 	    const struct ipt_p2p_info *info)
 {
+	unsigned char buf[16], *payload;
+
 	if (plen < 8)
 		return 0;
+
+	payload = skb_header_pointer(skb, poff,
+				     plen < sizeof(buf) ? plen : sizeof(buf),
+				     buf);
+	if (payload == NULL)
+		return 0;
+
 	/* match: xx xx xx xx | xx = sizeof(payload) - 4 */
 	if (get_u32(payload, 0) == plen - 4) {
 		const uint32_t m = get_u32(payload, 4);
@@ -461,12 +542,20 @@ search_soul(const unsigned char *payload, const unsigned int plen,
 	if (get_u32(payload, 0) == 0x14 && get_u8(payload, 4) == 0x01) {
 		uint32_t y = get_u32(payload, 5);
 		const unsigned char *w;
+		unsigned int off, len;
 
 		/* we need 19 chars + string */
 		if (plen < y + 19)
 			return 0;
 
-		w = payload + 9 + y;
+		off = poff + y + 9;
+		len = plen - y + 9;
+
+		w = skb_header_pointer(skb, off,
+				       len < sizeof(buf) ? len : sizeof(buf),
+				       buf);
+		if (w == NULL)
+			return 0;
 
 		if (get_u32(w, 0) == 0x01 &&
 		    (get_u16(w, 4) == 0x4600 ||
@@ -483,10 +572,19 @@ search_soul(const unsigned char *payload, const unsigned int plen,
 
 /* Search for WinMX commands */
 static unsigned int
-search_winmx(const unsigned char *payload, const unsigned int plen,
+search_winmx(const struct sk_buff *skb,
+	     const unsigned int poff,
+	     const unsigned int plen,
 	     const struct ipt_p2p_info *info)
 {
-	uint16_t start;
+	unsigned char buf[149], *payload;
+	uint16_t start = poff;
+
+	payload = skb_header_pointer(skb, poff,
+				     plen < sizeof(buf) ? plen : sizeof(buf),
+				     buf);
+	if (payload == NULL)
+		return 0;
 
 	if (plen == 4 && memcmp(payload, "SEND", 4) == 0)
 		return IPP2P_WINMX * 100 + 1;
@@ -500,23 +598,18 @@ search_winmx(const unsigned char *payload, const unsigned int plen,
 		return 0;
 
 	if (memcmp(payload, "SEND", 4) == 0)
-		start = 4;
+		start += 4;
 	else if (memcmp(payload, "GET", 3) == 0)
-		start = 3;
-	else
-		start = 0;
+		start += 3;
 
-	if (start) {
+	if (start > poff) {
 		uint8_t count = 0;
 
 		do {
-			struct ts_state state;
 			unsigned int pos;
 
-			pos = textsearch_find_continuous(info->ts_conf_winmx,
-							 &state,
-							 &payload[start],
-							 plen - start);
+			pos = skb_find_text((struct sk_buff *)skb, start,
+					    skb->len, info->ts_conf_winmx);
 			if (pos == UINT_MAX)
 				break;
 
@@ -525,7 +618,7 @@ search_winmx(const unsigned char *payload, const unsigned int plen,
 				return IPP2P_WINMX * 100 + 3;
 
 			start = pos + 2;
-		} while (start < plen);
+		} while (start < skb->len);
 	}
 
 	if (plen == 149 && payload[0] == '8') {
@@ -553,11 +646,22 @@ search_winmx(const unsigned char *payload, const unsigned int plen,
 
 /* Search for appleJuice commands */
 static unsigned int
-search_apple(const unsigned char *payload, const unsigned int plen,
+search_apple(const struct sk_buff *skb,
+	     const unsigned int poff,
+	     const unsigned int plen,
 	     const struct ipt_p2p_info *info)
 {
+	unsigned char buf[8], *payload;
+
 	if (plen < 8)
 		return 0;
+
+	payload = skb_header_pointer(skb, poff,
+				     plen < sizeof(buf) ? plen : sizeof(buf),
+				     buf);
+	if (payload == NULL)
+		return 0;
+
 	if (memcmp(payload, "ajprot\r\n", 8) == 0)
 		return IPP2P_APPLE * 100;
 	return 0;
@@ -565,12 +669,20 @@ search_apple(const unsigned char *payload, const unsigned int plen,
 
 /* Search for BitTorrent commands */
 static unsigned int
-search_bittorrent(const unsigned char *payload, const unsigned int plen,
+search_bittorrent(const struct sk_buff *skb,
+		  const unsigned int poff,
+		  const unsigned int plen,
 		  const struct ipt_p2p_info *info)
 {
-	struct ts_state state;
+	unsigned char buf[20], *payload;
 	unsigned int pos;
 
+	payload = skb_header_pointer(skb, poff,
+				     plen < sizeof(buf) ? plen : sizeof(buf),
+				     buf);
+	if (payload == NULL)
+		return 0;
+
 	/*
 	 * bitcomet encrypts the first packet, so we have to detect another one
 	 * later in the flow.
@@ -598,18 +710,18 @@ search_bittorrent(const unsigned char *payload, const unsigned int plen,
 	if (memcmp(payload, "GET /", 5) != 0)
 		return 0;
 
-	pos = textsearch_find_continuous(info->ts_conf_bt_info_hash,
-					 &state, &payload[5], plen - 5);
+	pos = skb_find_text((struct sk_buff *)skb, poff + 5, skb->len,
+			    info->ts_conf_bt_info_hash);
 	if (pos != UINT_MAX)
 		return IPP2P_BIT * 100 + 1;
 
-	pos = textsearch_find_continuous(info->ts_conf_bt_peer_id,
-					 &state, &payload[5], plen - 5);
+	pos = skb_find_text((struct sk_buff *)skb, poff + 5, skb->len,
+			    info->ts_conf_bt_peer_id);
 	if (pos != UINT_MAX)
 		return IPP2P_BIT * 100 + 2;
 
-	pos = textsearch_find_continuous(info->ts_conf_bt_passkey,
-					 &state, &payload[5], plen - 5);
+	pos = skb_find_text((struct sk_buff *)skb, poff + 5, skb->len,
+			    info->ts_conf_bt_passkey);
 	if (pos != UINT_MAX)
 		return IPP2P_BIT * 100 + 4;
 
@@ -618,13 +730,25 @@ search_bittorrent(const unsigned char *payload, const unsigned int plen,
 
 /* check for Kazaa get command */
 static unsigned int
-search_kazaa(const unsigned char *payload, const unsigned int plen,
+search_kazaa(const struct sk_buff *skb,
+	     const unsigned int poff,
+	     const unsigned int plen,
 	     const struct ipt_p2p_info *info)
 {
+	unsigned char hbuf[11], *head, tbuf[2], *tail;
+
 	if (plen < 13)
 		return 0;
-	if (iscrlf(&payload[plen - 2]) &&
-	    memcmp(payload, "GET /.hash=", 11) == 0)
+
+	head = skb_header_pointer(skb, poff, 11, hbuf);
+	if (head == NULL)
+		return 0;
+
+	tail = skb_header_pointer(skb, poff + plen - 2, 2, tbuf);
+	if (tail == NULL)
+		return 0;
+
+	if (iscrlf(tail) && memcmp(head, "GET /.hash=", 11) == 0)
 		return IPP2P_DATA_KAZAA * 100;
 
 	return 0;
@@ -632,54 +756,87 @@ search_kazaa(const unsigned char *payload, const unsigned int plen,
 
 /* check for gnutella get command */
 static unsigned int
-search_gnu(const unsigned char *payload, const unsigned int plen,
+search_gnu(const struct sk_buff *skb,
+	   const unsigned int poff,
+	   const unsigned int plen,
 	   const struct ipt_p2p_info *info)
 {
+	unsigned char hbuf[15], *head, tbuf[2], *tail;
+
 	if (plen < 11)
 		return 0;
-	if (!iscrlf(&payload[plen - 2]))
+
+	head = skb_header_pointer(skb, poff,
+				  plen - 2 < sizeof(hbuf) ?
+				  plen - 2 : sizeof(hbuf),
+				  hbuf);
+	if (head == NULL)
+		return 0;
+
+	tail = skb_header_pointer(skb, poff + plen - 2, 2, tbuf);
+	if (tail == NULL)
+		return 0;
+
+	if (!iscrlf(tail))
 		return 0;
-	if (memcmp(payload, "GET /get/", 9) == 0)
+	if (memcmp(head, "GET /get/", 9) == 0)
 		return IPP2P_DATA_GNU * 100 + 1;
-	if (plen >= 15 && memcmp(payload, "GET /uri-res/", 13) == 0)
+	if (plen >= 15 && memcmp(head, "GET /uri-res/", 13) == 0)
 		return IPP2P_DATA_GNU * 100 + 2;
 	return 0;
 }
 
 /* check for gnutella get commands and other typical data */
 static unsigned int
-search_all_gnu(const unsigned char *payload, const unsigned int plen,
+search_all_gnu(const struct sk_buff *skb,
+	       const unsigned int poff,
+	       const unsigned int plen,
 	       const struct ipt_p2p_info *info)
 {
-	struct ts_state state;
-	unsigned int c, pos;
+	unsigned char hbuf[17], *head, tbuf[2], *tail;
+	unsigned int off, pos;
 
 	if (plen < 11)
 		return 0;
-	if (!iscrlf(&payload[plen - 2]))
+
+	head = skb_header_pointer(skb, poff,
+				  plen - 2 < sizeof(hbuf) ?
+				  plen - 2 : sizeof(hbuf),
+				  hbuf);
+	if (head == NULL)
+		return 0;
+
+	tail = skb_header_pointer(skb, poff + plen - 2, 2, tbuf);
+	if (tail == NULL)
 		return 0;
-	if (plen >= 19 && memcmp(payload, "GNUTELLA CONNECT/", 17) == 0)
+
+	if (!iscrlf(tail))
+		return 0;
+
+	if (plen >= 19 && memcmp(head, "GNUTELLA CONNECT/", 17) == 0)
 		return IPP2P_GNU * 100 + 1;
-	if (memcmp(payload, "GNUTELLA/", 9) == 0)
+
+	if (memcmp(head, "GNUTELLA/", 9) == 0)
 		return IPP2P_GNU * 100 + 2;
 
 	if (plen < 22)
 		return 0;
 
-	if (memcmp(payload, "GET /get/", 9) == 0)
-		c = 9;
-	else if (memcmp(payload, "GET /uri-res/", 13) == 0)
-		c = 13;
+	if (memcmp(head, "GET /get/", 9) == 0)
+		off = 9;
+	else if (memcmp(head, "GET /uri-res/", 13) == 0)
+		off = 13;
 	else
 		return 0;
 
-	pos = textsearch_find_continuous(info->ts_conf_gnu_x_gnutella,
-					 &state, &payload[c], plen - c);
+	pos = skb_find_text((struct sk_buff *)skb, poff + off, skb->len,
+			    info->ts_conf_gnu_x_gnutella);
 	if (pos != UINT_MAX)
 		return IPP2P_GNU * 100 + 3;
 
-	pos = textsearch_find_continuous(info->ts_conf_gnu_x_queue,
-					 &state, &payload[c], plen - c);
+	pos = skb_find_text((struct sk_buff *)skb, poff + off, skb->len,
+			    info->ts_conf_gnu_x_queue);
+
 	if (pos != UINT_MAX)
 		return IPP2P_GNU * 100 + 3;
 
@@ -689,36 +846,46 @@ search_all_gnu(const unsigned char *payload, const unsigned int plen,
 /* check for KaZaA download commands and other typical data */
 /* plen is guaranteed to be >= 5 (see @matchlist) */
 static unsigned int
-search_all_kazaa(const unsigned char *payload, const unsigned int plen,
+search_all_kazaa(const struct sk_buff *skb,
+		 const unsigned int poff,
+		 const unsigned int plen,
 		 const struct ipt_p2p_info *info)
 {
-	struct ts_state state;
+	unsigned char hbuf[5], *head, tbuf[2], *tail;
 	unsigned int pos;
 
 	if (plen < 7)
 		/* too short for anything we test for - early bailout */
 		return 0;
 
-	if (!iscrlf(&payload[plen - 2]))
+	head = skb_header_pointer(skb, poff, sizeof(hbuf), hbuf);
+	if (head == NULL)
+		return 0;
+
+	tail = skb_header_pointer(skb, poff + plen - 2, 2, tbuf);
+	if (tail == NULL)
 		return 0;
 
-	if (memcmp(payload, "GIVE ", 5) == 0)
+	if (!iscrlf(tail))
+		return 0;
+
+	if (memcmp(head, "GIVE ", 5) == 0)
 		return IPP2P_KAZAA * 100 + 1;
 
-	if (memcmp(payload, "GET /", 5) != 0)
+	if (memcmp(head, "GET /", 5) != 0)
 		return 0;
 
 	if (plen < 18)
 		/* The next tests would not succeed anyhow. */
 		return 0;
 
-	pos = textsearch_find_continuous(info->ts_conf_kz_x_kazaa_username,
-					 &state, &payload[5], plen - 5);
+	pos = skb_find_text((struct sk_buff *)skb, poff + 5, skb->len,
+			    info->ts_conf_kz_x_kazaa_username);
 	if (pos != UINT_MAX)
 		return IPP2P_KAZAA * 100 + 2;
 
-	pos = textsearch_find_continuous(info->ts_conf_kz_user_agent,
-					 &state, &payload[5], plen - 5);
+	pos = skb_find_text((struct sk_buff *)skb, poff + 5, skb->len,
+			    info->ts_conf_kz_user_agent);
 	if (pos != UINT_MAX)
 		return IPP2P_KAZAA * 100 + 2;
 
@@ -727,11 +894,20 @@ search_all_kazaa(const unsigned char *payload, const unsigned int plen,
 
 /* fast check for edonkey file segment transfer command */
 static unsigned int
-search_edk(const unsigned char *payload, const unsigned int plen,
+search_edk(const struct sk_buff *skb,
+	   const unsigned int poff,
+	   const unsigned int plen,
 	   const struct ipt_p2p_info *info)
 {
+	unsigned char buf[6], *payload;
+
 	if (plen < 6)
 		return 0;
+
+	payload = skb_header_pointer(skb, poff, sizeof(buf), buf);
+	if (payload == NULL)
+		return 0;
+
 	if (payload[0] != 0xe3)
 		return 0;
 	if (payload[5] == 0x47)
@@ -741,13 +917,21 @@ search_edk(const unsigned char *payload, const unsigned int plen,
 
 /* intensive but slower search for some edonkey packets including size-check */
 static unsigned int
-search_all_edk(const unsigned char *payload, const unsigned int plen,
+search_all_edk(const struct sk_buff *skb,
+	       const unsigned int poff,
+	       const unsigned int plen,
 	       const struct ipt_p2p_info *info)
 {
+	unsigned char buf[6], *payload;
 	unsigned int cmd;
 
 	if (plen < 6)
 		return 0;
+
+	payload = skb_header_pointer(skb, poff, sizeof(buf), buf);
+	if (payload == NULL)
+		return 0;
+
 	if (payload[0] != 0xe3)
 		return 0;
 
@@ -768,11 +952,20 @@ search_all_edk(const unsigned char *payload, const unsigned int plen,
 
 /* fast check for Direct Connect send command */
 static unsigned int
-search_dc(const unsigned char *payload, const unsigned int plen,
+search_dc(const struct sk_buff *skb,
+	  const unsigned int poff,
+	  const unsigned int plen,
 	  const struct ipt_p2p_info *info)
 {
+	unsigned char buf[6], *payload;
+
 	if (plen < 6)
 		return 0;
+
+	payload = skb_header_pointer(skb, poff, sizeof(buf), buf);
+	if (payload == NULL)
+		return 0;
+
 	if (payload[0] != 0x24)
 		return 0;
 	if (memcmp(&payload[1], "Send|", 5) == 0)
@@ -782,21 +975,35 @@ search_dc(const unsigned char *payload, const unsigned int plen,
 
 /* intensive but slower check for all direct connect packets */
 static unsigned int
-search_all_dc(const unsigned char *payload, const unsigned int plen,
+search_all_dc(const struct sk_buff *skb,
+	      const unsigned int poff,
+	      const unsigned int plen,
 	      const struct ipt_p2p_info *info)
 {
+	unsigned char hbuf[8], *head, tbuf, *tail;
 	const unsigned char *t;
 
 	if (plen < 7)
 		return 0;
 
-	if (payload[0] != 0x24)
+	head = skb_header_pointer(skb, poff,
+				  plen - 1 < sizeof(hbuf) ?
+				  plen - 1 : sizeof(hbuf),
+				  hbuf);
+	if (head == NULL)
 		return 0;
 
-	if (payload[plen-1] != 0x7c)
+	tail = skb_header_pointer(skb, poff + plen - 1, 1, &tbuf);
+	if (tail == NULL)
 		return 0;
 
-	t = &payload[1];
+	if (head[0] != 0x24)
+		return 0;
+
+	if (tail[0] != 0x7c)
+		return 0;
+
+	t = &head[1];
 
 	/* Client-Hub-Protocol */
 	if (memcmp(t, "Lock ", 5) == 0)
@@ -814,18 +1021,21 @@ search_all_dc(const unsigned char *payload, const unsigned int plen,
 
 /* check for mute */
 static unsigned int
-search_mute(const unsigned char *payload, const unsigned int plen,
+search_mute(const struct sk_buff *skb,
+	    const unsigned int poff,
+	    const unsigned int plen,
 	    const struct ipt_p2p_info *info)
 {
 	if (plen == 209 || plen == 345 || plen == 473 || plen == 609 ||
 	    plen == 1121) {
-		//printk(KERN_DEBUG "size hit: %u", size);
+		unsigned char buf[11], *payload;
+
+		payload = skb_header_pointer(skb, poff, sizeof(buf), buf);
+		if (payload == NULL)
+			return 0;
+
 		if (memcmp(payload,"PublicKey: ", 11) == 0) {
 			return IPP2P_MUTE * 100 + 0;
-			/*
-			if (memcmp(t + size - 14, "\x0aEndPublicKey\x0a", 14) == 0)
-				printk(KERN_DEBUG "end pubic key hit: %u", size);
-			*/
 		}
 	}
 	return 0;
@@ -833,22 +1043,35 @@ search_mute(const unsigned char *payload, const unsigned int plen,
 
 /* check for xdcc */
 static unsigned int
-search_xdcc(const unsigned char *payload, const unsigned int plen,
+search_xdcc(const struct sk_buff *skb,
+	    const unsigned int poff,
+	    const unsigned int plen,
 	    const struct ipt_p2p_info *info)
 {
-	struct ts_state state;
+	unsigned char hbuf[8], *head, tbuf[2], *tail;
 	unsigned int pos;
 
 	/* search in small packets only */
 	if (plen <= 20 || plen >= 200)
 		return 0;
 
-	if (memcmp(payload, "PRIVMSG ", 8) != 0 || !iscrlf(&payload[plen - 2]))
+	head = skb_header_pointer(skb, poff,
+				  plen - 2 < sizeof(hbuf) ?
+				  plen - 2 : sizeof(hbuf),
+				  hbuf);
+	if (head == NULL)
+		return 0;
+
+	tail = skb_header_pointer(skb, poff + plen - 2, 2, &tbuf);
+	if (tail == NULL)
+		return 0;
+
+	if (memcmp(head, "PRIVMSG ", 8) != 0 || !iscrlf(tail))
 		return 0;
 
 	/* seems to be a irc private massage, check for xdcc command */
-	pos = textsearch_find_continuous(info->ts_conf_xdcc,
-					 &state, &payload[8], plen - 8);
+	pos = skb_find_text((struct sk_buff *)skb, poff + 8, skb->len,
+			    info->ts_conf_xdcc);
 	if (pos != UINT_MAX)
 		return IPP2P_XDCC * 100 + 0;
 
@@ -857,10 +1080,23 @@ search_xdcc(const unsigned char *payload, const unsigned int plen,
 
 /* search for waste */
 static unsigned int
-search_waste(const unsigned char *payload, const unsigned int plen,
+search_waste(const struct sk_buff *skb,
+	     const unsigned int poff,
+	     const unsigned int plen,
 	     const struct ipt_p2p_info *info)
 {
-	if (plen >= 9 && memcmp(payload, "GET.sha1:", 9) == 0)
+	unsigned char buf[9], *payload;
+
+	if (plen < 9)
+		return 0;
+
+	payload = skb_header_pointer(skb, poff,
+				     plen < sizeof(buf) ? plen : sizeof(buf),
+				     buf);
+	if (payload == NULL)
+		return 0;
+
+	if (memcmp(payload, "GET.sha1:", 9) == 0)
 		return IPP2P_WASTE * 100 + 0;
 
 	return 0;
@@ -869,7 +1105,9 @@ search_waste(const unsigned char *payload, const unsigned int plen,
 static const struct {
 	unsigned int command;
 	unsigned int packet_len;
-	unsigned int (*function_name)(const unsigned char *, const unsigned int,
+	unsigned int (*function_name)(const struct sk_buff *,
+				      const unsigned int,
+				      const unsigned int,
 				      const struct ipt_p2p_info *);
 } matchlist[] = {
 	{IPP2P_EDK,         20, search_all_edk},
@@ -894,7 +1132,9 @@ static const struct {
 static const struct {
 	unsigned int command;
 	unsigned int packet_len;
-	unsigned int (*function_name)(const unsigned char *, const unsigned int,
+	unsigned int (*function_name)(const struct sk_buff *,
+				      const unsigned int,
+				      const unsigned int,
 				      const struct ipt_p2p_info *);
 } udp_list[] = {
 	{IPP2P_KAZAA, 14, udp_search_kazaa},
@@ -925,8 +1165,9 @@ ipp2p_print_result_tcp6(const union nf_inet_addr *saddr, short sport,
 
 static bool
 ipp2p_mt_tcp(const struct ipt_p2p_info *info, const struct tcphdr *tcph,
-             const unsigned char *haystack, unsigned int hlen,
-             const struct ipp2p_result_printer *rp)
+	     const struct sk_buff *skb, unsigned int packet_off,
+	     unsigned int packet_len,
+	     const struct ipp2p_result_printer *rp)
 {
 	size_t tcph_len = tcph->doff * 4;
 	int i;
@@ -935,25 +1176,26 @@ ipp2p_mt_tcp(const struct ipt_p2p_info *info, const struct tcphdr *tcph,
 	if (tcph->syn) return 0;  /* if SYN bit is set bail out */
 	if (tcph->rst) return 0;  /* if RST bit is set bail out */
 
-	if (hlen < tcph_len) {
+	if (packet_len < tcph_len) {
 		if (info->debug)
 			pr_info("TCP header indicated packet larger than it is\n");
 		return 0;
 	}
-	if (hlen == tcph_len)
+	if (packet_len == tcph_len)
 		return 0;
 
-	haystack += tcph_len;
-	hlen     -= tcph_len;
+	packet_off += tcph_len;
+	packet_len -= tcph_len;
 
 	for (i = 0; matchlist[i].command; ++i) {
 		if ((info->cmd & matchlist[i].command) != matchlist[i].command)
 			continue;
-		if (hlen <= matchlist[i].packet_len)
+		if (packet_len <= matchlist[i].packet_len)
 			continue;
-		if (matchlist[i].function_name(haystack, hlen, info)) {
+		if (matchlist[i].function_name(skb, packet_off, packet_len,
+					       info)) {
 			if (info->debug)
-				print_result(rp, true, hlen);
+				print_result(rp, true, packet_len);
 			return true;
 		}
 	}
@@ -980,31 +1222,33 @@ ipp2p_print_result_udp6(const union nf_inet_addr *saddr, short sport,
 
 static bool
 ipp2p_mt_udp(const struct ipt_p2p_info *info, const struct udphdr *udph,
-             const unsigned char *haystack, unsigned int hlen,
-             const struct ipp2p_result_printer *rp)
+	     const struct sk_buff *skb, unsigned int packet_off,
+	     unsigned int packet_len,
+	     const struct ipp2p_result_printer *rp)
 {
 	size_t udph_len = sizeof(*udph);
 	int i;
 
-	if (hlen < udph_len) {
+	if (packet_len < udph_len) {
 		if (info->debug)
 			pr_info("UDP header indicated packet larger than it is\n");
 		return 0;
 	}
-	if (hlen == udph_len)
+	if (packet_len == udph_len)
 		return 0;
 
-	haystack += udph_len;
-	hlen     -= udph_len;
+	packet_off += udph_len;
+	packet_len -= udph_len;
 
 	for (i = 0; udp_list[i].command; ++i) {
 		if ((info->cmd & udp_list[i].command) != udp_list[i].command)
 			continue;
-		if (hlen <= udp_list[i].packet_len)
+		if (packet_len <= udp_list[i].packet_len)
 			continue;
-		if (udp_list[i].function_name(haystack, hlen, info)) {
+		if (udp_list[i].function_name(skb, packet_off, packet_len,
+					      info)) {
 			if (info->debug)
-				print_result(rp, true, hlen);
+				print_result(rp, true, packet_len);
 			return true;
 		}
 	}
@@ -1017,9 +1261,8 @@ ipp2p_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	const struct ipt_p2p_info *info = par->matchinfo;
 	struct ipp2p_result_printer printer;
 	union nf_inet_addr saddr, daddr;
-	const unsigned char *haystack;  /* packet data */
-	unsigned int hlen;              /* packet data length */
 	uint8_t family = xt_family(par);
+	unsigned int packet_len;
 	int protocol;
 
 	/*
@@ -1044,10 +1287,11 @@ ipp2p_mt(const struct sk_buff *skb, struct xt_action_param *par)
 
 	if (family == NFPROTO_IPV4) {
 		const struct iphdr *ip = ip_hdr(skb);
+
 		saddr.ip = ip->saddr;
 		daddr.ip = ip->daddr;
 		protocol = ip->protocol;
-		hlen = ip_transport_len(skb);
+		packet_len = ip_transport_len(skb);
 	} else {
 		const struct ipv6hdr *ip = ipv6_hdr(skb);
 		int thoff = 0;
@@ -1057,34 +1301,47 @@ ipp2p_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		protocol = ipv6_find_hdr(skb, &thoff, -1, NULL, NULL);
 		if (protocol < 0)
 			return 0;
-		hlen = ipv6_transport_len(skb);
+		packet_len = ipv6_transport_len(skb);
 	}
 
 	printer.saddr = &saddr;
 	printer.daddr = &daddr;
-	haystack = skb_transport_header(skb);
 
 	switch (protocol) {
 	case IPPROTO_TCP:	/* what to do with a TCP packet */
 	{
-		const struct tcphdr *tcph = tcp_hdr(skb);
+		const struct tcphdr *tcph;
+		struct tcphdr _tcph;
+
+		tcph = skb_header_pointer(skb, par->thoff, sizeof(_tcph), &_tcph);
+		if (tcph == NULL)
+			return 0;
 
 		printer.sport = ntohs(tcph->source);
 		printer.dport = ntohs(tcph->dest);
 		printer.print = family == NFPROTO_IPV6 ?
 		                ipp2p_print_result_tcp6 : ipp2p_print_result_tcp4;
-		return ipp2p_mt_tcp(info, tcph, haystack, hlen, &printer);
+
+		return ipp2p_mt_tcp(info, tcph, skb, par->thoff, packet_len,
+				    &printer);
 	}
 	case IPPROTO_UDP:	/* what to do with a UDP packet */
 	case IPPROTO_UDPLITE:
 	{
-		const struct udphdr *udph = udp_hdr(skb);
+		const struct udphdr *udph;
+		struct udphdr _udph;
+
+		udph = skb_header_pointer(skb, par->thoff, sizeof(_udph), &_udph);
+		if (udph == NULL)
+			return 0;
 
 		printer.sport = ntohs(udph->source);
 		printer.dport = ntohs(udph->dest);
 		printer.print = family == NFPROTO_IPV6 ?
 		                ipp2p_print_result_udp6 : ipp2p_print_result_udp4;
-		return ipp2p_mt_udp(info, udph, haystack, hlen, &printer);
+
+		return ipp2p_mt_udp(info, udph, skb, par->thoff, packet_len,
+				    &printer);
 	}
 	default:
 		return 0;
-- 
2.39.2

