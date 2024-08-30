Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396C21BA86F;
	Fri, 30 Aug 2024 17:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725038591; cv=none; b=q3GHKA/dKsQL4r5P/1eo6Wh8ERLx8CgWypWig6y3TSv668t2UjEtDycRRs4EL/PvutFLjie0LgeLoUrDVqy9jjJ6bom2ptn19o/4n3T2LemvfGWMUTWTs5Yu6XhXMf2b8/UkMjtcAV6i9LD1dSEYHvV2m28Pi+W0r275NbijRdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725038591; c=relaxed/simple;
	bh=4GW2FIud5MLTjx7eYbpeqy1kb8YzrWkbY1gWNUIq+ts=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=d34rUTBCqiHT5im+424Ydzu+NzwRwHE4I3PXVrV6vZvQpn3Geg9cRGw11ziXtNwKqrJEhv2w/2ZRz4ClG++mIWWGpZEExafZaOEkmEswiXVWTjN76cICgLP3eeeeWULe9Nub994Fw8iE4P2NgvRZRnoeH39pPygSyNVM9rgI8gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TrocFJxs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TrocFJxs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313D5C4CEC4;
	Fri, 30 Aug 2024 17:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725038589;
	bh=4GW2FIud5MLTjx7eYbpeqy1kb8YzrWkbY1gWNUIq+ts=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=TrocFJxsEvzQmrxTtF24oZg0Yvs86jBS/iuLGbQoySgJeBedojdiQvvYMnvMj7rqQ
	 xa3iG4h2lARHLH3DHkGJdMq3NrhLjqLgaOqxHZEElI90qxL0YrSYFbz328B9+mk8HC
	 1zCFVngZ26NU5A6auwdSyEUADOBfYiDGisRm2CVpI+INM79bVr9vY97/r2ELEekjU6
	 1Bdthgz5Vdgeumu2DQwWg1XNM16VMun9NTR9Hg4NWzAuQeLvRvpUZuRJMw+8hFlmzM
	 vDQZEY5wK4wQSQ2PAUOxe2BYlxPt70WEHkS0WRczA6d4XKx6TfZx4OdfSV0GO/y+YS
	 evLZfs/weWA0w==
From: Simon Horman <horms@kernel.org>
Date: Fri, 30 Aug 2024 18:23:00 +0100
Subject: [PATCH nf-next 1/2] netfilter: nf_tables: Add missing Kernel doc
 to nf_tables.h
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240830-nf-kdoc-v1-1-b974bb701b61@kernel.org>
References: <20240830-nf-kdoc-v1-0-b974bb701b61@kernel.org>
In-Reply-To: <20240830-nf-kdoc-v1-0-b974bb701b61@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 netdev@vger.kernel.org
X-Mailer: b4 0.14.0

Add missing documentation of struct field and enum items.

Flagged by ./scripts/kernel-doc -none.

No functional change intended.
Compile tested only.

Signed-off-by: Simon Horman <horms@kernel.org>
---
 include/net/netfilter/nf_tables.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 1cc33d946d41..12ae0434ac93 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -209,6 +209,7 @@ static inline void nft_data_copy(u32 *dst, const struct nft_data *src,
  *	@family: protocol family
  *	@level: depth of the chains
  *	@report: notify via unicast netlink message
+ *	@reg_inited: bitmap of initialised registers
  */
 struct nft_ctx {
 	struct net			*net;
@@ -313,6 +314,7 @@ static inline void *nft_elem_priv_cast(const struct nft_elem_priv *priv)
 /**
  * enum nft_iter_type - nftables set iterator type
  *
+ * @NFT_ITER_UNSPEC: unspecified, to catch errors
  * @NFT_ITER_READ: read-only iteration over set elements
  * @NFT_ITER_UPDATE: iteration under mutex to update set element state
  */

-- 
2.45.2

