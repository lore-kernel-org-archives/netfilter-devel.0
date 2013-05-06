From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [-stable-3.8.y 5/9] netfilter: ipset: "Directory not empty" error message
Date: Tue,  7 May 2013 01:05:24 +0200
Message-ID: <1367881528-15524-5-git-send-email-pablo@netfilter.org>
References: <1367881528-15524-1-git-send-email-pablo@netfilter.org>
Cc: stable@vger.kernel.org, davem@davemloft.net
To: netfilter-devel@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1367881528-15524-1-git-send-email-pablo@netfilter.org>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

When an entry flagged with "nomatch" was tested by ipset, it
returned the error message "Kernel error received:
Directory not empty" instead of "<element> is NOT in set <setname>"
(reported by John Brendler).

The internal error code was not properly transformed before returning
to userspace, fixed.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

[ git cherry-pick dd82088 ]
---
 net/netfilter/ipset/ip_set_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 6d6d8f2..38ca630 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1470,7 +1470,8 @@ ip_set_utest(struct sock *ctnl, struct sk_buff *skb,
 	if (ret == -EAGAIN)
 		ret = 1;
 
-	return ret < 0 ? ret : ret > 0 ? 0 : -IPSET_ERR_EXIST;
+	return (ret < 0 && ret != -ENOTEMPTY) ? ret :
+		ret > 0 ? 0 : -IPSET_ERR_EXIST;
 }
 
 /* Get headed data of a set */
-- 
1.7.10.4
