Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDE2BC7EE2E
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Jun 2023 19:20:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbjFETUR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Jun 2023 15:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235496AbjFETTv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jun 2023 15:19:51 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CF710FA
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Jun 2023 12:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=b4Qv6qGM6iMZD+j0KGtrU39Ns6Lh6LvhbTRY7CMt1LE=; b=eCB/tXTidpY3F5a1g3nERAfK1j
        pPXzH+9nAdhQX7PJcslP/9R5Z3uubASnCpFP2OuBX6g6gXKJOV+plIlCPQJ1tw+iGE7kKvIJeHVDN
        K9aYbzs0+JM6kT1Pv1kFrJ0505yFMxFILb49IuBZf/uHpFnmoH9/dB2hwz9xCUiJMOwCeSMHjpsfw
        xCMjTsRxbHewQataFTFSYWe9jF2S+h8q0RkanI4geT+7rvnIobJbHrz5afjHnLqg2+Qnlk0atfZjI
        huZ7Z21+ZTQZAII+zfO43fjulwrzc3Twnm3z9DM8cb9sLG6YcOX6C1Y4Y91YNFeC6ffeAZ2Rl+lfk
        vB3tS8pg==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q6FjL-00H0rc-2T
        for netfilter-devel@vger.kernel.org; Mon, 05 Jun 2023 20:19:03 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 1/8] xt_ipp2p: fix an off-by-one error
Date:   Mon,  5 Jun 2023 20:17:28 +0100
Message-Id: <20230605191735.119210-2-jeremy@azazel.net>
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

When checking for waste, we check that the packet is at least eight
bytes long and then examine the first nine bytes.  Fix the length check.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/xt_ipp2p.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/xt_ipp2p.c b/extensions/xt_ipp2p.c
index 2a9f3e4553b0..a90d1b3d57c8 100644
--- a/extensions/xt_ipp2p.c
+++ b/extensions/xt_ipp2p.c
@@ -793,7 +793,7 @@ search_xdcc(const unsigned char *payload, const unsigned int plen)
 static unsigned int
 search_waste(const unsigned char *payload, const unsigned int plen)
 {
-	if (plen >= 8 && memcmp(payload, "GET.sha1:", 9) == 0)
+	if (plen >= 9 && memcmp(payload, "GET.sha1:", 9) == 0)
 		return IPP2P_WASTE * 100 + 0;
 
 	return 0;
-- 
2.39.2

