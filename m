Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793925519;
	b=MNWFHXhq1HQzEVauODwc+YsS/b+8eHhCo+KXZXoAh57UkL3t7kuHD+4T/kje1fIN2diV
	 0jJvXu6HV+Rpg8isQJNuXdwX6R6uquUyyZE26DWz6FdMzg9k7bFNBVlbeVtxfn4O9XyQn
	 aEIjypB5VDaEemIK6JkA2Fk/vyC0ZgVxD7ZziWpcXoL1WXbOU80gz9oAEIN8IVbxtD0i9
	 eF5EtX9cAifyrwiPxuo7R9MkbzINuTMmzxs9mm4ypFhBTnHm9/Y4Ci/6wAd5kQYDOTSGo
	 6qUA1jNdGDumFKr1OOEUC9jl3d1uYExZy97JjXWZpu4GqujlwDx+6f/Lx8q7a7J6NTw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793925519;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=kaVH0A0JMbO+1bsZkRguhMGVAoNc+amrVPPZv2nocwU=;
	b=cicj8enlf37TdWhQhGPwhiPZAHHuMN6Y+W8/eC+axhLTxzOzUvaRLUk4QJrhs6RrE8Td
	 ksKqy85P5GhbYGWtIB9eMG00KC8oxWhRnLpNVrU05DTXB8Yg9gIZZT/em02Vrsw5i+taH
	 WdBZ8asBZH2L/UDEaTosO7GX4PU7O6fUxWhU0Aj5MY+lMv9KaavYZt2aspuZhzYculUML
	 kECR/qpgOJ55P0TpXXHmOfEaYXPDnqFFfLf2xzrw7Y6VpmFZ7KHUma7nNYdSheZhzPOHJ
	 vKq7XTPgrppu/SAaUyy9oKZGk2u3w0W+EKH0M4kTupDdQIAmBEHFTvFj6d+NXdf2Irg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BLUaIXvZ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EED9606A32C;
	Fri,  6 Nov 2026 00:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BLUaIXvZ
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793925519;
	b=O1LCwBddWTUkXCt+ML9xk3GLH+bOTm6nuWxQqvCLDVb6s1qdX05Am0Z4DCPp3Ot+w//l
	 0g6OKSwl4hryYV+p+CY5cg5NG6yJW1iiUEsJnN4gYWNYrwlfK+imaB+6mzlx77yH9cBnN
	 lY1sFqOuG+iAdA8aeHlbFpp8LvhfVMm0sRBwRoUhHB0l/XhkUYPM2/Vy0MkGUd6ntn2LM
	 SwPVOUFfBHbkziPw/qH4y35/MKi4e8l/gKGDsVybU3fJ9PZ2KS/Hobr92N79UdVuPsgrl
	 OPVpbRi/FtqNWTmycw08ChyYhAbZhDCkPpHCyPs146/XO6UXq1B8U+Wi4qGVn/ebo2A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793925519;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=kaVH0A0JMbO+1bsZkRguhMGVAoNc+amrVPPZv2nocwU=;
	b=LqFC/B/HROKvpcfYQnTeZ1++VMZf9vvw8GtXWbrBtiuFRzZOoSajI59JQO0u25n+5DgJ
	 YDmRx9NHwkn6Tv+BBr2cdMRoaCtI+ixo6aKgK+IFz14OUhjpCRvAiEwnjQ7C8k4ufbH38
	 +YPuM3zd9MIWeAM0Omx5w8NQZ1BcAsbdzNo4QPdN7nBQ4fo2eazf8EbCqBrJYr1btFk8r
	 q3qFaqBDh0mah+xsb7UKqDGmQivdmDqTZtAUwyStE6htOrZSkNsrfFqH1Unrb0Y0hxk3m
	 CIw7L9uptnq0le9mFZtHoaE+0Xu0tKjfwrKpCfWaZVSkBkADJ17Smt1Wmv3aStRgptQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 15C7C1F008A3;
	Fri,  6 Nov 2026 00:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793925519;
	bh=kaVH0A0JMbO+1bsZkRguhMGVAoNc+amrVPPZv2nocwU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=BLUaIXvZWgIbPv/Kdq1fvwlxuORrfgfG3k8yh4kwO2/UUxDdhS6vQD1pGSRSfZD9l
	 uVt5hLX9ViyslW0MBAPf67oXsFb+diFm4eOozQQdjZgp+qDEy6eO9vBvgGAeI0SDLw
	 8/dTayqR8gdJuHPE8LitYNz8E2PY9YrWoGZwwz+ST9BQ6g8e784iltNjc8I4Dd+Z/o
	 308B8st69kgMt1DfeDvSQhnXchWjA75no8Ij07nqHwvI1LOguhMePv2sT2fzdWCxEH
	 90aXjixccwpWMBpks4s+GTIlgFiHHJqC5i6yj3WeEUA6ApK9fVmDXTH+2pFtOiy9Nq
	 ZaE6lccUcv05Q==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 86A9845B1E;
	Fri,  6 Nov 2026 00:38:37 +0000 (UTC)
