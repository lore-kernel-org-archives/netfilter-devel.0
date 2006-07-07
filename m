From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 9/10][CTNETLINK] send expectation events if someone is
 listening to
Date: Fri, 07 Jul 2006 04:16:35 +0200
Message-ID: <44ADC403.9060106@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060309070106050101070000"
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
--------------060309070106050101070000
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch uses nfnetlink_has_listeners to check for listeners in userspace.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris


--------------060309070106050101070000
Content-Type: text/plain;
 name="09exp.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="09exp.patch"

[CTNETLINK] send expectation events if someone is listening to

This patch uses nfnetlink_has_listeners to check for listeners in userspace.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- net-2.6.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-07-07 00:47:02.000000000 +0200
+++ net-2.6/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-07-07 00:47:03.000000000 +0200
@@ -1286,6 +1286,9 @@ static int ctnetlink_expect_event(struct
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
--- net-2.6.orig/net/netfilter/nf_conntrack_netlink.c	2006-07-07 00:47:02.000000000 +0200
+++ net-2.6/net/netfilter/nf_conntrack_netlink.c	2006-07-07 00:47:03.000000000 +0200
@@ -1312,6 +1312,9 @@ static int ctnetlink_expect_event(struct
 	} else
 		return NOTIFY_DONE;
 
+	if (!nfnetlink_has_listeners(NFNLGRP_CONNTRACK_EXP_NEW))
+		return NOTIFY_DONE;
+
 	skb = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (!skb)
 		return NOTIFY_DONE;


--------------060309070106050101070000--
