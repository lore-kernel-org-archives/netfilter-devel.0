From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2/2]: Drop conntrack reference when packet leaves IP
Date: Mon, 18 Apr 2005 04:27:57 +0200
Message-ID: <42631B2D.4060609@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000604030405070502060002"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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
--------------000604030405070502060002
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

We had reoccuring problems with hanging conntrack module unload
because not all references could be reclaimed. Some were caused
by real leaks and were fixed, but queued packets are still a
problem. A packet with a conntrack reference can be held infinte
time in qdiscs or AF_PACKET socket receive queues. This patch drops
the conntrack reference when the packet leaves IP, so we don't have
to make assumptions about its fate.


--------------000604030405070502060002
Content-Type: text/x-patch;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/03/28 22:23:34+02:00 kernel@linuxace.com 
#   [NETFILTER]: Drop conntrack reference when packet leaves IP
#   
#   In the event a raw socket is created for sending purposes only, the creator
#   never bothers to check the socket's receive queue.  But we continue to
#   add skbs to its queue until it fills up.
#   
#   Unfortunately, if ip_conntrack is loaded on the box, each skb we add to the
#   queue potentially holds a reference to a conntrack.  If the user attempts
#   to unload ip_conntrack, we will spin around forever since the queued skbs
#   are pinned.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_standalone.c
#   2005/03/28 22:23:25+02:00 kernel@linuxace.com +0 -7
#   [NETFILTER]: Drop conntrack reference when packet leaves IP
#   
#   In the event a raw socket is created for sending purposes only, the creator
#   never bothers to check the socket's receive queue.  But we continue to
#   add skbs to its queue until it fills up.
#   
#   Unfortunately, if ip_conntrack is loaded on the box, each skb we add to the
#   queue potentially holds a reference to a conntrack.  If the user attempts
#   to unload ip_conntrack, we will spin around forever since the queued skbs
#   are pinned.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/ip_output.c
#   2005/03/28 22:23:25+02:00 kernel@linuxace.com +2 -0
#   [NETFILTER]: Drop conntrack reference when packet leaves IP
#   
#   In the event a raw socket is created for sending purposes only, the creator
#   never bothers to check the socket's receive queue.  But we continue to
#   add skbs to its queue until it fills up.
#   
#   Unfortunately, if ip_conntrack is loaded on the box, each skb we add to the
#   queue potentially holds a reference to a conntrack.  If the user attempts
#   to unload ip_conntrack, we will spin around forever since the queued skbs
#   are pinned.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
--- a/net/ipv4/ip_output.c	2005-04-18 04:00:03 +02:00
+++ b/net/ipv4/ip_output.c	2005-04-18 04:00:03 +02:00
@@ -195,6 +195,8 @@
 	nf_debug_ip_finish_output2(skb);
 #endif /*CONFIG_NETFILTER_DEBUG*/
 
+	nf_reset(skb);
+
 	if (hh) {
 		int hh_alen;
 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-04-18 04:00:03 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-04-18 04:00:03 +02:00
@@ -423,13 +423,6 @@
 				        const struct net_device *out,
 				        int (*okfn)(struct sk_buff *))
 {
-#if !defined(CONFIG_IP_NF_NAT) && !defined(CONFIG_IP_NF_NAT_MODULE)
-	/* Previously seen (loopback)?  Ignore.  Do this before
-           fragment check. */
-	if ((*pskb)->nfct)
-		return NF_ACCEPT;
-#endif
-
 	/* Gather fragments. */
 	if ((*pskb)->nh.iph->frag_off & htons(IP_MF|IP_OFFSET)) {
 		*pskb = ip_ct_gather_frags(*pskb,

--------------000604030405070502060002--
