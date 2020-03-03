Return-Path: <SRS0=D+Hy=4U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68CF3C3F2CD
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 09:48:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37D4720848
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 09:48:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="FRseMOTO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728257AbgCCJsq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Mar 2020 04:48:46 -0500
Received: from kadath.azazel.net ([81.187.231.250]:40804 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727982AbgCCJsq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Mar 2020 04:48:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+MRjDIMCPnUd9MF472aAGXhHCTyDnj3i+U40/yjk+e8=; b=FRseMOTOYJGiASd92CdiGEDl1N
        yPNQCpzhSMn4zo13GS/4g60ylmd52ZYQ99vdiaBP897UFFZpocxxfwp1/tFnEXbVirquE69ZlITd4
        lAMqF4/8O4zAm010eh1dfgnGAR6cj1Kw/gke22KNgu2IfyD1SkArK+fJEP2UTMIEL908taPDzTUOC
        lvei0ox+EQqLHFh7vbvyzbkr0oAvXiNqbxewaCe/eDtPpB39DrmFUB7xhU5C1c1ljxl4B1lb+j1Hq
        eMhzNNHLqvIzzxr3NvExbfopI+fvaU7vc/TYEqizKaW3qpTsGnb8Q4wjG+du/yjYz5RstB0o3X/FB
        HIBsadYg==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j94AP-00081M-2L; Tue, 03 Mar 2020 09:48:45 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v3 02/18] evaluate: simplify calculation of payload size.
Date:   Tue,  3 Mar 2020 09:48:28 +0000
Message-Id: <20200303094844.26694-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303094844.26694-1-jeremy@azazel.net>
References: <20200303094844.26694-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use div_round_up and one statement.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/evaluate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index fda30fd8001e..e2eff2353657 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2236,8 +2236,8 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 
 	shift_imm = expr_offset_shift(payload, payload->payload.offset,
 				      &extra_len);
-	payload_byte_size = round_up(payload->len, BITS_PER_BYTE) / BITS_PER_BYTE;
-	payload_byte_size += (extra_len / BITS_PER_BYTE);
+	payload_byte_size = div_round_up(payload->len + extra_len,
+					 BITS_PER_BYTE);
 
 	if (need_csum && payload_byte_size & 1) {
 		payload_byte_size++;
-- 
2.25.1

