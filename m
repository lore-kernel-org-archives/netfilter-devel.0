From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: [PATCH net-next] netfilter: core: make local function __nf_unregister_net_hook static
Date: Wed, 10 Jan 2018 07:05:06 +0000
Message-ID: <1515567906-188180-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Wei Yongjun <weiyongjun1@huawei.com>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netdev@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Fixes the following sparse warning:

net/netfilter/core.c:380:6: warning:
 symbol '__nf_unregister_net_hook' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 net/netfilter/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 997dd38..3f8e2d0 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -377,8 +377,8 @@ static void nf_remove_net_hook(struct nf_hook_entries *old,
 	}
 }
 
-void __nf_unregister_net_hook(struct net *net, int pf,
-			      const struct nf_hook_ops *reg)
+static void __nf_unregister_net_hook(struct net *net, int pf,
+				     const struct nf_hook_ops *reg)
 {
 	struct nf_hook_entries __rcu **pp;
 	struct nf_hook_entries *p;
