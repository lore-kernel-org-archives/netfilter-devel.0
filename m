Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0B03CFF7E;
	Mon, 20 Apr 2026 22:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776722547; cv=none; b=f0pBw1OPZHMKv0jfSzAq/wnMPL12u+jWR+T+NM78WQp1UntZ4S9H0+UIWNF+ObgIiZA6s5msrtpmkmJYFG3JvAMhu0ZahCshzqX6Rwmke0D5tZUz/6c4/+inKZVDd7O/mtqqwcvrNgn3ux6CCpK9hL2fUH7aD/qMgyeYjqj9fMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776722547; c=relaxed/simple;
	bh=VA8UTo8Z83ZB4Myct45px9fMJ2rLv7syvIBNMVevznI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QiKEj4AaAjuGHtI8RQHRvrjUJp7SFujIt/C35xc5IBJ8K/98TiPMTkuCAtdDahjRME/xOFRFOHjCkPjj66mv0GCwe0KrIJPao0dAxfX7GaDJGOCsWqNvaGKORZO4eXY/GrUj54AI8S27hYgQZ6TYxjIrJRxKTqhuvxBIcsX7SVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=E7JJA15K; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="E7JJA15K"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 431C260264;
	Tue, 21 Apr 2026 00:02:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776722544;
	bh=OiAU0N3unB6eDO1ijbrsbW503Mylsms6h7vYxlJm0G0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E7JJA15K5xGkxVMI2ZR05ZqfVPeynGWN4rVexCi82JrSWH1SQXds2n3Gi0zJ2adlJ
	 3dI6AFwxaTrXmja1di2UfY1oQYWLWgfWYL9kn3FpjLwHkrFDMav/0wi/tMzZMRAMN6
	 YWc0FaCf1OZdooj7kS3QQeouWOAv/s6LjJOJOSfRZ34r1IVfhw5fVhcmB4k0xrpdTK
	 SzfwJ3tRZLTs3UYzpwvwDAebzRZ67uQDEbjmISwmlzaG0Tn8m/u34OFQxFgmCNkfA0
	 cX+7rLGFJ7AaKS7+9TQkjtcQ932Vy9KpNqxNM7qPZkZEdVOpbeHO8sIm6EK2BdKXrm
	 rgF02IK6zLqYw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 4/8] netfilter: xtables: restrict several matches to inet family
Date: Tue, 21 Apr 2026 00:02:11 +0200
Message-ID: <20260420220215.111510-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260420220215.111510-1-pablo@netfilter.org>
References: <20260420220215.111510-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a partial revert of:

  commit ab4f21e6fb1c ("netfilter: xtables: use NFPROTO_UNSPEC in more extensions")

to allow ipv4 and ipv6 only.

- xt_mac
- xt_owner
- xt_physdev

These extensions are not used by ebtables in userspace.

Moreover, xt_realm is only for ipv4, since dst->tclassid is ipv4
specific.

Fixes: ab4f21e6fb1c ("netfilter: xtables: use NFPROTO_UNSPEC in more extensions")
Reported-by: "Kito Xu (veritas501)" <hxzene@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_mac.c     | 34 +++++++++++++++++++++++-----------
 net/netfilter/xt_owner.c   | 37 +++++++++++++++++++++++++------------
 net/netfilter/xt_physdev.c | 29 +++++++++++++++++++----------
 net/netfilter/xt_realm.c   |  2 +-
 4 files changed, 68 insertions(+), 34 deletions(-)

diff --git a/net/netfilter/xt_mac.c b/net/netfilter/xt_mac.c
index 4798cd2ca26e..7fc5156825e4 100644
--- a/net/netfilter/xt_mac.c
+++ b/net/netfilter/xt_mac.c
@@ -36,25 +36,37 @@ static bool mac_mt(const struct sk_buff *skb, struct xt_action_param *par)
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
index 5bfb4843df66..8f2e57b2a586 100644
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
+			      (1 << NF_INET_POST_ROUTING),
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
+			      (1 << NF_INET_POST_ROUTING),
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
index 53997771013f..d2b0b52434fa 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -137,24 +137,33 @@ static int physdev_mt_check(const struct xt_mtchk_param *par)
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
index 6df485f4403d..61b2f1e58d15 100644
--- a/net/netfilter/xt_realm.c
+++ b/net/netfilter/xt_realm.c
@@ -33,7 +33,7 @@ static struct xt_match realm_mt_reg __read_mostly = {
 	.matchsize	= sizeof(struct xt_realm_info),
 	.hooks		= (1 << NF_INET_POST_ROUTING) | (1 << NF_INET_FORWARD) |
 			  (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_LOCAL_IN),
-	.family		= NFPROTO_UNSPEC,
+	.family		= NFPROTO_IPV4,
 	.me		= THIS_MODULE
 };
 
-- 
2.47.3

