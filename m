From: Yuri Gushin <yuri@ecl-labs.org>
Subject: [PATCH] xt_tcpudp.c match unregistration bug
Date: Mon, 12 Jun 2006 10:35:06 +0300
Message-ID: <200606121035.07231.yuri@ecl-labs.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: coreteam@netfilter.org, netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Hi all,

There is a match unregistration bug in the __init function of xt_tcpudp.c;

"xt_unregister_match(AF_INET, &tcp_matchstruct)" is called twice, 
leaving "udp_matchstruct" registered, in case of a failure in the 
registration of the udp6 structure.

Attached is a patch to resolve this issue.

Signed-off-by: Yuri Gushin <yuri@ecl-labs.org>


--- a/net/netfilter/xt_tcpudp.c 2006-05-31 03:31:44.000000000 +0300
+++ b/net/netfilter/xt_tcpudp.c 2006-06-11 17:41:20.000000000 +0300
@@ -314,7 +314,7 @@
        return ret;
 
 out_unreg_udp:
-       xt_unregister_match(AF_INET, &tcp_matchstruct);
+       xt_unregister_match(AF_INET, &udp_matchstruct);
 out_unreg_tcp6:
        xt_unregister_match(AF_INET6, &tcp6_matchstruct);
 out_unreg_tcp:
