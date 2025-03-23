Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993FC202960;
	Sun, 23 Mar 2025 10:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742724574; cv=none; b=ui/hh0XCoCzrVz/BXjM9MyDkv5cMgjSvvBcgB+EOtrMPCfZBsL0Vu7ze8hXQd97zfaQHx3Wss0eYvKqS9jta3PjaZBWVZHEfR+8k9WfcTg39fJ89U618iZMmvIHsG94yLmYLFWmknjUOySBEu/2Mo7/wVl5Q8g08MoXUgOYXsdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742724574; c=relaxed/simple;
	bh=7QkvyVWfkvcKoHD03Ld5JEn6xNCnCPkjuGUzo5KLVMk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uzJTY5tjuis91wom07/k9WVf+sKypIrqs9lFTCKbHl0DQ41qV5yQj/QhaDGNy64p+WBUd90t4bHnFmai04ogndaOADRtF9tPAUZTfpzhpuAeRv+10m7it6k9wSPHEuC6ptEjx6cPfT8aVoUbHjmA6YK7hXg2nnN7sfi+ENQ8/H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Q/qvOsRp; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FVcx9vhA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Q/qvOsRp";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FVcx9vhA"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id EBC526039A; Sun, 23 Mar 2025 11:09:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742724570;
	bh=Jrj1Vudvlv3gJxIDFeWNyBbhMb72tRZRUB+3BFHOJRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q/qvOsRpsk5NM4Od/i02pGrMGChSeBAFh4OQ9Amm2Kjen6fuMSKwaN2nsppWFfnyJ
	 MMvUq6gp3kjW00Sc1wDILUhAdMydnfOx9JGeEb8wES0o52kaM4oEc67MGeJ1cdS+Z9
	 PFTIKAoyibVPoNteZGIYRxLqXYD66YXjQQGBhBQzvQIlwrjad/x/IwC03/mIRa31W0
	 mJK8cGY6ws6GKIcw2iIjeh0r2VLjzuXFteOIsEVmsBsvG5WkMx5pWvByrjWfMIduex
	 /HfyRma385edCO2GLZQZ6+QgX+omikVgwPTRqpJU397ThJAI3VvzDxarBMi88m8Arw
	 W1DrYRFBiDYoQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4B2F360386;
	Sun, 23 Mar 2025 11:09:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742724567;
	bh=Jrj1Vudvlv3gJxIDFeWNyBbhMb72tRZRUB+3BFHOJRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FVcx9vhARl65FYppfRLuIiUsIXKclNztobhGK+SOU4w839Gn2tJgNKwF9PBA6yLIU
	 cvKdGD8fAcMFJZtaWKtXpFP9114yEZmY1oNm815ETtYJnvC9+sksZ02b79AmWnWnT1
	 ExK5POurvGWaaPu8th4laLW+aJ2Qn+d8VJZ0GFPWW8LD6bQhDz0zi92t7EQF51hei+
	 440dwJL3QA/TvJxufrCrwW1jpFxhguZm46POmz+MYTZb3xTHGehN3hbcZV9lLn6JKm
	 ZGewoUjVS6ElVLZWNFL2srUIBU4R6JTHALf3MFvo0fNsN1AldCaXMzRPBiHyL5Xcdg
	 7H+Fnz0x9wdCA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 1/7] netfilter: xt_hashlimit: replace vmalloc calls with kvmalloc
Date: Sun, 23 Mar 2025 11:09:16 +0100
Message-Id: <20250323100922.59983-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250323100922.59983-1-pablo@netfilter.org>
References: <20250323100922.59983-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Denis Kirjanov <kirjanov@gmail.com>

Replace vmalloc allocations with kvmalloc since
kvmalloc is more flexible in memory allocation

Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_hashlimit.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index fa02aab56724..3b507694e81e 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -15,7 +15,6 @@
 #include <linux/random.h>
 #include <linux/jhash.h>
 #include <linux/slab.h>
-#include <linux/vmalloc.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/list.h>
@@ -294,8 +293,7 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
 		if (size < 16)
 			size = 16;
 	}
-	/* FIXME: don't use vmalloc() here or anywhere else -HW */
-	hinfo = vmalloc(struct_size(hinfo, hash, size));
+	hinfo = kvmalloc(struct_size(hinfo, hash, size), GFP_KERNEL);
 	if (hinfo == NULL)
 		return -ENOMEM;
 	*out_hinfo = hinfo;
@@ -303,7 +301,7 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
 	/* copy match config into hashtable config */
 	ret = cfg_copy(&hinfo->cfg, (void *)cfg, 3);
 	if (ret) {
-		vfree(hinfo);
+		kvfree(hinfo);
 		return ret;
 	}
 
@@ -322,7 +320,7 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
 	hinfo->rnd_initialized = false;
 	hinfo->name = kstrdup(name, GFP_KERNEL);
 	if (!hinfo->name) {
-		vfree(hinfo);
+		kvfree(hinfo);
 		return -ENOMEM;
 	}
 	spin_lock_init(&hinfo->lock);
@@ -344,7 +342,7 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
 		ops, hinfo);
 	if (hinfo->pde == NULL) {
 		kfree(hinfo->name);
-		vfree(hinfo);
+		kvfree(hinfo);
 		return -ENOMEM;
 	}
 	hinfo->net = net;
@@ -433,7 +431,7 @@ static void htable_put(struct xt_hashlimit_htable *hinfo)
 		cancel_delayed_work_sync(&hinfo->gc_work);
 		htable_selective_cleanup(hinfo, true);
 		kfree(hinfo->name);
-		vfree(hinfo);
+		kvfree(hinfo);
 	}
 }
 
-- 
2.30.2

