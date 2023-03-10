Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D474C64EC4
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Mar 2023 11:24:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjCJLYB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Mar 2023 06:24:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbjCJLYA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Mar 2023 06:24:00 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E02BCBA2
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Mar 2023 03:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=HyAmSxyGLydAq3qIffRhAyrcdvU3qClJCKEdvzuLrAE=; b=i0RQ/0eqDyS6bXyB6tCfhjYohy
        xSe65srTaLwHWC7Iezcuqy/M5Zr+cVFv5g9BUL9Hm8t2SIKPY0evVWpq9mynVkaKDHCEXkM0E3lv6
        x5ARK2uMT6jCDxeU/DxRsNX1z8Xw4VoWTUF4OY4no1vsePwFIz75Y+SYqXVIEm6yGruPps/jpZApz
        ax0ZXj/mUXSKFXacmqzcyIx0JOphi/E77vUDQaGXbSye6lLzTKctuxQHv0t8SqJvigUyeCT94UFMv
        QhgLUyN2g2AJJ1mumMth7PncHUkC8NWPpL5LVm7xnm4q5Z0bu1b09Zzld1x46bz3qc5cAHdgx0sZs
        4NIzeQXA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1paaqr-0001NC-KR; Fri, 10 Mar 2023 12:23:57 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2] Reject invalid chain priority values in user space
Date:   Fri, 10 Mar 2023 12:23:48 +0100
Message-Id: <20230310112348.32373-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The kernel doesn't accept nat type chains with a priority of -200 or
below. Catch this and provide a better error message than the kernel's
EOPNOTSUPP.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Pull mpz_export_data() call out of the conditional.
- Check priority value before calling strcmp(), it's less expensive.
- Reword the error message as suggested.
---
 src/evaluate.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index d24f8b66b0de8..21831201519dd 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4842,6 +4842,8 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 	}
 
 	if (chain->flags & CHAIN_F_BASECHAIN) {
+		int priority;
+
 		chain->hook.num = str2hooknum(chain->handle.family,
 					      chain->hook.name);
 		if (chain->hook.num == NF_INET_NUMHOOKS)
@@ -4854,6 +4856,13 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 			return __stmt_binary_error(ctx, &chain->priority.loc, NULL,
 						   "invalid priority expression %s in this context.",
 						   expr_name(chain->priority.expr));
+
+		mpz_export_data(&priority, chain->priority.expr->value,
+				BYTEORDER_HOST_ENDIAN, sizeof(int));
+		if (priority <= -200 && !strcmp(chain->type.str, "nat"))
+			return __stmt_binary_error(ctx, &chain->priority.loc, NULL,
+						   "Chains of type \"nat\" must have a priority value above -200.");
+
 		if (chain->policy) {
 			expr_set_context(&ctx->ectx, &policy_type,
 					 NFT_NAME_MAXLEN * BITS_PER_BYTE);
-- 
2.38.0

