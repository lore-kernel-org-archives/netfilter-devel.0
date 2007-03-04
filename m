From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/10]: tcp conntrack: accept SYN|URG as valid
Date: Sun,  4 Mar 2007 21:20:02 +0100 (MET)
Message-ID: <20070304201910.28582.42805.sendpatchset@localhost.localdomain>
References: <20070304201906.28582.51903.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070304201906.28582.51903.sendpatchset@localhost.localdomain>
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

[NETFILTER]: tcp conntrack: accept SYN|URG as valid

Some stacks apparently send packets with SYN|URG set. Linux accepts
these packets, so TCP conntrack should to.

Pointed out by Martijn Posthuma <posthuma@sangine.com>.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit efe99d89bb32f8ea7f76fdf9867d0df52e8ca0aa
tree 2fdf2aa01da7595f763432b3b03822a020239592
parent e6ebc414bb13540bba508e404af7aa6b3e65e6f3
author Patrick McHardy <kaber@trash.net> Thu, 01 Mar 2007 15:21:44 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 01 Mar 2007 15:21:44 +0100

 net/ipv4/netfilter/ip_conntrack_proto_tcp.c |    4 +++-
 net/netfilter/nf_conntrack_proto_tcp.c      |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
index 170d625..0a72eab 100644
--- a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
@@ -812,8 +812,10 @@ #define	TH_CWR	0x80
 static const u8 tcp_valid_flags[(TH_FIN|TH_SYN|TH_RST|TH_PUSH|TH_ACK|TH_URG) + 1] =
 {
 	[TH_SYN]			= 1,
-	[TH_SYN|TH_ACK]			= 1,
 	[TH_SYN|TH_PUSH]		= 1,
+	[TH_SYN|TH_URG]			= 1,
+	[TH_SYN|TH_PUSH|TH_URG]		= 1,
+	[TH_SYN|TH_ACK]			= 1,
 	[TH_SYN|TH_ACK|TH_PUSH]		= 1,
 	[TH_RST]			= 1,
 	[TH_RST|TH_ACK]			= 1,
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 3b9ad7f..153d661 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -769,8 +769,10 @@ #define	TH_CWR	0x80
 static u8 tcp_valid_flags[(TH_FIN|TH_SYN|TH_RST|TH_PUSH|TH_ACK|TH_URG) + 1] =
 {
 	[TH_SYN]			= 1,
-	[TH_SYN|TH_ACK]			= 1,
 	[TH_SYN|TH_PUSH]		= 1,
+	[TH_SYN|TH_URG]			= 1,
+	[TH_SYN|TH_PUSH|TH_URG]		= 1,
+	[TH_SYN|TH_ACK]			= 1,
 	[TH_SYN|TH_ACK|TH_PUSH]		= 1,
 	[TH_RST]			= 1,
 	[TH_RST|TH_ACK]			= 1,
