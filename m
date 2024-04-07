Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7C010A0E
	for <netfilter-devel@vger.kernel.org>; Sun,  7 Apr 2024 06:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712472985; cv=none; b=enjjyJCGYyDia9Xh60BAo6oiQloTQpCECTUFTEIKEb/My2WkSg7pTXScztJEhkmJWv21NHlRJLSGUVIVERV+LaHes2J652SFPEsgDWrNzhKbauzExlSoOY2qRlLTAmsLRMI1AGKuqkvVHhrdwgPizaGzl/E4zII2FGHYB0nW8vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712472985; c=relaxed/simple;
	bh=533itynMToTkvXTUNW1dSLJO6WXO8qEfpZnYBBv0T5g=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iYsGLLIawL6y/EKCPlS6hICzDnPCOXcN84IirUilQ228hq8gWwZ4XIeYUBJzij3RW1S4a8ehoLlqzOm9Af413sDOkJxUQrLB6OtxmM2EyBHek/W0I58mVGgJaNfa4PO85PFJub6zaWTnT/kFmraegsgh58l8zmeQvtAJ4vlIdik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4VC2zt11rvz1GG59;
	Sun,  7 Apr 2024 14:55:38 +0800 (CST)
Received: from canpemm500006.china.huawei.com (unknown [7.192.105.130])
	by mail.maildlp.com (Postfix) with ESMTPS id C636D14011F;
	Sun,  7 Apr 2024 14:56:20 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 7 Apr 2024 14:56:20 +0800
From: Ziyang Xuan <william.xuanziyang@huawei.com>
To: <pablo@netfilter.org>, <kadlec@netfilter.org>,
	<netfilter-devel@vger.kernel.org>
CC: <fw@strlen.de>
Subject: [PATCH nft 0/2] netfilter: nf_tables: Use rcu lock to enhance protection of the lists
Date: Sun, 7 Apr 2024 14:56:03 +0800
Message-ID: <cover.1712472595.git.william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500006.china.huawei.com (7.192.105.130)

nf_tables_expressions and nf_tables_objects lists can be concurrent
between type lookup and module unloading process. But there is not
any protection in type lookup process. Therefore, there is pertential
data-race of the lists entry.

Use rcu lock to enhance protection of the lists.

Ziyang Xuan (2):
  netfilter: nf_tables: Fix potential data-race in __nft_expr_type_get()
  netfilter: nf_tables: Fix potential data-race in __nft_obj_type_get()

 net/netfilter/nf_tables_api.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

-- 
2.25.1

