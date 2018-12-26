From: Kangjie Lu <kjlu@umn.edu>
Subject: [PATCH] ipset: fix a missing check of nla_parse
Date: Tue, 25 Dec 2018 21:50:01 -0600
Message-ID: <20181226035002.73614-1-kjlu@umn.edu>
Cc: pakki001@umn.edu, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: kjlu@umn.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

When nla_parse fails, we should not use the results (the first
argument). The fix checks if it fails, and if so, returns its error code
upstream.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 net/netfilter/ipset/ip_set_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 1577f2f76060..4dc8057cff02 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1531,8 +1531,10 @@ call_ad(struct sock *ctnl, struct sk_buff *skb, struct ip_set *set,
 		memcpy(&errmsg->msg, nlh, nlh->nlmsg_len);
 		cmdattr = (void *)&errmsg->msg + min_len;
 
-		nla_parse(cda, IPSET_ATTR_CMD_MAX, cmdattr,
+		ret = nla_parse(cda, IPSET_ATTR_CMD_MAX, cmdattr,
 			  nlh->nlmsg_len - min_len, ip_set_adt_policy, NULL);
+		if (ret)
+			return ret;
 
 		errline = nla_data(cda[IPSET_ATTR_LINENO]);
 
-- 
2.17.2 (Apple Git-113)
