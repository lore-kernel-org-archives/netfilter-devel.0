Return-Path: <SRS0=U5wk=2I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D633BC43603
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Dec 2019 11:05:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB5BA227BF
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Dec 2019 11:05:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbfLRLFm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Dec 2019 06:05:42 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:35980 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726674AbfLRLFm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Dec 2019 06:05:42 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ihX9A-00077i-Kv; Wed, 18 Dec 2019 12:05:40 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/9] netfilter: nft_meta: move sk uid/git handling to helper
Date:   Wed, 18 Dec 2019 12:05:15 +0100
Message-Id: <20191218110521.14048-4-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218110521.14048-1-fw@strlen.de>
References: <20191218110521.14048-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Not a hot path.  Also, both have copy&paste case statements,
so use a common helper for both.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_meta.c | 65 ++++++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 29 deletions(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index fe49b27dfa87..1b32440ec2e6 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -126,6 +126,41 @@ nft_meta_get_eval_pkttype_lo(const struct nft_pktinfo *pkt,
 	return true;
 }
 
+static noinline bool
+nft_meta_get_eval_skugid(enum nft_meta_keys key,
+			 u32 *dest,
+			 const struct nft_pktinfo *pkt)
+{
+	struct sock *sk = skb_to_full_sk(pkt->skb);
+	struct socket *sock;
+
+	if (!sk || !sk_fullsock(sk) || !net_eq(nft_net(pkt), sock_net(sk)))
+		return false;
+
+	read_lock_bh(&sk->sk_callback_lock);
+	sock = sk->sk_socket;
+	if (!sock || !sock->file) {
+		read_unlock_bh(&sk->sk_callback_lock);
+		return false;
+	}
+
+	switch (key) {
+	case NFT_META_SKUID:
+		*dest = from_kuid_munged(&init_user_ns,
+					 sock->file->f_cred->fsuid);
+		break;
+	case NFT_META_SKGID:
+		*dest =	from_kgid_munged(&init_user_ns,
+					 sock->file->f_cred->fsgid);
+		break;
+	default:
+		break;
+	}
+
+	read_unlock_bh(&sk->sk_callback_lock);
+	return true;
+}
+
 void nft_meta_get_eval(const struct nft_expr *expr,
 		       struct nft_regs *regs,
 		       const struct nft_pktinfo *pkt)
@@ -180,37 +215,9 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		nft_reg_store16(dest, out->type);
 		break;
 	case NFT_META_SKUID:
-		sk = skb_to_full_sk(skb);
-		if (!sk || !sk_fullsock(sk) ||
-		    !net_eq(nft_net(pkt), sock_net(sk)))
-			goto err;
-
-		read_lock_bh(&sk->sk_callback_lock);
-		if (sk->sk_socket == NULL ||
-		    sk->sk_socket->file == NULL) {
-			read_unlock_bh(&sk->sk_callback_lock);
-			goto err;
-		}
-
-		*dest =	from_kuid_munged(&init_user_ns,
-				sk->sk_socket->file->f_cred->fsuid);
-		read_unlock_bh(&sk->sk_callback_lock);
-		break;
 	case NFT_META_SKGID:
-		sk = skb_to_full_sk(skb);
-		if (!sk || !sk_fullsock(sk) ||
-		    !net_eq(nft_net(pkt), sock_net(sk)))
+		if (!nft_meta_get_eval_skugid(priv->key, dest, pkt))
 			goto err;
-
-		read_lock_bh(&sk->sk_callback_lock);
-		if (sk->sk_socket == NULL ||
-		    sk->sk_socket->file == NULL) {
-			read_unlock_bh(&sk->sk_callback_lock);
-			goto err;
-		}
-		*dest =	from_kgid_munged(&init_user_ns,
-				 sk->sk_socket->file->f_cred->fsgid);
-		read_unlock_bh(&sk->sk_callback_lock);
 		break;
 #ifdef CONFIG_IP_ROUTE_CLASSID
 	case NFT_META_RTCLASSID: {
-- 
2.24.1

