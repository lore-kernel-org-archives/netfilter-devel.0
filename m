Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C1253E3D
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Dec 2023 09:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C0sepe7v"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1703583867;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hp/0/EtTdpMsUAddj6nOU9DQyFHJ3X7EwlFVc6kkPQM=;
	b=C0sepe7vQ9c5pa4c+/WXMOeWpUbZkmkRIj+cyjmF00LtSuB7V9z7cSw2LMSb+Em/YHM9CT
	IFz5sFodVtvDBEur4UMSEJUbpsarcaS0JPz2ZX9gdLjZR/X1IrDxX3Gcn6JM2RCE25g87g
	eSvxnxwHjZRmJr3+wbyF5zesOdpHijw=
From: George Guo <dongtai.guo@linux.dev>
To: horms@kernel.org,
	pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	George Guo <guodongtai@kylinos.cn>
Subject: [PATCH 13/14] netfilter: cleanup struct nft_object_ops
Date: Tue, 26 Dec 2023 17:42:54 +0800
Message-Id: <20231226094255.77911-13-dongtai.guo@linux.dev>
In-Reply-To: <20231226094255.77911-1-dongtai.guo@linux.dev>
References: <20231226094255.77911-1-dongtai.guo@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: George Guo <guodongtai@kylinos.cn>

Add comment for type in struct nft_object_ops.

Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 include/net/netfilter/nf_tables.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index dab1727f3487..505128d10073 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1373,6 +1373,7 @@ struct nft_object_type {
  *	@destroy: release existing stateful object
  *	@dump: netlink dump stateful object
  *	@update: update stateful object
+ *	@type: pointer to object type
  */
 struct nft_object_ops {
 	void				(*eval)(struct nft_object *obj,
-- 
2.39.2

