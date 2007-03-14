From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 19/22]: tcp_conntrack: accept RST|PSH as valid
Date: Wed, 14 Mar 2007 09:50:45 +0100 (MET)
Message-ID: <20070314085030.15282.75158.sendpatchset@localhost.localdomain>
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

[NETFILTER]: TCP conntrack: accept RST|PSH as valid

This combination has been encountered on an IBM AS/400 in response
to packets sent to a closed session. There is no particular reason
to mark it invalid.

Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 922ad96654a159769dc890c4ef1896e10985f5bb
tree fe6736631229cdb0d961de37b738268e8dfca032
parent 625c028a6c0ccfd684f4334699f9ec7672fd179c
author Willy Tarreau <w@1wt.eu> Wed, 14 Mar 2007 09:32:43 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 14 Mar 2007 09:32:43 +0100

 net/netfilter/nf_conntrack_proto_tcp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 9e49631..926e302 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -774,6 +774,7 @@ static u8 tcp_valid_flags[(TH_FIN|TH_SYN
 	[TH_SYN|TH_ACK]			= 1,
 	[TH_SYN|TH_ACK|TH_PUSH]		= 1,
 	[TH_RST]			= 1,
+	[TH_RST|TH_PUSH]		= 1,
 	[TH_RST|TH_ACK]			= 1,
 	[TH_RST|TH_ACK|TH_PUSH]		= 1,
 	[TH_FIN|TH_ACK]			= 1,
