Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 238A9C433E0
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Mar 2021 01:33:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8EF56519A
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Mar 2021 01:32:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbhCDBcn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Mar 2021 20:32:43 -0500
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:41472 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbhCDBcj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Mar 2021 20:32:39 -0500
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 751E2891AE;
        Thu,  4 Mar 2021 14:31:57 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1614821517;
        bh=DTkdP6lVBb5tEo3BUJ3WXbNBPwWXO2PZGFbrBs7FH0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=p+gLtZZBHGSs00oKx1jBXbTLusYYQtY0i+KUT3QEJo2tmfogbzSRarVu52ED8N75q
         1fM5iD0EKFVjhRSi18uTTNjZGzeHVPPARNs6rWnrMLFWat4psL57YB2UZAYHVcNERj
         8fz/ygqrRov8f9+F4VECO2JJUSm0dWV0r8Z0cmuDt+pJZy+0fFXbP6+Vr2KyGUK+kr
         tmD19PKHCsuE9VL5hd5033JlXEn/94EyLiHjw/+bVZfXRpUgRZ0rvYCoPfWTBW9G+J
         j+DDLP0Z0TN5gsYkj0Qe00zPXaB2cPB/XEBOh7Bq3XkOefsDGaL6snkg5bYe3SQVoh
         Wu9JW5GSJ7MUQ==
Received: from smtp (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B6040388d0001>; Thu, 04 Mar 2021 14:31:57 +1300
Received: from markto-dl.ws.atlnz.lc (markto-dl.ws.atlnz.lc [10.33.23.25])
        by smtp (Postfix) with ESMTP id 5E24F13EF39;
        Thu,  4 Mar 2021 14:32:08 +1300 (NZDT)
Received: by markto-dl.ws.atlnz.lc (Postfix, from userid 1155)
        id 3CCCF340F72; Thu,  4 Mar 2021 14:31:57 +1300 (NZDT)
From:   Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Subject: [PATCH 1/3] Revert "netfilter: x_tables: Update remaining dereference to RCU"
Date:   Thu,  4 Mar 2021 14:31:14 +1300
Message-Id: <20210304013116.8420-2-mark.tomlinson@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304013116.8420-1-mark.tomlinson@alliedtelesis.co.nz>
References: <20210304013116.8420-1-mark.tomlinson@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=C7uXNjH+ c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=dESyimp9J3IA:10 a=VwQbUJbxAAAA:8 a=lnAaa70jyVaqVYQrNNUA:9 a=AjGcO6oz07-iQ99wixmX:22 a=BPzZvq435JnGatEyYwdK:22
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This reverts commit 443d6e86f821a165fae3fc3fc13086d27ac140b1.

This (and the following) patch basically re-implemented the RCU
mechanisms of patch 784544739a25. That patch was replaced because of the
performance problems that it created when replacing tables. Now, we have
the same issue: the call to synchronize_rcu() makes replacing tables
slower by as much as an order of magnitude.

See https://lore.kernel.org/patchwork/patch/151796/ for why using RCU is
not a good idea.

Revert these patches and fix the issue in a different way.

Signed-off-by: Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
---
 net/ipv4/netfilter/arp_tables.c | 2 +-
 net/ipv4/netfilter/ip_tables.c  | 2 +-
 net/ipv6/netfilter/ip6_tables.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tab=
les.c
index c576a63d09db..563b62b76a5f 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1379,7 +1379,7 @@ static int compat_get_entries(struct net *net,
 	xt_compat_lock(NFPROTO_ARP);
 	t =3D xt_find_table_lock(net, NFPROTO_ARP, get.name);
 	if (!IS_ERR(t)) {
-		const struct xt_table_info *private =3D xt_table_get_private_protected=
(t);
+		const struct xt_table_info *private =3D t->private;
 		struct xt_table_info info;
=20
 		ret =3D compat_table_info(private, &info);
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_table=
s.c
index e8f6f9d86237..6e2851f8d3a3 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1589,7 +1589,7 @@ compat_get_entries(struct net *net, struct compat_i=
pt_get_entries __user *uptr,
 	xt_compat_lock(AF_INET);
 	t =3D xt_find_table_lock(net, AF_INET, get.name);
 	if (!IS_ERR(t)) {
-		const struct xt_table_info *private =3D xt_table_get_private_protected=
(t);
+		const struct xt_table_info *private =3D t->private;
 		struct xt_table_info info;
 		ret =3D compat_table_info(private, &info);
 		if (!ret && get.size =3D=3D info.size)
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tab=
les.c
index 0d453fa9e327..c4f532f4d311 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1598,7 +1598,7 @@ compat_get_entries(struct net *net, struct compat_i=
p6t_get_entries __user *uptr,
 	xt_compat_lock(AF_INET6);
 	t =3D xt_find_table_lock(net, AF_INET6, get.name);
 	if (!IS_ERR(t)) {
-		const struct xt_table_info *private =3D xt_table_get_private_protected=
(t);
+		const struct xt_table_info *private =3D t->private;
 		struct xt_table_info info;
 		ret =3D compat_table_info(private, &info);
 		if (!ret && get.size =3D=3D info.size)
--=20
2.30.1

