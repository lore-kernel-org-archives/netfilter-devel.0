Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C45F9DF
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Apr 2024 13:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711978505; cv=none; b=UU030OlEkAOdW4oLYRmaI1cKC2kA2Bk5dLDJeW8mShMLzicbhh0zHeQo1D3KoHPKoKuNeksAFtKTNMZASIJw7D94XluKTQgdjr3L5X83NWJWc1y4DUEFpCxJAZWtwg4FlBeq+S6gpbutlpxKtiB7ouhDMo0chRjylhgQVn/VE5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711978505; c=relaxed/simple;
	bh=u6V5E4SbThycSuKMSXziFcLRO3Bx4LklUGtzOek22QE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ryRwy7gF/8fOHdKO6/bEj/jin33jEWvgDDFbl7cca1U7bx5RY7SolZLqevHRiIrXwCl0gE8VH5HF6snluV/oakMLGe9DyV7BHUQXgtUbFwEjQKvU2nRBA6WzGoREQZsdf37ovdhYiiASgoK5Cf291azbXrnt/tPFChWwHjgPkH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4V7X4J1wbfz1h5DC;
	Mon,  1 Apr 2024 21:32:16 +0800 (CST)
Received: from canpemm500006.china.huawei.com (unknown [7.192.105.130])
	by mail.maildlp.com (Postfix) with ESMTPS id 289251402D0;
	Mon,  1 Apr 2024 21:35:00 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 1 Apr 2024 21:34:59 +0800
From: Ziyang Xuan <william.xuanziyang@huawei.com>
To: <pablo@netfilter.org>, <kadlec@netfilter.org>,
	<netfilter-devel@vger.kernel.org>
Subject: [PATCH nft] netfilter: nf_tables: Fix pertential data-race in __nft_flowtable_type_get()
Date: Mon, 1 Apr 2024 21:34:55 +0800
Message-ID: <20240401133455.1945938-1-william.xuanziyang@huawei.com>
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

nft_unregister_flowtable_type() within nf_flow_inet_module_exit() can
concurrent with __nft_flowtable_type_get() within nf_tables_newflowtable().
And thhere is not any protection when iterate over nf_tables_flowtables
list in __nft_flowtable_type_get(). Therefore, there is pertential
data-race of nf_tables_flowtables list entry.

Use list_for_each_entry_rcu() with rcu_read_lock() to Iterate over
nf_tables_flowtables list in __nft_flowtable_type_get() to resolve it.

Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/netfilter/nf_tables_api.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index fd86f2720c9e..fbf38e32f11d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8297,10 +8297,14 @@ static const struct nf_flowtable_type *__nft_flowtable_type_get(u8 family)
 {
 	const struct nf_flowtable_type *type;
 
-	list_for_each_entry(type, &nf_tables_flowtables, list) {
-		if (family == type->family)
+	rcu_read_lock()
+	list_for_each_entry_rcu(type, &nf_tables_flowtables, list) {
+		if (family == type->family) {
+			rcu_read_unlock();
 			return type;
+		}
 	}
+	rcu_read_unlock();
 	return NULL;
 }
 
-- 
2.25.1

