From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2.4 4/6]: Fix ip6t_LOG sit tunnel logging
Date: Mon, 01 Aug 2005 02:42:32 +0200
Message-ID: <42ED6FF8.1070102@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="4.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="4.diff"
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

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3828b256e2b5adae44649792fee705bc91b1c44a
tree cc9fd8c21d707864d11181326f0ab86f202bdae8
parent 387a85697670fa620cf91969bd97f01687e83b20
author Patrick McHardy <kaber@trash.net> Sun, 31 Jul 2005 20:24:37 +0200
committer Patrick McHardy <kaber@trash.net> Sun, 31 Jul 2005 20:24:37 +0200

 net/ipv6/netfilter/ip6t_LOG.c |   58 +++++++++++++++++------------------------
 1 files changed, 24 insertions(+), 34 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -363,7 +363,6 @@ ip6t_log_target(struct sk_buff **pskb,
 		const void *targinfo,
 		void *userinfo)
 {
-	struct ipv6hdr *ipv6h = (*pskb)->nh.ipv6h;
 	const struct ip6t_log_info *loginfo = targinfo;
 	char level_string[4] = "< >";
 
@@ -375,41 +374,32 @@ ip6t_log_target(struct sk_buff **pskb,
 		in ? in->name : "",
 		out ? out->name : "");
 	if (in && !out) {
+		unsigned int len;
 		/* MAC logging for input chain only. */
 		printk("MAC=");
-		if ((*pskb)->dev && (*pskb)->dev->hard_header_len && (*pskb)->mac.raw != (void*)ipv6h) {
-			if ((*pskb)->dev->type != ARPHRD_SIT){
-			  int i;
-			  unsigned char *p = (*pskb)->mac.raw;
-			  for (i = 0; i < (*pskb)->dev->hard_header_len; i++,p++)
-				printk("%02x%c", *p,
-			       		i==(*pskb)->dev->hard_header_len - 1
-			       		? ' ':':');
-			} else {
-			  int i;
-			  unsigned char *p = (*pskb)->mac.raw;
-			  if ( p - (ETH_ALEN*2+2) > (*pskb)->head ){
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
-			  if (((*pskb)->dev->addr_len == 4) &&
-			      (*pskb)->dev->hard_header_len > 20){
-			    printk("TUNNEL=");
-			    p = (*pskb)->mac.raw + 12;
-			    for (i = 0; i < 4; i++,p++)
-				printk("%3d%s", *p,
-					i == 3 ? "->" : ".");
-			    for (i = 0; i < 4; i++,p++)
-				printk("%3d%c", *p,
-					i == 3 ? ' ' : '.');
-			  }
+		if ((*pskb)->dev && (len = (*pskb)->dev->hard_header_len) &&
+		    (*pskb)->mac.raw != (*pskb)->nh.raw) {
+			unsigned char *p = (*pskb)->mac.raw;
+			int i;
+
+			if ((*pskb)->dev->type == ARPHRD_SIT &&
+			    (p -= ETH_HLEN) < (*pskb)->head)
+				p = NULL;
+
+			if (p != NULL) {
+				for (i = 0; i < len; i++)
+					printk("%02x%s", p[i],
+					       i == len - 1 ? "" : ":");
+			}
+			printk(" ");
+
+			if ((*pskb)->dev->type == ARPHRD_SIT) {
+				struct iphdr *iph;
+				
+				iph = (struct iphdr *)(*pskb)->mac.raw;
+				printk("TUNNEL=%u.%u.%u.%u->%u.%u.%u.%u ",
+				       NIPQUAD(iph->saddr),
+				       NIPQUAD(iph->daddr));
 			}
 		} else
 			printk(" ");
