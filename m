From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 2.4 8/10]: fixes for ip6t_multiport
Date: Wed, 01 Dec 2004 17:07:30 +0900 (JST)
Message-ID: <200412010807.iB187UVY006278@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Wed_Dec__1_17:07:30_2004_838)--"
Content-Transfer-Encoding: 7bit
Cc: usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

----Next_Part(Wed_Dec__1_17:07:30_2004_838)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This patch fixes following bugs in ip6t_multiport.c,

	- missing check the size of the preference data.
	- IP6T_INV_PROTO should check with not ip->flags but ip->invflags.

Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Wed_Dec__1_17:07:30_2004_838)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="multiport.patch"

--- linux-2.4.28-rc1/./net/ipv6/netfilter/ip6t_multiport.c	2001-10-31 08:08:12.000000000 +0900
+++ linux-2.4.28-rc1-extfix/./net/ipv6/netfilter/ip6t_multiport.c	2004-11-10 00:51:45.000000000 +0900
@@ -74,9 +74,12 @@ checkentry(const char *tablename,
 {
 	const struct ip6t_multiport *multiinfo = matchinfo;
 
+	if (matchsize != IP6T_ALIGN(sizeof(struct ip6t_multiport)))
+		return 0;
+
 	/* Must specify proto == TCP/UDP, no unknown flags or bad count */
 	return (ip->proto == IPPROTO_TCP || ip->proto == IPPROTO_UDP)
-		&& !(ip->flags & IP6T_INV_PROTO)
+		&& !(ip->invflags & IP6T_INV_PROTO)
 		&& matchsize == IP6T_ALIGN(sizeof(struct ip6t_multiport))
 		&& (multiinfo->flags == IP6T_MULTIPORT_SOURCE
 		    || multiinfo->flags == IP6T_MULTIPORT_DESTINATION

----Next_Part(Wed_Dec__1_17:07:30_2004_838)----
