From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 42/51] ipvs: initialize tbl->entries after allocation
Date: Mon,  7 May 2018 00:47:00 +0200
Message-ID: <20180506224709.29100-43-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

tbl->entries is not initialized after kmalloc(), therefore
causes an uninit-value warning in ip_vs_lblc_check_expire()
as reported by syzbot.

Reported-by: <syzbot+3dfdea57819073a04f21@syzkaller.appspotmail.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Julian Anastasov <ja@ssi.bg>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_lblcr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/ipvs/ip_vs_lblcr.c b/net/netfilter/ipvs/ip_vs_lblcr.c
index 9b6a6c9e9cfa..542c4949937a 100644
--- a/net/netfilter/ipvs/ip_vs_lblcr.c
+++ b/net/netfilter/ipvs/ip_vs_lblcr.c
@@ -535,6 +535,7 @@ static int ip_vs_lblcr_init_svc(struct ip_vs_service *svc)
 	tbl->counter = 1;
 	tbl->dead = false;
 	tbl->svc = svc;
+	atomic_set(&tbl->entries, 0);
 
 	/*
 	 *    Hook periodic timer for garbage collection
-- 
2.11.0
