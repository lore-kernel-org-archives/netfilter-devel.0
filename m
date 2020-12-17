Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91FF7C4361B
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Dec 2020 04:39:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 596C423731
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Dec 2020 04:39:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgLQEjc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Dec 2020 23:39:32 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:17251 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbgLQEjb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Dec 2020 23:39:31 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608179950; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=2bmeHaMbBblas81vkHUfD0cv65/KqZ6a8Tg8grAFzRE=; b=tcVxBv3ujrB/3VhTmyLqFG9Epj5ognkpr8vbIRFzH02MZ9IAubaIRj99+Wnot8QjpuIvnu3r
 6JVSdUTEdGuiod14M+omBXrBMQg/xqlSaFPp6KD3YL482Dn8LoiYTWgOPhj+sK/agYrdoHpG
 0VdxekgtlGqKkhcCApvwlipQOII=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJlM2NhZSIsICJuZXRmaWx0ZXItZGV2ZWxAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-west-2.postgun.com with SMTP id
 5fdae0d1065be8d83555a5de (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 17 Dec 2020 04:38:41
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 46139C43461; Thu, 17 Dec 2020 04:38:41 +0000 (UTC)
Received: from subashab-lnx.qualcomm.com (unknown [129.46.15.92])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C3C9FC433CA;
        Thu, 17 Dec 2020 04:38:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C3C9FC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=subashab@codeaurora.org
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     fw@strlen.de, lkp@intel.com, pablo@netfilter.org,
        netfilter-devel@vger.kernel.org, stranche@codeaurora.org
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH nf] netfilter: x_tables: Update remaining dereference to RCU
Date:   Wed, 16 Dec 2020 21:38:02 -0700
Message-Id: <1608179882-1207-1-git-send-email-subashab@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This fixes the dereference to fetch the RCU pointer when holding
the appropriate xtables lock.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: cc00bcaa5899 ("netfilter: x_tables: Switch synchronization to RCU")
Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 net/ipv4/netfilter/arp_tables.c | 2 +-
 net/ipv4/netfilter/ip_tables.c  | 2 +-
 net/ipv6/netfilter/ip6_tables.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 563b62b..c576a63 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1379,7 +1379,7 @@ static int compat_get_entries(struct net *net,
 	xt_compat_lock(NFPROTO_ARP);
 	t = xt_find_table_lock(net, NFPROTO_ARP, get.name);
 	if (!IS_ERR(t)) {
-		const struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = xt_table_get_private_protected(t);
 		struct xt_table_info info;
 
 		ret = compat_table_info(private, &info);
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 6e2851f..e8f6f9d 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1589,7 +1589,7 @@ compat_get_entries(struct net *net, struct compat_ipt_get_entries __user *uptr,
 	xt_compat_lock(AF_INET);
 	t = xt_find_table_lock(net, AF_INET, get.name);
 	if (!IS_ERR(t)) {
-		const struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = xt_table_get_private_protected(t);
 		struct xt_table_info info;
 		ret = compat_table_info(private, &info);
 		if (!ret && get.size == info.size)
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index c4f532f..0d453fa 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1598,7 +1598,7 @@ compat_get_entries(struct net *net, struct compat_ip6t_get_entries __user *uptr,
 	xt_compat_lock(AF_INET6);
 	t = xt_find_table_lock(net, AF_INET6, get.name);
 	if (!IS_ERR(t)) {
-		const struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = xt_table_get_private_protected(t);
 		struct xt_table_info info;
 		ret = compat_table_info(private, &info);
 		if (!ret && get.size == info.size)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

