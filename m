From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 8/9] netfilter: conntrack: dccp: treat SYNC/SYNCACK as invalid if no prior state
Date: Tue, 24 Jul 2018 18:31:32 +0200
Message-ID: <20180724163133.14586-9-pablo@netfilter.org>
References: <20180724163133.14586-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180724163133.14586-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

When first DCCP packet is SYNC or SYNCACK, we insert a new conntrack
that has an un-initialized timeout value, i.e. such entry could be
reaped at any time.

Mark them as INVALID and only ignore SYNC/SYNCACK when connection had
an old state.

Reported-by: syzbot+6f18401420df260e37ed@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_dccp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index abe647d5b8c6..9ce6336d1e55 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -243,14 +243,14 @@ dccp_state_table[CT_DCCP_ROLE_MAX + 1][DCCP_PKT_SYNCACK + 1][CT_DCCP_MAX + 1] =
 		 * We currently ignore Sync packets
 		 *
 		 *	sNO, sRQ, sRS, sPO, sOP, sCR, sCG, sTW */
-			sIG, sIG, sIG, sIG, sIG, sIG, sIG, sIG,
+			sIV, sIG, sIG, sIG, sIG, sIG, sIG, sIG,
 		},
 		[DCCP_PKT_SYNCACK] = {
 		/*
 		 * We currently ignore SyncAck packets
 		 *
 		 *	sNO, sRQ, sRS, sPO, sOP, sCR, sCG, sTW */
-			sIG, sIG, sIG, sIG, sIG, sIG, sIG, sIG,
+			sIV, sIG, sIG, sIG, sIG, sIG, sIG, sIG,
 		},
 	},
 	[CT_DCCP_ROLE_SERVER] = {
@@ -371,14 +371,14 @@ dccp_state_table[CT_DCCP_ROLE_MAX + 1][DCCP_PKT_SYNCACK + 1][CT_DCCP_MAX + 1] =
 		 * We currently ignore Sync packets
 		 *
 		 *	sNO, sRQ, sRS, sPO, sOP, sCR, sCG, sTW */
-			sIG, sIG, sIG, sIG, sIG, sIG, sIG, sIG,
+			sIV, sIG, sIG, sIG, sIG, sIG, sIG, sIG,
 		},
 		[DCCP_PKT_SYNCACK] = {
 		/*
 		 * We currently ignore SyncAck packets
 		 *
 		 *	sNO, sRQ, sRS, sPO, sOP, sCR, sCG, sTW */
-			sIG, sIG, sIG, sIG, sIG, sIG, sIG, sIG,
+			sIV, sIG, sIG, sIG, sIG, sIG, sIG, sIG,
 		},
 	},
 };
-- 
2.11.0
