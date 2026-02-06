Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E973242D76;
	Fri,  6 Feb 2026 15:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770391876; cv=none; b=KiFTgpLPobT2KDxkk97k5UED4bZ1rvGGkK4EMVXLVUelop0zEgwAdha6B/efMzNr4tG0MdN3OyKILZyWhLYfe91sblWE2+chSdeWIn7TC48Y6KYAqsLILy+G2OYGL5+nDROiL+lOH/Bo4O2hWdSPoe+jtGKkquXLAoWbXpQrjmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770391876; c=relaxed/simple;
	bh=EiOrpYCePP9Ke4k3ZF7JsQg4zb8Wlo3IOG4c2sDvaDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ohgq+fDZNJwshFxGaFtFYdTF6UgFIS3F62gFGar9uSiJrLH7zPbHkQsW0a4OUG6ilLomXl06pjWJ4S6PcCuimlIUy5c1MsANDfYwgLjcQWzwYBr4eRkYJNR0nq5ZmcgT/7bKB219vI0mwB5f7BGMTHQZA2u90y0MMS1YWM8h2sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2D3C660345; Fri, 06 Feb 2026 16:31:15 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH v2 net-next 04/11] netfilter: flowtable: dedicated slab for flow entry
Date: Fri,  6 Feb 2026 16:30:41 +0100
Message-ID: <20260206153048.17570-5-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260206153048.17570-1-fw@strlen.de>
References: <20260206153048.17570-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Qingfang Deng <dqfext@gmail.com>

The size of `struct flow_offload` has grown beyond 256 bytes on 64-bit
kernels (currently 280 bytes) because of the `flow_offload_tunnel`
member added recently. So kmalloc() allocates from the kmalloc-512 slab,
causing significant memory waste per entry.

Introduce a dedicated slab cache for flow entries to reduce memory
footprint. Results in a reduction from 512 bytes to 320 bytes per entry
on x86_64 kernels.

Signed-off-by: Qingfang Deng <dqfext@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_flow_table_core.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 06e8251a6644..2c4140e6f53c 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -16,6 +16,7 @@
 
 static DEFINE_MUTEX(flowtable_lock);
 static LIST_HEAD(flowtables);
+static __read_mostly struct kmem_cache *flow_offload_cachep;
 
 static void
 flow_offload_fill_dir(struct flow_offload *flow,
@@ -56,7 +57,7 @@ struct flow_offload *flow_offload_alloc(struct nf_conn *ct)
 	if (unlikely(nf_ct_is_dying(ct)))
 		return NULL;
 
-	flow = kzalloc(sizeof(*flow), GFP_ATOMIC);
+	flow = kmem_cache_zalloc(flow_offload_cachep, GFP_ATOMIC);
 	if (!flow)
 		return NULL;
 
@@ -812,9 +813,13 @@ static int __init nf_flow_table_module_init(void)
 {
 	int ret;
 
+	flow_offload_cachep = KMEM_CACHE(flow_offload, SLAB_HWCACHE_ALIGN);
+	if (!flow_offload_cachep)
+		return -ENOMEM;
+
 	ret = register_pernet_subsys(&nf_flow_table_net_ops);
 	if (ret < 0)
-		return ret;
+		goto out_pernet;
 
 	ret = nf_flow_table_offload_init();
 	if (ret)
@@ -830,6 +835,8 @@ static int __init nf_flow_table_module_init(void)
 	nf_flow_table_offload_exit();
 out_offload:
 	unregister_pernet_subsys(&nf_flow_table_net_ops);
+out_pernet:
+	kmem_cache_destroy(flow_offload_cachep);
 	return ret;
 }
 
@@ -837,6 +844,7 @@ static void __exit nf_flow_table_module_exit(void)
 {
 	nf_flow_table_offload_exit();
 	unregister_pernet_subsys(&nf_flow_table_net_ops);
+	kmem_cache_destroy(flow_offload_cachep);
 }
 
 module_init(nf_flow_table_module_init);
-- 
2.52.0

