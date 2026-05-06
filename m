Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57E633D6EE;
	Wed,  6 May 2026 11:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778068260; cv=none; b=Q6cqr4SQk3LIOP8jbp9HiJCrSlN2oFuRI00Xl8AJUjzLSeewe7u/BS76h5j24inXSWyesV26ONOnbMVRJOK5Oc7ycFRB3dQt82ND5OauzPEBOA/w/x2bg/UFxTWKb954bVE1nZ3jYUfJjqzY+ZfpzgR5aj38SZjVyjY8CAZ5Frk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778068260; c=relaxed/simple;
	bh=dVCC6nplAGCvCLgD2wqYm7/VvRoe1Qxe1i/PFRj/fEM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cS3pNaJ6TgaI1FpK3kX3yDl9K0wUeWGBF+HiyCaMTAqAiy8zRHlB7un9UAZohoUMRu83lPr6Ze+/k08tM7yO0AnzD9fedNLA8miRpnspuoGoZlq7XzaAT9f4+oboFPjfZyQmCGfyQYyKMFIVMtwjlhHey4V5WJ1CSmODT/VKJjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=vNJUxrlp; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="vNJUxrlp"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=t4mZah63AmKiaytxu5xDKCCL10cJNC4I6R1HIeajBhM=;
	b=vNJUxrlpYRqBDaf0yug8sNo4AiChGUYm/uXhk5dWm3Gn/JkYkF6AKBqNZegMZ5aj9FYMruukS
	kwxwUzESJCMxUgRQVytX8qeMKVy/AOF8RsSiTQCzRTh81DXZbQWN8b9hFxV6NzuVs1OrxnVvyB6
	oyavX2Y+lXxliO95dbkctD0=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4g9YRZ301LzLlTq;
	Wed,  6 May 2026 19:43:22 +0800 (CST)
Received: from kwepemj500018.china.huawei.com (unknown [7.202.194.48])
	by mail.maildlp.com (Postfix) with ESMTPS id D0C0640565;
	Wed,  6 May 2026 19:50:54 +0800 (CST)
Received: from huawei.com (10.50.85.128) by kwepemj500018.china.huawei.com
 (7.202.194.48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 6 May
 2026 19:50:54 +0800
From: Li Xiasong <lixiasong1@huawei.com>
To: <netfilter-devel@vger.kernel.org>
CC: <stable@vger.kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>, Florian
 Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, <coreteam@netfilter.org>,
	<yuehaibing@huawei.com>, <zhangchangzhong@huawei.com>,
	<weiyongjun1@huawei.com>
Subject: [PATCH nft 1/2] netfilter: nf_conntrack_sip: fix missing expect put in REGISTER path
Date: Wed, 6 May 2026 20:16:17 +0800
Message-ID: <20260506121618.578443-2-lixiasong1@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260506121618.578443-1-lixiasong1@huawei.com>
References: <20260506121618.578443-1-lixiasong1@huawei.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemj500018.china.huawei.com (7.202.194.48)

process_register_request() allocates an expectation, but the !helper
error path returns NF_DROP without nf_ct_expect_put(exp).

Add the missing put to balance nf_ct_expect_alloc() on this path.

Fixes: e14575fa7529 ("netfilter: nf_conntrack: use rcu accessors where needed")
Cc: stable@vger.kernel.org
Signed-off-by: Li Xiasong <lixiasong1@huawei.com>
---
 net/netfilter/nf_conntrack_sip.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 1eb55907d470..a895bc836e1b 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1377,8 +1377,10 @@ static int process_register_request(struct sk_buff *skb, unsigned int protoff,
 		saddr = &ct->tuplehash[!dir].tuple.src.u3;
 
 	helper = rcu_dereference(nfct_help(ct)->helper);
-	if (!helper)
+	if (!helper) {
+		nf_ct_expect_put(exp);
 		return NF_DROP;
+	}
 
 	nf_ct_expect_init(exp, SIP_EXPECT_SIGNALLING, nf_ct_l3num(ct),
 			  saddr, &daddr, proto, NULL, &port);
-- 
2.34.1

