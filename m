Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E4F33B6F6;
	Mon, 25 May 2026 18:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779733788; cv=none; b=FtTioBpOwitYQcb9Xvm9fooa0zBG1TU80oSPQTvu9g8BgRVJRRy9mvvYHOhrCcDFnQDxbwIbi8IAlswwlFJm393lnRwCXU+mfZ3TuN/s+hiAKIAWx24Nv4xrKbnAMSzT7dkkpWndUKZ+FZYz8SEx0kxsqp0efM+FLZ88azdVeV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779733788; c=relaxed/simple;
	bh=QMx7nujn7ygzUwXtOaXF6SlBi11RPP94euNF2Qhlm7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFHFTdybcw93IWlCjIFHwnda4DlPRoscZ5QglehBiHPXoV4ZG72p3C+NvZpJKMKkmcdHLqMFet3kAGMBM4QFKOtmCA7nBFUna0TOvJutttybzURPgt0BSHBFL5/RLIrfBEuwQWLZctMyYLH/mIr5wprm30sxp9B8tDsrql8aOOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 841406068A; Mon, 25 May 2026 20:29:45 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net-next 04/11] netfilter: nf_conncount: use per-rule hash initval
Date: Mon, 25 May 2026 20:29:17 +0200
Message-ID: <20260525182924.28456-5-fw@strlen.de>
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

As-is, different netns will use same slots if the key is the same.
OVS uses this infrastructure to limit conntrack counts per zones.
Those can easily overlap. Make them hash to different slots internally.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conncount.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 00eed5b4d1b1..ab28b47395bd 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -58,6 +58,7 @@ static spinlock_t nf_conncount_locks[CONNCOUNT_SLOTS] __cacheline_aligned_in_smp
 
 struct nf_conncount_data {
 	unsigned int keylen;
+	u32 initval;
 	struct rb_root root[CONNCOUNT_SLOTS];
 	struct net *net;
 	struct work_struct gc_work;
@@ -65,7 +66,6 @@ struct nf_conncount_data {
 	unsigned int gc_tree;
 };
 
-static u_int32_t conncount_rnd __read_mostly;
 static struct kmem_cache *conncount_rb_cachep __read_mostly;
 static struct kmem_cache *conncount_conn_cachep __read_mostly;
 
@@ -496,7 +496,7 @@ count_tree(struct net *net,
 	struct nf_conncount_rb *rbconn;
 	unsigned int hash;
 
-	hash = jhash2(key, data->keylen, conncount_rnd) % CONNCOUNT_SLOTS;
+	hash = jhash2(key, data->keylen, data->initval) % CONNCOUNT_SLOTS;
 	root = &data->root[hash];
 
 	parent = rcu_dereference_raw(root->rb_node);
@@ -630,8 +630,6 @@ struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int keylen
 	    keylen == 0)
 		return ERR_PTR(-EINVAL);
 
-	net_get_random_once(&conncount_rnd, sizeof(conncount_rnd));
-
 	data = kmalloc_obj(*data);
 	if (!data)
 		return ERR_PTR(-ENOMEM);
@@ -641,6 +639,7 @@ struct nf_conncount_data *nf_conncount_init(struct net *net, unsigned int keylen
 
 	data->keylen = keylen / sizeof(u32);
 	data->net = net;
+	data->initval = get_random_u32();
 	INIT_WORK(&data->gc_work, tree_gc_worker);
 
 	return data;
-- 
2.53.0

