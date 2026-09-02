Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A11E4AA03D;
	Wed,  2 Sep 2026 18:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788374306; cv=none; b=pBspnKGYIP3v0+MIq+FRO7InbFmsReCr7NGbtQt9KMnjO0C63Ww3viaobrEUD5s96QkRDH3luLisAcmOvGPlwPaqg26dwrTpXbaUus95ujdl7OMeg6LNvOUB1KPMNtKJ59vjKDuLsZssZKnmSXHB3Q5qO11jJZkTM37uo7Y+PyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788374306; c=relaxed/simple;
	bh=IZhshA9fZOyRiYER+gWCvb7sLy6FkkdGhrHLrnkEMAw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nYNPFDnJGboR06t6mMNVllT/e/gxIaPYzVsW9gkJQVopAEZFHZ4A9qCtNvs59THv1yz4xJgo5BBvfQLQU/kvdvjLtNzNf/OkYcc7ViZjJNzfRArt4jFDn6Nr8pL0aLzuiva+96202lNpGmMM1WLdM8NeSReYKKsUPIOwAoLJVSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co; spf=pass smtp.mailfrom=rbox.co; dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b=JmDIxZIs; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rbox.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rbox.co
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rbox.co header.i=@rbox.co header.b="JmDIxZIs"
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <mhal@rbox.co>)
	id 1x1pAy-00Apwr-UQ; Wed, 02 Sep 2026 19:55:08 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
	s=selector2; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From;
	bh=FXFCe6ONM3mltyRpMuaa6tup/eZ+1813+oHLpm8cwE0=; b=JmDIxZIsDfoI2xLAITZjj+02Xk
	cHjeyDOj3K3E3fL1Jw1PIAjNXtLuyKujLF7KyH6eO6FUQdpWym8qYRVKZ4kGvndiVXsSBBXdCAN2t
	jVKm9QLe8pQ+pAPIt9VCRf5J8IQkevrTM8glo3H++fd3HPtTuMobI/lZbw+gtbAqN981FIxcZ8GT+
	1b/tDZy8RuwI1amExLlEUNz8klWvQYcjY8Mq+f0cZ+XXNW6y5bQUd5ezqlxVW9kau378iDxeogJg1
	e3A3bxIVof92hRGveKO3FBC789+anH+fBGzxfALreldg+kBtjV/OCCOH7AQBjwH9fnNiY2LFHuOp+
	kJOguvkA==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <mhal@rbox.co>)
	id 1x1pAx-0006J2-En; Wed, 02 Sep 2026 19:55:07 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.95)
	id 1x1pAj-0020Qt-Mt;
	Wed, 02 Sep 2026 19:54:53 +0200
From: Michal Luczaj <mhal@rbox.co>
Date: Wed, 02 Sep 2026 19:52:14 +0200
Subject: [PATCH bpf v3 1/2] bpf: Unconditionally take socket references in
 lookup helpers
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-sockmap-lookup-tcp-leak-v3-1-b998b3d49d07@rbox.co>
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
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.15.2

Lookup helpers gate the reference acquisition on sk_is_refcounted(), and
the release side re-evaluates the same check. An established socket can be
refcounted at acquire time and later gain SOCK_RCU_FREE via
connect(AF_UNSPEC) + listen() before release. The release re-check then
sees sk_is_refcounted() == false and skips the put, leaking the reference.

Make acquire and release unconditional and symmetric: always take a
reference, always put it. Adapt sk_select_reuseport(). Drop the
misplaced/outdated comment above __bpf_skc_lookup().

Fixes: 6acc9b432e67 ("bpf: Add helper to retrieve socket in BPF")
Fixes: 64d85290d79c ("bpf: Allow bpf_map_lookup_elem for SOCKMAP and SOCKHASH")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/bpf/20260701235552.2B0AA1F00A3F@smtp.kernel.org/
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
---
 net/core/filter.c   | 30 ++++++++++++++++++------------
 net/core/sock_map.c |  8 ++------
 2 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 61940e753552..66d83a198ea2 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7205,12 +7205,17 @@ static struct sock *sk_lookup(struct net *net, struct bpf_sock_tuple *tuple,
 		WARN_ONCE(1, "Found non-RCU, unreferenced socket!");
 		sk = NULL;
 	}
