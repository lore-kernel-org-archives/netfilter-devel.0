Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FA31A4E99;
	Sun, 13 Oct 2024 20:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.134.164.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728850706; cv=none; b=hGc2HkrLoCV9lkhJsPIKr3RMOefSrdTzZZpMkn7mCZNfrF2tBjpPXZ3JzItzoXlQIjUZL8jHc8/MZdYV2s3FsNFPUu7f8NJsjUltOGSkmtOmUizabNxJZpVP7uQ/wfHyRNezB1B9XLnlQ3QZOKTMQshJ/cQA/o+laNedZWok4uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728850706; c=relaxed/simple;
	bh=kNXkjJaFwYhP4JaG5wcv6WRNM+t/UfeD4oTesH2vCxg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QS30UotCeYtvUpz4ncSz7z0UobM7W1puZxR4aX56X5IUzV80GHjRlVkzf3XbszcEdJrJ6UcvY5CNn5RflqYmbcKlQc7pmL3l6eiwwQy7YtU9xPNJoJtNJNeBfiQ76HFJjp6jRNmIlJ29Xe1ofqi+R5Q9nBf8hgRq42qIZPPEyuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr; spf=pass smtp.mailfrom=inria.fr; dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b=fOBXgGt8; arc=none smtp.client-ip=192.134.164.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inria.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b="fOBXgGt8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MNKkUeKCiQIK6dfMVXhTuefn2rNn5Ihui1VbyZEV5N0=;
  b=fOBXgGt8Wgg4jLiCDM5kSigZXFtw6tJ+TR0lOaG+BawlHN6/NVRuQqeU
   sz20AqFdWrA8+0sEjfhi9/Wi91O+d6c/juvl23zUQXAQ5a1Y3xMUc75kZ
   yJXjfJC7Aahnqb9IguAE23Yj0CQ8ggoyTsv5rELL/g+Jm+ZiBeX6P2ted
   4=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="6.11,201,1725314400"; 
   d="scan'208";a="98968291"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2024 22:18:01 +0200
From: Julia Lawall <Julia.Lawall@inria.fr>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: kernel-janitors@vger.kernel.org,
	vbabka@suse.cz,
	paulmck@kernel.org,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 16/17] netfilter: expect: replace call_rcu by kfree_rcu for simple kmem_cache_free callback
Date: Sun, 13 Oct 2024 22:17:03 +0200
Message-Id: <20241013201704.49576-17-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20241013201704.49576-1-Julia.Lawall@inria.fr>
References: <20241013201704.49576-1-Julia.Lawall@inria.fr>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since SLOB was removed and since
commit 6c6c47b063b5 ("mm, slab: call kvfree_rcu_barrier() from kmem_cache_destroy()"),
it is not necessary to use call_rcu when the callback only performs
kmem_cache_free. Use kfree_rcu() directly.

The changes were made using Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 net/netfilter/nf_conntrack_expect.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 21fa550966f0..9dcaef6f3663 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -367,18 +367,10 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_init);
 
-static void nf_ct_expect_free_rcu(struct rcu_head *head)
-{
-	struct nf_conntrack_expect *exp;
-
-	exp = container_of(head, struct nf_conntrack_expect, rcu);
-	kmem_cache_free(nf_ct_expect_cachep, exp);
-}
-
 void nf_ct_expect_put(struct nf_conntrack_expect *exp)
 {
 	if (refcount_dec_and_test(&exp->use))
-		call_rcu(&exp->rcu, nf_ct_expect_free_rcu);
+		kfree_rcu(exp, rcu);
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_put);
 

