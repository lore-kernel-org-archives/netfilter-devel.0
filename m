From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 20/22]: tcp_conntrack: factorize out the PUSH flag
Date: Wed, 14 Mar 2007 09:50:46 +0100 (MET)
Message-ID: <20070314085031.15282.76027.sendpatchset@localhost.localdomain>
References: <20070314084946.15282.58609.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070314084946.15282.58609.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: TCP conntrack: factorize out the PUSH flag

The PUSH flag is accepted with every other valid combination.
Let's get it out of the tcp_valid_flags table and reduce the
number of combinations we have to handle. This does not
significantly reduce the table size however (8 bytes).

Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3607514396585a2be00d6d0aa3081a96532e5db7
tree 7aeb2263123d7bba9d8265c2dc55c1e5d3b3ad50
parent 922ad96654a159769dc890c4ef1896e10985f5bb
author Willy Tarreau <w@1wt.eu> Wed, 14 Mar 2007 09:34:29 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 14 Mar 2007 09:34:29 +0100

 net/netfilter/nf_conntrack_proto_tcp.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 926e302..a136362 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -764,27 +764,18 @@ #define	TH_URG	0x20
 #define	TH_ECE	0x40
 #define	TH_CWR	0x80
 
-/* table of valid flag combinations - ECE and CWR are always valid */
-static u8 tcp_valid_flags[(TH_FIN|TH_SYN|TH_RST|TH_PUSH|TH_ACK|TH_URG) + 1] =
+/* table of valid flag combinations - PUSH, ECE and CWR are always valid */
+static u8 tcp_valid_flags[(TH_FIN|TH_SYN|TH_RST|TH_ACK|TH_URG) + 1] =
 {
 	[TH_SYN]			= 1,
-	[TH_SYN|TH_PUSH]		= 1,
 	[TH_SYN|TH_URG]			= 1,
-	[TH_SYN|TH_PUSH|TH_URG]		= 1,
 	[TH_SYN|TH_ACK]			= 1,
-	[TH_SYN|TH_ACK|TH_PUSH]		= 1,
 	[TH_RST]			= 1,
-	[TH_RST|TH_PUSH]		= 1,
 	[TH_RST|TH_ACK]			= 1,
-	[TH_RST|TH_ACK|TH_PUSH]		= 1,
 	[TH_FIN|TH_ACK]			= 1,
+	[TH_FIN|TH_ACK|TH_URG]		= 1,
 	[TH_ACK]			= 1,
-	[TH_ACK|TH_PUSH]		= 1,
 	[TH_ACK|TH_URG]			= 1,
-	[TH_ACK|TH_URG|TH_PUSH]		= 1,
-	[TH_FIN|TH_ACK|TH_PUSH]		= 1,
-	[TH_FIN|TH_ACK|TH_URG]		= 1,
-	[TH_FIN|TH_ACK|TH_URG|TH_PUSH]	= 1,
 };
 
 /* Protect conntrack agaist broken packets. Code taken from ipt_unclean.c.  */
@@ -831,7 +822,7 @@ static int tcp_error(struct sk_buff *skb
 	}
 
 	/* Check TCP flags. */
-	tcpflags = (((u_int8_t *)th)[13] & ~(TH_ECE|TH_CWR));
+	tcpflags = (((u_int8_t *)th)[13] & ~(TH_ECE|TH_CWR|TH_PUSH));
 	if (!tcp_valid_flags[tcpflags]) {
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
