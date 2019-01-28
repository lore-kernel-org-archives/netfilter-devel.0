From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 32/33] netfilter: conntrack: fix error path in nf_conntrack_pernet_init()
Date: Tue, 29 Jan 2019 00:57:49 +0100
Message-ID: <20190128235750.18412-33-pablo@netfilter.org>
References: <20190128235750.18412-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128235750.18412-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

When nf_ct_netns_get() fails, it should clean up itself,
its caller doesn't need to call nf_conntrack_fini_net().

nf_conntrack_init_net() is called after registering sysctl
and proc, so its cleanup function should be called before
unregistering sysctl and proc.

Fixes: ba3fbe663635 ("netfilter: nf_conntrack: provide modparam to always register conntrack hooks")
Fixes: b884fa461776 ("netfilter: conntrack: unify sysctl handling")
Reported-and-tested-by: syzbot+fcee88b2d87f0539dfe9@syzkaller.appspotmail.com
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_standalone.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 8928a4d0933e..c2ae14c720b4 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -1115,11 +1115,11 @@ static int nf_conntrack_pernet_init(struct net *net)
 	return 0;
 
 out_hooks:
-	nf_conntrack_fini_net(net);
+	nf_conntrack_cleanup_net(net);
 out_init_net:
 	nf_conntrack_standalone_fini_proc(net);
 out_proc:
-	nf_conntrack_cleanup_net(net);
+	nf_conntrack_standalone_fini_sysctl(net);
 	return ret;
 }
 
-- 
2.11.0
