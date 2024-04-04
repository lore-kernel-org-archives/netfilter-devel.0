Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4C0980C15;
	Thu,  4 Apr 2024 10:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712227428; cv=none; b=umHIHnjyTOm5lwnagM6ox2NktPI95EHMsfB64/4og5uiy4vbZ/SNZa9N6i++6lb//Vmn3LyosKAWAksoX2Qc7nNA/QCvINiWetjGv9ipPDLGL3MW7NJMZhrFAuhtJZF9qU/EsyZ5jfFImDWYYPbj59L4Y2NRv7V8NrpkS56kO48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712227428; c=relaxed/simple;
	bh=KvhShJYyNB7S21kOegxaR5NH0sG3z8wdMAX5kevj4IE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tDnjvxiVCi6ggOxsMGZLXSeRVe6EhofH4msPaWkRpeNybIx0VOxVFHXkHCacjbxkftT+OL624Qs2lQDyvCUKr9HCwOwMI13CWSTvu3W3UQY5mTkK4VI3FsQAbw6wLkYALVgH0CRR114KoYkogEjFBiF9GmcUbuBoZw+BEDhJUfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com
Subject: [PATCH net 5/6] netfilter: nf_tables: Fix potential data-race in __nft_flowtable_type_get()
Date: Thu,  4 Apr 2024 12:43:33 +0200
Message-Id: <20240404104334.1627-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240404104334.1627-1-pablo@netfilter.org>
References: <20240404104334.1627-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ziyang Xuan <william.xuanziyang@huawei.com>

nft_unregister_flowtable_type() within nf_flow_inet_module_exit() can
concurrent with __nft_flowtable_type_get() within nf_tables_newflowtable().
And thhere is not any protection when iterate over nf_tables_flowtables
list in __nft_flowtable_type_get(). Therefore, there is pertential
data-race of nf_tables_flowtables list entry.

Use list_for_each_entry_rcu() to iterate over nf_tables_flowtables list
in __nft_flowtable_type_get(), and use rcu_read_lock() in the caller
nft_flowtable_type_get() to protect the entire type query process.

Fixes: 3b49e2e94e6e ("netfilter: nf_tables: add flow table netlink frontend")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1eb51bf24fc2..e02d0ae4f436 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8296,11 +8296,12 @@ static int nft_flowtable_parse_hook(const struct nft_ctx *ctx,
 	return err;
 }
 
+/* call under rcu_read_lock */
 static const struct nf_flowtable_type *__nft_flowtable_type_get(u8 family)
 {
 	const struct nf_flowtable_type *type;
 
-	list_for_each_entry(type, &nf_tables_flowtables, list) {
+	list_for_each_entry_rcu(type, &nf_tables_flowtables, list) {
 		if (family == type->family)
 			return type;
 	}
@@ -8312,9 +8313,13 @@ nft_flowtable_type_get(struct net *net, u8 family)
 {
 	const struct nf_flowtable_type *type;
 
+	rcu_read_lock();
 	type = __nft_flowtable_type_get(family);
-	if (type != NULL && try_module_get(type->owner))
+	if (type != NULL && try_module_get(type->owner)) {
+		rcu_read_unlock();
 		return type;
+	}
+	rcu_read_unlock();
 
 	lockdep_nfnl_nft_mutex_not_held();
 #ifdef CONFIG_MODULES
-- 
2.30.2

