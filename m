Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF70DC4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 09:24:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91D1461004
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 09:24:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238439AbhIMJ0I (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 05:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238506AbhIMJ0G (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 05:26:06 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B80CC061764
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Sep 2021 02:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nTv4sYiQav0PiWMfCsWDuMulxij4RqPN1B6uL2eS2HU=; b=aPePa4owiCHyV0+x0ibKuwzX9w
        sPIutnnIK5SptuL2T0WKPq0afBZ8vIv1nFMstqEyei6E34YYCwNrIOodep3ev5OyYTrhaeuxmDgjt
        QvefQqEtPAF4jSYhCS5yTfcO0t/YcGNsa+JONObUU7JiO0RI/SKnLG7OGCUy9mp1S4g1EqlitJ98N
        0YHdMfPTFZt5LibSTZpIoIDBE5aWLRwToATdH7JagxGZO54VxvqxbCJEpNR4cTA4ViC6917OY0mXh
        YPHGufReJ+Ht0Y0+RIPPgC2Elhrh3Sq4y/NciYTpq8knHWphdfutCylYtR6LMnSfe+QAkFrmRZnfo
        u7iBEtzw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mPiCm-00GLzi-BA; Mon, 13 Sep 2021 10:24:48 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>, kaskada@email.cz
Subject: [xtables-addons 1/4] xt_ipp2p: don't search haystack if it's empty
Date:   Mon, 13 Sep 2021 10:20:48 +0100
Message-Id: <20210913092051.79743-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913092051.79743-1-jeremy@azazel.net>
References: <20210913092051.79743-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

All the search functions have a positive minimum packet-length.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/xt_ipp2p.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/extensions/xt_ipp2p.c b/extensions/xt_ipp2p.c
index 8fb1b79bb414..4e0fbb675c76 100644
--- a/extensions/xt_ipp2p.c
+++ b/extensions/xt_ipp2p.c
@@ -842,14 +842,17 @@ ipp2p_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		if (tcph->syn) return 0;  /* if SYN bit is set bail out */
 		if (tcph->rst) return 0;  /* if RST bit is set bail out */
 
-		haystack += tcph->doff * 4; /* get TCP-Header-Size */
 		if (tcph->doff * 4 > hlen) {
 			if (info->debug)
 				pr_info("TCP header indicated packet larger than it is\n");
-			hlen = 0;
-		} else {
-			hlen -= tcph->doff * 4;
+			return 0;
 		}
+		if (tcph->doff * 4 == hlen)
+			return 0;
+
+		haystack += tcph->doff * 4; /* get TCP-Header-Size */
+		hlen     -= tcph->doff * 4;
+
 		while (matchlist[i].command) {
 			if ((info->cmd & matchlist[i].command) == matchlist[i].command &&
 			    hlen > matchlist[i].packet_len)
@@ -875,14 +878,16 @@ ipp2p_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	{
 		const struct udphdr *udph = (const void *)ip + ip_hdrlen(skb);
 
-		haystack += sizeof(*udph);
 		if (sizeof(*udph) > hlen) {
 			if (info->debug)
 				pr_info("UDP header indicated packet larger than it is\n");
-			hlen = 0;
-		} else {
-			hlen -= sizeof(*udph);
+			return 0;
 		}
+		if (sizeof(*udph) == hlen)
+			return 0;
+
+		haystack += sizeof(*udph);
+		hlen     -= sizeof(*udph);
 
 		while (udp_list[i].command) {
 			if ((info->cmd & udp_list[i].command) == udp_list[i].command &&
-- 
2.33.0

