Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 115E5C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 19:50:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCFC9610F9
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Sep 2021 19:50:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241247AbhIMTvW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 15:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240911AbhIMTvW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 15:51:22 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3626C061574
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Sep 2021 12:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KDRelbbBmXg+V0ma4pHaQc0WJa8fH0TNNFNzRdBkuYE=; b=tmQJEThw4QN1p2WlssACJJbqfm
        TovR0pmAeMkQza/IoYg28Io+Uf2dF8hmGy3vmXodQu5sUT/OGCoVC09OtNHLEy/7gk93H/n1s2dPA
        nJllaNs5PPKNLW6QmVj4Z5f8tYsjvEGu2cVaXvD07dM/nGJEYYCXHb9zoQMRWPRa+JOm/gPr06N/7
        Lnwxa0/AbIG/pJ9TQXr4rH32rHw/C6sUJiiZknrUow7Ve+aOlJKOf7TIW9jxVr8erb0o1zp646ni2
        jjpchTn90llrhl7zokUwKvFtoxQUilFYYCZv0tffRha+ioQFqgRoHW2ywkViwTFUMI3uwdIzHfF82
        9R6zs1Gg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mPrxr-00GciB-CT; Mon, 13 Sep 2021 20:50:03 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>, kaskada@email.cz
Subject: [xtables-addons] xt_ipp2p: fix compatibility with pre-5.1 kernels
Date:   Mon, 13 Sep 2021 20:46:07 +0100
Message-Id: <20210913194607.134775-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

`ip_transport_len` and `ipv6_transport_len` were introduced in 5.1.
They are both single-statement static inline functions, so add fall-back
implementations for compatibility with older kernels.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/xt_ipp2p.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/extensions/xt_ipp2p.c b/extensions/xt_ipp2p.c
index 74f7d18fc04b..696318551649 100644
--- a/extensions/xt_ipp2p.c
+++ b/extensions/xt_ipp2p.c
@@ -19,6 +19,20 @@ MODULE_AUTHOR("Eicke Friedrich/Klaus Degner <ipp2p@ipp2p.org>");
 MODULE_DESCRIPTION("An extension to iptables to identify P2P traffic.");
 MODULE_LICENSE("GPL");
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(5, 1, 0)
+static inline unsigned int
+ip_transport_len(const struct sk_buff *skb)
+{
+        return ntohs(ip_hdr(skb)->tot_len) - skb_network_header_len(skb);
+}
+static inline unsigned int
+ipv6_transport_len(const struct sk_buff *skb)
+{
+        return ntohs(ipv6_hdr(skb)->payload_len) + sizeof(struct ipv6hdr) -
+               skb_network_header_len(skb);
+}
+#endif
+
 union ipp2p_addr {
 	__be32 ip;
 	struct in6_addr in6;
-- 
2.33.0

