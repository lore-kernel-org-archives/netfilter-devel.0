Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA10A47A0A4
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 11:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785325796; cv=none; b=bo2MJTHwLhHOCICj+Ai+BAVnDjtvP0VB5lbfbzob4PfM+rG3/k9nQ9GzLigjdKRUmyzMHWGj9+H9OdnbSRn+jkjlc+hjNbTxZvHMHOCzshIaQYj/iePTpSNc28qdwAyp+McEJusrbcvj3MF5mA1J3hFv8KJDV91B5SiRp4qZcFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785325796; c=relaxed/simple;
	bh=87GW+5ujr01/ZnWggA/hK/Ridfbjy60W4uuJcgLoHzY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckpml3XLrV3Ab2WFJ0Jz0BMTVjA3w+2+Lcw7uqdzuXecFkLzDN78s9A4WmMymENoG/BllXsOSFVZgbZGPJgeEl84FPKIyOyybdDNXv2VJyXclQSK41ljAtyoGHDQeOxF0wxZyLZRpBj9oNWfqMyumQJteezB3defbDfYHc34lXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ksDLVMpf; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ksDLVMpf"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8779D6019B
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 13:49:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785325792;
	bh=dOaGX+ROzjK3VtjWN25BBGIVUiXzxMgWCZtF7RPopAk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ksDLVMpfLiVVoPlshynq+M0KVBXFX0GiL7J3b9v3LTvz4ZAzyXB+whhoRmK2s+Mk8
	 O0vsnKDLZIg8qoDGlHFzQOFXlQ4hTpHa2fN6hjqNbQNCCSMUD6oR50bvTVkSzAgvxC
	 P+vhuNEVmtys4NanCznUHSOvC2bxGYMMZjKvCtMUtdvKj2h+da9x6t/W4G1fh8XJP9
	 Ghwxozu3+Bc6D7vgsZ0pZGrg5ExuvFKu7vNiC1iWE49eCo7drDKpEzulREsT+xhE07
	 UfXTDM8R5+zxlXl0Zrr/8UNEgE8hKoZqKgVsJlau3PvtDe0exJi/pSa5NtkDJAOboh
	 YDDJ0OmTFHZPA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v5 2/6] netfilter: flowtable: consolidate flowtable device check
Date: Wed, 29 Jul 2026 13:49:43 +0200
Message-ID: <20260729114947.403782-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729114947.403782-1-pablo@netfilter.org>
References: <20260729114947.403782-1-pablo@netfilter.org>
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
v5: no changes

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

