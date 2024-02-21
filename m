Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25D840BED;
	Wed, 21 Feb 2024 11:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708515008; cv=none; b=QY6AqBcmK+7lULQeYIOxvXqMSBi6gl6gFs8LsPdBrKcMECEipyIBO885Dywpelx0PRMS3PSFUfoJ8QjOlAHSWhJzxiGFz3vjnTxK33vvDuxqczhzx0sQFmYPy62dU4pFOP3pyd7UJujK8AFc/x7dNsFGxwzhCPsZDK4R52u2+AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708515008; c=relaxed/simple;
	bh=Qo+ff032QZlF+Re4v8xYp6isLiACbK+JXc0+3JRT7Gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WDa8XiW50z9CQww2HwR8riItfhXcLAx7JqfREMvVD+ghc+gcsgylVynzQej37KXaIcLbShOPUnXI76ee2bvZvX5HngNbGavAbd8a4SDUOZRbBWZ7EwS9R2nzIKR0SqFadkw1e6YEvDa01OTewc7E0pKU04MGDFYPTqTvq2vKano=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rcknB-0003rv-QA; Wed, 21 Feb 2024 12:29:37 +0100
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	Kunwu Chan <chentao@kylinos.cn>
Subject: [PATCH net-next 01/12] netfilter: expect: Simplify the allocation of slab caches in nf_conntrack_expect_init
Date: Wed, 21 Feb 2024 12:26:03 +0100
Message-ID: <20240221112637.5396-2-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240221112637.5396-1-fw@strlen.de>
References: <20240221112637.5396-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kunwu Chan <chentao@kylinos.cn>

Use the new KMEM_CACHE() macro instead of direct kmem_cache_create
to simplify the creation of SLAB caches.

Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_expect.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 81ca348915c9..21fa550966f0 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -722,9 +722,7 @@ int nf_conntrack_expect_init(void)
 			nf_ct_expect_hsize = 1;
 	}
 	nf_ct_expect_max = nf_ct_expect_hsize * 4;
-	nf_ct_expect_cachep = kmem_cache_create("nf_conntrack_expect",
-				sizeof(struct nf_conntrack_expect),
-				0, 0, NULL);
+	nf_ct_expect_cachep = KMEM_CACHE(nf_conntrack_expect, 0);
 	if (!nf_ct_expect_cachep)
 		return -ENOMEM;
 
-- 
2.43.0

