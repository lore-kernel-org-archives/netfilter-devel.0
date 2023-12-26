Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E37524B9
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Dec 2023 09:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VA9m+0eT"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1703583858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WtCODN2ut5B36lflwZvDOFc9jG0uUJhY+OWc+SFFpyQ=;
	b=VA9m+0eTMeq6v2h6MbhM82UcediuFgMYcymAM2n9ve5kzqpP+KQ5RO88USUHON17J/Wv/z
	wDmmt8vQsGg1Arlt2Jxqy7LJeH5bCYg9TyMSE2VKNE71FTcyRiud3UMeEBBwMrOcujeJI7
	hgU95zeDOovWqAdbJ7uC1wQNYhm1kGI=
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
Subject: [PATCH 11/14] netfilter: cleanup struct nft_base_chain
Date: Tue, 26 Dec 2023 17:42:52 +0800
Message-Id: <20231226094255.77911-11-dongtai.guo@linux.dev>
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

Add comment for flags in struct nft_base_chain.

Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 include/net/netfilter/nf_tables.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 2ee906429cc9..526332bde1b4 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1172,6 +1172,7 @@ struct nft_hook {
  *	@hook_list: list of netfilter hooks (for NFPROTO_NETDEV family)
  *	@type: chain type
  *	@policy: default policy
+ *	@flags: indicate the base chain disabled or not
  *	@stats: per-cpu chain stats
  *	@chain: the chain
  *	@flow_block: flow block (for hardware offload)
-- 
2.39.2

