From: Shaochun Chen <cscnull@gmail.com>
Subject: [PATCH] netlink: fix memory leak
Date: Sun, 22 Jul 2018 10:49:25 +0800
Message-ID: <20180722024925.3176-1-cscnull@gmail.com>
Cc: kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        johannes.berg@intel.com, pombredanne@nexb.com,
        kstewart@linuxfoundation.org, cscnull@gmail.com,
        gregkh@linuxfoundation.org, Jason@zx2c4.com, dsahern@gmail.com,
        lucien.xin@gmail.com, ktkhai@virtuozzo.com,
        xiyou.wangcong@gmail.com, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

when netlink_dump start failed, netlink_callback will not be called,
and the memory which pointed by control->data will leak. so if netlink_dump
start fail, call control->done to free the memory.

Signed-off-by: Shaochun Chen <cscnull@gmail.com>
---
 include/linux/netlink.h       | 10 ++++++++++
 net/netfilter/nf_tables_api.c |  4 +++-
 net/netlink/af_netlink.c      |  4 ++++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index f3075d6c7e82..9d6b3edc5a5b 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -214,6 +214,16 @@ static inline int netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
 	return __netlink_dump_start(ssk, skb, nlh, control);
 }
 
+static inline void netlink_dump_start_fail(struct netlink_dump_control *control)
+{
+	struct netlink_callback cb = {
+		.data = control->data,
+	};
+
+	if (control->done)
+		control->done(&cb);
+}
+
 struct netlink_tap {
 	struct net_device *dev;
 	struct module *module;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 896d4a36081d..dc30a329f785 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -588,8 +588,10 @@ static int nft_netlink_dump_start_rcu(struct sock *nlsk, struct sk_buff *skb,
 {
 	int err;
 
-	if (!try_module_get(THIS_MODULE))
+	if (!try_module_get(THIS_MODULE)) {
+		netlink_dump_start_fail(c);
 		return -EINVAL;
+	}
 
 	rcu_read_unlock();
 	err = netlink_dump_start(nlsk, skb, nlh, c);
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 393573a99a5a..7b85176cf9bb 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2275,6 +2275,7 @@ int __netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
 	struct netlink_callback *cb;
 	struct sock *sk;
 	struct netlink_sock *nlk;
+	bool cb_running = false;
 	int ret;
 
 	refcount_inc(&skb->users);
@@ -2317,6 +2318,7 @@ int __netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
 
 	nlk->cb_running = true;
 	nlk->dump_done_errno = INT_MAX;
+	cb_running = true;
 
 	mutex_unlock(nlk->cb_mutex);
 
@@ -2339,6 +2341,8 @@ int __netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
 	mutex_unlock(nlk->cb_mutex);
 error_free:
 	kfree_skb(skb);
+	if (cb_running)
+		netlink_dump_start_fail(control);
 	return ret;
 }
 EXPORT_SYMBOL(__netlink_dump_start);
-- 
2.17.1
