From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/4] netfilter: nf_nat: handle NF_DROP from nfnetlink_parse_nat_setup()
Date: Tue, 13 Sep 2016 11:05:16 +0200
Message-ID: <1473757517-3764-4-git-send-email-pablo@netfilter.org>
References: <1473757517-3764-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1473757517-3764-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

nf_nat_setup_info() returns NF_* verdicts, so convert them to error
codes that is what ctnelink expects. This has passed overlook without
having any impact since this nf_nat_setup_info() has always returned
NF_ACCEPT so far. Since 870190a9ec90 ("netfilter: nat: convert nat bysrc
hash to rhashtable"), this is problem.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index de31818..19c081e 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -807,7 +807,7 @@ nfnetlink_parse_nat_setup(struct nf_conn *ct,
 	if (err < 0)
 		return err;
 
-	return nf_nat_setup_info(ct, &range, manip);
+	return nf_nat_setup_info(ct, &range, manip) == NF_DROP ? -ENOMEM : 0;
 }
 #else
 static int
-- 
2.1.4
