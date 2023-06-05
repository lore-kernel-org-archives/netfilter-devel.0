Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0835C7EE32
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jun 2023 19:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235392AbjFETUT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Jun 2023 15:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235787AbjFETT5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jun 2023 15:19:57 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4111708
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Jun 2023 12:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8cIxP02I6Y/JhU8MUgjYL5Rl75iOlhh0vPK83feuoAw=; b=MEGBdivVUVYbF7nZfG0ZHLidj6
        IgiGAL7nZeAItjK2hOuCbzmiKukDgummyqFgaHp/f5T2nnajz/sqDvRDn8nY50OjwYwpRZ5U6vLnR
        uYasn6/F3eV4qmxuD6Uno0kH0p4Z7BFgL7YZvNiMT9tlkhoBpcf4YXf9kliwZvS8OuTdlWNEeO03q
        wLzc0ueh4it+chXu3Dzcz0/ssv4UjnSGvfrnTViH0dMWD7I8FTg12M7AbRU3qXOS55BYEHqJxF6JW
        qwlzgqBDXv2so4C8n9HdSy/P/XLcedCKCVQ31BVfu65RuMqgH1es1Ut5omB2kCTATVg2wkvj+q8Zi
        e8vgn7uQ==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q6FjL-00H0rc-98
        for netfilter-devel@vger.kernel.org; Mon, 05 Jun 2023 20:19:03 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 5/8] xt_ipp2p: rearrange some conditionals and a couple of loops
Date:   Mon,  5 Jun 2023 20:17:32 +0100
Message-Id: <20230605191735.119210-6-jeremy@azazel.net>
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

Reduce indentation and improve the readability of the code.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/xt_ipp2p.c | 333 ++++++++++++++++++++++--------------------
 1 file changed, 172 insertions(+), 161 deletions(-)

diff --git a/extensions/xt_ipp2p.c b/extensions/xt_ipp2p.c
index de253c4f4cb4..ae9a3dd2a920 100644
--- a/extensions/xt_ipp2p.c
+++ b/extensions/xt_ipp2p.c
@@ -199,12 +199,14 @@ static unsigned int udp_search_directconnect(const unsigned char *t,
 {
 	if (packet_len < 5)
 		return 0;
-	if (t[0] == 0x24 && t[packet_len-1] == 0x7c) {
-		if (memcmp(&t[1], "SR ", 3) == 0)
-			return IPP2P_DC * 100 + 60;
-		if (packet_len >= 7 && memcmp(&t[1], "Ping ", 5) == 0)
-			return IPP2P_DC * 100 + 61;
-	}
+	if (t[0] != 0x24)
+		return 0;
+	if (t[packet_len-1] != 0x7c)
+		return 0;
+	if (memcmp(&t[1], "SR ", 3) == 0)
+		return IPP2P_DC * 100 + 60;
+	if (packet_len >= 7 && memcmp(&t[1], "Ping ", 5) == 0)
+		return IPP2P_DC * 100 + 61;
 	return 0;
 }
 
@@ -263,12 +265,14 @@ udp_search_bit(const unsigned char *haystack, const unsigned int packet_len)
 	}
 
 	/* some extra-bitcomet rules: "d1:" [a|r] "d2:id20:" */
-	if (packet_len > 22 && get_u8(haystack, 0) == 'd' &&
-	    get_u8(haystack, 1) == '1' && get_u8(haystack, 2) == ':')
-		if (get_u8(haystack, 3) == 'a' ||
-		    get_u8(haystack, 3) == 'r')
-			if (memcmp(haystack + 4, "d2:id20:", 8) == 0)
-				return IPP2P_BIT * 100 + 57;
+	if (packet_len > 22 &&
+	    get_u8(haystack, 0) == 'd' &&
+	    get_u8(haystack, 1) == '1' &&
+	    get_u8(haystack, 2) == ':' &&
+	    (get_u8(haystack, 3) == 'a' ||
+	     get_u8(haystack, 3) == 'r') &&
+	    memcmp(haystack + 4, "d2:id20:", 8) == 0)
+		return IPP2P_BIT * 100 + 57;
 
 #if 0
 	/* bitlord rules */
