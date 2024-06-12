Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E0118306E;
	Wed, 12 Jun 2024 17:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718211806; cv=none; b=G+yyE8Zd46i++Bk3ZGe9PyqKE+IxVKeE7+sRf2Wub+d8q3n4CjM8UyN1eZyi5X8o7h2/DCcnLI455GOiAnX/HSg3BizEEjrVMLFP6hy35gIr+NBPipn989AjSFkpOnmOImM6jCbhYzcCHa3kBxw0fWqGtPsBxRnVA++f4sjZedo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718211806; c=relaxed/simple;
	bh=oi4DoqovsixUFRVfCzGtZa5ipaDq/Cpe3T13qBLJFIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NDKuuQY/dRvxMKJoSDk083QSVrWSOAqfydveMpiVFB3t50v6PKoUc+3OYcIHkHujK6mxwVAZ5/tdemGZYVT6NUu/dhfZX2O/J12BHi93+mNPohtJ0bd6Q23ERxM90C7LZIgLzM1RidGj3rRc0YSzZHufxsVng5m6fd2MfZggcxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Siy0ObRH; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=hihM1Fw4; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Siy0ObRH";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="hihM1Fw4"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1718211796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ANCKiEga5l1DBuytNTefl4llHnehnchG20Prvletyy0=;
	b=Siy0ObRHyiZlsKgPWqH2npCxTKzawOsVMHoEsH6xJVdKfjKK8dzcw4FreagOxRjy43x6P0
	8fwYkhxryOPG2p4CSnD2TNVNyFXVZJzS8l+ihyqtstdh1381IVhxkfztmEWB/o1tz/8tCd
	ca7C3P9Ylb1ZiYYX5cBceCkiQHMvwiyqib79nA9LalVLjEcn4k06J1xVwI+3/lwwBYImzg
	zscSCJ8HCez14HkTk4I2of8v0Y7WdqGsq65MVTCGkm63rbgDYlL36Wt1Fl0iY0gsOPzEEC
	EqlenJrfmSCwtw7YHTqI/2xrCQK0FkeByhZEG6WaSEgGFdYesWQ+lBppfRSHtw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1718211796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ANCKiEga5l1DBuytNTefl4llHnehnchG20Prvletyy0=;
	b=hihM1Fw4tir6rVnfGwTAOzCnWXgNk3QLIgagNy9Sbl2aB8g9D9U3KtUxj8MLy9rgQuHE5j
	sEtd2PkaOJdhP6Dw==
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
Subject: [PATCH v6 net-next 07/15] netfilter: br_netfilter: Use nested-BH locking for brnf_frag_data_storage.
Date: Wed, 12 Jun 2024 18:44:33 +0200
Message-ID: <20240612170303.3896084-8-bigeasy@linutronix.de>
In-Reply-To: <20240612170303.3896084-1-bigeasy@linutronix.de>
References: <20240612170303.3896084-1-bigeasy@linutronix.de>
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
2.45.1

