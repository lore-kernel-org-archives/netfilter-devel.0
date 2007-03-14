From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 14/22]: nfnetlink: move EXPORT_SYMBOL declarations next
	to the exported symbol
Date: Wed, 14 Mar 2007 09:50:37 +0100 (MET)
Message-ID: <20070314085021.15282.20635.sendpatchset@localhost.localdomain>
References: <20070314084946.15282.58609.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070314084946.15282.58609.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nfnetlink: move EXPORT_SYMBOL declarations next to the exported symbol

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f7ec69deeb727422f3e7b2aec0e89a411c165d81
tree ea9661307f8d0e661338d3df4765692bf3e3d608
parent b826bdd775fb219458b886e3fc41491019af0d67
author Pablo Neira Ayuso <pablo@netfilter.org> Thu, 08 Mar 2007 18:25:59 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 14 Mar 2007 09:31:29 +0100

 net/netfilter/nfnetlink.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 6dd6654..9ba6aa4 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -78,6 +78,7 @@ int nfnetlink_subsys_register(struct nfn
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(nfnetlink_subsys_register);
 
 int nfnetlink_subsys_unregister(struct nfnetlink_subsystem *n)
 {
@@ -87,6 +88,7 @@ int nfnetlink_subsys_unregister(struct n
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(nfnetlink_subsys_unregister);
 
 static inline struct nfnetlink_subsystem *nfnetlink_get_subsys(u_int16_t type)
 {
@@ -121,6 +123,7 @@ void __nfa_fill(struct sk_buff *skb, int
 	memcpy(NFA_DATA(nfa), data, attrlen);
 	memset(NFA_DATA(nfa) + attrlen, 0, NFA_ALIGN(size) - size);
 }
+EXPORT_SYMBOL_GPL(__nfa_fill);
 
 void nfattr_parse(struct nfattr *tb[], int maxattr, struct nfattr *nfa, int len)
 {
@@ -133,6 +136,7 @@ void nfattr_parse(struct nfattr *tb[], i
 		nfa = NFA_NEXT(nfa, len);
 	}
 }
+EXPORT_SYMBOL_GPL(nfattr_parse);
 
 /**
  * nfnetlink_check_attributes - check and parse nfnetlink attributes
@@ -194,11 +198,13 @@ int nfnetlink_send(struct sk_buff *skb, 
 
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
@@ -296,10 +302,3 @@ static int __init nfnetlink_init(void)
 
 module_init(nfnetlink_init);
 module_exit(nfnetlink_exit);
-
-EXPORT_SYMBOL_GPL(nfnetlink_subsys_register);
-EXPORT_SYMBOL_GPL(nfnetlink_subsys_unregister);
-EXPORT_SYMBOL_GPL(nfnetlink_send);
-EXPORT_SYMBOL_GPL(nfnetlink_unicast);
-EXPORT_SYMBOL_GPL(nfattr_parse);
-EXPORT_SYMBOL_GPL(__nfa_fill);
