Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7714751A721
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Sep 2026 18:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788548044; cv=none; b=Mg2BnZRGrzDAirIVVJRcbCcITxqAfO6p35vWeNFak8br3/R353zE+jRT5NKjPtiPuapv9/cvAdy3ayN2/BwNfs0OWJKfbpCylu5t88PqrnrG5A5KbIp/dVpZXUT9A4JZPerp2MaIVvYn9nv8wAwX9xoyteFzgfE0FhZeRiJFofM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788548044; c=relaxed/simple;
	bh=lvhjYs1NJORSUZdeDy+eV4NJTFyu+xwGUu5rshxviwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iY5bM1bCNslk/C8TlRhlmdmSSaepClYr5x24cnBQ3vJnYn6tjOzrjsg0s/6LiTseuHEQfk3FG0CqxgjijDY09ON9RNRQEtafZ9Mhmn/983AF41TgmVaaTvoEHwHSLYMUL+dus7jseyrJOGIMrjXoNUEdI12iEgI9FK8mn3pAHgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4D2C06035B; Fri, 04 Sep 2026 20:53:59 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v4 06/13] netfilter: ipset: also report mem size for cidr storage to userspace
Date: Fri,  4 Sep 2026 20:53:14 +0200
Message-ID: <20260904185321.30313-7-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904185321.30313-1-fw@strlen.de>
References: <20260904185321.30313-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After the 'Fixes' commit, the storage is allocated dynamically.
Include this when reporting the mem usage.

Fixes: 8e5fd2a55e24 ("netfilter: ipset: rework cidr bookkeeping")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index ad190b2f8632..4d2e1e867606 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -641,6 +641,23 @@ mtype_rht_size(struct ip_set *set, u32 *elements, size_t *ext_size)
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
 
 static u32 mtype_remove_key(const void *data, u32 len, u32 seed)
-- 
2.55.0

