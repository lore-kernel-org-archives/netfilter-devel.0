Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2408C77B73
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jun 2023 19:20:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbjFETUR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Jun 2023 15:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235764AbjFETTy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jun 2023 15:19:54 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6727B1707
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Jun 2023 12:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=omlXSo3pq1a1PcVIZP1WDvDbcSGKVJkVzP/I3L7ULKc=; b=c7lDdT3OvpCWyBOzzrMFqanYd0
        xSnml1HsynbCQ7uwqUnV6QA9K2LFGfxxljAIZLX2UkeozPvymA/KwNgktwVLw+vTvyj7AdQR2BAdi
        +gy3CqWroxbxqpXrm1x/lQVEv8CoNDx9M5OKecqmyf7HPAS0Lsc9WmusMb6BXwxz9qCeTGOfuBMVv
        DyRu90NXbsWXNRv9YtegCaDzHsWOJ6hxpXguEkgGEm2wEU+vlWy9YK3g8CW+15tNZ9n+nZrPibkfz
        U1qe1P/vOmGB6se6UWd0E42FF8TfyAfD30bGhSo/RCOJb8k22xH7luPsb8YXxciflhXqWN9at6laN
        q5sKoFGg==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q6FjL-00H0rc-7N
        for netfilter-devel@vger.kernel.org; Mon, 05 Jun 2023 20:19:03 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 4/8] xt_ipp2p: add helper for matching "\r\n"
Date:   Mon,  5 Jun 2023 20:17:31 +0100
Message-Id: <20230605191735.119210-5-jeremy@azazel.net>
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

There are repeated checks that:

  pkt[x] == 0x0d && pkt[x + 1] == 0x0a

Replace them with `iscrlf(&pkt[x])` function calls.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/xt_ipp2p.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/extensions/xt_ipp2p.c b/extensions/xt_ipp2p.c
index 4790c2fca229..de253c4f4cb4 100644
--- a/extensions/xt_ipp2p.c
+++ b/extensions/xt_ipp2p.c
@@ -39,6 +39,11 @@ struct ipp2p_result_printer {
 	void (*print)(const union nf_inet_addr *, short, const union nf_inet_addr *, short, bool, unsigned int);
 };
 
+static bool iscrlf(const unsigned char *str)
+{
+	return *str == '\r' && *(str + 1) == '\n';
+}
+
 static void
 print_result(const struct ipp2p_result_printer *rp, bool result,
              unsigned int hlen)
@@ -518,7 +523,7 @@ search_winmx(const unsigned char *payload, const unsigned int plen)
 static unsigned int
 search_apple(const unsigned char *payload, const unsigned int plen)
 {
-	if (plen > 7 && payload[6] == 0x0d && payload[7] == 0x0a &&
+	if (plen > 7 && iscrlf(&payload[6]) &&
 	    memcmp(payload, "ajprot", 6) == 0)
 		return IPP2P_APPLE * 100;
 
@@ -574,7 +579,7 @@ search_kazaa(const unsigned char *payload, const unsigned int plen)
 {
 	if (plen < 13)
 		return 0;
-	if (payload[plen-2] == 0x0d && payload[plen-1] == 0x0a &&
+	if (iscrlf(&payload[plen - 2]) &&
 	    memcmp(payload, "GET /.hash=", 11) == 0)
 		return IPP2P_DATA_KAZAA * 100;
 
@@ -587,7 +592,7 @@ search_gnu(const unsigned char *payload, const unsigned int plen)
 {
 	if (plen < 11)
 		return 0;
-	if (payload[plen-2] == 0x0d && payload[plen-1] == 0x0a) {
+	if (iscrlf(&payload[plen - 2])) {
 		if (memcmp(payload, "GET /get/", 9) == 0)
 			return IPP2P_DATA_GNU * 100 + 1;
 		if (plen >= 15 && memcmp(payload, "GET /uri-res/", 13) == 0)
@@ -602,7 +607,7 @@ search_all_gnu(const unsigned char *payload, const unsigned int plen)
 {
 	if (plen < 11)
 		return 0;
-	if (payload[plen-2] == 0x0d && payload[plen-1] == 0x0a) {
+	if (iscrlf(&payload[plen - 2])) {
 		if (plen >= 19 && memcmp(payload, "GNUTELLA CONNECT/", 17) == 0)
 			return IPP2P_GNU * 100 + 1;
 		if (memcmp(payload, "GNUTELLA/", 9) == 0)
@@ -614,8 +619,7 @@ search_all_gnu(const unsigned char *payload, const unsigned int plen)
 			unsigned int c;
 
 			for (c = 0; c < plen - 22; ++c)
-				if (payload[c] == 0x0d &&
-				    payload[c+1] == 0x0a &&
+				if (iscrlf(&payload[c]) &&
 				    (memcmp(&payload[c+2], "X-Gnutella-", 11) == 0 ||
 				    memcmp(&payload[c+2], "X-Queue:", 8) == 0))
 					return IPP2P_GNU * 100 + 3;
@@ -635,7 +639,7 @@ search_all_kazaa(const unsigned char *payload, const unsigned int plen)
 		/* too short for anything we test for - early bailout */
 		return 0;
 
-	if (payload[plen-2] != 0x0d || payload[plen-1] != 0x0a)
+	if (!iscrlf(&payload[plen - 2]))
 		return 0;
 
 	if (memcmp(payload, "GIVE ", 5) == 0)
@@ -651,9 +655,7 @@ search_all_kazaa(const unsigned char *payload, const unsigned int plen)
 	end = plen - 18;
 	rem = plen - 5;
 	for (c = 5; c < end; ++c, --rem) {
-		if (payload[c] != 0x0d)
-			continue;
-		if (payload[c+1] != 0x0a)
+		if (!iscrlf(&payload[c]))
 			continue;
 		if (rem >= 18 &&
 		    memcmp(&payload[c+2], "X-Kazaa-Username: ", 18) == 0)
@@ -769,8 +771,8 @@ static unsigned int
 search_xdcc(const unsigned char *payload, const unsigned int plen)
 {
 	/* search in small packets only */
-	if (plen > 20 && plen < 200 && payload[plen-1] == 0x0a &&
-	    payload[plen-2] == 0x0d && memcmp(payload, "PRIVMSG ", 8) == 0)
+	if (plen > 20 && plen < 200 && iscrlf(&payload[plen - 2]) &&
+	    memcmp(payload, "PRIVMSG ", 8) == 0)
 	{
 		uint16_t x = 10;
 		const uint16_t end = plen - 13;
-- 
2.39.2

