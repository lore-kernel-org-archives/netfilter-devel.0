From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7/8] Remove unused var proto
Date: Mon, 05 Dec 2005 12:21:12 +0100
Message-ID: <439422A8.3070309@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050408000408030909080103"
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
--------------050408000408030909080103
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------050408000408030909080103
Content-Type: text/plain;
 name="16.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="16.patch"

Remove useless proto.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- netfilter-2.6.14.git.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-12-05 11:45:12.000000000 +0100
+++ netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-12-05 11:45:20.000000000 +0100
@@ -1204,7 +1204,6 @@ static int ctnetlink_expect_event(struct
 	unsigned int type;
 	unsigned char *b;
 	int flags = 0;
-	u16 proto;
 
 	if (events & IPEXP_NEW) {
 		type = IPCTNL_MSG_EXP_NEW;
@@ -1231,7 +1230,6 @@ static int ctnetlink_expect_event(struct
 		goto nfattr_failure;
 
 	nlh->nlmsg_len = skb->tail - b;
-	proto = exp->tuple.dst.protonum;
 	nfnetlink_send(skb, 0, NFNLGRP_CONNTRACK_EXP_NEW, 0);
 	return NOTIFY_DONE;
 

--------------050408000408030909080103--
