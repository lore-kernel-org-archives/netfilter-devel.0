Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250641D5170
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 21:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779226713; cv=none; b=kmu9UruE9LM8HSqS9dqN6ZXZaCAHEyc6BFdZLprDJYNeXPIaUpcETp9O3yNkyiefkOlvvSJ0WrpkG94mrlH7SVBwegQBu6lVMnUkU39ZAHH5n/eZgm51in181jH0kTKJE1pNXVGwJTsae27JpzqOs3D1030MjIRt3xMT3NuaA58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779226713; c=relaxed/simple;
	bh=Yg6/Vzgk32eCz0Vx836KeyXu/jIlzGzUrbsrny08YP4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=qaVQYhMiDF4ooGWzPklegPLKJ9AioU/EG3ZcdvO9ZJveDny5D8o3bjw5Ztuo1B6o1tP1Hy4E/bfI0IJpZomdGMS8mEIncpy5HQHhXcBv5u988TVU9Yeu/eZ8prA8whLQkuXBQchQ9WCBzsiiOP1AdGLLZi2GkRyG8cnfUPJ/KqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Dl5qNNef; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Dl5qNNef"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id F299960288
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 23:38:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1779226710;
	bh=Ok0vDe8v3Te73h8kauQDqL0b5YarXr/yBWzD3lXCmes=;
	h=From:To:Subject:Date:From;
	b=Dl5qNNefAKGzbGDaA1vU3psv/NpWU2RDh+AoGuc23+/DiYbsldrtV00aU8wVBoAdg
	 NtbWeT+DWyTzpfJyJz7ggw5NFs8iO5tEq1uGbSLfAjNFM7BVufyPVDd2dIRun4POzd
	 tht8IpR4uyAAkH5rH6izM0TGMaEcD928y3vQcy8LI9QmLldx89m2HaClgkbrXvCNLq
	 Dvmx2Jh4bqfH5zx974oEtebhWL/CX3bni8q/ilgmgztMdAmS8yjxxQMfMYLKN54QyG
	 ElQptnq/LBwA4jsIJ4HUqXR6JD8iFp9r648wQ21N0IrD8h+NxTdWW7+9WQkPz/jPsD
	 IJtEz+R1rvMOQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf 1/7] netfilter: nfnetlink_cthelper: use {READ,WRITE}_ONCE for accessing helper flags
Date: Tue, 19 May 2026 23:38:20 +0200
Message-ID: <20260519213826.1181661-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Conntrack helper flags are accessed from packet and netlink dump path.
Concurrent update of userspace helper flags is not possible, because the
nfnl_mutex in held on updates. These flags are only used by userspace
helpers. Use {READ,WRITE}_ONCE() to access this flags from lockless
paths.

Fixes: 12f7a505331e ("netfilter: add user-space connection tracking helper infrastructure")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c  |  2 +-
 net/netfilter/nfnetlink_cthelper.c | 20 +++++++++++++-------
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 8ba5b22a1eef..2938df5a6a18 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2216,7 +2216,7 @@ static int nf_confirm_cthelper(struct sk_buff *skb, struct nf_conn *ct,
 	if (!helper)
 		return NF_ACCEPT;
 
-	if (!(helper->flags & NF_CT_HELPER_F_USERSPACE))
+	if (!(READ_ONCE(helper->flags) & NF_CT_HELPER_F_USERSPACE))
 		return NF_ACCEPT;
 
 	switch (nf_ct_l3num(ct)) {
diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 0d16ad82d70c..61a2407b53bd 100644
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
-	struct nlmsghdr *nlh;
 	unsigned int flags = portid ? NLM_F_MULTI : 0;
+	struct nlmsghdr *nlh;
 	int status;
 
 	event = nfnl_msg_type(NFNL_SUBSYS_CTHELPER, event);
@@ -554,7 +557,7 @@ nfnl_cthelper_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	if (nla_put_be32(skb, NFCTH_PRIV_DATA_LEN, htonl(helper->data_len)))
 		goto nla_put_failure;
 
-	if (helper->flags & NF_CT_HELPER_F_CONFIGURED)
+	if (READ_ONCE(helper->flags) & NF_CT_HELPER_F_CONFIGURED)
 		status = NFCT_HELPER_STATUS_ENABLED;
 	else
 		status = NFCT_HELPER_STATUS_DISABLED;
@@ -575,6 +578,7 @@ static int
 nfnl_cthelper_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct nf_conntrack_helper *cur, *last;
+	unsigned int helper_flags;
 
 	rcu_read_lock();
 	last = (struct nf_conntrack_helper *)cb->args[1];
@@ -583,8 +587,10 @@ nfnl_cthelper_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
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

