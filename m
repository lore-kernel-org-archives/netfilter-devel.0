Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6625E4499BD
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jul 2026 19:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783626387; cv=none; b=U6tnDxJn7pLoSO8o9JS5eUWEDCoHsTKUcMbtaN75yjoH2LGrUemGdOJi2IaNTE7ivQXAFbf+jgHFXfKeHHxyyloFBgsJBcmJVXLZxQaCZ2PsML+iTjK/kRIN6x/unHjMjSqLCcBONCoN4pshmFG6ZeCMvdiuD0bIHY9zcHW0HLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783626387; c=relaxed/simple;
	bh=eUgn+Ix42DAH5mteojrUvSz2cOTlYAeBa2kFy+tvknI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=grlfEqKZp3OiInkr6RN9QBIhBupQb2HYXcLeJXmlJa0HraQl5niPzH1nJLcZElNCG6J2g6B7R3hdovcW1Dsmn6VPwWhm2oW4bcfT/ugXlEJ8nLDRlh1xKyq0mEV+5O52X8cz3W0iA4igzsQKnaZSVlRoMeD5nJMIEBl3dIT5e3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=HyigjiCy; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="HyigjiCy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KmeeT316pEyQzpYpsbTQx1IoLPkQx5uJqSqXVa/B7iM=; b=HyigjiCyJJxuaSF/cJmbAhxs37
	SPzBRMxAheC7sBBP0Me8H2zqjqvwdWBxcaTOpW18PsFaEmlgsLY1/L6/o4uVT31T/6ZnZqlQCcryv
	KitIP1EpiXzoZWLXLGVi8Mu+IX1xEIp7yGw82huPpLK+u4FZGAKebGffRrJEOzxje0Ho7ck0RAKaU
	CwzATou6G7D4uBHTWiWrHMRYFLj6r3ZGaAhALYNBpxt7eXTFjBzi/omCknnd9dC+gfIrD69dZZHsK
	1PwHrsNj93AsYby9+AXCJCOLr/GF4yzo2hhsZQ9GPFTmb0KISjk9mmuKGRY120zwUaHGyS/PCIq/H
	Xtql4wNA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1whuhN-000000002il-1AQv;
	Thu, 09 Jul 2026 21:46:17 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [nf-next PATCH v2 1/5] netfilter: nfnetlink_hook: Fix for EINTR due to index too large
Date: Thu,  9 Jul 2026 21:46:08 +0200
Message-ID: <20260709194612.1995795-2-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260709194612.1995795-1-phil@nwl.cc>
References: <20260709194612.1995795-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When resuming a multipart dump and e->num_hook_entries has become lower
than the stored index, nfnl_hook_dump_one is not called and therefore
nl_dump_check_consistent will be passed an invalid nlmsghdr pointer.

Detect the situation and put an empty message to carry NLM_F_DUMP_INTR
flag.

This will help fix for concurrent NAT hook changes while dumping as well
since nfnl_hook_dump_nat will also abort before putting a single message
in that case.

The old code did assign NLM_F_DUMP_INTR to garbage in (or beyond) nlskb
with uninterrupted dumps, too: The mandatory last call saw 'i ==
e->num_hook_entries' and therefore incremented cb->seq. This patch makes
this a non-error (and the function will just return 0 without further
action).

Fixes: e2cf17d3774c ("netfilter: add new hook nfnl subsystem")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nfnetlink_hook.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
index 95005e9a6066..755d8f148db3 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -188,13 +188,21 @@ static int nfnl_hook_put_nft_ft_info(struct sk_buff *nlskb,
 	return 0;
 }
 
+static struct nlmsghdr *nfnl_put_get_hook_msg(struct sk_buff *nlskb,
+					      unsigned int seq, int family)
+{
+	u16 event = nfnl_msg_type(NFNL_SUBSYS_HOOK, NFNL_MSG_HOOK_GET);
+	unsigned int portid = NETLINK_CB(nlskb).portid;
+
+	return nfnl_msg_put(nlskb, portid, seq, event,
+			   NLM_F_MULTI, family, NFNETLINK_V0, 0);
+}
+
 static int nfnl_hook_dump_one(struct sk_buff *nlskb,
 			      const struct nfnl_dump_hook_data *ctx,
 			      const struct nf_hook_ops *ops, int priority,
 			      int family, unsigned int seq)
 {
-	u16 event = nfnl_msg_type(NFNL_SUBSYS_HOOK, NFNL_MSG_HOOK_GET);
-	unsigned int portid = NETLINK_CB(nlskb).portid;
 	struct nlmsghdr *nlh;
 	int ret = -EMSGSIZE;
 	u32 hooknum;
@@ -202,8 +210,7 @@ static int nfnl_hook_dump_one(struct sk_buff *nlskb,
 	char sym[KSYM_SYMBOL_LEN];
 	char *module_name;
 #endif
-	nlh = nfnl_msg_put(nlskb, portid, seq, event,
-			   NLM_F_MULTI, family, NFNETLINK_V0, 0);
+	nlh = nfnl_put_get_hook_msg(nlskb, seq, family);
 	if (!nlh)
 		goto nla_put_failure;
 
@@ -366,7 +373,7 @@ static int nfnl_hook_dump(struct sk_buff *nlskb,
 {
 	struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
 	struct nfnl_dump_hook_data *ctx = cb->data;
-	int err, family = nfmsg->nfgen_family;
+	int err = 0, family = nfmsg->nfgen_family;
 	struct net *net = sock_net(nlskb->sk);
 	struct nf_hook_ops * const *ops;
 	const struct nf_hook_entries *e;
@@ -378,14 +385,14 @@ static int nfnl_hook_dump(struct sk_buff *nlskb,
 	if (!e)
 		goto done;
 
-	if (IS_ERR(e)) {
+	if (IS_ERR(e) ||
+	    i > e->num_hook_entries ||
+	    (unsigned long)e != ctx->headv) {
 		cb->seq++;
+		err = -EINTR;
 		goto done;
 	}
 
-	if ((unsigned long)e != ctx->headv || i >= e->num_hook_entries)
-		cb->seq++;
-
 	ops = nf_hook_entries_get_hook_ops(e);
 
 	for (; i < e->num_hook_entries; i++) {
@@ -401,6 +408,8 @@ static int nfnl_hook_dump(struct sk_buff *nlskb,
 	}
 
 done:
+	if (err && !nlskb->len)
+		nfnl_put_get_hook_msg(nlskb, cb->nlh->nlmsg_seq, family);
 	nl_dump_check_consistent(cb, nlmsg_hdr(nlskb));
 	rcu_read_unlock();
 	cb->args[0] = i;
-- 
2.54.0

