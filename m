Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED5C39794A
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 18:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788807364; cv=none; b=jFMA5JDJtdZLPZxGKBD9kYaEiPotALeaH/EEqyE3F0fl392vyVCdZdK4fPA+nm1QanIOBFTJ9TqTg7+NRpAlUE8jai/zDmJNE8IqSEvm55RHs5fF1KqqoDmlnxc/R9IVqIl0aAkXn49a/FFu1i+sW0pkjs0LkvyqegRcp8cekfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788807364; c=relaxed/simple;
	bh=KHmaaNGSo1IoO0UCjgfyyoKINbvfQpXpoGpXNkqENio=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4InXgBBUZaqYCzMhMG3dDAHoSsM2xCwYvmY2xIW9P7TBaTCvP7F4BD2YnMU/BEx+DP6WliPrGo+CqDQKQ5VfzdP4gdCdsT/sRmSyjQo/lNxqLK6n8vxI9nVyjVUmUHA1QSwlC+332xLTsE/rkVywlYfKmrz8RgopFJSR8mHgkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=j1/RWI38; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="j1/RWI38"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788807361;
	bh=iamynmgZLfX/9Fb/mGgQaJ9QRISjeOmQQeWzNRvF2qA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=j1/RWI38TInk5gRFf5SxuOMFD8eQ88uzpX9x7XuHa+kQEyCatG0uak47CO2WylEG1
	 nEnHGOuQ6vNdzyn93LwtP0i93l9hVAo+EcPds2mLXM1m5nC/f7dEMy0raGHFtAGsJ5
	 83GajopEhPu8EQgOF95JvaSDZ+cuR87qF67yPjKTzl6YRPvibF+sCsu+pCbmWEyt+a
	 bANz7/LUUWkyv8457gn6XVk61m0XNTl2oqSWp+zslYWDuMRY0pwROPDwRoiQv8GKZG
	 5DWUMsnSRu2W31rTZxzh4fSb0oXrTHlo8rwTQBdhvlIFvaZS0SBnau5dnVlt0IMipH
	 8+R82HR0bzgmw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 00ED760798
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 20:56:00 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v3 5/8] netfilter: sysctl: use GFP_KERNEL_ACCOUNT
Date: Mon,  7 Sep 2026 20:55:49 +0200
Message-ID: <20260907185552.1422008-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260907185552.1422008-1-pablo@netfilter.org>
References: <20260907185552.1422008-1-pablo@netfilter.org>
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
v3: no changes

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

