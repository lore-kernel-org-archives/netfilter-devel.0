From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 8/8] dump ID and mark in conntrack events
Date: Mon, 05 Dec 2005 12:21:16 +0100
Message-ID: <439422AC.5080704@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090808010700080006080907"
Cc: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------090808010700080006080907
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------090808010700080006080907
Content-Type: text/plain;
 name="17.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="17.patch"

Dump the ID and the mark in events. This info is useful for the userspace 
clients.

Signed-off-by: Christian Hentschel <chentschel@people.netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- netfilter-2.6.14.git.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-12-04 04:12:23.000000000 +0100
+++ netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-12-04 04:22:16.000000000 +0100
@@ -373,7 +373,9 @@ static int ctnetlink_conntrack_event(str
 		goto nfattr_failure;
 
 	if (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
-	    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0)
+	    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0 ||
+	    ctnetlink_dump_mark(skb, ct) < 0 ||
+	    ctnetlink_dump_id(skb, ct) < 0)
 		goto nfattr_failure;
 
 	nlh->nlmsg_len = skb->tail - b;

--------------090808010700080006080907--
