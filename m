Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DD2317715
	for <netfilter-devel@vger.kernel.org>; Thu,  7 May 2026 13:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778161140; cv=none; b=QdLt/heed5HvIZkn2qLqd936HZqOxvR3EFUd+RtRcGvifskboHIJF6Xbot54BNqO06kfi+PySnk+whyZTuGj+IuJcyCNbQDHfhrEZUhVM4Od2UHtIeCNKuuKFqGINqn6zcDGoZ0k70HUwrJwrfTu9WuKd8kOr/rMELhKzyh+aqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778161140; c=relaxed/simple;
	bh=yGy4Wwi7es9iLVKBZoDvlzxaFM+IwPuLgPmhLgdjWCQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WYZ6Tp0EU7ojDZZe/O+Aun68sIkq+PUmgE6lXR70AGXqSIeaBAbds3bVQOgkmh5iRyZFWSkHalVHuSwmxGzhJlP9P9ZvH9G30CwZ4jlzk/FmHsFHnnv/dUuVuMYqDU1GWfTaIXXebwQqqt4xcqJJch5x8c8JJ4iMqiV7CsN+1zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=wWB6YGPh; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="wWB6YGPh"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=baYHPUHTTdZ8AvIrILDW5xP5cVQjBwpw+fctcTzu+n4=;
	b=wWB6YGPhaXYeARlu3KOVN3NOKNmPbDrx6CV9sQVT8Dadd/6EOdsBVs/bTIUfHYyADlhpAMmBD
	Fuec4AOoU5f+tLV0fj7xPTSLt0DFBpCfiDA0W/1hXWb1lpNJt5YK/DqAZaJbebsxP1/8EaGOFRU
	5jfqFkcVEPb5v8aOR1ZUMWU=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4gBCnk1bGDz1K970;
	Thu,  7 May 2026 21:31:22 +0800 (CST)
Received: from kwepemj500018.china.huawei.com (unknown [7.202.194.48])
	by mail.maildlp.com (Postfix) with ESMTPS id 5D65C402AB;
	Thu,  7 May 2026 21:38:54 +0800 (CST)
Received: from huawei.com (10.50.85.128) by kwepemj500018.china.huawei.com
 (7.202.194.48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 7 May
 2026 21:38:53 +0800
From: Li Xiasong <lixiasong1@huawei.com>
To: <netfilter-devel@vger.kernel.org>
CC: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>, <coreteam@netfilter.org>, <yuehaibing@huawei.com>,
	<zhangchangzhong@huawei.com>, <weiyongjun1@huawei.com>
Subject: [PATCH nft v2 0/2] netfilter: fix expectation reference leaks
Date: Thu, 7 May 2026 22:04:21 +0800
Message-ID: <20260507140423.3734545-1-lixiasong1@huawei.com>
X-Mailer: git-send-email 2.34.1
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

this series fixes two expectation reference leaks in netfilter.

The first patch simplifies SIP REGISTER handling by validating helper
availability before expectation allocation, removing an early-return
leak path.

The second patch adds a missing nf_ct_expect_put() in nft_ct expectation
object evaluation to balance the allocation reference.

Changes in v2:
  - Patch 2/2: in process_register_request(), check helper before
    nf_ct_expect_alloc() as suggested.

Link to v1:
  - https://lore.kernel.org/netfilter-devel/20260506121618.578443-1-lixiasong1@huawei.com/

Li Xiasong (2):
  netfilter: nf_conntrack_sip: get helper before allocating expectation
  netfilter: nft_ct: fix missing expect put in obj eval

 net/netfilter/nf_conntrack_sip.c | 8 ++++----
 net/netfilter/nft_ct.c           | 2 ++
 2 files changed, 6 insertions(+), 4 deletions(-)

-- 
2.34.1

