Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927BF4D0A06
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 13:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789650589; cv=none; b=RaKZagIXZ6qFv5TdL/dnfwNg1Gfd87SO1ES+oDjqYw/TO/H/qHkD7UOF1Ip0ISjEyKoO9iF9+vcRILXc/ZaLtKj77L5xWurkpJBSknYyLCgm/kJHAdRpEw0OjYqjewit7Ttz4d7g9iCXAXwWbLGM6DeE/i1YIaUpjpdcwmd/HYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789650589; c=relaxed/simple;
	bh=Nyb/P3qpEoHlI5GazZ9ZxZUM5RQgRIsEgOYYSJwYNzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfS6wdznybhjFoJXdLE3JRhtvLmisDMPRk55hWZi2H/ph3aLlQEv6hldq+8ABTgbSPD1e8KCFyfQTnvssZoYof/nI7XGJnPWD+wXqJJCFmJbjppOkF2/8o9nIfG0ynoMaghPGJXeZaOLp6vQgTXRtXtuZC5Zvt6fVLWNG2e6mCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 836316038C; Thu, 17 Sep 2026 15:09:42 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf 3/6] netfilter: nf_conntrack: verify L4 protocol before calling helper
Date: Thu, 17 Sep 2026 15:09:19 +0200
Message-ID: <20260917130922.17699-4-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917130922.17699-1-fw@strlen.de>
References: <20260917130922.17699-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This commit ensures that a conntrack helper is only invoked if its
configured L4 protocol matches the actual protocol of the packet.

Currently, nf_ct_call_helper() invokes a helper based on the connection
state, but it does not explicitly verify the protocol number against
the helper's expected protocol. This could potentially lead to helpers
processing packets they were not designed for.

This can happen with related ICMP(v6) errors in the original direction
or when conntrack got attached via TC/act_ct, then was later munged via
act_pipe to alter the ip protocol.

Extend the introduced helper functions: extract the L4 protocol number,
then check it matches helper->l4proto.

Also change ipv4 to explicitly skip frasgments, this shouldn't happen
for normal netfilter-only code path, because conntrack depends on defrag
module, but this may not be the case for other users (ovs, tc).

Also skip the helper invocation if the packet contains no payload
(protoff == skb->len).

nft_ct.c needs to set l4proto in the new helper it allocates to avoid
tripping the new helper->l4proto != pnum guard.

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_proto.c | 23 ++++++++++++++++-------
 net/netfilter/nft_ct.c             |  1 +
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 32f900c155de..18125aa29e0d 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -134,21 +134,23 @@ static bool in_vrf_postrouting(const struct nf_hook_state *state)
 static bool nf_confirm_get_protoff(struct sk_buff *skb, struct net *net,
 				   struct nf_conn *ct,
 				   enum ip_conntrack_info ctinfo,
-				   unsigned int *protoffp)
+				   unsigned int *protoffp, u8 *pnum)
 {
 	unsigned int protoff;
 	__be16 frag_off;
 	int start;
-	u8 pnum;
 
 	switch (nf_ct_l3num(ct)) {
 	case NFPROTO_IPV4:
+		if (ip_is_fragment(ip_hdr(skb)))
+			return false;
 		protoff = skb_network_offset(skb) + ip_hdrlen(skb);
+		*pnum = ip_hdr(skb)->protocol;
 		break;
 	case NFPROTO_IPV6:
-		pnum = ipv6_hdr(skb)->nexthdr;
-		start = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &pnum, &frag_off);
-		if (start < 0 || (frag_off & htons(~0x7)) != 0)
+		*pnum = ipv6_hdr(skb)->nexthdr;
+		start = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), pnum, &frag_off);
+		if (start < 0 || frag_off)
 			return false;
 
 		protoff = start;
@@ -170,6 +172,9 @@ static bool nf_confirm_get_protoff(struct sk_buff *skb, struct net *net,
  *
  * This function calls the l4 connection tracking helper (e.g. ftp, sip...) if
  * one was assigned to the connection.
+ * This re-derives the l4 protocol number: act_ct can associate the skb with
+ * a connection/protocol and later pedit/bpf function can munge the packet
+ * afterwards.
  *
  * Return: verdict (NF_ACCEPT, NF_DROP, ...)
  */
@@ -180,6 +185,7 @@ int nf_ct_call_helper(struct sk_buff *skb, struct nf_conn *ct,
 	const struct nf_conn_help *help;
 	bool seqadj_needed;
 	unsigned int protoff;
+	u8 pnum = 0;
 
 	help = nfct_help(ct);
 
@@ -191,10 +197,10 @@ int nf_ct_call_helper(struct sk_buff *skb, struct nf_conn *ct,
 	if (ctinfo == IP_CT_RELATED_REPLY)
 		return NF_ACCEPT;
 
-	if (!nf_confirm_get_protoff(skb, net, ct, ctinfo, &protoff))
+	if (!nf_confirm_get_protoff(skb, net, ct, ctinfo, &protoff, &pnum))
 		return NF_ACCEPT;
 
-	if (help) {
+	if (help && protoff < skb->len) {
 		const struct nf_conntrack_helper *helper;
 		int (*helper_cb)(struct sk_buff *skb, unsigned int protoff,
 				 struct nf_conn *ct,
@@ -204,6 +210,9 @@ int nf_ct_call_helper(struct sk_buff *skb, struct nf_conn *ct,
 		/* rcu_read_lock()ed by nf_hook */
 		helper = rcu_dereference(help->helper);
 		if (helper) {
+			if (helper->l4proto != pnum)
+				return NF_ACCEPT;
+
 			helper_cb = rcu_dereference(helper->help);
 			if (helper_cb) {
 				ret = helper_cb(skb, protoff,
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 9dbf127df9c8..a1093311414b 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1306,6 +1306,7 @@ static int nft_ct_expect_helper_alloc(struct nft_ct_expect_obj *priv)
 		 "nft_ct_expect");
 	ct_expect_helper->me = THIS_MODULE;
 	ct_expect_helper->expect_policy[NF_CT_EXPECT_CLASS_DEFAULT].max_expected = priv->size;
+	ct_expect_helper->l4proto = priv->l4proto;
 	rcu_assign_pointer(ct_expect_helper->help, ct_expect_help);
 	refcount_set(&ct_expect_helper->ct_refcnt, 1);
 
-- 
2.55.0

