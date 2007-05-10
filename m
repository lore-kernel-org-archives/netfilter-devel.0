From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/09]: nf_nat: remove unused argument of function
	allocating binding
Date: Thu, 10 May 2007 15:41:12 +0200 (MEST)
Message-ID: <20070510134030.8559.58054.sendpatchset@localhost.localdomain>
References: <20070510134027.8559.40540.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070510134027.8559.40540.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_nat: remove unused argument of function allocating binding

nf_nat_rule_find, alloc_null_binding and alloc_null_binding_confirmed
do not use the argument 'info', which is actually ct->nat.info.
If they are necessary to access it again, we can use the argument 'ct'
instead.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f1103257fddbe3a55b4ae964741cefb5026c20ec
tree 32d30851ebdb14a2dfc5b7b10267b9700cf010d5
parent acf2e14c5f3ff9b9ad1500c135a8d9be98d66436
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Tue, 08 May 2007 11:06:17 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 08 May 2007 11:06:17 +0200

 include/net/netfilter/nf_nat_rule.h    |   11 +++--------
 net/ipv4/netfilter/nf_nat_rule.c       |   13 ++++---------
 net/ipv4/netfilter/nf_nat_standalone.c |   11 +++--------
 3 files changed, 10 insertions(+), 25 deletions(-)

diff --git a/include/net/netfilter/nf_nat_rule.h b/include/net/netfilter/nf_nat_rule.h
index e765654..f974318 100644
--- a/include/net/netfilter/nf_nat_rule.h
+++ b/include/net/netfilter/nf_nat_rule.h
@@ -10,16 +10,11 @@ extern int nf_nat_rule_find(struct sk_buff **pskb,
 			    unsigned int hooknum,
 			    const struct net_device *in,
 			    const struct net_device *out,
-			    struct nf_conn *ct,
-			    struct nf_nat_info *info);
+			    struct nf_conn *ct);
 
 extern unsigned int
-alloc_null_binding(struct nf_conn *ct,
-		   struct nf_nat_info *info,
-		   unsigned int hooknum);
+alloc_null_binding(struct nf_conn *ct, unsigned int hooknum);
 
 extern unsigned int
-alloc_null_binding_confirmed(struct nf_conn *ct,
-			     struct nf_nat_info *info,
-			     unsigned int hooknum);
+alloc_null_binding_confirmed(struct nf_conn *ct, unsigned int hooknum);
 #endif /* _NF_NAT_RULE_H */
diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
index 07e99e3..6740736 100644
--- a/net/ipv4/netfilter/nf_nat_rule.c
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -173,9 +173,7 @@ static int ipt_dnat_checkentry(const char *tablename,
 }
 
 inline unsigned int
-alloc_null_binding(struct nf_conn *ct,
-		   struct nf_nat_info *info,
-		   unsigned int hooknum)
+alloc_null_binding(struct nf_conn *ct, unsigned int hooknum)
 {
 	/* Force range to this IP; let proto decide mapping for
 	   per-proto parts (hence not IP_NAT_RANGE_PROTO_SPECIFIED).
@@ -194,9 +192,7 @@ alloc_null_binding(struct nf_conn *ct,
 }
 
 unsigned int
-alloc_null_binding_confirmed(struct nf_conn *ct,
-			     struct nf_nat_info *info,
-			     unsigned int hooknum)
+alloc_null_binding_confirmed(struct nf_conn *ct, unsigned int hooknum)
 {
 	__be32 ip
 		= (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC
@@ -218,8 +214,7 @@ int nf_nat_rule_find(struct sk_buff **pskb,
 		     unsigned int hooknum,
 		     const struct net_device *in,
 		     const struct net_device *out,
-		     struct nf_conn *ct,
-		     struct nf_nat_info *info)
+		     struct nf_conn *ct)
 {
 	int ret;
 
@@ -228,7 +223,7 @@ int nf_nat_rule_find(struct sk_buff **pskb,
 	if (ret == NF_ACCEPT) {
 		if (!nf_nat_initialized(ct, HOOK2MANIP(hooknum)))
 			/* NUL mapping */
-			ret = alloc_null_binding(ct, info, hooknum);
+			ret = alloc_null_binding(ct, hooknum);
 	}
 	return ret;
 }
diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index 64bbed2..55dac36 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -80,7 +80,6 @@ nf_nat_fn(unsigned int hooknum,
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn_nat *nat;
-	struct nf_nat_info *info;
 	/* maniptype == SRC for postrouting. */
 	enum nf_nat_manip_type maniptype = HOOK2MANIP(hooknum);
 
@@ -129,7 +128,6 @@ nf_nat_fn(unsigned int hooknum,
 		}
 		/* Fall thru... (Only ICMPs can be IP_CT_IS_REPLY) */
 	case IP_CT_NEW:
-		info = &nat->info;
 
 		/* Seen it before?  This can happen for loopback, retrans,
 		   or local packets.. */
@@ -138,14 +136,13 @@ nf_nat_fn(unsigned int hooknum,
 
 			if (unlikely(nf_ct_is_confirmed(ct)))
 				/* NAT module was loaded late */
-				ret = alloc_null_binding_confirmed(ct, info,
-								   hooknum);
+				ret = alloc_null_binding_confirmed(ct, hooknum);
 			else if (hooknum == NF_IP_LOCAL_IN)
 				/* LOCAL_IN hook doesn't have a chain!  */
-				ret = alloc_null_binding(ct, info, hooknum);
+				ret = alloc_null_binding(ct, hooknum);
 			else
 				ret = nf_nat_rule_find(pskb, hooknum, in, out,
-						       ct, info);
+						       ct);
 
 			if (ret != NF_ACCEPT) {
 				return ret;
@@ -160,10 +157,8 @@ nf_nat_fn(unsigned int hooknum,
 		/* ESTABLISHED */
 		NF_CT_ASSERT(ctinfo == IP_CT_ESTABLISHED ||
 			     ctinfo == (IP_CT_ESTABLISHED+IP_CT_IS_REPLY));
-		info = &nat->info;
 	}
 
-	NF_CT_ASSERT(info);
 	return nf_nat_packet(ct, ctinfo, hooknum, pskb);
 }
 
