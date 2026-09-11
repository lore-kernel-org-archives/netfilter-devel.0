Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A581546EC7C;
	Fri, 11 Sep 2026 08:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789116301; cv=none; b=aCxQysh4GE9ePmAVHHPy5psdLfl+I/a7p68StKnOdhQM4ZI/0I+LvQ4p9536k8ZywM7ZQAGnrapj0E+PptjJltF2hmxzxLHIFibnzlqVetCYt5obZ5k6pQ330IeMLD+XVHoAGTXaSDHQmN9cZJdgNsCRHodLWz5d1+g7jdSl3TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789116301; c=relaxed/simple;
	bh=NBU/r3pHiVCwirL0bpjiiwszvSYY75+db+/ZSX4Kbq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+8tEvuxPhX0rHyjS72K6HtHkpGsrVm9+f8t9p8Vy5+hvcLVPp7AwiL0Wkei0PuPEyEHk+lRIFE38/iionXRP5NJ0Xspd/QsCzW5b1xbsKFnI4MZcCFVbQ0SWRMfpbeo6q4Y+xlV3qKWHuWo1Ca+psZNKUs+AY2Vrlp/hL16uGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IuSgAZdp; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IuSgAZdp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789116292;
	bh=nscLJtFml+dV0HAVphj07zNRvDGfDmVjHneIRp0ar9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IuSgAZdpWGlxh+GwgEAQVVa3IKptHwc0EzYyYkz6hCbGpcwtkYO3zHXVObfFlDm7K
	 igLcNvmjaAwAzmSnlWBfbQy5wDtEOd5IXjhjaifzyPO57/lXZbq9wHTcCr6JXrIv8a
	 vbJqpB2vksM8Ouy7m/MiBuZ/jbrbqeD4pEmRG7wcIJO+m7hGJdEVR6F2PiKnegrGzY
	 gw9lIgbOhQRIPjxnGKklz7N8eruy/YaN1EKKrxhb0rCSfPCOtMR8oKCXGkxJNVeTl2
	 0TyWKWkUbvfTlfRFjqBQtfobFW4loYIB1GYTcBcQo48kZJiFVB2htZUBzlAYB+jtfY
	 ssi0HgZ/TirrA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3B0E9603E5;
	Fri, 11 Sep 2026 10:44:52 +0200 (CEST)
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
Subject: [PATCH net-next 6/8] netfilter: sysctl: use GFP_KERNEL_ACCOUNT
Date: Fri, 11 Sep 2026 10:44:35 +0200
Message-ID: <20260911084437.1838161-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260911084437.1838161-1-pablo@netfilter.org>
References: <20260911084437.1838161-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

GFP_KERNEL_ACCOUNT is preferred these days for memcg, replace
GFP_KERNEL by GFP_KERNEL_ACCOUNT.

Allocate per-netns sysctl via GFP_KERNEL_ACCOUNT.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_standalone.c | 2 +-
 net/netfilter/nf_hooks_lwtunnel.c       | 2 +-
 net/netfilter/nf_log.c                  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index f4f2d82192d5..d88a10230862 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -1009,7 +1009,7 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 	BUILD_BUG_ON(ARRAY_SIZE(nf_ct_sysctl_table) != NF_SYSCTL_CT_LAST_SYSCTL);
 
 	table = kmemdup(nf_ct_sysctl_table, sizeof(nf_ct_sysctl_table),
-			GFP_KERNEL);
+			GFP_KERNEL_ACCOUNT);
 	if (!table)
 		return -ENOMEM;
 
diff --git a/net/netfilter/nf_hooks_lwtunnel.c b/net/netfilter/nf_hooks_lwtunnel.c
index 4e1eef1ba0f1..40c6fce14a63 100644
--- a/net/netfilter/nf_hooks_lwtunnel.c
+++ b/net/netfilter/nf_hooks_lwtunnel.c
@@ -73,7 +73,7 @@ static int __net_init nf_lwtunnel_net_init(struct net *net)
 	if (!net_eq(net, &init_net)) {
 		table = kmemdup(nf_lwtunnel_sysctl_table,
 				sizeof(nf_lwtunnel_sysctl_table),
-				GFP_KERNEL);
+				GFP_KERNEL_ACCOUNT);
 		if (!table)
 			goto err_alloc;
 	}
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index f4d80654dfe6..f1d3649e3fc6 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -493,7 +493,7 @@ static int netfilter_log_sysctl_init(struct net *net)
 	if (!net_eq(net, &init_net)) {
 		table = kmemdup(nf_log_sysctl_table,
 				 sizeof(nf_log_sysctl_table),
-				 GFP_KERNEL);
+				 GFP_KERNEL_ACCOUNT);
 		if (!table)
 			goto err_alloc;
 	} else {
-- 
2.47.3

