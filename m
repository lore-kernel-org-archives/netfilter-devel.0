Return-Path: <SRS0=4Rej=4R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E14EBC3F2D7
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Feb 2020 11:27:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD334246A2
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Feb 2020 11:27:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="UetdEBY2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbgB2L1f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Feb 2020 06:27:35 -0500
Received: from kadath.azazel.net ([81.187.231.250]:48656 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbgB2L1e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Feb 2020 06:27:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=M9KtdBLmRU8rUHsjNOuiO+TtR+E/sJYKBj50GT82ilA=; b=UetdEBY2ipPkY0BFQNzngkyMpY
        KZgCDxS4CY4BsEKZyYrjUdIxcNXLfHogxH3qV+eTe4Inzyc4p9t7gbw9FturJw4FNmUYM6N7b8Bbo
        UloT+q5tgZL5Oe38q+tN8AVQYeoneQDcEYB3DbudRoNOfECb6hcmWp3W+ufvSWW1Yvlx0xGoOmhry
        5t2874RlJf9td6M9UINoTR3qEGKDqce0XMHN8cy3MxmENp08agUlqWLdA4WYHqKdfv9FP0tI4FtVV
        dnk+XbdFfOQbu3A2x85Im4aMFTNcy8jKN/Zt9xdSBLdsUinYMncO5FC/Y27VZ84buMX4UtFFfirEN
        yhsDwjDg==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j80HL-0003Wm-VP; Sat, 29 Feb 2020 11:27:32 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 03/18] evaluate: don't evaluate payloads twice.
Date:   Sat, 29 Feb 2020 11:27:16 +0000
Message-Id: <20200229112731.796417-4-jeremy@azazel.net>
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

Payload munging means that evaluation of payload expressions may not be
idempotent.  Add a flag to prevent them from being evaluated more than
once.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/expression.h | 1 +
 src/evaluate.c       | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/expression.h b/include/expression.h
index 62fbbbb5a737..87c39e5de08a 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -300,6 +300,7 @@ struct expr {
 			enum proto_bases		base;
 			unsigned int			offset;
 			bool				is_raw;
+			bool				evaluated;
 		} payload;
 		struct {
 			/* EXPR_EXTHDR */
diff --git a/src/evaluate.c b/src/evaluate.c
index e2eff2353657..a169e41bd833 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -736,6 +736,9 @@ static int expr_evaluate_payload(struct eval_ctx *ctx, struct expr **exprp)
 {
 	struct expr *expr = *exprp;
 
+	if (expr->payload.evaluated)
+		return 0;
+
 	if (__expr_evaluate_payload(ctx, expr) < 0)
 		return -1;
 
@@ -745,6 +748,8 @@ static int expr_evaluate_payload(struct eval_ctx *ctx, struct expr **exprp)
 	if (payload_needs_adjustment(expr))
 		expr_evaluate_bits(ctx, exprp);
 
+	expr->payload.evaluated = true;
+
 	return 0;
 }
 
-- 
2.25.0

