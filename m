Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C732C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:10:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BD6B60F9B
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhJ3RNP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 13:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbhJ3RNP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 13:13:15 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A203BC061570
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 10:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=mpMOj/MKQiLBukKk1edf3w1TciBTGYXcm6F6gyeRDno=; b=dXl6qG2Pf/wo43tT5bhcgZT/CK
        JOXfzQ1c8O836yOD3SIZzpDMdJJ9hFgOV4hEAO2Bkl8G53c7n8Kg5DRb/cg9lq72BF4d4WHevSzhP
        O8PUjOcc1EN5M0FnQ9YyjqR7cJ67CD5EwHzXlCebaKjToEKtEqUP4941t+0qHAS24NibnuBKJZw/D
        CQYTXczr5Efs3ohuLgItaQ62AiNY78tLAolCHF4fUgNLNsqe3UdDu2DWhMXuuUVp516byQoqr9Vxs
        7K6Qx2VIEPvxfG+IlXXfGdcu5bniuJCRWUGeNPXK+BLe2s4XvbgWQokKUCkkgtO8tiwHUqr9V3b+g
        40xQDsog==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgrT9-00AFgT-6a
        for netfilter-devel@vger.kernel.org; Sat, 30 Oct 2021 17:44:35 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 12/26] filter: PWSNIFF: replace malloc+strncpy with strndup.
Date:   Sat, 30 Oct 2021 17:44:18 +0100
Message-Id: <20211030164432.1140896-13-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211030164432.1140896-1-jeremy@azazel.net>
References: <20211030164432.1140896-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 filter/ulogd_filter_PWSNIFF.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/filter/ulogd_filter_PWSNIFF.c b/filter/ulogd_filter_PWSNIFF.c
index 934ff0e09c4f..9060d16feac6 100644
--- a/filter/ulogd_filter_PWSNIFF.c
+++ b/filter/ulogd_filter_PWSNIFF.c
@@ -35,10 +35,14 @@
 #define DEBUGP(format, args...)
 #endif
 
-
 #define PORT_POP3	110
 #define PORT_FTP	21
 
+enum pwsniff_output_keys {
+	PWSNIFF_OUT_KEY_USER,
+	PWSNIFF_OUT_KEY_PASS,
+};
+
 static uint16_t pwsniff_ports[] = {
 	PORT_POP3,
 	PORT_FTP,
@@ -93,11 +97,11 @@ static int interp_pwsniff(struct ulogd_pluginstance *pi)
 		return ULOGD_IRET_STOP;
 
 	DEBUGP("----> pwsniff detected, tcplen=%d, struct=%d, iphtotlen=%d, "
-		"ihl=%d\n", tcplen, sizeof(struct tcphdr), ntohs(iph->tot_len),
-		iph->ihl);
+	       "ihl=%d\n", tcplen, sizeof(struct tcphdr), ntohs(iph->tot_len),
+	       iph->ihl);
 
 	for (ptr = (unsigned char *) tcph + sizeof(struct tcphdr); 
-			ptr < (unsigned char *) tcph + tcplen; ptr++)
+	     ptr < (unsigned char *) tcph + tcplen; ptr++)
 	{
 		if (!strncasecmp((char *)ptr, "USER ", 5)) {
 			begp = ptr+5;
@@ -108,7 +112,7 @@ static int interp_pwsniff(struct ulogd_pluginstance *pi)
 		if (!strncasecmp((char *)ptr, "PASS ", 5)) {
 			pw_begp = ptr+5;
 			pw_endp = _get_next_blank(pw_begp, 
-					(unsigned char *)tcph + tcplen);
+						  (unsigned char *)tcph + tcplen);
 			if (pw_endp)
 				pw_len = pw_endp - pw_begp + 1;
 		}
@@ -116,21 +120,17 @@ static int interp_pwsniff(struct ulogd_pluginstance *pi)
 
 	if (len) {
 		char *ptr;
-		ptr = (char *) malloc(len+1);
+		ptr = strndup((char *)begp, len);
 		if (!ptr)
 			return ULOGD_IRET_ERR;
-		strncpy(ptr, (char *)begp, len);
-		ptr[len] = '\0';
-		okey_set_ptr(&ret[0], ptr);
+		okey_set_ptr(&ret[PWSNIFF_OUT_KEY_USER], ptr);
 	}
 	if (pw_len) {
 		char *ptr;
-		ptr = (char *) malloc(pw_len+1);
+		ptr = strndup((char *)pw_begp, pw_len);
 		if (!ptr)
 			return ULOGD_IRET_ERR;
-		strncpy(ptr, (char *)pw_begp, pw_len);
-		ptr[pw_len] = '\0';
-		okey_set_ptr(&ret[1], ptr);
+		okey_set_ptr(&ret[PWSNIFF_OUT_KEY_PASS], ptr);
 	}
 	return ULOGD_IRET_OK;
 }
-- 
2.33.0

