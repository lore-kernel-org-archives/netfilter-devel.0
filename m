Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359692C181;
	Thu,  7 May 2026 13:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778161140; cv=none; b=RwVfwpkuMmaddssU0KXW+wXJXPgyt1j2nTeLpBrarCysuVYdYF6s653K4mtwBPp8cYZNcNDko9VItrdQ0FpZt+6AmVddiQbOWgH1CO97w4J+0c+gjRIL5kupRL+cq1ClxUEe1G3E9uTE0tmKc24+eulhyn/D+BJdzBOOxBn4V+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778161140; c=relaxed/simple;
	bh=1jjyzn/wfmqboTm8tQQkfuG/UP+xXoIksMAk0d4wq5k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PUrNUh0kexplLV0IiaftUu/1NVMib8Lj3cvvIIKdEfvDWymFbDqczN0BrAblKzIYDRaAPrHPrkkv/M0MIk6BL8m1gU0NyzLEFlc/qvWEPUqIUPWKdDhjP3eI8BIEXMz28iLZirV0hc/sQApbhukzQ74J3X80kngg8a2bN/m9Jp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=ixOHXYOe; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="ixOHXYOe"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=606UbMcorULUuW0bd3DLo8nq4xbJ/M8vcj6aLLrlzFE=;
	b=ixOHXYOeybb23DYy1jvKoyD1Lj7nFaTY1O5yDh45TdjM2pPNJedy3Qj6qys+XKlQ1qOJzuXkG
	0QBEBeBSE5xa2gPoqNrHO1tPYeFlw6Q0WO/wcgbVKvWaksTwuXg9rdFl9gJChmNFs7zaRKKNFuD
	4zYrWqbdOKFh2JyQ/1IE7bM=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4gBCpB3sX5z12LFZ;
	Thu,  7 May 2026 21:31:46 +0800 (CST)
Received: from kwepemj500018.china.huawei.com (unknown [7.202.194.48])
	by mail.maildlp.com (Postfix) with ESMTPS id 1BC8F40576;
	Thu,  7 May 2026 21:38:55 +0800 (CST)
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
Subject: [PATCH nft v2 2/2] netfilter: nft_ct: fix missing expect put in obj eval
Date: Thu, 7 May 2026 22:04:23 +0800
Message-ID: <20260507140423.3734545-3-lixiasong1@huawei.com>
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

nft_ct_expect_obj_eval() allocates an expectation and may call
nf_ct_expect_related(), but never drops its local reference.

Add nf_ct_expect_put(exp) before return to balance allocation.

Fixes: 857b46027d6f ("netfilter: nft_ct: add ct expectations support")
Cc: stable@vger.kernel.org
Signed-off-by: Li Xiasong <lixiasong1@huawei.com>
---
 net/netfilter/nft_ct.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 60ee8d932fcb..fa2cc556331c 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1334,6 +1334,8 @@ static void nft_ct_expect_obj_eval(struct nft_object *obj,
 
 	if (nf_ct_expect_related(exp, 0) != 0)
 		regs->verdict.code = NF_DROP;
+
+	nf_ct_expect_put(exp);
 }
 
 static const struct nla_policy nft_ct_expect_policy[NFTA_CT_EXPECT_MAX + 1] = {
-- 
2.34.1

