Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022D219FA90;
	Tue, 27 Aug 2024 09:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724752575; cv=none; b=S2R2m3R8uq8QGc0FHNGUuo6kFy3sJmsL/Qw0dvqJe9pQdSQDqy8Bi+0jQ25wI3Ts+1jMPaKv1YGyVySDqIWFWkY0BZLYJfMdNHElb8I1n0Uo6XY+jd5DubesxSzq4tOwCeJErSyihN65g9G2fgywDiNzzwPH4uZt5VwwOIn5uYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724752575; c=relaxed/simple;
	bh=qpfKZaFPy1rFBJJEv+3AoCtQ8MPb5ZJY/rFUAhGq7f0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OrZBDc1roLYucIVijP/HEoOLDILnMJoIC1rKqL6CHIdN1Ilk4cYjvUSq7wKWDuLl+EoI7dqrY81KU6kYrx1oeWWO/OgE8gu62skOkWl3+wF22yI61uQPdo4iT+JzogcFKBR4W7LO2cBETlJTqBDuU6XSbFneGCLdTcOeIbNVATE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4WtNGT1HH3z1S99F;
	Tue, 27 Aug 2024 17:56:01 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id B9ECD1401F4;
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
Subject: [PATCH net-next 3/5] net/netfilter: make use of the helper macro LIST_HEAD()
Date: Tue, 27 Aug 2024 18:04:05 +0800
Message-ID: <20240827100407.3914090-4-lihongbo22@huawei.com>
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
 net/netfilter/core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index b00fc285b334..93642fcd379c 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -655,10 +655,8 @@ void nf_hook_slow_list(struct list_head *head, struct nf_hook_state *state,
 		       const struct nf_hook_entries *e)
 {
 	struct sk_buff *skb, *next;
-	struct list_head sublist;
 	int ret;
-
-	INIT_LIST_HEAD(&sublist);
+	LIST_HEAD(sublist);
 
 	list_for_each_entry_safe(skb, next, head, list) {
 		skb_list_del_init(skb);
-- 
2.34.1

