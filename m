From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/13]: tcp conntrack: accept SYN|URG as valid
Date: Wed,  7 Mar 2007 22:34:30 +0100 (MET)
Message-ID: <20070307213351.22306.59582.sendpatchset@localhost.localdomain>
References: <20070307213347.22306.9248.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	davem@davemloft.net
To: stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070307213347.22306.9248.sendpatchset@localhost.localdomain>
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
commit 026cf98c00d9fd7a1cf241a29d466f04c84c4df1
tree 1d48b67975a4ed0eea6517de00aaa5be9deb52e1
parent bcaac807aeec7ae9aff8a62261b1138979d6dd5b
author Patrick McHardy <kaber@trash.net> Tue, 06 Mar 2007 08:22:40 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 06 Mar 2007 08:22:40 +0100

 net/ipv4/netfilter/ip_conntrack_proto_tcp.c |    4 +++-
 net/netfilter/nf_conntrack_proto_tcp.c      |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
index 06e4e8a..4cd76ed 100644
--- a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
@@ -821,8 +821,10 @@ #define	TH_CWR	0x80
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
index 626b001..693d189 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -778,8 +778,10 @@ #define	TH_CWR	0x80
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
