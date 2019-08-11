Return-Path: <SRS0=u4e5=WH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E20C433FF
	for <netfilter-devel@archiver.kernel.org>; Sun, 11 Aug 2019 13:16:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 618A4216F4
	for <netfilter-devel@archiver.kernel.org>; Sun, 11 Aug 2019 13:16:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="MNBcHPBW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbfHKNQS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 11 Aug 2019 09:16:18 -0400
Received: from kadath.azazel.net ([81.187.231.250]:55498 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfHKNQS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Aug 2019 09:16:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qgQ0vT5/nzmmJnVDJE3cIj+Alisr1zIlKRpFPgtMe34=; b=MNBcHPBWm/bXDpWDHm89sRiZBC
        pP+7H3UShI4aY7v5bzjf1elZznAEfOd4pxJBrjG87ebXG2IdT+H86YrUZngR1n5edcuzCttVzov8z
        1NZPo3ss/OhuetnRLOzFpQfhGJidGIoAZOtIm452TK1hZQ/l81bVf/dzCrU4XbBvlvCrwtxqN5j2K
        MRMrITtFqtP2aA/gvu6rJz6ZhPrhwVZQc3us1i0aZfcqhdwb0P6Tj8W+jCfpkI19divk9NG6aMlzt
        MByKdCCjRX4q2Ph9r1TA5/EvhgKXCwJEW4SHm5B3wPbek8CVb74g26eUz1H1ooUKEphn8KHqL8Gjj
        Ee2OcTcw==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1hwnhp-0002CN-Mj; Sun, 11 Aug 2019 14:16:17 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     =?UTF-8?q?Franta=20Hanzl=C3=ADk?= <franta@hanzlici.cz>
Subject: [PATCH xtables-addons 2/2] xt_DHCPMAC: replaced skb_make_writable with skb_ensure_writable.
Date:   Sun, 11 Aug 2019 14:16:17 +0100
Message-Id: <20190811131617.10365-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190811131617.10365-1-jeremy@azazel.net>
References: <20190811113826.5e594d8f@franta.hanzlici.cz>
 <20190811131617.10365-1-jeremy@azazel.net>
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
 extensions/xt_DHCPMAC.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/xt_DHCPMAC.c b/extensions/xt_DHCPMAC.c
index 47f9534f74c7..412f8984d326 100644
--- a/extensions/xt_DHCPMAC.c
+++ b/extensions/xt_DHCPMAC.c
@@ -96,7 +96,7 @@ dhcpmac_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	struct udphdr udpbuf, *udph;
 	unsigned int i;
 
-	if (!skb_make_writable(skb, 0))
+	if (!skb_ensure_writable(skb, 0))
 		return NF_DROP;
 
 	udph = skb_header_pointer(skb, ip_hdrlen(skb),
-- 
2.20.1

