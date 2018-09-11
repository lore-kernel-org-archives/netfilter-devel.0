From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 10/12] netfilter: cttimeout: ctnl_timeout_find_get() returns incorrect pointer to type
Date: Tue, 11 Sep 2018 02:20:42 +0200
Message-ID: <20180911002044.9100-11-pablo@netfilter.org>
References: <20180911002044.9100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180911002044.9100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Compiler did not catch incorrect typing in the rcu hook assignment.

 % nfct add timeout test-tcp inet tcp established 100 close 10 close_wait 10
 % iptables -I OUTPUT -t raw -p tcp -j CT --timeout test-tcp
 dmesg - xt_CT: Timeout policy `test-tcp' can only be used by L3 protocol number 25000

The CT target bails out with incorrect layer 3 protocol number.

Fixes: 6c1fd7dc489d ("netfilter: cttimeout: decouple timeout policy from nfnetlink_cttimeout object")
Reported-by: Harsha Sharma <harshasharmaiitr@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_cttimeout.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index d46a236cdf31..a30f8ba4b89a 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -489,8 +489,8 @@ static int cttimeout_default_get(struct net *net, struct sock *ctnl,
 	return err;
 }
 
-static struct ctnl_timeout *
-ctnl_timeout_find_get(struct net *net, const char *name)
+static struct nf_ct_timeout *ctnl_timeout_find_get(struct net *net,
+						   const char *name)
 {
 	struct ctnl_timeout *timeout, *matching = NULL;
 
@@ -509,7 +509,7 @@ ctnl_timeout_find_get(struct net *net, const char *name)
 		break;
 	}
 err:
-	return matching;
+	return matching ? &matching->timeout : NULL;
 }
 
 static void ctnl_timeout_put(struct nf_ct_timeout *t)
-- 
2.11.0
