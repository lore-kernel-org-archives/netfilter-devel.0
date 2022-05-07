Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82CDDC433FE
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 May 2022 11:59:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356300AbiEGMD1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 7 May 2022 08:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446308AbiEGMD0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 May 2022 08:03:26 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE54148392
        for <netfilter-devel@vger.kernel.org>; Sat,  7 May 2022 04:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OH5eW8fChFjGrrbXYrkxOX+TG4u/umeq7/Uy9YqY0mI=; b=l72Vk8FVlxVUD101uGYKRZds9k
        KwFiv3Nl6hHFUGaa027pyRXXLwjgMop98OYIkqDeExYW8LG7psEj4r0S0DeWjXtyIAoQ7TTym6qDr
        ALnRWOiNRAFxp1uCJy0NR06JT7zAuiOFSVPQRC+dT8gM/2RacYubNsjuVCS6HVHQbaAHX/VMtvtZC
        IhLk0pe6ZXkSYJNmCiIFQz2cGWrYATNuH3/lWJwIbpi9pCvOxWPMjlgbq4oc0AdTgX7AToHbhWbaY
        nJKNTjcxKJJl5y0NsY598wA/uGMZxxlLjTn2fQynwdP9aGuIbxeZEcbvpfzan9ItGn9YW+5KcmICF
        X/eeKbAA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nnJ60-0025Kn-Pw; Sat, 07 May 2022 12:59:36 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 2/2] doc: fix typo in help
Date:   Sat,  7 May 2022 12:59:24 +0100
Message-Id: <20220507115924.3590034-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220507115924.3590034-1-jeremy@azazel.net>
References: <20220507115924.3590034-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

libxt_psd.c: 'threshhold' -> 'threshold'

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/libxt_psd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_psd.c b/extensions/libxt_psd.c
index 05940e7187b9..1f7992973e0f 100644
--- a/extensions/libxt_psd.c
+++ b/extensions/libxt_psd.c
@@ -36,7 +36,7 @@
 static void psd_mt_help(void) {
 	printf(
 		"psd match options:\n"
-		" --psd-weight-threshold threshhold  Portscan detection weight threshold\n"
+		" --psd-weight-threshold threshold   Portscan detection weight threshold\n"
 		" --psd-delay-threshold  delay       Portscan detection delay threshold\n"
 		" --psd-lo-ports-weight  lo          Privileged ports weight\n"
 		" --psd-hi-ports-weight  hi          High ports weight\n\n");
-- 
2.35.1

