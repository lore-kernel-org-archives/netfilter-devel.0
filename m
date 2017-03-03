From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/4] netfilter: nf_conntrack_sip: fix wrong memory initialisation
Date: Fri,  3 Mar 2017 20:22:23 +0100
Message-ID: <1488568945-4177-3-git-send-email-pablo@netfilter.org>
References: <1488568945-4177-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1488568945-4177-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

In commit 82de0be6862cd ("netfilter: Add helper array
register/unregister functions"),
struct nf_conntrack_helper sip[MAX_PORTS][4] was changed to
sip[MAX_PORTS * 4], so the memory init should have been changed to
memset(&sip[4 * i], 0, 4 * sizeof(sip[i]));

But as the sip[] table is allocated in the BSS, it is already set to 0

Fixes: 82de0be6862cd ("netfilter: Add helper array register/unregister functions")
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_sip.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 24174c520239..0d17894798b5 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1628,8 +1628,6 @@ static int __init nf_conntrack_sip_init(void)
 		ports[ports_c++] = SIP_PORT;
 
 	for (i = 0; i < ports_c; i++) {
-		memset(&sip[i], 0, sizeof(sip[i]));
-
 		nf_ct_helper_init(&sip[4 * i], AF_INET, IPPROTO_UDP, "sip",
 				  SIP_PORT, ports[i], i, sip_exp_policy,
 				  SIP_EXPECT_MAX,
-- 
2.1.4
