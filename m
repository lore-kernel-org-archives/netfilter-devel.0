Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46C6314B76
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2026 10:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776250036; cv=none; b=ZB4mTkcGiIfOfeuU86DOE4D8+GnywnmaOYQ9GwwFF4mxTmGsLKtZoPFKriwERZAa9bFybt74g7fuoavY1ZYiXAp1qfyWcXBH7YIpTIW6BYarpwLPN9icxmDHoPQSRaEi1j1dL1ivDcSiucZb4GDE6O41VlNQmUSkItZ3jks6Khk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776250036; c=relaxed/simple;
	bh=zre4LGf00RLwLfaD17aEHynkNwu4BAmfxv0aL3ttB3I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=j5Qa3QOI/zfW3BfkqAR4x3aUljwC1PxPEKLw2c4uEDxaVgSSVh73aFQYbLcCgtXzvCHtNd/ZuUprC+MPayLKmO/bbGpJpBkQjrAjgASkWRkhCBxhW3F8cZkYbVw+3pG1Zs7BZ2x+fw+u25QY2PtqNI9NkgM3NJJt1RDfqlTHhl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rzLoyTsm; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rzLoyTsm"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 32AB260177;
	Wed, 15 Apr 2026 12:47:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776250031;
	bh=cgDCGzIr16YL9BibCxZpNEb97j6uNpU1e/ypiiD9Dhs=;
	h=From:To:Cc:Subject:Date:From;
	b=rzLoyTsmeMv8WY6HmdgdlGwgPftm/J/aPKLzN+AcscY7LpC+BFyF+l2q25hbsDYx6
	 BvtPowctcR7a8wKWl9Lq2BWH7tZ/JOuc6jCjpAozP1r932D77rtj9CncG2jxnJnwuW
	 9TalvovLQQVXm2+Bz4MGLi0NsJ/m1gV9ED8gKp3z/NfI97UZEsKKuJP0O/LfAxR81z
	 uLzIlpSIEKVPkiA0bANUksGu1bHZ8Ruz938d9oWxYJxCeQTYgt5lYjDC6ZkwQgOZpe
	 bSQnF4h8kbOI9OU94Ztkh/VVtli8uxt3Js/+8vcjj3mi5KjYKCRZAD3+08Aq3z/5N2
	 Y7KkpbdDdqKfg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf] netfilter: xtables: restrict several matches to ipv4 and ipv6
Date: Wed, 15 Apr 2026 12:47:07 +0200
Message-ID: <20260415104707.55946-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a partial revert of:

  ab4f21e6fb1c ("netfilter: xtables: use NFPROTO_UNSPEC in more extensions")

to allow ipv4 and ipv6 only.

- xt_mac
- xt_owner
- xt_physdev
- xt_realm

these extensions are not used by ebtables in userspace.

Fixes: ab4f21e6fb1c ("netfilter: xtables: use NFPROTO_UNSPEC in more extensions")
Reported-by: "Kito Xu (veritas501)" <hxzene@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_mac.c     | 34 +++++++++++++++++++++++-----------
 net/netfilter/xt_owner.c   | 37 +++++++++++++++++++++++++------------
 net/netfilter/xt_physdev.c | 29 +++++++++++++++++++----------
 net/netfilter/xt_realm.c   | 31 +++++++++++++++++++++----------
 4 files changed, 88 insertions(+), 43 deletions(-)

diff --git a/net/netfilter/xt_mac.c b/net/netfilter/xt_mac.c
index 81649da57ba5..bd2354760895 100644
--- a/net/netfilter/xt_mac.c
+++ b/net/netfilter/xt_mac.c
@@ -38,25 +38,37 @@ static bool mac_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	return ret;
 }
 
