From: Patrick McHardy <kaber@trash.net>
Subject: Re: problem with active ftp masqarading in kernel newer than
	2.6.10-rc1
Date: Mon, 25 Apr 2005 05:43:04 +0200
Message-ID: <426C6748.2080907@trash.net>
References: <20050421222803Z136196-2326+375@kps1.test.onet.pl>	<4268BA1C.1080902@trash.net>
	<20050424195714.61edbfc3.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020906010901050800030105"
Cc: mateusz@republika.pl, linux-net@vger.kernel.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20050424195714.61edbfc3.davem@davemloft.net>
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
--------------020906010901050800030105
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

David S. Miller wrote:
> Patrick, as you've seen I've applied this sequence number fixing patch
> and the conntrack one to handle SYN+ACK+PSH correctly.
> 
> But I seem to remember there was some third pending netfilter fix you
> want me to put into 2.6.12, but I can't find it anywhere.  Am I right?
> If so, please point me at it.

There were two more fixes for 2.6.12, I've attached them to this mail
and cut-n-pasted the descriptions below.

--- 1 ---
This first patch fixes truncated sequence numbers in ip_conntrack_ftp,
the types were changed to u16 by some unfortunate patch.
----------

--- 2 ---
We had reoccuring problems with hanging conntrack module unload
because not all references could be reclaimed. Some were caused
by real leaks and were fixed, but queued packets are still a
problem. A packet with a conntrack reference can be held infinte
time in qdiscs or AF_PACKET socket receive queues. This patch drops
the conntrack reference when the packet leaves IP, so we don't have
to make assumptions about its fate.
---------

Regards
Patrick

--------------020906010901050800030105
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/03/09 22:51:34+01:00 yasuyuki.kozakai@toshiba.co.jp 
#   [NETFILTER]: Fix truncated sequence numbers in FTP helper
#   
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozkaai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_ftp.c
#   2005/03/09 22:51:26+01:00 yasuyuki.kozakai@toshiba.co.jp +2 -2
#   [NETFILTER]: Fix truncated sequence numbers in FTP helper
#   
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozkaai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_ftp.c b/net/ipv4/netfilter/ip_conntrack_ftp.c
--- a/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-04-18 03:59:47 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-04-18 03:59:47 +02:00
@@ -252,7 +252,7 @@
 }
 
 /* Look up to see if we're just after a \n. */
-static int find_nl_seq(u16 seq, const struct ip_ct_ftp_master *info, int dir)
+static int find_nl_seq(u32 seq, const struct ip_ct_ftp_master *info, int dir)
 {
 	unsigned int i;
 
@@ -263,7 +263,7 @@
 }
 
 /* We don't update if it's older than what we have. */
-static void update_nl_seq(u16 nl_seq, struct ip_ct_ftp_master *info, int dir)
+static void update_nl_seq(u32 nl_seq, struct ip_ct_ftp_master *info, int dir)
 {
 	unsigned int i, oldest = NUM_SEQ_TO_REMEMBER;
 

--------------020906010901050800030105
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

--------------020906010901050800030105--
