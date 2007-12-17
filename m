From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 44/64]: nf_nat: pass manip type instead of hook to nf_nat_setup_info
Date: Tue, 18 Dec 2007 00:47:13 +0100 (MET)
Message-ID: <20071217234712.23601.50797.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39017 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700AbXLQXrO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:47:14 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_nat: pass manip type instead of hook to nf_nat_setup_info

nf_nat_setup_info gets the hook number and translates that to the
manip type to perform. This is a relict from the time when one
manip per hook could exist, the exact hook number doesn't matter
anymore, its converted to the manip type. Most callers already
know what kind of NAT they want to perform, so pass the maniptype
in directly.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 977f2f4eedc00948e79a6e1cbb385b3a946228cc
tree 2a4008b57ec8c8f01339ff5a5636243c94a4a038
parent 2c4956d3c5e45fca0caa5f7c431d1c45d27ece49
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:33 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:58 +0100

 include/net/netfilter/nf_nat.h       |    2 +-
 net/ipv4/netfilter/ipt_MASQUERADE.c  |    2 +-
 net/ipv4/netfilter/ipt_NETMAP.c      |    2 +-
 net/ipv4/netfilter/ipt_REDIRECT.c    |    2 +-
 net/ipv4/netfilter/nf_nat_core.c     |    9 +++------
 net/ipv4/netfilter/nf_nat_h323.c     |   16 ++++------------
 net/ipv4/netfilter/nf_nat_helper.c   |    6 ++----
 net/ipv4/netfilter/nf_nat_pptp.c     |    6 ++----
 net/ipv4/netfilter/nf_nat_rule.c     |    8 ++++----
 net/ipv4/netfilter/nf_nat_sip.c      |    6 ++----
 net/netfilter/nf_conntrack_netlink.c |   10 ++++------
 11 files changed, 25 insertions(+), 44 deletions(-)

diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index 76da322..9dc1039 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -80,7 +80,7 @@ struct nf_conn_nat
 /* Set up the info structure to map into this range. */
 extern unsigned int nf_nat_setup_info(struct nf_conn *ct,
 				      const struct nf_nat_range *range,
-				      unsigned int hooknum);
+				      enum nf_nat_manip_type maniptype);
 
 /* Is this tuple already taken? (not by us)*/
 extern int nf_nat_used_tuple(const struct nf_conntrack_tuple *tuple,
diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
index f541503..1cbff7b 100644
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -95,7 +95,7 @@ masquerade_tg(struct sk_buff *skb, const struct net_device *in,
 		  mr->range[0].min, mr->range[0].max });
 
 	/* Hand modified range to generic setup. */
-	return nf_nat_setup_info(ct, &newrange, hooknum);
+	return nf_nat_setup_info(ct, &newrange, IP_NAT_MANIP_SRC);
 }
 
 static int
diff --git a/net/ipv4/netfilter/ipt_NETMAP.c b/net/ipv4/netfilter/ipt_NETMAP.c
index 8b8263e..5b71ef4 100644
--- a/net/ipv4/netfilter/ipt_NETMAP.c
+++ b/net/ipv4/netfilter/ipt_NETMAP.c
@@ -70,7 +70,7 @@ netmap_tg(struct sk_buff *skb, const struct net_device *in,
 		  mr->range[0].min, mr->range[0].max });
 
 	/* Hand modified range to generic setup. */
-	return nf_nat_setup_info(ct, &newrange, hooknum);
+	return nf_nat_setup_info(ct, &newrange, HOOK2MANIP(hooknum));
 }
 
 static struct xt_target netmap_tg_reg __read_mostly = {
diff --git a/net/ipv4/netfilter/ipt_REDIRECT.c b/net/ipv4/netfilter/ipt_REDIRECT.c
index 74ce7e1..3d9ec5c 100644
--- a/net/ipv4/netfilter/ipt_REDIRECT.c
+++ b/net/ipv4/netfilter/ipt_REDIRECT.c
@@ -87,7 +87,7 @@ redirect_tg(struct sk_buff *skb, const struct net_device *in,
 		  mr->range[0].min, mr->range[0].max });
 
 	/* Hand modified range to generic setup. */
