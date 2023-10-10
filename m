Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1763BCD8C9D
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Oct 2023 14:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbjJJOyW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Oct 2023 10:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232586AbjJJOyV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Oct 2023 10:54:21 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BFFAF;
        Tue, 10 Oct 2023 07:54:20 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qqE7k-0001Qi-54; Tue, 10 Oct 2023 16:54:16 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH net-next 7/8] netfilter: conntrack: prefer tcp_error_log to pr_debug
Date:   Tue, 10 Oct 2023 16:53:37 +0200
Message-ID: <20231010145343.12551-8-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231010145343.12551-1-fw@strlen.de>
References: <20231010145343.12551-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

pr_debug doesn't provide any information other than that a packet
did not match existing state but also was found to not create a new
connection.

Replaces this with tcp_error_log, which will also dump packets'
content so one can see if this is a stray FIN or RST.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 4018acb1d674..e573be5afde7 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -835,7 +835,8 @@ static bool tcp_error(const struct tcphdr *th,
 
 static noinline bool tcp_new(struct nf_conn *ct, const struct sk_buff *skb,
 			     unsigned int dataoff,
-			     const struct tcphdr *th)
+			     const struct tcphdr *th,
+			     const struct nf_hook_state *state)
 {
 	enum tcp_conntrack new_state;
 	struct net *net = nf_ct_net(ct);
@@ -846,7 +847,7 @@ static noinline bool tcp_new(struct nf_conn *ct, const struct sk_buff *skb,
 
 	/* Invalid: delete conntrack */
 	if (new_state >= TCP_CONNTRACK_MAX) {
-		pr_debug("nf_ct_tcp: invalid new deleting.\n");
+		tcp_error_log(skb, state, "invalid new");
 		return false;
 	}
 
@@ -980,7 +981,7 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 	if (tcp_error(th, skb, dataoff, state))
 		return -NF_ACCEPT;
 
-	if (!nf_ct_is_confirmed(ct) && !tcp_new(ct, skb, dataoff, th))
+	if (!nf_ct_is_confirmed(ct) && !tcp_new(ct, skb, dataoff, th, state))
 		return -NF_ACCEPT;
 
 	spin_lock_bh(&ct->lock);
-- 
2.41.0

