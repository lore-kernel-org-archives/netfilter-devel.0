Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A614B1FC8;
	Tue, 24 Jun 2025 01:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750728432; cv=none; b=giYzR3dNvPYj8fqnW4ZZyhrM5eiGqOq8n0s9ZlLYdKT3XSttv8eMuN5ryPiVvFloeOnFUJ6MC7oYfgdHPDx6ofdtFdn8EUs58SJrpju+Jnvy1H3G8lfhNoROq1gIvybtD3fTnHKAdIK06nzGVq1vFXlBSUBaWeFwQxI6a27+2t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750728432; c=relaxed/simple;
	bh=fBtxcZ7KMES+AZ3RMX7I7JpObBGSwEBH1l98Sl1mQ0g=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Sbw4KAtNRx8vHyEToRVE5aPUm/ZkheTJ9JXqledto32nVqav+FXX3sk1Xii73KLjoZawOtSwA8V9r2Cng7Y5uDTbUDa2rtFV4ucaLBjWPqk6ZOJn+/2H3zey1mgzuso5xqhYuhFcmO4q59nwypBWwZExujOWlH5zc7nuQ12xD0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4bR6j14xLgztRqp;
	Tue, 24 Jun 2025 09:25:57 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 0DA121401E9;
	Tue, 24 Jun 2025 09:27:07 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpemf500002.china.huawei.com
 (7.185.36.57) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 24 Jun
 2025 09:27:06 +0800
From: Yue Haibing <yuehaibing@huawei.com>
To: <pablo@netfilter.org>, <kadlec@netfilter.org>, <kuba@kernel.org>,
	<yuehaibing@huawei.com>
CC: <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] netfilter: x_tables: Remove unused functions xt_{in|out}name()
Date: Tue, 24 Jun 2025 09:44:32 +0800
Message-ID: <20250624014432.3708190-1-yuehaibing@huawei.com>
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
 dggpemf500002.china.huawei.com (7.185.36.57)

Since commit 2173c519d5e9 ("audit: normalize NETFILTER_PKT")
these are unused, so can be removed.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
 include/linux/netfilter/x_tables.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index f39f688d7285..77c778d84d4c 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -51,21 +51,11 @@ static inline struct net_device *xt_in(const struct xt_action_param *par)
 	return par->state->in;
 }
 
-static inline const char *xt_inname(const struct xt_action_param *par)
-{
-	return par->state->in->name;
-}
-
 static inline struct net_device *xt_out(const struct xt_action_param *par)
 {
 	return par->state->out;
 }
 
-static inline const char *xt_outname(const struct xt_action_param *par)
-{
-	return par->state->out->name;
-}
-
 static inline unsigned int xt_hooknum(const struct xt_action_param *par)
 {
 	return par->state->hook;
-- 
2.34.1