-	return nf_nat_setup_info(ct, &newrange, hooknum);
+	return nf_nat_setup_info(ct, &newrange, IP_NAT_MANIP_DST);
 }
 
 static struct xt_target redirect_tg_reg __read_mostly = {
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 7cc179c..aec157d 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -277,12 +277,11 @@ out:
 unsigned int
 nf_nat_setup_info(struct nf_conn *ct,
 		  const struct nf_nat_range *range,
-		  unsigned int hooknum)
+		  enum nf_nat_manip_type maniptype)
 {
 	struct nf_conntrack_tuple curr_tuple, new_tuple;
 	struct nf_conn_nat *nat;
 	int have_to_hash = !(ct->status & IPS_NAT_DONE_MASK);
-	enum nf_nat_manip_type maniptype = HOOK2MANIP(hooknum);
 
 	/* nat helper or nfctnetlink also setup binding */
 	nat = nfct_nat(ct);
@@ -294,10 +293,8 @@ nf_nat_setup_info(struct nf_conn *ct,
 		}
 	}
 
-	NF_CT_ASSERT(hooknum == NF_INET_PRE_ROUTING ||
-		     hooknum == NF_INET_POST_ROUTING ||
-		     hooknum == NF_INET_LOCAL_IN ||
-		     hooknum == NF_INET_LOCAL_OUT);
+	NF_CT_ASSERT(maniptype == IP_NAT_MANIP_SRC ||
+		     maniptype == IP_NAT_MANIP_DST);
 	BUG_ON(nf_nat_initialized(ct, maniptype));
 
 	/* What we've got will look like inverse of reply. Normally
diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index 0f226df..2e4bdee 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -389,18 +389,14 @@ static void ip_nat_q931_expect(struct nf_conn *new,
 	/* Change src to where master sends to */
 	range.flags = IP_NAT_RANGE_MAP_IPS;
 	range.min_ip = range.max_ip = new->tuplehash[!this->dir].tuple.src.u3.ip;
-
-	/* hook doesn't matter, but it has to do source manip */
-	nf_nat_setup_info(new, &range, NF_INET_POST_ROUTING);
+	nf_nat_setup_info(new, &range, IP_NAT_MANIP_SRC);
 
 	/* For DST manip, map port here to where it's expected. */
 	range.flags = (IP_NAT_RANGE_MAP_IPS | IP_NAT_RANGE_PROTO_SPECIFIED);
 	range.min = range.max = this->saved_proto;
 	range.min_ip = range.max_ip =
 	    new->master->tuplehash[!this->dir].tuple.src.u3.ip;
-
-	/* hook doesn't matter, but it has to do destination manip */
-	nf_nat_setup_info(new, &range, NF_INET_PRE_ROUTING);
+	nf_nat_setup_info(new, &range, IP_NAT_MANIP_DST);
 }
 
 /****************************************************************************/
@@ -479,17 +475,13 @@ static void ip_nat_callforwarding_expect(struct nf_conn *new,
 	/* Change src to where master sends to */
 	range.flags = IP_NAT_RANGE_MAP_IPS;
 	range.min_ip = range.max_ip = new->tuplehash[!this->dir].tuple.src.u3.ip;
-
-	/* hook doesn't matter, but it has to do source manip */
-	nf_nat_setup_info(new, &range, NF_INET_POST_ROUTING);
+	nf_nat_setup_info(new, &range, IP_NAT_MANIP_SRC);
 
 	/* For DST manip, map port here to where it's expected. */
 	range.flags = (IP_NAT_RANGE_MAP_IPS | IP_NAT_RANGE_PROTO_SPECIFIED);
 	range.min = range.max = this->saved_proto;
 	range.min_ip = range.max_ip = this->saved_ip;
-
-	/* hook doesn't matter, but it has to do destination manip */
-	nf_nat_setup_info(new, &range, NF_INET_PRE_ROUTING);
+	nf_nat_setup_info(new, &range, IP_NAT_MANIP_DST);
 }
 
 /****************************************************************************/
