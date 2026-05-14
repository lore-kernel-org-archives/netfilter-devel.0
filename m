Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C8F325727
	for <netfilter-devel@vger.kernel.org>; Thu, 14 May 2026 14:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778769024; cv=none; b=YoeuS6Y8tI02lN/3lz8nccYIQwskmPtx1L2XBOgWwJCi4mXJvoneNrdQxpTFafahlCJ0+QVN22R6VzUAB6X9SxjGNSo2/WY3NaxJP8yOgN6RlFDApcOHKQI7mJ/GtKln+huM+MjvuAy0O/zDEQDmHPkRMiU4GJpCbptclo9078c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778769024; c=relaxed/simple;
	bh=RNPJglXxCvuJ4rUN/rSuWaRs4C1Qd4qYj+WcTIXSh0g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JwZffGKdz5PqeHR4nkWqpj28JBkmBxzuavsea9kKnGO9bDMZxio1NYRhncjmfenc75fBSo6LlTrIXt0mOO1cUXAygHzN845zYwF+PzWcY6hzTUCrnSVXSB4hhyna2u0TGMebIyvvzEs3nlaj/GIb2E55URelsQHOk5apYKWeC/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XpmgtO2e; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XpmgtO2e"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 805D9601EE;
	Thu, 14 May 2026 16:30:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1778769019;
	bh=0cwxDEvUuml81Nbf7CoZ9LoTgu9a5qobc3xKDs5AO1E=;
	h=From:To:Cc:Subject:Date:From;
	b=XpmgtO2eMTcWs7O6dLZOeebsHFbYxXvolm4fBc1WUUhp98DBvt75OknkfoPTnfGqv
	 o9F26PCuQMICMlkvpMX/7Il7I65g9NvwnRHMDYrCb7GVwxr2NsUAO+jOZ8tXQzjHcN
	 tkp1KPli62aEe3Q1gXpJ/Ruq4Ypu4EqIM2WMe9VMC8SJ5DK/ePDWXdu/DVqHENGQnZ
	 YpDBnzNtIryIqNtRUuIIECUH5KU/pIPuJOAeIeaboAmHBglt2GNKaBtms2xSF1I+Ta
	 SB3hznlAuLO1Rh4lLWgJQbeDdjQtRYuJ9JxR5gCVaSuaz3MdLqeAzqsmAjdRq3/+h6
	 Qf4KN9j0kckiw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf,v2] netfilter: conntrack: add dead flag to helpers
Date: Thu, 14 May 2026 16:30:16 +0200
Message-ID: <20260514143016.874811-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new NF_CT_HELPER_F_DEAD helper flag to notify the packet path that
this helper is going away. Thus, helpers are effectively disabled and no
new expectations are created while removing the expectations created by
this helper as well as unhelping the existing conntrack entries.

Add the check for NF_CT_HELPER_F_DEAD in the packet path to:
- Conntrack confirmation path which invokes the helper callback.
- Propagation of helper to conntrack via expectation.
- OVS ct helper invocation.

Fixes: 12f7a505331e ("netfilter: add user-space connection tracking helper infrastructure")
Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: use READ_ONCE() and WRITE_ONCE() to modify helper flags are AI reporter suggests.

 include/net/netfilter/nf_conntrack_helper.h | 8 ++++++++
 net/netfilter/nf_conntrack_core.c           | 2 +-
 net/netfilter/nf_conntrack_helper.c         | 5 ++++-
 net/netfilter/nf_conntrack_ovs.c            | 3 +++
 net/netfilter/nf_conntrack_proto.c          | 2 +-
 5 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index de2f956abf34..b6ff7dc65c97 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -25,6 +25,7 @@ struct module;
 enum nf_ct_helper_flags {
 	NF_CT_HELPER_F_USERSPACE	= (1 << 0),
 	NF_CT_HELPER_F_CONFIGURED	= (1 << 1),
+	NF_CT_HELPER_F_DEAD		= (1 << 2),
 };
 
 #define NF_CT_HELPER_NAME_LEN	16
@@ -63,6 +64,13 @@ struct nf_conntrack_helper {
 	char nat_mod_name[NF_CT_HELPER_NAME_LEN];
 };
 
+static inline bool nf_ct_helper_alive(const struct nf_conntrack_helper *helper)
+{
+	unsigned int helper_flags = READ_ONCE(helper->flags);
+
+	return likely(!(helper_flags & NF_CT_HELPER_F_DEAD));
+}
+
 /* Must be kept in sync with the classes defined by helpers */
 #define NF_CT_MAX_EXPECT_CLASSES	4
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 8ba5b22a1eef..d54da6babcfe 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1818,7 +1818,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 			/* exp->master safe, refcnt bumped in nf_ct_find_expectation */
 			ct->master = exp->master;
 			assign_helper = rcu_dereference(exp->assign_helper);
-			if (assign_helper) {
+			if (assign_helper && nf_ct_helper_alive(assign_helper)) {
 				help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
 				if (help)
 					rcu_assign_pointer(help->helper, assign_helper);
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index b594cd244fe1..9f4ba1b0b5ab 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -415,8 +415,11 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 	nf_ct_helper_count--;
 	mutex_unlock(&nf_ct_helper_mutex);
 
+	WRITE_ONCE(me->flags, me->flags | NF_CT_HELPER_F_DEAD);
+
 	/* Make sure every nothing is still using the helper unless its a
-	 * connection in the hash.
+	 * connection in the hash, no more expectations are created after
+	 * this rcu grace period.
 	 */
 	synchronize_rcu();
 
diff --git a/net/netfilter/nf_conntrack_ovs.c b/net/netfilter/nf_conntrack_ovs.c
index a6988eeb1579..eeeb85c18a84 100644
--- a/net/netfilter/nf_conntrack_ovs.c
+++ b/net/netfilter/nf_conntrack_ovs.c
@@ -28,6 +28,9 @@ int nf_ct_helper(struct sk_buff *skb, struct nf_conn *ct,
 	if (!helper)
 		return NF_ACCEPT;
 
+	if (!nf_ct_helper_alive(helper))
+		return NF_ACCEPT;
+
 	if (helper->tuple.src.l3num != NFPROTO_UNSPEC &&
 	    helper->tuple.src.l3num != proto)
 		return NF_ACCEPT;
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 50ddd3d613e1..b2ac5bd491cb 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -174,7 +174,7 @@ unsigned int nf_confirm(void *priv,
 
 		/* rcu_read_lock()ed by nf_hook */
 		helper = rcu_dereference(help->helper);
-		if (helper) {
+		if (helper && nf_ct_helper_alive(helper)) {
 			ret = helper->help(skb,
 					   protoff,
 					   ct, ctinfo);
-- 
2.47.3

