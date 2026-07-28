Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635813AEB49
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2026 11:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785236994; cv=none; b=DSCV0xS0My9V06gpiwqsXa/iQOZnjCPEYovXCl9s5XIxpnaLcVMLI3RsOKyzY6lx/PondFSsZzU9Gly94gpqODrKYweaaO2KD8M/hLKwTuvEXJ9GmXFmo3J+nAbi4MHj7pYfBg1AVwGapP2UFABNhsF00/gh1ffED5fa9wvAh/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785236994; c=relaxed/simple;
	bh=i2Za9tMflI3AOqbcNQEeNJykdnuBpOHGPhIYOJ8HP3c=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQ31Lco3iWO4kVVtFJIuq6Y6PPhHfgB2Uw4UYofdlrUTBNl+2LKqjSmvCC4J5LnN+Gv/Jt6Ye0GNRCY0r4VcjO7fQzkSXuAe0WBDiIg5EyXlDRDvT/rnU9sqdc116F/AmFREUMLSwPVnXbG4A/Z9xA+a2oDFLssJxpM4YML9bAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=PWrbQoHt; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="PWrbQoHt"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DD12E60196
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2026 13:09:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785236990;
	bh=/mvpVzwVIaBGFFH7weuOAdTAW5Jg9v+urv29+8FDWZo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=PWrbQoHt6+u+3+Ch27VPoX+wLo3gLTxOME2TUZ5W/KIylhAHGVFP0b8EVwenEWhyY
	 SKA/5EEmuHqiEC0OclFcqDmy7kKA+90WMGlyM/H7axCQjOGcoLiPnPfCirRTUOL+Bk
	 /Kwt+Mi+Fem7GJUi/g37rUszdW/Xy9eCy0BimT5pz2cIYz0AtwZhHau8FnFm298OUx
	 M928ZBH91kh3MQrPKzRQl33vTph526JRGU2Xi7E1uZ1TcdFEcGmPyD+0mK9EuWGMC+
	 wMlQkj5dDZNghqoUjCggVX4Itj0KWl/f6fwBno1n6dGqkA+Sa9OJHSJqMWm6sHClC/
	 SU8MEJ9kMtQmQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v3 2/5] netfilter: flowtable: consolidate flowtable device check
Date: Tue, 28 Jul 2026 13:09:39 +0200
Message-ID: <20260728110943.124900-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728110943.124900-1-pablo@netfilter.org>
References: <20260728110943.124900-1-pablo@netfilter.org>
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
v3: no changes

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

