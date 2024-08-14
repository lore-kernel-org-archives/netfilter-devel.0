Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 427E914A097;
	Wed, 14 Aug 2024 22:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723674055; cv=none; b=WmHgOckK0N1AEa8AE4zNgDdwTr5z5yTtFPWHJSUGTup0yScs/++UgflDHxUZ6Bo/czJMNSrHtzASYBWkTKoGN7w0QmkN3xT0MSAxsHuHktDOIUrABGWfFzrBRq9zAWRdmyBBMfH4ZNx/6d/xf4oUvRJBdukmQeXBnPCj+hcm6iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723674055; c=relaxed/simple;
	bh=rlyyIgvMGTAzzAY8GHZbZD4QyFOJXFOoceMIfUtdIDM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BoSGOVCEwb1zSSYwt0Cyg6vcllSUxjWZzEgcWOfAjvmlId1iicKVyOQy0DRrW3wu1zv+0C6G0YwZa30aOTWkJfgu+1GH5oG4lXGOCQ4fi5pGSaL2xZllgnv3/xW7RicfWCZyKA9aX+TLTXDDZp/weMFqb2du8v2BVyDsZoJOzeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 4/8] netfilter: nf_queue: drop packets with cloned unconfirmed conntracks
Date: Thu, 15 Aug 2024 00:20:38 +0200
Message-Id: <20240814222042.150590-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240814222042.150590-1-pablo@netfilter.org>
References: <20240814222042.150590-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Conntrack assumes an unconfirmed entry (not yet committed to global hash
table) has a refcount of 1 and is not visible to other cores.

With multicast forwarding this assumption breaks down because such
skbs get cloned after being picked up, i.e.  ct->use refcount is > 1.

Likewise, bridge netfilter will clone broad/mutlicast frames and
all frames in case they need to be flood-forwarded during learning
phase.

For ip multicast forwarding or plain bridge flood-forward this will
"work" because packets don't leave softirq and are implicitly
serialized.

With nfqueue this no longer holds true, the packets get queued
and can be reinjected in arbitrary ways.

Disable this feature, I see no other solution.

After this patch, nfqueue cannot queue packets except the last
multicast/broadcast packet.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/br_netfilter_hooks.c |  6 +++++-
 net/netfilter/nfnetlink_queue.c | 35 +++++++++++++++++++++++++++++++--
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 09f6a773a708..8f9c19d992ac 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -622,8 +622,12 @@ static unsigned int br_nf_local_in(void *priv,
 	if (likely(nf_ct_is_confirmed(ct)))
 		return NF_ACCEPT;
 
+	if (WARN_ON_ONCE(refcount_read(&nfct->use) != 1)) {
+		nf_reset_ct(skb);
+		return NF_ACCEPT;
+	}
+
 	WARN_ON_ONCE(skb_shared(skb));
-	WARN_ON_ONCE(refcount_read(&nfct->use) != 1);
 
 	/* We can't call nf_confirm here, it would create a dependency
 	 * on nf_conntrack module.
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 55e28e1da66e..e0716da256bf 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -820,10 +820,41 @@ static bool nf_ct_drop_unconfirmed(const struct nf_queue_entry *entry)
 {
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	static const unsigned long flags = IPS_CONFIRMED | IPS_DYING;
-	const struct nf_conn *ct = (void *)skb_nfct(entry->skb);
+	struct nf_conn *ct = (void *)skb_nfct(entry->skb);
+	unsigned long status;
+	unsigned int use;
 
-	if (ct && ((ct->status & flags) == IPS_DYING))
+	if (!ct)
+		return false;
+
+	status = READ_ONCE(ct->status);
+	if ((status & flags) == IPS_DYING)
 		return true;
+
+	if (status & IPS_CONFIRMED)
+		return false;
+
+	/* in some cases skb_clone() can occur after initial conntrack
+	 * pickup, but conntrack assumes exclusive skb->_nfct ownership for
+	 * unconfirmed entries.
+	 *
+	 * This happens for br_netfilter and with ip multicast routing.
+	 * We can't be solved with serialization here because one clone could
+	 * have been queued for local delivery.
+	 */
+	use = refcount_read(&ct->ct_general.use);
+	if (likely(use == 1))
+		return false;
+
+	/* Can't decrement further? Exclusive ownership. */
+	if (!refcount_dec_not_one(&ct->ct_general.use))
+		return false;
+
+	skb_set_nfct(entry->skb, 0);
+	/* No nf_ct_put(): we already decremented .use and it cannot
+	 * drop down to 0.
+	 */
+	return true;
 #endif
 	return false;
 }
-- 
2.30.2

