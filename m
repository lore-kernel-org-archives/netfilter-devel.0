Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DD74F215
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Dec 2023 09:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="V1ADvl9p"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1703583836;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H13iUT2LC2IVV8agCsIZaf3XhkP8F5t9KpuQnr3FssU=;
	b=V1ADvl9p+Wx0L58Qqnk9ZJU2xjF1DwXEeOkAy0uS7k1WYpW+rpg+ReDCGJ5YVmxHX0y5mD
	L1CdrwG41Ps89IuI83uForrO7Iphhhqn1jVjfWJXKhmTp98LFZE/zkFY3nBUO3rXQozQOZ
	wJ+HiOkK9zJbm489Pq84iXsSIIRjUg4=
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
Subject: [PATCH 08/14] netfilter: cleanup struct nft_expr_type
Date: Tue, 26 Dec 2023 17:42:49 +0800
Message-Id: <20231226094255.77911-8-dongtai.guo@linux.dev>
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

Add comment for inner_ops in struct nft_expr_type.

Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 include/net/netfilter/nf_tables.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 55f1b3c7dc1f..65c41dcdd4be 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -850,6 +850,7 @@ struct nft_expr_ops;
  *	@select_ops: function to select nft_expr_ops
  *	@release_ops: release nft_expr_ops
  *	@ops: default ops, used when no select_ops functions is present
+ *	@inner_ops: inner ops, used for inner packet operation
  *	@list: used internally
  *	@name: Identifier
  *	@owner: module reference
-- 
2.39.2

