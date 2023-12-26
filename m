Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231764D594
	for <netfilter-devel@vger.kernel.org>; Tue, 26 Dec 2023 09:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bn3Ta8PK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1703583810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EwZQLx2dP6eCcL8bAS0PoU4Q4fVzMb/S1zk9b9IjiLU=;
	b=bn3Ta8PKwrV7zwu4K1uWwNhYe1/cdQ+l1iqiPLL0NPYWnZHgcBuVZ62MnGVEaBxHZCQK7k
	ZL8t5ciSb5ucRuTbSX9N3QhMCMWC7nieem57zNf30/Yf3GXJxz6WIbyzXTa1wGdXt37jpP
	MqY7MT0ZvVHuYmcMfYSNgxOPk64T/Rc=
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
Subject: [PATCH 04/14] netfilter: cleanup struct nft_set_iter
Date: Tue, 26 Dec 2023 17:42:45 +0800
Message-Id: <20231226094255.77911-4-dongtai.guo@linux.dev>
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

Add comments for timeout in struct nft_set_iter, and flags is not a
member of struct nft_set_iter, remove the comment for it.

Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 include/net/netfilter/nf_tables.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index adabddc4b0b9..a8243cf32e29 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -327,10 +327,10 @@ struct nft_set_iter {
  *	@dtype: data type
  *	@dlen: data length
  *	@objtype: object type
- *	@flags: flags
  *	@size: number of set elements
  *	@policy: set policy
  *	@gc_int: garbage collector interval
+ *	@timeout: element timeout
  *	@field_len: length of each field in concatenation, bytes
  *	@field_count: number of concatenated fields in element
  *	@expr: set must support for expressions
-- 
2.39.2

