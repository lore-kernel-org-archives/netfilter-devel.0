From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/8] ctnetlink_event cleanup
Date: Mon, 05 Dec 2005 12:21:08 +0100
Message-ID: <439422A4.8010305@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020205050500080102080502"
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
--------------020205050500080102080502
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------020205050500080102080502
Content-Type: text/plain;
 name="14.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="14.patch"

Cleanup: Use 'else if' instead of a ugly 'goto' statement.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- netfilter-2.6.14.git.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-12-05 11:43:34.000000000 +0100
+++ netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-12-05 11:44:55.000000000 +0100
@@ -311,29 +311,22 @@ static int ctnetlink_conntrack_event(str
 	if (events & IPCT_DESTROY) {
 		type = IPCTNL_MSG_CT_DELETE;
 		group = NFNLGRP_CONNTRACK_DESTROY;
-		goto alloc_skb;
-	}
-	if (events & (IPCT_NEW | IPCT_RELATED)) {
+	} else  if (events & (IPCT_NEW | IPCT_RELATED)) {
 		type = IPCTNL_MSG_CT_NEW;
 		flags = NLM_F_CREATE|NLM_F_EXCL;
 		/* dump everything */
 		events = ~0UL;
 		group = NFNLGRP_CONNTRACK_NEW;
-		goto alloc_skb;
-	}
-	if (events & (IPCT_STATUS |
+	} else if (events & (IPCT_STATUS |
 		      IPCT_PROTOINFO |
 		      IPCT_HELPER |
 		      IPCT_HELPINFO |
 		      IPCT_NATINFO)) {
 		type = IPCTNL_MSG_CT_NEW;
 		group = NFNLGRP_CONNTRACK_UPDATE;
-		goto alloc_skb;
-	} 
+	} else 
+		return NOTIFY_DONE;
 	
-	return NOTIFY_DONE;
-
-alloc_skb:
   /* FIXME: Check if there are any listeners before, don't hurt performance */
 	
 	skb = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);

--------------020205050500080102080502--
