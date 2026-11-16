Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794788183;
	b=HSpvbPVxjVDk14pPKkrihYWZvejHzlpSHngQStMAykBXeEBLg/VaMuLC+r+3OT2T3SKk
	 BdmY59ttZX595oZBHOL6MRk0/EE4BtQiozTrihmGaV06RdHnd4W3WugFP0rKu+FcTA+ka
	 2e6hqJ1HDuLYTvb8C2bDm1fylo8qvoKu9wfHjpxoJ5PZeV/nmxRJn7Vyd7zp9EHqhBGxF
	 tQ2dD9OfldjM8pzlPoJsjH13PVPh+1SJs7DyobkTIMOr+r7VBOX8zk8Zymx3FhJWXNE2g
	 iwD8cc6V/oBJsC2SuQfy+Q75z+xqZA3E7Hm85f4PEha9fBazJCAGCM02DHIli/2qpFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794788183;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=MuZYn3povtzmoL5icif9wy6L5AGSAJTl5DCcEtuEppM=;
	b=3JZreIi2ZIe2cHa4Nv0oEj9BSw4v+/BvuoF/7mmeW0B4w4nPqO6lAKpj99n1926s9UTw
	 MgDFg9RXtNnkCK+gdADNRPKtpQxN74UAxZTRWPGrLf5H8vrcqHjZ+cfKtGDP1Du5W2D4k
	 rstkatCMWEf+lRPiOSRqW8x+ErnAv+Ow0py5cxcyg6aHcgsejLZ6r7M2DBlj8lz7te83d
	 W9VaT9J/WRyWVzeoEcFHo0WSobIsZfknAWgwSNRDo6X7YvqjT4aZ9iSt8e6Q1WwiuvvXG
	 aU/JtBRwe19aewm+8kLNsW1G7FFu7T8NnBY95PWTujkR0Nrju/e3MLDc2qOMnvH0JeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=AV7x67Hg;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08F4606A337;
	Mon, 16 Nov 2026 00:16:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B08F4606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=AV7x67Hg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794788180;
	bh=MuZYn3povtzmoL5icif9wy6L5AGSAJTl5DCcEtuEppM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AV7x67HgL97SY3UC47vJ3YbayltGlmsGcWxF19y8j+2xh2i2lGujYLHgNO0vN77EK
	 Iv6DWwLvDzpAMjJC4eh6eCDD4zHZ6NoPUFGf6zy42GUjBCt+7BSnUdibWQNkEyPfaw
	 fNd0kOFVUyqyuD14qBQ3vMWfI6znYVpYfyi1aOOKwdPgGe8ySJpXt97ClVI5IpszxK
	 a0n9e5DCGH3Gtbxca0Nvi2qYAAb0hi25QwmoiGCjXv0uwiPZUYPpcCQbwqAMiIL31P
	 Q3Qed8ddI3S3qeX6MQvcp+u33fjXUsIiatwVa9krb+TGblF3izlOI2lTRFfh3vOoZq
	 gLjZPFv8OZRYw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2A7D06005A;
	Mon, 16 Nov 2026 01:16:20 +0100 (CET)
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
Subject: [PATCH net-next 01/13] netfilter: flowtable: do not hw offload flows in teardown state
Date: Mon, 16 Nov 2026 01:16:00 +0100
Message-ID: <20261116001612.2806263-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116001612.2806263-1-pablo@netfilter.org>
References: <20261116001612.2806263-1-pablo@netfilter.org>
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

Sashiko reports that refreshing hw offload from packet path is racy
since the flow might be already torn down.

Since commit 7c549fb7eecd ("netfilter: flowtable: generalize pending
status bit"), GC skips flow entries that are still pending to be
offloaded. Let's just check for the teardown status bit after the
pending bit is set on to address this race.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 4365859220e6..3a18fa48cadb 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1120,6 +1120,12 @@ void nf_flow_offload_refresh(struct nf_flowtable *flowtable,
 	if (!offload)
 		return;
 
+	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
+		clear_bit(NF_FLOW_PENDING, &flow->flags);
+		kfree(offload);
+		return;
+	}
+
 	flow_offload_queue_work(offload);
 }
 
-- 
2.47.3

