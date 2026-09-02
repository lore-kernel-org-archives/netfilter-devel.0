Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D841386C36;
	Wed,  2 Sep 2026 18:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788374506; cv=none; b=lB7SskkU0LSokRPc7mPf7+w8GmBL0PpZvPQnEwcjFhZ0kZliKh/KPEaTPCCrfb+++SmZqeNg80/9s4VcPlLEyc9fIoNKJNY66qfco4fSF8cFVsmGh+p9KpYMcv+y+/WBmjR+fch8byJsrzzMPIY8NilJ9ZSz+Van3jHK9rhYa6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788374506; c=relaxed/simple;
	bh=cHuW+PoC/Z1Qut9eKmuFeNWun/CMk2X5AcPMdTDPNdc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Pi3uhhXpTSud5dF9JtBlcVM2jSpBa0z+0wdvQ8JP4XKpORgCrJab/tP6r/D/4UKIjMXEM5VZSOfrTwRC+Fx8/gOBD6FRmQqJC2lVUYEVYVEXyIdrlfMRpXCJ24S5lmA41nyQJPxyO0ukAoM7EyK9P6cjue+TMwS4/Cy7YICZV8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=F6mOaSIn; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="F6mOaSIn"
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1x1pAz-00Apwz-F0; Wed, 02 Sep 2026 19:55:09 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From;
	bh=2fxNQ3cklJgeh+Wdn7qij4WTU+lRYoEvYB4H1QfnGkk=; b=F6mOaSInNmI/4+IX8kuWbZXR4j
	bXw7nbZ+2Ow0ksDuY1b0KmeDwmr3ZrlYy7UFaFsJV6Zg31+qRRiIqM9s2GcoWAJBD7fy5f0xpbsQ5
	rvCZEWJ+ddfkrtcqvtgvOEWrl/hXwdQiUUYNxU3egKq+8lgsAq/fNaQJrcfVCZwgoIvCIzv73Y+IH
	QLY40ejF/ZUhkcVhVZWwCIy69bQnu/Pkt4VTsKQRG2aIfkbzJjQMGFUif1WY6tYURNtUAOEDkaJoa
	aVfLOm4AsrBEn9GlTUoPYDVAPqhQXwAHGPqpGmFPDRLAIDLghnw2m3JSQzaU5CWrx1iDeEGOkoMjc
	sdauiRMw==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1x1pAy-00072p-U0; Wed, 02 Sep 2026 19:55:09 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.95)
	id 1x1pAk-0020Qt-QS;
	Wed, 02 Sep 2026 19:54:54 +0200
From: Michal Luczaj <mhal@rbox.co>
Date: Wed, 02 Sep 2026 19:52:15 +0200
Subject: [PATCH bpf v3 2/2] bpf: Fix reference leak in bpf_sk_assign()
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-sockmap-lookup-tcp-leak-v3-2-b998b3d49d07@rbox.co>
References: <20260902-sockmap-lookup-tcp-leak-v3-0-b998b3d49d07@rbox.co>
In-Reply-To: <20260902-sockmap-lookup-tcp-leak-v3-0-b998b3d49d07@rbox.co>
To: Alexei Starovoitov <ast@kernel.org>, 
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
 Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
 Emil Tsalapatis <emil@etsalapatis.com>, 
 John Fastabend <john.fastabend@gmail.com>, 
 Stanislav Fomichev <sdf@fomichev.me>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Kuniyuki Iwashima <kuniyu@google.com>, 
 Willem de Bruijn <willemb@google.com>, 
 Jakub Sitnicki <jakub@cloudflare.com>, 
 Jiayuan Chen <jiayuan.chen@linux.dev>, Joe Stringer <joe@wand.net.nz>, 
 Ihor Solodrai <ihor.solodrai@linux.dev>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 Phil Sutter <phil@nwl.cc>
Cc: Michal Luczaj <mhal@rbox.co>, bpf@vger.kernel.org, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
X-Mailer: b4 0.15.2

sk_is_refcounted() is mutable; it depends on sk_state and SOCK_RCU_FREE.
TC bpf_sk_assign() uses it at assign time to take a reference and lets
sock_pfree() re-evaluate it at free time. If the socket becomes
non-refcounted in between, e.g. connect(AF_UNSPEC) + listen() sets
SOCK_RCU_FREE, the reference is leaked.

Freeze the decision at assign time. If the socket is refcounted (i.e. can
become non-refcounted), take a reference and set sock_pfree_refcounted()
as the destructor; otherwise stick with sock_pfree(), which effectively
becomes a no-op destructor. Next, extend skb_sk_is_prefetched() to handle
both dtors and, for the sake of CONFIG_INET=n, add a specialized
skb_sk_is_prefetched_noref(). Adapt prefetched-skb treatment in
__nf_queue() and skb_steal_sock(). The latter changes its contract with
callers: inet{,6}_steal_sock() must now expect a refcounted TCP_LISTEN
socket.

Fixes: 7ae215d23c12 ("bpf: Don't refcount LISTEN sockets in sk_assign()")
Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 include/net/inet6_hashtables.h |  9 +++++----
 include/net/inet_hashtables.h  |  9 +++++----
 include/net/request_sock.h     |  2 +-
 include/net/sock.h             | 11 +++++++++++
 net/core/filter.c              | 19 ++++++++++++++++---
 net/netfilter/nf_queue.c       | 18 +++++++++---------
 6 files changed, 47 insertions(+), 21 deletions(-)

