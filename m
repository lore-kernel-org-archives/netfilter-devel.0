From: Willy Tarreau <w@1wt.eu>
Subject: [NETFILTER]: tcp_conntrack: accept RST|PSH as valid
Date: Sun, 11 Mar 2007 11:19:22 +0100
Message-ID: <11736083633448-git-send-email-w@1wt.eu>
Cc: davem@davemloft.net
To: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

This combination has been encountered on an IBM AS/400 in response
to packets sent to a closed session. There is no particular reason
to mark it invalid.

Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/ipv4/netfilter/ip_conntrack_proto_tcp.c |    1 +
 net/netfilter/nf_conntrack_proto_tcp.c      |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
index 0a72eab..918205f 100644
--- a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
@@ -818,6 +818,7 @@ static const u8 tcp_valid_flags[(TH_FIN|TH_SYN|TH_RST|TH_PUSH|TH_ACK|TH_URG) + 1
 	[TH_SYN|TH_ACK]			= 1,
 	[TH_SYN|TH_ACK|TH_PUSH]		= 1,
 	[TH_RST]			= 1,
+	[TH_RST|TH_PUSH]		= 1,
 	[TH_RST|TH_ACK]			= 1,
 	[TH_RST|TH_ACK|TH_PUSH]		= 1,
 	[TH_FIN|TH_ACK]			= 1,
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 153d661..b51afd3 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -775,6 +775,7 @@ static u8 tcp_valid_flags[(TH_FIN|TH_SYN|TH_RST|TH_PUSH|TH_ACK|TH_URG) + 1] =
 	[TH_SYN|TH_ACK]			= 1,
 	[TH_SYN|TH_ACK|TH_PUSH]		= 1,
 	[TH_RST]			= 1,
+	[TH_RST|TH_PUSH]		= 1,
 	[TH_RST|TH_ACK]			= 1,
 	[TH_RST|TH_ACK|TH_PUSH]		= 1,
 	[TH_FIN|TH_ACK]			= 1,
-- 
1.5.0.3
