From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 8/10][CTNETLINK] Do not dump everything on new conntracks
 events
Date: Fri, 07 Jul 2006 04:16:13 +0200
Message-ID: <44ADC3ED.20709@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080607010300070503080002"
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
--------------080607010300070503080002
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Just dump what has been explicitely set in the event cache.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris


--------------080607010300070503080002
Content-Type: text/plain;
 name="08new.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="08new.patch"

[CTNETLINK] Do not dump everything on new conntracks events

Just dump what has been explicitely set in the event cache.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- net-2.6.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-07-06 20:13:05.000000000 +0200
+++ net-2.6/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-07-06 20:16:41.000000000 +0200
@@ -326,8 +326,6 @@
 	} else if (events & (IPCT_NEW | IPCT_RELATED)) {
 		type = IPCTNL_MSG_CT_NEW;
 		flags = NLM_F_CREATE|NLM_F_EXCL;
-		/* dump everything */
-		events = ~0UL;
 		group = NFNLGRP_CONNTRACK_NEW;
 	} else if (events & (IPCT_STATUS |
 		      IPCT_PROTOINFO |
Index: net-2.6/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-2.6.orig/net/netfilter/nf_conntrack_netlink.c	2006-07-06 20:17:29.000000000 +0200
+++ net-2.6/net/netfilter/nf_conntrack_netlink.c	2006-07-06 20:18:02.000000000 +0200
@@ -336,8 +336,6 @@
 	} else  if (events & (IPCT_NEW | IPCT_RELATED)) {
 		type = IPCTNL_MSG_CT_NEW;
 		flags = NLM_F_CREATE|NLM_F_EXCL;
-		/* dump everything */
-		events = ~0UL;
 		group = NFNLGRP_CONNTRACK_NEW;
 	} else  if (events & (IPCT_STATUS |
 		      IPCT_PROTOINFO |

--------------080607010300070503080002--
