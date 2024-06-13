Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3389E18028;
	Thu, 13 Jun 2024 01:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718240549; cv=none; b=f6WQYipvfL8NODYthVgAFVf9FfLFbVxdAxxFUwu++SB08rcdYrVuhI54JeczMjXNpla5eWKp8og+YkgLVJPUKFZ9TUHMAg4OhUfiI5yM4hVWM7aml23hfcqlpCECuZH6HDvpTFxRTraF88rPVXGYUBqPcMVyQiygjC+Pt9uM1dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718240549; c=relaxed/simple;
	bh=VR0vCSw6qBR8FFlSppYaTO9EIzBrOVfmurNjZkRbst0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=We8UnbJWtfgRCgVd5kWbGJD1iMKgElojSc7ez7ea2gxPGvl19UF+Dp+YHesgtFTPLSMsnumAWCnx3NkB+LT8Bl5JMvxoNm/JzD8nOwhV7oau3r+Y6hFxmZEOMfD1DJkAcFQg2AadoeV7hkrlu66dWRI3Jz4B5+W4IA7ZsYry7vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,4.19.x 15/40] netfilter: nf_tables: GC transaction race with abort path
Date: Thu, 13 Jun 2024 03:01:44 +0200
Message-Id: <20240613010209.104423-16-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240613010209.104423-1-pablo@netfilter.org>
References: <20240613010209.104423-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 720344340fb9be2765bbaab7b292ece0a4570eae upstream.

Abort path is missing a synchronization point with GC transactions. Add
GC sequence number hence any GC transaction losing race will be
discarded.

Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 81bdc5201c91..a48e92114bdc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7263,7 +7263,12 @@ static int __nf_tables_abort(struct net *net)
 static int nf_tables_abort(struct net *net, struct sk_buff *skb)
 {
 	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
-	int ret = __nf_tables_abort(net);
+	unsigned int gc_seq;
+	int ret;
+
+	gc_seq = nft_gc_seq_begin(nft_net);
+	ret = __nf_tables_abort(net);
+	nft_gc_seq_end(nft_net, gc_seq);
 
 	mutex_unlock(&nft_net->commit_mutex);
 
-- 
2.30.2

