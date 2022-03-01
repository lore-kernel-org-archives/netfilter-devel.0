Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FB69C4321E
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Mar 2022 21:53:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238623AbiCAVya (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Mar 2022 16:54:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238409AbiCAVy2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Mar 2022 16:54:28 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8694688B37;
        Tue,  1 Mar 2022 13:53:46 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2578C6244C;
        Tue,  1 Mar 2022 22:52:17 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 4/8] netfilter: nf_queue: don't assume sk is full socket
Date:   Tue,  1 Mar 2022 22:53:33 +0100
Message-Id: <20220301215337.378405-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220301215337.378405-1-pablo@netfilter.org>
References: <20220301215337.378405-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

There is no guarantee that state->sk refers to a full socket.

If refcount transitions to 0, sock_put calls sk_free which then ends up
with garbage fields.

I'd like to thank Oleksandr Natalenko and Jiri Benc for considerable
debug work and pointing out state->sk oddities.

Fixes: ca6fb0651883 ("tcp: attach SYNACK messages to request sockets instead of listener")
Tested-by: Oleksandr Natalenko <oleksandr@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_queue.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 6d12afabfe8a..5ab0680db445 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -46,6 +46,15 @@ void nf_unregister_queue_handler(void)
 }
 EXPORT_SYMBOL(nf_unregister_queue_handler);
 
+static void nf_queue_sock_put(struct sock *sk)
+{
+#ifdef CONFIG_INET
+	sock_gen_put(sk);
+#else
+	sock_put(sk);
+#endif
+}
+
 static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
 {
 	struct nf_hook_state *state = &entry->state;
@@ -54,7 +63,7 @@ static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
 	dev_put(state->in);
 	dev_put(state->out);
 	if (state->sk)
-		sock_put(state->sk);
+		nf_queue_sock_put(state->sk);
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	dev_put(entry->physin);
-- 
2.30.2

