Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62BE8C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Dec 2021 15:17:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234729AbhLGPUp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Dec 2021 10:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233954AbhLGPUo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Dec 2021 10:20:44 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A760C061746
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Dec 2021 07:17:14 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mucDR-0001kt-4b; Tue, 07 Dec 2021 16:17:13 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/4] payload: skip templates with meta key set
Date:   Tue,  7 Dec 2021 16:16:57 +0100
Message-Id: <20211207151659.5507-3-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211207151659.5507-1-fw@strlen.de>
References: <20211207151659.5507-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

meta templates are only there for ease of use (input/parsing).

When listing, they should be ignored:
 set s4 { typeof ip version elements = { 1, } }
 chain c4 { ip version @s4 accept }

gets listed as 'ip l4proto ...' which is nonsensical.

 after this patch we get:
in: ip version @s4
out: (@nh,0,8 & 0xf0) >> 4 == @s4

.. which is (marginally) better.

Next patch adds support for payload decoding.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/payload.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/payload.c b/src/payload.c
index d9e0d4254f19..79008762825f 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -811,6 +811,9 @@ void payload_expr_complete(struct expr *expr, const struct proto_ctx *ctx)
 		    tmpl->len    != expr->len)
 			continue;
 
+		if (tmpl->meta_key && i == 0)
+			continue;
+
 		if (tmpl->icmp_dep && ctx->th_dep.icmp.type &&
 		    ctx->th_dep.icmp.type != icmp_dep_to_type(tmpl->icmp_dep))
 			continue;
-- 
2.32.0

