Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F9F3806B6
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Jan 2026 10:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769681546; cv=none; b=GNJXYOyHLdfQP+4cJYjyhEdyiipMdwtVU8KONGkV+qnTB4zqCMSzHNx1SxKP0ObYaiB5uk04dofX4ElFYpwvHas4khoQ413NArUtwADuLxrkA/xzO5enCndvZmEtiA004dDKuBV/JFS5WEcAl4XSP0Lo3G16oLI6COH/HhgqquI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769681546; c=relaxed/simple;
	bh=V4kEo+SZojVCtWgR2qpo3SKCTe5B0pPOMa6sCL8N57o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nzlCudfviPfCySAdq5XfpLrrd6yeBUlnNukJtJo3rkuI/wkKPMyWExNYcFhfiqTxEmDhDmMEwzvfnOSkfY4VbcPFxoHxFEzdQdnUiG37QEX09IzpKc9z7Goy0wMnpIrPXxhX23y0hstm5Bs/klDwJaiyd4i2zjATKVfqLxODOT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UufYWTe9; arc=none smtp.client-ip=74.125.82.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UufYWTe9"
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-124a95e592fso218485c88.0
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jan 2026 02:12:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769681544; x=1770286344; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AJa7eQGWZbzucfOY/PWCQHeENsvDVajhwi4B2jpBWQE=;
        b=UufYWTe9Z0lCWYsDAoxLx3wof5M0PhfmZve1QGXCGpPQ+uzAnpers4m478HMPzkQYD
         qYSRVUl3w05ik2EF5YM1zZtxJKZHxMx1SLCXc4Np7MvBlOkD+ksFf2HPngekXdTyQ+C7
         AO8kmw0MWfHJvqIgO6cUR/0QG7HO5wLqbIKIfyqbhLc0sqTnGFfRJboSd7wo/+qlvEIH
         uIiYfXJ0huF3Fsy4VtQlZt4F5rCLIsIPwHn4rPynHU4mhqHh2V9J4w3ZjyTlGECFZN2R
         eTJl46g9WqzKMubMpCfh5m2M1H2+GaQeS9IenLQ318WsiYYpF8L9sCqjp78qMi+Xizt0
         WxtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769681544; x=1770286344;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AJa7eQGWZbzucfOY/PWCQHeENsvDVajhwi4B2jpBWQE=;
        b=kf1WDyFrGG5XF/MZ2gCxjS9mSwnU5qcgmWfDAdrg/lxZAjQaGEuP0X6g6OQzlsMFyz
         VdUxGQfWDgTRyxnSx2O2EEuVy7ZNMWUHLvmsc2ScqDG6P5u8Sje+K2NnNrkS+W/46Mjg
         tYNZ3zqATT+RwotbeQzQn0mD6gt4ClubKXxmx6LEgN0JJMYujDf1rH43Zt1+tRAh7Mur
         etU382Gsm1KmUEsVy3aWB9bVz3hAO4piORwF8A2VFucTfHB37S+d+N5T8ExjEMESTNlc
         /42wh6+GYsFUgtaQH4/p/RDxx6yqIivcc7zLFWkl87lps9XoCzLmW6GoBy7r6/sKwyh5
         7xOw==
X-Forwarded-Encrypted: i=1; AJvYcCUUeNiZFe6E/Fq2R8DeTbYymTB9qrvYH00+kxFkYwqhtTH01xNNqHeaNOw9xmq1EVLKY/gpidaL3GpE7sKBZpg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/s77aDmMlscbzzCgKwx4M2KO0rKb8HsdwEWzqlcOMI/WlSZZo
	JBKhchZK+ArzliawuCVGPrCX2PI5njhsPLTB/WBgthzCllN7jP4K4gWm
X-Gm-Gg: AZuq6aJVKsl43+GAvT1cszSFGhHW8vWvBKw8DgcFiHT1oAOXIcGnIBlOGViWBLsFZpp
	KHDxFNDkIZdATrhMX9p601PAKlw22iWfCu2oGRsO6Alcp54wi9x9vDKNMY8wb/mc5yW328DxOLy
	2CIFrYKK8yTBPeKxW/eOW+iO3bPXcIVL1Wy7LaMLu3ylSmFnxAFKXnh9MWvjVR05XJw+IUU6EY3
	PlHUVld1cFVrqBNTmzcJ0QQmXvpEuhe41yD6BBKwGs7uT2Rx7gc8Asd2slR6g9jSxoj5KcFxueT
	cbf89fG/Z/V9lSxvj0SdTMdla0BGhBaSDcl0xgxfBsIYP96F1L00pqSL/IlTu0dxccGDLYxN9Op
	EqEZ2dEeQnCjn8weMiLmt9DZV5k7mZqeogM6pPsGcq0NPrxMK3mq6bfxfoY6yZaA3jH9vX+UXFu
	g=
X-Received: by 2002:a05:7022:6889:b0:11e:3e9:3e8b with SMTP id a92af1059eb24-124a00e8a82mr4376360c88.50.1769681543633;
        Thu, 29 Jan 2026 02:12:23 -0800 (PST)
Received: from gmail.com ([2a09:bac5:4e24:c8::14:2b2])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-124a9debe5dsm6246054c88.11.2026.01.29.02.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 02:12:23 -0800 (PST)
From: Qingfang Deng <dqfext@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH nf-next] netfilter: flowtable: dedicated slab for flow entry
Date: Thu, 29 Jan 2026 18:12:12 +0800
Message-ID: <20260129101213.74557-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The size of `struct flow_offload` has grown beyond 256 bytes on 64-bit
kernels (currently 280 bytes) because of the `flow_offload_tunnel`
member added recently. So kmalloc() allocates from the kmalloc-512 slab,
causing significant memory waste per entry.

Introduce a dedicated slab cache for flow entries to reduce memory
footprint. Results in a reduction from 512 bytes to 320 bytes per entry
on x86_64 kernels.

Signed-off-by: Qingfang Deng <dqfext@gmail.com>
---
 net/netfilter/nf_flow_table_core.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 06e8251a6644..e075dbf5b0ce 100644
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
 
@@ -812,9 +813,15 @@ static int __init nf_flow_table_module_init(void)
 {
 	int ret;
 
+	flow_offload_cachep = kmem_cache_create("nf_flow_offload",
+						sizeof(struct flow_offload),
+						NULL, SLAB_HWCACHE_ALIGN);
+	if (!flow_offload_cachep)
+		return -ENOMEM;
+
 	ret = register_pernet_subsys(&nf_flow_table_net_ops);
 	if (ret < 0)
-		return ret;
+		goto out_pernet;
 
 	ret = nf_flow_table_offload_init();
 	if (ret)
@@ -830,6 +837,8 @@ static int __init nf_flow_table_module_init(void)
 	nf_flow_table_offload_exit();
 out_offload:
 	unregister_pernet_subsys(&nf_flow_table_net_ops);
+out_pernet:
+	kmem_cache_destroy(flow_offload_cachep);
 	return ret;
 }
 
@@ -837,6 +846,7 @@ static void __exit nf_flow_table_module_exit(void)
 {
 	nf_flow_table_offload_exit();
 	unregister_pernet_subsys(&nf_flow_table_net_ops);
+	kmem_cache_destroy(flow_offload_cachep);
 }
 
 module_init(nf_flow_table_module_init);
-- 
2.43.0

