Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7479151FCD5;
	Mon,  7 Sep 2026 17:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788801466; cv=none; b=OBqQbHSO1hdyTJfFWoczxlESxlW9AH2rHn89803jObPDTuwQKst5u4I9SoWN14wBvNAQ5ryq6Uwv7iFQ1dSV6dabTKFqe7Gbwd/gvT8OI3Flhj+EMTnlQIO4JYQIy4vL97BCY4xtAaJjMjRXJKiriHdCoGd5+0iBudJU+Ueu6vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788801466; c=relaxed/simple;
	bh=KDMZxKBokX/eFmwjI6AiPYr9lz9zdu6GtHeQGtGseKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tj05VeLmxCuIS85B39ezbyaqNz/HtsuPwpg5JbeKdRqviT62/oV+5fL94u6UUI0/INsktiCKZYzSU+lyk9eQeqrXcG7F+Rid7K5BhWuMCurQPnRpP8o88rvL++riIfPoyORNN34zjcm7ZPbna2CurjXp64jUVlm5pGjJUSYcOJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rBcSAe0t; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rBcSAe0t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788801462;
	bh=+Qvb7ZF0hgN+b8Z8TtazAeZH6daOLVVsMU/uL6SjuRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rBcSAe0t/hUuksXgymcIXUZLS4gdJw6btyHaq1f8B9J9oRhuUoYdIGyKirpdhsSSy
	 objSmrGrcAL3WkBm9zBKe0OKRty0nbmI3km4N3IGpoTt8IaATRWWajCAXxOUIFBHj9
	 ch0f8TBDR2CYgafHrECet4WEmZbQHceSdGhBY8jcguIa/3kXqkLjwdRLDaK031zKLC
	 r4tI4qlF2jZzf6Mg1J0t16b685D2x+eoBO0aENrJV62yIIfWqo3e7aGLpDaIuQFFIZ
	 OQllpoJIpVBjbpVcUyv2KXG2s7JaFfNhnXv2A7+sxgfvjHrkZRNhuNGeqBTGPDNnR9
	 DXv9JZ6v78fmQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E78DD607D3;
	Mon,  7 Sep 2026 19:17:41 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 4/9] netfilter: cttimeout: prevent UAF during module unload
Date: Mon,  7 Sep 2026 19:17:27 +0200
Message-ID: <20260907171732.1407739-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260907171732.1407739-1-pablo@netfilter.org>
References: <20260907171732.1407739-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chengfeng Ye <nicoyip.dev@gmail.com>

nf_ct_set_timeout() protects the timeout hook dereference and policy lookup
with rcu_read_lock(). cttimeout_exit(), however, unregisters the per-net
operations before it clears the hook.

This allows the following interleaving:

  CPU 0                              CPU 1
  cttimeout_exit()                   nf_ct_set_timeout()
    unregister_pernet_subsys()         rcu_read_lock()
      kfree(pernet)                     h = nf_ct_timeout_hook
                                        h->timeout_find_get()
                                          nfct_timeout_pernet()

The hook still points to ctnl_timeout_find_get() when CPU 1 looks up the
already freed per-net timeout list. KASAN reported:

  BUG: KASAN: slab-use-after-free in ctnl_timeout_find_get
  Read of size 8 by task poc/90
  Call Trace:
   ctnl_timeout_find_get+0x271/0x2a0 [nfnetlink_cttimeout]
   nf_ct_set_timeout+0x7b/0x3c0
   xt_ct_tg_check+0x724/0xb20
   xt_check_target+0x234/0xa90
   do_ipt_set_ctl+0x570/0x1270
  Allocated by task 89:
   __kmalloc_noprof+0x16e/0x460
   ops_init+0x6d/0x420
   register_pernet_operations+0x2f6/0x670
  Freed by task 91:
   kfree+0x131/0x390
   ops_undo_list+0x3d4/0x730
   unregister_pernet_operations+0x232/0x490
   unregister_pernet_subsys+0x1c/0x30
   cttimeout_exit+0x52/0x970 [nfnetlink_cttimeout]

Clear the hook and wait for existing readers before unregistering the
per-net operations. This blocks new policy lookups and ensures readers that
observed the hook finish before the per-net storage is freed.

Fixes: ebfbe67568a7 ("netfilter: cttimeout: use net_generic infra")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_cttimeout.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 66c2016f6049..132c02ac7c4e 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -652,9 +652,9 @@ static void __exit cttimeout_exit(void)
 {
 	nfnetlink_subsys_unregister(&cttimeout_subsys);
 
-	unregister_pernet_subsys(&cttimeout_ops);
 	RCU_INIT_POINTER(nf_ct_timeout_hook, NULL);
 	synchronize_net();
+	unregister_pernet_subsys(&cttimeout_ops);
 }
 
 module_init(cttimeout_init);
-- 
2.47.3