+
+	/*
+	 * Always take a reference, even if the lookup skipped one;
+	 * bpf_sk_release() always puts one.
+	 */
+	if (sk && !refcounted && !refcount_inc_not_zero(&sk->sk_refcnt))
+		sk = NULL;
+
 	return sk;
 }
 
-/* bpf_skc_lookup performs the core lookup for different types of sockets,
- * taking a reference on the socket if it doesn't have the flag SOCK_RCU_FREE.
- */
 static struct sock *
 __bpf_skc_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 		 struct net *caller_net, u32 ifindex, u8 proto, u64 netns_id,
@@ -7263,11 +7268,16 @@ bpf_sk_lookup_full_sk(struct sock *sk)
 	 */
 	if (sk2 != sk) {
 		sock_gen_put(sk);
-		/* Ensure there is no need to bump sk2 refcnt. */
 		if (unlikely(sk2 && !sock_flag(sk2, SOCK_RCU_FREE))) {
 			WARN_ONCE(1, "Found non-RCU, unreferenced socket!");
 			return NULL;
 		}
+		/*
+		 * sk2 is not refcounted, but take a reference anyway;
+		 * bpf_sk_release() puts.
+		 */
+		if (sk2 && !refcount_inc_not_zero(&sk2->sk_refcnt))
+			sk2 = NULL;
 		sk = sk2;
 	}
 
@@ -7448,7 +7458,7 @@ static const struct bpf_func_proto bpf_tc_sk_lookup_udp_proto = {
 
 BPF_CALL_1(bpf_sk_release, struct sock *, sk)
 {
-	if (sk && sk_is_refcounted(sk))
+	if (sk)
 		sock_gen_put(sk);
 	return 0;
 }
@@ -11736,11 +11746,13 @@ BPF_CALL_4(sk_select_reuseport, struct sk_reuseport_kern *, reuse_kern,
 	bool is_sockarray = map->map_type == BPF_MAP_TYPE_REUSEPORT_SOCKARRAY;
 	struct sock_reuseport *reuse;
 	struct sock *selected_sk;
-	int err;
+	int err = 0;
 
 	selected_sk = map->ops->map_lookup_elem(map, key);
 	if (!selected_sk)
 		return -ENOENT;
+	if (!is_sockarray)
+		sock_put(selected_sk);
 
 	reuse = rcu_dereference(selected_sk->sk_reuseport_cb);
 	if (!reuse) {
@@ -11770,13 +11782,7 @@ BPF_CALL_4(sk_select_reuseport, struct sk_reuseport_kern *, reuse_kern,
 	}
 
 	reuse_kern->selected_sk = selected_sk;
-
-	return 0;
 error:
-	/* Lookup in sock_map can return TCP ESTABLISHED sockets. */
-	if (sk_is_refcounted(selected_sk))
-		sock_put(selected_sk);
-
 	return err;
 }
 
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index ca49bc7f8687..ae18dc4d60f9 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -390,9 +390,7 @@ static void *sock_map_lookup(struct bpf_map *map, void *key)
 	struct sock *sk;
 
 	sk = __sock_map_lookup_elem(map, *(u32 *)key);
-	if (!sk)
-		return NULL;
-	if (sk_is_refcounted(sk))
+	if (sk)
 		sock_hold(sk);
 	return sk;
 }
@@ -1216,9 +1214,7 @@ static void *sock_hash_lookup(struct bpf_map *map, void *key)
 	struct sock *sk;
 
 	sk = __sock_hash_lookup_elem(map, key);
-	if (!sk)
-		return NULL;
-	if (sk_is_refcounted(sk))
+	if (sk)
 		sock_hold(sk);
 	return sk;
 }

-- 
2.55.0

