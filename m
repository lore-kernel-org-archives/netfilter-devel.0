From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/8][CTNETLINK] dump conntrack mark
Date: Tue, 25 Jul 2006 15:17:44 +0200
Message-ID: <44C619F8.40201@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070002030705000608040101"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
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
--------------070002030705000608040101
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

ctnetlink dumps the mark iif the event mark happened

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------070002030705000608040101
Content-Type: text/plain;
 name="02dump_mark.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02dump_mark.patch"

[CTNETLINK] Dump conntrack mark

ctnetlink dumps the mark iif the event mark happened

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- net-2.6.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-07-06 19:52:51.000000000 +0200
+++ net-2.6/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-07-06 19:52:54.000000000 +0200
@@ -385,6 +385,10 @@ static int ctnetlink_conntrack_event(str
 	    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0)
 		goto nfattr_failure;
 
+	if (events & IPCT_MARK
+	    && ctnetlink_dump_mark(skb, ct) < 0)
+		goto nfattr_failure;
+
 	nlh->nlmsg_len = skb->tail - b;
 	nfnetlink_send(skb, 0, group, 0);
 	return NOTIFY_DONE;
Index: net-2.6/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-2.6.orig/net/netfilter/nf_conntrack_netlink.c	2006-07-06 19:53:19.000000000 +0200
+++ net-2.6/net/netfilter/nf_conntrack_netlink.c	2006-07-06 19:53:43.000000000 +0200
@@ -395,6 +395,10 @@ static int ctnetlink_conntrack_event(str
 	    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0)
 		goto nfattr_failure;
 
+	if (events & IPCT_MARK
+	    && ctnetlink_dump_mark(skb, ct) < 0)
+		goto nfattr_failure;
+
 	nlh->nlmsg_len = skb->tail - b;
 	nfnetlink_send(skb, 0, group, 0);
 	return NOTIFY_DONE;

--------------070002030705000608040101--
