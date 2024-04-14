Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892F91C687;
	Sun, 14 Apr 2024 04:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713070623; cv=none; b=D3pQ0Umo1FiYx2CwElo5pnRpsQBX9zEDRDPyta+qgpXVoVv+OLaCT8Ek3iZfvglFSIbkj40sLeUGPlwXfNcn7s74DKSrXEXKPXmNs0VGXisCgLZ95vE+T78aKB52E3FKTtPLhBSpPWiWlVGfy1ny/tFCQ0Jx9aafsAHGXc5cod0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713070623; c=relaxed/simple;
	bh=W/GMN2CX8wOoXL64K7+LKTqWiSBk8VTWUAe1hPB9zP0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cTorYkV+xxaXWeuzKLcZ7/qN+j+8XRN6dAVhqnUK3XboQE3oyjTGenEdwsFrLuzIj+/BZsjiVGm/ceAulCM67TRrG6WY8A2sCmyisSRoiWk+4hDuz9XjqBx/spWCiyAZMtuIyCX+KiXOwaeQM5Www0UtsKiOVNlRKVwqVSySHMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4VHHyw281qz1ynT8;
	Sun, 14 Apr 2024 12:54:32 +0800 (CST)
Received: from dggpeml500026.china.huawei.com (unknown [7.185.36.106])
	by mail.maildlp.com (Postfix) with ESMTPS id 17A551A0172;
	Sun, 14 Apr 2024 12:56:52 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Sun, 14 Apr
 2024 12:56:51 +0800
From: Zhengchao Shao <shaozhengchao@huawei.com>
To: <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
	<netdev@vger.kernel.org>, <pablo@netfilter.org>, <kadlec@netfilter.org>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>
CC: <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
	<shaozhengchao@huawei.com>
Subject: [PATCH net-next] netfilter: nft_chain_filter: remove redundant code in nf_tables_netdev_event
Date: Sun, 14 Apr 2024 13:02:51 +0800
Message-ID: <20240414050251.3923028-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500026.china.huawei.com (7.185.36.106)

Since commit d54725cd11a5("netfilter: nf_tables: support for multiple
devices per netdev hook") has been merged, nft_netdev_event only process
events of NETDEV_UNREGISTRATION type. Therefore, nf_tables_netdev_event
can directly return events of non-NETDEV_UNREGISTRATION type.

Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
 net/netfilter/nft_chain_filter.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index 274b6f7e6bb5..22057df9bbdc 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -365,8 +365,7 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 		.net	= dev_net(dev),
 	};
 
-	if (event != NETDEV_UNREGISTER &&
-	    event != NETDEV_CHANGENAME)
+	if (event != NETDEV_UNREGISTER)
 		return NOTIFY_DONE;
 
 	nft_net = nft_pernet(ctx.net);
-- 
2.34.1

