Return-Path: <SRS0=ffOv=3X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F459C33CAC
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 11:20:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AD7720721
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 11:20:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="o9yVKzZq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbgBCLU1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Feb 2020 06:20:27 -0500
Received: from kadath.azazel.net ([81.187.231.250]:33250 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727302AbgBCLUZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Feb 2020 06:20:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8IfejBEIdHw373fWiXq3VePNx3BHue0N/FLp8vRxFgE=; b=o9yVKzZqSyPnW7Llznh+CJtziS
        bc7SsL9MQl0dV62Jqv55ocwVT9GpMkkr2upg5KsiRnb2ggMSCwbM4+XouhEsXV0jInjXMtBEturKx
        uj1R97p2248ITZm5nzagNuc35Sm+juA2NgoZXForlMTTZhCnAVlqlq2O2a//61HmuoiZJ183WMRoz
        6CGF1JZGrzT7t/kvoG1rUc8unj4etuoeFqXOIe0zzdHk6YtnB7djZP/fQFeUd4gxBmGmLxf4gkqxn
        PqTzPnETO4nMgHuxr2ntCfKp0ue9RpgFBDHcnUcIoDqPJshK2G/JA14mBdxcVXqEteHVqXkDPTckm
        UzZxF8Zg==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iyZmB-0007Br-HT
        for netfilter-devel@vger.kernel.org; Mon, 03 Feb 2020 11:20:23 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v4 3/6] evaluate: change shift byte-order to host-endian.
Date:   Mon,  3 Feb 2020 11:20:20 +0000
Message-Id: <20200203112023.646840-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200203112023.646840-1-jeremy@azazel.net>
References: <20200203112023.646840-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The byte-order of the righthand operands of the right-shifts generated
for payload and exthdr expressions is big-endian.  However, all right
operands should be host-endian.  Since evaluation of the shift binop
will insert a byte-order conversion to enforce this, change the
endianness in order to avoid the extra operation.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/evaluate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 966582e44a7d..ef2dcb5ce78f 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -487,7 +487,7 @@ static void expr_evaluate_bits(struct eval_ctx *ctx, struct expr **exprp)
 	if (shift) {
 		off = constant_expr_alloc(&expr->location,
 					  expr_basetype(expr),
-					  BYTEORDER_BIG_ENDIAN,
+					  BYTEORDER_HOST_ENDIAN,
 					  sizeof(shift), &shift);
 
 		rshift = binop_expr_alloc(&expr->location, OP_RSHIFT, and, off);
-- 
2.24.1