diff --git a/net/ipv4/netfilter/nf_nat_helper.c b/net/ipv4/netfilter/nf_nat_helper.c
index d24f3d9..4c02328 100644
--- a/net/ipv4/netfilter/nf_nat_helper.c
+++ b/net/ipv4/netfilter/nf_nat_helper.c
@@ -433,15 +433,13 @@ void nf_nat_follow_master(struct nf_conn *ct,
 	range.flags = IP_NAT_RANGE_MAP_IPS;
 	range.min_ip = range.max_ip
 		= ct->master->tuplehash[!exp->dir].tuple.dst.u3.ip;
-	/* hook doesn't matter, but it has to do source manip */
-	nf_nat_setup_info(ct, &range, NF_INET_POST_ROUTING);
+	nf_nat_setup_info(ct, &range, IP_NAT_MANIP_SRC);
 
 	/* For DST manip, map port here to where it's expected. */
 	range.flags = (IP_NAT_RANGE_MAP_IPS | IP_NAT_RANGE_PROTO_SPECIFIED);
 	range.min = range.max = exp->saved_proto;
 	range.min_ip = range.max_ip
 		= ct->master->tuplehash[!exp->dir].tuple.src.u3.ip;
-	/* hook doesn't matter, but it has to do destination manip */
-	nf_nat_setup_info(ct, &range, NF_INET_PRE_ROUTING);
+	nf_nat_setup_info(ct, &range, IP_NAT_MANIP_DST);
 }
 EXPORT_SYMBOL(nf_nat_follow_master);
diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
index c540999..e63b944 100644
--- a/net/ipv4/netfilter/nf_nat_pptp.c
+++ b/net/ipv4/netfilter/nf_nat_pptp.c
@@ -93,8 +93,7 @@ static void pptp_nat_expected(struct nf_conn *ct,
 		range.flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
 		range.min = range.max = exp->saved_proto;
 	}
-	/* hook doesn't matter, but it has to do source manip */
-	nf_nat_setup_info(ct, &range, NF_INET_POST_ROUTING);
+	nf_nat_setup_info(ct, &range, IP_NAT_MANIP_SRC);
 
 	/* For DST manip, map port here to where it's expected. */
 	range.flags = IP_NAT_RANGE_MAP_IPS;
@@ -104,8 +103,7 @@ static void pptp_nat_expected(struct nf_conn *ct,
 		range.flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
 		range.min = range.max = exp->saved_proto;
 	}
-	/* hook doesn't matter, but it has to do destination manip */
-	nf_nat_setup_info(ct, &range, NF_INET_PRE_ROUTING);
+	nf_nat_setup_info(ct, &range, IP_NAT_MANIP_DST);
 }
 
 /* outbound packets == from PNS to PAC */
diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
index ee39ed8..4391aec 100644
--- a/net/ipv4/netfilter/nf_nat_rule.c
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -87,7 +87,7 @@ static unsigned int ipt_snat_target(struct sk_buff *skb,
 			    ctinfo == IP_CT_RELATED + IP_CT_IS_REPLY));
 	NF_CT_ASSERT(out);
 
-	return nf_nat_setup_info(ct, &mr->range[0], hooknum);
+	return nf_nat_setup_info(ct, &mr->range[0], IP_NAT_MANIP_SRC);
 }
 
 /* Before 2.6.11 we did implicit source NAT if required. Warn about change. */
