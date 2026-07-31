Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282243B6BF5;
	Fri, 31 Jul 2026 15:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512059; cv=none; b=J5aNyo3EqlzZF6zESvPnu/wviJlU00UILb+KL8hORwGZYWZ9DoQeHHDCUf5zFcoV43ukXaz64eGQEORqGNpnHlyDXPPI9k81oFmRelzy/N08mq5M12/QrduzsGhOSKruODNZLkJ6nqC7xDQAyD6HQ62X93SL8xenuIa5Q5sNOQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512059; c=relaxed/simple;
	bh=uEuFaapg3eoZZMP2GaFuGVcml+6QyqfqQ+wKDbVOz50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Upjp0Lyt+f+OVZhNfHpjpcuLj6aQ9upp9UEOizqqq7nNSVNbe2eYisCVHdHOiveVPbIqdLQxbxSKNH8dhrHRAeC5MF6AMHAv8MKYOj1zf8qBJsSyQsirsgVPQNKH8neHKJRpJwj6+TdY4/1KRqjEsN4fOUh6hbLwJYkh19+hTUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DPGp2D34; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DPGp2D34"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BCEF3602AD;
	Fri, 31 Jul 2026 17:34:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785512056;
	bh=VisJhoTRokNHUIawQiFicZyWP/akiy+sJcWmBNTqUHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DPGp2D34g0kYLFnB32NxOrdZz3fvOor59JpI7i1jdncHeWUybsqPNha0MVDaJBHHM
	 9qZ4fx2dXxDxUdNclFBQUCa6POJiuJpOUCfJ8I3w1Q+GNRTOzBG6g/xs0Jbg0gSDIM
	 Oc9OVbzGxIwNAgzuvO5bixPHWQNFV/dBVKw+Pbmr5g7qIDsMkQOOVswvVgZlTThC7F
	 82ZjYrrBtHwldK/BEiIY0OnHkRdfsiC2l5piya6htCwm4gEF/s/3CmUcZAkMnbZrxA
	 qpqQDtMD+ihkAANsSB7ynU5lRg5oYRksRKgjbDDivPrbotf4dHDtglhOnLTcToVTE1
	 KNGgHeFVF1SCw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 3/9] netfilter: flowtable: consolidate flowtable device check
Date: Fri, 31 Jul 2026 17:33:56 +0200
Message-ID: <20260731153402.851224-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260731153402.851224-1-pablo@netfilter.org>
References: <20260731153402.851224-1-pablo@netfilter.org>
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

