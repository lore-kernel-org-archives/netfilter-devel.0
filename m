Return-Path: <SRS0=mmGa=IG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DB83C433E0
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 01:25:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B817C65142
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 01:25:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233508AbhCHBZM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 7 Mar 2021 20:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233460AbhCHBYj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 Mar 2021 20:24:39 -0500
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED32C061760
        for <netfilter-devel@vger.kernel.org>; Sun,  7 Mar 2021 17:24:39 -0800 (PST)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id BBC29806B5;
        Mon,  8 Mar 2021 14:24:34 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1615166674;
        bh=3ChjARLI+JghjvJi6D+2e3uGZQ1moufjjv43Y4fwjOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=MMnUv746AwpVAcVs+E47WML1/eOh+YLmLXlmLg55OVO+lRMHXr191zKqP9cPbB6Lr
         2Y4Wzf47DKR4JT+bjxuhXeiDFlC4+1sYLAJnX8H0rjLK8WVMsaiYeuOYbsyF5DiaVN
         FIIZFlEttiRLcY4y93r5Y9adsI0J4ipkOj3XfKrL2dXtNQluxcU9Zv5krR/ETOo/SH
         8zVOKzcqjTgViJeHOYxld5Yqh1PdPY8o8KRBWxCoPHPYl/EeK9sdpLVaLKmTo0ql1M
         Zp0Db+1iS5I9uQtGnCzhlgSmY11NTT0tHf2ogLSO/UmCRWxnZCAQ/JxtNDvZuld4mo
         lYzL5OoS9dLvw==
Received: from smtp (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B60457cd20001>; Mon, 08 Mar 2021 14:24:34 +1300
Received: from markto-dl.ws.atlnz.lc (markto-dl.ws.atlnz.lc [10.33.23.25])
        by smtp (Postfix) with ESMTP id 90C4113EF6B;
        Mon,  8 Mar 2021 14:24:46 +1300 (NZDT)
Received: by markto-dl.ws.atlnz.lc (Postfix, from userid 1155)
        id 9969A340EA6; Mon,  8 Mar 2021 14:24:34 +1300 (NZDT)
From:   Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Cc:     subashab@codeaurora.org, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Subject: [PATCH v2 1/3] Revert "netfilter: x_tables: Update remaining dereference to RCU"
Date:   Mon,  8 Mar 2021 14:24:11 +1300
Message-Id: <20210308012413.14383-2-mark.tomlinson@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308012413.14383-1-mark.tomlinson@alliedtelesis.co.nz>
References: <20210308012413.14383-1-mark.tomlinson@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=C7uXNjH+ c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=dESyimp9J3IA:10 a=lnAaa70jyVaqVYQrNNUA:9
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

