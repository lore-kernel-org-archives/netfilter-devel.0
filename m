Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26D6456DF6
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2026 11:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435271; cv=none; b=tsCZyhffFuSHDcEgIuoFFiEPqyxO0pzY2R/LzBseE4/NQcebfSW4aEXlCctfqOuh3LAK66oNpAz96xcczNRZdSfNrwcFC3Aq6ANW9jyji23j0dmy7MzeNCgbncfpE2l9JlEnuQxRo0WUu0O8EX6QbxuzRnjGfMcIRWSGeHtVKis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435271; c=relaxed/simple;
	bh=af//ZibZ6MQmeUMqYGT/cnLnqkxBYrErAH88OQeZxKo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VypPoRURsskNDl83qSqNU/bBlgI1Ww72L/wNWVU68YVDiOvuwy1R5R6oJCQdCcDxD11fpvkJDwj88Y1ECxR92N5EZC7/x+DJ0iwA0YOl5ccTbWlkZFYRr3y9KZnk+sdAGrMfmdthIlIISCyGUExNCo5IZWBroklXRqvhHWIK0V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bpsY+MSy; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bpsY+MSy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788435261;
	bh=QA6g8xsLtZjfWWXq/7HTQfd2Mpepe2oQqLCCJptPWrk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=bpsY+MSyGWOj5ItoBRoE/P+8omp6HrMPAKyUnqbx4UzKZ+zUnn4r9tYP5Ta3hzPLu
	 /VE2J5WhfohcJLdAQYIlx3WgtLF9jx6XpImhw779OE14AZSj9aPB4nsG2ueUySIeZ+
	 IIt33pIWLkrnevczRo2CIpCLLifInK3xj1XfvMbgcDI/9HLClI0T5GnoNoBBjViyZB
	 GyiHvWaQNcfBzLe0bP6+ZJDWfo4XFJQakt2pN7P2rhQ93ARBo5PJAbr4H7lla0Dfi9
	 wLhpbCtF/8ge28lPjgpZuTttkUP8Ojek+vO2CDgwNr8ji7wKPiYLk1ycVrv0MkaKmX
	 UYnd+mLytdzeg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8077A607ED
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2026 13:34:21 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 5/8] netfilter: sysctl: use GFP_KERNEL_ACCOUNT
Date: Thu,  3 Sep 2026 13:34:10 +0200
Message-ID: <20260903113413.1122606-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903113413.1122606-1-pablo@netfilter.org>
References: <20260903113413.1122606-1-pablo@netfilter.org>
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
v2: new in this series, formerly nf_log: + chunk that slipped through in ipset

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

