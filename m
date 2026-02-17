Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED19336F439;
	Tue, 17 Feb 2026 16:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771345979; cv=none; b=hBhWQDNR2Oj7JwXteXnaoCPG02yU5Pnb08IQLM2Jqe6ljqhk/LHOnCQAF4yfA5PtjAUnSveXk3XTbW5Q92qSk1bj1RE2NP6pTas5LrdgLVmwPalYvvIkgL1E+cfPY0CSrpNyE8vGVWhUEXCKoO0aVKv142cJOo27eNOovumS3cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771345979; c=relaxed/simple;
	bh=uW2O5Th1LCTJ1AVmag2UcS2a7ifOv+akwKAP3v8/iSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKDflXpcFXUHiY9RjRTXkyPTmBNgfHTa9DZoQ/s416VLeTbUWh/zrqmwlJOS9YDjjdSAa13JG1WUfB/15jLu/W2kdlN+0tds41Kkx9x4BKwPcalVx2pFaqbzVMLMrc6frdK4cIKDuax8smTL6lmKGGQmRLmjoAldN/vK27oh1y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3A78960683; Tue, 17 Feb 2026 17:32:56 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 03/10] netfilter: nft_quota: use atomic64_xchg for reset
Date: Tue, 17 Feb 2026 17:32:26 +0100
Message-ID: <20260217163233.31455-4-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260217163233.31455-1-fw@strlen.de>
References: <20260217163233.31455-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Brian Witte <brianwitte@mailfence.com>

Use atomic64_xchg() to atomically read and zero the consumed value
on reset, which is simpler than the previous read+sub pattern and
doesn't require lock serialization.

Fixes: bd662c4218f9 ("netfilter: nf_tables: Add locking for NFT_MSG_GETOBJ_RESET requests")
Fixes: 3d483faa6663 ("netfilter: nf_tables: Add locking for NFT_MSG_GETSETELEM_RESET requests")
Fixes: 3cb03edb4de3 ("netfilter: nf_tables: Add locking for NFT_MSG_GETRULE_RESET requests")
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Brian Witte <brianwitte@mailfence.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_quota.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index df0798da2329..cb6c0e04ff67 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -140,11 +140,16 @@ static int nft_quota_do_dump(struct sk_buff *skb, struct nft_quota *priv,
 	u64 consumed, consumed_cap, quota;
 	u32 flags = priv->flags;
 
-	/* Since we inconditionally increment consumed quota for each packet
+	/* Since we unconditionally increment consumed quota for each packet
 	 * that we see, don't go over the quota boundary in what we send to
 	 * userspace.
 	 */
-	consumed = atomic64_read(priv->consumed);
+	if (reset) {
+		consumed = atomic64_xchg(priv->consumed, 0);
+		clear_bit(NFT_QUOTA_DEPLETED_BIT, &priv->flags);
+	} else {
+		consumed = atomic64_read(priv->consumed);
+	}
 	quota = atomic64_read(&priv->quota);
 	if (consumed >= quota) {
 		consumed_cap = quota;
@@ -160,10 +165,6 @@ static int nft_quota_do_dump(struct sk_buff *skb, struct nft_quota *priv,
 	    nla_put_be32(skb, NFTA_QUOTA_FLAGS, htonl(flags)))
 		goto nla_put_failure;
 
-	if (reset) {
-		atomic64_sub(consumed, priv->consumed);
-		clear_bit(NFT_QUOTA_DEPLETED_BIT, &priv->flags);
-	}
 	return 0;
 
 nla_put_failure:
-- 
2.52.0

