Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D58719FA86;
	Tue, 27 Aug 2024 09:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724752575; cv=none; b=oElIbGe0WVEcykZ23proRyz+L3WSbeYIUrcclU6K773WeusTvGzGGV9tjfX9by+inBg4vtO96rfvt+yQbXX+Bc5fkRZk2WSWujytLrlUCWolwnhhpHQQVVt0Ta4d+G/byTlhviZcXO1TwEqCyCVyM8yFGjm7QDwQPysBzSBi2WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724752575; c=relaxed/simple;
	bh=/ccHUHyNp8wFv9njEhp4jo7AI1ResrGAiFUOk9+Tzro=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F5xBYEQVL/lWCaUC83fBrX4n0oSz8jesNmhKKp01IbX94G995Fl8TC2nG4RBEvABgiV0c4kbdVtED4vHqK6k2fOX1ejcyQtNwA6LxMoAii/SocuHq5P3SQCd9Her3USmC2M0ZM8cqMoUwExqUYI2aKCHA0C+nkVv/mIOZn1v05w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4WtN965ZcXzQqtR;
	Tue, 27 Aug 2024 17:51:22 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 6B203180064;
	Tue, 27 Aug 2024 17:56:11 +0800 (CST)
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
Subject: [PATCH net-next 1/5] net/ipv4: make use of the helper macro LIST_HEAD()
Date: Tue, 27 Aug 2024 18:04:03 +0800
Message-ID: <20240827100407.3914090-2-lihongbo22@huawei.com>
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
 net/ipv4/ip_input.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index d6fbcbd2358a..b6e7d4921309 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -596,9 +596,8 @@ static void ip_list_rcv_finish(struct net *net, struct sock *sk,
 {
 	struct sk_buff *skb, *next, *hint = NULL;
 	struct dst_entry *curr_dst = NULL;
-	struct list_head sublist;
+	LIST_HEAD(sublist);
 
-	INIT_LIST_HEAD(&sublist);
 	list_for_each_entry_safe(skb, next, head, list) {
 		struct net_device *dev = skb->dev;
 		struct dst_entry *dst;
@@ -646,9 +645,8 @@ void ip_list_rcv(struct list_head *head, struct packet_type *pt,
 	struct net_device *curr_dev = NULL;
 	struct net *curr_net = NULL;
 	struct sk_buff *skb, *next;
-	struct list_head sublist;
+	LIST_HEAD(sublist);
 
-	INIT_LIST_HEAD(&sublist);
 	list_for_each_entry_safe(skb, next, head, list) {
 		struct net_device *dev = skb->dev;
 		struct net *net = dev_net(dev);
-- 
2.34.1

