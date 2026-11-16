Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794789465;
	b=UAzYwI0NI3g2LrqRpwrP+mFkVyxwSwRNX59ONujZuluZq5yp2tqI6E5cNghNMn4Ibab1
	 7WkPCMZE9FBYcv3jczhVseFiO8CJnbTeMWQri0F9F+9k2jZ20oBwgz5W4ggHqP8sVpbS7
	 /zjn63vapfQ0jxgx//E4AcuOZgaTt6mKKO2DkvbAW8zc82E3iErEN+OT0XIbEIpN/NWTH
	 QgknAcApjkwtKkyTCP6xCnrR2Yg9XOMqUHudSMj3PKQpaPfoBtXmnxbFPbUEv8J0nFmvb
	 KFgyTd6BMxcRwo6ywzCW5j9zAO5wK/DJ4J0DXOfGhZ//GOognRO1F2QRMt+fwqDEKrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794789465;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=Sm0LbSQ0EhBOyxYFYdHL7FySch0YyP/jISZpLDs2/wE=;
	b=MrbfdDd3Gv0Csuq3UjXl2h2WptbxrAbpskd8swJzHQMF9GLo9nzHLYNgimCDih7fnUN3
	 ZBhjRsGMN5izvjHdLTbTfD4//CDBPR0Q3BZRhlg71BqwePVWWcPMg38wA+QHqzLE2sJM+
	 beOjkQ3UuVKf0A5AHvKQ15lfdfz0/yYAtup0wiMyGInULqygGDyahnrLzgM3Ei997ay6d
	 3odMmUNZ7qvZfZAVOoDgdjpzLVrOpXEksnROL0qK0EtnoLTlZ5oFYZ1FdF7o0liWnEYae
	 gB2dywA2Jkcane0tn8hX0TkZUOjfz2Xzhp5yfqoa8ZbGolED4Eo/LYqqTRLmSpQfkYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=soeu+KXz;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC668606A323
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 00:37:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC668606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=soeu+KXz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794789463;
	bh=Sm0LbSQ0EhBOyxYFYdHL7FySch0YyP/jISZpLDs2/wE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=soeu+KXzfrr1CdjVNoelVAuz3piR2JRpPGXH0eMA/t0dX2n0xXF6pyHfmkPvq7FCy
	 YmOigiKvTbtG7kxQ07p6RTkVcJbveNxqg7dBvYYJIIdYXNuC56sF6yA4T3ZgnMMEg7
	 TPI4FcjDXhyKxY8XdknBjSsM5yehmQcMzfeTT0xAz57cBNqdqizKRnezhb9A18N2xw
	 ZZSl+c47FE4fe1MRmrtIPMgRjYYxEwh7VtGoG2ATcUToNYszmm0YHtzJqJBAIadhtq
	 y3PKGTZd5Ot5hPuUjDcjpTP1lmd2fh4aNqZDWaELINBKF4yDVhBtCeKkQkgGhWgtfY
	 BPVgINetvEfxA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1227060078
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 01:37:43 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v8 5/7] netfilter: nfnetlink_queue: restrict NFQA_EXP to userspace helpers
Date: Mon, 16 Nov 2026 01:37:31 +0100
Message-ID: <20261116003733.2820132-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116003733.2820132-1-pablo@netfilter.org>
References: <20261116003733.2820132-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Adding expectations to unconfirmed conntracks from any hook is
problematic because of reallocations of the ct extension area can happen
while expectations are placed in the ct extension expectation list.

Note that NFQA_EXP was added with the purpose of supporting userspace
conntrack helpers, which create expectations in confirmation hook.

This patch restricts expectation creation to userspace ct helpers to the
conntrack confirmation hook (ie. NF_HOOK_OP_CONNTRACK), where the
expectation creation for userspace helpers is allowed.

On packet reinjection, hook updates could result in a stale hook_index
that point to different hooks, but this is not an issue because the hook
type is validated.

Fixes: bd0779370588 ("netfilter: nfnetlink_queue: allow to attach expectations to conntracks")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v8: rebase.

 net/netfilter/nfnetlink_queue.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 943dd35ff371..2e0081fbcc5e 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -381,6 +381,19 @@ nf_queue_hook_entry(const struct nf_hook_entries *hooks,
 	return &hooks->hooks[i];
 }
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+static bool nfqnl_hook_exp_support(const struct nf_hook_ops *ops)
+{
+	return (ops->hook_ops_type == NF_HOOK_OP_CONNTRACK &&
+		(((ops->pf == NFPROTO_IPV4 ||
+		   ops->pf == NFPROTO_IPV6) &&
+		  (ops->hooknum == NF_INET_LOCAL_IN ||
+		   ops->hooknum == NF_INET_POST_ROUTING)) ||
+		 (ops->pf == NFPROTO_BRIDGE &&
+		  ops->hooknum == NF_BR_POST_ROUTING)));
+}
+#endif
+
 /* caller must hold rcu read-side lock */
 static void nf_reinject(struct nf_queue_entry *entry,
 			const struct nf_hook_entries *hook_entries,
@@ -1826,6 +1839,7 @@ static struct nf_conn *nfqnl_ct_parse(const struct nfnl_ct_hook *nfnl_ct,
 				      const struct nlmsghdr *nlh,
 				      const struct nlattr * const nfqa[],
 				      struct nf_queue_entry *entry,
+				      const struct nf_hook_ops *hook,
 				      enum ip_conntrack_info *ctinfo)
 {
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
@@ -1838,10 +1852,11 @@ static struct nf_conn *nfqnl_ct_parse(const struct nfnl_ct_hook *nfnl_ct,
 	if (nfnl_ct->parse(nfqa[NFQA_CT], ct) < 0)
 		return NULL;
 
-	if (nfqa[NFQA_EXP])
+	if (nfqa[NFQA_EXP] && nfqnl_hook_exp_support(hook)) {
 		nfnl_ct->attach_expect(nfqa[NFQA_EXP], ct,
-				      NETLINK_CB(entry->skb).portid,
-				      nlmsg_report(nlh));
+				       NETLINK_CB(entry->skb).portid,
+				       nlmsg_report(nlh));
+	}
 	return ct;
 #else
 	return NULL;
@@ -1938,7 +1953,7 @@ static int nfqnl_recv_verdict(struct sk_buff *skb, const struct nfnl_info *info,
 	if (nfqa[NFQA_CT]) {
 		if (nfnl_ct != NULL)
 			ct = nfqnl_ct_parse(nfnl_ct, info->nlh, nfqa, entry,
-					    &ctinfo);
+					    hook, &ctinfo);
 	}
 
 	if (entry->state.pf == PF_BRIDGE) {
-- 
2.47.3

