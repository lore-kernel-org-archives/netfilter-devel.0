Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51E54C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Apr 2022 11:20:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234200AbiDILW7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Apr 2022 07:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241619AbiDILWd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Apr 2022 07:22:33 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D26165A4
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Apr 2022 04:20:26 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nd98i-0007jq-8P; Sat, 09 Apr 2022 13:20:24 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Topi Miettinen <toiwoton@gmail.com>
Subject: [PATCH nf] netfilter: nft_socket: make cgroup match work in input too
Date:   Sat,  9 Apr 2022 13:20:19 +0200
Message-Id: <20220409112019.12113-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

cgroupv2 helper function ignores the already-looked up sk
and uses skb->sk instead.

Just pass sk from the calling function instead; this will
make cgroup matching work for udp and tcp in input even when
edemux did not set skb->sk already.

Cc: Topi Miettinen <toiwoton@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 NB: compile tested only.

 net/netfilter/nft_socket.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index bd3792f080ed..6d9e8e0a3a7d 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -37,12 +37,11 @@ static void nft_socket_wildcard(const struct nft_pktinfo *pkt,
 
 #ifdef CONFIG_SOCK_CGROUP_DATA
 static noinline bool
-nft_sock_get_eval_cgroupv2(u32 *dest, const struct nft_pktinfo *pkt, u32 level)
+nft_sock_get_eval_cgroupv2(u32 *dest, struct sock *sk, const struct nft_pktinfo *pkt, u32 level)
 {
-	struct sock *sk = skb_to_full_sk(pkt->skb);
 	struct cgroup *cgrp;
 
-	if (!sk || !sk_fullsock(sk) || !net_eq(nft_net(pkt), sock_net(sk)))
+	if (!sk_fullsock(sk))
 		return false;
 
 	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
@@ -109,7 +108,7 @@ static void nft_socket_eval(const struct nft_expr *expr,
 		break;
 #ifdef CONFIG_SOCK_CGROUP_DATA
 	case NFT_SOCKET_CGROUPV2:
-		if (!nft_sock_get_eval_cgroupv2(dest, pkt, priv->level)) {
+		if (!nft_sock_get_eval_cgroupv2(dest, sk, pkt, priv->level)) {
 			regs->verdict.code = NFT_BREAK;
 			return;
 		}
-- 
2.35.1

