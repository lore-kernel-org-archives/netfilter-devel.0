From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 8/8]: Don't insist on ICMP errors carrying 8 byte of
 protocol header
Date: Fri, 04 Mar 2005 13:00:57 +0100
Message-ID: <42284DF9.4060209@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="08.diff"
Content-Transfer-Encoding: 7bit
To: "David S. Miller" <davem@davemloft.net>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
#   2005/03/03 23:20:42+01:00 kaber@coreworks.de 
#   [NETFILTER]: Don't insist on ICMP errors carrying 8 byte of protocol header
#   
#   An ICMP error only needs to carry 8 bytes of protocol header if they were
#   present in the original packet. Makes netfilter's handling of ICMP errors
#   consistent with IP.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ipt_REJECT.c
#   2005/03/03 23:20:32+01:00 kaber@coreworks.de +0 -4
#   [NETFILTER]: Don't insist on ICMP errors carrying 8 byte of protocol header
#   
#   An ICMP error only needs to carry 8 bytes of protocol header if they were
#   present in the original packet. Makes netfilter's handling of ICMP errors
#   consistent with IP.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ipt_LOG.c
#   2005/03/03 23:20:32+01:00 kaber@coreworks.de +5 -5
#   [NETFILTER]: Don't insist on ICMP errors carrying 8 byte of protocol header
#   
#   An ICMP error only needs to carry 8 bytes of protocol header if they were
#   present in the original packet. Makes netfilter's handling of ICMP errors
#   consistent with IP.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
--- a/net/ipv4/netfilter/ipt_LOG.c	2005-03-03 23:36:12 +01:00
+++ b/net/ipv4/netfilter/ipt_LOG.c	2005-03-03 23:36:12 +01:00
@@ -198,16 +198,16 @@
 		static size_t required_len[NR_ICMP_TYPES+1]
 			= { [ICMP_ECHOREPLY] = 4,
 			    [ICMP_DEST_UNREACH]
-			    = 8 + sizeof(struct iphdr) + 8,
+			    = 8 + sizeof(struct iphdr),
 			    [ICMP_SOURCE_QUENCH]
-			    = 8 + sizeof(struct iphdr) + 8,
+			    = 8 + sizeof(struct iphdr),
 			    [ICMP_REDIRECT]
-			    = 8 + sizeof(struct iphdr) + 8,
+			    = 8 + sizeof(struct iphdr),
 			    [ICMP_ECHO] = 4,
 			    [ICMP_TIME_EXCEEDED]
-			    = 8 + sizeof(struct iphdr) + 8,
+			    = 8 + sizeof(struct iphdr),
 			    [ICMP_PARAMETERPROB]
-			    = 8 + sizeof(struct iphdr) + 8,
+			    = 8 + sizeof(struct iphdr),
 			    [ICMP_TIMESTAMP] = 20,
 			    [ICMP_TIMESTAMPREPLY] = 20,
 			    [ICMP_ADDRESS] = 12,
diff -Nru a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
--- a/net/ipv4/netfilter/ipt_REJECT.c	2005-03-03 23:36:12 +01:00
+++ b/net/ipv4/netfilter/ipt_REJECT.c	2005-03-03 23:36:12 +01:00
@@ -252,10 +252,6 @@
 	if (iph->frag_off&htons(IP_OFFSET))
 		return;
 
-	/* Ensure we have at least 8 bytes of proto header. */
-	if (skb_in->len < skb_in->nh.iph->ihl*4 + 8)
-		return;
-
 	/* If we send an ICMP error to an ICMP error a mess would result.. */
 	if (iph->protocol == IPPROTO_ICMP) {
 		struct icmphdr ihdr;
