Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F3E314B72;
	Thu,  7 May 2026 23:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778197529; cv=none; b=HtaTenetu28OuSS8PQeVN3kENkFRA3qbXp3oYLFlmMfftH0uNPYk6P/dNif9byBYvpLBdyD0PVoYIbLG7AeLnMnJ3aTsS9G9nxlCmYFLv1+a07XgEW6wKCPMBK6KilLOd0EB7XmGPYXM6/xuxyY8wcnhA12OXWErsPKhcgIMvPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778197529; c=relaxed/simple;
	bh=1kLRw3gHtTGmydLGdtdcy7G073u9IG0S19LN7VSK/HM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bsb44ZGQeKt9jiwTgPqUdVsD2Pt2K3fzrblYxMDXbAQFn4OTVcLbAEqjTFHEo+cSEMznfXaSYhKxl8oCkXoIaeuZNDQhzPz3Q/IlAc0XFGTzSelyA+5Zr03pqZES+zOBlLEjAcSm/pjDrQbkplnW1spAg5/aONjgFJrcOhMeMJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=htngr3h/; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="htngr3h/"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3276560265;
	Fri,  8 May 2026 01:45:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1778197525;
	bh=q4MhS3tLkATKAgOAuY/1V4txf//R27ogoB5E+yf8nwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=htngr3h/VbbqdyM15kpKIHpbJR1s1c27/I9cT5f0Of+RqVgTOKC1lTwB6se2hWHHH
	 7VIG6YQH5mUaw8IDmZvetJViixAnFxhSCEQqPWD94XtqQVgydHsiIHKcUrARb4sQAb
	 Pts7bV2pC7o53GzHPU9rCvFB485enznGZ7Rd1eq3qzM8yHw5ntmCyb6a6VGC3Na/em
	 2g0697mMMpQ1FR7VXwFUjH7YdzJZPDlRBLjJ8c1OnFLmgzhtK+rtlmov5+E3TTdzDK
	 mhBgjBGLfuf8XypojhP/XycRIb0yLYWdcRGta9FWgxXP7fkIvh/73Zm4TkPWthDk3z
	 4pTR1RkBwG6Xg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 08/13] netfilter: x_tables: close dangling table module init race
Date: Fri,  8 May 2026 01:45:04 +0200
Message-ID: <20260507234509.603182-9-pablo@netfilter.org>
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

Similar to the previous ebtables patch:
template add exposes the table to userspace, we must do this last to
rnsure the pernet ops are set up (contain the destructors).

Fixes: fdacd57c79b7 ("netfilter: x_tables: never register tables by default")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/arptable_filter.c   | 23 ++++++++++++-----------
 net/ipv4/netfilter/iptable_filter.c    | 23 ++++++++++++-----------
 net/ipv4/netfilter/iptable_mangle.c    | 25 +++++++++++++------------
 net/ipv4/netfilter/iptable_raw.c       | 22 +++++++++++-----------
 net/ipv4/netfilter/iptable_security.c  | 23 ++++++++++++-----------
 net/ipv6/netfilter/ip6table_filter.c   | 22 +++++++++++-----------
 net/ipv6/netfilter/ip6table_mangle.c   | 23 ++++++++++++-----------
 net/ipv6/netfilter/ip6table_raw.c      | 20 ++++++++++----------
 net/ipv6/netfilter/ip6table_security.c | 23 ++++++++++++-----------
 9 files changed, 105 insertions(+), 99 deletions(-)

diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 382345567a60..370b635e3523 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -58,25 +58,26 @@ static struct pernet_operations arptable_filter_net_ops = {
 
 static int __init arptable_filter_init(void)
 {
-	int ret = xt_register_template(&packet_filter,
-				       arptable_filter_table_init);
-
-	if (ret < 0)
-		return ret;
+	int ret;
 
 	arpfilter_ops = xt_hook_ops_alloc(&packet_filter, arpt_do_table);
-	if (IS_ERR(arpfilter_ops)) {
-		xt_unregister_template(&packet_filter);
+	if (IS_ERR(arpfilter_ops))
 		return PTR_ERR(arpfilter_ops);
-	}
 
 	ret = register_pernet_subsys(&arptable_filter_net_ops);
+	if (ret < 0)
+		goto err_free;
+
+	ret = xt_register_template(&packet_filter,
+				   arptable_filter_table_init);
 	if (ret < 0) {
-		xt_unregister_template(&packet_filter);
-		kfree(arpfilter_ops);
-		return ret;
+		unregister_pernet_subsys(&arptable_filter_net_ops);
+		goto err_free;
 	}
 
+	return 0;
+err_free:
+	kfree(arpfilter_ops);
 	return ret;
 }
 
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index 0dea754a9120..672d7da1071d 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -77,26 +77,27 @@ static struct pernet_operations iptable_filter_net_ops = {
 
 static int __init iptable_filter_init(void)
 {
-	int ret = xt_register_template(&packet_filter,
-				       iptable_filter_table_init);
-
-	if (ret < 0)
-		return ret;
+	int ret;
 
 	filter_ops = xt_hook_ops_alloc(&packet_filter, ipt_do_table);
-	if (IS_ERR(filter_ops)) {
-		xt_unregister_template(&packet_filter);
+	if (IS_ERR(filter_ops))
 		return PTR_ERR(filter_ops);
-	}
 
 	ret = register_pernet_subsys(&iptable_filter_net_ops);
+	if (ret < 0)
+		goto err_free;
+
+	ret = xt_register_template(&packet_filter,
+				   iptable_filter_table_init);
 	if (ret < 0) {
-		xt_unregister_template(&packet_filter);
-		kfree(filter_ops);
-		return ret;
+		unregister_pernet_subsys(&iptable_filter_net_ops);
+		goto err_free;
 	}
 
 	return 0;
+err_free:
+	kfree(filter_ops);
+	return ret;
 }
 
 static void __exit iptable_filter_fini(void)
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 4d3b12492308..13d25d9a4610 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -111,25 +111,26 @@ static struct pernet_operations iptable_mangle_net_ops = {
 
 static int __init iptable_mangle_init(void)
 {
-	int ret = xt_register_template(&packet_mangler,
-				       iptable_mangle_table_init);
-	if (ret < 0)
-		return ret;
+	int ret;
 
 	mangle_ops = xt_hook_ops_alloc(&packet_mangler, iptable_mangle_hook);
-	if (IS_ERR(mangle_ops)) {
-		xt_unregister_template(&packet_mangler);
-		ret = PTR_ERR(mangle_ops);
-		return ret;
-	}
+	if (IS_ERR(mangle_ops))
+		return PTR_ERR(mangle_ops);
 
 	ret = register_pernet_subsys(&iptable_mangle_net_ops);
+	if (ret < 0)
+		goto err_free;
+
+	ret = xt_register_template(&packet_mangler,
+				   iptable_mangle_table_init);
 	if (ret < 0) {
-		xt_unregister_template(&packet_mangler);
-		kfree(mangle_ops);
-		return ret;
+		unregister_pernet_subsys(&iptable_mangle_net_ops);
+		goto err_free;
 	}
 
+	return 0;
+err_free:
+	kfree(mangle_ops);
 	return ret;
 }
 
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index 6f7afec7954b..2745c22f4034 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -77,24 +77,24 @@ static int __init iptable_raw_init(void)
 		pr_info("Enabling raw table before defrag\n");
 	}
 
-	ret = xt_register_template(table,
-				   iptable_raw_table_init);
-	if (ret < 0)
-		return ret;
-
 	rawtable_ops = xt_hook_ops_alloc(table, ipt_do_table);
-	if (IS_ERR(rawtable_ops)) {
-		xt_unregister_template(table);
+	if (IS_ERR(rawtable_ops))
 		return PTR_ERR(rawtable_ops);
-	}
 
 	ret = register_pernet_subsys(&iptable_raw_net_ops);
+	if (ret < 0)
+		goto err_free;
+
+	ret = xt_register_template(table,
+				   iptable_raw_table_init);
 	if (ret < 0) {
-		xt_unregister_template(table);
-		kfree(rawtable_ops);
-		return ret;
+		unregister_pernet_subsys(&iptable_raw_net_ops);
+		goto err_free;
 	}
 
+	return 0;
+err_free:
+	kfree(rawtable_ops);
 	return ret;
 }
 
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index 81175c20ccbe..491894511c54 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -65,25 +65,26 @@ static struct pernet_operations iptable_security_net_ops = {
 
 static int __init iptable_security_init(void)
 {
-	int ret = xt_register_template(&security_table,
-				       iptable_security_table_init);
-
-	if (ret < 0)
-		return ret;
+	int ret;
 
 	sectbl_ops = xt_hook_ops_alloc(&security_table, ipt_do_table);
-	if (IS_ERR(sectbl_ops)) {
-		xt_unregister_template(&security_table);
+	if (IS_ERR(sectbl_ops))
 		return PTR_ERR(sectbl_ops);
-	}
 
 	ret = register_pernet_subsys(&iptable_security_net_ops);
+	if (ret < 0)
+		goto err_free;
+
+	ret = xt_register_template(&security_table,
+				   iptable_security_table_init);
 	if (ret < 0) {
-		xt_unregister_template(&security_table);
-		kfree(sectbl_ops);
-		return ret;
+		unregister_pernet_subsys(&iptable_security_net_ops);
+		goto err_free;
 	}
 
+	return 0;
+err_free:
+	kfree(sectbl_ops);
 	return ret;
 }
 
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index cf561919bde8..b074fc477676 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -76,25 +76,25 @@ static struct pernet_operations ip6table_filter_net_ops = {
 
 static int __init ip6table_filter_init(void)
 {
-	int ret = xt_register_template(&packet_filter,
-					ip6table_filter_table_init);
-
-	if (ret < 0)
-		return ret;
+	int ret;
 
 	filter_ops = xt_hook_ops_alloc(&packet_filter, ip6t_do_table);
-	if (IS_ERR(filter_ops)) {
-		xt_unregister_template(&packet_filter);
+	if (IS_ERR(filter_ops))
 		return PTR_ERR(filter_ops);
-	}
 
 	ret = register_pernet_subsys(&ip6table_filter_net_ops);
+	if (ret < 0)
+		goto err_free;
+
+	ret = xt_register_template(&packet_filter, ip6table_filter_table_init);
 	if (ret < 0) {
-		xt_unregister_template(&packet_filter);
-		kfree(filter_ops);
-		return ret;
+		unregister_pernet_subsys(&ip6table_filter_net_ops);
+		goto err_free;
 	}
 
+	return 0;
+err_free:
+	kfree(filter_ops);
 	return ret;
 }
 
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 1a758f2bc537..e6ee036a9b2c 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -104,25 +104,26 @@ static struct pernet_operations ip6table_mangle_net_ops = {
 
 static int __init ip6table_mangle_init(void)
 {
-	int ret = xt_register_template(&packet_mangler,
-				       ip6table_mangle_table_init);
-
-	if (ret < 0)
-		return ret;
+	int ret;
 
 	mangle_ops = xt_hook_ops_alloc(&packet_mangler, ip6table_mangle_hook);
-	if (IS_ERR(mangle_ops)) {
-		xt_unregister_template(&packet_mangler);
+	if (IS_ERR(mangle_ops))
 		return PTR_ERR(mangle_ops);
-	}
 
 	ret = register_pernet_subsys(&ip6table_mangle_net_ops);
+	if (ret < 0)
+		goto err_free;
+
+	ret = xt_register_template(&packet_mangler,
+				   ip6table_mangle_table_init);
 	if (ret < 0) {
-		xt_unregister_template(&packet_mangler);
-		kfree(mangle_ops);
-		return ret;
+		unregister_pernet_subsys(&ip6table_mangle_net_ops);
+		goto err_free;
 	}
 
+	return 0;
+err_free:
+	kfree(mangle_ops);
 	return ret;
 }
 
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index 923455921c1d..3b161ee875bc 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -75,24 +75,24 @@ static int __init ip6table_raw_init(void)
 		pr_info("Enabling raw table before defrag\n");
 	}
 
-	ret = xt_register_template(table, ip6table_raw_table_init);
-	if (ret < 0)
-		return ret;
-
 	/* Register hooks */
 	rawtable_ops = xt_hook_ops_alloc(table, ip6t_do_table);
-	if (IS_ERR(rawtable_ops)) {
-		xt_unregister_template(table);
+	if (IS_ERR(rawtable_ops))
 		return PTR_ERR(rawtable_ops);
-	}
 
 	ret = register_pernet_subsys(&ip6table_raw_net_ops);
+	if (ret < 0)
+		goto err_free;
+
+	ret = xt_register_template(table, ip6table_raw_table_init);
 	if (ret < 0) {
-		kfree(rawtable_ops);
-		xt_unregister_template(table);
-		return ret;
+		unregister_pernet_subsys(&ip6table_raw_net_ops);
+		goto err_free;
 	}
 
+	return 0;
+err_free:
+	kfree(rawtable_ops);
 	return ret;
 }
 
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index c44834d93fc7..4bd5d97b8ab6 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -64,25 +64,26 @@ static struct pernet_operations ip6table_security_net_ops = {
 
 static int __init ip6table_security_init(void)
 {
-	int ret = xt_register_template(&security_table,
-				       ip6table_security_table_init);
-
-	if (ret < 0)
-		return ret;
+	int ret;
 
 	sectbl_ops = xt_hook_ops_alloc(&security_table, ip6t_do_table);
-	if (IS_ERR(sectbl_ops)) {
-		xt_unregister_template(&security_table);
+	if (IS_ERR(sectbl_ops))
 		return PTR_ERR(sectbl_ops);
-	}
 
 	ret = register_pernet_subsys(&ip6table_security_net_ops);
+	if (ret < 0)
+		goto err_free;
+
+	ret = xt_register_template(&security_table,
+				   ip6table_security_table_init);
 	if (ret < 0) {
-		kfree(sectbl_ops);
-		xt_unregister_template(&security_table);
-		return ret;
+		unregister_pernet_subsys(&ip6table_security_net_ops);
+		goto err_free;
 	}
 
+	return 0;
+err_free:
+	kfree(sectbl_ops);
 	return ret;
 }
 
-- 
2.47.3

