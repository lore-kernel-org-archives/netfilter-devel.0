From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: [Patch nf-next] nf_conntrack: fix error path in nf_conntrack_pernet_init()
Date: Wed, 23 Jan 2019 12:58:57 -0800
Message-ID: <20190123205857.8107-1-xiyou.wangcong@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+fcee88b2d87f0539dfe9@syzkaller.appspotmail.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

When nf_ct_netns_get() fails, it should clean up itself,
its caller doesn't need to call nf_conntrack_fini_net().

nf_conntrack_init_net() is called after registering sysctl
and proc, so its cleanup function should be called before
unregistering sysctl and proc.

Fixes: ba3fbe663635 ("netfilter: nf_conntrack: provide modparam to always register conntrack hooks")
Fixes: b884fa461776 ("netfilter: conntrack: unify sysctl handling")
Reported-and-tested-by: syzbot+fcee88b2d87f0539dfe9@syzkaller.appspotmail.com
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
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
2.20.1
