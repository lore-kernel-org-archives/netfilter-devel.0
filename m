Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78270C7EE23
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jun 2023 22:12:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbjFEWMI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Jun 2023 18:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232149AbjFEWMG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jun 2023 18:12:06 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B06109
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Jun 2023 15:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DWtAmPQ/WJTTA3a6ZueJHCurr5BxrdvopzuQ4XD95l4=; b=XENrdSgAFz2HbBd2CLZdk+z5oq
        fczPXidBFHsmu1buoI997wDhFOiFQu8YzVzrDYDMauazNd7er4AZDaNeaaNrTWEKmx22YwCGtzRpd
        dFFeZsvxAriDNYtzal0KQinm3W+huo0TPQ3yYvsWS4V8sth97JfgHbeCw2S8fV7suJcrfvlcPbTim
        MXPf8rVFp1rCO3eo9ZO8TshlwVhgpD4KfsHn5+zBDuaw1o6SOOLz47wqKTbfNppTdQMu1/tMjEbQg
        tfUf2nHixCSYmUKuz5Ig8MLMMm4VWmPeobB0CQ6CnHAUDk2ZHOvvZdGxAcvkp2H3XDWrsAP2H3/oc
        UbnwyQ7A==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q6IQl-00H5Wa-TK
        for netfilter-devel@vger.kernel.org; Mon, 05 Jun 2023 23:12:03 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons v2 7/7] xt_ipp2p: drop requirement that skb is linear
Date:   Mon,  5 Jun 2023 23:10:44 +0100
Message-Id: <20230605221044.140855-8-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230605221044.140855-1-jeremy@azazel.net>
References: <20230605221044.140855-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It is no longer necessary.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/xt_ipp2p.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/extensions/xt_ipp2p.c b/extensions/xt_ipp2p.c
index 4322ab3623e5..fd6651caebeb 100644
--- a/extensions/xt_ipp2p.c
+++ b/extensions/xt_ipp2p.c
@@ -1280,13 +1280,6 @@ ipp2p_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		return 0;
 	}
 
-	/* make sure that skb is linear */
-	if (skb_is_nonlinear(skb)) {
-		if (info->debug)
-			printk("IPP2P.match: nonlinear skb found\n");
-		return 0;
-	}
-
 	if (family == NFPROTO_IPV4) {
 		const struct iphdr *ip = ip_hdr(skb);
 
-- 
2.39.2

