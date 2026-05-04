Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C0A3E557C
	for <netfilter-devel@vger.kernel.org>; Mon,  4 May 2026 18:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777919035; cv=none; b=g4V6orXiZ96zewJWR0ujJOvF2yTIVXU/7zL7cx6j1XU2oXF7oU32BJAXoUbnW65wpt+TXy7HWOfK+niadojI12hQ2YfPqM4zPGel1LMQovGLQzF6t52q9KBcqSjJwPmJuOzO+i0UbevSHfj0EE7LO5XZJSBT0JUi859tt7bBOdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777919035; c=relaxed/simple;
	bh=yX+Y3KraB2/pId8RvV/tmH3rAK5+MTCOSURNKblW+JI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lERbsH6tiZ04EPkMX9pXJLhPhtbxrVF+5+xiM/wjAKfAEXS92QFv+xc2HHsSzAqosw9KBylLDvn364VaEDqgifEBGOKX96mY4ozcmbEa4mFiUMRMMBjEz3I06vvFQpbp9Goin54wysxmqP+ZevK2Ryk8pXEZw9ehmLeA9lsatjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0A852602F8; Mon, 04 May 2026 20:23:52 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf 8/8] netfilter: x_tables: close dangling table module init race
Date: Mon,  4 May 2026 20:22:20 +0200
Message-ID: <20260504182310.1916-9-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260504182310.1916-1-fw@strlen.de>
References: <20260504182310.1916-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Similar to the previous ebtables patch:
template add exposes the table to userspace, we must do this last to
rnsure the pernet ops are set up (contain the destructors).

Fixes: fdacd57c79b7 ("netfilter: x_tables: never register tables by default")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: new in this series.

 net/ipv4/netfilter/arptable_filter.c   | 23 ++++++++++++-----------
 net/ipv4/netfilter/iptable_filter.c    | 23 ++++++++++++-----------
 net/ipv4/netfilter/iptable_mangle.c    | 25 +++++++++++++------------
 net/ipv4/netfilter/iptable_raw.c       | 22 +++++++++++-----------
 net/ipv4/netfilter/iptable_security.c  | 19 +++++++++++--------
 net/ipv6/netfilter/ip6table_filter.c   | 22 +++++++++++-----------
 net/ipv6/netfilter/ip6table_mangle.c   | 23 ++++++++++++-----------
 net/ipv6/netfilter/ip6table_raw.c      | 20 ++++++++++----------
 net/ipv6/netfilter/ip6table_security.c | 23 ++++++++++++-----------
 9 files changed, 104 insertions(+), 96 deletions(-)

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
index 81175c20ccbe..fd90f228c8bc 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -65,11 +65,7 @@ static struct pernet_operations iptable_security_net_ops = {
 
 static int __init iptable_security_init(void)
 {
-	int ret = xt_register_template(&security_table,
-				       iptable_security_table_init);
-
-	if (ret < 0)
-		return ret;
+	int ret;
 
 	sectbl_ops = xt_hook_ops_alloc(&security_table, ipt_do_table);
 	if (IS_ERR(sectbl_ops)) {
@@ -78,12 +74,19 @@ static int __init iptable_security_init(void)
 	}
 
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
2.53.0

