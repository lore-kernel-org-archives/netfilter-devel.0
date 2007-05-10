From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 08/09]: iptable_raw: ignore short packets sent by
	SOCK_RAW sockets
Date: Thu, 10 May 2007 15:41:20 +0200 (MEST)
Message-ID: <20070510134038.8559.13052.sendpatchset@localhost.localdomain>
References: <20070510134027.8559.40540.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070510134027.8559.40540.sendpatchset@localhost.localdomain>
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

[NETFILTER]: iptable_raw: ignore short packets sent by SOCK_RAW sockets

iptables matches and targets expect packets to have at least a full
IP header and a valid header length. Ignore packets sent through
raw sockets for which this isn't true as in the other tables.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e319b2005352790a24e1a91dc1af4b2f8643a876
tree 20b707b1bb83996c701f78745f18c75d3e06a3d0
parent 2a5f3d9533016d5f7914b75ea5f7a5fe98872f24
author Patrick McHardy <kaber@trash.net> Thu, 10 May 2007 15:38:16 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 10 May 2007 15:38:16 +0200

 net/ipv4/netfilter/iptable_raw.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index f7d28fd..d6e5033 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -5,6 +5,7 @@
  */
 #include <linux/module.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
+#include <net/ip.h>
 
 #define RAW_VALID_HOOKS ((1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_LOCAL_OUT))
 
@@ -54,6 +55,24 @@ ipt_hook(unsigned int hook,
 	return ipt_do_table(pskb, hook, in, out, &packet_raw);
 }
 
+static unsigned int
+ipt_local_hook(unsigned int hook,
+	       struct sk_buff **pskb,
+	       const struct net_device *in,
+	       const struct net_device *out,
+	       int (*okfn)(struct sk_buff *))
+{
+	/* root is playing with raw sockets. */
+	if ((*pskb)->len < sizeof(struct iphdr) ||
+	    ip_hdrlen(*pskb) < sizeof(struct iphdr)) {
+		if (net_ratelimit())
+			printk("iptable_raw: ignoring short SOCK_RAW"
+			       "packet.\n");
+		return NF_ACCEPT;
+	}
+	return ipt_do_table(pskb, hook, in, out, &packet_raw);
+}
+
 /* 'raw' is the very first table. */
 static struct nf_hook_ops ipt_ops[] = {
 	{
@@ -64,7 +83,7 @@ static struct nf_hook_ops ipt_ops[] = {
 		.owner = THIS_MODULE,
 	},
 	{
-		.hook = ipt_hook,
+		.hook = ipt_local_hook,
 		.pf = PF_INET,
 		.hooknum = NF_IP_LOCAL_OUT,
 		.priority = NF_IP_PRI_RAW,