From: Alireza Asgari via B4 Relay <devnull+alireza.asgari.net@kernel.org>
Date: Fri, 06 Nov 2026 00:37:05 +0000
Subject: [PATCH RFC net 2/3] netfilter: nfnetlink_queue: fix batch verdict
 ordering across large ID gaps
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-nfqueue-review-v1-2-b6c933f44943@asgari.net>
References: <20261106-nfqueue-review-v1-0-b6c933f44943@asgari.net>
In-Reply-To: <20261106-nfqueue-review-v1-0-b6c933f44943@asgari.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, 
 netdev@vger.kernel.org, kunit-dev@googlegroups.com, 
 Alireza Asgari <alireza@asgari.net>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793925516; l=6889;
 i=alireza@asgari.net; s=nfqueue-20261106-d5b860a0;
 h=from:subject:message-id;
 bh=thyPlPBC4IPd7n1D48A6d9kY4Ts7iTj7kmr/x4AWyz8=;
 b=fp3I3S5jzfFlccSLkKo98X8xDa4oYEfvAIFmXMqWM3vxLtHg7FO7LeTBxKktDmfz4eMI2WG3R
 tRysb9swnlcDO1Ohv/3WLUvAm6PTUCBWjlL494V19lhWAsrHV9Tt3AE
X-Developer-Key: i=alireza@asgari.net; a=ed25519;
 pk=zQFqyM4zwBHzads8dtEOnNQiQQ1pktgndpKPB3TI+AE=
X-Endpoint-Received: by B4 Relay for
 alireza@asgari.net/nfqueue-20261106-d5b860a0 with auth_id=1424
X-Original-From: Alireza Asgari <alireza@asgari.net>
Reply-To: alireza@asgari.net
Content-Transfer-Encoding: 7bit

From: Alireza Asgari <alireza@asgari.net>

Signed 32-bit ID differences do not order packets separated by half an
ID cycle or more. Queue length does not bound this distance: an old
packet can remain queued while newer packets receive individual verdicts.
For IDs [1, 0x80000002], batching through 1 incorrectly selects both.
For [1, 2, 0x80000003], removing 2 before batching through it also selects
both remaining packets instead of only 1.

Look up a queued boundary by its unique ID and dequeue the FIFO prefix
through that entry. For an absent boundary, use the issuance interval
from the oldest pending packet through the latest assigned ID. Widen the
queue counter to u64 and store its upper 32 bits in a tail id_epoch field;
combine that field with the existing packet ID to recover issuance order.
Wire IDs, hash keys and the proc sequence column remain 32-bit.

An absent ID has a unique offset while the interval spans fewer than
2^32 increments. Outside that interval, retain before/after behavior
only within a strict half-range window. Return ERANGE without changing
the queue for a full-cycle interval or an ambiguous boundary. Empty
prefixes still return ENOENT. Exact queued boundaries work independently
of the interval length.

Assignment and selection stay under the queue lock; reinjection remains
outside it. Failed insertion or notification still consumes an ID.
The internal epoch cannot identify stale userspace verdicts after ID
reuse, and outstanding issuance distances must remain below 2^64.

Codex assisted with development, review and validation of this change.

Fixes: 97d32cf9440d ("netfilter: nfnetlink_queue: batch verdict support")
Signed-off-by: Alireza Asgari <alireza@asgari.net>
---
 include/net/netfilter/nf_queue.h |  1 +
 net/netfilter/nfnetlink_queue.c  | 68 +++++++++++++++++++++++++++++++++++-----
 2 files changed, 62 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index 86021c55ba3ce..41aeca590cc3a 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -25,6 +25,7 @@ struct nf_queue_entry {
 	struct nf_hook_state	state;
 	bool			nf_ct_is_unconfirmed;
 	u16			size; /* sizeof(entry) + saved route keys */
+	u32			id_epoch; /* upper 32 bits of NFQUEUE issuance order */
 
 	/* extra space to store route keys */
 };
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index c71f4fe890eee..23f9896930bb2 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -89,7 +89,7 @@ struct nfqnl_instance {
  */
 	spinlock_t	lock	____cacheline_aligned_in_smp;
 	unsigned int	queue_total;
-	unsigned int	id_sequence;		/* 'sequence' of pkt ids */
+	u64		id_sequence;		/* full sequence of assigned ids */
 	struct list_head queue_list;		/* packets in queue */
 };
 
