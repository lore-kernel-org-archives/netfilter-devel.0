From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: [Patch nf] ipvs: initialize tbl->entries in ip_vs_lblc_init_svc()
Date: Mon, 23 Apr 2018 14:04:45 -0700
Message-ID: <20180423210445.18336-1-xiyou.wangcong@gmail.com>
Cc: lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Similarly, tbl->entries is not initialized after kmalloc(),
therefore causes an uninit-value warning in ip_vs_lblc_check_expire(),
as reported by syzbot.

Reported-by: <syzbot+3e9695f147fb529aa9bc@syzkaller.appspotmail.com>
Cc: Simon Horman <horms@verge.net.au>
Cc: Julian Anastasov <ja@ssi.bg>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/netfilter/ipvs/ip_vs_lblc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/ipvs/ip_vs_lblc.c b/net/netfilter/ipvs/ip_vs_lblc.c
index 3057e453bf31..83918119ceb8 100644
--- a/net/netfilter/ipvs/ip_vs_lblc.c
+++ b/net/netfilter/ipvs/ip_vs_lblc.c
@@ -371,6 +371,7 @@ static int ip_vs_lblc_init_svc(struct ip_vs_service *svc)
 	tbl->counter = 1;
 	tbl->dead = false;
 	tbl->svc = svc;
+	atomic_set(&tbl->entries, 0);
 
 	/*
 	 *    Hook periodic timer for garbage collection
-- 
2.13.0
