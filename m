Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6B73D88EC
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 21:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779226714; cv=none; b=Dj1as65ifplzByz0I1GO4OgBBr9qqaIf9dicUiAl1BfAG0k711gdp717e+MYdNUmfaKm+bKJrBRtGS//adwEiVM/TV3FymTiHMZgtyQXFe10HHARv8xbk12canRiFsLo2DDqOcvnwn22hwcfPN3mQjtUdPXYwfusR28dt8nWwKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779226714; c=relaxed/simple;
	bh=9x5vTZFJC2eyBsbBcuaZZBbMNmkSibRDqMK4b/juEkQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKtk1acHrZqBvuMXhZvStUv5/Cn4OwgqTdUehfREtADiquhOCVfoD10UrB2c669d763CLPBMReWQWwvu77tfOycm/iLhIBSXYe5nyux2AS/V2jsBKlUmUY3mA2yqa2SbFIybKoRAzckzp/dFTrpF1XKsbRRtdpvUBXrHtzibNjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=oVppfG6A; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="oVppfG6A"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4DD866028D
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 23:38:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1779226711;
	bh=uy0oOpdlqcnDGHsPH49kwE8iVldgcnNCNIYlbuR4E7k=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=oVppfG6AwQoBSrO3bhriLwcPZNurPTNJwzQvUZEy8qRc2aiZiUSzzV1+YUh+BUNLu
	 XEII/ddXCDJaiJknLYbmHX77h7xhSj4lCo7rFOTePunvmeOV5V+8SJWXvzardJP7Q8
	 lvGIwLQlbpxw/JquWTKOJxrQ84BNJmV2ua+VznIczUpH4i60MoLbSrmHuqo4gp07kk
	 C8AIZtBbyauRhqqGAbhklG1bIrvTSFLBNk2ph813lSEKKEMSM7Cc50Nwy1eOPYfuuP
	 H3byg6wFGzfTFEg7Px+3e+rNEZ8lMCbuj50xpGjFPWuGkFjVEgkeIB2RuSMPvnzRFX
	 HB4WvBGNR919g==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf 2/7] netfilter: conntrack: add dead flag to helpers
Date: Tue, 19 May 2026 23:38:21 +0200
Message-ID: <20260519213826.1181661-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260519213826.1181661-1-pablo@netfilter.org>
References: <20260519213826.1181661-1-pablo@netfilter.org>
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
- ctnetlink expectation creation path.
- OVS ct helper invocations.

nf_conntrack_helper_unregister() is only called under nfnl_mutex when
unregistering the helper, else by helper module which already owns this
helper from the module removal path. Therefore, concurrent update of
helper flags via nfnetlink_cthelper is not possible, but packet path and
netlink dump path can read these flags locklessly.

The kernel helpers never use flags, so concurrent update on these flags
can only happen in userspace helper via nfnetlink interface, where the
nfnl_mutex is held.

This patch also requires:

  c56716c69ce1 ("netfilter: extensions: introduce extension genid count")

which adds an extension genid for unconfirmed conntrack entries. This
allows to invalidate the conntrack helper extension in case a packet
holding a reference on the unconfirmed conntrack sits in nfqueue, or
elsewhere, and the helper goes away. This ensures that the access to the
helper area is disabled so the dandling pointer to the helper that went
away is not reachable anymore.

Fixes: 12f7a505331e ("netfilter: add user-space connection tracking helper infrastructure")
Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_helper.h | 8 ++++++++
 net/netfilter/nf_conntrack_core.c           | 2 +-
 net/netfilter/nf_conntrack_helper.c         | 5 ++++-
 net/netfilter/nf_conntrack_netlink.c        | 2 +-
 net/netfilter/nf_conntrack_ovs.c            | 2 +-
 net/netfilter/nf_conntrack_proto.c          | 2 +-
 6 files changed, 16 insertions(+), 5 deletions(-)

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
index 2938df5a6a18..1c04ef9dd17c 100644
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
index 17e971bd4c74..9a10b3449957 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -418,8 +418,11 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
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
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index befa7e83ee49..41926844d1be 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3546,7 +3546,7 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 		return ERR_PTR(-EOPNOTSUPP);
 
 	helper = rcu_dereference(help->helper);
-	if (!helper)
+	if (!helper || !nf_ct_helper_alive(helper))
 		return ERR_PTR(-EOPNOTSUPP);
 
 	if (cda[CTA_EXPECT_CLASS]) {
diff --git a/net/netfilter/nf_conntrack_ovs.c b/net/netfilter/nf_conntrack_ovs.c
index a6988eeb1579..fc4de20b5ccf 100644
--- a/net/netfilter/nf_conntrack_ovs.c
+++ b/net/netfilter/nf_conntrack_ovs.c
@@ -25,7 +25,7 @@ int nf_ct_helper(struct sk_buff *skb, struct nf_conn *ct,
 		return NF_ACCEPT;
 
 	helper = rcu_dereference(help->helper);
-	if (!helper)
+	if (!helper || !nf_ct_helper_alive(helper))
 		return NF_ACCEPT;
 
 	if (helper->tuple.src.l3num != NFPROTO_UNSPEC &&
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

