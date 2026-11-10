Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794347693;
	b=LuwWTLVhXpl5H91OEjODeCYPMyZl1/LCEPDpgL5fFH2r2tKzJulYFC7feviJt7fExnjt
	 y2kzgAQaaNvlijQ7TAi9qTyZvhQl5y1p7h8VbY+dSyjCc0MU/UsPDYXtqcdp85a8vL1w/
	 gyB+8jTiZp0Wmc6CCDgGNcjpTA7F4YaXzvizEQD+AgG5RhIJHS8Di6vI7+D8yhVr3Wvjh
	 7dNQSOLfo/tNxJNR7T0+vVDX6LPJViJ/gfP4rQxU+bnw7kxk8ROoMIyZ6Xto7aom6ty3s
	 h2qgmV5H2JBe1zr9lj5oVr44TVtmIBYdLeQKlcIP2eGevnXxByN86iWttFfbSBGklZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794347693;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=wMiKeNGdUJtFOBw3Zhiu176ZK6HZDS4UsftiYBTCU0I=;
	b=uK9WgPL0X/SHdj4ukvakFIDRYVTxJX8q1OgzmuGBH1Py78sO8uZV9/86MEBPkbX10jfJ
	 4UijgG9RBd0DEz6JvkolyYL2ueltkf2DwLreAAH8LJJTBdR8l8OilROLi6zf2WWx4RVSv
	 kBfTCU3bpeZjYUFOgwlm11q7UYNjktGvL0R6CJsu1oH+OTjxta39SDGSEAx1lRgBLxXUu
	 b3KtaA+G8Vlh0/dYgUm0bh/RcIWOkK7VMP7y9RVtEevUc66ziQRCwy7ikBHP2/en6aoa/
	 L0iPkfZM1RBJaE0xD/unRiTPeucc/eg1wg88Lz+6Du7OYevSU8GaFXB2mgk182bTfrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=uYkooTsz;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1C6606A320
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 21:54:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD1C6606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=uYkooTsz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794347690;
	bh=wMiKeNGdUJtFOBw3Zhiu176ZK6HZDS4UsftiYBTCU0I=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=uYkooTszfPyu0rSHq7MqnE+0Sco50fOcsMbagwGP3LR0efrJGpX4+1Pl7H11aHsbG
	 M6wcDHduZuKjrcR6EGlG39iAUHIaOaQgvxAu4BZMzmkT0cxxHE/nl4Ld61/zrm4iyt
	 wC5dbC1R3WLzmXQ8nPr7mlRVnqEr4k0SxC7YQuOaIpAJQ0yd3DBDQDUlZGzREbxjUH
	 Qza35dxevaurQmncEwmmeuzd/8djfCq0rV2IpxlmXGScjSM6Xxguqw4C7cKvqeTrx5
	 iND3dxWMXbsuqdSDKJV3CveKjaKN73zhCuZuzRzgG/OO8y9JPwVvqQ5CROPA0etNw0
	 Ztz3XfjT0q3Ng==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B323E60306
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 22:54:50 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v6 7/7] netfilter: nfnetlink_queue: do not skip ct confirmation with userspace ct helpers
Date: Tue, 10 Nov 2026 22:54:39 +0100
Message-ID: <20261110215439.1958120-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261110215439.1958120-1-pablo@netfilter.org>
References: <20261110215439.1958120-1-pablo@netfilter.org>
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

There are a two more issues with the existing userspace ct helpers:

- Disallow re-queueing packets in userspace ct helpers, none of the
  existing helper in userspace use this feature.

- nf_conntrack_update() should only be called if this is the confirmation
  hook, there is a new helper function to check this, use it.

While at this, nfqnl_reinject() is already called from a rcu read lock
section, remove the redundant rcu_read_{un,lock}().

Fixes: ee04805ff54a ("netfilter: conntrack: make conntrack userspace helpers work again")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v7: - disable NF_REPEAT and NF_QUEUE with userspace helpers from confirm hook.

 net/netfilter/nfnetlink_queue.c | 46 +++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 3f6b38776ff8..9c4f10b7525f 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -526,35 +526,51 @@ static void __nfqnl_reinject(struct nf_queue_entry *entry,
 			     const struct nf_hook_entries *hooks,
 			     unsigned int verdict)
 {
-	const struct nf_ct_hook *ct_hook;
+	unsigned int verdict_mask = verdict & NF_VERDICT_MASK;
 
 	if (!nf_bridge_ports_valid(entry))
-		verdict = NF_DROP;
+		goto drop;
 
-	if (verdict == NF_ACCEPT ||
-	    verdict == NF_REPEAT ||
-	    verdict == NF_STOP) {
-		unsigned int ct_verdict = verdict;
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	if (verdict_mask == NF_ACCEPT ||
+	    verdict_mask == NF_REPEAT ||
+	    verdict_mask == NF_STOP ||
+	    verdict_mask == NF_QUEUE) {
+		const struct nf_ct_hook *ct_hook;
+		struct nf_hook_ops **ops;
+		unsigned int i;
+
+		ops = nf_hook_entries_get_hook_ops(hooks);
+
+		i = entry->hook_index;
+		if (i >= hooks->num_hook_entries)
+			goto drop;
 
-		rcu_read_lock();
 		ct_hook = rcu_dereference(nf_ct_hook);
-		if (ct_hook)
-			ct_verdict = ct_hook->update(entry->state.net, entry->skb);
-		rcu_read_unlock();
+		if (ct_hook && nfqnl_hook_exp_support(ops[i])) {
+			if (verdict_mask == NF_QUEUE ||
+			    verdict_mask == NF_REPEAT)
+				goto drop;
+
+			verdict_mask = ct_hook->update(entry->state.net, entry->skb);
+		}
 
-		switch (ct_verdict & NF_VERDICT_MASK) {
+		switch (verdict_mask) {
 		case NF_ACCEPT:
 			/* follow userspace verdict, could be REPEAT */
 			break;
 		case NF_STOLEN:
 			nf_queue_entry_free(entry);
 			return;
+		case NF_QUEUE:
+			/* follow userspace verdict too */
+			break;
 		default:
-			verdict = ct_verdict & NF_VERDICT_MASK;
+			verdict = verdict_mask;
 			break;
 		}
 	}
-
+#endif
 	if (verdict != NF_DROP && entry->nf_ct_is_unconfirmed) {
 		/* If first queued segment was already reinjected then
 		 * there is a good chance the ct entry is now confirmed.
@@ -572,6 +588,10 @@ static void __nfqnl_reinject(struct nf_queue_entry *entry,
 			verdict = NF_DROP;
 	}
 	nf_reinject(entry, hooks, verdict);
+	return;
+drop:
+	kfree_skb_reason(entry->skb, SKB_DROP_REASON_NETFILTER_DROP);
+	nf_queue_entry_free(entry);
 }
 
 static void nfqnl_reinject(struct nf_queue_entry *entry,
-- 
2.47.3

