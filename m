Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951503822AF;
	Fri, 19 Jun 2026 11:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781870111; cv=none; b=pcwjtqtkOhXN8N4WN0nC8hvus0WpHwsGfGDb4GcLqqK8/4mOqOnibyXtTgyMc3MXBFgqUu/M0oK/fl74HK54LsvgNoKI0KXMTzppU7anl3Dio93ukrTWgcH6rftzbDQk5D9dKxRrSOQxlAzv3EmLi/7TzfFE6ETZCmW0CrLWWTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781870111; c=relaxed/simple;
	bh=6ube8aCnDGhsVWLD3B2L2+JpR7ui9bWBKs+rKc/OPMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ojIbRGlQe5u+UT9WrRnDryVFCIwF102Sl1SBRUh+KH5YfxV6VhMDjEL8MMpOpA2nubmC0NeJIhCh8dTsTTArLUePT08oy/bxaiAtnF/EPY5dVtpfdbc2k6srRwH5F1REaQ0qi9etntAXAOAQsbA7Y4YBKa3B1siBfKlXZNnkk1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vHenn4Jr; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vHenn4Jr"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6855A601A8;
	Fri, 19 Jun 2026 13:55:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781870102;
	bh=uWuuABX0tqyCSosK/9RXGrFwC2EEkpdFJ+6Epga9q+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vHenn4Jr9+DwewpImKjusVfmh8yFLz2R1lyJo6AcY0sVVJy+tdObpZjiHX76NzXJe
	 bQ4d7i+C7tNJnA44p2commHyez1KacjpQUSM+YkU3XFyRa3VzmRB0TRhWh27PoF63e
	 t/uYe0OYKFL+wMMNwT89nOIwMWvRWfrdfqpWfUK8wInbM8eKQDiExX4NNlGGhBSWcL
	 28UgM3mq5l4QdVFqdvRYOojClM4UEQaYLf2Tu2KliAa/swVhyWmu2WSBqmCIZwAUD5
	 Rt1Ei+EgEl/LspzzBOhnVa5BKWR0cBIV81XpG6xwg/Fza4HtMpdBDDM7KClBn+v9nV
	 Fsfdxrlf4Zzpg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 03/16] netfilter: xt_cluster: reject template conntracks in hash match
Date: Fri, 19 Jun 2026 13:54:38 +0200
Message-ID: <20260619115452.93949-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260619115452.93949-1-pablo@netfilter.org>
References: <20260619115452.93949-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wyatt Feng <bronzed_45_vested@icloud.com>

xt_cluster_mt() treats any non-NULL nf_ct_get() result as a fully
initialized conntrack and passes it to xt_cluster_hash().

This causes a state confusion bug when the raw table CT target attaches
a template conntrack to skb->_nfct before normal conntrack processing.
Templates carry IPS_TEMPLATE status but do not have a valid tuple for
hashing yet, so xt_cluster_hash() can hit its WARN_ON() path on the
zeroed l3num field.

Reject template conntracks before hashing them. This matches existing
netfilter handling for template objects and avoids hashing incomplete
conntrack state.

Fixes: 0269ea493734 ("netfilter: xtables: add cluster match")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:GPT-5.4
Signed-off-by: Wyatt Feng <bronzed_45_vested@icloud.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_cluster.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_cluster.c b/net/netfilter/xt_cluster.c
index 908fd5f2c3c8..eaf2511d63f0 100644
--- a/net/netfilter/xt_cluster.c
+++ b/net/netfilter/xt_cluster.c
@@ -107,7 +107,7 @@ xt_cluster_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	}
 
 	ct = nf_ct_get(skb, &ctinfo);
-	if (ct == NULL)
+	if (!ct || nf_ct_is_template(ct))
 		return false;
 
 	if (ct->master)
-- 
2.47.3

