From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.4 8/8]: Fix IP/TCP option logging
Date: Fri, 04 Mar 2005 13:18:56 +0100
Message-ID: <42285230.2070107@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="08.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="08.diff"
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

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/03/04 11:36:23+01:00 kaber@coreworks.de 
#   [NETFILTER]: Fix IP/TCP option logging
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ipt_LOG.c
#   2005/03/04 11:35:42+01:00 kaber@coreworks.de +4 -3
#   [NETFILTER]: Fix IP/TCP option logging
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
--- a/net/ipv4/netfilter/ipt_LOG.c	2005-03-04 11:37:01 +01:00
+++ b/net/ipv4/netfilter/ipt_LOG.c	2005-03-04 11:37:01 +01:00
@@ -67,8 +67,8 @@
 		printk("FRAG:%u ", ntohs(iph->frag_off) & IP_OFFSET);
 
 	if ((info->logflags & IPT_LOG_IPOPT)
-	    && iph->ihl * 4 != sizeof(struct iphdr)
-	    && iph->ihl * 4 >= datalen) {
+	    && iph->ihl * 4 > sizeof(struct iphdr)
+	    && iph->ihl * 4 <= len) {
 		unsigned int i;
 
 		/* Max length: 127 "OPT (" 15*4*2chars ") " */
@@ -126,7 +126,8 @@
 		printk("URGP=%u ", ntohs(tcph->urg_ptr));
 
 		if ((info->logflags & IPT_LOG_TCPOPT)
-		    && tcph->doff * 4 != sizeof(struct tcphdr)) {
+		    && tcph->doff * 4 > sizeof(struct tcphdr)
+		    && tcph->doff * 4 <= datalen) {
 			unsigned int i;
 
 			/* Max length: 127 "OPT (" 15*4*2chars ") " */
