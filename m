Return-Path: <SRS0=S009=3H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2A8FC33CB7
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Jan 2020 21:23:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9335246A2
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Jan 2020 21:23:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="nTWJfVvh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgARVXV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 18 Jan 2020 16:23:21 -0500
Received: from kadath.azazel.net ([81.187.231.250]:55188 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbgARVXU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 18 Jan 2020 16:23:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/3T9m6QEVfVUD/+aCjgdUGEDP5YZEMp2PxMcG7lIs9w=; b=nTWJfVvhxQ+3O2fIO3YBQ54y+k
        OVhPn1YgdnEj2SjO2i0GwO2tOxisKbcJK3RxpSJfX0SC58e3IXFmUceF0VpeQ43PjXQ6eMogfYJ1d
        I3y8AoMJmSyEI/YHa0MAZCJF2zCFdjC/VfZax0W/KjXTtOAvwxR//aWUQ4EJ8XF4uZnxPzT8lBVR8
        falACkaqCnMtJhoWdemv74izYhqxXxTrgYilXH47kfpxz+YwI90CnYTlOjSMJQoUUmTsCqlWpRDZu
        37FxYCqrUslwZA4/pxCH9x0fqZW+lW89VsicPrtq1cexMYbe8rCZdsVsdZ/4EXpEq+pg8VvmQ1l/M
        SM87/3AA==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1isvYt-0006Ji-M5
        for netfilter-devel@vger.kernel.org; Sat, 18 Jan 2020 21:23:19 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v2 4/9] netlink_delinearize: remove commented out pr_debug statement.
Date:   Sat, 18 Jan 2020 21:23:14 +0000
Message-Id: <20200118212319.253112-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200118212319.253112-1-jeremy@azazel.net>
References: <20200118212319.253112-1-jeremy@azazel.net>
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

