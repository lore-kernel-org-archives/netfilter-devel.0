From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 15/17]: H.323 helper: replace internal_net_addr
	parameter by routing-based heuristic
Date: Tue, 30 May 2006 00:34:33 +0200 (MEST)
Message-ID: <20060529223433.24834.80475.sendpatchset@localhost.localdomain>
References: <20060529223404.24834.30808.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060529223404.24834.30808.sendpatchset@localhost.localdomain>
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

[NETFILTER]: H.323 helper: replace internal_net_addr parameter by routing-based heuristic

Call Forwarding doesn't need to create an expectation if both peers can
reach each other without our help. The internal_net_addr parameter
lets the user explicitly specify a single network where this is true,
but is not very flexible and even fails in the common case that calls
will both be forwarded to outside parties and inside parties. Use an
optional heuristic based on routing instead, the assumption is that
if bpth the outgoing device and the gateway are equal, both peers can
reach each other directly.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4f26e484683957dde7142a135a8938efe9b69f5f
tree 02b20ac59b8a16cede8e2d4d590bc759ffc0c2de
parent cf55d393a491b6d441f36a68117e9bdfc8940a47
author Patrick McHardy <kaber@trash.net> Tue, 30 May 2006 00:08:45 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 30 May 2006 00:08:45 +0200

 net/ipv4/netfilter/ip_conntrack_helper_h323.c |   57 ++++++++++++-------------
 1 files changed, 27 insertions(+), 30 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_h323.c b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
index 3052468..0665674 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_h323.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
@@ -40,12 +40,11 @@ static int gkrouted_only = 1;
 module_param(gkrouted_only, int, 0600);
 MODULE_PARM_DESC(gkrouted_only, "only accept calls from gatekeeper");
 
-static char *internal_net = NULL;
-static u_int32_t internal_net_addr = 0;
-static u_int32_t internal_net_mask = 0;
-module_param(internal_net, charp, 0600);
-MODULE_PARM_DESC(internal_net, "specify your internal network using format "
-		 "address/mask. this is used by call forwarding support");
+static int callforward_filter = 1;
+module_param(callforward_filter, bool, 0600);
+MODULE_PARM_DESC(callforward_filter, "only create call forwarding expectations "
+		                     "if both endpoints are on different sides "
+				     "(determined by routing information)");
 
 /* Hooks for NAT */
 int (*set_h245_addr_hook) (struct sk_buff ** pskb,
@@ -721,12 +720,28 @@ static int expect_callforwarding(struct 
 
 	/* If the calling party is on the same side of the forward-to party,
 	 * we don't need to track the second call */
-	if (internal_net &&
-	    ((ip & internal_net_mask) == internal_net_addr) ==
-	    ((ct->tuplehash[!dir].tuple.src.ip & internal_net_mask) ==
-	     internal_net_addr)) {
-		DEBUGP("ip_ct_q931: Call Forwarding not tracked\n");
-		return 0;
+	if (callforward_filter) {
+		struct rtable *rt1, *rt2;
+		struct flowi fl1 = {
+			.fl4_dst = ip,
+		};
+		struct flowi fl2 = {
+			.fl4_dst = ct->tuplehash[!dir].tuple.src.ip,
+		};
+
+		if (ip_route_output_key(&rt1, &fl1) == 0) {
+			if (ip_route_output_key(&rt2, &fl2) == 0) {
+				if (rt1->rt_gateway == rt2->rt_gateway &&
+				    rt1->u.dst.dev  == rt2->u.dst.dev)
+					ret = 1;
+				dst_release(&rt2->u.dst);
+			}
+			dst_release(&rt1->u.dst);
+		}
+		if (ret) {
+			DEBUGP("ip_ct_q931: Call Forwarding not tracked\n");
+			return 0;
+		}
 	}
 
 	/* Create expect for the second call leg */
@@ -1762,7 +1777,6 @@ static void fini(void)
 static int __init init(void)
 {
 	int ret;
-	char *p;
 
 	h323_buffer = kmalloc(65536, GFP_KERNEL);
 	if (!h323_buffer)
@@ -1772,23 +1786,6 @@ static int __init init(void)
 		fini();
 		return ret;
 	}
-
-	if (internal_net) {
-		if ((p = strchr(internal_net, '/')))
-			*p++ = 0;
-		if (isdigit(internal_net[0])) {
-			internal_net_addr = in_aton(internal_net);
-			if (p && isdigit(p[0]))
-				internal_net_mask = in_aton(p);
-			else
-				internal_net_mask = 0xffffffff;
-			internal_net_addr &= internal_net_mask;
-		}
-		DEBUGP("ip_ct_h323: internal_net = %u.%u.%u.%u/%u.%u.%u.%u\n",
-		       NIPQUAD(internal_net_addr),
-		       NIPQUAD(internal_net_mask));
-	}
-
 	DEBUGP("ip_ct_h323: init success\n");
 	return 0;
 }
