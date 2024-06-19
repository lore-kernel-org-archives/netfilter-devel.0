Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D9A78297;
	Wed, 19 Jun 2024 07:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718781808; cv=none; b=ZPMmzI7Z7LjpDgK+tlxRHbE1t0ff0W5dRoq9NqqD5vf63hj96WZGZCYVRJt6rPr1+gEEoM5cDz1MDfhVPiJuWRArykBqm2QjBXS/RAYRS53BOfASAfUL1PnqkjXr/arQE5szYkVsGz9PSDNCcuJXeYgFrn8iBAh+jJZ0dKqUI+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718781808; c=relaxed/simple;
	bh=hVYiIFL5HwJaYF05A9M5SqbFcZHu2+UJJv8+B5zsSCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m0VzJ04jt9tvHQjbXUHOJbxHyiq5Tk5yTn1lGVlJZy/RBHZJgo6W94kX48iCvYGHk7FP+QppiLikcLr2c/Ta2F7j8HHuVu47kmLW3iEWtY3Y0laW4uEW2+SVGxEi8JhQXEosBffu2MmVCPU3Y8OlPDWFPwY4pRWrbGFzCnwQpWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=rHWi6jze; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=A2F8Nccx; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="rHWi6jze";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="A2F8Nccx"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1718781803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7Fimo9A+L9/O8JEt6UHonD1Uw2oHXu2TNi4Wzvh1cs4=;
	b=rHWi6jzeSduKdw5K2csZbW18hEY8fMN2AO1O3RK7J7RUB7ke8pLVcbdFAK0fB+jVAHisVO
	hw0BaXdGatM/pJBqAcB7Y4wpzRKh7oOwx7CMzaT9B+aYKXhujSGij9GsBa2CLzAOn9z0eM
	ncSuz2/REAzWu/YDyTc3q+TSqGTLMuHoiMoM6JodlTbZgLjIdXw52LoTI2jBz5cjpQqhAa
	Y0PSXFLb2OOR9BWxoz6PrLw1xXUw+Ep/Gm+h9XeXR/kCTqZjLOuLxROSrkswVH8EvABjOA
	+XPDBEdY9ackc4qLSdGT5Y7FrTnbKUYV8Rm8cU8KHv57fsNNIPGiuHs5oqyXBg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1718781803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7Fimo9A+L9/O8JEt6UHonD1Uw2oHXu2TNi4Wzvh1cs4=;
	b=A2F8NccxsP65zzcG+jVF7k8I9pHqaXNC9tcB2sqQClkuy3T6z04rYbfQcjs1/6oWZxQyDU
	ZqmsIE7KpPwE7jBw==
To: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Daniel Bristot de Oliveira <bristot@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Eric Dumazet <edumazet@google.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Florian Westphal <fw@strlen.de>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Roopa Prabhu <roopa@nvidia.com>,
	bridge@lists.linux.dev,
	coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org
Subject: [PATCH v8 net-next 07/15] netfilter: br_netfilter: Use nested-BH locking for brnf_frag_data_storage.
Date: Wed, 19 Jun 2024 09:16:58 +0200
Message-ID: <20240619072253.504963-8-bigeasy@linutronix.de>
In-Reply-To: <20240619072253.504963-1-bigeasy@linutronix.de>
References: <20240619072253.504963-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

brnf_frag_data_storage is a per-CPU variable and relies on disabled BH
for its locking. Without per-CPU locking in local_bh_disable() on
PREEMPT_RT this data structure requires explicit locking.

Add a local_lock_t to the data structure and use local_lock_nested_bh()
for locking. This change adds only lockdep coverage and does not alter
the functional behaviour for !PREEMPT_RT.

