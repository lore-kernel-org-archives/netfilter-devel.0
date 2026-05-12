Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBAB3AC0CE
	for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2026 22:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778625865; cv=none; b=kEDZSn+w96Ka/tRB9XT2afwh9P0cQvMe+l4cI58dmZW5TJTHNxRoypTGqVSlI1Di8lhleJuP6sifAIhCjB3zZBzTWid/xsaYOm200n8aeZ4Hj9hhTQ/1LUi5BOM2uR0UKJxFgJpkEDHhlHuP5cKHheN+gTjhKrmGnk5JkLab5Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778625865; c=relaxed/simple;
	bh=6sgDentVb17w3Qnq1YedvkoDMgo2nPuVYIVOeqtvYfw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oz2Tkzzmuj8U9Vmy81hgoU2TiiIE+7kQgJwy7HMpxYJUQUv/sZ61U36cTotTxESsrTVqwnj6gMeFZaeMSEsztsWWf9e48tcjZeakDLrjxgqakoefv5JCK1WdVwM/cJt5xOZGBwPHcqPM3kPSdYJdouyo/Oqtk8tW22W9Twn7STo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Rd0r6Gkw; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Rd0r6Gkw"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 102236017E;
	Wed, 13 May 2026 00:44:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1778625861;
	bh=atqKZwckc0rBIB79yI7lVDtfLngOvSJocwbZsGgCwm0=;
	h=From:To:Cc:Subject:Date:From;
	b=Rd0r6Gkw9BgDue+IwScnsvQoO8lEKZ9u1Wqjq8Yqo70KOzZe7ZlmvPDrC+JR1drNh
	 4Tfi9Q94ey6j7KsDDkNj/n0EyoXQ9TySIC2D9FGecGbRT5b1gn9p5WxyBvWcecwkaa
	 80F5QFQCVpCf5sk1HOF6TXGiEe+62uFAe9vvgVZYpUDZENA6P4oD/X8ljNOvwQy/iQ
	 hVDmrnokqvRR4ul+Zhwcl3Tues421p4ovSBRboytXfIEMOxt+aLcZ4LudUEehktgyU
	 4D0/Su5oUnWBa7vAOxBzSKywBmUs33A2ixzvKL0fbAc9BN3PdS6F9+oGZg/aO5xcna
	 QlPfEGTCJyg5g==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf] netfilter: nf_queue: hold reference on skb->dev
Date: Wed, 13 May 2026 00:44:17 +0200
Message-ID: <20260512224417.812214-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Before NF_BR_LOCAL_IN, skb->dev is mangled in a way that results in
state->in != skb->dev, which can result in UaF when accessing the bridge
device if removed while in the queue.

Reported-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_queue.c        | 6 ++++++
 net/netfilter/nfnetlink_queue.c | 3 +++
 2 files changed, 9 insertions(+)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index a6c81c04b3a5..9c6741673842 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -59,8 +59,11 @@ static void nf_queue_sock_put(struct sock *sk)
 static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
 {
 	struct nf_hook_state *state = &entry->state;
+	struct sk_buff *skb = entry->skb;
 
 	/* Release those devices we held, or Alexey will kill me. */
+	if (skb->dev)
+		dev_put(skb->dev);
 	dev_put(state->in);
 	dev_put(state->out);
 	if (state->sk)
@@ -98,10 +101,13 @@ static void __nf_queue_entry_init_physdevs(struct nf_queue_entry *entry)
 bool nf_queue_entry_get_refs(struct nf_queue_entry *entry)
 {
 	struct nf_hook_state *state = &entry->state;
+	struct sk_buff *skb = entry->skb;
 
 	if (state->sk && !refcount_inc_not_zero(&state->sk->sk_refcnt))
 		return false;
 
+	if (skb->dev)
+		dev_hold(skb->dev);
 	dev_hold(state->in);
 	dev_hold(state->out);
 
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 58304fd1f70f..7408b348da13 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1212,6 +1212,9 @@ dev_cmp(struct nf_queue_entry *entry, unsigned long ifindex)
 	if (physinif == ifindex || physoutif == ifindex)
 		return 1;
 #endif
+	if (entry->skb->dev)
+		if (entry->skb->dev->ifindex == ifindex)
+			return 1;
 	if (entry->state.in)
 		if (entry->state.in->ifindex == ifindex)
 			return 1;
-- 
2.47.3

