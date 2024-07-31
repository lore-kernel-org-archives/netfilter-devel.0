Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE28B3A1B5;
	Wed, 31 Jul 2024 21:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722461881; cv=none; b=X7vu5yrGFG/J4zwX52t4usDCMQlHGtpdOrX0GOIbdecIZejyMEGv60IAtB1tF9LSSf2bxXyg0dD1xqkWNjQMUl/yC5Ptw8aJMW6O9W+kqISoEtAzuTcjb69KPnAY293hMx/lfVsIri9q8onW93Fkg1WKGxVDJ7lcLQfvWicVqxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722461881; c=relaxed/simple;
	bh=KxzYCQG3wttGcX8tAtKL8uopegVCdD0jQ8DEr1RfNDs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PN+AXHjLzijTtV085gB1saDjKzKl9sX5pq3xnCOlJ/1plnuMTH8TtnEnwIXPzIW9JxANU9/ct13G7iMLZe35zYUIAB4ca27PFoDhUHvUIjyNGsMpVLtCKAxkYsYCOnP+8ww6OhXk3uptgUr4zx2xxT358aXfLt3ZwAknJBk7n2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 2/2] netfilter: iptables: Fix potential null-ptr-deref in ip6table_nat_table_init().
Date: Wed, 31 Jul 2024 23:30:46 +0200
Message-Id: <20240731213046.6194-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240731213046.6194-1-pablo@netfilter.org>
References: <20240731213046.6194-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kuniyuki Iwashima <kuniyu@amazon.com>

ip6table_nat_table_init() accesses net->gen->ptr[ip6table_nat_net_ops.id],
but the function is exposed to user space before the entry is allocated
via register_pernet_subsys().

Let's call register_pernet_subsys() before xt_register_template().

Fixes: fdacd57c79b7 ("netfilter: x_tables: never register tables by default")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv6/netfilter/ip6table_nat.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/netfilter/ip6table_nat.c b/net/ipv6/netfilter/ip6table_nat.c
index 52cf104e3478..e119d4f090cc 100644
--- a/net/ipv6/netfilter/ip6table_nat.c
+++ b/net/ipv6/netfilter/ip6table_nat.c
@@ -147,23 +147,27 @@ static struct pernet_operations ip6table_nat_net_ops = {
 
 static int __init ip6table_nat_init(void)
 {
-	int ret = xt_register_template(&nf_nat_ipv6_table,
-				       ip6table_nat_table_init);
+	int ret;
 
+	/* net->gen->ptr[ip6table_nat_net_id] must be allocated
+	 * before calling ip6t_nat_register_lookups().
+	 */
+	ret = register_pernet_subsys(&ip6table_nat_net_ops);
 	if (ret < 0)
 		return ret;
 
-	ret = register_pernet_subsys(&ip6table_nat_net_ops);
+	ret = xt_register_template(&nf_nat_ipv6_table,
+				   ip6table_nat_table_init);
 	if (ret)
-		xt_unregister_template(&nf_nat_ipv6_table);
+		unregister_pernet_subsys(&ip6table_nat_net_ops);
 
 	return ret;
 }
 
 static void __exit ip6table_nat_exit(void)
 {
-	unregister_pernet_subsys(&ip6table_nat_net_ops);
 	xt_unregister_template(&nf_nat_ipv6_table);
+	unregister_pernet_subsys(&ip6table_nat_net_ops);
 }
 
 module_init(ip6table_nat_init);
-- 
2.30.2

