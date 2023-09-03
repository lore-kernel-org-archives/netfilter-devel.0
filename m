Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F20FC71153
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Sep 2023 21:04:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbjICVEG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 3 Sep 2023 17:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjICVEF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Sep 2023 17:04:05 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC59102
        for <netfilter-devel@vger.kernel.org>; Sun,  3 Sep 2023 14:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=W1u6/BM7WY6HBOErOl6Kxc9qoyzud6/2DEM9Bp0H4pQ=; b=UK6YNvFUC5IyOqMpSADPB4HGxI
        fjbCJWKmE5MlQ3PEIasyU/2cB6Yb0l1+B9BUMv+HdwiecEhdOvMB0gwd73iZHk39sG7rx7eMdG6+P
        kUtQmEzKGWojOy1oYyLiwZ0/0P5vJawiyND1Hlx1ODsgkmdDPIzNqygyToJseVxWWdn45pDsC2ZNv
        RtbKZjYi33HA5c6Ht0OTUBZOtSN0yr9p3wjzQ0TIA9jhQKvT4wBonSD2p5WjFeYkCdoVMvUoU+UVA
        y5uDRb0KA1wyremuZj5khV7+ZM8ztdCHTNvGAo3MVRJguIwXLC3C9daeFW/HnIigIp1zm7+e1htb4
        DNt6CI4g==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qcuGF-004DXA-0n
        for netfilter-devel@vger.kernel.org;
        Sun, 03 Sep 2023 22:03:59 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnetfilter_log] libipulog: remove debugging printfs
Date:   Sun,  3 Sep 2023 22:03:57 +0100
Message-Id: <20230903210357.2139250-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There are a couple of `printf` calls which appear to be left over debugging
aids.  Remove them.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1060
Fixes: 9b5887192ed5 ("- some more work on libipulog compat API [almost finished] - improt ulog_test.c from libipulog in order to test libipulog compat API")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/libipulog_compat.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/src/libipulog_compat.c b/src/libipulog_compat.c
index a0de3cb78b68..4efa5012f197 100644
--- a/src/libipulog_compat.c
+++ b/src/libipulog_compat.c
@@ -133,10 +133,9 @@ ulog_packet_msg_t *ipulog_get_packet(struct ipulog_handle *h,
 	struct nfulnl_msg_packet_hdr *hdr;
 
 	if (!h->last_nlh) {
-		printf("first\n");
 		nlh = nfnl_get_msg_first(nflog_nfnlh(h->nfulh), buf, len);
 	}else {
-next_msg:	printf("next\n");
+next_msg:
 		nlh = nfnl_get_msg_next(nflog_nfnlh(h->nfulh), buf, len);
 	}
 	h->last_nlh = nlh;
-- 
2.40.1

