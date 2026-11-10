Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794347686;
	b=AFCzST5fffYh7gi1bFC8G8Eay+QqFUTAink1W1hZPtx+L8oGi8xCaLYjh83s20+RTWlA
	 ku9fWts2P4pMhPU56hGG6g4KFDc7+pc4tXQ+spoavR6gtr6zJxc9QKwPEopqPncZm3a5F
	 6qogQlgRYeBNkKqNi1D6zaR4ld/+SE/EHJp58Kd5vr9pkCGr28z4lLCwsZEDewxuGPaPx
	 I1iLZw2AlJKdvJUsE81i4GeySGBeq4sy3f0UussL73bybrlrOJeKexmKC5QEK0WalVHuh
	 EdIZV1loLwqm9ma33aTGO3LqQ6C59cFiR7TXn5J2xOF4b3ybJweRExFKl+0DawUYGiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794347686;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=VG0FQGZtaJvUuPvoUldOYmMRJMDLasf2Pmn+DxMzQdE=;
	b=duep4VPdBEUeNtAZEzzpR9QjrU8B7OhWPbjGUDl7HHNG2KrtcE5+l2mb8QRHEtBgknq4
	 ZCX/ypEtKkVsuxbN+GheRaTbs6N5S0G04eWMgeFqafZeG71GPz3sgrmB9m/rbg4jN8IIu
	 7ud8Jo0pcZc1U5pDVfdwB8jV96zOrGqm1/yaREFnDnXOwVW+AclQ5yoBD9COhGvVtaoqe
	 clKNow3kj8Wa0vArsereNQHiXBT0N0AmkGHr9BHldrt3zOPducGETBIqNgubDD6cVhVH7
	 w7GL0fdukRHyadvYzrOZ4WoQvZ7BGLoaS5ndPATkwwnZVsYyGpg9TYuefBmWNwNGroA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=SqL9uAkg;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55240606A320
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 21:54:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55240606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=SqL9uAkg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794347683;
	bh=VG0FQGZtaJvUuPvoUldOYmMRJMDLasf2Pmn+DxMzQdE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=SqL9uAkgwrgzbYtDBhjy5pLag/pQnQcJVeNzWpV4ux9HVSt+O5eUfHRhDPpemXj9q
	 wCm3fRg+fXT0WsmNaKa+6/GA0OHPBgPqjPYYTc9LJbMpnApMmXTPfZ6jlEji9X+P7U
	 A4F+FkkNVFOGoD8Ky/2xzMoxURh0OwWdyUADbaUnR1hzDmY+zGlE5Q/tV8uUUzr5s8
	 K2khke+4R1uwOBMJLpHWKNOBbv3siBwp79oPk6cI7YOGQ2ZRGmVADgFzon8PB5IrxC
	 B/57++jT8F0o74O00fbOVqFqmuSKAv/40/xTVEUkpL1Uz45XTT1LnGVBf1IG1S5l79
	 P5/s4ij2zghLA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CAD6360304
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 22:54:43 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v6 2/7] netfilter: nfnetlink_queue: add helper function to retrieve hook entries
Date: Tue, 10 Nov 2026 22:54:34 +0100
Message-ID: <20261110215439.1958120-2-pablo@netfilter.org>
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

Add nf_queue_hook_entry() and nf_queue_hook_entries() helper functions
to retrieve hook entries and use them.

This comes in preparation for a fix to restrict expectation creation to
nfnetlink_cthelper.

No functional changes are intended.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v6: no changes

 net/netfilter/nfnetlink_queue.c | 40 +++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index a8aa7ad832c3..09af8faf8675 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -360,6 +360,27 @@ static int nf_reroute(struct sk_buff *skb, struct nf_queue_entry *entry)
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
@@ -367,10 +388,8 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	const struct nf_hook_entries *hooks;
 	struct sk_buff *skb = entry->skb;
 	bool old_in_nf_duplicate;
-	const struct net *net;
 	unsigned int i;
 	int err;
-	u8 pf;
 
 	DEBUG_NET_WARN_ONCE(current->in_nf_duplicate &&
 			    !entry->in_nf_duplicate,
@@ -379,20 +398,23 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	local_bh_disable();
 	old_in_nf_duplicate = current->in_nf_duplicate;
 
-	net = entry->state.net;
-	pf = entry->state.pf;
-
 	current->in_nf_duplicate = entry->in_nf_duplicate;
-	hooks = nf_hook_entries_head(net, pf, entry->state.hook);
 
-	i = entry->hook_index;
-	if (!hooks || i >= hooks->num_hook_entries) {
+	hooks = nf_queue_hook_entries(entry);
+	if (!hooks) {
 		kfree_skb_reason(skb, SKB_DROP_REASON_NETFILTER_DROP);
 		nf_queue_entry_free(entry);
 		goto out;
 	}
 
-	hook_entry = &hooks->hooks[i];
+	hook_entry = nf_queue_hook_entry(hooks, entry);
+	if (!hook_entry) {
+		kfree_skb_reason(skb, SKB_DROP_REASON_NETFILTER_DROP);
+		nf_queue_entry_free(entry);
+		goto out;
+	}
+
+	i = entry->hook_index;
 
 	/* Continue traversal iff userspace said ok... */
 	if (verdict == NF_REPEAT)
-- 
2.47.3