@@ -447,19 +451,22 @@ search_soul(const unsigned char *payload, const unsigned int plen)
 	/* without size at the beginning !!! */
 	if (get_u32(payload, 0) == 0x14 && get_u8(payload, 4) == 0x01) {
 		uint32_t y = get_u32(payload, 5);
+		const unsigned char *w;
 
 		/* we need 19 chars + string */
-		if (y + 19 <= plen) {
-			const unsigned char *w = payload + 9 + y;
-			if (get_u32(w, 0) == 0x01 &&
-			    (get_u16(w, 4) == 0x4600 ||
-			     get_u16(w, 4) == 0x5000) &&
-			    get_u32(w, 6) == 0x00) {
+		if (plen < y + 19)
+			return 0;
+
+		w = payload + 9 + y;
+
+		if (get_u32(w, 0) == 0x01 &&
+		    (get_u16(w, 4) == 0x4600 ||
+		     get_u16(w, 4) == 0x5000) &&
+		    get_u32(w, 6) == 0x00) {
 #ifdef IPP2P_DEBUG_SOUL
-				printk(KERN_DEBUG "Soulseek special client command recognized\n");
+			printk(KERN_DEBUG "Soulseek special client command recognized\n");
 #endif
-				return IPP2P_SOUL * 100 + 9;
-			}
+			return IPP2P_SOUL * 100 + 9;
 		}
 	}
 	return 0;
@@ -523,10 +530,10 @@ search_winmx(const unsigned char *payload, const unsigned int plen)
 static unsigned int
 search_apple(const unsigned char *payload, const unsigned int plen)
 {
-	if (plen > 7 && iscrlf(&payload[6]) &&
-	    memcmp(payload, "ajprot", 6) == 0)
+	if (plen < 8)
+		return 0;
+	if (memcmp(payload, "ajprot\r\n", 8) == 0)
 		return IPP2P_APPLE * 100;
-
 	return 0;
 }
 
@@ -534,41 +541,38 @@ search_apple(const unsigned char *payload, const unsigned int plen)
 static unsigned int
 search_bittorrent(const unsigned char *payload, const unsigned int plen)
 {
-	if (plen > 20) {
-		/* test for match 0x13+"BitTorrent protocol" */
-		if (payload[0] == 0x13)
-			if (memcmp(payload + 1, "BitTorrent protocol", 19) == 0)
-				return IPP2P_BIT * 100;
-		/*
-		 * Any tracker command starts with GET / then *may be* some file on web server
-		 * (e.g. announce.php or dupa.pl or whatever.cgi or NOTHING for tracker on root dir)
-		 * but *must have* one (or more) of strings listed below (true for scrape and announce)
-		 */
-		if (memcmp(payload, "GET /", 5) == 0) {
-			if (HX_memmem(payload, plen, "info_hash=", 10) != NULL)
-				return IPP2P_BIT * 100 + 1;
-			if (HX_memmem(payload, plen, "peer_id=", 8) != NULL)
-				return IPP2P_BIT * 100 + 2;
-			if (HX_memmem(payload, plen, "passkey=", 8) != NULL)
-				return IPP2P_BIT * 100 + 4;
-		}
-	} else {
-	    	/* bitcomet encryptes the first packet, so we have to detect another
-	    	 * one later in the flow */
-		/* first try failed, too many false positives */
-	    	/*
-		if (size == 5 && get_u32(t, 0) == __constant_htonl(1) &&
-		    t[4] < 3)
-			return IPP2P_BIT * 100 + 3;
-		*/
+	/*
+	 * bitcomet encrypts the first packet, so we have to detect another one
+	 * later in the flow.
+	 */
+	if (plen == 17 &&
+	    get_u32(payload, 0) == __constant_htonl(0x0d) &&
+	    payload[4] == 0x06 &&
+	    get_u32(payload,13) == __constant_htonl(0x4000))
+		return IPP2P_BIT * 100 + 3;
 
-	    	/* second try: block request packets */
-	    	if (plen == 17 &&
-		    get_u32(payload, 0) == __constant_htonl(0x0d) &&
-		    payload[4] == 0x06 &&
-		    get_u32(payload,13) == __constant_htonl(0x4000))
-			return IPP2P_BIT * 100 + 3;
-	}
+	if (plen <= 20)
+		return 0;
+
+	/* test for match 0x13+"BitTorrent protocol" */
+	if (payload[0] == 0x13)
+		if (memcmp(payload + 1, "BitTorrent protocol", 19) == 0)
+			return IPP2P_BIT * 100;
+
+	/*
+	 * Any tracker command starts with GET / then *may be* some file
+	 * on web server (e.g. announce.php or dupa.pl or whatever.cgi
+	 * or NOTHING for tracker on root dir) but *must have* one (or
+	 * more) of strings listed below (true for scrape and announce)
+	 */
+	if (memcmp(payload, "GET /", 5) != 0)
+		return 0;
+	if (HX_memmem(payload, plen, "info_hash=", 10) != NULL)
+		return IPP2P_BIT * 100 + 1;
+	if (HX_memmem(payload, plen, "peer_id=", 8) != NULL)
+		return IPP2P_BIT * 100 + 2;
+	if (HX_memmem(payload, plen, "passkey=", 8) != NULL)
+		return IPP2P_BIT * 100 + 4;
 
 	return 0;
 }
@@ -592,12 +596,12 @@ search_gnu(const unsigned char *payload, const unsigned int plen)
 {
 	if (plen < 11)
 		return 0;
-	if (iscrlf(&payload[plen - 2])) {
-		if (memcmp(payload, "GET /get/", 9) == 0)
-			return IPP2P_DATA_GNU * 100 + 1;
-		if (plen >= 15 && memcmp(payload, "GET /uri-res/", 13) == 0)
-			return IPP2P_DATA_GNU * 100 + 2;
-	}
+	if (!iscrlf(&payload[plen - 2]))
+		return 0;
+	if (memcmp(payload, "GET /get/", 9) == 0)
+		return IPP2P_DATA_GNU * 100 + 1;
+	if (plen >= 15 && memcmp(payload, "GET /uri-res/", 13) == 0)
+		return IPP2P_DATA_GNU * 100 + 2;
 	return 0;
 }
 
@@ -605,25 +609,33 @@ search_gnu(const unsigned char *payload, const unsigned int plen)
 static unsigned int
 search_all_gnu(const unsigned char *payload, const unsigned int plen)
 {
+	unsigned int c;
+
 	if (plen < 11)
 		return 0;
-	if (iscrlf(&payload[plen - 2])) {
-		if (plen >= 19 && memcmp(payload, "GNUTELLA CONNECT/", 17) == 0)
-			return IPP2P_GNU * 100 + 1;
-		if (memcmp(payload, "GNUTELLA/", 9) == 0)
-			return IPP2P_GNU * 100 + 2;
-
-		if (plen >= 22 && (memcmp(payload, "GET /get/", 9) == 0 ||
-		    memcmp(payload, "GET /uri-res/", 13) == 0))
-		{
-			unsigned int c;
+	if (!iscrlf(&payload[plen - 2]))
+		return 0;
+	if (plen >= 19 && memcmp(payload, "GNUTELLA CONNECT/", 17) == 0)
+		return IPP2P_GNU * 100 + 1;
+	if (memcmp(payload, "GNUTELLA/", 9) == 0)
+		return IPP2P_GNU * 100 + 2;
 
-			for (c = 0; c < plen - 22; ++c)
-				if (iscrlf(&payload[c]) &&
-				    (memcmp(&payload[c+2], "X-Gnutella-", 11) == 0 ||
-				    memcmp(&payload[c+2], "X-Queue:", 8) == 0))
-					return IPP2P_GNU * 100 + 3;
-		}
+	if (plen < 22)
+		return 0;
+
+	if (memcmp(payload, "GET /get/", 9) != 0 &&
+	    memcmp(payload, "GET /uri-res/", 13) != 0)
+		return 0;
+
+	for (c = 0; c < plen - 22; ++c) {
+		if (!iscrlf(&payload[c]))
+			continue;
+
+		if (memcmp(&payload[c+2], "X-Gnutella-", 11) == 0)
+			return IPP2P_GNU * 100 + 3;
+
+		if ( memcmp(&payload[c+2], "X-Queue:", 8) == 0)
+			return IPP2P_GNU * 100 + 3;
 	}
 	return 0;
 }
@@ -674,39 +686,37 @@ search_edk(const unsigned char *payload, const unsigned int plen)
 {
 	if (plen < 6)
 		return 0;
-	if (payload[0] != 0xe3) {
+	if (payload[0] != 0xe3)
 		return 0;
-	} else {
-		if (payload[5] == 0x47)
-			return IPP2P_DATA_EDK * 100;
-		else
-			return 0;
-	}
+	if (payload[5] == 0x47)
+		return IPP2P_DATA_EDK * 100;
+	return 0;
 }
 
 /* intensive but slower search for some edonkey packets including size-check */
 static unsigned int
 search_all_edk(const unsigned char *payload, const unsigned int plen)
 {
+	unsigned int cmd;
+
 	if (plen < 6)
 		return 0;
-	if (payload[0] != 0xe3) {
+	if (payload[0] != 0xe3)
 		return 0;
-	} else {
-		unsigned int cmd = get_u16(payload, 1);
 
-		if (cmd == plen - 5) {
-			switch (payload[5]) {
-			case 0x01:
-				/* Client: hello or Server:hello */
+	cmd = get_u16(payload, 1);
+
+	if (cmd == plen - 5) {
+		switch (payload[5]) {
+		case 0x01:
+			/* Client: hello or Server:hello */
 			return IPP2P_EDK * 100 + 1;
-				case 0x4c:
-				/* Client: Hello-Answer */
-				return IPP2P_EDK * 100 + 9;
-			}
+		case 0x4c:
+			/* Client: Hello-Answer */
+			return IPP2P_EDK * 100 + 9;
 		}
-		return 0;
 	}
+	return 0;
 }
 
 /* fast check for Direct Connect send command */
@@ -715,36 +725,41 @@ search_dc(const unsigned char *payload, const unsigned int plen)
 {
 	if (plen < 6)
 		return 0;
-	if (payload[0] != 0x24) {
+	if (payload[0] != 0x24)
 		return 0;
-	} else {
-		if (memcmp(&payload[1], "Send|", 5) == 0)
-			return IPP2P_DATA_DC * 100;
-		else
-			return 0;
-	}
+	if (memcmp(&payload[1], "Send|", 5) == 0)
+		return IPP2P_DATA_DC * 100;
+	return 0;
 }
 
 /* intensive but slower check for all direct connect packets */
 static unsigned int
 search_all_dc(const unsigned char *payload, const unsigned int plen)
 {
+	const unsigned char *t;
+
 	if (plen < 7)
 		return 0;
-	if (payload[0] == 0x24 && payload[plen-1] == 0x7c) {
-		const unsigned char *t = &payload[1];
 
-		/* Client-Hub-Protocol */
-		if (memcmp(t, "Lock ", 5) == 0)
-			return IPP2P_DC * 100 + 1;
+	if (payload[0] != 0x24)
+		return 0;
+
+	if (payload[plen-1] != 0x7c)
+		return 0;
+
+	t = &payload[1];
+
+	/* Client-Hub-Protocol */
+	if (memcmp(t, "Lock ", 5) == 0)
+		return IPP2P_DC * 100 + 1;
+
+	/*
+	 * Client-Client-Protocol, some are already recognized by client-hub
+	 * (like lock)
+	 */
+	if (plen >= 9 && memcmp(t, "MyNick ", 7) == 0)
+		return IPP2P_DC * 100 + 38;
 
-		/*
-		 * Client-Client-Protocol, some are already recognized by
-		 * client-hub (like lock)
-		 */
-		if (plen >= 9 && memcmp(t, "MyNick ", 7) == 0)
-			return IPP2P_DC * 100 + 38;
-	}
 	return 0;
 }
 
@@ -770,23 +785,25 @@ search_mute(const unsigned char *payload, const unsigned int plen)
 static unsigned int
 search_xdcc(const unsigned char *payload, const unsigned int plen)
 {
+	uint16_t x = 10;
+	const uint16_t end = plen - 13;
+
 	/* search in small packets only */
-	if (plen > 20 && plen < 200 && iscrlf(&payload[plen - 2]) &&
-	    memcmp(payload, "PRIVMSG ", 8) == 0)
-	{
-		uint16_t x = 10;
-		const uint16_t end = plen - 13;
+	if (plen <= 20 || plen >= 200)
+		return 0;
 
-		/*
-		 * is seems to be a irc private massage, chedck for
-		 * xdcc command
-		 */
-		while (x < end)	{
-			if (payload[x] == ':')
-				if (memcmp(&payload[x+1], "xdcc send #", 11) == 0)
-					return IPP2P_XDCC * 100 + 0;
-			x++;
-		}
+	if (memcmp(payload, "PRIVMSG ", 8) != 0 || !iscrlf(&payload[plen - 2]))
+		return 0;
+
+	/*
+	 * is seems to be a irc private massage, chedck for
+	 * xdcc command
+	 */
+	while (x < end)	{
+		if (payload[x] == ':' &&
+		    memcmp(&payload[x + 1], "xdcc send #", 11) == 0)
+			return IPP2P_XDCC * 100 + 0;
+		x++;
 	}
 	return 0;
 }
@@ -862,8 +879,7 @@ ipp2p_mt_tcp(const struct ipt_p2p_info *info, const struct tcphdr *tcph,
              const struct ipp2p_result_printer *rp)
 {
 	size_t tcph_len = tcph->doff * 4;
-	bool p2p_result = false;
-	int i = 0;
+	int i;
 
 	if (tcph->fin) return 0;  /* if FIN bit is set bail out */
 	if (tcph->syn) return 0;  /* if SYN bit is set bail out */
@@ -880,20 +896,18 @@ ipp2p_mt_tcp(const struct ipt_p2p_info *info, const struct tcphdr *tcph,
 	haystack += tcph_len;
 	hlen     -= tcph_len;
 
-	while (matchlist[i].command) {
-		if ((info->cmd & matchlist[i].command) == matchlist[i].command &&
-		    hlen > matchlist[i].packet_len)
-		{
-			p2p_result = matchlist[i].function_name(haystack, hlen);
-			if (p2p_result)	{
-				if (info->debug)
-					print_result(rp, p2p_result, hlen);
-				return p2p_result;
-			}
+	for (i = 0; matchlist[i].command; ++i) {
+		if ((info->cmd & matchlist[i].command) != matchlist[i].command)
+			continue;
+		if (hlen <= matchlist[i].packet_len)
+			continue;
+		if (matchlist[i].function_name(haystack, hlen))	{
+			if (info->debug)
+				print_result(rp, true, hlen);
+			return true;
 		}
-		i++;
 	}
-	return p2p_result;
+	return false;
 }
 
 static void
@@ -920,8 +934,7 @@ ipp2p_mt_udp(const struct ipt_p2p_info *info, const struct udphdr *udph,
              const struct ipp2p_result_printer *rp)
 {
 	size_t udph_len = sizeof(*udph);
-	bool p2p_result = false;
-	int i = 0;
+	int i;
 
 	if (hlen < udph_len) {
 		if (info->debug)
@@ -934,20 +947,18 @@ ipp2p_mt_udp(const struct ipt_p2p_info *info, const struct udphdr *udph,
 	haystack += udph_len;
 	hlen     -= udph_len;
 
-	while (udp_list[i].command) {
-		if ((info->cmd & udp_list[i].command) == udp_list[i].command &&
-		    hlen > udp_list[i].packet_len)
-		{
-			p2p_result = udp_list[i].function_name(haystack, hlen);
-			if (p2p_result) {
-				if (info->debug)
-					print_result(rp, p2p_result, hlen);
-				return p2p_result;
-			}
+	for (i = 0; udp_list[i].command; ++i) {
+		if ((info->cmd & udp_list[i].command) != udp_list[i].command)
+			continue;
+		if (hlen <= udp_list[i].packet_len)
+			continue;
+		if (udp_list[i].function_name(haystack, hlen)) {
+			if (info->debug)
+				print_result(rp, true, hlen);
+			return true;
 		}
-		i++;
 	}
-	return p2p_result;
+	return false;
 }
 
 static bool
-- 
2.39.2

