From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 18/18]: nf_conntrack_l3proto_ipv4.c needs net/route.h
Date: Thu,  5 Jan 2006 05:06:55 +0100 (MET)
Message-ID: <20060105040619.23512.39043.sendpatchset@localhost.localdomain>
References: <20060105040554.23512.27346.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David S. Miller <davem@davemloft.net>
In-Reply-To: <20060105040554.23512.27346.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack_l3proto_ipv4.c needs net/route.h

CC [M]  net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.o
net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c: In function 'ipv4_refrag':
net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c:198: error: dereferencing pointer to incomplete type
make[3]: *** [net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.o] Error 1

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b3a15f5d0c42e1e8d62af29befbec373fbc225a9
tree b20ed9974bcffd63b84beb40b275910b3ca449b4
parent 727822f9fd9970d84b78d6016677ea1d348f5cfd
author Patrick McHardy <kaber@trash.net> Thu, 05 Jan 2006 01:42:19 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 05 Jan 2006 01:42:19 +0100

 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 8202c1c..e5cea90 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -22,6 +22,7 @@
 #include <linux/skbuff.h>
 #include <linux/icmp.h>
 #include <linux/sysctl.h>
+#include <net/route.h>
 #include <net/ip.h>
 
 #include <linux/netfilter_ipv4.h>
