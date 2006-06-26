From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/06]: xt_tcpudp: fix double unregistration in error
	path
Date: Mon, 26 Jun 2006 17:43:11 +0200 (MEST)
Message-ID: <20060626154311.11682.33519.sendpatchset@localhost.localdomain>
References: <20060626154307.11682.28562.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060626154307.11682.28562.sendpatchset@localhost.localdomain>
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

[NETFILTER]: xt_tcpudp: fix double unregistration in error path

"xt_unregister_match(AF_INET, &tcp_matchstruct)" is called twice,
leaving "udp_matchstruct" registered, in case of a failure in the
registration of the udp6 structure.

Signed-off-by: Yuri Gushin <yuri@ecl-labs.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a81302ac4c22da108602d0c053c168a700c81e32
tree b420da32ec06dd3d9e9a42b581bcfcc05b6eee53
parent 7cb7437f3a26e2054d315a9baea52f9d825a7286
author Yuri Gushin <yuri@ecl-labs.org> Mon, 19 Jun 2006 16:59:55 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 19 Jun 2006 16:59:55 +0200

 net/netfilter/xt_tcpudp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_tcpudp.c b/net/netfilter/xt_tcpudp.c
index 1b61dac..a9a63aa 100644
--- a/net/netfilter/xt_tcpudp.c
+++ b/net/netfilter/xt_tcpudp.c
@@ -260,7 +260,7 @@ static int __init xt_tcpudp_init(void)
 	return ret;
 
 out_unreg_udp:
-	xt_unregister_match(&tcp_matchstruct);
+	xt_unregister_match(&udp_matchstruct);
 out_unreg_tcp6:
 	xt_unregister_match(&tcp6_matchstruct);
 out_unreg_tcp:
