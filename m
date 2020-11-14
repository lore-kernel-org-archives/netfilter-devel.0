Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3472AC63697
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Nov 2020 17:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF90F2223C
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Nov 2020 17:42:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QO4QLsnw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgKNRmh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 14 Nov 2020 12:42:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbgKNRmg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 14 Nov 2020 12:42:36 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C041BC0613D1
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Nov 2020 09:42:36 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id h6so9395458pgk.4
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Nov 2020 09:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :cc:to;
        bh=bRlrpwkmstJu1d89wKBPH1yyb9oj106zB6LAcNX3xw0=;
        b=QO4QLsnw6hzdy33kiHltoSLIwiIAURasBUIX61JITeu42aunPyQ+kDFNosROI80B5l
         tW6aIQTgBjhVbkV35Qc5PTQNw+PXPUKszZ4A8WX4A6Z7CmcmnlOanVaQzuFfKvCQIGhJ
         /sk83/S9/eVnOs21GX7ThZ1I7coNPRjTVUEdYMoVcUYbZFxdM/44my750Fj5aYE85OBA
         qDOEikfZxRLIfQfJjyYJ/Q2/IGy0ag9M/enMcwA0oCL443/ZeW8Fyzmc35igXYGek+2m
         xuwUEgMcQLfoJy4Tlv9b0q3TuV1d3kFJr8Bzeo7l4DDyI15aaqsq5Ipb4ZeDSAFP7cf2
         xW2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=bRlrpwkmstJu1d89wKBPH1yyb9oj106zB6LAcNX3xw0=;
        b=jM4oFlGjsgLBrYvSogRnAqq0MnuT8rf/UKs506SMMKg4CEM8Pzz35QNbd1kxJDwssX
         qmOEUV1iKu3ZbneCTOi1Ghm2/uiL26xtdozvEokSydVD9qtcqlPKr8NCRnMLOeD/OwIr
         B76nTOLHQsyzkVHYFWCm5WVxvhnFI2q4RWYu7PuYKFEk4ACiTOU9FCvega2boBQNSlWd
         0IDCxC+fdjMjxHXzWEBSsE+NqDPuTQfxEcDUeJERpPh3CqmyHGrtNaUOBOdCq+G/TdhD
         3Dw68x1tv31WvHRZuYIlqRO/4BKJSLODsTsVXqlT/pcJhCB0cQUKRcoyyENYPlvknHfn
         E6cA==
X-Gm-Message-State: AOAM533PsxRpTbmF02JT90Rb4rfHDA9Ym6K0DhCSe0xPSd3Q40Nd9Ld+
        Oub2iaWqF4/ckSbwWBBsJ6uv6LrnNqCfXA==
X-Google-Smtp-Source: ABdhPJw3thJjDzu9Ef/Nwg9sazM+w+IO8j79nVRLloTj7/EcanHMmiQK3yOY4sO4FxnyC6xhDbsoBA==
X-Received: by 2002:a63:cd0f:: with SMTP id i15mr6620095pgg.46.1605375755812;
        Sat, 14 Nov 2020 09:42:35 -0800 (PST)
Received: from [10.7.1.10] ([133.130.111.179])
        by smtp.gmail.com with ESMTPSA id a23sm11733264pgv.35.2020.11.14.09.42.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 Nov 2020 09:42:35 -0800 (PST)
From:   Wang Shanker <shankerwangmiao@gmail.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: [PATCH] netfilter: nfnl_acct: remove data from struct net
Message-Id: <2D679487-4F6A-405E-AC4E-B47539F1969A@gmail.com>
Date:   Sun, 15 Nov 2020 01:42:30 +0800
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
To:     netfilter-devel@vger.kernel.org
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch removes nfnl_acct_list from struct net, making it possible to
compile the nfacct module out of tree.

