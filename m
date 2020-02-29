Return-Path: <SRS0=4Rej=4R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6F38C3F2CE
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Feb 2020 11:44:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 758D72469C
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Feb 2020 11:44:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="Iz67rube"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbgB2Loj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Feb 2020 06:44:39 -0500
Received: from kadath.azazel.net ([81.187.231.250]:49564 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgB2Loj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Feb 2020 06:44:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=B0UTu3CcNcfKFzzm3TasWV0BikuktgZERyrOQFhTBII=; b=Iz67rubeW0bWRnDPYUHhekN4un
        eCeMPtE+3r5bM0CxzILuWjPoNUiCjx2Ct1Hf9jUdy8HjnfOcFdLyU5acdjoUt7HNDZiGPM05De78B
        FVLhGfbHIXT/q5Ga4rpAcCwD4WkHZlwGByPLCDtFfMN5oapfM3eT///ZCY/ZIq7vqPDmQuFalY9HK
        dHZUJssxNUtjYR5lOJ3SDdM1wQR/MtGa10O8zMT2U1i0QwQLNxiPp/GBfbrqrFocmun7CM5gus0DS
        /yLudCFWImZGx9H4KcrhXgq+ajP16QN35y03fGS83rVZO5MqmoMwmjb8zRscO3o+XCGFtk7ZJgY8c
        9934J31g==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j80HO-0003Wm-6g; Sat, 29 Feb 2020 11:27:34 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 16/18] tests: shell: remove stray debug flag.
Date:   Sat, 29 Feb 2020 11:27:29 +0000
Message-Id: <20200229112731.796417-17-jeremy@azazel.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200229112731.796417-1-jeremy@azazel.net>
References: <20200229112731.796417-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

0040mark_shift_0 was passing --debug=eval to nft.  Remove it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 tests/shell/testcases/chains/0040mark_shift_0 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/shell/testcases/chains/0040mark_shift_0 b/tests/shell/testcases/chains/0040mark_shift_0
index 55447f0b9737..ef3dccfa049a 100755
--- a/tests/shell/testcases/chains/0040mark_shift_0
+++ b/tests/shell/testcases/chains/0040mark_shift_0
@@ -8,4 +8,4 @@ RULESET="
   add rule t c oif lo ct mark set (meta mark | 0x10) << 8
 "
 
-$NFT --debug=eval -f - <<< "$RULESET"
+$NFT -f - <<< "$RULESET"
-- 
2.25.0

