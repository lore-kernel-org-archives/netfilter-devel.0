Return-Path: <SRS0=D+Hy=4U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4554C3F2D9
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 09:48:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B42A620848
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 09:48:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="IwqPGwRd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgCCJsr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Mar 2020 04:48:47 -0500
Received: from kadath.azazel.net ([81.187.231.250]:40830 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727982AbgCCJsr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Mar 2020 04:48:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MG/4Muke66DEE3195+EI6d+aJ1+1r8eHjC+yCa/YzfE=; b=IwqPGwRdrRgjNvKxCHMpxXv9F2
        quHBl10Uh+yqWm0PSZZRlKnfhk8CLYEcBLXYLSCk7shgvd+3Hi1/+Nv1IENz8TwmYilFqKjhhQhAa
        JKkR0x7A6T0GmeDPoHAjMqy3NWmxkGTr/WG5me8FfXoh6y8CRpJPGtmIEYZeiUI10FYwcNrt15xyI
        RwazW2X20wlBn1aO0b/tACumYcyaTILnUV0Zh4odCA8qQxxWCpqhS+0f6X8LbUyUUiOTvXsw/EISv
        BDjC+8oJ8J+O04VjJohXEwF0GU55xSf6X2n0ig1BRH+psqDBdCxGGJtwmR/45jluj9AwoavGTtoI4
        kVctwp4g==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j94AP-00081M-R1; Tue, 03 Mar 2020 09:48:45 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v3 07/18] src: fix leaks.
Date:   Tue,  3 Mar 2020 09:48:33 +0000
Message-Id: <20200303094844.26694-8-jeremy@azazel.net>
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

Some bitmask variables are not cleared.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/evaluate.c            | 2 ++
 src/netlink_delinearize.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index f4260436ae0f..4a23b231c74d 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -483,6 +483,7 @@ static void expr_evaluate_bits(struct eval_ctx *ctx, struct expr **exprp)
 	mask = constant_expr_alloc(&expr->location, expr_basetype(expr),
 				   BYTEORDER_HOST_ENDIAN, masklen, NULL);
 	mpz_set(mask->value, bitmask);
+	mpz_clear(bitmask);
 
 	and = binop_expr_alloc(&expr->location, OP_AND, expr, mask);
 	and->dtype	= expr->dtype;
@@ -2290,6 +2291,7 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 	mpz_export_data(data, bitmask, BYTEORDER_HOST_ENDIAN, sizeof(data));
 	mask = constant_expr_alloc(&payload->location, expr_basetype(payload),
 				   BYTEORDER_HOST_ENDIAN, masklen, data);
+	mpz_clear(bitmask);
 
 	payload_bytes = payload_expr_alloc(&payload->location, NULL, 0);
 	payload_init_raw(payload_bytes, payload->payload.base,
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 3c80895a43f9..79efda123c14 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2558,6 +2558,7 @@ static void stmt_payload_binop_postprocess(struct rule_pp_ctx *ctx)
 			mpz_init_bitmask(bitmask, payload->len);
 			mpz_xor(bitmask, bitmask, value->value);
 			mpz_set(value->value, bitmask);
+			mpz_clear(bitmask);
 			break;
 		case OP_OR: /* IIb */
 			break;
-- 
2.25.1

