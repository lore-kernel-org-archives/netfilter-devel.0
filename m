Return-Path: <SRS0=4Rej=4R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C3A6C3F2D9
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Feb 2020 11:27:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A730246AE
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Feb 2020 11:27:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="OJ/2D3S4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgB2L1h (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Feb 2020 06:27:37 -0500
Received: from kadath.azazel.net ([81.187.231.250]:48658 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726901AbgB2L1f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Feb 2020 06:27:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3JUjbQ1aBwdnjQKGvEtF8cYSj48U1vaEQ3SeEi+wX7c=; b=OJ/2D3S4E5sRRIV4aKStIQ5Vtg
        q+ORrOu6qZbrBQLSujo8Xo79tKEU7MDVx1Q+UItmTEJG5CJ8glqnX/3XH+qCn281WI1usKP1/FaWi
        0GkpiKUyosPhuhn50XC6/D1zWNeClZeEMUQPIBXTYDg++zUvTiXf2CLoolesM79Oda3Cq3MRcliLX
        CiqQtvfSOTFd/ybfBEQm9senL4xaWHdW3sV58I/6RSuoteDvASy5HDOVlwwIIc8Mlpoitr76u30Mg
        XjCVgmnuMrRgJKFjmQ6Zsp+hBBMmr20vLD6y9pa+Sk4tqCS/duWyclrqqSZaSYxA5AwxOa1Tirzy4
        k242WM2A==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j80HM-0003Wm-57; Sat, 29 Feb 2020 11:27:32 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 04/18] evaluate: convert the byte-order of payload statement arguments.
Date:   Sat, 29 Feb 2020 11:27:17 +0000
Message-Id: <20200229112731.796417-5-jeremy@azazel.net>
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

Since shift operations require host byte-order, we need to be able to
convert the result of the shift back to network byte-order, in a rule
like:

  nft add rule ip t c tcp dport set tcp dport lshift 1

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/evaluate.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index a169e41bd833..9b1a04f26f44 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2225,6 +2225,11 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 			      payload->byteorder, &stmt->payload.val) < 0)
 		return -1;
 
+	if (!expr_is_constant(stmt->payload.val) &&
+	    byteorder_conversion(ctx, &stmt->payload.val,
+				 payload->byteorder) < 0)
+		return -1;
+
 	need_csum = stmt_evaluate_payload_need_csum(payload);
 
 	if (!payload_needs_adjustment(payload)) {
-- 
2.25.0