diff --git a/include/net/inet6_hashtables.h b/include/net/inet6_hashtables.h
index 2cc5d416bbb5..a310cb91611c 100644
--- a/include/net/inet6_hashtables.h
+++ b/include/net/inet6_hashtables.h
@@ -134,10 +134,11 @@ struct sock *inet6_steal_sock(struct net *net, struct sk_buff *skb, int doff,
 	if (!reuse_sk)
 		return sk;
 
-	/* We've chosen a new reuseport sock which is never refcounted. This
-	 * implies that sk also isn't refcounted.
-	 */
-	WARN_ON_ONCE(*refcounted);
+	/* New reuseport sock is never refcounted; drop the old sk's ref. */
+	if (*refcounted) {
+		sock_put(sk);
+		*refcounted = false;
+	}
 
 	return reuse_sk;
 }
diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 6e2fe186d0dc..1589e9e7ecb2 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -474,10 +474,11 @@ struct sock *inet_steal_sock(struct net *net, struct sk_buff *skb, int doff,
 	if (!reuse_sk)
 		return sk;
 
-	/* We've chosen a new reuseport sock which is never refcounted. This
-	 * implies that sk also isn't refcounted.
-	 */
-	WARN_ON_ONCE(*refcounted);
+	/* New reuseport sock is never refcounted; drop the old sk's ref. */
+	if (*refcounted) {
+		sock_put(sk);
+		*refcounted = false;
+	}
 
 	return reuse_sk;
 }
diff --git a/include/net/request_sock.h b/include/net/request_sock.h
index 5a9c826a7092..3fb114fa77de 100644
--- a/include/net/request_sock.h
+++ b/include/net/request_sock.h
@@ -113,7 +113,7 @@ static inline struct sock *skb_steal_sock(struct sk_buff *skb,
 			return sk;
 		}
 #endif
-		*refcounted = sk_is_refcounted(sk);
+		*refcounted = !skb_sk_is_prefetched_noref(skb);
 	} else {
 		*refcounted = true;
 	}
diff --git a/include/net/sock.h b/include/net/sock.h
index 51185222aac2..fb553697db83 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1870,6 +1870,7 @@ void sock_efree(struct sk_buff *skb);
 #ifdef CONFIG_INET
 void sock_edemux(struct sk_buff *skb);
 void sock_pfree(struct sk_buff *skb);
+void sock_pfree_refcounted(struct sk_buff *skb);
 
 static inline void skb_set_owner_edemux(struct sk_buff *skb, struct sock *sk)
 {
@@ -3015,6 +3016,16 @@ static inline void sk_eat_skb(struct sock *sk, struct sk_buff *skb)
 static inline bool
 skb_sk_is_prefetched(struct sk_buff *skb)
 {
+#ifdef CONFIG_INET
+	return skb->destructor == sock_pfree ||
+	       skb->destructor == sock_pfree_refcounted;
+#else
+	return false;
+#endif /* CONFIG_INET */
+}
+
+static inline bool skb_sk_is_prefetched_noref(struct sk_buff *skb)
+{
 #ifdef CONFIG_INET
 	return skb->destructor == sock_pfree;
 #else
diff --git a/net/core/filter.c b/net/core/filter.c
index 66d83a198ea2..e473ad8c9b3c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7989,8 +7989,20 @@ static const struct bpf_func_proto bpf_tcp_gen_syncookie_proto = {
 	.arg5_type	= ARG_MEM_SIZE,
 };
 
+/*
+ * skb destructor set by TC bpf_sk_assign(), refcounted path only.
+ * Acts as a "prefetched by bpf, ref taken" marker.
+ */
+void sock_pfree_refcounted(struct sk_buff *skb)
+{
+	sock_gen_put(skb->sk);
+}
+EXPORT_SYMBOL(sock_pfree_refcounted);
+
 BPF_CALL_3(bpf_sk_assign, struct sk_buff *, skb, struct sock *, sk, u64, flags)
 {
+	bool refcounted;
+
 	if (!sk || flags != 0)
 		return -EINVAL;
 	if (!skb_at_tc_ingress(skb))
@@ -7999,13 +8011,14 @@ BPF_CALL_3(bpf_sk_assign, struct sk_buff *, skb, struct sock *, sk, u64, flags)
 		return -ENETUNREACH;
 	if (sk_unhashed(sk))
 		return -EOPNOTSUPP;
-	if (sk_is_refcounted(sk) &&
-	    unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
+
+	refcounted = sk_is_refcounted(sk);
+	if (refcounted && unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
 		return -ENOENT;
 
 	skb_orphan(skb);
 	skb->sk = sk;
-	skb->destructor = sock_pfree;
+	skb->destructor = refcounted ? sock_pfree_refcounted : sock_pfree;
 
 	return 0;
 }
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 73363ceedebe..e2e9739c00ac 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -195,16 +195,16 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 		break;
 	}
 
-	if (skb_sk_is_prefetched(skb)) {
-		struct sock *sk = skb->sk;
-
-		if (!sk_is_refcounted(sk)) {
-			if (!refcount_inc_not_zero(&sk->sk_refcnt))
-				return -ENOTCONN;
+	/*
+	 * If the skb was prefetched without taking sock's ref, bump it.
+	 * Skip sock_pfree-dtor'ed skbs coming from bpf_sk_assign_tcp_reqsk().
+	 */
+	if (skb_sk_is_prefetched_noref(skb) && sk_fullsock(skb->sk)) {
+		if (!refcount_inc_not_zero(&skb->sk->sk_refcnt))
+			return -ENOTCONN;
 
-			/* drop refcount on skb_orphan */
-			skb->destructor = sock_edemux;
-		}
+		/* drop refcount on skb_orphan */
+		skb->destructor = sock_edemux;
 	}
 
 	entry = kmalloc(sizeof(*entry) + route_key_size, GFP_ATOMIC);

-- 
2.55.0

