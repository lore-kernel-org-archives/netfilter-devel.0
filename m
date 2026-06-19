Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22AD3859CF;
	Fri, 19 Jun 2026 11:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781870116; cv=none; b=Uz6a0tg3glTtMeS0VmRKP5G0OZHqkq5LhKVIyS5I1AMvPT3skIpMoKHn7mY+XkBL9Q5FXyW/9wpeHTXMbRw0MgnDLE0clSuynxx+ipef32UWamCQQ6oABOEo7WGhOaIuG1oZK+/7N3zhNkj6bUTGPtD4tPf+s9wdKUVg5Qu4vV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781870116; c=relaxed/simple;
	bh=RsDaxyPuvOrBmPdJ6FVONCDxwowu3uBw/KYyrv/aet4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AWmcYtURTfJ8hBLlli7UP401l3I1uB7oL2yn/GwMYPZYPPBluPyjG8fBXeRRaIHkHnyrIE7zEURBnehbEnV7BKWHl7CC07mLOAqKjjaPy4QmmDokI8tvjVkDpT5tlUF5ANg2fh4NWEa7QncRSFEJaBoveXrw5N/bzwC3osKPhrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CM8BZWsU; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CM8BZWsU"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C1079601A8;
	Fri, 19 Jun 2026 13:55:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781870113;
	bh=UBi8nAYVNxDOC9Fca/g+kEvutyyeLg3iui/uJTcXf3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CM8BZWsUn6m+pH7GMpebrF+Kp7nqeX3HNlkCmpJqgHK2Ja2xFpW+nIhsnYYTCb8vD
	 j74/Z6B9m2j3tRDsrvcbSuTxZTOfEhymEkYOXPI5fCbbswbZ5CL/BBv2wGOWPSycpU
	 tUt13GyENEtNDSosD1Edvbv9lFtxyGZv5XR6Gn6a57yRf0H3mDaW7zbsBBF/a/+8sA
	 xzCmcRSsEU7CoDiQ2fA6h1opgtvg8eDB+K+49IK9l8uHd8dSUp7cLyNekLjZ5tCvGg
	 cpVel7Vo6bMvTdpEJqQ0ersKCrLX8YDJBPvPis5+enqshk7lIUq/DYstxoQEPpY+z7
	 PigAqSG1zbl9A==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 12/16] netfilter: nft_flow_offload: zero device address for non-ether case
Date: Fri, 19 Jun 2026 13:54:47 +0200
Message-ID: <20260619115452.93949-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260619115452.93949-1-pablo@netfilter.org>
References: <20260619115452.93949-1-pablo@netfilter.org>
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

