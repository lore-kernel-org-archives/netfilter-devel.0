Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B55A10F1;
	Thu, 22 Feb 2024 00:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560535; cv=none; b=VpZi3F1NobQwQYGStGNFFw2giyyPoCfDU3y4wOLU0YPJ/xrsihlHDrvSGnhNBFRutTPRluMhWJUddcu7LZ8p5OD/a6Zhpu3VUk5lR1jgZQbG4poPJyWlJ2b+pHxvGADB1Ykwq8yqy1WKQuYyQvVeeJTn9HKn50rYhG8T3gJ6Oyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560535; c=relaxed/simple;
	bh=2n/mqBjXZQR/JNE569Eojei1VwcI4Xx5AmH4D6kwZr4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rwYpbOTDabJbLR4iPx+2BIkDCISy0Og/cWxafOrnRX9BREcOyTm1pf63GaWL2M1rNOSeeeIttUT3iWXPX2QCqTbWP3BHUVUkrpkWLYdNNf0ok5sYjZITlYXWx5oCFQt9Q7bJSHs/s45KxYtgTeTe92mPqc94BPow0eqN1uhXsg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 1/5] netfilter: nf_tables: set dormant flag on hook register failure
Date: Thu, 22 Feb 2024 01:08:39 +0100
Message-Id: <20240222000843.146665-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240222000843.146665-1-pablo@netfilter.org>
References: <20240222000843.146665-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

We need to set the dormant flag again if we fail to register
the hooks.

During memory pressure hook registration can fail and we end up
with a table marked as active but no registered hooks.

On table/base chain deletion, nf_tables will attempt to unregister
the hook again which yields a warn splat from the nftables core.

Reported-and-tested-by: syzbot+de4025c006ec68ac56fc@syzkaller.appspotmail.com
Fixes: 179d9ba5559a ("netfilter: nf_tables: fix table flag updates")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f8e3f70c35bd..90038d778f37 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1251,6 +1251,7 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
 	return 0;
 
 err_register_hooks:
+	ctx->table->flags |= NFT_TABLE_F_DORMANT;
 	nft_trans_destroy(trans);
 	return ret;
 }
-- 
2.30.2

