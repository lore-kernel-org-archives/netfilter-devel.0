From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/02]: fix xt_state compile failure
Date: Mon, 15 Jan 2007 10:22:54 +0100 (MET)
Message-ID: <20070115092253.22775.93499.sendpatchset@localhost.localdomain>
References: <20070115092251.22775.89608.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20070115092251.22775.89608.sendpatchset@localhost.localdomain>
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

[NETFILTER]: fix xt_state compile failure

In file included from net/netfilter/xt_state.c:13:
include/net/netfilter/nf_conntrack_compat.h: In function 'nf_ct_l3proto_try_module_get':
include/net/netfilter/nf_conntrack_compat.h:70: error: 'PF_INET' undeclared (first use in this function)
include/net/netfilter/nf_conntrack_compat.h:70: error: (Each undeclared identifier is reported only once
include/net/netfilter/nf_conntrack_compat.h:70: error: for each function it appears in.)
include/net/netfilter/nf_conntrack_compat.h:71: warning: control reaches end of non-void function
make[2]: *** [net/netfilter/xt_state.o] Error 1
make[1]: *** [net/netfilter] Error 2
make: *** [net] Error 2

A simple fix is to have nf_conntrack_compat.h #include <linux/socket.h>.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f8f00b3d4bf918190a6edd5b94bbee452b4f5d64
tree 72676d027ca247eb0ca171247c328860e3f043c3
parent 2725df007db9ffd520ce9be463e1d73202709d9b
author Mikael Pettersson <mikpe@it.uu.se> Mon, 15 Jan 2007 09:30:45 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 15 Jan 2007 09:30:45 +0100

 include/net/netfilter/nf_conntrack_compat.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_compat.h b/include/net/netfilter/nf_conntrack_compat.h
index b9ce5c8..6f84c1f 100644
--- a/include/net/netfilter/nf_conntrack_compat.h
+++ b/include/net/netfilter/nf_conntrack_compat.h
@@ -6,6 +6,7 @@ #ifdef __KERNEL__
 #if defined(CONFIG_IP_NF_CONNTRACK) || defined(CONFIG_IP_NF_CONNTRACK_MODULE)
 
 #include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/socket.h>
 
 #ifdef CONFIG_IP_NF_CONNTRACK_MARK
 static inline u_int32_t *nf_ct_get_mark(const struct sk_buff *skb,
