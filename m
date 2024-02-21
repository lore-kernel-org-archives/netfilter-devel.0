Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822322F2C
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Feb 2024 17:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708537310; cv=none; b=MWATzOTrFgECgwl8uSByk3XhzIRn+D1AO016uXLPWtl4SvffVCAMNUxdQYvxj5j0UHNT8B8ArGKru0WWGTdE526a7c2UJxbsS5wb++/IasrpzZuwdF5uKzb29BrWiKW8aJRNdqP/0qIEKKwRqpCUX5yMX5cSVvbbCnivmp13nac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708537310; c=relaxed/simple;
	bh=TMvdQueAm4kOWRudUp2b4vTXBFgaReQoPlOks8jvP0o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tl+K0spDXfrivFUghqi7ttvBwKiqTHr8ox/4TMLn1/VhIXbwgTuQFYI8yYYibWxntG1UBPYiwULUuEC1RBtRSrY9SoO4u8glagGno9wRbwV/nvj4OF4jLUESGbFJNnwAtH3Yx677WU5HOlb+tLNavz5IPqb0Tm6d30BalkL4Fxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rcqbK-0006fk-GF; Wed, 21 Feb 2024 18:41:46 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nf_tables: use kzalloc for hook allocation
Date: Wed, 21 Feb 2024 18:38:45 +0100
Message-ID: <20240221173848.5929-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KMSAN reports unitialized variable when registering the hook,
   reg->hook_ops_type == NF_HOOK_OP_BPF)
        ~~~~~~~~~~~ undefined

This is a small structure, just use kzalloc to make sure this
won't happen again when new fields get added to nf_hook_ops.

Fixes: 7b4b2fa37587 ("netfilter: annotate nf_tables base hook ops")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f8e3f70c35bd..e61271a5db1a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2080,7 +2080,7 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 	struct nft_hook *hook;
 	int err;
 
-	hook = kmalloc(sizeof(struct nft_hook), GFP_KERNEL_ACCOUNT);
+	hook = kzalloc(sizeof(struct nft_hook), GFP_KERNEL_ACCOUNT);
 	if (!hook) {
 		err = -ENOMEM;
 		goto err_hook_alloc;
-- 
2.43.0

