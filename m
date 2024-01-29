Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0638154435;
	Mon, 29 Jan 2024 15:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706542291; cv=none; b=qULo991BYmvsQFimktV01RtdTpv95Xy+9FRfX9J7DyP6SpyCbxoNgyfpCzO/upqjf5lyc8NHlig7/AAz21J8ReAxTJ9nLmhMxOPJL1YRpnoRNK8hGrA6KAgCCvTf8fmpuGeYYP2F2d4956NIy8CdGdugBMzxc+PMR6+d2PyZW0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706542291; c=relaxed/simple;
	bh=9A/Cff5I6/+gIYHxG2x4jBKoi4a9spUgoqphgBujnpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uiKIafi9xj7dEHfBpT+eNMNC91F8VqI5jZIo5kJVvolJmjPtyRBJCY7znH8TIoOc/OIlRv4dQLxXZAqoIUtwRtfkaWLETBsD9NTkleEJj7kI6tvm2lHFyZkNHHfma+PKN1J9Jlc3zn4nfxj/27iIo7EdGXGE8wRSx+E0ivsublU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rUTbR-0001zv-Pe; Mon, 29 Jan 2024 16:31:17 +0100
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	Phil Sutter <phil@nwl.cc>
Subject: [PATCH nf-next 1/9] netfilter: uapi: Document NFT_TABLE_F_OWNER flag
Date: Mon, 29 Jan 2024 15:57:51 +0100
Message-ID: <20240129145807.8773-2-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129145807.8773-1-fw@strlen.de>
References: <20240129145807.8773-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

Add at least this one-liner describing the obvious.

Fixes: 6001a930ce03 ("netfilter: nftables: introduce table ownership")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/uapi/linux/netfilter/nf_tables.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index ca30232b7bc8..fbce238abdc1 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -179,6 +179,7 @@ enum nft_hook_attributes {
  * enum nft_table_flags - nf_tables table flags
  *
  * @NFT_TABLE_F_DORMANT: this table is not active
+ * @NFT_TABLE_F_OWNER:   this table is owned by a process
  */
 enum nft_table_flags {
 	NFT_TABLE_F_DORMANT	= 0x1,
-- 
2.43.0

