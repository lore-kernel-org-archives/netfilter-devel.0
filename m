Return-Path: <SRS0=i/iJ=2H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C517CC43603
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 11:27:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A44112146E
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 11:27:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfLQL1u (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Dec 2019 06:27:50 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:57354 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726383AbfLQL1u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 06:27:50 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ihB12-0006lr-Kl; Tue, 17 Dec 2019 12:27:48 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v3 07/10] mnl: round up the map data size too
Date:   Tue, 17 Dec 2019 12:27:10 +0100
Message-Id: <20191217112713.6017-8-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217112713.6017-1-fw@strlen.de>
References: <20191217112713.6017-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Same as key: if the size isn't divisible by BITS_PER_BYTE, we need to
round up, not down.

Without this, you can't store vlan ids in a map, as they are truncated
to 8 bit.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/mnl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/mnl.c b/src/mnl.c
index 03afe79c23a8..d5bdff293c61 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -861,7 +861,7 @@ int mnl_nft_set_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 		nftnl_set_set_u32(nls, NFTNL_SET_DATA_TYPE,
 				  dtype_map_to_kernel(set->data->dtype));
 		nftnl_set_set_u32(nls, NFTNL_SET_DATA_LEN,
-				  set->data->len / BITS_PER_BYTE);
+				  div_round_up(set->data->len, BITS_PER_BYTE));
 	}
 	if (set_is_objmap(set->flags))
 		nftnl_set_set_u32(nls, NFTNL_SET_OBJ_TYPE, set->objtype);
-- 
2.24.1

