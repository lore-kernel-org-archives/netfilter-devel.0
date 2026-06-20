Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73DC347BD9;
	Sat, 20 Jun 2026 22:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781994477; cv=none; b=ludvWGlv/nJGIlET8LwoDQgAUsM9mWXZCYWxrNm6tnL7igci//eU6NCpt6D0Fl+7+F/unfy37MfDvemWwEmMz/lpfg0Er5xj1exqlNCoMms6iY7qAuwRJv3n4spqPkMx3Hv8vcfI5Lg5+oqYTgzgQi0RcvmhpUNbiLUFMBMQDyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781994477; c=relaxed/simple;
	bh=RsDaxyPuvOrBmPdJ6FVONCDxwowu3uBw/KYyrv/aet4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SzRGnQfqjoIPLeZRDSAJ6X6kKBmHfz7ThQaopr83KKdVsR0J1buAyCmYmuAFy5uMU47aL/ia+YS8KBckQVvq7okKMBK6FVhKb2pdaQ6tMS3sE0Ij/rbAXxG5ogNq7nE/YogPPR0GAVqr/gtrFHAknSlweRXACEfihNRTzYRcfuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jXsD8tNK; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jXsD8tNK"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EF64F60195;
	Sun, 21 Jun 2026 00:27:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781994475;
	bh=UBi8nAYVNxDOC9Fca/g+kEvutyyeLg3iui/uJTcXf3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jXsD8tNKLhkGaB5+PhkVY/suggDzRvj4ymkM0jt1I565Ib/rPPLsAMJ4gOhbRmRh7
	 HZU8XZnhXAoVKymSNobxETV7hrn+WfhQvMYS/QSc/R+y5FdeFf9v0BZs5UYD/5DahY
	 +XZDj2s9yUKO7ZidWP3ofIl82ebcqkL6qjzTOWASTltpQxJa6HUdN8RzbW0NBmsREI
	 jrxkD/GNxOol/mr7UCAlkPDdeGm+flqBJf/rVZRb7TSA6cn+Km/nC5+Z5mQr9gqtjl
	 /TOqGRDFIVRkkkSbYUMaSH2/RQQucKrbed1C91jYEpleJrdvuMbs2WKMUocz0A7Dea
	 XZNKzCDVOdWSg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 11/14] netfilter: nft_flow_offload: zero device address for non-ether case
Date: Sun, 21 Jun 2026 00:27:35 +0200
Message-ID: <20260620222738.112506-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260620222738.112506-1-pablo@netfilter.org>
References: <20260620222738.112506-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

LLM points out that the skip causes unitialised stack array to
propagate down into dev_fill_forward_path().  Its not clear to me that
there is a guarantee that a later ctx.dev->netdev_ops->ndo_fill_forward_path()
would always fix this up.

Cc: Felix Fietkau <nbd@nbd.name>
Fixes: 45ca3e61999e ("netfilter: nft_flow_offload: skip dst neigh lookup for ppp devices")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_path.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 1e7e216b9f89..98c03b487f52 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -53,8 +53,10 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
 	struct neighbour *n;
 	u8 nud_state;
 
-	if (!nft_is_valid_ether_device(dev))
+	if (!nft_is_valid_ether_device(dev)) {
+		eth_zero_addr(ha);
 		goto out;
+	}
 
 	n = dst_neigh_lookup(dst_cache, daddr);
 	if (!n)
-- 
2.47.3

