Return-Path: <SRS0=uHYT=BB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 340D2C433E5
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jul 2020 11:51:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17D04206F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jul 2020 11:51:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731898AbgGVLvg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Jul 2020 07:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbgGVLvg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Jul 2020 07:51:36 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF80C0619DC
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jul 2020 04:51:35 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jyDHa-0008Qc-6J; Wed, 22 Jul 2020 13:51:34 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     sbrivio@redhat.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/2] netlink: fix concat range expansion in map case
Date:   Wed, 22 Jul 2020 13:51:25 +0200
Message-Id: <20200722115126.12596-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Maps with range + concatenation do not work:

Input to nft -f:
        map map_test_concat_interval {
                type ipv4_addr . ipv4_addr : mark
                flags interval
                elements = { 192.168.0.0/24 . 192.168.0.0/24 : 1,
                     192.168.0.0/24 . 10.0.0.1 : 2,
                             192.168.1.0/24 . 10.0.0.1 : 3,
                             192.168.0.0/24 . 192.168.1.10 : 4,
                }
        }

nft list:
        map map_test_concat_interval {
                type ipv4_addr . ipv4_addr : mark
                flags interval
                elements = { 192.168.0.0 . 192.168.0.0-10.0.0.1 : 0x00000002,
                             192.168.1.0-192.168.0.0 . 10.0.0.1-192.168.1.10 : 0x00000004 }
        }

This is not a display bug, nft sends broken information
to kernel.  Use the correct key expression to fix this.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/netlink.c b/src/netlink.c
index f752c3c932aa..b57e1c558501 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -123,7 +123,7 @@ static struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 	netlink_gen_data(key, &nld);
 	nftnl_set_elem_set(nlse, NFTNL_SET_ELEM_KEY, &nld.value, nld.len);
 
-	if (set->set_flags & NFT_SET_INTERVAL && expr->key->field_count > 1) {
+	if (set->set_flags & NFT_SET_INTERVAL && key->field_count > 1) {
 		key->flags |= EXPR_F_INTERVAL_END;
 		netlink_gen_data(key, &nld);
 		key->flags &= ~EXPR_F_INTERVAL_END;
-- 
2.26.2

