Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C0DC433DB
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Feb 2021 15:10:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22C2C64E50
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Feb 2021 15:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbhBHPK0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Feb 2021 10:10:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbhBHPIc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Feb 2021 10:08:32 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD782C061786;
        Mon,  8 Feb 2021 07:08:17 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1l9898-0004VT-Um; Mon, 08 Feb 2021 16:08:14 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     netfilter@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Martin Gignac <martin.gignac@gmail.com>
Subject: [PATCH nft] trace: do not remove icmp type from packet dump
Date:   Mon,  8 Feb 2021 16:08:09 +0100
Message-Id: <20210208150809.1601-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <CANf9dFNK+APd2Pn0twresoZic60q+cFJ+yxc77fggYZKsf-11A@mail.gmail.com>
References: <CANf9dFNK+APd2Pn0twresoZic60q+cFJ+yxc77fggYZKsf-11A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

As of 0.9.8 the icmp type is marked as a protocol field, so its
elided in 'nft monitor trace' output:

   icmp code 0 icmp id 44380 ..

Restore it.  Unlike tcp, where 'tcp sport' et. al in the dump
will make the 'ip protocol tcp' redundant this case isn't obvious
in the icmp case:

  icmp type 8 code 0 id ...

Reported-by: Martin Gignac <martin.gignac@gmail.com>
Fixes: 98b871512c4677 ("src: add auto-dependencies for ipv4 icmp")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/netlink.c b/src/netlink.c
index ec2dad29ace1..c3887d5b6662 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1859,7 +1859,9 @@ next:
 		    pctx->pbase == PROTO_BASE_INVALID) {
 			payload_dependency_store(pctx, stmt, base - stacked);
 		} else {
-			payload_dependency_kill(pctx, lhs, ctx->family);
+			/* Don't strip 'icmp type' from payload dump. */
+			if (pctx->icmp_type == 0)
+				payload_dependency_kill(pctx, lhs, ctx->family);
 			if (lhs->flags & EXPR_F_PROTOCOL)
 				payload_dependency_store(pctx, stmt, base - stacked);
 		}
-- 
2.26.2

