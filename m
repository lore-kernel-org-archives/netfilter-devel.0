From: Stephen Hemminger <shemminger@osdl.org>
Subject: Re: [PTCH 2.5.68] netfilter using Read Copy Update
Date: Mon, 28 Apr 2003 10:23:07 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030428102307.0d2718d3.shemminger@osdl.org>
References: <20030427132413.GP990@sunbeam.de.gnumonks.org>
	<20030428062622.5F0FE2C4D3@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
   davem@redhat.com
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>,
   "David S. Miller"
 <davem@redhat.com>
In-Reply-To: <20030428062622.5F0FE2C4D3@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Addition to Rusty's patch that uses C99 initializers for the 
Netfilter Ethernet bridge routing hooks table.

Dave if you apply Rusty's for the queue/module/reinject race then
please apply this.

diff -Nru a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
--- a/net/bridge/br_netfilter.c	Mon Apr 28 10:19:28 2003
+++ b/net/bridge/br_netfilter.c	Mon Apr 28 10:19:28 2003
@@ -572,15 +572,51 @@
  * ip_refrag() can return NF_STOLEN.
  */
 static struct nf_hook_ops br_nf_ops[] = {
-	{ { NULL, NULL }, br_nf_pre_routing, THIS_MODULE, PF_BRIDGE, NF_BR_PRE_ROUTING, NF_BR_PRI_BRNF },
-	{ { NULL, NULL }, br_nf_local_in, THIS_MODULE, PF_BRIDGE, NF_BR_LOCAL_IN, NF_BR_PRI_BRNF },
-	{ { NULL, NULL }, br_nf_forward, THIS_MODULE, PF_BRIDGE, NF_BR_FORWARD, NF_BR_PRI_BRNF },
-	{ { NULL, NULL }, br_nf_local_out, THIS_MODULE, PF_BRIDGE, NF_BR_LOCAL_OUT, NF_BR_PRI_FIRST },
-	{ { NULL, NULL }, br_nf_post_routing, THIS_MODULE, PF_BRIDGE, NF_BR_POST_ROUTING, NF_BR_PRI_LAST },
-	{ { NULL, NULL }, ipv4_sabotage_in, THIS_MODULE, PF_INET, NF_IP_PRE_ROUTING, NF_IP_PRI_FIRST },
-	{ { NULL, NULL }, ipv4_sabotage_out, THIS_MODULE, PF_INET, NF_IP_FORWARD, NF_IP_PRI_BRIDGE_SABOTAGE_FORWARD },
-	{ { NULL, NULL }, ipv4_sabotage_out, THIS_MODULE, PF_INET, NF_IP_LOCAL_OUT, NF_IP_PRI_BRIDGE_SABOTAGE_LOCAL_OUT },
-	{ { NULL, NULL }, ipv4_sabotage_out, THIS_MODULE, PF_INET, NF_IP_POST_ROUTING, NF_IP_PRI_FIRST }
+	{ .hook = br_nf_pre_routing, 
+	  .owner = THIS_MODULE, 
+	  .pf = PF_BRIDGE, 
+	  .hooknum = NF_BR_PRE_ROUTING, 
+	  .priority = NF_BR_PRI_BRNF, },
+	{ .hook = br_nf_local_in,
+	  .owner = THIS_MODULE,
+	  .pf = PF_BRIDGE,
+	  .hooknum = NF_BR_LOCAL_IN,
+	  .priority = NF_BR_PRI_BRNF, },
+	{ .hook = br_nf_forward,
+	  .owner = THIS_MODULE,
+	  .pf = PF_BRIDGE,
+	  .hooknum = NF_BR_FORWARD,
+	  .priority = NF_BR_PRI_BRNF, },
+	{ .hook = br_nf_local_out,
+	  .owner = THIS_MODULE,
+	  .pf = PF_BRIDGE,
+	  .hooknum = NF_BR_LOCAL_OUT,
+	  .priority = NF_BR_PRI_FIRST, },
+	{ .hook = br_nf_post_routing,
+	  .owner = THIS_MODULE,
+	  .pf = PF_BRIDGE,
+	  .hooknum = NF_BR_POST_ROUTING,
+	  .priority = NF_BR_PRI_LAST, },
+	{ .hook = ipv4_sabotage_in,
+	  .owner = THIS_MODULE,
+	  .pf = PF_INET,
+	  .hooknum = NF_IP_PRE_ROUTING,
+	  .priority = NF_IP_PRI_FIRST, },
+	{ .hook = ipv4_sabotage_out,
+	  .owner = THIS_MODULE,
+	  .pf = PF_INET,
+	  .hooknum = NF_IP_FORWARD,
+	  .priority = NF_IP_PRI_BRIDGE_SABOTAGE_FORWARD, },
+	{ .hook = ipv4_sabotage_out,
+	  .owner = THIS_MODULE,
+	  .pf = PF_INET,
+	  .hooknum = NF_IP_LOCAL_OUT,
+	  .priority = NF_IP_PRI_BRIDGE_SABOTAGE_LOCAL_OUT, },
+	{ .hook = ipv4_sabotage_out,
+	  .owner = THIS_MODULE,
+	  .pf = PF_INET,
+	  .hooknum = NF_IP_POST_ROUTING,
+	  .priority = NF_IP_PRI_FIRST, },
 };
 
 #define NUMHOOKS (sizeof(br_nf_ops)/sizeof(br_nf_ops[0]))
