Return-Path: <SRS0=fRNh=SB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F876C4360F
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Mar 2019 01:37:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F87C217F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Mar 2019 01:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553909865;
	bh=cgWWA4NdB4H980FSIjqAM4q10d158oVXZcb0Y/IiNRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=n1gzWhcdf7wm/e9OHDFn+wqgv+AfnbqSxMgvxhHSTlDHVGkm/9rlYKjeRQzin9/6D
	 ZwXgMKAvQdhsNu5AsSNSG5+hSU1K89VVNey4VnwNyPbjxIhVa4qGs99R86q26ktIkP
	 5RoO/MFr03OrKjIi/I5HbT06D/P2UEpSkGPu1Yw8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731658AbfC3Baa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Mar 2019 21:30:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731626AbfC3Ba3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Mar 2019 21:30:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 571D1217F5;
        Sat, 30 Mar 2019 01:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553909428;
        bh=cgWWA4NdB4H980FSIjqAM4q10d158oVXZcb0Y/IiNRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XQtZOGe+637WoDW5PKyAq3uMPjHxs/6lK1Kvp1W7Yf4IoJxAKPpCb3ZqLOqbRTnBt
         Xg3xgJ9YYo7A+7ufTwoZB5EP0GjGRi8qQ2jDxMjkX8xupBATJ9UFGkeoX1Wao9jw76
         INvm8MuAWDl51YVIJ4M6bnAlHEGe3+/BsldzXvo0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, Tejun Heo <tj@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 06/37] netfilter: xt_cgroup: shrink size of v2 path
Date:   Fri, 29 Mar 2019 21:29:49 -0400
Message-Id: <20190330013020.379-6-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190330013020.379-1-sashal@kernel.org>
References: <20190330013020.379-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 0d704967f4a49cc2212350b3e4a8231f8b4283ed ]

cgroup v2 path field is PATH_MAX which is too large, this is placing too
much pressure on memory allocation for people with many rules doing
cgroup v1 classid matching, side effects of this are bug reports like:

https://bugzilla.kernel.org/show_bug.cgi?id=200639

This patch registers a new revision that shrinks the cgroup path to 512
bytes, which is the same approach we follow in similar extensions that
have a path field.

Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/netfilter/xt_cgroup.h | 16 ++++++
 net/netfilter/xt_cgroup.c                | 72 ++++++++++++++++++++++++
 2 files changed, 88 insertions(+)

diff --git a/include/uapi/linux/netfilter/xt_cgroup.h b/include/uapi/linux/netfilter/xt_cgroup.h
index e96dfa1b34f7..b74e370d6133 100644
--- a/include/uapi/linux/netfilter/xt_cgroup.h
+++ b/include/uapi/linux/netfilter/xt_cgroup.h
@@ -22,4 +22,20 @@ struct xt_cgroup_info_v1 {
 	void		*priv __attribute__((aligned(8)));
 };
 
+#define XT_CGROUP_PATH_MAX	512
+
+struct xt_cgroup_info_v2 {
+	__u8		has_path;
+	__u8		has_classid;
+	__u8		invert_path;
+	__u8		invert_classid;
+	union {
+		char	path[XT_CGROUP_PATH_MAX];
+		__u32	classid;
+	};
+
+	/* kernel internal data */
+	void		*priv __attribute__((aligned(8)));
+};
+
 #endif /* _UAPI_XT_CGROUP_H */
diff --git a/net/netfilter/xt_cgroup.c b/net/netfilter/xt_cgroup.c
index 891f4e7e8ea7..db18c0177b0f 100644
--- a/net/netfilter/xt_cgroup.c
+++ b/net/netfilter/xt_cgroup.c
@@ -66,6 +66,38 @@ static int cgroup_mt_check_v1(const struct xt_mtchk_param *par)
 	return 0;
 }
 
+static int cgroup_mt_check_v2(const struct xt_mtchk_param *par)
+{
+	struct xt_cgroup_info_v2 *info = par->matchinfo;
+	struct cgroup *cgrp;
+
+	if ((info->invert_path & ~1) || (info->invert_classid & ~1))
+		return -EINVAL;
+
+	if (!info->has_path && !info->has_classid) {
+		pr_info("xt_cgroup: no path or classid specified\n");
+		return -EINVAL;
+	}
+
+	if (info->has_path && info->has_classid) {
+		pr_info_ratelimited("path and classid specified\n");
+		return -EINVAL;
+	}
+
+	info->priv = NULL;
+	if (info->has_path) {
+		cgrp = cgroup_get_from_path(info->path);
+		if (IS_ERR(cgrp)) {
+			pr_info_ratelimited("invalid path, errno=%ld\n",
+					    PTR_ERR(cgrp));
+			return -EINVAL;
+		}
+		info->priv = cgrp;
+	}
+
+	return 0;
+}
+
 static bool
 cgroup_mt_v0(const struct sk_buff *skb, struct xt_action_param *par)
 {
@@ -95,6 +127,24 @@ static bool cgroup_mt_v1(const struct sk_buff *skb, struct xt_action_param *par)
 			info->invert_classid;
 }
 
+static bool cgroup_mt_v2(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	const struct xt_cgroup_info_v2 *info = par->matchinfo;
+	struct sock_cgroup_data *skcd = &skb->sk->sk_cgrp_data;
+	struct cgroup *ancestor = info->priv;
+	struct sock *sk = skb->sk;
+
+	if (!sk || !sk_fullsock(sk) || !net_eq(xt_net(par), sock_net(sk)))
+		return false;
+
+	if (ancestor)
+		return cgroup_is_descendant(sock_cgroup_ptr(skcd), ancestor) ^
+			info->invert_path;
+	else
+		return (info->classid == sock_cgroup_classid(skcd)) ^
+			info->invert_classid;
+}
+
 static void cgroup_mt_destroy_v1(const struct xt_mtdtor_param *par)
 {
 	struct xt_cgroup_info_v1 *info = par->matchinfo;
@@ -103,6 +153,14 @@ static void cgroup_mt_destroy_v1(const struct xt_mtdtor_param *par)
 		cgroup_put(info->priv);
 }
 
+static void cgroup_mt_destroy_v2(const struct xt_mtdtor_param *par)
+{
+	struct xt_cgroup_info_v2 *info = par->matchinfo;
+
+	if (info->priv)
+		cgroup_put(info->priv);
+}
+
 static struct xt_match cgroup_mt_reg[] __read_mostly = {
 	{
 		.name		= "cgroup",
@@ -130,6 +188,20 @@ static struct xt_match cgroup_mt_reg[] __read_mostly = {
 				  (1 << NF_INET_POST_ROUTING) |
 				  (1 << NF_INET_LOCAL_IN),
 	},
+	{
+		.name		= "cgroup",
+		.revision	= 2,
+		.family		= NFPROTO_UNSPEC,
+		.checkentry	= cgroup_mt_check_v2,
+		.match		= cgroup_mt_v2,
+		.matchsize	= sizeof(struct xt_cgroup_info_v2),
+		.usersize	= offsetof(struct xt_cgroup_info_v2, priv),
+		.destroy	= cgroup_mt_destroy_v2,
+		.me		= THIS_MODULE,
+		.hooks		= (1 << NF_INET_LOCAL_OUT) |
+				  (1 << NF_INET_POST_ROUTING) |
+				  (1 << NF_INET_LOCAL_IN),
+	},
 };
 
 static int __init cgroup_mt_init(void)
-- 
2.19.1

