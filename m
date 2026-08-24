Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950263F3294
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Aug 2026 12:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787573573; cv=none; b=Lh468H52Srmj3rMJ0ZDY6eiVa9s8uIo4PZSt+sc7KrG6jCJ/Q7DIiyU4x0hLhonUKA6ZPxQWQOFnafa9SPEU1DdM6/7dfmObuAH7+XLoqljVCQsOomCtb64YWL5hReGrNt0GWXg54ddzosxJBLbB9ltVT2c+WzbnAUp4sd/+Yw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787573573; c=relaxed/simple;
	bh=qTuo0XGpd3/TJoBr7VlydNUS5gAgjPvXjtLTX//eAj0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qfU0yIdpHgn34K5bNZhq7w+k4iWbK6MkxOOdjhfWLk0xuW12lod86irPSr2a9cABYh9FWTbqYjSbc3tOYLBpcc+0vvZPHe6xYg1lvx7ifJAPW+/cCgJSCyZDFnCadMTy3EuAIH/cxUED/lHJ5DFdf+E1cmmF6M48MN9JNOfmhxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dNKg45UB; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dNKg45UB"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cffd93cdedso2855985ad.3
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Aug 2026 05:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787573572; x=1788178372; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y0ppQhbiQcCeg1OqwKrv6XM0T1yzd97yREoqT41AZzU=;
        b=dNKg45UBwquvACLINh3/RMXrzf4oSej41PPI3JJj5vaZgrYeloEC/zX6biqvwbfN4V
         /35WCX8AuyFZGh4Dj0Qd7Zzx5ljA5HrUAzSax5pQMj4Zo9FGaiQcPAAZgQWhYl7iuoGZ
         /YLcSLe+VuZ82vJGSI3aMV0OGGYXAMMigDmoTlTLVBD7Ej1TIuPLPy5YXELoxte4YqjC
         m1tJjYcoIb1PHwr17zYtqPiQGA2fGCE1pJrO2ks9WZ4lrX9IWD+GbDKM/J2GpuRy94bY
         p5smS55RvvU647vD3qoOQqLl7nCTbhtoZyHs4MQVq1pcNiimRYUPytvt2ztg9m6tsz0g
         OUGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787573572; x=1788178372;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y0ppQhbiQcCeg1OqwKrv6XM0T1yzd97yREoqT41AZzU=;
        b=fyIRfFQC6qdabXAyjyBvrWHGPuks38zWEcx5Bg4/fBYPYhRWuzpRVAz+u1iO8ExmkJ
         yBnEH+F86EZKh9KXHMekke13OE2s9q/NDLdu6cbZac75MclwXzxE5NX5ADkx+LZ6Q5cZ
         PtGBHKgavjpxb8JwgKsjrDhIFRVwc7UOQoyDRZxATXU5scJ6TWxenE4HpHvBC7RxyQa8
         mB/H1Dq2EwBVeLxXcd/nOh1uDbTJxtJb8Cz/eS6a66qMepSqaHUJgBW6J9Sq7h86Q13m
         BGqd0Uph/ugPusLERRkpDGZ2Orko/BAIdICk8vcNc3Z45qPdQ5lkkcfOCbZskssy3YGX
         qLwQ==
X-Gm-Message-State: AFuF++lMU5U191RDCCW1U4uvlvlbhxPp76YaL+IQw+ZA2e7u7FBCfnrh
	DdO3fw6NeTE94Wheg5AVQD9UXBvAaCwAOvSk41rWIhA/bdVX3P00x6Wc
X-Gm-Gg: AR+sD12tUXO0jQygEaiebrwWstq0hRqDrfG55gWkw57QYzPVlHSimPytVimp03jKpkp
	iaVpNzUnlBDn/FKSGbatgemCnq2t5tK30JSYgXQFpX6ssRxqsc3O+69GQYEHJx9tUfuKJzwxtSE
	2cgWn6vN4QgZCfEHcoYuOTz74EJe6uv4s0QT1usYSfuXOv5hMUUKFvUgHeqvzYdGrEPzvuV8Y+t
	Nny8tDswo3a+u/ROMDgAyyVBWaQZGoSx5MkizV0MQG7zuwrf/qiGpImR2RSJFXXdFts1bT+Iy1A
	UixcW6K8sxevVgE/izRdjfNuWumSh5SxBzmsQn2AbSSTYd/D2blhv7BOJ02N1Nkb9JFizZTuuns
	NC8EEmXW/njo8z1i1snoHZEDAO/w7iNPd9WoHuYuHmKIFr24N0MjsfVeWCGm07SE1e4HdiU7lbm
	X/zCaXj2MGKXHpupKWBkwdP0Jr1FWJTdxbpQZMfs2BfCEtLSkJF7J6aMpPFneQLActP5/30eQ9j
	LgQlnrZO8lgSzPlPwF2Yu865R3Wzfyfz/KCqF3j0CKmEcg3iAj4LdE=
X-Received: by 2002:a17:903:3b84:b0:2cc:f4d4:29a0 with SMTP id d9443c01a7336-2d64b0a908emr230320855ad.3.1787573571971;
        Mon, 24 Aug 2026 05:12:51 -0700 (PDT)
Received: from localhost.localdomain (45.78.65.84.16clouds.com. [45.78.65.84])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3280d116cb1sm16516298eec.10.2026.08.24.05.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 05:12:51 -0700 (PDT)
From: Chengfeng Ye <nicoyip.dev@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH net] netfilter: cttimeout: prevent UAF during module unload
Date: Mon, 24 Aug 2026 20:12:38 +0800
Message-ID: <20260824121238.205812-1-nicoyip.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
2.43.0

