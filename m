Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0416A4CDA28;
	Thu, 15 Oct 2026 11:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.155.198.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792063564; cv=none; b=Yo3m6p8rIDYgwaeRGpsq17hieR/vF8ARekXu58WG8wpvcXWaiodMXPNa20pAu93yDUfuzfXbsi6fN9UQFQk36Qp4xH88apFE7fWciIMw83g032O9ttYs8cO2YzFZrJdr1AM7VcLM8HDfExydPYxnYDVPMyA/wpdKoQcJzsTaNuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792063564; c=relaxed/simple;
	bh=7PXNMn2C4p9pMnktnZoNhlpR49ZVLPwGee0gzKDKqjw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=F0FpM6Xn3QFKZY7Ghyd3gyOLPXtpID7ZPfhqenBDZ13m2SBaadHssBKDjFjzJf1iOiGQoZKYQgCzrErWPULmDcZtj2qpK/7vbqjZkUV0RBKESM9Z1/c2q6fD/85Oa1hYPU2WtGdu3usPvFqZyG1OD58WfqqWmXzN4SaZFgRTNuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=ngMZTFqy; arc=none smtp.client-ip=35.155.198.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="ngMZTFqy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1792063556; x=1823599556;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dWPeIBe4ZvwIBWLGCPJyt8oAMWcJJcBbPHtJ5cfA8lQ=;
  b=ngMZTFqy9+dRecl4kaERR58GPcHbK5Qg2L+L64MytDphDXmtICqJSij8
   HVnZ97H1EnB8lRdFMv5T+MJFpVqsT59/nx3YTwT3wYmtTgC9YtpaHa3wC
   5cq3YY9Mu/hGN4FtqR+knBVSG91Y/F2B+IY8229zOUwHBlfkRZo5wJPgU
   baMQXu8f5TI5CQOsdYiyUT88SxD2cz+/SnQ9Obe/GiHmxZk8a+fZO5gzK
   vgpL/a6MPG4Kco057qUouwYLXE5P5bGOoJ0vdb++/jjYjvzOOOdKESVJQ
   J2fqyf20LEHJOJyfpaopA90Wa7fDPvU8OWRPowwbwg7dOSxWA4MxyaoqI
   g==;
X-CSE-ConnectionGUID: WMdNMVpIT7ycY4BQnd/AtQ==
X-CSE-MsgGUID: SxGpi8BsSXycBzD2MamsUA==
X-IronPort-AV: E=Sophos;i="6.27,159,1787011200"; 
   d="scan'208";a="31231660"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 11:25:52 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:4508]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.54.1:2525] with esmtp (Farcaster)
 id 22a6e85e-4171-4fa5-abe1-d6a11a02de47; Thu, 15 Oct 2026 11:25:52 +0000 (UTC)
X-Farcaster-Flow-ID: 22a6e85e-4171-4fa5-abe1-d6a11a02de47
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Thu, 15 Oct 2026 11:25:52 +0000
Received: from dev-dsk-gyokhan-1a-87ab81cc.eu-west-1.amazon.com
 (10.253.85.128) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.53; Thu, 15 Oct 2026
 11:25:50 +0000
From: Gyokhan Kochmarla <gyokhan@amazon.de>
To: <stable@vger.kernel.org>, <gregkh@linuxfoundation.org>
CC: Felix Fietkau <nbd@nbd.name>, Pablo Neira Ayuso <pablo@netfilter.org>,
	Vlad Buslov <vladbu@nvidia.com>, Daniel Golle <daniel@makrotopia.org>, "Sasha
 Levin" <sashal@kernel.org>, <netfilter-devel@vger.kernel.org>, "Gyokhan
 Kochmarla" <gyokhan@amazon.de>
Subject: [PATCH 5.10] netfilter: nf_tables: fix bidirectional offload regression
Date: Thu, 15 Oct 2026 11:25:33 +0000
Message-ID: <20261015112533.648137-1-gyokhan@amazon.de>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC003.ant.amazon.com (10.13.139.252) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

From: Felix Fietkau <nbd@nbd.name>

commit 84443741faab9045d53f022a9ac6a6633067a481 upstream.

Commit 8f84780b84d6 ("netfilter: flowtable: allow unidirectional rules")
made unidirectional flow offload possible, while completely ignoring (and
breaking) bidirectional flow offload for nftables.
Add the missing flag that was left out as an exercise for the reader :)

Cc: Vlad Buslov <vladbu@nvidia.com>
Fixes: 8f84780b84d6 ("netfilter: flowtable: allow unidirectional rules")
Reported-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Gyokhan Kochmarla <gyokhan@amazon.de>
---

8f84780b84d6 came into 5.10.y in 5.10.271 (238c7e7e0808) as a
Stable-dep-of d644b23afe1e ("netfilter: flowtable: publish HW_DEAD after
worker is done"), but this follow-up fix did not. Since then
flow_offload_rule_add(), flow_offload_work_del() and
flow_offload_work_stats() only handle the reply direction when
NF_FLOW_HW_BIDIRECTIONAL is set, and nft_flow_offload never sets it, so
nftables hardware offload only installs the original direction.

 net/netfilter/nft_flow_offload.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index c2a5d05f501f..98c60e4263f7 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -127,6 +127,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 		ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
 	}
 
+	__set_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags);
 	ret = flow_offload_add(flowtable, flow);
 	if (ret < 0)
 		goto err_flow_add;
-- 
2.50.1

