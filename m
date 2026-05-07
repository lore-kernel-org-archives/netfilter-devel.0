Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05E23B893A;
	Thu,  7 May 2026 13:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778161140; cv=none; b=fQItjFDkHgHs4ZljjUoEDSzjXdJHkluwnf604ce48q9FuDeuL4ikxERfoeajuNZZrt1q1fJg33ulEuKFN3SIt9svh3fdATc1egYGMXH9fngmdz+7uDQdHoglahW4xVmu7dOPjD140fn8OQ/UxMbOX0JjF9chmfgxOG8vLOCgzAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778161140; c=relaxed/simple;
	bh=kUgJmL/GAPlg8Lm7wTNxGGcekfOVXdbOcH3b88ZNNV0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kLrBQdeyonn7XdOMjykYuawSH17A2IQqZseuRq2a03JFqP/mpVLVLjM6iSMjgwhOpeEduwcGhWfaPMkRGzNsQqjPPkg8AVogOEZglEzp3x8nKbw+heRsgKe5WpaE+yxHNVRnHbS4WatL5lcYaFIUSn6q2yzomWP/+lXx39DNQUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=h+eSMKlW; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="h+eSMKlW"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=x6aYXSkDMxsfxRvjT+JWwxZLyvgj/tSbFyzDgWDtwqg=;
	b=h+eSMKlWt3zvKVmHKnPYNe98y/hii2BmLlYP3voXPA49G8hOdq9h8mmmpSZKIna1RGhCf81lo
	8Td2RZi5UQy3nvQlKe78OJ67dHRCtGqQ2NzmEee9uRnp0T/r/AnkmWCSnG74xrR376Xsh1Wcntc
	bi2XM84CIcjA1YXWAj0fusM=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gBCpD4SDDznTXS;
	Thu,  7 May 2026 21:31:48 +0800 (CST)
Received: from kwepemj500018.china.huawei.com (unknown [7.202.194.48])
	by mail.maildlp.com (Postfix) with ESMTPS id BA328402AB;
	Thu,  7 May 2026 21:38:54 +0800 (CST)
Received: from huawei.com (10.50.85.128) by kwepemj500018.china.huawei.com
 (7.202.194.48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 7 May
 2026 21:38:54 +0800
From: Li Xiasong <lixiasong1@huawei.com>
To: <netfilter-devel@vger.kernel.org>
CC: <stable@vger.kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>, Florian
 Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, <coreteam@netfilter.org>,
	<yuehaibing@huawei.com>, <zhangchangzhong@huawei.com>,
	<weiyongjun1@huawei.com>
Subject: [PATCH nft v2 1/2] netfilter: nf_conntrack_sip: get helper before allocating expectation
Date: Thu, 7 May 2026 22:04:22 +0800
Message-ID: <20260507140423.3734545-2-lixiasong1@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260507140423.3734545-1-lixiasong1@huawei.com>
References: <20260507140423.3734545-1-lixiasong1@huawei.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemj500018.china.huawei.com (7.202.194.48)

process_register_request() allocates an expectation and then checks
whether a conntrack helper is available. If helper lookup fails, the
function returns early and the allocated expectation is left behind.

Reorder the code to fetch and validate helper before calling
nf_ct_expect_alloc(). This keeps the logic simpler and removes the leak
path while preserving existing behavior.

Fixes: e14575fa7529 ("netfilter: nf_conntrack: use rcu accessors where needed")
Cc: stable@vger.kernel.org
Signed-off-by: Li Xiasong <lixiasong1@huawei.com>
---
 net/netfilter/nf_conntrack_sip.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 1eb55907d470..58fce6242f89 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1366,6 +1366,10 @@ static int process_register_request(struct sk_buff *skb, unsigned int protoff,
 		goto store_cseq;
 	}
 
+	helper = rcu_dereference(nfct_help(ct)->helper);
+	if (!helper)
+		return NF_DROP;
+
 	exp = nf_ct_expect_alloc(ct);
 	if (!exp) {
 		nf_ct_helper_log(skb, ct, "cannot alloc expectation");
@@ -1376,10 +1380,6 @@ static int process_register_request(struct sk_buff *skb, unsigned int protoff,
 	if (sip_direct_signalling)
 		saddr = &ct->tuplehash[!dir].tuple.src.u3;
 
-	helper = rcu_dereference(nfct_help(ct)->helper);
-	if (!helper)
-		return NF_DROP;
-
 	nf_ct_expect_init(exp, SIP_EXPECT_SIGNALLING, nf_ct_l3num(ct),
 			  saddr, &daddr, proto, NULL, &port);
 	exp->timeout.expires = sip_timeout * HZ;
-- 
2.34.1

