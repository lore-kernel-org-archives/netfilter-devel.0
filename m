Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531704F1E3
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Dec 2023 09:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CJ/u/Yoc"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1703583823;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HGLhO5Ou1/1sy5iMfPRnAioEor7eJGTaCFhyISDdmuA=;
	b=CJ/u/YocoRH87w7XAkDO5W7pMkoLV+bxFqEqGej2CADiGdDvhuGaCluJSIZzOOQCC52gzn
	7feu7abBgBDpuImPkJDQt6a66b9Bz0rG94Dvp2yrniFyOPY/eJuk421VZxyfk4s4bduhIu
	lEneILhFX9q2md3kWR83Uwn01fLesEo=
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
Subject: [PATCH 06/14] netfilter: cleanup struct nft_set
Date: Tue, 26 Dec 2023 17:42:47 +0800
Message-Id: <20231226094255.77911-6-dongtai.guo@linux.dev>
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

Add comments for pending_update, num_exprs, exprs and catchall_list
in struct nft_set.

Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 include/net/netfilter/nf_tables.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 1e24db91a37e..91a1cb6fadf1 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -546,13 +546,16 @@ struct nft_set_elem_expr {
  *	@policy: set parameterization (see enum nft_set_policies)
  *	@udlen: user data length
  *	@udata: user data
- *	@expr: stateful expression
+ *	@pending_update: list of pending update set element
  * 	@ops: set ops
  * 	@flags: set flags
  *	@dead: set will be freed, never cleared
  *	@genmask: generation mask
  * 	@klen: key length
  * 	@dlen: data length
+ *	@num_exprs: numbers of exprs
+ *	@exprs: stateful expression
+ *	@catchall_list: list of catch-all set element
  * 	@data: private set data
  */
 struct nft_set {
-- 
2.39.2

