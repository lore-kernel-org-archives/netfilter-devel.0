Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2706C3195FC;
	Thu,  7 May 2026 23:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778197525; cv=none; b=Q55k9fiB+nodnnkwlKKJRO711flbW1Y5PU3gwzgRSU+e/TkGJ7ppfegbIQNFpLh06Z1gs0ZiGUUeDKwqIIIm5ku1rLoFlWeaJ750LY7p4MLI1pbdfwhxyQ2IhqTwsF0mBpV3qFylYL5Fh1/krczzUOY8CiowhTcQRuSvf7iYfh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778197525; c=relaxed/simple;
	bh=9dtFwNtNHq/vDcWT11CL63MdX0bAMwvjk2cdRnfevRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9b8asiPI1gGoLv+umT+f+jrf6k/kcdEAhgA7hWE3u83VnKLO849uxDxRue0tyhaBHP3rD15udjefJJPfkbCWV8eYuhpX0LB28bb4vzKS8BfkMdbrxqo9jHdjhbJk1PEpDV2+7tME3wlMFbz0IMsOEDBLA6nMpyh90hTjkw1DC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DsfJ808A; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DsfJ808A"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7094060255;
	Fri,  8 May 2026 01:45:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1778197519;
	bh=1AWBUi/tyBexQ8IV3iDVGK6G0UI/M6+5nRfuiZIrXmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DsfJ808AtgRtbsxKXy7si/RoBuL0jInGgrkhhzhGq4jdN35QhsOP6On4adE1ZoMsn
	 hWJp/DbqnldnY0CDPWHs732Gzr1ChkFQ8YGLYF5vEpHegke48NIGtbZexTZeaVtyKf
	 YyZMiXjF2pKduPNx21sJU/44t7yI0JRGx5XefvLg6h2ccED8LHIbk8T6Da2+4m561W
	 XvVSiOjBgZdKBQ0Et/1RagyZBKR01cAO7RFJ7+QZ1uog9IOgmoOfrdwU7j6KbYTuBB
	 cgk44v3SUjjaCw2qeHBAirZzhIcVLAqFOp7oI50pY5hmsSHLI5YVNnBjGTz+cZracR
	 TrVbiJNVCdbdA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 04/13] netfilter: x_tables: unregister the templates first
Date: Fri,  8 May 2026 01:45:00 +0200
Message-ID: <20260507234509.603182-5-pablo@netfilter.org>
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

When the module is going away we need to zap the template
first.  Else there is a small race window where userspace
could instantiate a new table after the pernet exit function
has removed the current table.

Fixes: fdacd57c79b7 ("netfilter: x_tables: never register tables by default")
Reported-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Tristan Madani <tristan@talencesecurity.com>
Closes: https://lore.kernel.org/netfilter-devel/20260429175613.1459342-1-tristmd@gmail.com/
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/arptable_filter.c   | 2 +-
 net/ipv4/netfilter/iptable_filter.c    | 2 +-
 net/ipv4/netfilter/iptable_mangle.c    | 2 +-
 net/ipv4/netfilter/iptable_raw.c       | 2 +-
 net/ipv4/netfilter/iptable_security.c  | 2 +-
 net/ipv6/netfilter/ip6table_filter.c   | 2 +-
 net/ipv6/netfilter/ip6table_mangle.c   | 2 +-
 net/ipv6/netfilter/ip6table_raw.c      | 2 +-
 net/ipv6/netfilter/ip6table_security.c | 2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 393d9a8c7739..382345567a60 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -82,8 +82,8 @@ static int __init arptable_filter_init(void)
 
 static void __exit arptable_filter_fini(void)
 {
-	unregister_pernet_subsys(&arptable_filter_net_ops);
 	xt_unregister_template(&packet_filter);
+	unregister_pernet_subsys(&arptable_filter_net_ops);
 	kfree(arpfilter_ops);
 }
 
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index b2fbd9651d61..0dea754a9120 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -101,8 +101,8 @@ static int __init iptable_filter_init(void)
 
 static void __exit iptable_filter_fini(void)
 {
-	unregister_pernet_subsys(&iptable_filter_net_ops);
 	xt_unregister_template(&packet_filter);
+	unregister_pernet_subsys(&iptable_filter_net_ops);
 	kfree(filter_ops);
 }
 
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index a99e61996197..4d3b12492308 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -135,8 +135,8 @@ static int __init iptable_mangle_init(void)
 
 static void __exit iptable_mangle_fini(void)
 {
-	unregister_pernet_subsys(&iptable_mangle_net_ops);
 	xt_unregister_template(&packet_mangler);
+	unregister_pernet_subsys(&iptable_mangle_net_ops);
 	kfree(mangle_ops);
 }
 
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index 42511721e538..6f7afec7954b 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -100,9 +100,9 @@ static int __init iptable_raw_init(void)
 
 static void __exit iptable_raw_fini(void)
 {
+	xt_unregister_template(&packet_raw);
 	unregister_pernet_subsys(&iptable_raw_net_ops);
 	kfree(rawtable_ops);
-	xt_unregister_template(&packet_raw);
 }
 
 module_init(iptable_raw_init);
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index 4646bf6d7d2b..81175c20ccbe 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -89,9 +89,9 @@ static int __init iptable_security_init(void)
 
 static void __exit iptable_security_fini(void)
 {
+	xt_unregister_template(&security_table);
 	unregister_pernet_subsys(&iptable_security_net_ops);
 	kfree(sectbl_ops);
-	xt_unregister_template(&security_table);
 }
 
 module_init(iptable_security_init);
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index f05a9e4b2c67..cf561919bde8 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -100,8 +100,8 @@ static int __init ip6table_filter_init(void)
 
 static void __exit ip6table_filter_fini(void)
 {
-	unregister_pernet_subsys(&ip6table_filter_net_ops);
 	xt_unregister_template(&packet_filter);
+	unregister_pernet_subsys(&ip6table_filter_net_ops);
 	kfree(filter_ops);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index afa4a5703e43..1a758f2bc537 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -128,8 +128,8 @@ static int __init ip6table_mangle_init(void)
 
 static void __exit ip6table_mangle_fini(void)
 {
-	unregister_pernet_subsys(&ip6table_mangle_net_ops);
 	xt_unregister_template(&packet_mangler);
+	unregister_pernet_subsys(&ip6table_mangle_net_ops);
 	kfree(mangle_ops);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index 32d2da81c52a..923455921c1d 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -98,8 +98,8 @@ static int __init ip6table_raw_init(void)
 
 static void __exit ip6table_raw_fini(void)
 {
-	unregister_pernet_subsys(&ip6table_raw_net_ops);
 	xt_unregister_template(&packet_raw);
+	unregister_pernet_subsys(&ip6table_raw_net_ops);
 	kfree(rawtable_ops);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index 3dfd8d6ea4b9..c44834d93fc7 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -88,8 +88,8 @@ static int __init ip6table_security_init(void)
 
 static void __exit ip6table_security_fini(void)
 {
-	unregister_pernet_subsys(&ip6table_security_net_ops);
 	xt_unregister_template(&security_table);
+	unregister_pernet_subsys(&ip6table_security_net_ops);
 	kfree(sectbl_ops);
 }
 
-- 
2.47.3