Cc: Florian Westphal <fw@strlen.de>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Nikolay Aleksandrov <razor@blackwall.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Roopa Prabhu <roopa@nvidia.com>
Cc: bridge@lists.linux.dev
Cc: coreteam@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/bridge/br_netfilter_hooks.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hook=
s.c
index bf30c50b56895..3c9f6538990ea 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -137,6 +137,7 @@ static inline bool is_pppoe_ipv6(const struct sk_buff *=
skb,
 #define NF_BRIDGE_MAX_MAC_HEADER_LENGTH (PPPOE_SES_HLEN + ETH_HLEN)
=20
 struct brnf_frag_data {
+	local_lock_t bh_lock;
 	char mac[NF_BRIDGE_MAX_MAC_HEADER_LENGTH];
 	u8 encap_size;
 	u8 size;
@@ -144,7 +145,9 @@ struct brnf_frag_data {
 	__be16 vlan_proto;
 };
=20
-static DEFINE_PER_CPU(struct brnf_frag_data, brnf_frag_data_storage);
+static DEFINE_PER_CPU(struct brnf_frag_data, brnf_frag_data_storage) =3D {
+	.bh_lock =3D INIT_LOCAL_LOCK(bh_lock),
+};
=20
 static void nf_bridge_info_free(struct sk_buff *skb)
 {
@@ -850,6 +853,7 @@ static int br_nf_dev_queue_xmit(struct net *net, struct=
 sock *sk, struct sk_buff
 {
 	struct nf_bridge_info *nf_bridge =3D nf_bridge_info_get(skb);
 	unsigned int mtu, mtu_reserved;
+	int ret;
=20
 	mtu_reserved =3D nf_bridge_mtu_reduction(skb);
 	mtu =3D skb->dev->mtu;
@@ -882,6 +886,7 @@ static int br_nf_dev_queue_xmit(struct net *net, struct=
 sock *sk, struct sk_buff
=20
 		IPCB(skb)->frag_max_size =3D nf_bridge->frag_max_size;
=20
+		local_lock_nested_bh(&brnf_frag_data_storage.bh_lock);
 		data =3D this_cpu_ptr(&brnf_frag_data_storage);
=20
 		if (skb_vlan_tag_present(skb)) {
@@ -897,7 +902,9 @@ static int br_nf_dev_queue_xmit(struct net *net, struct=
 sock *sk, struct sk_buff
 		skb_copy_from_linear_data_offset(skb, -data->size, data->mac,
 						 data->size);
=20
-		return br_nf_ip_fragment(net, sk, skb, br_nf_push_frag_xmit);
+		ret =3D br_nf_ip_fragment(net, sk, skb, br_nf_push_frag_xmit);
+		local_unlock_nested_bh(&brnf_frag_data_storage.bh_lock);
+		return ret;
 	}
 	if (IS_ENABLED(CONFIG_NF_DEFRAG_IPV6) &&
 	    skb->protocol =3D=3D htons(ETH_P_IPV6)) {
@@ -909,6 +916,7 @@ static int br_nf_dev_queue_xmit(struct net *net, struct=
 sock *sk, struct sk_buff
=20
 		IP6CB(skb)->frag_max_size =3D nf_bridge->frag_max_size;
=20
+		local_lock_nested_bh(&brnf_frag_data_storage.bh_lock);
 		data =3D this_cpu_ptr(&brnf_frag_data_storage);
 		data->encap_size =3D nf_bridge_encap_header_len(skb);
 		data->size =3D ETH_HLEN + data->encap_size;
@@ -916,8 +924,12 @@ static int br_nf_dev_queue_xmit(struct net *net, struc=
t sock *sk, struct sk_buff
 		skb_copy_from_linear_data_offset(skb, -data->size, data->mac,
 						 data->size);
=20
-		if (v6ops)
-			return v6ops->fragment(net, sk, skb, br_nf_push_frag_xmit);
+		if (v6ops) {
+			ret =3D v6ops->fragment(net, sk, skb, br_nf_push_frag_xmit);
+			local_unlock_nested_bh(&brnf_frag_data_storage.bh_lock);
+			return ret;
+		}
+		local_unlock_nested_bh(&brnf_frag_data_storage.bh_lock);
=20
 		kfree_skb(skb);
 		return -EMSGSIZE;
--=20
2.45.2

