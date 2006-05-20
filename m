From: Patrick McHardy <kaber@trash.net>
Subject: Re: [H.323 Helper 1/3]: Add support for Call Forwarding
Date: Sat, 20 May 2006 05:23:23 +0200
Message-ID: <446E8BAB.80105@trash.net>
References: <BAY109-DAV265AE2E1870989462F689B3BE0@phx.gbl><444F7A3F.9080507@trash.net><BAY109-DAV1099B645E5820953632189B3BC0@phx.gbl><444FA4A7.7060105@trash.net><BAY109-DAV107DE91F0E0B272EC778E4B3BC0@phx.gbl><444FD64F.5020002@trash.net><BAY109-DAV19D24F345ECC0228FE364B3BC0@phx.gbl>	<44512214.9050703@trash.net>	<BAY109-DAV10B763E5C4658D4D61C39CB3B20@phx.gbl>
	<44523130.20007@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080108000907030700050505"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jing Min Zhao <zhaojingmin@users.sourceforge.net>
In-Reply-To: <44523130.20007@trash.net>
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

This is a multi-part message in MIME format.
--------------080108000907030700050505
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Jing Min Zhao wrote:
> 
>>WARNING: "ip_fib_main_table" [net/ipv4/netfilter/ip_conntrack_h323.ko] undefined!
>>WARNING: "ip_fib_local_table" [net/ipv4/netfilter/ip_conntrack_h323.ko] undefined!
>>WARNING: "free_fib_info" [net/ipv4/netfilter/ip_conntrack_h323.ko] undefined!
> 
> 
> Oops .. these aren't exported. Just drop the patch, I'll send you a
> better one this weekend.

Sorry for the delay, but here it is :) I've already queued your patch
for 2.6.18, if there are no problems I'll just add this one on top.
The saved_ip conversion can happen latter, currently it would conflict
with a bunch of other patches.

--------------080108000907030700050505
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

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
commit 19d2680b3e7afec4258525d4ca13079bea4e4d7b
tree 67a780d51c8e8bde8234abc17d497177d53a2299
parent 165f6194cc61940a2277b0f0dde84695e598aebe
author Patrick McHardy <kaber@trash.net> Sat, 20 May 2006 05:16:47 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 20 May 2006 05:16:47 +0200

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

--------------080108000907030700050505--
