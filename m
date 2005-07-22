From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 5/5]: Fix ip6t_LOG MAC format
Date: Fri, 22 Jul 2005 09:36:00 +0200
Message-ID: <42E0A1E0.4080301@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="05.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="05.diff"
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

[NETFILTER]: Fix ip6t_LOG MAC format

I broke this in the patch that consolidated MAC logging.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3aa13776ac25163f546d52cc990d194bbbb9120c
tree d80cf2bd3faedff88fbd7e68f6638020cef38972
parent d778c0e9a5c2aa805b7c297b5712efb9c1ada2c6
author Patrick McHardy <kaber@trash.net> Fri, 22 Jul 2005 09:24:42 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 22 Jul 2005 09:24:42 +0200

 net/ipv6/netfilter/ip6t_LOG.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -373,9 +373,10 @@ ip6t_log_packet(unsigned int hooknum,
 		in ? in->name : "",
 		out ? out->name : "");
 	if (in && !out) {
+		unsigned int len;
 		/* MAC logging for input chain only. */
 		printk("MAC=");
-		if (skb->dev && skb->dev->hard_header_len &&
+		if (skb->dev && (len = skb->dev->hard_header_len) &&
 		    skb->mac.raw != skb->nh.raw) {
 			unsigned char *p = skb->mac.raw;
 			int i;
@@ -384,9 +385,11 @@ ip6t_log_packet(unsigned int hooknum,
 			    (p -= ETH_HLEN) < skb->head)
 				p = NULL;
 
-			if (p != NULL)
-				for (i = 0; i < skb->dev->hard_header_len; i++)
-					printk("%02x", p[i]);
+			if (p != NULL) {
+				for (i = 0; i < len; i++)
+					printk("%02x%s", p[i],
+					       i == len - 1 ? "" : ":");
+			}
 			printk(" ");
 
 			if (skb->dev->type == ARPHRD_SIT) {
