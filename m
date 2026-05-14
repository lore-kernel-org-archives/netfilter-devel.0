Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D4333066E
	for <netfilter-devel@vger.kernel.org>; Thu, 14 May 2026 15:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778773107; cv=none; b=lxKKVTL4kgKBgVwpyLLIl3gYWFMfLwqA53yqUgoGqZuQWgssUKQ5HNSJTW1x2bnfOld4uAnkj2UXJZhmnfoHSXt8XHsGtvgVwqbFm/GmcmqE2Fu/NorclRtVfksJURqO3Yhc2C9Eh/4fahAaqgftN/ZsenK9LhXkYSz1WJAO3GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778773107; c=relaxed/simple;
	bh=x0DiPm8lohhDofTS59pe+MvZT40VVDnc4B7Xe3YFsEg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cyAWJYROvCXZ3p2hr0aTCCry8b0SbiWeIYEmWdDBOHHKFEv7Mj/71G6eOKFOfLGK1QtWf/LpuMT8iNvcxDCE+mUuwoDevrsBCwFR6juW0+GFklgofu5XEuxxxUseWFn/ksPUuLW0f4O8FVd53gKoUismEx3bb0os0R95w4txHXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=W798tx3m; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="W798tx3m"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 774A160177;
	Thu, 14 May 2026 17:38:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1778773097;
	bh=fMMeMIHP61dVMfM+NJGv7868ehQhslHwJqI0HVlkebY=;
	h=From:To:Cc:Subject:Date:From;
	b=W798tx3mnhJYAId8GvsBgLLG7FzeuNFnlxPmR7Y6jhmTX+oqwiTly351EF92PTEcg
	 w3tqjI+7unBwTA+TOaQNJqCJDySNdzSxhTUmTCQvr2bR4wEb6aNqkXc1lAqe1CMKiP
	 bZNGlre0ljDp76sK7tfMV7Amaq5ZdIksQACCyup5M4ND87SGxbFkOk/hC4s/mFkYCi
	 LRd/bjCrwmCJU3Tz0ITfE2RwFzWtt60WPs/GHYxbHLu43UUTE7uteM/8WZiZt/EzmD
	 CfA+Gjsj9kcuRLoiPG3reNg3zHGrGHUY5HT99aWHHZisg9SAbsUvQhb0Y5fKgs/g9Z
	 XtvjWXYLGW+iA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf,v3 1/2] netfilter: nfnetlink_cthelper: use {READ,WRITE}_ONCE for accessing helper flags
Date: Thu, 14 May 2026 17:38:13 +0200
Message-ID: <20260514153814.877747-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Conntrack helper flags are accessed from packet and netlink dump path.
While updates are protected by the nfnl_mutex, use {READ,WRITE}_ONCE()
to access this flags.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: new in this series, per Florian comment.

 net/netfilter/nfnetlink_cthelper.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 0d16ad82d70c..34ac6af1e0dd 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -41,8 +41,9 @@ static int
 nfnl_userspace_cthelper(struct sk_buff *skb, unsigned int protoff,
 			struct nf_conn *ct, enum ip_conntrack_info ctinfo)
 {
-	const struct nf_conn_help *help;
 	struct nf_conntrack_helper *helper;
+	const struct nf_conn_help *help;
+	unsigned int helper_flags;
 
 	help = nfct_help(ct);
 	if (help == NULL)
@@ -53,8 +54,10 @@ nfnl_userspace_cthelper(struct sk_buff *skb, unsigned int protoff,
 	if (helper == NULL)
 		return NF_DROP;
 
+	helper_flags = READ_ONCE(helper->flags);
+
 	/* This is a user-space helper not yet configured, skip. */
-	if ((helper->flags &
+	if ((helper_flags &
 	    (NF_CT_HELPER_F_USERSPACE | NF_CT_HELPER_F_CONFIGURED)) ==
 	     NF_CT_HELPER_F_USERSPACE)
 		return NF_ACCEPT;
@@ -404,10 +407,10 @@ nfnl_cthelper_update(const struct nlattr * const tb[],
 
 		switch(status) {
 		case NFCT_HELPER_STATUS_ENABLED:
-			helper->flags |= NF_CT_HELPER_F_CONFIGURED;
+			WRITE_ONCE(helper->flags, helper->flags | NF_CT_HELPER_F_CONFIGURED);
 			break;
 		case NFCT_HELPER_STATUS_DISABLED:
-			helper->flags &= ~NF_CT_HELPER_F_CONFIGURED;
+			WRITE_ONCE(helper->flags, helper->flags & ~NF_CT_HELPER_F_CONFIGURED);
 			break;
 		}
 	}
@@ -529,8 +532,8 @@ static int
 nfnl_cthelper_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 			int event, struct nf_conntrack_helper *helper)
 {
+	unsigned int flags = portid ? NLM_F_MULTI : 0, helper_flags;
 	struct nlmsghdr *nlh;
-	unsigned int flags = portid ? NLM_F_MULTI : 0;
 	int status;
 
 	event = nfnl_msg_type(NFNL_SUBSYS_CTHELPER, event);
@@ -554,7 +557,8 @@ nfnl_cthelper_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	if (nla_put_be32(skb, NFCTH_PRIV_DATA_LEN, htonl(helper->data_len)))
 		goto nla_put_failure;
 
-	if (helper->flags & NF_CT_HELPER_F_CONFIGURED)
+	helper_flags = READ_ONCE(helper->flags);
+	if (helper_flags & NF_CT_HELPER_F_CONFIGURED)
 		status = NFCT_HELPER_STATUS_ENABLED;
 	else
 		status = NFCT_HELPER_STATUS_DISABLED;
@@ -575,6 +579,7 @@ static int
 nfnl_cthelper_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct nf_conntrack_helper *cur, *last;
+	unsigned int helper_flags;
 
 	rcu_read_lock();
 	last = (struct nf_conntrack_helper *)cb->args[1];
@@ -583,8 +588,10 @@ nfnl_cthelper_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 		hlist_for_each_entry_rcu(cur,
 				&nf_ct_helper_hash[cb->args[0]], hnode) {
 
+			helper_flags = READ_ONCE(cur->flags);
+
 			/* skip non-userspace conntrack helpers. */
-			if (!(cur->flags & NF_CT_HELPER_F_USERSPACE))
+			if (!(helper_flags & NF_CT_HELPER_F_USERSPACE))
 				continue;
 
 			if (cb->args[1]) {
-- 
2.47.3

