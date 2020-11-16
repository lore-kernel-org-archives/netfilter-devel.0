Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C83FC4742C
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Nov 2020 04:17:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40AE4222C4
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Nov 2020 04:17:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E3jvs/ue"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbgKPER3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 Nov 2020 23:17:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbgKPER2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Nov 2020 23:17:28 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2CDBC0613CF
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2020 20:17:28 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id c20so12893325pfr.8
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2020 20:17:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=c+YgiFuqUqxZjjhybldaEzc4ruOux+6tvGR785TpMKs=;
        b=E3jvs/ueRLR+X5t8/2BaDY4RIFR5dYqCUqZcgkCw5syGmm3kBidu4ZFtE0EDxVQEpF
         nZWXgZQW8eItUQeHKGVdGsyXyQ73/ngbPMRXSNldEEtgARAMGtZxerX8EDJP/PrU8ed6
         VuO1xg9iVNAYmyCXqKoFZbeIaacLB+vDNsRoNhpjAx29zq1ns6VxJrGZdYAjuw/I9ZtU
         MyiYVG6Tuwi39iUWu2lh5cHFLp2z3bGV+RUkUSq/Rep/59U39ViFKi9qt5wpx4uONzS7
         r8q0LyySrxwl6sCBIbF9m1Ab+SR5X/tKNRU+Id7VAw7AARQMOCBXBTT+kxeHOJHFgaDL
         Xt+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=c+YgiFuqUqxZjjhybldaEzc4ruOux+6tvGR785TpMKs=;
        b=uPcb9T0zlhy6zjZjkul9HTJ/+fYdiCJ7iSvbllK0oZ+InUul9rY2Kmhdm+XJZgKBIA
         ixzYDE/xq1aODW0u1Ci4Pk6A+rGgC9VMgYPgu5h0thZNo+wxf3XHDmIF9C1HzAT9eohG
         G8l3htWJ4+R7qiVD45LgSd7TJHDO80uK64MKReznm73dS3dIO+Cq5NeG0X7vzb8AHPL+
         XJUTLYnDCIjP6+w3IIaplf3Oi4EWefGMZEeWUCeHg4MBcR9suc9osDC7j5V+a5bXbEgD
         Q1yjLFj9yow6OutRn8GoA9eEMWOL8/p9pUSvyne/15urE5rzXBll9OhLwOdGOtEXUqgH
         uQuA==
X-Gm-Message-State: AOAM532jRXGZ+d1V0Wdm2+FRg3lvEhGRC9fmrd33dFoR8oTMZE0h1RDs
        mh80NysI+x7AVYzLpciLiXXayFZrPudu1w==
X-Google-Smtp-Source: ABdhPJwRLwO5JkJrXeFuY2kW02NXbg5U9V5dN+QddQoyX59giFnx7sNppP1edtmJwppVIUyL+Fa6BA==
X-Received: by 2002:a17:90a:7c03:: with SMTP id v3mr14122204pjf.28.1605500248006;
        Sun, 15 Nov 2020 20:17:28 -0800 (PST)
Received: from [10.7.3.1] ([133.130.111.179])
        by smtp.gmail.com with ESMTPSA id r2sm16155880pji.55.2020.11.15.20.17.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Nov 2020 20:17:27 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: [PATCH v2] netfilter: nfnl_acct: remove data from struct net
From:   Wang Shanker <shankerwangmiao@gmail.com>
In-Reply-To: <20201115110432.GA23896@salvia>
Date:   Mon, 16 Nov 2020 12:17:24 +0800
Cc:     netfilter-devel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Content-Transfer-Encoding: quoted-printable
Message-Id: <BC5D575D-5AA9-40AD-AEF6-67BF2111BCD4@gmail.com>
References: <2D679487-4F6A-405E-AC4E-B47539F1969A@gmail.com>
 <20201115110432.GA23896@salvia>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch removes nfnl_acct_list from struct net, making it possible to
compile nfacct module out of tree and reducing the default memory
footprint for the netns structure.

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
index 5bfec829c12f..dbc2fc8940c8 100644
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
@@ -49,6 +61,7 @@ static int nfnl_acct_new(struct net *net, struct sock =
*nfnl,
 			 const struct nlattr * const tb[],
 			 struct netlink_ext_ack *extack)
 {
+	struct nfnl_acct_net *nfnl_acct_net =3D nfnl_acct_pernet(net);
 	struct nf_acct *nfacct, *matching =3D NULL;
 	char *acct_name;
 	unsigned int size =3D 0;
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
@@ -188,6 +201,7 @@ static int
 nfnl_acct_dump(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct net *net =3D sock_net(skb->sk);
+	struct nfnl_acct_net *nfnl_acct_net =3D nfnl_acct_pernet(net);
 	struct nf_acct *cur, *last;
 	const struct nfacct_filter *filter =3D cb->data;
=20
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
@@ -269,6 +283,7 @@ static int nfnl_acct_get(struct net *net, struct =
sock *nfnl,
 			 const struct nlattr * const tb[],
 			 struct netlink_ext_ack *extack)
 {
+	struct nfnl_acct_net *nfnl_acct_net =3D nfnl_acct_pernet(net);
 	int ret =3D -ENOENT;
 	struct nf_acct *cur;
 	char *acct_name;
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
@@ -342,19 +357,20 @@ static int nfnl_acct_del(struct net *net, struct =
sock *nfnl,
 			 const struct nlattr * const tb[],
 			 struct netlink_ext_ack *extack)
 {
+	struct nfnl_acct_net *nfnl_acct_net =3D nfnl_acct_pernet(net);
 	struct nf_acct *cur, *tmp;
 	int ret =3D -ENOENT;
 	char *acct_name;
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
@@ -402,10 +418,11 @@ MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_ACCT);
=20
 struct nf_acct *nfnl_acct_find_get(struct net *net, const char =
*acct_name)
 {
+	struct nfnl_acct_net *nfnl_acct_net =3D nfnl_acct_pernet(net);
 	struct nf_acct *cur, *acct =3D NULL;
=20
 	rcu_read_lock();
-	list_for_each_entry_rcu(cur, &net->nfnl_acct_list, head) {
+	list_for_each_entry_rcu(cur, &nfnl_acct_net->nfnl_acct_list, =
head) {
 		if (strncmp(cur->name, acct_name, NFACCT_NAME_MAX)!=3D =
0)
 			continue;
=20
@@ -488,16 +505,17 @@ EXPORT_SYMBOL_GPL(nfnl_acct_overquota);
=20
 static int __net_init nfnl_acct_net_init(struct net *net)
 {
-	INIT_LIST_HEAD(&net->nfnl_acct_list);
+	INIT_LIST_HEAD(&nfnl_acct_pernet(net)->nfnl_acct_list);
=20
 	return 0;
 }
=20
 static void __net_exit nfnl_acct_net_exit(struct net *net)
 {
+	struct nfnl_acct_net *nfnl_acct_net =3D nfnl_acct_pernet(net);
 	struct nf_acct *cur, *tmp;
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
+        .id     =3D &nfnl_acct_net_id,
+        .size   =3D sizeof(struct nfnl_acct_net),
 };
=20
 static int __init nfnl_acct_init(void)
--=20
2.20.1

