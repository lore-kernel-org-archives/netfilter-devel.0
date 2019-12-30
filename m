Return-Path: <SRS0=r9U9=2U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A513AC2D0C2
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 11:22:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86CE7206E4
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 11:22:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbfL3LWE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Dec 2019 06:22:04 -0500
Received: from correo.us.es ([193.147.175.20]:59316 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727460AbfL3LWD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Dec 2019 06:22:03 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 08B3E4DE747
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 12:22:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EC468DA710
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 12:22:01 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DA5A6DA720; Mon, 30 Dec 2019 12:22:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C5930DA78D;
        Mon, 30 Dec 2019 12:21:59 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Dec 2019 12:21:59 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [185.124.28.61])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 43A7241E4800;
        Mon, 30 Dec 2019 12:21:59 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 11/17] netfilter: nft_meta: move sk uid/git handling to helper
Date:   Mon, 30 Dec 2019 12:21:37 +0100
Message-Id: <20191230112143.121708-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191230112143.121708-1-pablo@netfilter.org>
References: <20191230112143.121708-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Not a hot path.  Also, both have copy&paste case statements,
so use a common helper for both.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_meta.c | 65 +++++++++++++++++++++++++++---------------------
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
2.11.0

