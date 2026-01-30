Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6ADC309F18
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Jan 2026 07:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769757738; cv=none; b=pLCubxkJlRX66QExJx2/lus5BPYibb1Htc209xjhImwmudJ9eUqhBmUHcNkUchI6p4DaBfcz/ufQmvEOcYpNV2td6z6qrAfd7kniAX6JcOWdGBxk6GntsZv7qktNYJq7XECHiEsM0fI9FOQlhgPL+xGfR9BjkK+8iJmjUYpvkdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769757738; c=relaxed/simple;
	bh=scpHbiU85fPKFr3iZ5a8B06uHXcjdSPXniUbJsWoh5k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Yk+vKc18tM/y+/p7Gxc9k/g4so3K+YVCxzoZ6blcHDgGr9OYXGahoiO6ioVPLGXXp5vFhVmGIyQvzDxQpF8XuaCyNQ2C6b3XgJZx75Rpr3h5SBjambrujP7uduD8CzDbxNCJo+ZCDxABGMKajPYQwwoWyVK2dGDEzj5xOtOzzGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cQwmQm6L; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cQwmQm6L"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-64c893f3a94so4394583a12.0
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jan 2026 23:22:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769757735; x=1770362535; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0lV1Eb14MHHXl34cLNbbdByp1XdnJD9vp/7a+55/aDk=;
        b=cQwmQm6LdQ1GoFYIID9LxpBt35vzfmqsXTxMsjgNifnTTB8MKJkO5cNjTlhfURddro
         i5N4Pc8XW/1UNczzgir44OOAqTbquBFnP4+jXujj5gwFwyteKtFIgWTgbmS5OjzsxmZ1
         cJBS5Xuc8cdpLglFNrwqc7n/1u20mejI+dfH1z7HOAz06ovruXlBfIuuKPJYiR/RerEy
         Oj25silYh+WS7PYNLwJLB2l4SsBajrO7bybZ9qvFeFrdjj+WFHFQ9HcLNFcMHUZZcMym
         tFEPpIzffyNFYjb4sOudbEqhum7T+yi1Yejpn+1NW6bSF1PF1WRYC4yeAnVLly3vmWku
         9mvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769757735; x=1770362535;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0lV1Eb14MHHXl34cLNbbdByp1XdnJD9vp/7a+55/aDk=;
        b=IX2cfhJ/OTqe6fjPrgUQCGtM/Zv9BBf35DPH2zsgCbFe/O9OTFp4jLwLQnE9h5rIjg
         QnImaF99ztk1sflcKcKQhJAgYY6ebDAOCvmpanoHTvKkhrzlmOFR+8RyuMztKpKy9Ghe
         qNlGB4jUhkaQ9P8U7PVEb0pH2tbrW3MrVvTneOgX5G7aFti5X+mF0T+VeG+VO+THyJ0v
         jST3a5MobH9LIJiwyHgGFEs1LabJSPxzhSRRt8Qg+F0ApG1FsNz53kpfd7GOIHJI729+
         gzN4Pj/8bE321QqKuUvSzEOec0wr4IQ0MLULTbw0iOyEyaV8N7uhpyHbwj6PVBsyj+OH
         nSKQ==
X-Forwarded-Encrypted: i=1; AJvYcCV7gg8MQ9daPG9Pm7ScmLOH49hd/0JRS+A9hgIdZt41akthF0utsaPiu6bpSLRyk75ngNiwzs9LI21SDOWcAaQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1z6ggcuFOlHYMn0MIMaM+h+78iLqyN1NReBsTX0hUZgPqDRNv
	KydnEB6IE2bghrHsh04fxvkObWqk0W8JOGYzDKZAxqG5+AsaSPCMDjbT
X-Gm-Gg: AZuq6aKUN2Swifo4ewDAw+V+IT1Jzw/bEOCo3CRMiWp9qSAcnf3eDfUKPUvJfq/aC8R
	MOIj7pR1W1I+F6vikYJFCbxMnNtccgK23nJxWS2Br5hr+2HAls8H6cAYmdMZvG9Vr0hlQ2D0jtC
	52Ypxye02dlpvLDgn2FXqU18kNORAaBcZ8PANU7+z39DFTo9f1f+McZjKWccjgWyCn81oGWwbGk
	1UeCcuTS27nyXSBOMAB1Wg9vY/PYKYRk4B8JUt4ivwp2SBi1JDqv8aRLmIQPDWWWllufL4nc46P
	/jokyVscwBk/Acf5qwNrVF2VJ5e2WoyG4+O8h/XwhkXseYIb5n2CM5Cr425eJWFnCxcZP0CZUj0
	CU4dG1FG2Yz8hQ27GEDeWxUnKCP90H3jIAP0vnK3veXzlfTIEWdxDvVpKTHf6MRPQrOU=
X-Received: by 2002:a17:907:9805:b0:b87:7430:d5e2 with SMTP id a640c23a62f3a-b8ddf85c0a2mr331985166b.12.1769757734675;
        Thu, 29 Jan 2026 23:22:14 -0800 (PST)
Received: from gmail.com ([2a09:bac5:4e22:2e3c::49b:47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8dbf2f3e33sm379318466b.71.2026.01.29.23.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 23:22:14 -0800 (PST)
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
Subject: [PATCH nf-next v2] netfilter: flowtable: dedicated slab for flow entry
Date: Fri, 30 Jan 2026 15:22:07 +0800
Message-ID: <20260130072208.108345-1-dqfext@gmail.com>
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
v2: use KMEM_CACHE macro
  - https://lore.kernel.org/netfilter-devel/20260129101213.74557-1-dqfext@gmail.com/

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
2.43.0