Signed-off-by: Miao Wang <shankerwangmiao@gmail.com>
---
 include/net/net_namespace.h    |  3 ---
 net/netfilter/nfnetlink_acct.c | 38 ++++++++++++++++++++++++++--------
 2 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 22bc07f4b043..dc20a47e3828 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -151,9 +151,6 @@ struct net {
 #endif
 	struct sock		*nfnl;
 	struct sock		*nfnl_stash;
-#if IS_ENABLED(CONFIG_NETFILTER_NETLINK_ACCT)
-	struct list_head        nfnl_acct_list;
-#endif
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK_TIMEOUT)
 	struct list_head	nfct_timeout_list;
 #endif
diff --git a/net/netfilter/nfnetlink_acct.c =
b/net/netfilter/nfnetlink_acct.c
index 5bfec829c12f..ae56756fab46 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -16,6 +16,7 @@
 #include <linux/errno.h>
 #include <net/netlink.h>
 #include <net/sock.h>
+#include <net/netns/generic.h>
=20
 #include <linux/netfilter.h>
 #include <linux/netfilter/nfnetlink.h>
@@ -41,6 +42,17 @@ struct nfacct_filter {
 	u32 mask;
 };
=20
+struct nfnl_acct_net {
+	struct list_head        nfnl_acct_list;
+};
+
+static unsigned int nfnl_acct_net_id __read_mostly;
+
+static inline struct nfnl_acct_net *nfnl_acct_pernet(struct net *net)
+{
+	return net_generic(net, nfnl_acct_net_id);
+}
+
 #define NFACCT_F_QUOTA (NFACCT_F_QUOTA_PKTS | NFACCT_F_QUOTA_BYTES)
 #define NFACCT_OVERQUOTA_BIT	2	/* NFACCT_F_OVERQUOTA */
