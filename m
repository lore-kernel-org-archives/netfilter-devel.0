Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB13493D38;
	Wed,  9 Sep 2026 22:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788992353; cv=none; b=DsB1Ep81AzxiJAChmzFOE3fOlq8cxUuLJ3YwshFl0DJKjYz6q3lnA3S/Cuq4GOVLwfcv0ZOLky2KMhAOinL0mfB+fMUu+jbjrdze5MMGZDJIGryRQrg1S6oeJtlb4MtxT5rVQYYT5OTkcpFoJ6S9JPxR02D0bd51V/Y1Z6kv+6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788992353; c=relaxed/simple;
	bh=jrT3oX3mKDFRjtRI9PnG7RCHgOxUNE7JlN4gfGGVCqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k853fq5awssszL0987Mng6Gig8ua6a+YRVjHSWFYOuTmXmgtIh3RhGOXT0tXUHJN2/SzRJAXClYKmHo23kIZidU1J7MaSrK1WhbTTd8bRVrInxIxsVOz2uN3oSaDboz3y1IGQANdmbLufoKE8PMtMr9G86CkEd1vdwSQs0k2wR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=S8ZXT5xd; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="S8ZXT5xd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788992342;
	bh=3K1cdcG7lCMhwb2HmdLaCPOZtjgB80js8r3x1WzuzTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S8ZXT5xdxNX5sBrap/FGTPW7G6eR6AWem8zG3F7jHl81shpg/++tBiMnTOjFQVnpo
	 Vw4tRgVynlYGHI5X5p+XIZcO41reg8vS6pwGX8cBwsQiEjFbya71B4h6KFs5SAzzDt
	 YCTLsLiZMwH9VVqfE/mHmcvH3ajl6T5LOZBOCRqnrbaqVsZufoW0CMrdDiC63vYO9I
	 cio59NBAOW/cclgt36vW2hVpS3F0yZOuZU1obYL6mSbTAbCMXlRIT9Pf9pkovfN/Ih
	 hjecQBG251O7KRuv8DMsYO6tsAQoYtHhWNEWpFyIednPIUTdJdITuwizn6tTuk3taU
	 iou/Qr9Fhb4IQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7C3ED607C7;
	Thu, 10 Sep 2026 00:19:01 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 7/7] netfilter: hold reference on module during netlink dump
Date: Thu, 10 Sep 2026 00:18:44 +0200
Message-ID: <20260909221844.1650275-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260909221844.1650275-1-pablo@netfilter.org>
References: <20260909221844.1650275-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Modules can be removed in the middle of a netlink dump. Set .module to
THIS_MODULE in struct netlink_dump_control to hold a reference on the
module while netlink dump is in progress.

See commit 6dc878a8ca39 ("netlink: add reference of module in
netlink_dump_start") which describes this problem.

Fixes: a7b4f989a629 ("netfilter: ipset: IP set core support")
Fixes: c1d10adb4a52 ("[NETFILTER]: Add ctnetlink port for nf_conntrack")
Fixes: 50978462300f ("netfilter: add cttimeout infrastructure for fine timeout tuning")
Fixes: 9413902796f5 ("netfilter: add extended accounting infrastructure over nfnetlink")
Fixes: 12f7a505331e ("netfilter: add user-space connection tracking helper infrastructure")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c    | 1 +
 net/netfilter/nf_conntrack_netlink.c | 7 +++++++
 net/netfilter/nfnetlink_acct.c       | 1 +
 net/netfilter/nfnetlink_cthelper.c   | 1 +
 net/netfilter/nfnetlink_cttimeout.c  | 1 +
 5 files changed, 11 insertions(+)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 0a86a170ba90..624c5f14acf6 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1733,6 +1733,7 @@ static int ip_set_dump(struct sk_buff *skb, const struct nfnl_info *info,
 			.start = ip_set_dump_start,
 			.dump = ip_set_dump_do,
 			.done = ip_set_dump_done,
+			.module = THIS_MODULE,
 		};
 		return netlink_dump_start(info->sk, skb, info->nlh, &c);
 	}
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 579ada063b1b..2340885b2076 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1682,6 +1682,7 @@ static int ctnetlink_get_conntrack(struct sk_buff *skb,
 			.start = ctnetlink_start,
 			.dump = ctnetlink_dump_table,
 			.done = ctnetlink_done,
+			.module = THIS_MODULE,
 			.data = (void *)cda,
 		};
 
@@ -1826,6 +1827,7 @@ static int ctnetlink_get_ct_dying(struct sk_buff *skb,
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.dump = ctnetlink_dump_dying,
+			.module = THIS_MODULE,
 		};
 		return netlink_dump_start(info->sk, skb, info->nlh, &c);
 	}
@@ -1840,6 +1842,7 @@ static int ctnetlink_get_ct_unconfirmed(struct sk_buff *skb,
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.dump = ctnetlink_dump_unconfirmed,
+			.module = THIS_MODULE,
 		};
 		return netlink_dump_start(info->sk, skb, info->nlh, &c);
 	}
@@ -2555,6 +2558,7 @@ static int ctnetlink_stat_ct_cpu(struct sk_buff *skb,
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.dump = ctnetlink_ct_stat_cpu_dump,
+			.module = THIS_MODULE,
 		};
 		return netlink_dump_start(info->sk, skb, info->nlh, &c);
 	}
@@ -3278,6 +3282,7 @@ static int ctnetlink_dump_exp_ct(struct net *net, struct sock *ctnl,
 		.dump = ctnetlink_exp_ct_dump_table,
 		.start = ctnetlink_dump_exp_ct_start,
 		.done = ctnetlink_dump_exp_ct_done,
+		.module = THIS_MODULE,
 	};
 
 	err = ctnetlink_parse_tuple(cda, &tuple, CTA_EXPECT_MASTER,
@@ -3327,6 +3332,7 @@ static int ctnetlink_get_expect(struct sk_buff *skb,
 		else {
 			struct netlink_dump_control c = {
 				.dump = ctnetlink_exp_dump_table,
+				.module = THIS_MODULE,
 			};
 			return netlink_dump_start(info->sk, skb, info->nlh, &c);
 		}
@@ -3748,6 +3754,7 @@ static int ctnetlink_stat_exp_cpu(struct sk_buff *skb,
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.dump = ctnetlink_exp_stat_cpu_dump,
+			.module = THIS_MODULE,
 		};
 		return netlink_dump_start(info->sk, skb, info->nlh, &c);
 	}
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 8ff1e0ad5cb0..39a62bb9a6e6 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -284,6 +284,7 @@ static int nfnl_acct_get(struct sk_buff *skb, const struct nfnl_info *info,
 			.dump = nfnl_acct_dump,
 			.start = nfnl_acct_start,
 			.done = nfnl_acct_done,
+			.module = THIS_MODULE,
 			.data = (void *)tb[NFACCT_FILTER],
 		};
 
diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 5b6a09f46903..1331aba007ba 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -644,6 +644,7 @@ static int nfnl_cthelper_get(struct sk_buff *skb, const struct nfnl_info *info,
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.dump = nfnl_cthelper_dump_table,
+			.module = THIS_MODULE,
 		};
 		return netlink_dump_start(info->sk, skb, info->nlh, &c);
 	}
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 132c02ac7c4e..29de875d1713 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -277,6 +277,7 @@ static int cttimeout_get_timeout(struct sk_buff *skb,
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.dump = ctnl_timeout_dump,
+			.module = THIS_MODULE,
 		};
 		return netlink_dump_start(info->sk, skb, info->nlh, &c);
 	}
-- 
2.47.3

