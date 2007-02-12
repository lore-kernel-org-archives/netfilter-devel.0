From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 22/22]: nf_conntrack_tcp: make sysctl variables static
Date: Mon, 12 Feb 2007 11:36:53 +0100 (MET)
Message-ID: <20070212103652.661.17148.sendpatchset@localhost.localdomain>
References: <20070212103621.661.65165.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070212103621.661.65165.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack_tcp: make sysctl variables static

sysctls are registered by the protocol module itself since 2.6.19, no need
to have them visible to others.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ebdb23c15670f1d49d7466856f4db8fd00f6c3a9
tree 005b35c07855e3723b9d94ea77f203fb4e829924
parent a7b4ff1031d3e62fad2b7da2068bb5deb2041325
author Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 11:08:17 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 12 Feb 2007 11:08:17 +0100

 net/netfilter/nf_conntrack_proto_tcp.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index c2884f9..aff65aa 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -58,16 +58,16 @@ static DEFINE_RWLOCK(tcp_lock);
 /* "Be conservative in what you do,
     be liberal in what you accept from others."
     If it's non-zero, we mark only out of window RST segments as INVALID. */
-int nf_ct_tcp_be_liberal __read_mostly = 0;
+static int nf_ct_tcp_be_liberal __read_mostly = 0;
 
 /* If it is set to zero, we disable picking up already established
    connections. */
-int nf_ct_tcp_loose __read_mostly = 1;
+static int nf_ct_tcp_loose __read_mostly = 1;
 
 /* Max number of the retransmitted packets without receiving an (acceptable)
    ACK from the destination. If this number is reached, a shorter timer
    will be started. */
-int nf_ct_tcp_max_retrans __read_mostly = 3;
+static int nf_ct_tcp_max_retrans __read_mostly = 3;
 
   /* FIXME: Examine ipfilter's timeouts and conntrack transitions more
      closely.  They're more complex. --RR */
