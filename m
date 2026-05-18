Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6D038F938
	for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2026 19:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779131559; cv=none; b=TiRFuIklBvjDwjPqYn9MtM+ZLPdwOKmLjoKDQL634mcdIxOG+iIQqxTECwMvFWdL3q1EsXpB4/td8VRk3czaEoa121Eaeh4yOF8ywrSLj8+rPTBUKMBDhCJ7WHh3HsYaqgZIyeKUzXReniB8YgtkA2xho+LoQ4gqdmdnZQ30KbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779131559; c=relaxed/simple;
	bh=Fl9JbjgTJVj48WEUkK6dpKVONuhSbWeoAf3olT2H1ok=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uPMzJB21Mq6tpk3rV/ivZZxxMM7ALneRWaWg6rp/fIm15c6J9Q6gSQhlZ0JA0/YOhxNGfffGJG9ptMjGo9o3pmMNolGVDyzxor44BooehHmsenIiB27j+Nz2WBPwW8gq53ZJ7KAZq26EWej0vRRIu1cSR46x/YJCPDBRCH2COQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=h72vQ3Bj; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="h72vQ3Bj"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AF3C960502;
	Mon, 18 May 2026 21:12:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1779131555;
	bh=C7/9aH5n3qjg4SUkmSmv4WTCKPxXkXvX9KTMvjoPpAs=;
	h=From:To:Cc:Subject:Date:From;
	b=h72vQ3BjbyQ2Lxu2YGnD+FZIvT9glOHyUHTsZyBIKoDBbVGAR6s7sUcnTTtqcBt6D
	 J7B2jF7tBC06fADKxzU5zRmETTKtphR9sYX9Yk3AJQk1cIQOJOYRw5I4Gee/SLtKzL
	 D6cxC9W5L6RYG8A2mvVSmXCXz0qJ+Q7mn+O/sH6IHZKIFg326ReGXfnZMMbVKc5mR5
	 MdN2BMudfS/OPHG6QdbWh6eF+Tylx0CdPk+j3DlZv7WkwxHJhYYIYpfvvwsRkkZgge
	 UeVyLcwVAq3Iqg3K01pduPipvjr68vK25jcA2Rv3KSpoBBMwfBAWLcTHglFFrgfWja
	 4M6+07u5h3EMQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf,v4 1/3] netfilter: nfnetlink_cthelper: use {READ,WRITE}_ONCE for accessing helper flags
Date: Mon, 18 May 2026 21:12:30 +0200
Message-ID: <20260518191232.1053294-1-pablo@netfilter.org>
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
v4: no changes.

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

