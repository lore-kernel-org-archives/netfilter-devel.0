Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442136;
	b=VD/HlBBq5YPkiFj3iwGfW2qI7KnikcatfUP2n+j5VSLQnrPTQAXrtiqdTssIVDAEisPd
	 8OZnTHE7TeR4UStQlyaQg0lfGbqd3Gm6Fdk+6fPRQFRD+ewc+ejHWVbcjWKotSf86kz5G
	 dNpnDSQG37a7SY9UOfdzbE2DVKvxE9ddDDQLuZ8+nHKTwdyZDdGVRcMHGSw6HvyKqgM+A
	 l0GgkjnayCkd0pg7b9N6Z03f7ha4+UHqMZDp7zQeQB9DtFWjRp3rtZKpo+pGXdvMZiITb
	 FTw7H2v/NUpirVP9BYljn7gdS4DABC2O3j/dBrSXYsvzZNUDIjYHvAyLMNzzXPnGcWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442136;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=myUGGX+F6ZcHO7a3JIENspm3MjUjgJGi7zSbu1RcHZA=;
	b=TqwGpYAEHmuAmUI3FUErStUVOh14PSoA76/vQI+M/BG4UJAOLf/euxDnxT/JDKS+x3HB
	 p4NR2vgyNMlMA9TiVN23gTnpwMJMShKQdWFDq2tJOLU5QKFt17WgVwUKOFdbZwF9sABny
	 NWRThd4PvAuJLINqTlZL7yHsHr1POcb8lVrJ3VPivcKQIKDaH8mwTbp9on9+8jpMKCZQd
	 CYjPcnTDKmCD6cJJ/RCBSbTivxSHWS5QEoQARzXjUjOaKdy6C1fEXWcN9GTan4cuyFU6U
	 +HMYpi4RbStPQ58+5ldGSFVhFgkVgN3A0dqsiIHcQglixc0J6aqHII/dbz3dSSBlEMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=aYivypBR;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4A0606A331;
	Mon, 23 Nov 2026 13:55:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE4A0606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=aYivypBR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795442133;
	bh=myUGGX+F6ZcHO7a3JIENspm3MjUjgJGi7zSbu1RcHZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aYivypBRUyG/NyUG7QPnC/rf/rCeeyH+tZe+915Q13McLJ6HLt0viXwVzF+ECNbdK
	 99ERSnKJMHOWSvAKcID2A9QBHvxLJWlUXrUeGLrUu+e9ufvW8VHb5tatj/js8tSXXy
	 /pL8kEFDdYj5I8umihtE+e7ouvuT2d06PXoAaX+FNpYSHYA22sBgwlGbkCNRrXlAhL
	 CuiMfA4zpC3WUqDtkpjTwjIY9+29GEOssUUgaHHqOeWcWr8d3ySRKW9YDgweNa+aiD
	 MTai7SckwcJ+DA2/p7p310g8mzylN/fhKGkd21KfySETRaoAzVx98MVtjFTT1SxINJ
	 ooqiwXVqJeSig==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3A789602D6;
	Mon, 23 Nov 2026 14:55:33 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 13/15] netfilter: ipset: also report mem size for cidr storage to userspace
Date: Mon, 23 Nov 2026 14:54:40 +0100
Message-ID: <20261123135442.3940372-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123135442.3940372-1-pablo@netfilter.org>
References: <20261123135442.3940372-1-pablo@netfilter.org>
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

From: Florian Westphal <fw@strlen.de>

After the 'Fixes' commit, the storage is allocated dynamically.
Include this when reporting the mem usage.

Fixes: 8e5fd2a55e24 ("netfilter: ipset: rework cidr bookkeeping")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 8ac1b0f04856..e7f2e584a7a5 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -616,6 +616,23 @@ mtype_rht_size(struct ip_set *set, u32 *elements, size_t *ext_size)
 	*elements = ipset_hash_nelems(h);
 	*ext_size = *elements *
 		    (offsetof(struct mtype_rht_elem, elem) + set->dsize);
+
+#ifdef IP_SET_HASH_WITH_NETS
+	{
+		const struct net_prefixes *nets;
+		int i;
+
+		rcu_read_lock();
+
+		for (i = 0; i < IPSET_NET_COUNT; i++) {
+			nets = rcu_dereference(h->rnets[i]);
+			if (nets)
+				*ext_size += ksize(nets);
+		}
+
+		rcu_read_unlock();
+	}
+#endif
 }
 
 /**
-- 
2.47.3

