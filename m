Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB5B348C42;
	Sat, 20 Jun 2026 22:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781994474; cv=none; b=cvV2b7lAFuQoMjcI5Xwqsv+tq2VUFt4VLzYWsOtjKeOdYfu+rHL1rCR8bb7MlHc14MJpSMeVdWQpA9zA5ivaPsXrmjD24rtgxC1tjTNPfgNVTLq/5npMFjfY7FYZ2m+Gxt5fTlkpuZmoJceTCXuB0rRzjvVykUVq4WHtZu/MIJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781994474; c=relaxed/simple;
	bh=6ube8aCnDGhsVWLD3B2L2+JpR7ui9bWBKs+rKc/OPMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tjZa6B0rLoZdJoM21cY4N+Ch/flJ0cpQz4E/NGDM50I4Oj4vkDZ0kNTZKNLdRBIQDXLfl05cXONxwMnGAYdbXJ8Hdld8IqfEMlbwJfGEgat/G0V5x+HJk3SM152wuowLvp2faKTqf8sl2hr116cGys0XVVQZ8UncbijH3yayFE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gFJCMenT; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gFJCMenT"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9EE8160196;
	Sun, 21 Jun 2026 00:27:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781994466;
	bh=uWuuABX0tqyCSosK/9RXGrFwC2EEkpdFJ+6Epga9q+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFJCMenTNPvGzpcGS+DRcwNmgRocCSexg1JnKl4lWrBz3+tmXies85e4ayzPvlhdG
	 L52UKvkC4wlLSSc3LJ3Dkm8xcbIeCOrwq5TIHXVVMVyNuWDPLqxjAMIp7I8v7LLXDO
	 Y/i/XPF2PcYHtJC8u/usXwFiOPq4MiPQmp0exW8CEkglmHowjUlonJL5FMsagKGHm7
	 8zdQGZa7JRtDaDatn3p2pTml4QqrWkDyTzy8SB+1LUb208HXurSXZv6js7BeOj7bv1
	 EFc+z5o+ehuDwvPiHzbkAkKGWK4hwkq1/pihJvJZTv2Qzih+zlyCGcHQFr/Ur2lkqX
	 rmUD1IlC+2AZw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 03/14] netfilter: xt_cluster: reject template conntracks in hash match
Date: Sun, 21 Jun 2026 00:27:27 +0200
Message-ID: <20260620222738.112506-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260620222738.112506-1-pablo@netfilter.org>
References: <20260620222738.112506-1-pablo@netfilter.org>
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

