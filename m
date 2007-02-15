From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6/6] move EXPORT_SYMBOL declarations next to the exported
 symbol
Date: Thu, 15 Feb 2007 04:23:46 +0100
Message-ID: <45D3D242.1060509@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060602080705010107020307"
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
--------------060602080705010107020307
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------060602080705010107020307
Content-Type: text/plain;
 name="09.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="09.patch"

[PATCH] move EXPORT_SYMBOL declarations next to the exported symbol

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org> 

Index: net-2.6.git/net/netfilter/nfnetlink.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nfnetlink.c	2007-02-15 03:27:09.000000000 +0100
+++ net-2.6.git/net/netfilter/nfnetlink.c	2007-02-15 03:27:09.000000000 +0100
@@ -56,6 +56,7 @@ int nfnetlink_subsys_register(struct nfn
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(nfnetlink_subsys_register);
 
 int nfnetlink_subsys_unregister(struct nfnetlink_subsystem *n)
 {
@@ -65,6 +66,7 @@ int nfnetlink_subsys_unregister(struct n
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(nfnetlink_subsys_unregister);
 
 static inline struct nfnetlink_subsystem *nfnetlink_get_subsys(u_int16_t type)
 {
@@ -99,6 +101,7 @@ void __nfa_fill(struct sk_buff *skb, int
 	memcpy(NFA_DATA(nfa), data, attrlen);
 	memset(NFA_DATA(nfa) + attrlen, 0, NFA_ALIGN(size) - size);
 }
+EXPORT_SYMBOL_GPL(__nfa_fill);
 
 void nfattr_parse(struct nfattr *tb[], int maxattr, struct nfattr *nfa, int len)
 {
@@ -111,6 +114,7 @@ void nfattr_parse(struct nfattr *tb[], i
 		nfa = NFA_NEXT(nfa, len);
 	}
 }
+EXPORT_SYMBOL_GPL(nfattr_parse);
 
 /**
  * nfnetlink_check_attributes - check and parse nfnetlink attributes
@@ -173,11 +177,13 @@ int nfnetlink_send(struct sk_buff *skb, 
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(nfnetlink_send);
 
 int nfnetlink_unicast(struct sk_buff *skb, u_int32_t pid, int flags)
 {
 	return netlink_unicast(nfnl, skb, pid, flags);
 }
+EXPORT_SYMBOL_GPL(nfnetlink_unicast);
 
 /* Process one complete nfnetlink message. */
 static int nfnetlink_rcv_msg(struct sk_buff *skb,
@@ -318,10 +324,3 @@ static int __init nfnetlink_init(void)
 
 module_init(nfnetlink_init);
 module_exit(nfnetlink_exit);
-
-EXPORT_SYMBOL_GPL(nfnetlink_subsys_register);
-EXPORT_SYMBOL_GPL(nfnetlink_subsys_unregister);
-EXPORT_SYMBOL_GPL(nfnetlink_send);
-EXPORT_SYMBOL_GPL(nfnetlink_unicast);
-EXPORT_SYMBOL_GPL(nfattr_parse);
-EXPORT_SYMBOL_GPL(__nfa_fill);

--------------060602080705010107020307--
