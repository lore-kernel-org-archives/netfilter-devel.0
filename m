Return-Path: <SRS0=i/iJ=2H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84C2FC43603
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 23:59:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 595EE20729
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 23:59:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbfLQX7d (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Dec 2019 18:59:33 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:33640 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbfLQX7d (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 18:59:33 -0500
Received: from localhost ([::1]:46728 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1ihMkU-0002lL-Mh; Wed, 18 Dec 2019 00:59:30 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        =?UTF-8?q?M=C3=A1t=C3=A9=20Eckl?= <ecklm94@gmail.com>
Subject: [nf PATCH] netfilter: nft_tproxy: Fix port selector on Big Endian
Date:   Wed, 18 Dec 2019 00:59:29 +0100
Message-Id: <20191217235929.32555-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Big Endian architectures, u16 port value was extracted from the wrong
parts of u32 sreg_port, just like commit 10596608c4d62 ("netfilter:
nf_tables: fix mismatch in big-endian system") describes.

Fixes: 4ed8eb6570a49 ("netfilter: nf_tables: Add native tproxy support")
Cc: Máté Eckl <ecklm94@gmail.com>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nft_tproxy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_tproxy.c b/net/netfilter/nft_tproxy.c
index f92a82c738808..95980154ef02c 100644
--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -50,7 +50,7 @@ static void nft_tproxy_eval_v4(const struct nft_expr *expr,
 	taddr = nf_tproxy_laddr4(skb, taddr, iph->daddr);
 
 	if (priv->sreg_port)
-		tport = regs->data[priv->sreg_port];
+		tport = nft_reg_load16(&regs->data[priv->sreg_port]);
 	if (!tport)
 		tport = hp->dest;
 
@@ -117,7 +117,7 @@ static void nft_tproxy_eval_v6(const struct nft_expr *expr,
 	taddr = *nf_tproxy_laddr6(skb, &taddr, &iph->daddr);
 
 	if (priv->sreg_port)
-		tport = regs->data[priv->sreg_port];
+		tport = nft_reg_load16(&regs->data[priv->sreg_port]);
 	if (!tport)
 		tport = hp->dest;
 
-- 
2.24.1