-static struct xt_match mac_mt_reg __read_mostly = {
-	.name      = "mac",
-	.revision  = 0,
-	.family    = NFPROTO_UNSPEC,
-	.match     = mac_mt,
-	.matchsize = sizeof(struct xt_mac_info),
-	.hooks     = (1 << NF_INET_PRE_ROUTING) | (1 << NF_INET_LOCAL_IN) |
-	             (1 << NF_INET_FORWARD),
-	.me        = THIS_MODULE,
+static struct xt_match mac_mt_reg[] __read_mostly = {
+	{
+		.name		= "mac",
+		.family		= NFPROTO_IPV4,
+		.match		= mac_mt,
+		.matchsize	= sizeof(struct xt_mac_info),
+		.hooks		= (1 << NF_INET_PRE_ROUTING) |
+				  (1 << NF_INET_LOCAL_IN) |
+				  (1 << NF_INET_FORWARD),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "mac",
+		.family		= NFPROTO_IPV6,
+		.match		= mac_mt,
+		.matchsize	= sizeof(struct xt_mac_info),
+		.hooks		= (1 << NF_INET_PRE_ROUTING) |
+				  (1 << NF_INET_LOCAL_IN) |
+				  (1 << NF_INET_FORWARD),
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init mac_mt_init(void)
 {
-	return xt_register_match(&mac_mt_reg);
+	return xt_register_matches(mac_mt_reg, ARRAY_SIZE(mac_mt_reg));
 }
 
 static void __exit mac_mt_exit(void)
 {
-	xt_unregister_match(&mac_mt_reg);
+	xt_unregister_matches(mac_mt_reg, ARRAY_SIZE(mac_mt_reg));
 }
 
 module_init(mac_mt_init);
diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
index 50332888c8d2..4786ea157269 100644
--- a/net/netfilter/xt_owner.c
+++ b/net/netfilter/xt_owner.c
@@ -127,26 +127,39 @@ owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	return true;
 }
 
-static struct xt_match owner_mt_reg __read_mostly = {
-	.name       = "owner",
-	.revision   = 1,
-	.family     = NFPROTO_UNSPEC,
-	.checkentry = owner_check,
-	.match      = owner_mt,
-	.matchsize  = sizeof(struct xt_owner_match_info),
-	.hooks      = (1 << NF_INET_LOCAL_OUT) |
-	              (1 << NF_INET_POST_ROUTING),
-	.me         = THIS_MODULE,
+static struct xt_match owner_mt_reg[] __read_mostly = {
+	{
+		.name       = "owner",
+		.revision   = 1,
+		.family     = NFPROTO_IPV4,
+		.checkentry = owner_check,
+		.match      = owner_mt,
+		.matchsize  = sizeof(struct xt_owner_match_info),
+		.hooks      = (1 << NF_INET_LOCAL_OUT) |
+		              (1 << NF_INET_POST_ROUTING),
+		.me         = THIS_MODULE,
+	},
+	{
+		.name       = "owner",
+		.revision   = 1,
+		.family     = NFPROTO_IPV6,
+		.checkentry = owner_check,
+		.match      = owner_mt,
+		.matchsize  = sizeof(struct xt_owner_match_info),
+		.hooks      = (1 << NF_INET_LOCAL_OUT) |
+		              (1 << NF_INET_POST_ROUTING),
+		.me         = THIS_MODULE,
+	}
 };
 
 static int __init owner_mt_init(void)
 {
-	return xt_register_match(&owner_mt_reg);
+	return xt_register_matches(owner_mt_reg, ARRAY_SIZE(owner_mt_reg));
 }
 
 static void __exit owner_mt_exit(void)
 {
-	xt_unregister_match(&owner_mt_reg);
+	xt_unregister_matches(owner_mt_reg, ARRAY_SIZE(owner_mt_reg));
 }
 
 module_init(owner_mt_init);
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index 343e65f377d4..130842c35c6f 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -115,24 +115,33 @@ static int physdev_mt_check(const struct xt_mtchk_param *par)
 	return 0;
 }
 
-static struct xt_match physdev_mt_reg __read_mostly = {
-	.name       = "physdev",
-	.revision   = 0,
-	.family     = NFPROTO_UNSPEC,
-	.checkentry = physdev_mt_check,
-	.match      = physdev_mt,
-	.matchsize  = sizeof(struct xt_physdev_info),
-	.me         = THIS_MODULE,
+static struct xt_match physdev_mt_reg[] __read_mostly = {
+	{
+		.name		= "physdev",
+		.family		= NFPROTO_IPV4,
+		.checkentry	= physdev_mt_check,
+		.match		= physdev_mt,
+		.matchsize	= sizeof(struct xt_physdev_info),
+		.me		= THIS_MODULE,
+	},
+	{
+		.name		= "physdev",
+		.family		= NFPROTO_IPV6,
+		.checkentry	= physdev_mt_check,
+		.match		= physdev_mt,
+		.matchsize	= sizeof(struct xt_physdev_info),
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init physdev_mt_init(void)
 {
-	return xt_register_match(&physdev_mt_reg);
+	return xt_register_matches(physdev_mt_reg, ARRAY_SIZE(physdev_mt_reg));
 }
 
 static void __exit physdev_mt_exit(void)
 {
-	xt_unregister_match(&physdev_mt_reg);
+	xt_unregister_matches(physdev_mt_reg, ARRAY_SIZE(physdev_mt_reg));
 }
 
 module_init(physdev_mt_init);
diff --git a/net/netfilter/xt_realm.c b/net/netfilter/xt_realm.c
index 6df485f4403d..130ebe5d1c43 100644
--- a/net/netfilter/xt_realm.c
+++ b/net/netfilter/xt_realm.c
@@ -27,24 +27,35 @@ realm_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	return (info->id == (dst->tclassid & info->mask)) ^ info->invert;
 }
 
-static struct xt_match realm_mt_reg __read_mostly = {
-	.name		= "realm",
-	.match		= realm_mt,
-	.matchsize	= sizeof(struct xt_realm_info),
-	.hooks		= (1 << NF_INET_POST_ROUTING) | (1 << NF_INET_FORWARD) |
-			  (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_LOCAL_IN),
-	.family		= NFPROTO_UNSPEC,
-	.me		= THIS_MODULE
+static struct xt_match realm_mt_reg[] __read_mostly = {
+	{
+		.name		= "realm",
+		.match		= realm_mt,
+		.matchsize	= sizeof(struct xt_realm_info),
+		.hooks		= (1 << NF_INET_POST_ROUTING) | (1 << NF_INET_FORWARD) |
+				  (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_LOCAL_IN),
+		.family		= NFPROTO_IPV4,
+		.me		= THIS_MODULE
+	},
+	{
+		.name		= "realm",
+		.match		= realm_mt,
+		.matchsize	= sizeof(struct xt_realm_info),
+		.hooks		= (1 << NF_INET_POST_ROUTING) | (1 << NF_INET_FORWARD) |
+				  (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_LOCAL_IN),
+		.family		= NFPROTO_IPV6,
+		.me		= THIS_MODULE
+	}
 };
 
 static int __init realm_mt_init(void)
 {
-	return xt_register_match(&realm_mt_reg);
+	return xt_register_matches(realm_mt_reg, ARRAY_SIZE(realm_mt_reg));
 }
 
 static void __exit realm_mt_exit(void)
 {
-	xt_unregister_match(&realm_mt_reg);
+	xt_unregister_matches(realm_mt_reg, ARRAY_SIZE(realm_mt_reg));
 }
 
 module_init(realm_mt_init);
-- 
2.47.3

