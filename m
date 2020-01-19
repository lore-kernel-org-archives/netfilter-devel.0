Return-Path: <SRS0=vOmJ=3I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5456CC33CB6
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 22:57:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22ACD20678
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 22:57:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="tLtrNJKm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbgASW5M (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 Jan 2020 17:57:12 -0500
Received: from kadath.azazel.net ([81.187.231.250]:56582 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728894AbgASW5M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Jan 2020 17:57:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/3T9m6QEVfVUD/+aCjgdUGEDP5YZEMp2PxMcG7lIs9w=; b=tLtrNJKmemGN46Uec2ki83nOu/
        n6punoftk88t2oPJ3SIDd6Kq3sbA3XvaUymsL2C59JYF+16be/BGH5iRYmuc197P5O78ra/fiN1QD
        M7SZG2VAMcpARa/x60ZHBusvPa5i/V7hv2je+DxRrtSuD6gSkg5DA9fmcXB6ayYDNcqd8GsIB+3Dk
        82bPuleeCiY9u5p7WoXyrI8hXXVotlULGkE6OUTk9P4Ltcd1ZMdYmUQE7dXzH4LJrJ8ratYvsW52y
        HMM3EtpUx42oT8CMLjAqht7s/NLsQobfr6RtJTgGBvsJji/IuVqREDpmdkyHKCaUh6xzhrMU8FRAX
        KHtYJofw==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1itJVH-0006wh-0U
        for netfilter-devel@vger.kernel.org; Sun, 19 Jan 2020 22:57:11 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v3 4/9] netlink_delinearize: remove commented out pr_debug statement.
Date:   Sun, 19 Jan 2020 22:57:05 +0000
Message-Id: <20200119225710.222976-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200119225710.222976-1-jeremy@azazel.net>
References: <20200119225710.222976-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The statement doesn't compile, so remove it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/netlink_delinearize.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 8b9b5c808384..8f2a5dfacd3e 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -2047,8 +2047,6 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
 {
 	struct expr *expr = *exprp, *i;
 
-	//pr_debug("%s len %u\n", expr->ops->name, expr->len);
-
 	switch (expr->etype) {
 	case EXPR_MAP:
 		switch (expr->map->etype) {
-- 
2.24.1

