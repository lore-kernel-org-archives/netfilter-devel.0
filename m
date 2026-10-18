Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE8C43AB0
	for <netfilter-devel@vger.kernel.org>; Sun, 18 Oct 2026 00:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792281975; cv=none; b=n4ruuU9CR7z0ffBk967wvWpqOtO+AtQN6lIWcOkQM8Z5G1Wz03fZNsKlrI6VPmPgR20Zfoc4WG8RuIyhHkeDthscsplP4WWLXxrSykIYT7mAg5kA9463Y2FFNQ/nC5DOESUeV90FSTfirdoy9DwgWlzzWOJ9uwFktcuZxVNfcbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792281975; c=relaxed/simple;
	bh=MV1LeJq/R19qHH+HUFtbJU08hDkUuVhN/JBSpl6SKWA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=VDWcT+h8/baZwT/gIgQEezs9t9ouiv11WWY1BGdheMGkMEYHLlIAqFEOKWKytzNZIoCg24B2DZClISpZCyl8H/lXXUyOPG9Q798T/AKWHn0k8MHbJCkQWrrkIkIG2n6r47Jch2bzEVzmhD6UJKdwQr3OHvH+RkgZ3rHw+7ZHxDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=R+v0NdNb; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="R+v0NdNb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792281969;
	bh=yCVakKsOLO1oDDz9Jhw6wuh7EBNlfwJ4GdpUI0HdFRk=;
	h=From:To:Subject:Date:From;
	b=R+v0NdNbNnRBPZ8cG7qPFmacK6fxpUncsmest5fhK6M46Oljb3cpDy7dldWg1Myg8
	 oUlugGpIBInOeZhKfX6KY4Octufs/LLSzYKJV3zsCfHYdQlqQkkH/5cnnyTttzSd66
	 4FqfQypwmeD5689URCWvNmWCTwEZfi2UQH7hJiRZH4Tt/pLUSt2i+UtKsTqtJrUskb
	 LXx44EldynvfbYVZZ6EV2zrDBose10XMoSb7WskD/3R82V5Ent7pJtj+bpgIKE14kB
	 9/+K3+gYBq3cZYS4P1PFJOWT0wa6AK9couosqIPkTmyhLhAqF9XgYISRzmnsPqoi5x
	 3oHc9PoQPjAbQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2620D600A1
	for <netfilter-devel@vger.kernel.org>; Sun, 18 Oct 2026 02:06:09 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 1/2] netfilter: nfnetlink_queue: add helper function to retrieve hook entries
Date: Sun, 18 Oct 2026 02:06:04 +0200
Message-ID: <20261018000605.1748752-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add nf_queue_hook_entry() and nf_queue_hook_entries() helper functions
to retrieve hook entries and use them.

This comes in preparation for a fix to restrict expectation creation to
nfnetlink_cthelper.

No functional changes are intended.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_queue.c | 43 ++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index a3bc00280051..5b45d67e71cd 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -358,30 +358,45 @@ static int nf_reroute(struct sk_buff *skb, struct nf_queue_entry *entry)
 	return ret;
 }
 
+static const struct nf_hook_entries *
+nf_queue_hook_entries(struct nf_queue_entry *entry)
+{
+	const struct net *net = entry->state.net;
+	u8 pf = entry->state.pf;
+
+	return nf_hook_entries_head(net, pf, entry->state.hook);
+}
+
+static const struct nf_hook_entry *
+nf_queue_hook_entry(const struct nf_hook_entries *hooks,
+		    struct nf_queue_entry *entry)
+{
+	unsigned int i = entry->hook_index;
+
+	if (i >= hooks->num_hook_entries)
+		return NULL;
+
+	return &hooks->hooks[i];
+}
+
 /* caller must hold rcu read-side lock */
 static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 {
 	const struct nf_hook_entry *hook_entry;
 	const struct nf_hook_entries *hooks;
 	struct sk_buff *skb = entry->skb;
-	const struct net *net;
 	unsigned int i;
 	int err;
-	u8 pf;
 
-	net = entry->state.net;
-	pf = entry->state.pf;
+	hooks = nf_queue_hook_entries(entry);
+	if (!hooks)
+		goto drop;
 
-	hooks = nf_hook_entries_head(net, pf, entry->state.hook);
+	hook_entry = nf_queue_hook_entry(hooks, entry);
+	if (!hook_entry)
+		goto drop;
 
 	i = entry->hook_index;
-	if (!hooks || i >= hooks->num_hook_entries) {
-		kfree_skb_reason(skb, SKB_DROP_REASON_NETFILTER_DROP);
-		nf_queue_entry_free(entry);
-		return;
-	}
-
-	hook_entry = &hooks->hooks[i];
 
 	/* Continue traversal iff userspace said ok... */
 	if (verdict == NF_REPEAT)
@@ -417,6 +432,10 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	}
 
 	nf_queue_entry_free(entry);
+	return;
+drop:
+	kfree_skb_reason(skb, SKB_DROP_REASON_NETFILTER_DROP);
+	nf_queue_entry_free(entry);
 }
 
 /* return true if the entry has an unconfirmed conntrack attached that isn't owned by us
-- 
2.47.3