@@ -994,6 +994,7 @@ __nfqnl_enqueue_packet(struct net *net, struct nfqnl_instance *queue,
 	int err = -ENOBUFS;
 	__be32 *packet_id_ptr;
 	int failopen = 0;
+	u64 sequence;
 
 	nskb = nfqnl_build_packet_message(net, queue, entry, &packet_id_ptr);
 	if (nskb == NULL) {
@@ -1005,7 +1006,9 @@ __nfqnl_enqueue_packet(struct net *net, struct nfqnl_instance *queue,
 	if (queue->queue_total >= queue->queue_maxlen)
 		goto err_out_queue_drop;
 
-	entry->id = ++queue->id_sequence;
+	sequence = ++queue->id_sequence;
+	entry->id = (u32)sequence;
+	entry->id_epoch = (u32)(sequence >> 32);
 	*packet_id_ptr = htonl(entry->id);
 
 	/* Insert into hash BEFORE unicast. If failure don't send to userspace. */
@@ -1714,9 +1717,45 @@ verdicthdr_get(const struct nlattr * const nfqa[])
 	return vhdr;
 }
 
-static int nfq_id_after(unsigned int id, unsigned int max)
+/* Called under queue->lock, for a boundary absent from the packet map. */
+static int nfqnl_batch_range(struct nfqnl_instance *queue, u32 maxid,
+			     u32 *firstid, u32 *max_offset)
 {
-	return (int)(id - max) > 0;
+	struct nf_queue_entry *first;
+	u64 first_sequence, span;
+
+	if (list_empty(&queue->queue_list))
+		return -ENOENT;
+
+	first = list_first_entry(&queue->queue_list, struct nf_queue_entry,
+				 list);
+	first_sequence = ((u64)first->id_epoch << 32) | first->id;
+	span = queue->id_sequence - first_sequence;
+	if (span > U32_MAX)
+		return -ERANGE;
+
+	/*
+	 * Interpret an absent ID in the current live issuance interval. Its
+	 * unsigned offset is unique while that interval is shorter than a
+	 * complete ID cycle. Failed notifications also advance the interval.
+	 * This cannot distinguish stale requests aliasing a later ID cycle.
+	 */
+	*firstid = first->id;
+	*max_offset = maxid - *firstid;
+	if (*max_offset <= span)
+		return 0;
+
+	/*
+	 * Outside that interval, preserve ordinary before/after requests only
+	 * when the boundary and both endpoints fit a strict half-range window.
+	 * Otherwise leave every packet queued rather than guess the prefix.
+	 */
+	if (*max_offset < BIT(31))
+		return 0;
+	if ((u32)(queue->id_sequence - maxid) < BIT(31))
+		return -ENOENT;
+
+	return -ERANGE;
 }
 
 static int nfqnl_recv_verdict_batch(struct sk_buff *skb,
@@ -1725,11 +1764,13 @@ static int nfqnl_recv_verdict_batch(struct sk_buff *skb,
 {
 	struct nfnl_queue_net *q = nfnl_queue_pernet(info->net);
 	u16 queue_num = ntohs(info->nfmsg->res_id);
-	struct nf_queue_entry *entry, *tmp;
+	struct nf_queue_entry *entry, *tmp, *last;
 	struct nfqnl_msg_verdict_hdr *vhdr;
 	struct nfqnl_instance *queue;
 	unsigned int verdict, maxid;
+	u32 firstid = 0, max_offset = 0;
 	LIST_HEAD(batch_list);
+	int err = 0;
 
 	queue = verdict_instance_lookup(q, queue_num,
 					NETLINK_CB(skb).portid);
@@ -1745,14 +1786,27 @@ static int nfqnl_recv_verdict_batch(struct sk_buff *skb,
 
 	spin_lock_bh(&queue->lock);
 
+	/* A unique queued boundary identifies the prefix across large gaps. */
+	last = rhashtable_lookup_fast(&queue->nfqnl_packet_map, &maxid,
+				      nfqnl_rhashtable_params);
+	if (!last) {
+		err = nfqnl_batch_range(queue, maxid, &firstid, &max_offset);
+		if (err)
+			goto unlock;
+	}
 	list_for_each_entry_safe(entry, tmp, &queue->queue_list, list) {
-		if (nfq_id_after(entry->id, maxid))
+		if (!last && (u32)(entry->id - firstid) > max_offset)
 			break;
 		__dequeue_entry(queue, entry);
 		list_add_tail(&entry->list, &batch_list);
+		if (entry == last)
+			break;
 	}
 
+unlock:
 	spin_unlock_bh(&queue->lock);
+	if (err)
+		return err;
 
 	if (list_empty(&batch_list))
 		return -ENOENT;
@@ -2150,7 +2204,7 @@ static int seq_show(struct seq_file *s, void *v)
 		   inst->peer_portid, inst->queue_total,
 		   inst->copy_mode, inst->copy_range,
 		   inst->queue_dropped, inst->queue_user_dropped,
-		   inst->id_sequence, 1);
+		   (u32)inst->id_sequence, 1);
 	return 0;
 }
 

-- 
2.43.0


