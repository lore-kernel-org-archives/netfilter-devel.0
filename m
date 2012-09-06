From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] ipvs: use list_del_init instead of list_del/INIT_LIST_HEAD
Date: Thu, 6 Sep 2012 12:21:53 +0800
Message-ID: <CAPgLHd_JMzWm-Eh48bXcq6xW2viVEQgmkxLU8KgVyD2gUk6sZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: yongjun_wei@trendmicro.com.cn, lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: wensong@linux-vs.org, horms@verge.net.au, ja@ssi.bg,
	pablo@netfilter.org, kaber@trash.net
Return-path: <lvs-devel-owner@vger.kernel.org>
Sender: lvs-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using list_del_init() instead of list_del() + INIT_LIST_HEAD().

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index f51013c..9d9f83e 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -539,8 +539,7 @@ static int ip_vs_rs_unhash(struct ip_vs_dest *dest)
 	 * Remove it from the rs_table table.
 	 */
 	if (!list_empty(&dest->d_list)) {
-		list_del(&dest->d_list);
-		INIT_LIST_HEAD(&dest->d_list);
+		list_del_init(&dest->d_list);
 	}
 
 	return 1;


