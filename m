Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AFF4C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Feb 2022 20:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234940AbiBWUKm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Feb 2022 15:10:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234567AbiBWUKm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Feb 2022 15:10:42 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A58C4C7AD
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Feb 2022 12:10:12 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nMxxh-0008Rj-OQ; Wed, 23 Feb 2022 21:10:09 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nf_queue: don't assume sk is full socket
Date:   Wed, 23 Feb 2022 21:10:04 +0100
Message-Id: <20220223201004.30615-1-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There is no guarantee that state->sk refers to a full socket.

If refcount transitions to 0, sock_put calls sk_free which then ends up
with garbage fields.

I'd like to thank Oleksandr Natalenko and Jiri Benc for considerable
debug work and pointing out state->sk oddities.

Fixes: ca6fb0651883 ("tcp: attach SYNACK messages to request sockets instead of listener")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 No reproducer, so there is a chance that the reported crash is caused by
 something else. That said, I don't see how sock_put use is safe here.

 net/netfilter/nf_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 6d12afabfe8a..178742a110d9 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -54,7 +54,7 @@ static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
 	dev_put(state->in);
 	dev_put(state->out);
 	if (state->sk)
-		sock_put(state->sk);
+		sock_gen_put(state->sk);
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	dev_put(entry->physin);
-- 
2.34.1

