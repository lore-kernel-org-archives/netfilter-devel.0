From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [PATCH] uncast some ip_conntrack_get callsites
Date: Thu, 28 Dec 2006 18:22:43 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0612281820590.23545@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
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


ip_conntrack_get already takes a const struct sk_buff *, so no need to 
cast the const away.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

Index: linux-2.6.20-rc2/net/netfilter/xt_conntrack.c
===================================================================
--- linux-2.6.20-rc2.orig/net/netfilter/xt_conntrack.c
+++ linux-2.6.20-rc2/net/netfilter/xt_conntrack.c
@@ -44,7 +44,7 @@ match(const struct sk_buff *skb,
 	enum ip_conntrack_info ctinfo;
 	unsigned int statebit;
 
-	ct = ip_conntrack_get((struct sk_buff *)skb, &ctinfo);
+	ct = ip_conntrack_get(skb, &ctinfo);
 
 #define FWINV(bool, invflg) ((bool) ^ !!(sinfo->invflags & invflg))
 
Index: linux-2.6.20-rc2/net/netfilter/xt_helper.c
===================================================================
--- linux-2.6.20-rc2.orig/net/netfilter/xt_helper.c
+++ linux-2.6.20-rc2/net/netfilter/xt_helper.c
@@ -54,7 +54,7 @@ match(const struct sk_buff *skb,
 	enum ip_conntrack_info ctinfo;
 	int ret = info->invert;
 	
-	ct = ip_conntrack_get((struct sk_buff *)skb, &ctinfo);
+	ct = ip_conntrack_get(skb, &ctinfo);
 	if (!ct) {
 		DEBUGP("xt_helper: Eek! invalid conntrack?\n");
 		return ret;
#<EOF>

	-`J'
-- 
