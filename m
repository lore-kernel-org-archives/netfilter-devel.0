From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 8/8][CTNETLINK] Remove useless event-bit-is-set checkings
 on updates
Date: Tue, 25 Jul 2006 15:27:23 +0200
Message-ID: <44C61C3B.8070504@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020203080606080803030606"
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
--------------020203080606080803030606
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

IPCT_HELPER and IPCT_NATINFO bits are never set on updates.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------020203080606080803030606
Content-Type: text/plain;
 name="08remove.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="08remove.patch"

[CTNETLINK] Remove useless event-bit-is-set checkings on updates

IPCT_HELPER and IPCT_NATINFO bits are never set on updates.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-2.6.orig/net/netfilter/nf_conntrack_netlink.c	2006-07-25 01:20:38.000000000 +0200
+++ net-2.6/net/netfilter/nf_conntrack_netlink.c	2006-07-25 01:20:49.000000000 +0200
@@ -340,11 +340,7 @@ static int ctnetlink_conntrack_event(str
 			  IPCT_STATUS |
 			  IPCT_PROTOINFO;
 		group = NFNLGRP_CONNTRACK_NEW;
-	} else  if (events & (IPCT_STATUS |
-		      IPCT_PROTOINFO |
-		      IPCT_HELPER |
-		      IPCT_HELPINFO |
-		      IPCT_NATINFO)) {
+	} else  if (events & (IPCT_STATUS | IPCT_PROTOINFO)) {
 		type = IPCTNL_MSG_CT_NEW;
 		events |= IPCT_REFRESH |
 			  IPCT_STATUS |
Index: net-2.6/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- net-2.6.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-07-25 01:20:38.000000000 +0200
+++ net-2.6/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-07-25 01:20:49.000000000 +0200
@@ -330,11 +330,7 @@ static int ctnetlink_conntrack_event(str
 			  IPCT_STATUS |
 			  IPCT_PROTOINFO;
 		group = NFNLGRP_CONNTRACK_NEW;
-	} else if (events & (IPCT_STATUS |
-		      IPCT_PROTOINFO |
-		      IPCT_HELPER |
-		      IPCT_HELPINFO |
-		      IPCT_NATINFO)) {
+	} else if (events & (IPCT_STATUS | IPCT_PROTOINFO)) {
 		type = IPCTNL_MSG_CT_NEW;
 		events |= IPCT_REFRESH |
 			  IPCT_STATUS |

--------------020203080606080803030606--
