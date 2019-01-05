From: Aditya Pakki <pakki001@umn.edu>
Subject: [PATCH] [v2] netfilter: ipset: fix a missing check of nla_parse
Date: Sat,  5 Jan 2019 09:31:49 -0600
Message-ID: <20190105153150.2600-1-pakki001@umn.edu>
Cc: kjlu@umn.edu, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: pakki001@umn.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

When nla_parse fails, we should not use the results (the first
argument). The fix checks if it fails, and if so, returns its error code
upstream.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 net/netfilter/ipset/ip_set_core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 45a257695bef..3ee0fda05a3b 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1546,8 +1546,13 @@ call_ad(struct sock *ctnl, struct sk_buff *skb, struct ip_set *set,
 		memcpy(&errmsg->msg, nlh, nlh->nlmsg_len);
 		cmdattr = (void *)&errmsg->msg + min_len;
 
-		nla_parse(cda, IPSET_ATTR_CMD_MAX, cmdattr,
-			  nlh->nlmsg_len - min_len, ip_set_adt_policy, NULL);
+		ret = nla_parse(cda, IPSET_ATTR_CMD_MAX, cmdattr,
+				nlh->nlmsg_len - min_len, ip_set_adt_policy,
+				NULL);
+		if (ret) {
+			nlmsg_free(skb2);
+			return ret;
+		}
 
 		errline = nla_data(cda[IPSET_ATTR_LINENO]);
 
-- 
2.17.1
