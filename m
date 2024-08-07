Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C74612FF71
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Aug 2024 19:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723059656; cv=none; b=kXXO4qHtIjLhabyblG6rVrL910DrlU9TKzcurZIQ8OkSHsD3E6cVwe2mAiz9G9PZbXK+ZaWpXWbWjm50pYhllAzhh5kMbxuJP4ZClfvWy5hqe8MM8kswNYhB+D6mYe02omvvnh72bgAPW9haBXoG6EPhsV4xloHBJaisMDV7Sz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723059656; c=relaxed/simple;
	bh=p4eNcCv1XFEfKJmzwllak4FufxWQy8pIq8OsKlXTPDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lHq4IzhCoH3Du3g5bJuvSb94KO8mhGSntyMSt0n0D3wUj6I8fUMFbKNzOSQb+m+73svytDgY+zT4OwLPrXRRsB5rncVx+8jQDEULvJFCRpCBH8Di/XSGCNy78C4As/QarggpGHZfgBRMBxvffEJyHi8mvQZWbJ5RfTmXlnBwmWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sbmWi-0007eZ-Gj; Wed, 07 Aug 2024 21:40:52 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 1/2] netfilter: nf_queue: drop packets with cloned unconfirmed conntracks
Date: Wed,  7 Aug 2024 21:28:41 +0200
Message-ID: <20240807192848.28007-2-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
In-Reply-To: <20240807192848.28007-1-fw@strlen.de>
References: <20240807192848.28007-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
2.44.2

