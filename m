From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/8][CTNETLINK] send expectation events iif there listeners
Date: Tue, 25 Jul 2006 15:18:02 +0200
Message-ID: <44C61A0A.6040000@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090802050305090304050605"
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
--------------090802050305090304050605
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch uses nfnetlink_has_listeners to check for listeners in userspace.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------090802050305090304050605
Content-Type: text/plain;
 name="03exp.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03exp.patch"

[CTNETLINK] send expectation events iif there are listeners

This patch uses nfnetlink_has_listeners to check for listeners in userspace.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- net-2.6.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-07-14 16:38:57.000000000 +0200
+++ net-2.6/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-07-20 21:25:36.000000000 +0200
@@ -1260,6 +1260,9 @@ static int ctnetlink_expect_event(struct
 	} else
 		return NOTIFY_DONE;
 
+	if (!nfnetlink_has_listeners(NFNLGRP_CONNTRACK_EXP_NEW))
+		return NOTIFY_DONE;
+
 	skb = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (!skb)
 		return NOTIFY_DONE;
Index: net-2.6/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-2.6.orig/net/netfilter/nf_conntrack_netlink.c	2006-07-14 16:38:57.000000000 +0200
+++ net-2.6/net/netfilter/nf_conntrack_netlink.c	2006-07-20 21:25:36.000000000 +0200
@@ -1281,6 +1281,9 @@ static int ctnetlink_expect_event(struct
 	} else
 		return NOTIFY_DONE;
 
+	if (!nfnetlink_has_listeners(NFNLGRP_CONNTRACK_EXP_NEW))
+		return NOTIFY_DONE;
+
 	skb = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (!skb)
 		return NOTIFY_DONE;

--------------090802050305090304050605--
