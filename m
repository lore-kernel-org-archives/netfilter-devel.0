From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next] netfilter: nfqueue: don't use prev pointer
Date: Fri,  9 Oct 2015 13:10:37 +0200
Message-ID: <1444389037-17285-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:39466 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756705AbbJILKo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Oct 2015 07:10:44 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Usage of -prev seems buggy.  While packet was out our hook cannot be
removed but we have no way to know if the previous one is still valid.

So better not use ->prev at all.  Since NF_REPEAT just asks to invoke
same hook function again, just do so, and continue with nf_interate
if we get an ACCEPT verdict.

A side effect of this change is that if nf_reinject(NF_REPEAT) causes
another REPEAT we will now drop the skb instead of a kernel loop.

However, NF_REPEAT loops would be a bug so this should not happen anyway.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
Targetting -next: on -nf we need to s/elem->priv/elem/, else oops.

I tested this with nf-queue.c from libnetfilter_queue, changed to issue
NF_REPEAT + NFMARK=1 and
-m mark --mark 1 -j ACCEPT
-j NFQUEUE

-> ping works, both rule counters increment.

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 96777f9..253a995 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -192,10 +192,8 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	nf_queue_entry_release_refs(entry);
 
 	/* Continue traversal iff userspace said ok... */
-	if (verdict == NF_REPEAT) {
-		elem = list_entry(elem->list.prev, struct nf_hook_ops, list);
-		verdict = NF_ACCEPT;
-	}
+	if (verdict == NF_REPEAT)
+		verdict = elem->hook(elem->priv, skb, &entry->state);
 
 	if (verdict == NF_ACCEPT) {
 		afinfo = nf_get_afinfo(entry->state.pf);
-- 
2.0.5

