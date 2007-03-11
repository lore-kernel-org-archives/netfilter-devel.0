From: Willy Tarreau <w@1wt.eu>
Subject: [NETFILTER]: tcp_conntrack: factorize out the PUSH flag
Date: Sun, 11 Mar 2007 11:19:23 +0100
Message-ID: <11736083633652-git-send-email-w@1wt.eu>
References: <11736083633448-git-send-email-w@1wt.eu>
Cc: davem@davemloft.net
To: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <11736083633448-git-send-email-w@1wt.eu>
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

The PUSH flag is accepted with every other valid combination.
Let's get it out of the tcp_valid_flags table and reduce the
number of combinations we have to handle. This does not
significantly reduce the table size however (8 bytes).

Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/netfilter/ip_conntrack_proto_tcp.c |   17 ++++-------------
 net/netfilter/nf_conntrack_proto_tcp.c      |   17 ++++-------------
 2 files changed, 8 insertions(+), 26 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
index 918205f..4a09b3c 100644
--- a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
@@ -808,27 +808,18 @@ void ip_conntrack_tcp_update(struct sk_buff *skb,
 #define	TH_ECE	0x40
 #define	TH_CWR	0x80
 
-/* table of valid flag combinations - ECE and CWR are always valid */
-static const u8 tcp_valid_flags[(TH_FIN|TH_SYN|TH_RST|TH_PUSH|TH_ACK|TH_URG) + 1] =
+/* table of valid flag combinations - PUSH, ECE and CWR are always valid */
+static const u8 tcp_valid_flags[(TH_FIN|TH_SYN|TH_RST|TH_ACK|TH_URG) + 1] =
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
@@ -873,7 +864,7 @@ static int tcp_error(struct sk_buff *skb,
 	}
 
 	/* Check TCP flags. */
-	tcpflags = (((u_int8_t *)th)[13] & ~(TH_ECE|TH_CWR));
+	tcpflags = (((u_int8_t *)th)[13] & ~(TH_ECE|TH_CWR|TH_PUSH));
 	if (!tcp_valid_flags[tcpflags]) {
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(PF_INET, 0, skb, NULL, NULL, NULL,
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index b51afd3..cac0a82 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -765,27 +765,18 @@ EXPORT_SYMBOL_GPL(nf_conntrack_tcp_update);
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
@@ -832,7 +823,7 @@ static int tcp_error(struct sk_buff *skb,
 	}
 
 	/* Check TCP flags. */
-	tcpflags = (((u_int8_t *)th)[13] & ~(TH_ECE|TH_CWR));
+	tcpflags = (((u_int8_t *)th)[13] & ~(TH_ECE|TH_CWR|TH_PUSH));
 	if (!tcp_valid_flags[tcpflags]) {
 		if (LOG_INVALID(IPPROTO_TCP))
 			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
-- 
1.5.0.3
