Return-Path: <SRS0=yud9=WI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FCCCC32750
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Aug 2019 11:57:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B4A7206DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Aug 2019 11:57:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="SCyvalos"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbfHLL5n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Aug 2019 07:57:43 -0400
Received: from kadath.azazel.net ([81.187.231.250]:42460 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728336AbfHLL5n (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Aug 2019 07:57:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=eiddhejMHZa3RsroE846rcDJuLu3g6wv8w4ZwuPQBW4=; b=SCyvalos7hrPijtWYQ7FQAdpUj
        3ow7yPzkmZkXXtyZQ+1J8DZ7z+m15UhOuYziNAciJp191Nios1arx0OCHAN6gQy87FEGWpOixxgOJ
        spdN35CWQUMcTHLyB/fnZNbyMXKR7J5R4Scq/mhpz23UyrLTSZpqBLG8PKEy/KfL2XPCkbQl22yBd
        rAqGTYbrsKeVSUofi8MzWLkIrX1ZvukFvnqC3hqrOiGti+e52BIkvfwdPG52hsfnAWFBZ9MSLkdt/
        k1h31G8avMoZIxoE4j4UbYFDZNCygBDPA/d1PFaHB7cCIjBlhSQ+rDSvCWKMyxhcyCC/v7+BkbTdY
        mzHgsxPQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1hx8xK-0002sN-Gt; Mon, 12 Aug 2019 12:57:42 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     =?UTF-8?q?Franta=20Hanzl=C3=ADk?= <franta@hanzlici.cz>
Subject: [PATCH xtables-addons v2 2/2] xt_DHCPMAC: replaced skb_make_writable with skb_ensure_writable.
Date:   Mon, 12 Aug 2019 12:57:42 +0100
Message-Id: <20190812115742.21770-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190812115742.21770-1-jeremy@azazel.net>
References: <20190811113826.5e594d8f@franta.hanzlici.cz>
 <20190812115742.21770-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

skb_make_writable was removed from the kernel in 5.2 and its callers
converted to use skb_ensure_writable.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/xt_DHCPMAC.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/extensions/xt_DHCPMAC.c b/extensions/xt_DHCPMAC.c
index 47f9534f74c7..a748cb101d99 100644
--- a/extensions/xt_DHCPMAC.c
+++ b/extensions/xt_DHCPMAC.c
@@ -96,7 +96,8 @@ dhcpmac_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	struct udphdr udpbuf, *udph;
 	unsigned int i;
 
-	if (!skb_make_writable(skb, 0))
+	if (skb_ensure_writable(skb, ip_hdrlen(skb) + sizeof(udpbuf) +
+				     sizeof(dhcpbuf)))
 		return NF_DROP;
 
 	udph = skb_header_pointer(skb, ip_hdrlen(skb),
-- 
2.20.1

