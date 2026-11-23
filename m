Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442097;
	b=ch4J8s1FBy3szCP940Hds2ymQzmiCT+Z/7sPq3lfg2KpnmyiwNmljchD1IUhKVRpsF4u
	 ZHTWwsNtC22oDS7l9JsWwFTi+gHY2868WMRI38BRgGhT0AQ5eKjvLkWGuwj56TYeRQncZ
	 I9onC4oD9fj/xfEDZjwbxIZ/ZUx4yNEiaYOYQKgwVYoq7YsxRdybrVmDWThJUQg830gNU
	 ittlZdmmanU+UueDWExsWZaUtv2qKp7VsvNqfjqAqu+dBMGhm28JG2qc694KD6T+OKwKv
	 rudKvpJ+rzznqqfhfALqEvMLxP05OreveLywS6t/VxsriNvYE/L/zFJgjU1q5KhdnQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442097;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=uPrRflyZhCB2rkOWmpLzJ+vYdeKuwqwS6D1aU/IBrt0=;
	b=ffp+EIhTKhGYZL6PeYZZ2T1Z4pWefgF+x7RrFHG5mDexHuH/wqIUWrM91bVG83Hjpt2K
	 di08iQp5KvcJOXftBMOXwW2D0sqQOwlow2v5gDGctb5in/aRmMzXTRGtSQrrIwRJfy6ZC
	 KnNl6Yx3tuis82nVYDgw0LSePukl9snTv28I/nW4WZVVrKEyYC1qajSv1vx/ZIMAYx+pD
	 oTUwEFU8CAhjVuIyR7HMqtlLvngU834dwy+3gr5Ry6ogownsFwOpEJwgIbuiIfmMLkwVL
	 XK6jza6octZwMok+TZC6BjG6KvfFPIcPXdn1wHMFQaGtbj8SUQjXmgQ6nIfdbH+ZygQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Huv+ANRz;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26786606A31F;
	Mon, 23 Nov 2026 13:54:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 26786606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Huv+ANRz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795442094;
	bh=uPrRflyZhCB2rkOWmpLzJ+vYdeKuwqwS6D1aU/IBrt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Huv+ANRzD82CJAJpGPL1PilSPzimz+Yx5ni/isxjagrbHbPgRYzSYgFYO55EUTMsJ
	 0vZn44LnKvNe8c2zevWbCQRBKSrVKReMmk8Ny0sbakFf75ZzRoKRYItZzt2Bl7Cs8+
	 B8rihB7XybD32hPtKyW/Wbqf4P7yIsrWFr1i47Yz47CD2LJGbsavvAhrv8aih2aUA1
	 3F0Lfv+l8ZFo8lxC0ptj7ZgIpLOCi8g3xlEi8DUvs2XTOmIGOff+OQW+4+uIGPv5TE
	 mDKSqvFaRywhDXLbRsyIyBywg6Huzli3f4RDuz/TpIVx6fLIIHOKw0O0wVGB1rvR+O
	 HIoLWkYiAKs1Q==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 80334602D0;
	Mon, 23 Nov 2026 14:54:53 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 04/15] netfilter: conntrack: verify L4 protocol before calling helper
Date: Mon, 23 Nov 2026 14:54:31 +0100
Message-ID: <20261123135442.3940372-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123135442.3940372-1-pablo@netfilter.org>
References: <20261123135442.3940372-1-pablo@netfilter.org>
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

From: Florian Westphal <fw@strlen.de>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
index 5a8db5592036..58846bc405b7 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1307,6 +1307,7 @@ static int nft_ct_expect_helper_alloc(struct nft_ct_expect_obj *priv)
 		 "nft_ct_expect");
 	ct_expect_helper->me = THIS_MODULE;
 	ct_expect_helper->expect_policy[NF_CT_EXPECT_CLASS_DEFAULT].max_expected = priv->size;
+	ct_expect_helper->l4proto = priv->l4proto;
 	rcu_assign_pointer(ct_expect_helper->help, ct_expect_help);
 	refcount_set(&ct_expect_helper->ct_refcnt, 1);
 
-- 
2.47.3

