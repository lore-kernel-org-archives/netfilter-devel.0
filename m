Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792684295;
	b=rzay2ZJDyFcirU194QauYVNvTplg0LZndeuQ9b+u1Ys2HwDB7by8jvKT81HxHdz6v+8W
	 aoAYr4/MP4zm9t2RJROUf8xgHr0TVOhJSR7atD1N7l/iupYtVbGNOjqC/X46lFLCgSOyq
	 OVwjxm030O6DnKYtcomugU4Ug7xLmOJh+qVPjtsRRbXom48ZMc6fKLPGoQFdX57CnwNgD
	 U3uV9YeuP+zst66cIxfLcecXpxLW7FPW6coRQurtcnHgv9I9vVK5sNHBdr0iQiiMI8RoL
	 kQW94qcnmPy7VFGiyam+R/UlduCD4euPay1XKgseGMWwj/LgN3pDIySvBTcRKzqczoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792684295;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=+ME/80QatzfKpvKQwLo0C4UeVM2LQy6SKxuQJowWhCI=;
	b=HQ6Nu/XpbdheoyxUzWF5XVDZNIDywV/i1OgXcb4/2yPOU27+8ru4ckgZTI+HVERbAIL0
	 w5ICSJ8aPvb+tR9Gu8Z+hHeFXvnAn0iRWeoR/oAY3cJj5XfqoGsP2bbm0qrlQPVlJYkdR
	 ty8WhY1AJbVsXETECqex0U430VDt7yMusPsteJd+xfiogFljPOlev86Kxat5oFDUL0FRS
	 8R3+OI8kCZlyfA/SlMX8coNgpHRpoPbE1sebbdc+5dgYwhKWGfEaoumNlr/Q/Tr9N+dJN
	 aESodPYUfAYabWnrmoJ0KC04etVHMNOa6io0GI0ItUbuS2CD+FJGK/UTx6Tc68ra8qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=BfieVTeA;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1328606A31A
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 15:51:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1328606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=BfieVTeA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792684292;
	bh=+ME/80QatzfKpvKQwLo0C4UeVM2LQy6SKxuQJowWhCI=;
	h=From:To:Subject:Date:From;
	b=BfieVTeAeFhC74Z26NMkw6rep2KguHe75AV6w/dnsqRsK/wNzCPcg3yjicGxX0U0X
	 PXECv1BM9jjP+Pn6tNcuMtcKSWba8HKcoNxqhfCIh3CwE2dJTgBPEWH+srOLC7FfCZ
	 S1EzMMg2hsgrsekX4UVjOSYWUSs021tvYahp/+ypIHVjLg3p2oK8C0my/knSBpzQgY
	 74halss+8/ILA5XEr5+LATGgfzEJ8AW0Nwk5k9sVdCUxz5t268RhDiQ+EUY6/HcquN
	 GaMWRlwzNL6sRwjhLsV4RfZcu3CpRZk6o0JDrYqht817qAmOxsDOpTttTTuBkpDRev
	 595rJIa+6SWmg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3EE406005D
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 17:51:32 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v3 1/3] netfilter: nfnetlink_queue: add helper function to retrieve hook entries
Date: Thu, 22 Oct 2026 17:51:27 +0200
Message-ID: <20261022155129.2003363-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
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

Add nf_queue_hook_entry() and nf_queue_hook_entries() helper functions
to retrieve hook entries and use them.

This comes in preparation for a fix to restrict expectation creation to
nfnetlink_cthelper.

No functional changes are intended.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: no changes

 net/netfilter/nfnetlink_queue.c | 43 ++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 90d887546f7d..6ebf2bb8bbbd 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -359,30 +359,45 @@ static int nf_reroute(struct sk_buff *skb, struct nf_queue_entry *entry)
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
@@ -418,6 +433,10 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
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

