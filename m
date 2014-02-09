From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] netfilter: ctnetlink: force null nat binding on insert
Date: Sun,  9 Feb 2014 21:35:09 +0100
Message-ID: <1391978109-26507-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:53799 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751688AbaBIUi5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Feb 2014 15:38:57 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Quoting Andrey Vagin:
  When a conntrack is created  by kernel, it is initialized (sets
  IPS_{DST,SRC}_NAT_DONE_BIT bits in nf_nat_setup_info) and only then it
  is added in hashes (__nf_conntrack_hash_insert), so one conntract
  can't be initialized from a few threads concurrently.

  ctnetlink can add an uninitialized conntrack (w/o
  IPS_{DST,SRC}_NAT_DONE_BIT) in hashes, then a few threads can look up
  this conntrack and start initialize it concurrently. It's dangerous,
  because BUG can be triggered from nf_nat_setup_info.

Fix this race by always setting up nat, even if no CTA_NAT_ attribute
was requested before inserting the ct into the hash table.

In absence of CTA_NAT_ attribute, a null binding is created.

This alters current behaviour:
Before this patch, the first packet matching the newly injected
conntrack would be run through the nat table since nf_nat_initialized()
returns false.  IOW, this forces ctnetlink users to specify the desired
nat transformation on ct creation time.

Reported-By: Andrey Vagin <avagin@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_netlink.c | 37 ++++++++++++++++--------------------
 net/netfilter/nf_nat_core.c          | 24 +++++++++++++++++------
 2 files changed, 34 insertions(+), 27 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index bb322d0..40299a6 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1310,27 +1310,24 @@ ctnetlink_change_status(struct nf_conn *ct, const struct nlattr * const cda[])
 }
 
 static int
-ctnetlink_change_nat(struct nf_conn *ct, const struct nlattr * const cda[])
+ctnetlink_setup_nat(struct nf_conn *ct, const struct nlattr * const cda[])
 {
 #ifdef CONFIG_NF_NAT_NEEDED
 	int ret;
 
-	if (cda[CTA_NAT_DST]) {
-		ret = ctnetlink_parse_nat_setup(ct,
-						NF_NAT_MANIP_DST,
-						cda[CTA_NAT_DST]);
-		if (ret < 0)
-			return ret;
-	}
-	if (cda[CTA_NAT_SRC]) {
-		ret = ctnetlink_parse_nat_setup(ct,
-						NF_NAT_MANIP_SRC,
-						cda[CTA_NAT_SRC]);
-		if (ret < 0)
-			return ret;
-	}
-	return 0;
+	ret = ctnetlink_parse_nat_setup(ct,
+					NF_NAT_MANIP_DST,
+					cda[CTA_NAT_DST]);
+	if (ret < 0)
+		return ret;
+
+	ret = ctnetlink_parse_nat_setup(ct,
+					NF_NAT_MANIP_SRC,
+					cda[CTA_NAT_SRC]);
+	return ret;
 #else
+	if (!cda[CTA_NAT_DST] && !cda[CTA_NAT_SRC])
+		return 0;
 	return -EOPNOTSUPP;
 #endif
 }
@@ -1659,11 +1656,9 @@ ctnetlink_create_conntrack(struct net *net, u16 zone,
 			goto err2;
 	}
 
-	if (cda[CTA_NAT_SRC] || cda[CTA_NAT_DST]) {
-		err = ctnetlink_change_nat(ct, cda);
-		if (err < 0)
-			goto err2;
-	}
+	err = ctnetlink_setup_nat(ct, cda);
+	if (err < 0)
+		goto err2;
 
 	nf_ct_acct_ext_add(ct, GFP_ATOMIC);
 	nf_ct_tstamp_ext_add(ct, GFP_ATOMIC);
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index d3f5cd6..788b53f 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -432,15 +432,15 @@ nf_nat_setup_info(struct nf_conn *ct,
 }
 EXPORT_SYMBOL(nf_nat_setup_info);
 
-unsigned int
-nf_nat_alloc_null_binding(struct nf_conn *ct, unsigned int hooknum)
+static unsigned int
+__nf_nat_alloc_null_binding(struct nf_conn *ct, enum nf_nat_manip_type manip)
 {
 	/* Force range to this IP; let proto decide mapping for
 	 * per-proto parts (hence not IP_NAT_RANGE_PROTO_SPECIFIED).
 	 * Use reply in case it's already been mangled (eg local packet).
 	 */
 	union nf_inet_addr ip =
-		(HOOK2MANIP(hooknum) == NF_NAT_MANIP_SRC ?
+		(manip == NF_NAT_MANIP_SRC ?
 		ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3 :
 		ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3);
 	struct nf_nat_range range = {
@@ -448,7 +448,13 @@ nf_nat_alloc_null_binding(struct nf_conn *ct, unsigned int hooknum)
 		.min_addr	= ip,
 		.max_addr	= ip,
 	};
-	return nf_nat_setup_info(ct, &range, HOOK2MANIP(hooknum));
+	return nf_nat_setup_info(ct, &range, manip);
+}
+
+unsigned int
+nf_nat_alloc_null_binding(struct nf_conn *ct, unsigned int hooknum)
+{
+	return __nf_nat_alloc_null_binding(ct, HOOK2MANIP(hooknum));
 }
 EXPORT_SYMBOL_GPL(nf_nat_alloc_null_binding);
 
@@ -741,11 +747,17 @@ nfnetlink_parse_nat_setup(struct nf_conn *ct,
 	struct nf_nat_range range;
 	int err;
 
+	/* should not happen, restricted to creating new conntracks
+	 * via ctnetlink */
+	if (WARN_ON_ONCE(nf_nat_initialized(ct, manip)))
+		return -EEXIST;
+
+	if (attr == NULL)
+		return __nf_nat_alloc_null_binding(ct, manip);
+
 	err = nfnetlink_parse_nat(attr, ct, &range);
 	if (err < 0)
 		return err;
-	if (nf_nat_initialized(ct, manip))
-		return -EEXIST;
 
 	return nf_nat_setup_info(ct, &range, manip);
 }
-- 
1.8.1.5

