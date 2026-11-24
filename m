Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795525717;
	b=w+2LA1Ldbj/mJ57YxrcEovG59XlTEX/fOsrQ6AFNqyVMHh77NWE52gDm9lypTG+LbC/0
	 T+FmW02qOcebc8itOcnOLScuErO0b+ibyn5cXLzDeP7ewfZfazHjDDBdniEhYG2sDj7Fn
	 cp+k9sqcVVw4rFENtZbosw5c+YlHbiqkcDw9/Gt+3GYdXFPL8ZGFfPt/SVZOXmUvIIZuC
	 8CVrwnZECT7DLeZscRb/KS36xSoEIlW1j6apuHTNoiMx39qdXNCdiIIyE1nxGLVuVkDRs
	 MoLS+OG5XmAeotW2qXocWKBV2Xohw84UU8We+7ULs8ch4YfMCPWNDpGxNXfVxGeZwNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795525717;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=RQ3YF1RfEqs94cp9dLMIze3uhjn7zFoDvRCz3CbVmv8=;
	b=nbJugpbCUWQELkIRNpWwluerQNvzSLVnPrbI/AIRkiVCDWjDVafmH+MyyGtXoueS3MgT
	 FUFLRz1jHHiDAUOShcH8+os6o4ZKKNyt/Mx2YdMEiTn/GkqtPUF2J4XVn3Ryxcr2YaWBM
	 qnX2VkjI06ePwYkLt9H9lvZFuESFeNwbD0X/TaQxSXONNY7bTAVpFpdy2Mb1I71kR0T/J
	 lYpEsebN86tmjwOKrmgxH05kJXh9LOMHmNMjvtdjsAubMQg6nFlOte6Yh8tJRWdwV7HRx
	 S7VVKHMAdxWuQ2OQMlfMR7zIyYMyeP5V9e7rK1lmQ6Dip1ke1kaiiHoS4KHTWJc50aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=oR3lIa81;
	arc=none smtp.remote-ip=95.215.58.3
Received: from mta1.migadu.com (out-3.mta1.migadu.com [95.215.58.3])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8584C606A326
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2026 13:08:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8584C606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=oR3lIa81
X-Envelope-To: netfilter-devel@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=nji5A2XjSCYxW4EpPuWPD3nn2/76/ynnUfE5sAmbOEw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795525714; v=1; x=1796130514;
 b=oR3lIa81Ip6PgF7APxT9LAO91m++WqKzt8FAV2PFHux+GWJn04KEwKULNkCkbO+SjUnrH6Ac
 b+9CG0eR2VzYoOVDPZ6FWxv6C1Lj6dsW2yofWpoK+7RrYo2ZcJy0F8HB8M52dtmh9aqxu+plSDk
 YNWLOB3qKCp23btyNMsBDFFQ=
X-Envelope-To: netfilter-devel@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 052fed434da67c83;
	Tue, 24 Nov 2026 13:08:34 +0000
X-Mizu-Trace-ID: 052fed434da67c83
X-Migadu-Flow: FLOW_OUT
From: Xuanqiang Luo <xuanqiang.luo@linux.dev>
To: netdev@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Matthieu Baerts <matttbe@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mptcp@lists.linux.dev,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Subject: [PATCH net-next v1 5/6] tcp: avoid a stack canary in tcp_rcv_established()
Date: Tue, 24 Nov 2026 22:06:30 +0900
Message-ID: <20261124130631.1886963-6-xuanqiang.luo@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261124130631.1886963-1-xuanqiang.luo@linux.dev>
References: <20261124130631.1886963-1-xuanqiang.luo@linux.dev>
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

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

tcp_rcv_established() passes the address of a local boolean to
tcp_queue_rcv(), to know if skb->head was stolen while coalescing.

With CONFIG_STACKPROTECTOR_STRONG=y, this forces a stack canary in
tcp_rcv_established(), which is paid for every received packet,
including pure ACKs. tcp_data_queue() has the same issue.

