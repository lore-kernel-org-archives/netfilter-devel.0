From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 14/13]: Fix NAT PMTUD problems
Date: Sat, 18 Feb 2006 20:48:24 +0100
Message-ID: <43F77A08.4030308@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="14.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="14.diff"
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

[NETFILTER]: Fix NAT PMTUD problems

ICMP errors are only SNATed when their source matches the source of the
connection they are related to, otherwise the source address is not
changed. This creates problems with ICMP frag. required messages
originating from a router behind the NAT, if private IPs are used the
packet has a good change of getting dropped on the path to its destination.

Always NAT ICMP errors similar to the original connection.

Based on report by Al Viro.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit d8f2c4c9001e94af39643c14106c0bc7a659067b
tree 2856a88ee436733e0a8f4491d1a3a6ec6235db90
parent 0d101f9f648b51101f3c4ba4ba39b76b4a3e12c8
author Patrick McHardy <kaber@trash.net> Fri, 17 Feb 2006 16:13:25 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 17 Feb 2006 16:13:25 +0100

 net/ipv4/netfilter/ip_nat_core.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_core.c
index c1a6146..1741d55 100644
--- a/net/ipv4/netfilter/ip_nat_core.c
+++ b/net/ipv4/netfilter/ip_nat_core.c
@@ -434,6 +434,7 @@ int ip_nat_icmp_reply_translation(struct
 	} *inside;
 	struct ip_conntrack_tuple inner, target;
 	int hdrlen = (*pskb)->nh.iph->ihl * 4;
+	unsigned long statusbit;
 
 	if (!skb_make_writable(pskb, hdrlen + sizeof(*inside)))
 		return 0;
@@ -495,17 +496,16 @@ int ip_nat_icmp_reply_translation(struct
 
 	/* Change outer to look the reply to an incoming packet
 	 * (proto 0 means don't invert per-proto part). */
+	if (manip == IP_NAT_MANIP_SRC)
+		statusbit = IPS_SRC_NAT;
+	else
+		statusbit = IPS_DST_NAT;
+
+	/* Invert if this is reply dir. */
+	if (dir == IP_CT_DIR_REPLY)
+		statusbit ^= IPS_NAT_MASK;
 
-	/* Obviously, we need to NAT destination IP, but source IP
-	   should be NAT'ed only if it is from a NAT'd host.
-
-	   Explanation: some people use NAT for anonymizing.  Also,
-	   CERT recommends dropping all packets from private IP
-	   addresses (although ICMP errors from internal links with
-	   such addresses are not too uncommon, as Alan Cox points
-	   out) */
-	if (manip != IP_NAT_MANIP_SRC
-	    || ((*pskb)->nh.iph->saddr == ct->tuplehash[dir].tuple.src.ip)) {
+	if (ct->status & statusbit) {
 		invert_tuplepr(&target, &ct->tuplehash[!dir].tuple);
 		if (!manip_pkt(0, pskb, 0, &target, manip))
 			return 0;
