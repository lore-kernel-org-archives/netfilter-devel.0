From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 07/09]: iptable_{filter,
	mangle}: more descriptive "happy cracking" message
Date: Thu, 10 May 2007 15:41:19 +0200 (MEST)
Message-ID: <20070510134036.8559.70460.sendpatchset@localhost.localdomain>
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

[NETFILTER]: iptable_{filter,mangle}: more descriptive "happy cracking" message

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2a5f3d9533016d5f7914b75ea5f7a5fe98872f24
tree e20bd2440ccf6814b349fb00cee0941d63b31d61
parent 204674154410105c5b614101779698b439c2d864
author Patrick McHardy <kaber@trash.net> Thu, 10 May 2007 15:30:22 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 10 May 2007 15:30:22 +0200

 net/ipv4/netfilter/iptable_filter.c |    3 ++-
 net/ipv4/netfilter/iptable_mangle.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index ea14979..4f51c1d 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -81,7 +81,8 @@ ipt_local_out_hook(unsigned int hook,
 	if ((*pskb)->len < sizeof(struct iphdr)
 	    || ip_hdrlen(*pskb) < sizeof(struct iphdr)) {
 		if (net_ratelimit())
-			printk("ipt_hook: happy cracking.\n");
+			printk("iptable_filter: ignoring short SOCK_RAW "
+			       "packet.\n");
 		return NF_ACCEPT;
 	}
 
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index c3827ba..902446f 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -100,7 +100,8 @@ ipt_local_hook(unsigned int hook,
 	if ((*pskb)->len < sizeof(struct iphdr)
 	    || ip_hdrlen(*pskb) < sizeof(struct iphdr)) {
 		if (net_ratelimit())
-			printk("ipt_hook: happy cracking.\n");
+			printk("iptable_mangle: ignoring short SOCK_RAW "
+			       "packet.\n");
 		return NF_ACCEPT;
 	}
 
