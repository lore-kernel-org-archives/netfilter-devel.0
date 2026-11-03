Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714608;
	b=a7sEWgr4vE0opM9Ge/iE5VSMm85970xeAZrFbGwngIVisbflJpLW+/V8oEMMB17vImg0
	 QZkgLzo4VGCY0B+MxbIhQhxfZ0q80DlCUhQQME/JQLpKOJcuZw3L+d2aJ9OHT+YKuhDZ5
	 9s755omGKeRClTEmAhKm00MxnttPMQkrow2lCND2Qm1Izl5Sx11cW5Y/XQRepn4OUlPc1
	 JjVzf3SnzBMhiBGk7Yujzv9aJ1m1aEhhFt23APXv0u+N3FCfjNUEQE3Fi/YD/w+x5B1OH
	 5iXF2NPwkFIe/+DfkAGbm7uT+KWYoALICh/d+LD/oS0Jzv6lr8C70pCxOMl2NYTWxwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714608;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=kuc0tSs2t8YhL7Z9z30YhIe5qV0tfMkKwJx3EJPkeDo=;
	b=f0A3ycbHdN8NrTrkkT3PCCXq9gwaGSP/PuQOfJBxPYu4ihKsVC2y69ha1FIeXPh5Powu
	 L1pZzkLUJmMrlp7869aUqGASl9lsyAhvepvWptRrc2tmVxSvG7zHsC7WmAjSH9SDKvTpY
	 zEnYO0wkq2O9D8JgFKlemA0kRZqqCV44PZQubFOvUOoJi4hlevaLcZvkAWbcpVf/fLFML
	 mMxFX9RFHtFpKQ6yFlnfRjvC/7c1XocMsEcxb7wg89Z6pQMPCcvcprcaZg3iHHfYOao3s
	 g+vO8O96D48VVZq0jHDNmbWnNdISSALF8IKoYobiQ9zydSmkQEduQxGLKnCadJKmKKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Kyz59pTO;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8F06083615;
	Tue,  3 Nov 2026 14:03:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1D8F06083615
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Kyz59pTO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793714606;
	bh=kuc0tSs2t8YhL7Z9z30YhIe5qV0tfMkKwJx3EJPkeDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kyz59pTONpbJF/KmuCcZVdpg0g537efKmDcYZ2Svrtg4A4ns6xkcG+7Qu5dCClGzd
	 q0oRFMJAnNCix5dXtQZ6MKrbiyeO3aJt5+2+cVNwi7lzDM2DJdTYVy1EWlPpjwhDGs
	 4tRlv3BNufeAM30Ik7meVhIb8xr9fQ+oR5TPK6FIuSHU4a+Kl8Krv67KMilsJWsS2U
	 /jzO7zP9sjYBZjdi3adL6VdS6jHguISAFGiNLPnEOuE4sgpNVclAvWmVKmi/3+K7WQ
	 wXGdxp0FcqJj7t7OCW6B0Roy2PBEx8fFAVXkCR/Mb4vcrBAF0hAQ6K+2sAKc2dgAe7
	 uxgV7YiL/WYeg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DEEA060092;
	Tue,  3 Nov 2026 15:03:25 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 07/15] netfilter: nf_dup: preserve guard across NFQUEUE reinjection
Date: Tue,  3 Nov 2026 15:03:00 +0100
Message-ID: <20261103140308.591690-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261103140308.591690-1-pablo@netfilter.org>
References: <20261103140308.591690-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zihan Xi <zihanx@nebusec.ai>

NFQUEUE can suspend traversal of a duplicated packet while the task-local
duplication guard is set. The output call then returns and clears the guard
before a later verdict resumes hook traversal.

Save the guard in the queue entry and restore it while reinjection
continues hook traversal. Preserve and restore the verdict task's prior
state, including nested synchronous reinjection.

Fixes: cd58bcd9787e ("netfilter: xt_TEE: have cloned packet travel through Xtables too")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_queue.h |  1 +
 net/netfilter/nf_queue.c         |  1 +
 net/netfilter/nfnetlink_queue.c  | 17 ++++++++++++++---
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index 86021c55ba3c..4a8cefd8398d 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -23,6 +23,7 @@ struct nf_queue_entry {
 	struct net_device	*physout;
 #endif
 	struct nf_hook_state	state;
+	bool			in_nf_duplicate;
 	bool			nf_ct_is_unconfirmed;
 	u16			size; /* sizeof(entry) + saved route keys */
 
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 166d05e994ac..bd603e3a99a5 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -219,6 +219,7 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 	*entry = (struct nf_queue_entry) {
 		.skb	= skb,
 		.skb_dev = skb->dev,
+		.in_nf_duplicate = current->in_nf_duplicate,
 		.state	= *state,
 		.hook_index = index,
 		.size	= sizeof(*entry) + route_key_size,
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 90d887546f7d..a8aa7ad832c3 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -44,6 +44,7 @@
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <net/netfilter/nf_queue.h>
+#include <net/net_debug.h>
 #include <net/netns/generic.h>
 
 #include <linux/atomic.h>
@@ -365,21 +366,30 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	const struct nf_hook_entry *hook_entry;
 	const struct nf_hook_entries *hooks;
 	struct sk_buff *skb = entry->skb;
+	bool old_in_nf_duplicate;
 	const struct net *net;
 	unsigned int i;
 	int err;
 	u8 pf;
 
+	DEBUG_NET_WARN_ONCE(current->in_nf_duplicate &&
+			    !entry->in_nf_duplicate,
+			    "%s called with unexpected duplication guard",
+			    __func__);
+	local_bh_disable();
+	old_in_nf_duplicate = current->in_nf_duplicate;
+
 	net = entry->state.net;
 	pf = entry->state.pf;
 
+	current->in_nf_duplicate = entry->in_nf_duplicate;
 	hooks = nf_hook_entries_head(net, pf, entry->state.hook);
 
 	i = entry->hook_index;
 	if (!hooks || i >= hooks->num_hook_entries) {
 		kfree_skb_reason(skb, SKB_DROP_REASON_NETFILTER_DROP);
 		nf_queue_entry_free(entry);
-		return;
+		goto out;
 	}
 
 	hook_entry = &hooks->hooks[i];
@@ -402,9 +412,7 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	switch (verdict & NF_VERDICT_MASK) {
 	case NF_ACCEPT:
 	case NF_STOP:
-		local_bh_disable();
 		entry->state.okfn(entry->state.net, entry->state.sk, skb);
-		local_bh_enable();
 		break;
 	case NF_QUEUE:
 		err = nf_queue(skb, &entry->state, i, verdict);
@@ -418,6 +426,9 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	}
 
 	nf_queue_entry_free(entry);
+out:
+	current->in_nf_duplicate = old_in_nf_duplicate;
+	local_bh_enable();
 }
 
 /* return true if the entry has an unconfirmed conntrack attached that isn't owned by us
-- 
2.47.3

