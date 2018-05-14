From: Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH 03/14] net: sched: add 'delete' function to action ops
Date: Mon, 14 May 2018 17:27:04 +0300
Message-ID: <1526308035-12484-4-git-send-email-vladbu@mellanox.com>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com>
Cc: davem@davemloft.net, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, pablo@netfilter.org, kadlec@blackhole.kfki.hu,
        fw@strlen.de, ast@kernel.org, daniel@iogearbox.net,
        edumazet@google.com, vladbu@mellanox.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, kliteyn@mellanox.com
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1526308035-12484-1-git-send-email-vladbu@mellanox.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Extend action ops with 'delete' function. Each action type to implement its
own delete function that doesn't depend on rtnl lock.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---
 include/net/act_api.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index e634014..73175a3 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -100,6 +100,7 @@ struct tc_action_ops {
 	void	(*stats_update)(struct tc_action *, u64, u32, u64);
 	size_t  (*get_fill_size)(const struct tc_action *act);
 	struct net_device *(*get_dev)(const struct tc_action *a);
+	int     (*delete)(struct net *net, u32 index);
 };
 
 struct tc_action_net {
-- 
2.7.5
