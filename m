From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 14/15] netfilter: x_tables: initialise match/target check parameter struct
Date: Mon, 11 Jun 2018 11:22:32 +0200
Message-ID: <20180611092233.3219-15-pablo@netfilter.org>
References: <20180611092233.3219-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180611092233.3219-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

syzbot reports following splat:

BUG: KMSAN: uninit-value in ebt_stp_mt_check+0x24b/0x450
 net/bridge/netfilter/ebt_stp.c:162
 ebt_stp_mt_check+0x24b/0x450 net/bridge/netfilter/ebt_stp.c:162
 xt_check_match+0x1438/0x1650 net/netfilter/x_tables.c:506
 ebt_check_match net/bridge/netfilter/ebtables.c:372 [inline]
 ebt_check_entry net/bridge/netfilter/ebtables.c:702 [inline]

The uninitialised access is
   xt_mtchk_param->nft_compat

... which should be set to 0.
Fix it by zeroing the struct beforehand, same for tgchk.

ip(6)tables targetinfo uses c99-style initialiser, so no change
needed there.

Reported-by: syzbot+da4494182233c23a5fcf@syzkaller.appspotmail.com
Fixes: 55917a21d0cc0 ("netfilter: x_tables: add context to know if extension runs from nft_compat")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/ebtables.c | 2 ++
 net/ipv4/netfilter/ip_tables.c  | 1 +
 net/ipv6/netfilter/ip6_tables.c | 1 +
 3 files changed, 4 insertions(+)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 08a65e4a77d0..ead123dab05e 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -700,6 +700,8 @@ ebt_check_entry(struct ebt_entry *e, struct net *net,
 	}
 	i = 0;
 
+	memset(&mtpar, 0, sizeof(mtpar));
+	memset(&tgpar, 0, sizeof(tgpar));
 	mtpar.net	= tgpar.net       = net;
 	mtpar.table     = tgpar.table     = name;
 	mtpar.entryinfo = tgpar.entryinfo = e;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index e85f35b89c49..f6130704f052 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -531,6 +531,7 @@ find_check_entry(struct ipt_entry *e, struct net *net, const char *name,
 		return -ENOMEM;
 
 	j = 0;
+	memset(&mtpar, 0, sizeof(mtpar));
 	mtpar.net	= net;
 	mtpar.table     = name;
 	mtpar.entryinfo = &e->ip;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 97f79dc943d7..685c2168f524 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -551,6 +551,7 @@ find_check_entry(struct ip6t_entry *e, struct net *net, const char *name,
 		return -ENOMEM;
 
 	j = 0;
+	memset(&mtpar, 0, sizeof(mtpar));
 	mtpar.net	= net;
 	mtpar.table     = name;
 	mtpar.entryinfo = &e->ipv6;
-- 
2.11.0
