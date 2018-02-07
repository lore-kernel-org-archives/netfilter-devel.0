From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 04/11] netfilter: xt_cgroup: initialize info->priv in cgroup_mt_check_v1()
Date: Wed,  7 Feb 2018 18:42:22 +0100
Message-ID: <20180207174229.4098-5-pablo@netfilter.org>
References: <20180207174229.4098-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46994 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754220AbeBGRml (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Feb 2018 12:42:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9C4003066B1
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2018 18:42:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8A6C6DA7F7
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2018 18:42:39 +0100 (CET)
In-Reply-To: <20180207174229.4098-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Cong Wang <xiyou.wangcong@gmail.com>

xt_cgroup_info_v1->priv is an internal pointer only used for kernel,
we should not trust what user-space provides.

Reported-by: <syzbot+4fbcfcc0d2e6592bd641@syzkaller.appspotmail.com>
Fixes: c38c4597e4bf ("netfilter: implement xt_cgroup cgroup2 path match")
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_cgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/xt_cgroup.c b/net/netfilter/xt_cgroup.c
index 1db1ce59079f..891f4e7e8ea7 100644
--- a/net/netfilter/xt_cgroup.c
+++ b/net/netfilter/xt_cgroup.c
@@ -52,6 +52,7 @@ static int cgroup_mt_check_v1(const struct xt_mtchk_param *par)
 		return -EINVAL;
 	}
 
+	info->priv = NULL;
 	if (info->has_path) {
 		cgrp = cgroup_get_from_path(info->path);
 		if (IS_ERR(cgrp)) {
-- 
2.11.0

