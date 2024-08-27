Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B734D1A00E7;
	Tue, 27 Aug 2024 09:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724752576; cv=none; b=SujjXEw7BOKnEbsp0cewtutlTFS72dsSvhdio6PyU4dNr5vCNVY968CzDdvRFA2oh/YyywIIm96NhMCSdB8kFBUPFUlD+IDGRkJmhZ0RohQ/oqvoBJqkRcn+ueFmCBZSbtgGDuFJlNzXdB6BjEALzGnW85tsjbAYbdKhYXJLrUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724752576; c=relaxed/simple;
	bh=jdjjeOIxjalNo0zfMZ9TNLnx6O1TbDrwfH3pNbM8ro4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dzf8tQGFifuX+GRqjjw35A44Sk0fwGzZwsF2MjhnyzguR9FAHqBLnXyWck/acWAjXPjNJU6J1JEV2CoSdcaJXOr8NvbwaMN3o2xzmBATlTo7F6M9x3OLU+WX4wpo83s6gm4/OyN4BQXiKZoKEAPYRXwpYWGXtBHqQQ5FAH1NB8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4WtNGV0lVJz2Cndt;
	Tue, 27 Aug 2024 17:56:02 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 1B6AA1401F4;
	Tue, 27 Aug 2024 17:56:12 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 27 Aug
 2024 17:56:11 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <jmaloy@redhat.com>,
	<ying.xue@windriver.com>, <pablo@netfilter.org>, <kadlec@netfilter.org>
CC: <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
	<lihongbo22@huawei.com>
Subject: [PATCH net-next 5/5] net/core: make use of the helper macro LIST_HEAD()
Date: Tue, 27 Aug 2024 18:04:07 +0800
Message-ID: <20240827100407.3914090-6-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240827100407.3914090-1-lihongbo22@huawei.com>
References: <20240827100407.3914090-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)

list_head can be initialized automatically with LIST_HEAD()
instead of calling INIT_LIST_HEAD(). Here we can simplify
the code.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 net/core/dev.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 0d0b983a6c21..b0b660c90cb9 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5726,10 +5726,9 @@ static void __netif_receive_skb_list_core(struct list_head *head, bool pfmemallo
 	struct packet_type *pt_curr = NULL;
 	/* Current (common) orig_dev of sublist */
 	struct net_device *od_curr = NULL;
-	struct list_head sublist;
 	struct sk_buff *skb, *next;
+	LIST_HEAD(sublist);
 
-	INIT_LIST_HEAD(&sublist);
 	list_for_each_entry_safe(skb, next, head, list) {
 		struct net_device *orig_dev = skb->dev;
 		struct packet_type *pt_prev = NULL;
@@ -5867,9 +5866,8 @@ static int netif_receive_skb_internal(struct sk_buff *skb)
 void netif_receive_skb_list_internal(struct list_head *head)
 {
 	struct sk_buff *skb, *next;
-	struct list_head sublist;
+	LIST_HEAD(sublist);
 
-	INIT_LIST_HEAD(&sublist);
 	list_for_each_entry_safe(skb, next, head, list) {
 		net_timestamp_check(READ_ONCE(net_hotdata.tstamp_prequeue),
 				    skb);
-- 
2.34.1

