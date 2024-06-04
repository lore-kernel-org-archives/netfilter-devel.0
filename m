Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236471487DD;
	Tue,  4 Jun 2024 15:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717515894; cv=none; b=XYSof/ZcWX4h4WEY1m1x3Kmgic5M26Y9BgSSG887j9NG/nrlnOkP+MYzVf85IdOO7ypnHZxPS535N+sfcrGKcemE+QN5Q8orpRl5wz6hBEi1gTiKB0DrlRLshpONdUCEdhxoxoENWQwZYijiJb04iGZDAwYnSiWcfTlnubPY7yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717515894; c=relaxed/simple;
	bh=3tHIwdbnjoTNL6ML5KnhjhEyimnnTQ36tmq4mQnwqVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nujNKUWrSZ5M3B0baDZZqw93uEEbYQUEsWgW+5q9R2aLf2b0bmwjV8tHqQSWiHPByWEZBZmafazMOMEaJuk3LA2oz/Iee2YaQLFs8x7Lnf3DIieHeI5oXqEDvagLrkV2pnr3Y82e1WWZ3Qd/Nx2EdnIWerSeq7q3YnmQQOtC718=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=ZpWmVHEr; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=7LV7zmsm; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="ZpWmVHEr";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="7LV7zmsm"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1717515889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1zGFUh5BIokNXo1khBHVCTilWjLuFPEXOImnZTfvdCg=;
	b=ZpWmVHErbJYFgaXZ51awhGMxW8APDMPsVj677mOUaCG53w6WpXDDtD782NFgN/9poB5o/9
	v8wyjjXhdoUVLXFpxZRCpGumG0gUmiJXArOSk0WR4dZPJ8FSPZpnPn+etwGCxEbBR0M2hZ
	jHdycZZdQIcwsDEpihBvWw+0YGieWALV0mpMi75xtJg04BclQhlq1lJeCr/MrForbC0ysz
	BUfaF2EvwiGSXmSFVmKuGtZ3W3TK5Tp3CdwdL4XPFYV+Ixa/v235KMB+bPjxBkBx8f9LBF
	KLso4ewxszNNc2GVpObSgXHryCla2dPlAiUtTYHnXje1C4tl/zTzKY4aAQpNyA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1717515889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1zGFUh5BIokNXo1khBHVCTilWjLuFPEXOImnZTfvdCg=;
	b=7LV7zmsmr6KTon9MNuUio70Erb1OBJPxeXiLPV4HpBhHg+kUbmieawZ6/D437xV4pBbr4t
	maPCCVw7KfTbEnBQ==
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
Subject: [PATCH v4 net-next 06/14] netfilter: br_netfilter: Use nested-BH locking for brnf_frag_data_storage.
Date: Tue,  4 Jun 2024 17:24:13 +0200
Message-ID: <20240604154425.878636-7-bigeasy@linutronix.de>
In-Reply-To: <20240604154425.878636-1-bigeasy@linutronix.de>
References: <20240604154425.878636-1-bigeasy@linutronix.de>
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
 net/bridge/br_netfilter_hooks.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hook=
s.c
index bf30c50b56895..9596ad19224ad 100644
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
@@ -882,6 +885,7 @@ static int br_nf_dev_queue_xmit(struct net *net, struct=
 sock *sk, struct sk_buff
=20
 		IPCB(skb)->frag_max_size =3D nf_bridge->frag_max_size;
=20
+		guard(local_lock_nested_bh)(&brnf_frag_data_storage.bh_lock);
 		data =3D this_cpu_ptr(&brnf_frag_data_storage);
=20
 		if (skb_vlan_tag_present(skb)) {
@@ -909,6 +913,7 @@ static int br_nf_dev_queue_xmit(struct net *net, struct=
 sock *sk, struct sk_buff
=20
 		IP6CB(skb)->frag_max_size =3D nf_bridge->frag_max_size;
=20
+		guard(local_lock_nested_bh)(&brnf_frag_data_storage.bh_lock);
 		data =3D this_cpu_ptr(&brnf_frag_data_storage);
 		data->encap_size =3D nf_bridge_encap_header_len(skb);
 		data->size =3D ETH_HLEN + data->encap_size;
--=20
2.45.1

