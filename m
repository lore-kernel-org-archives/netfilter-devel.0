Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E207A371D16;
	Thu,  7 May 2026 23:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778197528; cv=none; b=CxcyYpPTmq13In86xYEf7Sbt+aM+No+HfvqYqw/9oBxwutLhoz66FnXCIztWSLkmrb6GXWCFKg+dECHLqc/wADnFW2xDObMZVMifj8HOIGmasIPdgBSd7MPmhyBJKISatGWulnplEYAqjJX5nT1OHGegshxiE+Oh2PCIP8edF9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778197528; c=relaxed/simple;
	bh=fh7SxsjywG2+VddLUurzj1SQ7DhdCBADx4XadRdBjE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozxwO5RQNWmKeThzAMf2sZcYFrbGls2CDrxnrha72jESu2hDaoM4AaitTQVTOIFiL9dQRSvLO5SjPZPpjbU3A8U/Tou0Dam3JRNfqaBCyKbDPmFojIxeR2YlUb/x0Xl4syQN81eaL2Ib0qH1kGWwIxYQjmw5bIIruhMaippUQmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jwd0uqrg; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jwd0uqrg"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EF91C60264;
	Fri,  8 May 2026 01:45:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1778197524;
	bh=qPhePoNl+exyjAY5RXLGVTo2Fbw1aSez9quW64wtJJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jwd0uqrg5Ii/3UOhYcEW7ZLKpGXi2RyBRdIBqx4pTKu55vYWBjfPPAHtyV5Lj85V7
	 j1UJ7AybZS7vr04HSWR4dldsAAPM70BmNtGLMND/eM3b2dYQMeLzmG9HVQTiqrrHqh
	 70eQkiuPOzXb+QXIHYHZzF+jSy5ArN2/j6Bv9rCNM8ZdF22O/woBFqEmg90bOB595u
	 NRGuvpPWBEqDPJqPUGEwyf2J1zYwIYy9YDb/yWA7sCb58aoFe+tRSYh04U07corK5n
	 pYGK5agzJYpqD/6zFvtUkDacrLHlm1s/YZe9SAf8N1n+eMfNmSLY08d60Fs3rkoxMC
	 sSy+xh6hFK2Kg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 07/13] netfilter: ebtables: close dangling table module init race
Date: Fri,  8 May 2026 01:45:03 +0200
Message-ID: <20260507234509.603182-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260507234509.603182-1-pablo@netfilter.org>
References: <20260507234509.603182-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

sashiko reported for a related patch:
 In modules like iptable_raw.c, [..], if register_pernet_subsys() fails,
 the rollback might call kfree(rawtable_ops) before [..]
 During this window, could a concurrent userspace process find the globally
 visible template, trigger table_init(), [..]

The table init functions must always register the template last.

Otherwise, set/getsockopt can instantiate a table in a namespace
while the required pernet ops (contain the destructor) isn't available.
This change is also required in x_tables, handled in followup change.

Fixes: 87663c39f898 ("netfilter: ebtables: do not hook tables by default")
Reviewed-by: Tristan Madani <tristan@talencesecurity.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/ebtable_broute.c | 12 +++++-------
 net/bridge/netfilter/ebtable_filter.c | 12 +++++-------
 net/bridge/netfilter/ebtable_nat.c    | 10 ++++------
 3 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/net/bridge/netfilter/ebtable_broute.c b/net/bridge/netfilter/ebtable_broute.c
index e6f9e343b41f..f05c79f215ea 100644
--- a/net/bridge/netfilter/ebtable_broute.c
+++ b/net/bridge/netfilter/ebtable_broute.c
@@ -112,18 +112,16 @@ static struct pernet_operations broute_net_ops = {
 
 static int __init ebtable_broute_init(void)
 {
-	int ret = ebt_register_template(&broute_table, broute_table_init);
+	int ret = register_pernet_subsys(&broute_net_ops);
 
 	if (ret)
 		return ret;
 
-	ret = register_pernet_subsys(&broute_net_ops);
-	if (ret) {
-		ebt_unregister_template(&broute_table);
-		return ret;
-	}
+	ret = ebt_register_template(&broute_table, broute_table_init);
+	if (ret)
+		unregister_pernet_subsys(&broute_net_ops);
 
-	return 0;
+	return ret;
 }
 
 static void __exit ebtable_broute_fini(void)
diff --git a/net/bridge/netfilter/ebtable_filter.c b/net/bridge/netfilter/ebtable_filter.c
index 02b6501c15a5..0fc03b07e62a 100644
--- a/net/bridge/netfilter/ebtable_filter.c
+++ b/net/bridge/netfilter/ebtable_filter.c
@@ -93,18 +93,16 @@ static struct pernet_operations frame_filter_net_ops = {
 
 static int __init ebtable_filter_init(void)
 {
-	int ret = ebt_register_template(&frame_filter, frame_filter_table_init);
+	int ret = register_pernet_subsys(&frame_filter_net_ops);
 
 	if (ret)
 		return ret;
 
-	ret = register_pernet_subsys(&frame_filter_net_ops);
-	if (ret) {
-		ebt_unregister_template(&frame_filter);
-		return ret;
-	}
+	ret = ebt_register_template(&frame_filter, frame_filter_table_init);
+	if (ret)
+		unregister_pernet_subsys(&frame_filter_net_ops);
 
-	return 0;
+	return ret;
 }
 
 static void __exit ebtable_filter_fini(void)
diff --git a/net/bridge/netfilter/ebtable_nat.c b/net/bridge/netfilter/ebtable_nat.c
index 9985a82555c4..8a10375d8909 100644
--- a/net/bridge/netfilter/ebtable_nat.c
+++ b/net/bridge/netfilter/ebtable_nat.c
@@ -93,16 +93,14 @@ static struct pernet_operations frame_nat_net_ops = {
 
 static int __init ebtable_nat_init(void)
 {
-	int ret = ebt_register_template(&frame_nat, frame_nat_table_init);
+	int ret = register_pernet_subsys(&frame_nat_net_ops);
 
 	if (ret)
 		return ret;
 
-	ret = register_pernet_subsys(&frame_nat_net_ops);
-	if (ret) {
-		ebt_unregister_template(&frame_nat);
-		return ret;
-	}
+	ret = ebt_register_template(&frame_nat, frame_nat_table_init);
+	if (ret)
+		unregister_pernet_subsys(&frame_nat_net_ops);
 
 	return ret;
 }
-- 
2.47.3

