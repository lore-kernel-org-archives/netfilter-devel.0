From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 9/7]: Fix ip6t_LOG sit tunnel logging
Date: Tue, 21 Jun 2005 18:24:53 +0200
Message-ID: <42B83F55.909@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="09.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="09.diff"
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

[NETFILTER]: Fix ip6t_LOG sit tunnel logging

Sit tunnel logging is currently broken:

MAC=01:23:45:67:89:ab->01:23:45:47:89:ac TUNNEL=123.123.  0.123-> 12.123.  6.123

Apart from the broken IP address, MAC addresses are printed differently
for sit tunnels than for everything else.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 98c724bae08162ce2254bc466c0dbddda2cc3591
tree 69697640ed2db28c916a552aa303d5910f2b8163
parent 043f4df110b0be9f82a5ddaeede9be7f7ae4c894
author Patrick McHardy <kaber@trash.net> Tue, 21 Jun 2005 18:24:04
committer Patrick McHardy <kaber@trash.net> Tue, 21 Jun 2005 18:24:04

 net/ipv6/netfilter/ip6t_LOG.c |   54 ++++++++++++++---------------------------
 1 files changed, 19 insertions(+), 35 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -366,8 +366,6 @@ ip6t_log_packet(unsigned int hooknum,
 		const char *level_string,
 		const char *prefix)
 {
-	struct ipv6hdr *ipv6h = skb->nh.ipv6h;
-
 	spin_lock_bh(&log_lock);
 	printk(level_string);
 	printk("%sIN=%s OUT=%s ",
@@ -377,39 +375,25 @@ ip6t_log_packet(unsigned int hooknum,
 	if (in && !out) {
 		/* MAC logging for input chain only. */
 		printk("MAC=");
-		if (skb->dev && skb->dev->hard_header_len && skb->mac.raw != (void*)ipv6h) {
-			if (skb->dev->type != ARPHRD_SIT){
-			  int i;
-			  unsigned char *p = skb->mac.raw;
-			  for (i = 0; i < skb->dev->hard_header_len; i++,p++)
-				printk("%02x%c", *p,
-			       		i==skb->dev->hard_header_len - 1
-			       		? ' ':':');
-			} else {
-			  int i;
-			  unsigned char *p = skb->mac.raw;
-			  if ( p - (ETH_ALEN*2+2) > skb->head ){
-			    p -= (ETH_ALEN+2);
-			    for (i = 0; i < (ETH_ALEN); i++,p++)
-				printk("%02x%s", *p,
-					i == ETH_ALEN-1 ? "->" : ":");
-			    p -= (ETH_ALEN*2);
-			    for (i = 0; i < (ETH_ALEN); i++,p++)
-				printk("%02x%c", *p,
-					i == ETH_ALEN-1 ? ' ' : ':');
-			  }
-			  
-			  if ((skb->dev->addr_len == 4) &&
-			      skb->dev->hard_header_len > 20){
-			    printk("TUNNEL=");
-			    p = skb->mac.raw + 12;
-			    for (i = 0; i < 4; i++,p++)
-				printk("%3d%s", *p,
-					i == 3 ? "->" : ".");
-			    for (i = 0; i < 4; i++,p++)
-				printk("%3d%c", *p,
-					i == 3 ? ' ' : '.');
-			  }
+		if (skb->dev && skb->dev->hard_header_len &&
+		    skb->mac.raw != skb->nh.raw) {
+			unsigned char *p = skb->mac.raw;
+			int i;
+
+			if (skb->dev->type == ARPHRD_SIT &&
+			    (p -= ETH_HLEN) < skb->head)
+				p = NULL;
+
+			if (p != NULL)
+				for (i = 0; i < skb->dev->hard_header_len; i++)
+					printk("%02x", p[i]);
+			printk(" ");
+
+			if (skb->dev->type == ARPHRD_SIT) {
+				struct iphdr *iph = (struct iphdr *)skb->mac.raw;
+				printk("TUNNEL=%u.%u.%u.%u->%u.%u.%u.%u ",
+				       NIPQUAD(iph->saddr),
+				       NIPQUAD(iph->daddr));
 			}
 		} else
 			printk(" ");
