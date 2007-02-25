From: Willy Tarreau <w@1wt.eu>
Subject: [PATCH-2.4] fix missing parenthesis in unused macro in
	ip_nat_standalone
Date: Sun, 25 Feb 2007 09:08:54 +0100
Message-ID: <20070225080854.GD25706@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, davem@davemloft.net
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Just FYI, I've queued the following patch for 2.4.35-pre2.
Mariusz proposed to remove the unused macro (which is not
in 2.6 anymore BTW), but I don't like removing anything in
code freeze. However, fixing invalid code still seems important
to me.

Regards,
Willy

From: Willy Tarreau <w@1wt.eu>
Date: Sun, 25 Feb 2007 08:55:44 +0100
Subject: [PATCH] fix missing parenthesis in unused macro in ip_nat_standalone

The bug found by Mariusz Kozlowski affects an unused macro. However,
I prefer to fix the macro than removing it because external patches
might be relying on it.
---
 net/ipv4/netfilter/ip_nat_standalone.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ip_nat_standalone.c b/net/ipv4/netfilter/ip_nat_standalone.c
index 2628978..ff8935b 100644
--- a/net/ipv4/netfilter/ip_nat_standalone.c
+++ b/net/ipv4/netfilter/ip_nat_standalone.c
@@ -47,7 +47,7 @@ #define HOOKNAME(hooknum) ((hooknum) == 
 			   : ((hooknum) == NF_IP_PRE_ROUTING ? "PRE_ROUTING" \
 			      : ((hooknum) == NF_IP_LOCAL_OUT ? "LOCAL_OUT"  \
 			         : ((hooknum) == NF_IP_LOCAL_IN ? "LOCAL_IN"  \
-				    : "*ERROR*")))
+				    : "*ERROR*"))))
 
 static inline int call_expect(struct ip_conntrack *master,
 			      struct sk_buff **pskb,
-- 
1.4.2.4