Change tcp_try_coalesce(), tcp_ooo_try_coalesce() and tcp_queue_rcv()
to return this information by value, in a new enum tcp_eaten.

$ scripts/bloat-o-meter -t vmlinux.old vmlinux.new
add/remove: 0/0 grow/shrink: 1/5 up/down: 16/-215 (-199)
Function                                     old     new   delta
tcp_validate_incoming                       2487    2503     +16
tcp_send_rcvq                                502     490     -12
tcp_try_coalesce                             359     336     -23
tcp_queue_rcv                                752     723     -29
tcp_data_queue                              4425    4350     -75
tcp_rcv_established                         3287    3211     -76
Total: Before=24067604, After=24067405, chg -0.00%

Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
---
 net/ipv4/tcp_input.c | 99 +++++++++++++++++++++++---------------------
 1 file changed, 52 insertions(+), 47 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 801c76744ed8..3d0a8b7e883e 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5276,41 +5276,47 @@ static void tcp_sack_remove(struct tcp_sock *tp)
 	tp->rx_opt.num_sacks = num_sacks;
 }
 
+/* Result of an attempt to merge an skb to a prior one. */
+enum tcp_eaten {
+	TCP_NOT_EATEN,
+	TCP_EATEN,
+	TCP_EATEN_STOLEN,	/* skb->head was stolen */
+};
+
 /**
  * tcp_try_coalesce - try to merge skb to prior one
  * @sk: socket
  * @to: prior buffer
  * @from: buffer to add in queue
- * @fragstolen: pointer to boolean
  *
  * Before queueing skb @from after @to, try to merge them
  * to reduce overall memory use and queue lengths, if cost is small.
  * Packets in ofo or receive queues can stay a long time.
  * Better try to coalesce them right now to avoid future collapses.
- * Returns true if caller should free @from instead of queueing it
+ *
+ * Return: TCP_NOT_EATEN if @from has to be queued. Otherwise the caller
+ * should free @from with kfree_skb_partial().
  */
-static bool tcp_try_coalesce(struct sock *sk,
-			     struct sk_buff *to,
-			     struct sk_buff *from,
-			     bool *fragstolen)
+static enum tcp_eaten tcp_try_coalesce(struct sock *sk,
+				       struct sk_buff *to,
+				       struct sk_buff *from)
 {
+	bool fragstolen;
 	int delta;
 
-	*fragstolen = false;
-
 	/* Its possible this segment overlaps with prior segment in queue */
 	if (TCP_SKB_CB(from)->seq != TCP_SKB_CB(to)->end_seq)
-		return false;
+		return TCP_NOT_EATEN;
 
 	if (!tcp_skb_can_collapse_rx(to, from))
-		return false;
+		return TCP_NOT_EATEN;
 
 	/* Nothing follows a FIN. */
 	if (unlikely(TCP_SKB_CB(to)->tcp_flags & TCPHDR_FIN))
-		return false;
+		return TCP_NOT_EATEN;
 
-	if (!skb_try_coalesce(to, from, fragstolen, &delta))
-		return false;
+	if (!skb_try_coalesce(to, from, &fragstolen, &delta))
+		return TCP_NOT_EATEN;
 
 	atomic_add(delta, &sk->sk_rmem_alloc);
 	sk_mem_charge(sk, delta);
@@ -5325,15 +5331,14 @@ static bool tcp_try_coalesce(struct sock *sk,
 		skb_hwtstamps(to)->hwtstamp = skb_hwtstamps(from)->hwtstamp;
 	}
 
-	return true;
+	return fragstolen ? TCP_EATEN_STOLEN : TCP_EATEN;
 }
 
