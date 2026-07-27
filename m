Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26DE3F4854
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2026 11:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785153591; cv=none; b=ZVBf/QfmTAuJa0rkSo+HDG5M/YjtZodZPYB71/Rz15X3PeFnwmqgUKxPEgCXgwDqzAX9tjEn9gMSzDS5CfHBk4VceDDnUmJiw6kCxGIcaxnAzyylLgCkzoBOg3HwtKAMxb3r/V9gureVnBUscdITBoEwg7sRQNeSWdAUALSxgQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785153591; c=relaxed/simple;
	bh=8tGOlFj/s7nai5lEwwVoJROJVORSFhvO6iH0UIQM8xQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hybeE5pxn/lLaPNP59px9/8YLPjdRQW0c7bAtTJeGTiLfmzCQMz/5Q1O8lht+rzgKtPlyV1KIj8oElzOuR/halvmwI8SsEg4Xq8RD7HYR0dulLWHifLDWTaU3vYL59i/jLW7NkvnMnPSghy3Keyu38KMvkeE9dBPyhcp7o8QP7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CrPSs6Tz; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CrPSs6Tz"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6FC6E601A3;
	Mon, 27 Jul 2026 13:59:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785153580;
	bh=b+tpNZAzRDPXNi9eHp/Z2nYPvYC5iWk3ESx7ZgO/O1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CrPSs6TznYr9JPSXHGTGxWgQx4GoaAjIa4USE5qvWlw8PwspuLottxuF9KqRz8qaD
	 ZbjSc17bngH9XR2Mr8ssyGP033qMHT3MCwr61dxMjl10KEQxL4sdD0s7Stjmzr/fIe
	 jqIXFCCXt01gIbfIbez7RWMaxhDBWr4O8Q/ixH+MeGqPbiC8z4vKE04bOUJlKBnNtj
	 cCzmxllGSWZTATlf3ySNJkS243fTV9Tc/HyjX7AtBzUKjAkmo/DNDi3lVJCwt+Vjnz
	 Igc/pV+ZughnNmTIERYlujTsmt01I2aWNDnSDBshyEFEnoyWZu9snZxmBwyS7VFOYJ
	 Uy/NjHS3VvwqA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: lorenzo@kernel.org
Subject: [PATCH nf-next,v2 2/5] netfilter: flowtable: consolidate flowtable device check
Date: Mon, 27 Jul 2026 13:59:29 +0200
Message-ID: <20260727115932.88335-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727115932.88335-1-pablo@netfilter.org>
References: <20260727115932.88335-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Check that device belongs to the flowtable right after the flowtable
discovery path. This is a preparation patch to obtain the dst entry
from the .fill_forward_path in tunnels.

No functional changes are intended.

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes

 net/netfilter/nf_flow_table_path.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 261bb44d08eb..8f04a4487897 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -90,9 +90,12 @@ struct nft_forward_info {
 	enum flow_offload_xmit_type xmit_type;
 };
 
+static bool nft_flowtable_find_dev(const struct net_device *dev,
+				   struct nft_flowtable *ft);
+
 static int nft_dev_path_info(const struct net_device_path_stack *stack,
 			     struct nft_forward_info *info,
-			     unsigned char *ha, struct nf_flowtable *flowtable)
+			     unsigned char *ha, struct nft_flowtable *ft)
 {
 	const struct net_device_path *path;
 	int i;
@@ -178,10 +181,13 @@ static int nft_dev_path_info(const struct net_device_path_stack *stack,
 		}
 	}
 
-	if (nf_flowtable_hw_offload(flowtable) &&
+	if (nf_flowtable_hw_offload(&ft->data) &&
 	    nft_is_valid_ether_device(info->dev))
 		info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
 
+	if (!nft_flowtable_find_dev(info->dev, ft))
+		return -1;
+
 	return 0;
 }
 
@@ -253,10 +259,7 @@ static int nft_dev_forward_path(const struct nft_pktinfo *pkt,
 	int i;
 
 	if (nft_dev_fill_forward_path(dst, ct, dir, ha, &stack) < 0 ||
-	    nft_dev_path_info(&stack, &info, ha, &ft->data) < 0)
-		return -ENOENT;
-
-	if (!nft_flowtable_find_dev(info.dev, ft))
+	    nft_dev_path_info(&stack, &info, ha, ft) < 0)
 		return -ENOENT;
 
 	route->tuple[!dir].in.ifindex = info.dev->ifindex;
-- 
2.47.3

