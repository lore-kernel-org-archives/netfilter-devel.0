From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 10/37] netfilter: ipset: fix ip_set_byindex function
Date: Fri, 21 Dec 2018 01:28:14 +0100
Message-ID: <20181221002841.28587-11-pablo@netfilter.org>
References: <20181221002841.28587-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181221002841.28587-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florent Fourcot <florent.fourcot@wifirst.fr>

New function added by "Introduction of new commands and protocol
version 7" is not working, since we return skb2 to user

Signed-off-by: Victorien Molle <victorien.molle@wifirst.fr>
Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 1c3614aca34e..e3113aa1a975 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1949,7 +1949,7 @@ static int ip_set_byindex(struct net *net, struct sock *ctnl,
 	if (!nlh2)
 		goto nlmsg_failure;
 	if (nla_put_u8(skb2, IPSET_ATTR_PROTOCOL, protocol(attr)) ||
-	    nla_put_string(skb, IPSET_ATTR_SETNAME, set->name))
+	    nla_put_string(skb2, IPSET_ATTR_SETNAME, set->name))
 		goto nla_put_failure;
 	nlmsg_end(skb2, nlh2);
 
-- 
2.11.0