-static bool tcp_ooo_try_coalesce(struct sock *sk,
-			     struct sk_buff *to,
-			     struct sk_buff *from,
-			     bool *fragstolen)
+static enum tcp_eaten tcp_ooo_try_coalesce(struct sock *sk,
+					   struct sk_buff *to,
+					   struct sk_buff *from)
 {
-	bool res = tcp_try_coalesce(sk, to, from, fragstolen);
+	enum tcp_eaten res = tcp_try_coalesce(sk, to, from);
 
 	/* In case tcp_drop_reason() is called later, update to->gso_segs */
 	if (res) {
@@ -5359,9 +5364,10 @@ static void tcp_ofo_queue(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	__u32 dsack_high = tp->rcv_nxt;
-	bool fin, fragstolen, eaten;
 	struct sk_buff *skb, *tail;
+	enum tcp_eaten eaten;
 	struct rb_node *p;
+	bool fin;
 
 	p = rb_first(&tp->out_of_order_queue);
 	while (p) {
@@ -5387,13 +5393,13 @@ static void tcp_ofo_queue(struct sock *sk)
 		bpf_tcp_ops_call_flag(enqueue_rcvq, RCVQ, sk, skb);
 
 		tail = skb_peek_tail(&sk->sk_receive_queue);
-		eaten = tail && tcp_try_coalesce(sk, tail, skb, &fragstolen);
+		eaten = tail ? tcp_try_coalesce(sk, tail, skb) : TCP_NOT_EATEN;
 		tcp_rcv_nxt_update(tp, TCP_SKB_CB(skb)->end_seq);
 		fin = TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN;
 		if (!eaten)
 			tcp_add_receive_queue(sk, skb);
 		else
-			kfree_skb_partial(skb, fragstolen);
+			kfree_skb_partial(skb, eaten == TCP_EATEN_STOLEN);
 
 		if (unlikely(fin)) {
 			tcp_fin(sk);
@@ -5460,8 +5466,8 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 	enum skb_drop_reason reason;
 	struct rb_node **p, *parent;
 	struct sk_buff *skb1;
+	enum tcp_eaten eaten;
 	u32 seq, end_seq;
-	bool fragstolen;
 	int rmem;
 
 	tcp_save_lrcv_flowlabel(sk, skb);
@@ -5504,15 +5510,15 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 	/* In the typical case, we are adding an skb to the end of the list.
 	 * Use of ooo_last_skb avoids the O(Log(N)) rbtree lookup.
 	 */
-	if (tcp_ooo_try_coalesce(sk, tp->ooo_last_skb,
-				 skb, &fragstolen)) {
+	eaten = tcp_ooo_try_coalesce(sk, tp->ooo_last_skb, skb);
+	if (eaten) {
 coalesce_done:
 		/* For non sack flows, do not grow window to force DUPACK
 		 * and trigger fast retransmit.
 		 */
 		if (tcp_is_sack(tp))
 			tcp_grow_window(sk, skb, true);
-		kfree_skb_partial(skb, fragstolen);
+		kfree_skb_partial(skb, eaten == TCP_EATEN_STOLEN);
 		skb = NULL;
 		goto add_sack;
 	}
@@ -5561,9 +5567,10 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 						SKB_DROP_REASON_TCP_OFOMERGE);
 				goto merge_right;
 			}
-		} else if (tcp_ooo_try_coalesce(sk, skb1,
-						skb, &fragstolen)) {
-			goto coalesce_done;
+		} else {
+			eaten = tcp_ooo_try_coalesce(sk, skb1, skb);
+			if (eaten)
+				goto coalesce_done;
 		}
 		p = &parent->rb_right;
 	}
@@ -5614,18 +5621,16 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 		tcp_rcvbuf_grow(sk, tp->rcvq_space.space);
 }
 
-static int __must_check tcp_queue_rcv(struct sock *sk, struct sk_buff *skb,
-				      bool *fragstolen)
+static enum tcp_eaten __must_check tcp_queue_rcv(struct sock *sk,
+						 struct sk_buff *skb)
 {
 	int rmem = atomic_read(&sk->sk_rmem_alloc);
 	struct sk_buff *tail = skb_peek_tail(&sk->sk_receive_queue);
-	int eaten;
+	enum tcp_eaten eaten;
 
 	bpf_tcp_ops_call_flag(enqueue_rcvq, RCVQ, sk, skb);
 
-	eaten = (tail &&
-		 tcp_try_coalesce(sk, tail,
-				  skb, fragstolen)) ? 1 : 0;
+	eaten = tail ? tcp_try_coalesce(sk, tail, skb) : TCP_NOT_EATEN;
 	tcp_rcv_nxt_update(tcp_sk(sk), TCP_SKB_CB(skb)->end_seq);
 	if (!eaten) {
 		tcp_add_receive_queue(sk, skb);
@@ -5637,10 +5642,10 @@ static int __must_check tcp_queue_rcv(struct sock *sk, struct sk_buff *skb,
 
 int tcp_send_rcvq(struct sock *sk, struct msghdr *msg, size_t size)
 {
+	enum tcp_eaten eaten;
 	struct sk_buff *skb;
 	int err = -ENOMEM;
 	int data_len = 0;
-	bool fragstolen;
 
 	if (size == 0)
 		return 0;
@@ -5674,8 +5679,9 @@ int tcp_send_rcvq(struct sock *sk, struct msghdr *msg, size_t size)
 	TCP_SKB_CB(skb)->end_seq = TCP_SKB_CB(skb)->seq + size;
 	TCP_SKB_CB(skb)->ack_seq = tcp_sk(sk)->snd_una - 1;
 
-	if (tcp_queue_rcv(sk, skb, &fragstolen)) {
-		WARN_ON_ONCE(fragstolen); /* should not happen */
+	eaten = tcp_queue_rcv(sk, skb);
+	if (eaten) {
+		WARN_ON_ONCE(eaten == TCP_EATEN_STOLEN); /* should not happen */
 		__kfree_skb(skb);
 	}
 	return size;
@@ -5697,8 +5703,7 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	enum skb_drop_reason reason;
-	bool fragstolen;
-	int eaten;
+	enum tcp_eaten eaten;
 
 	/* If a subflow has been reset, the packet should not continue
 	 * to be processed, drop the packet.
@@ -5756,7 +5761,7 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 			sk_forced_mem_schedule(sk, skb->truesize);
 		}
 
-		eaten = tcp_queue_rcv(sk, skb, &fragstolen);
+		eaten = tcp_queue_rcv(sk, skb);
 		if (skb->len)
 			tcp_event_data_recv(sk, skb);
 		if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN)
@@ -5777,8 +5782,8 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
 
 		tcp_fast_path_check(sk);
 
-		if (eaten > 0)
-			kfree_skb_partial(skb, fragstolen);
+		if (eaten)
+			kfree_skb_partial(skb, eaten == TCP_EATEN_STOLEN);
 		if (!sock_flag(sk, SOCK_DEAD))
 			tcp_data_ready(sk);
 		return;
@@ -6815,8 +6820,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 				goto discard;
 			}
 		} else {
-			int eaten = 0;
-			bool fragstolen = false;
+			enum tcp_eaten eaten;
 
 			if (tcp_checksum_complete(skb))
 				goto csum_error;
@@ -6847,7 +6851,7 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 			__skb_pull(skb, tcp_header_len);
 			tcp_ecn_received_counters(sk, skb,
 						  len - tcp_header_len);
-			eaten = tcp_queue_rcv(sk, skb, &fragstolen);
+			eaten = tcp_queue_rcv(sk, skb);
 
 			tcp_event_data_recv(sk, skb);
 
@@ -6864,7 +6868,8 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 			__tcp_ack_snd_check(sk, 0);
 no_ack:
 			if (eaten)
-				kfree_skb_partial(skb, fragstolen);
+				kfree_skb_partial(skb,
+						  eaten == TCP_EATEN_STOLEN);
 			tcp_data_ready(sk);
 			return;
 		}
-- 
2.43.0

