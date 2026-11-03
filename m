Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714620;
	b=S/pFmxGMolRskylh495WUohbHqQkxSFqdLn7d3KUMgifPbICBgccdN8A6C4pFVsWu8Vt
	 ShODQ5TNBrJVSAd57EbOEWGAx1bYvliNFUnEzUNC5Oq/DxkCe2XqvPWHmjhXs2PNbiUD0
	 McC2/UfbCX/2nM7A4xqzLOtwgiifNrocvu6yvmi0Gi/p5nPB8b3ON3anb5/3jwMWVhkv/
	 HaVLui7ii8+2fpZvW5dYJLz3Bojxr9NHTYKG3ErERPSn4rwhOsLYquPgE+E1I1cc3eCZN
	 PO/fuPcg7W/gvJrg779czXcmRqOOdWby/mk7eCsttMp+FyJk9aQFsUqjBKpOMvwrfXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714620;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=0GlfH3e3DvVlPjKTJC55ueYHxXbJqUklbkL29/+8PgM=;
	b=0zc0cxiJLJXpHSSxK0BwzLC4UbfcRjMRzUF9fyauDpBtqsPMH/69ZeeUWC7FU2Qp0vGP
	 HgEPdZyOTASt98LPHCqGwgH8D3o3NF1gAZgB6Vq+K/q9oqQXHt9zGey+fDqeFWVd9aS1M
	 lmTANuqi4QCU3y8jIYkojimSUA0np4efGOvVS7uQVrU2ky5B7oUqzkAK8yJ6phKIKkjR2
	 biJFIUKoXErSCMq3/vI6M1cUEDY2unNzlDd9NjxvxO5VxI+4mljlRkBO6q0x2RNOXilkI
	 O31qJQVLzWgHHZKUYJHqq+Zqk38lTtpXkNA9nNpIsTiCWP33t3L7yO4ryCvwziJpzIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=uW92qSy0;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7B660A6F6A;
	Tue,  3 Nov 2026 14:03:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A7B660A6F6A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=uW92qSy0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793714618;
	bh=0GlfH3e3DvVlPjKTJC55ueYHxXbJqUklbkL29/+8PgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uW92qSy0Uzf3U37x5MgSo6gs+ViHZZh0rMKcFWDw5C4nwxV21PDYNd9qXBZ1QknWZ
	 1NBFfccLFKa4s9e+oPpAA5xMAWuo0pRJhwrhfjVPFOr1BnzGYnfAfpgSCu2mrzk8tf
	 LvoSNcbw1vqJnHjRdB97Y72wpX/du6jLCJVy+PHb5Jj25FSkNLua4qk3TsULNE1abT
	 YMdvdvvhUojDUhZLGL9afUBp0fH6EZTus0pB8ohPQnF39oT7lfYAsfm48/4eykwMqn
	 c8+5sZpBCnrzRii36mfSkbu8kW9Cty4ETlwoP4HlFx+zkLPeVmJ7xiT+drIaes1lbK
	 sqBJwMGxV1RIQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7EF6460090;
	Tue,  3 Nov 2026 15:03:37 +0100 (CET)
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
Subject: [PATCH net 15/15] netfilter: nat: zero newrange before filling it in
Date: Tue,  3 Nov 2026 15:03:08 +0100
Message-ID: <20261103140308.591690-17-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261103140308.591690-1-pablo@netfilter.org>
References: <20261103140308.591690-1-pablo@netfilter.org>
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

nf_nat_masquerade_ipv4(), nf_nat_masquerade_ipv6(), netmap_tg4() and
netmap_tg6() each build a stack-local struct nf_nat_range2 from the
caller-supplied range, inheriting range->flags unmodified. Two of them
only memset() the min_addr/max_addr members, the other two don't
memset() anything at all, so newrange.base_proto is left as stack
garbage.

If the inherited flags include NF_NAT_RANGE_PROTO_OFFSET,
nf_nat_l4proto_unique_tuple() reads range->base_proto.all to compute
the NAT port offset. Neither the NETMAP nor the MASQUERADE targets
mask the flags field in their checkentry callback, so this
uninitialized stack value can end up feeding the NAT port selection.

The per-member memset()s are not enough: they have to enumerate every
field that must be cleared, and base_proto was missed when
NF_NAT_RANGE_PROTO_OFFSET/base_proto was added to the struct. memset()
the whole struct instead, so every member is covered regardless of
which ones get explicitly assigned afterwards.

There are other places that miss this, but those hardcode .flags so
nat core won't read from the uninitialized fields.

C99 initializers would be preferrable, but this is a more intrusive
change.  Lets followup in nf-next and convert others as well.

This is an LLM finding.

Fixes: 2eb0f624b709 ("netfilter: add NAT support for shifted portmap ranges")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_masquerade.c | 4 ++--
 net/netfilter/xt_NETMAP.c         | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_nat_masquerade.c b/net/netfilter/nf_nat_masquerade.c
index 4de6e0a51701..c2a85bd84af1 100644
--- a/net/netfilter/nf_nat_masquerade.c
+++ b/net/netfilter/nf_nat_masquerade.c
@@ -62,8 +62,7 @@ nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int hooknum,
 		nat->masq_index = out->ifindex;
 
 	/* Transfer from original range. */
-	memset(&newrange.min_addr, 0, sizeof(newrange.min_addr));
-	memset(&newrange.max_addr, 0, sizeof(newrange.max_addr));
+	memset(&newrange, 0, sizeof(newrange));
 	newrange.flags       = range->flags | NF_NAT_RANGE_MAP_IPS;
 	newrange.min_addr.ip = newsrc;
 	newrange.max_addr.ip = newsrc;
@@ -242,6 +241,7 @@ nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 	if (nat)
 		nat->masq_index = out->ifindex;
 
+	memset(&newrange, 0, sizeof(newrange));
 	newrange.flags		= range->flags | NF_NAT_RANGE_MAP_IPS;
 	newrange.min_addr.in6	= src;
 	newrange.max_addr.in6	= src;
diff --git a/net/netfilter/xt_NETMAP.c b/net/netfilter/xt_NETMAP.c
index 7da065a472e0..8bcb3f716d68 100644
--- a/net/netfilter/xt_NETMAP.c
+++ b/net/netfilter/xt_NETMAP.c
@@ -44,6 +44,7 @@ netmap_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 				   netmask.ip6[i];
 	}
 
+	memset(&newrange, 0, sizeof(newrange));
 	newrange.flags	= range->flags | NF_NAT_RANGE_MAP_IPS;
 	newrange.min_addr	= new_addr;
 	newrange.max_addr	= new_addr;
@@ -91,8 +92,7 @@ netmap_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 		new_ip = ip_hdr(skb)->saddr & ~netmask;
 	new_ip |= mr->range[0].min_ip & netmask;
 
-	memset(&newrange.min_addr, 0, sizeof(newrange.min_addr));
-	memset(&newrange.max_addr, 0, sizeof(newrange.max_addr));
+	memset(&newrange, 0, sizeof(newrange));
 	newrange.flags	     = mr->range[0].flags | NF_NAT_RANGE_MAP_IPS;
 	newrange.min_addr.ip = new_ip;
 	newrange.max_addr.ip = new_ip;
-- 
2.47.3