=20
@@ -53,6 +65,7 @@ static int nfnl_acct_new(struct net *net, struct sock =
*nfnl,
 	char *acct_name;
 	unsigned int size =3D 0;
 	u32 flags =3D 0;
+	struct nfnl_acct_net *nfnl_acct_net =3D nfnl_acct_pernet(net);
=20
 	if (!tb[NFACCT_NAME])
 		return -EINVAL;
@@ -61,7 +74,7 @@ static int nfnl_acct_new(struct net *net, struct sock =
*nfnl,
 	if (strlen(acct_name) =3D=3D 0)
 		return -EINVAL;
=20
-	list_for_each_entry(nfacct, &net->nfnl_acct_list, head) {
+	list_for_each_entry(nfacct, &nfnl_acct_net->nfnl_acct_list, =
head) {
 		if (strncmp(nfacct->name, acct_name, NFACCT_NAME_MAX) !=3D=
 0)
 			continue;
=20
@@ -123,7 +136,7 @@ static int nfnl_acct_new(struct net *net, struct =
sock *nfnl,
 			     =
be64_to_cpu(nla_get_be64(tb[NFACCT_PKTS])));
 	}
 	refcount_set(&nfacct->refcnt, 1);
-	list_add_tail_rcu(&nfacct->head, &net->nfnl_acct_list);
+	list_add_tail_rcu(&nfacct->head, =
&nfnl_acct_net->nfnl_acct_list);
 	return 0;
 }
=20
@@ -190,6 +203,7 @@ nfnl_acct_dump(struct sk_buff *skb, struct =
netlink_callback *cb)
 	struct net *net =3D sock_net(skb->sk);
 	struct nf_acct *cur, *last;
 	const struct nfacct_filter *filter =3D cb->data;
+	struct nfnl_acct_net *nfnl_acct_net =3D nfnl_acct_pernet(net);
=20
 	if (cb->args[2])
 		return 0;
@@ -199,7 +213,7 @@ nfnl_acct_dump(struct sk_buff *skb, struct =
netlink_callback *cb)
 		cb->args[1] =3D 0;
=20
 	rcu_read_lock();
-	list_for_each_entry_rcu(cur, &net->nfnl_acct_list, head) {
+	list_for_each_entry_rcu(cur, &nfnl_acct_net->nfnl_acct_list, =
head) {
 		if (last) {
 			if (cur !=3D last)
 				continue;
@@ -272,6 +286,7 @@ static int nfnl_acct_get(struct net *net, struct =
sock *nfnl,
 	int ret =3D -ENOENT;
 	struct nf_acct *cur;
 	char *acct_name;
+	struct nfnl_acct_net *nfnl_acct_net =3D nfnl_acct_pernet(net);
=20
 	if (nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c =3D {
@@ -288,7 +303,7 @@ static int nfnl_acct_get(struct net *net, struct =
sock *nfnl,
 		return -EINVAL;
 	acct_name =3D nla_data(tb[NFACCT_NAME]);
=20
-	list_for_each_entry(cur, &net->nfnl_acct_list, head) {
+	list_for_each_entry(cur, &nfnl_acct_net->nfnl_acct_list, head) {
 		struct sk_buff *skb2;
=20
 		if (strncmp(cur->name, acct_name, NFACCT_NAME_MAX)!=3D =
0)
@@ -345,16 +360,17 @@ static int nfnl_acct_del(struct net *net, struct =
sock *nfnl,
 	struct nf_acct *cur, *tmp;
 	int ret =3D -ENOENT;
 	char *acct_name;
+	struct nfnl_acct_net *nfnl_acct_net =3D nfnl_acct_pernet(net);
=20
 	if (!tb[NFACCT_NAME]) {
-		list_for_each_entry_safe(cur, tmp, &net->nfnl_acct_list, =
head)
+		list_for_each_entry_safe(cur, tmp, =
&nfnl_acct_net->nfnl_acct_list, head)
 			nfnl_acct_try_del(cur);
=20
 		return 0;
 	}
 	acct_name =3D nla_data(tb[NFACCT_NAME]);
=20
-	list_for_each_entry(cur, &net->nfnl_acct_list, head) {
+	list_for_each_entry(cur, &nfnl_acct_net->nfnl_acct_list, head) {
 		if (strncmp(cur->name, acct_name, NFACCT_NAME_MAX) !=3D =
0)
 			continue;
=20
@@ -403,9 +419,10 @@ MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_ACCT);
 struct nf_acct *nfnl_acct_find_get(struct net *net, const char =
*acct_name)
 {
 	struct nf_acct *cur, *acct =3D NULL;
+	struct nfnl_acct_net *nfnl_acct_net =3D nfnl_acct_pernet(net);
=20
 	rcu_read_lock();
-	list_for_each_entry_rcu(cur, &net->nfnl_acct_list, head) {
+	list_for_each_entry_rcu(cur, &nfnl_acct_net->nfnl_acct_list, =
head) {
 		if (strncmp(cur->name, acct_name, NFACCT_NAME_MAX)!=3D =
0)
 			continue;
=20
@@ -488,7 +505,7 @@ EXPORT_SYMBOL_GPL(nfnl_acct_overquota);
=20
 static int __net_init nfnl_acct_net_init(struct net *net)
 {
-	INIT_LIST_HEAD(&net->nfnl_acct_list);
+	INIT_LIST_HEAD(&nfnl_acct_pernet(net)->nfnl_acct_list);
=20
 	return 0;
 }
@@ -496,8 +513,9 @@ static int __net_init nfnl_acct_net_init(struct net =
*net)
 static void __net_exit nfnl_acct_net_exit(struct net *net)
 {
 	struct nf_acct *cur, *tmp;
+	struct nfnl_acct_net *nfnl_acct_net =3D nfnl_acct_pernet(net);
=20
-	list_for_each_entry_safe(cur, tmp, &net->nfnl_acct_list, head) {
+	list_for_each_entry_safe(cur, tmp, =
&nfnl_acct_net->nfnl_acct_list, head) {
 		list_del_rcu(&cur->head);
=20
 		if (refcount_dec_and_test(&cur->refcnt))
@@ -508,6 +526,8 @@ static void __net_exit nfnl_acct_net_exit(struct net =
*net)
 static struct pernet_operations nfnl_acct_ops =3D {
         .init   =3D nfnl_acct_net_init,
         .exit   =3D nfnl_acct_net_exit,
+	.id     =3D &nfnl_acct_net_id,
+	.size   =3D sizeof(struct nfnl_acct_net),
 };
=20
 static int __init nfnl_acct_init(void)
--=20
2.20.1


