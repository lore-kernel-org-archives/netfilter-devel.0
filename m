Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159C241B358;
	Wed,  8 Jul 2026 14:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783519440; cv=none; b=UVcP0mSA6NtHcJGUcyU1k76ZOGe/xNRE+/ly3gUunultYCJEgumAv4RmA82cYaxe97t3QS/E42xtOJyGe5EQr134LYydqtLVoONToz8J8YYT9BsRW5GUYR9XYRmUthAi8nUgefVHVggRfQ8m/g8Ra2qG8D3RVzUT1+zDr71qR5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783519440; c=relaxed/simple;
	bh=GNkKpxB5B0ubW7+Mu5YOk8E45lf3Hv/rSf+8fitcvXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXDjRQ/sJAi3CPctC8NSL4ETzylUjXn1BDkAASfqYf+CdQVpmNFW/8KyzPx0yMSgkLmYoZyL9c/oEbl9iutj8B9JwYUabBSfR6OuOazTJUaNmEoO2Rxd8Wz5wFO6VNeYups3EANM1Az2B6uJa4w6bEYWZ74ejm/cAFtf69sqfw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9F2036076F; Wed, 08 Jul 2026 16:03:57 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 09/17] netfilter: ipset: allocate the proper memory for the generic hash structure
Date: Wed,  8 Jul 2026 16:03:01 +0200
Message-ID: <20260708140309.19633-10-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260708140309.19633-1-fw@strlen.de>
References: <20260708140309.19633-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jozsef Kadlecsik <kadlec@netfilter.org>

Because a single create function is emitted for every hash type,
from the IPv4 and IPv6 generic hash structure definitions the last
one, i.e. the IPv6 was in effect for IPv4 too. Use the proper size
when allocating the structure. Comment properly that because create()
refers to elements of the generic hash structure, all referred ones
must come before the IPv4/IPv6 dependent 'next' member.

Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index c0132d0f4cc0..8231317b0f1f 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -303,10 +303,13 @@ struct htype {
 	u8 netmask;		/* netmask value for subnets to store */
 	union nf_inet_addr bitmask;	/* stores bitmask */
 #endif
-	struct mtype_elem next; /* temporary storage for uadd */
 #ifdef IP_SET_HASH_WITH_NETS
 	struct net_prefixes nets[NLEN]; /* book-keeping of prefixes */
 #endif
+	/* Because 'next' is IPv4/IPv6 dependent, no elements of this
+	 * structure and referred in create() may come after 'next'.
+	 */
+	struct mtype_elem next; /* temporary storage for uadd */
 };
 
 /* ADD|DEL entries saved during resize */
@@ -1584,7 +1587,13 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 	if (tb[IPSET_ATTR_MAXELEM])
 		maxelem = ip_set_get_h32(tb[IPSET_ATTR_MAXELEM]);
 
-	hsize = sizeof(*h);
+#ifdef IP_SET_PROTO_UNDEF
+	hsize = sizeof(struct htype);
+#else
+	hsize = set->family == NFPROTO_IPV6 ?
+		sizeof(struct IPSET_TOKEN(HTYPE, 6)) :
+		sizeof(struct IPSET_TOKEN(HTYPE, 4));
+#endif
 	h = kzalloc(hsize, GFP_KERNEL);
 	if (!h)
 		return -ENOMEM;
-- 
2.54.0

