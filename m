Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794391943;
	b=Ie91lv2+LeGCfvFnQGdRPPFaqcchditD2XOD6JoQpV2XUDv9+NbJ7tu0yCrTSpwu1jgZ
	 ieqWF3Q283JC82oXXTwahr/OcgziElCz1bHUeyoP4X2/i2aAULv8S+kPCQfzLmA4U7fO4
	 oAoKB3IrwX/Ozt6ur1xKloqEeUoy91REvjju2nGK/SYiSDMLsAyE8a84edmTgZbgSPdvT
	 L8y4avXthNOzakEnK8la4In42aMCXWD5Vnu8tS9ycOdPPLklVsJki6WVtSZ6lblCt9ikG
	 hbtbphMAe4FFP2vzzrkBnnLfMnVdgMILFU9ITng8OsdY/K5G6A/n5MN9iMGFIkGB6zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794391943;
	h=DMARC-Filter:Received:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=CoZQFs3oyNgwraZR0IIJss0jx5bPEcLDwkpfRz0EBLI=;
	b=v5wikk+EXTPKvuQ9NkXaG7ZBzMXS/xVFiBp6PB8SsB7lEtljrfc0Z6n9t5uGFZVvkJMP
	 Pdds71N5tBHamwH/1xkwrwGwDHVHpbrFEyOcLAmZPo1eT5Xc++ZjfzrQ0FbS7HXBIYqSh
	 ts4Q7GAO7ORVx1vQUYc2E0/w+4Qsl2Yl7Q6haqMFGoEr7HLQrrdH0ir9+qFlcw8pCP+Oe
	 sBDTr+9khNwcsjo3nzuC6JHxagMrm/ckDWMric3/oqkqQYLiulVvEOe/lujiWYGKs92Uv
	 FXd7ltbSNJn3kS8m7Xmcb3hgNAOdvaM7LWwdRzfBSCplLRek08ggbQg1QuFbiXuNyAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9D6606A326
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2026 10:12:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E9D6606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A99216060B; Wed, 11 Nov 2026 11:12:21 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v8 4/6] netfilter: ipset: also report mem size for cidr storage to userspace
Date: Wed, 11 Nov 2026 11:11:55 +0100
Message-ID: <20261111101157.22270-5-fw@strlen.de>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261111101157.22270-1-fw@strlen.de>
References: <20261111101157.22270-1-fw@strlen.de>
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

After the 'Fixes' commit, the storage is allocated dynamically.
Include this when reporting the mem usage.

Fixes: 8e5fd2a55e24 ("netfilter: ipset: rework cidr bookkeeping")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 No changes.
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
2.56.0

