Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D893C433FE
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Nov 2022 10:41:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236040AbiKNKlX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Nov 2022 05:41:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236024AbiKNKlS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Nov 2022 05:41:18 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7AAEC1A22E;
        Mon, 14 Nov 2022 02:41:15 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 5/6] netfilter: rpfilter/fib: clean up some inconsistent indenting
Date:   Mon, 14 Nov 2022 11:41:05 +0100
Message-Id: <20221114104106.8719-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221114104106.8719-1-pablo@netfilter.org>
References: <20221114104106.8719-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

No functional modification involved.

net/ipv4/netfilter/nft_fib_ipv4.c:141 nft_fib4_eval() warn: inconsistent indenting.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2733
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nft_fib_ipv4.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index fc65d69f23e1..9eee535c64dd 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -138,12 +138,11 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		break;
 	}
 
-       if (!oif) {
-               found = FIB_RES_DEV(res);
+	if (!oif) {
+		found = FIB_RES_DEV(res);
 	} else {
 		if (!fib_info_nh_uses_dev(res.fi, oif))
 			return;
-
 		found = oif;
 	}
 
-- 
2.30.2

