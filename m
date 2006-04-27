From: Patrick McHardy <kaber@trash.net>
Subject: Re: [H.323 Helper 1/3]: Add support for Call Forwarding
Date: Thu, 27 Apr 2006 21:57:08 +0200
Message-ID: <44512214.9050703@trash.net>
References: <BAY109-DAV265AE2E1870989462F689B3BE0@phx.gbl><444F7A3F.9080507@trash.net><BAY109-DAV1099B645E5820953632189B3BC0@phx.gbl><444FA4A7.7060105@trash.net><BAY109-DAV107DE91F0E0B272EC778E4B3BC0@phx.gbl>
	<444FD64F.5020002@trash.net>
	<BAY109-DAV19D24F345ECC0228FE364B3BC0@phx.gbl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040407060405050406060308"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jing Min Zhao <zhaojingmin@hotmail.com>
In-Reply-To: <BAY109-DAV19D24F345ECC0228FE364B3BC0@phx.gbl>
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
--------------040407060405050406060308
Content-Type: text/plain; charset=gb18030
Content-Transfer-Encoding: 7bit

Jing Min Zhao wrote:
>>>>>I also want such a solution deadly, but I can't figure out a way. 
>>>>>Actually, the only question is how can a firewall tell that any two 
>>>>>endpoints can talk with each other directly without passing though it.
>>>>>Any suggestion for this will be greatly appreciated.
>>>>
>>>>There is no general way to do this, but we I think we can take a good
>>>>guess for the common case of no weird NATing etc based on the nexthop
>>>>information we get from fib_lookup(). I think an assumption that is
>>>>true for most cases is that if the nexthop information is identical,
>>>>the two endpoints can reach each other without our help. It needs to
>>>>be optional of course. What do you think about this?
>>>>
>>>>
>>>
>>>This is a good idea, and it's probably the best that a firewall can do.
>>>I'll think about it.

Here is a patch which does this. I don't have a proper setup, please
test if it works and if it does just integrate it with your patch and
resubmit. Thanks.


--------------040407060405050406060308
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: H.323 helper: optionally use nexthop information to guess whether two hosts can reach each other directly

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit fa397eabacd7c7aeab07227bd6ab40b70c59d2c9
tree 23bd56b41918ce09725adf1a4c5320ca87b71961
parent c6e95adefe7a13a2cf4933e131c86a36410340bf
author Patrick McHardy <kaber@trash.net> Thu, 27 Apr 2006 21:54:55 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 27 Apr 2006 21:54:55 +0200

 net/ipv4/netfilter/ip_conntrack_helper_h323.c |   61 ++++++++++++-------------
 1 files changed, 29 insertions(+), 32 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_h323.c b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
index 5dec119..8aeec26 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_h323.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
@@ -24,6 +24,7 @@
 #include <linux/moduleparam.h>
 #include <linux/ctype.h>
 #include <linux/inet.h>
+#include <net/ip_fib.h>
 
 #if 0
 #define DEBUGP printk
@@ -40,12 +41,9 @@ static int gkrouted_only = 1;
 module_param(gkrouted_only, int, 0600);
 MODULE_PARM_DESC(gkrouted_only, "only accept calls from gatekeeper");
 
-static char *internal_net = NULL;
-static u_int32_t internal_net_addr = 0;
-static u_int32_t internal_net_mask = 0;
-module_param(internal_net, charp, 0600);
-MODULE_PARM_DESC(internal_net, "specify your internal network using format "
-		 "address/mask. this is used by call forwarding support");
+static int forwarding_mode;
+module_param(forwarding_mode, int, 0600);
+MODULE_PARM_DESC(forwarding_mode, "call forwarding mode");
 
 /* Hooks for NAT */
 int (*set_h245_addr_hook) (struct sk_buff ** pskb,
@@ -717,14 +715,31 @@ static int expect_callforwarding(struct 
 	if (!get_h225_addr(*data, addr, &ip, &port) || port == 0)
 		return 0;
 
-	/* If the calling party is on the same side of the forward-to party,
-	 * we don't need to track the second call */
-	if (internal_net &&
-	    ((ip & internal_net_mask) == internal_net_addr) ==
-	    ((ct->tuplehash[!dir].tuple.src.ip & internal_net_mask) ==
-	     internal_net_addr)) {
-		DEBUGP("ip_ct_q931: Call Forwarding not tracked\n");
-		return 0;
+	if (forwarding_mode) {
+		struct fib_result res1, res2;
+		struct flowi fl;
+		int eq = 0;
+
+		memset(&fl, 0, sizeof(fl));
+
+		fl.fl4_dst = ip;
+		if (fib_lookup(&fl, &res1) == 0) {
+			fl.fl4_dst = ct->tuplehash[!dir].tuple.src.ip;
+			if (fib_lookup(&fl, &res2) == 0) {
+				if (FIB_RES_GW(res1) == FIB_RES_GW(res2) &&
+				    FIB_RES_OIF(res1) == FIB_RES_OIF(res2))
+					eq = 1;
+				fib_res_put(&res2);
+			}
+			fib_res_put(&res1);
+		}
+
+		/* If the calling party is on the same side of the forward-to
+		 * party, we don't need to track the second call */
+		if (eq) {
+			DEBUGP("ip_ct_q931: Call Forwarding not tracked\n");
+			return 0;
+		}
 	}
 
 	/* Create expect for the second call leg */
@@ -1760,7 +1775,6 @@ static void fini(void)
 static int __init init(void)
 {
 	int ret;
-	char *p;
 
 	h323_buffer = kmalloc(65536, GFP_KERNEL);
 	if (!h323_buffer)
@@ -1770,23 +1784,6 @@ static int __init init(void)
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

--------------040407060405050406060308--
