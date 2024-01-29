Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEEB155302;
	Mon, 29 Jan 2024 15:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706542293; cv=none; b=Lxdd5iUET0+Hc7TsXdcO/+JYMNSthkFKgBdPOrZudegLdiCD7LqsPeH9LdLp/ePud2BrS53wrHMoVyChjRtzOv4HdRash/ed2ek35l6KYQchYwZwB56jo/yYpHrLly2+5CLd0UMhH2NJnuKZddFxo2UTv7tW/KaVKoLnCRMeycY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706542293; c=relaxed/simple;
	bh=l0hM+HWEyAUI2hn54alZopDnPbqW0wr2rKPz5r5bdi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USiK9JkII0IhWOU6uPsgUjUb/Kh1LeAKhtS6XcJznWmJF6ndKoAfhTeYYyV9XBVyKqx0IhzeU77nH+5VviO87+lmDvq0wt8TGs/h1In0WR+oDSBwSM7BOFjR6fbwfES4FYg8t4xy4yGfllUNOjSboxOkPjIfNdhWN25NPeyQmLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rUTbW-000219-Un; Mon, 29 Jan 2024 16:31:22 +0100
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	Kunwu Chan <chentao@kylinos.cn>
Subject: [PATCH nf-next 5/9] netfilter: nf_conncount: Use KMEM_CACHE instead of kmem_cache_create()
Date: Mon, 29 Jan 2024 15:57:55 +0100
Message-ID: <20240129145807.8773-6-fw@strlen.de>
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

From: Kunwu Chan <chentao@kylinos.cn>

Use the new KMEM_CACHE() macro instead of direct kmem_cache_create
to simplify the creation of SLAB caches.

Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conncount.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 5d8ed6c90b7e..8715617b02fe 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -605,15 +605,11 @@ static int __init nf_conncount_modinit(void)
 	for (i = 0; i < CONNCOUNT_SLOTS; ++i)
 		spin_lock_init(&nf_conncount_locks[i]);
 
-	conncount_conn_cachep = kmem_cache_create("nf_conncount_tuple",
-					   sizeof(struct nf_conncount_tuple),
-					   0, 0, NULL);
+	conncount_conn_cachep = KMEM_CACHE(nf_conncount_tuple, 0);
 	if (!conncount_conn_cachep)
 		return -ENOMEM;
 
-	conncount_rb_cachep = kmem_cache_create("nf_conncount_rb",
-					   sizeof(struct nf_conncount_rb),
-					   0, 0, NULL);
+	conncount_rb_cachep = KMEM_CACHE(nf_conncount_rb, 0);
 	if (!conncount_rb_cachep) {
 		kmem_cache_destroy(conncount_conn_cachep);
 		return -ENOMEM;
-- 
2.43.0

