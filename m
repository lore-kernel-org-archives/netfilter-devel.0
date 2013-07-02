From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -stable-3.9 06/15] ipvs: info leak in __ip_vs_get_dest_entries()
Date: Tue,  2 Jul 2013 16:50:56 +0200
Message-ID: <1372776665-6795-6-git-send-email-pablo@netfilter.org>
References: <1372776665-6795-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, stable@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1372776665-6795-1-git-send-email-pablo@netfilter.org>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

The entry struct has a 2 byte hole after ->port and another 4 byte
hole after ->stats.outpkts.  You must have CAP_NET_ADMIN in your
namespace to hit this information leak.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Cherry-pick: a8241c63517ec0b900695daa9003cddc41c536a1

 net/netfilter/ipvs/ip_vs_ctl.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 9e2d1cc..b940919 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2562,6 +2562,7 @@ __ip_vs_get_dest_entries(struct net *net, const struct ip_vs_get_dests *get,
 		struct ip_vs_dest *dest;
 		struct ip_vs_dest_entry entry;
 
+		memset(&entry, 0, sizeof(entry));
 		list_for_each_entry(dest, &svc->destinations, n_list) {
 			if (count >= get->num_dests)
 				break;
-- 
1.7.10.4
