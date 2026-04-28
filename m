Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBEE63E2766;
	Tue, 28 Apr 2026 09:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777370339; cv=none; b=Rnv6h1yirjqKXIJnAYMV+fjbGoMVCwVMNpA6cAmjTqlWCpoVpzaIe8Eu/BVfNd/C38L9K/VQ0CtuFH0q+oPppdoqz2Td+ObtdsJ6fpN+IxGqHJ4y3wJ0wkrtYKjBaQxg97H79YDCdlowSXRoN97hQKrn6LCeBV5MwDCWuIRhIR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777370339; c=relaxed/simple;
	bh=5auVh159NgHYnY9KURAEEAM3LkKuat/4fjrsARva74g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6xVTWkDXTvBrcFlARRYlM95IzDxGJAfbRt8uZ6eUYbzmmmHCdg4mAjWlA+IEvuvFJJwIuf+odX9l0RWfnFwkP2qpHYkckfT6cerD0txNV0nYUDb2whgB2Hcz7U3QAvs/9mL9LhW+L2YvanSEDbAnhaWOSDGuPSyK0m0CTZ7Qjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nk19gGBb; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nk19gGBb"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C319560255;
	Tue, 28 Apr 2026 11:58:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777370335;
	bh=kvO4NiWkgz6Po7XmbFpN2ojH9hOJD7U1mcp/a6giG88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nk19gGBb992D0YhNpCc0TND4MkruzaIzLT5gvv3W4xFHpcPnlPFisQsGUM87GtsyM
	 8/ttN63oqGbFPil5kiGbtP0qXlvKp37cxcN3JUyw9LQqEMOL64YRYhjCB847/ctI8G
	 LcqTIQTRjFBGkaQw1WPPGy4vWPcEwk+jWKUCxQeTiHs0njzhZ7/bHu3K8UyKWudv8d
	 gn9mKEojhT6sIVBGcpTkDCzBjMHSyDqFlX+ryKV4j0+raf3iGuxvySSwJoc96ZsvbB
	 mRhVeCTRx6LnWO759n89ONT/DPk6UGVpyPwHzR6sxrOUYAkoLMdIg/bSdEgAgFduvP
	 14RRVw4Ij2lgw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 7/8] netfilter: reject zero shift in nft_bitwise
Date: Tue, 28 Apr 2026 11:58:38 +0200
Message-ID: <20260428095840.51961-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260428095840.51961-1-pablo@netfilter.org>
References: <20260428095840.51961-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kai Ma <k4729.23098@gmail.com>

Reject zero shift operands for nft_bitwise left and right shift
expressions during initialization.

The carry propagation logic computes the carry from the adjacent 32-bit
word using BITS_PER_TYPE(u32) - shift. A zero shift operand turns this
into a 32-bit shift, which is undefined behaviour.

Reject zero shift operands in the control plane, alongside the existing
check for values greater than or equal to 32, so malformed rules never
reach the packet path.

Fixes: 567d746b55bc ("netfilter: bitwise: add support for shifts.")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Kai Ma <k4729.23098@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_bitwise.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 13808e9cd999..94dccdcfa06b 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -196,7 +196,8 @@ static int nft_bitwise_init_shift(struct nft_bitwise *priv,
 	if (err < 0)
 		return err;
 
-	if (priv->data.data[0] >= BITS_PER_TYPE(u32)) {
+	if (!priv->data.data[0] ||
+	    priv->data.data[0] >= BITS_PER_TYPE(u32)) {
 		nft_data_release(&priv->data, desc.type);
 		return -EINVAL;
 	}
-- 
2.47.3