@@ -133,7 +133,7 @@ static unsigned int ipt_dnat_target(struct sk_buff *skb,
 		warn_if_extra_mangle(ip_hdr(skb)->daddr,
 				     mr->range[0].min_ip);
 
-	return nf_nat_setup_info(ct, &mr->range[0], hooknum);
+	return nf_nat_setup_info(ct, &mr->range[0], IP_NAT_MANIP_DST);
 }
 
 static bool ipt_snat_checkentry(const char *tablename,
@@ -184,7 +184,7 @@ alloc_null_binding(struct nf_conn *ct, unsigned int hooknum)
 
 	pr_debug("Allocating NULL binding for %p (%u.%u.%u.%u)\n",
 		 ct, NIPQUAD(ip));
-	return nf_nat_setup_info(ct, &range, hooknum);
+	return nf_nat_setup_info(ct, &range, HOOK2MANIP(hooknum));
 }
 
 unsigned int
@@ -203,7 +203,7 @@ alloc_null_binding_confirmed(struct nf_conn *ct, unsigned int hooknum)
 
 	pr_debug("Allocating NULL binding for confirmed %p (%u.%u.%u.%u)\n",
 		 ct, NIPQUAD(ip));
-	return nf_nat_setup_info(ct, &range, hooknum);
+	return nf_nat_setup_info(ct, &range, HOOK2MANIP(hooknum));
 }
 
 int nf_nat_rule_find(struct sk_buff *skb,
diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c
index 6ebf509..443310c 100644
--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -228,15 +228,13 @@ static void ip_nat_sdp_expect(struct nf_conn *ct,
 	range.flags = IP_NAT_RANGE_MAP_IPS;
 	range.min_ip = range.max_ip
 		= ct->master->tuplehash[!exp->dir].tuple.dst.u3.ip;
-	/* hook doesn't matter, but it has to do source manip */
-	nf_nat_setup_info(ct, &range, NF_INET_POST_ROUTING);
+	nf_nat_setup_info(ct, &range, IP_NAT_MANIP_SRC);
 
 	/* For DST manip, map port here to where it's expected. */
 	range.flags = (IP_NAT_RANGE_MAP_IPS | IP_NAT_RANGE_PROTO_SPECIFIED);
 	range.min = range.max = exp->saved_proto;
 	range.min_ip = range.max_ip = exp->saved_ip;
-	/* hook doesn't matter, but it has to do destination manip */
-	nf_nat_setup_info(ct, &range, NF_INET_PRE_ROUTING);
+	nf_nat_setup_info(ct, &range, IP_NAT_MANIP_DST);
 }
 
 /* So, this packet has hit the connection tracking matching code.
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 7851065..3a065f4 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -918,19 +918,17 @@ ctnetlink_change_status(struct nf_conn *ct, struct nlattr *cda[])
 			if (nfnetlink_parse_nat(cda[CTA_NAT_DST], ct,
 						&range) < 0)
 				return -EINVAL;
-			if (nf_nat_initialized(ct,
-					       HOOK2MANIP(NF_INET_PRE_ROUTING)))
+			if (nf_nat_initialized(ct, IP_NAT_MANIP_DST))
 				return -EEXIST;
-			nf_nat_setup_info(ct, &range, NF_INET_PRE_ROUTING);
+			nf_nat_setup_info(ct, &range, IP_NAT_MANIP_DST);
 		}
 		if (cda[CTA_NAT_SRC]) {
 			if (nfnetlink_parse_nat(cda[CTA_NAT_SRC], ct,
 						&range) < 0)
 				return -EINVAL;
-			if (nf_nat_initialized(ct,
-					       HOOK2MANIP(NF_INET_POST_ROUTING)))
+			if (nf_nat_initialized(ct, IP_NAT_MANIP_SRC))
 				return -EEXIST;
-			nf_nat_setup_info(ct, &range, NF_INET_POST_ROUTING);
+			nf_nat_setup_info(ct, &range, IP_NAT_MANIP_SRC);
 		}
 #endif
 	}
