From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7/7] group all export symbol declarations
Date: Mon, 12 Feb 2007 23:46:53 +0100
Message-ID: <45D0EE5D.204@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070803070405060703030505"
Cc: Patrick McHardy <kaber@trash.net>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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
--------------070803070405060703030505
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Minor cleanup, move nfnetlink_has_listeners where other export_symbol
declarations are

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------070803070405060703030505
Content-Type: text/plain;
 name="09.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="09.patch"

[PATCH] group all export symbol declarations

Minor cleanup, move nfnetlink_has_listeners where other export_symbol
declarations are

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org> 

Index: net-2.6.git/net/netfilter/nfnetlink.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nfnetlink.c	2007-01-21 23:51:14.000000000 +0100
+++ net-2.6.git/net/netfilter/nfnetlink.c	2007-01-21 23:51:15.000000000 +0100
@@ -145,7 +145,6 @@ int nfnetlink_has_listeners(unsigned int
 {
 	return netlink_has_listeners(nfnl, group);
 }
-EXPORT_SYMBOL_GPL(nfnetlink_has_listeners);
 
 int nfnetlink_send(struct sk_buff *skb, u32 pid, unsigned group, int echo)
 {
@@ -311,5 +310,6 @@ EXPORT_SYMBOL_GPL(nfnetlink_subsys_regis
 EXPORT_SYMBOL_GPL(nfnetlink_subsys_unregister);
 EXPORT_SYMBOL_GPL(nfnetlink_send);
 EXPORT_SYMBOL_GPL(nfnetlink_unicast);
+EXPORT_SYMBOL_GPL(nfnetlink_has_listeners);
 EXPORT_SYMBOL_GPL(nfattr_parse);
 EXPORT_SYMBOL_GPL(__nfa_fill);

--------------070803070405060703030505--
