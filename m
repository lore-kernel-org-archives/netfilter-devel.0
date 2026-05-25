Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83D7355F41;
	Mon, 25 May 2026 18:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779733796; cv=none; b=iVhztdS/NGG1QeUOEZdt8DrOz9hzlu7IvoQN8YvWbqpGjfx665Oc+MNlQyUvnpXGebMuvQjgN4N41N0u7HRYzVx9hDjqLVl3NDBd8chfgJr1+7Xnw50n3qWqzEDjMrQcBupuerNE7rIps00MR/F/RPgfhDN5HqOknpLjq8Bd2Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779733796; c=relaxed/simple;
	bh=lH9OxYamxAhZjV2LhLA6k5MgvCb6VHKbyIJ2A4cmkbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FnRBeTnh7lL2XxI9L7K/urIJ/CRcACqY6ysUHx8CurWWvepNnFbBS/GDeYnrEAMEr7ZFhdbfIlJF4XfAZOdDP8OII77++0lxO00rOpO10C9RvClJa7ZDMlO3MVg/2zZeEDs8R8OwjIrZ2Ew/NlGXGtzn7lQxwPJd2m411trZAsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1D99860595; Mon, 25 May 2026 20:29:54 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 06/11] netfilter: nft_set_rbtree: remove dead conditional
Date: Mon, 25 May 2026 20:29:19 +0200
Message-ID: <20260525182924.28456-7-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260525182924.28456-1-fw@strlen.de>
References: <20260525182924.28456-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

net/netfilter/nft_set_rbtree.c:399 __nft_rbtree_insert()
        warn: 'removed_end' is not an error pointer

Since commit : 087388278e0f ("netfilter: nf_tables: nft_set_rbtree: fix
spurious insertion failure") __nft_rbtree_insert() can no longer fail
and this condition is always false.  Remove it.

Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/netfilter-devel/adjSaolTji0mPgqx@stanley.mountain/
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_rbtree.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 560fbe6e3f75..b4f0b5fdf1f2 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -396,9 +396,6 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 			const struct nft_rbtree_elem *removed_end;
 
 			removed_end = nft_rbtree_gc_elem(set, priv, rbe);
-			if (IS_ERR(removed_end))
-				return PTR_ERR(removed_end);
-
 			if (removed_end == rbe_le || removed_end == rbe_ge)
 				return -EAGAIN;
 
-- 
2.53.0

