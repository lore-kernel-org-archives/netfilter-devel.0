From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: [Patch net] xt_cgroup: initialize info->priv in cgroup_mt_check_v1()
Date: Wed, 31 Jan 2018 15:02:47 -0800
Message-ID: <20180131230247.1417-1-xiyou.wangcong@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

xt_cgroup_info_v1->priv is an internal pointer only used for kernel,
we should not trust what user-space provides.

Reported-by: <syzbot+4fbcfcc0d2e6592bd641@syzkaller.appspotmail.com>
Fixes: c38c4597e4bf ("netfilter: implement xt_cgroup cgroup2 path match")
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
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
2.13.0
