Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882757;
	b=LgMx3jN/bR5zc4fHiErvRGAaXUt713n9/QuzCNRDMfgRMHpuEWgEfr3h7vLaSN80NCWq
	 t18YpNbzi9X/kZeSZltMI78RN2HxQMCIHekBjbgYhqUECEukDlSmoUaaeAcqjTKmwIBo7
	 eqiOMXbd2qUPXoZ5r1wEnEdRkOO9dWXxj4yygWhPoAZKOhRQA7flovA91e4eGOBJXxWmt
	 jwvnRMIlNIdqqUXG6pFyvuyJ8mrqYhp76QOeXsEq9mFAtfvU6N2qVvYUuHyiX7rpS9y/l
	 4cJJZyi8gytfQAd5Equt3Ep8YrpCJpenkTpMO4HGm4qAsqemyT/UGDTUaL4FY60rqfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882757;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=0GlfH3e3DvVlPjKTJC55ueYHxXbJqUklbkL29/+8PgM=;
	b=gEkmHKZgpHX1wns3426NYfGl7RA8FHbuhN9Ru5jMy5ZvOLfoiw2KbpJ9Vba8Swap682B
	 OsOE4o1IJnb224ZdhEiDPQmDga1kkeJDyDrt4zQiiBEjnf+Oc2ybnTqTveAJkyxSZidR5
	 XYbPbDezylTB4X+HV+2RBQRfMOw0yTkb1ZeVzPtJDUWanlJ0lVyTNmvEkNAeS8TLZEBXG
	 cspF6hdeVb/5ys9DuyNnU1/gJ3mgzmUpnNZtqU8pnZ5Zk3m59aLhU9uzTjWbyJXKMTiSa
	 i/VE0h/QfHU1Qh9iQBPEjLIwUFSvDng5LiW38GVgdHFv3hSTCAydrXefTUDu4c+Le2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=QB2MCrNL;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F6A606EEAE;
	Thu,  5 Nov 2026 12:45:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42F6A606EEAE
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=QB2MCrNL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793882755;
	bh=0GlfH3e3DvVlPjKTJC55ueYHxXbJqUklbkL29/+8PgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QB2MCrNL5E+DeADD7tq0SR8sB8YlNxMCcf7Epz5cXpXWw6OPri1BHLpwV4FEgftEy
	 vqqmkaLRtpNERZeit7pySxndHNT2rD5HFQn07eob7gVE1K5aUOa1LrgkM4OHdNGiEf
	 bQDtP63ZSLF7fBUyyR8znwPLdPeNSxWvrrRkkp3FRB7vb7AyLbZrbeR3Q8dwFVJ6tp
	 DaG+HvDTC17vwE/mj5RbVnCYehxoD/MJHq0vrNr698Eg8LetuDbdK2qpHxscQOhggX
	 5TeHHuQBp2jHr3lgxrL8H44hV8OjDkn6v2cBxSPeBLaew8YGs1w2/e5O9+xRsphTZa
	 Ymbvt7aX22fmg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EFBF460082;
	Thu,  5 Nov 2026 13:45:54 +0100 (CET)
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
Subject: [PATCH net 12/12] netfilter: nat: zero newrange before filling it in
Date: Thu,  5 Nov 2026 13:45:36 +0100
Message-ID: <20261105124536.1009301-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261105124536.1009301-1-pablo@netfilter.org>
References: <20261105124536.1009301-1-pablo@netfilter.org>
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

