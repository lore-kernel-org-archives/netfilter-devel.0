Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC2E38F938
	for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2026 19:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779131562; cv=none; b=tRggCHR2iNzrZbVLfO3DsXxfRdnaZWLu69TX1sq3DBTo6t6j+p3HB5F7WbN5ZH8PaQL+en9zHEBPtkbFGUWzHsrSCFFR2YH+WYFQEkNFPdhBCTDmEPAH0EIPSjsOOspEKoIXoTmg2DL08ThYRveuqgHliQWJWeKdPsmEttMf1YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779131562; c=relaxed/simple;
	bh=AIX9HBqFDP/JnBOxnOsn/fmWL4wmc2mTr5tMx14Fp7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gCTOU/2oUSYIXuCkKQo0au7oGsylJ+xVMK5xZuI2mzMF1LXvp1PWWk7LOlBNAhHUr6ikOSFZ3t4O5XZjEGNoHjeQGRPEPdygOmpOaXS5RR+1YAqYmp3RFufhpzOWCPYE1V07Br+qQo/tH1O5wi0CInjZ2ux0jOg7tAe3kH8B86k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=J5kBi6jk; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="J5kBi6jk"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C74146055C;
	Mon, 18 May 2026 21:12:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1779131558;
	bh=OXRtvqQss5aAR4sPgBkwQmkFb5v1aQhjhvABsci+5XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J5kBi6jksz/NVb/9EmBVn9wnTd/T1sF+FJ58r1sJ3q5L5o7AzxHKc/J2Y9WsrgvE/
	 vsfNoUyyPPVdR9Sz5g6gNj0GbiXJG+7C8jScAQmxxTHeOUMhIxSlyTUX6lNx7hwwTr
	 gEe54HH3puZT4zrgscUEWRgAQluj5+OPKCh3X/lWvqxDpOmRolDhx1QYuEsriLDV/F
	 3Bpb+PFxWxrHuIDD3SjtynLxL9aF+fEvlllPOHcaQv8qHRAPcxmMVhBcJT9Ma1F2LK
	 /KemWjY+ICHwRjdtPTaCypn8yNEu8qPK4BTlYL0M6B429GkMGdYXSRobgRfHWm4KX8
	 UmQdAppW1w+fA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf,v4 3/3] netfilter: nf_conntrack_helper: add null check in nfct_help_data() calls
Date: Mon, 18 May 2026 21:12:32 +0200
Message-ID: <20260518191232.1053294-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518191232.1053294-1-pablo@netfilter.org>
References: <20260518191232.1053294-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When helper is removed, nf_ct_iterate_destroy() unhelps the conntrack
entries. Then, the nf_ct_ext_find() might return NULL if the extension
is stale via:

  c56716c69ce1 ("netfilter: extensions: introduce extension genid count").

Add the null check to nfct_help_data() and helpers that call this
function since packet path could be walking over helper while it is
being removed.

Fixes: 1afc56794e03 ("netfilter: nf_ct_helper: implement variable length helper private data")
Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: new in this series

 include/net/netfilter/nf_conntrack_helper.h |  2 ++
 net/ipv4/netfilter/nf_nat_h323.c            |  6 ++++++
 net/ipv4/netfilter/nf_nat_pptp.c            |  6 ++++++
 net/netfilter/nf_conntrack_ftp.c            |  6 ++++++
 net/netfilter/nf_conntrack_h323_main.c      | 18 ++++++++++++++++++
 net/netfilter/nf_conntrack_pptp.c           | 12 ++++++++++++
 net/netfilter/nf_conntrack_proto_gre.c      |  6 ++++++
 net/netfilter/nf_conntrack_sane.c           |  3 +++
 net/netfilter/nf_conntrack_sip.c            | 21 +++++++++++++++++++++
 net/netfilter/nf_nat_sip.c                  |  9 +++++++++
 10 files changed, 89 insertions(+)

diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index b6ff7dc65c97..a712288fe162 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -140,6 +140,8 @@ static inline void *nfct_help_data(const struct nf_conn *ct)
 	struct nf_conn_help *help;
 
 	help = nf_ct_ext_find(ct, NF_CT_EXT_HELPER);
+	if (!help)
+		return NULL;
 
 	return (void *)help->data;
 }
diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index faee20af4856..f6a33ee11e4f 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -100,6 +100,9 @@ static int set_sig_addr(struct sk_buff *skb, struct nf_conn *ct,
 	__be16 port;
 	union nf_inet_addr addr;
 
+	if (!info)
+		return -1;
+
 	for (i = 0; i < count; i++) {
 		if (get_h225_addr(ct, *data, &taddr[i], &addr, &port)) {
 			if (addr.ip == ct->tuplehash[dir].tuple.src.u3.ip &&
@@ -184,6 +187,9 @@ static int nat_rtp_rtcp(struct sk_buff *skb, struct nf_conn *ct,
 	int i;
 	u_int16_t nated_port;
 
+	if (!info)
+		return -1;
+
 	/* Set expectations for NAT */
 	rtp_exp->saved_proto.udp.port = rtp_exp->tuple.dst.u.udp.port;
 	rtp_exp->expectfn = nf_nat_follow_master;
diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
index fab357cc8559..efda9b64e4cf 100644
--- a/net/ipv4/netfilter/nf_nat_pptp.c
+++ b/net/ipv4/netfilter/nf_nat_pptp.c
@@ -58,6 +58,8 @@ static void pptp_nat_expected(struct nf_conn *ct,
 
 	nat_pptp_info = &nat->help.nat_pptp_info;
 	ct_pptp_info = nfct_help_data(master);
+	if (!ct_pptp_info)
+		return;
 
 	/* And here goes the grand finale of corrosion... */
 	if (exp->dir == IP_CT_DIR_ORIGINAL) {
@@ -137,6 +139,8 @@ pptp_outbound_pkt(struct sk_buff *skb,
 
 	nat_pptp_info = &nat->help.nat_pptp_info;
 	ct_pptp_info = nfct_help_data(ct);
+	if (!ct_pptp_info)
+		return NF_DROP;
 
 	new_callid = ct_pptp_info->pns_call_id;
 
@@ -209,6 +213,8 @@ pptp_exp_gre(struct nf_conntrack_expect *expect_orig,
 
 	nat_pptp_info = &nat->help.nat_pptp_info;
 	ct_pptp_info = nfct_help_data(ct);
+	if (!ct_pptp_info)
+		return;
 
 	/* save original PAC call ID in nat_info */
 	nat_pptp_info->pac_call_id = ct_pptp_info->pac_call_id;
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index de83bf9e6c61..a083697c3a54 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -381,6 +381,9 @@ static int help(struct sk_buff *skb,
 	int found = 0, ends_in_nl;
 	nf_nat_ftp_hook_fn *nf_nat_ftp;
 
+	if (!ct_ftp_info)
+		return NF_DROP;
+
 	/* Until there's been traffic both ways, don't look in packets. */
 	if (ctinfo != IP_CT_ESTABLISHED &&
 	    ctinfo != IP_CT_ESTABLISHED_REPLY) {
@@ -542,6 +545,9 @@ static int nf_ct_ftp_from_nlattr(struct nlattr *attr, struct nf_conn *ct)
 {
 	struct nf_ct_ftp_master *ftp = nfct_help_data(ct);
 
+	if (!ftp)
+		return -1;
+
 	/* This conntrack has been injected from user-space, always pick up
 	 * sequence tracking. Otherwise, the first FTP command after the
 	 * failover breaks.
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index b2fe6554b9cf..0ffd191a29ee 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -76,6 +76,9 @@ static int get_tpkt_data(struct sk_buff *skb, unsigned int protoff,
 	int tpktlen;
 	int tpktoff;
 
+	if (!info)
+		return 0;
+
 	/* Get TCP header */
 	th = skb_header_pointer(skb, protoff, sizeof(_tcph), &_tcph);
 	if (th == NULL)
@@ -1215,6 +1218,9 @@ static int expect_q931(struct sk_buff *skb, struct nf_conn *ct,
 	union nf_inet_addr addr;
 	struct nf_conntrack_expect *exp;
 
+	if (!info)
+		return -1;
+
 	/* Look for the first related address */
 	for (i = 0; i < count; i++) {
 		if (get_h225_addr(ct, *data, &taddr[i], &addr, &port) &&
@@ -1328,6 +1334,9 @@ static int process_rrq(struct sk_buff *skb, struct nf_conn *ct,
 	const struct nfct_h323_nat_hooks *nathook;
 	int ret;
 
+	if (!info)
+		return -1;
+
 	pr_debug("nf_ct_ras: RRQ\n");
 
 	ret = expect_q931(skb, ct, ctinfo, protoff, data,
@@ -1366,6 +1375,9 @@ static int process_rcf(struct sk_buff *skb, struct nf_conn *ct,
 	int ret;
 	struct nf_conntrack_expect *exp;
 
+	if (!info)
+		return -1;
+
 	pr_debug("nf_ct_ras: RCF\n");
 
 	nathook = rcu_dereference(nfct_h323_nat_hook);
@@ -1416,6 +1428,9 @@ static int process_urq(struct sk_buff *skb, struct nf_conn *ct,
 	int dir = CTINFO2DIR(ctinfo);
 	int ret;
 
+	if (!info)
+		return -1;
+
 	pr_debug("nf_ct_ras: URQ\n");
 
 	nathook = rcu_dereference(nfct_h323_nat_hook);
@@ -1450,6 +1465,9 @@ static int process_arq(struct sk_buff *skb, struct nf_conn *ct,
 	__be16 port;
 	union nf_inet_addr addr;
 
+	if (!info)
+		return 0;
+
 	pr_debug("nf_ct_ras: ARQ\n");
 
 	nathook = rcu_dereference(nfct_h323_nat_hook);
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 4c679638df06..57f85f6c2625 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -164,6 +164,9 @@ static void pptp_destroy_siblings(struct nf_conn *ct)
 	const struct nf_ct_pptp_master *ct_pptp_info = nfct_help_data(ct);
 	struct nf_conntrack_tuple t;
 
+	if (!ct_pptp_info)
+		return;
+
 	nf_ct_gre_keymap_destroy(ct);
 
 	/* try original (pns->pac) tuple */
@@ -261,6 +264,9 @@ pptp_inbound_pkt(struct sk_buff *skb, unsigned int protoff,
 	u_int16_t msg;
 	__be16 cid = 0, pcid = 0;
 
+	if (!info)
+		return NF_DROP;
+
 	msg = ntohs(ctlh->messageType);
 	pr_debug("inbound control message %s\n", pptp_msg_name(msg));
 
@@ -388,6 +394,9 @@ pptp_outbound_pkt(struct sk_buff *skb, unsigned int protoff,
 	u_int16_t msg;
 	__be16 cid = 0, pcid = 0;
 
+	if (!info)
+		return NF_DROP;
+
 	msg = ntohs(ctlh->messageType);
 	pr_debug("outbound control message %s\n", pptp_msg_name(msg));
 
@@ -506,6 +515,9 @@ conntrack_pptp_help(struct sk_buff *skb, unsigned int protoff,
 	int ret;
 	u_int16_t msg;
 
+	if (!info)
+		return NF_DROP;
+
 #if IS_ENABLED(CONFIG_NF_NAT)
 	if (!nf_ct_is_confirmed(ct) && (ct->status & IPS_NAT_MASK)) {
 		struct nf_conn_nat *nat = nf_ct_ext_find(ct, NF_CT_EXT_NAT);
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index 94c19bc4edc5..fa99380aaf64 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -96,6 +96,9 @@ int nf_ct_gre_keymap_add(struct nf_conn *ct, enum ip_conntrack_dir dir,
 	struct nf_ct_pptp_master *ct_pptp_info = nfct_help_data(ct);
 	struct nf_ct_gre_keymap **kmp, *km;
 
+	if (!ct_pptp_info)
+		return -ENOENT;
+
 	kmp = &ct_pptp_info->keymap[dir];
 	if (*kmp) {
 		/* check whether it's a retransmission */
@@ -131,6 +134,9 @@ void nf_ct_gre_keymap_destroy(struct nf_conn *ct)
 	struct nf_ct_pptp_master *ct_pptp_info = nfct_help_data(ct);
 	enum ip_conntrack_dir dir;
 
+	if (!ct_pptp_info)
+		return;
+
 	pr_debug("entering for ct %p\n", ct);
 
 	spin_lock_bh(&keymap_lock);
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
index 13dc421fc4f5..9cf4a22eca4a 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -74,6 +74,9 @@ static int help(struct sk_buff *skb,
 		struct sane_reply_net_start repl;
 	} buf;
 
+	if (!ct_sane_info)
+		return NF_DROP;
+
 	/* Until there's been traffic both ways, don't look in packets. */
 	if (ctinfo != IP_CT_ESTABLISHED &&
 	    ctinfo != IP_CT_ESTABLISHED_REPLY)
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index e69941f1a101..2f90f2c54708 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1227,6 +1227,9 @@ static int process_invite_response(struct sk_buff *skb, unsigned int protoff,
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 	struct nf_ct_sip_master *ct_sip_info = nfct_help_data(ct);
 
+	if (!ct_sip_info)
+		return NF_DROP;
+
 	if ((code >= 100 && code <= 199) ||
 	    (code >= 200 && code <= 299))
 		return process_sdp(skb, protoff, dataoff, dptr, datalen, cseq);
@@ -1244,6 +1247,9 @@ static int process_update_response(struct sk_buff *skb, unsigned int protoff,
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 	struct nf_ct_sip_master *ct_sip_info = nfct_help_data(ct);
 
+	if (!ct_sip_info)
+		return NF_DROP;
+
 	if ((code >= 100 && code <= 199) ||
 	    (code >= 200 && code <= 299))
 		return process_sdp(skb, protoff, dataoff, dptr, datalen, cseq);
@@ -1261,6 +1267,9 @@ static int process_prack_response(struct sk_buff *skb, unsigned int protoff,
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 	struct nf_ct_sip_master *ct_sip_info = nfct_help_data(ct);
 
+	if (!ct_sip_info)
+		return NF_DROP;
+
 	if ((code >= 100 && code <= 199) ||
 	    (code >= 200 && code <= 299))
 		return process_sdp(skb, protoff, dataoff, dptr, datalen, cseq);
@@ -1279,6 +1288,9 @@ static int process_invite_request(struct sk_buff *skb, unsigned int protoff,
 	struct nf_ct_sip_master *ct_sip_info = nfct_help_data(ct);
 	unsigned int ret;
 
+	if (!ct_sip_info)
+		return NF_DROP;
+
 	flush_expectations(ct, true);
 	ret = process_sdp(skb, protoff, dataoff, dptr, datalen, cseq);
 	if (ret == NF_ACCEPT)
@@ -1321,6 +1333,9 @@ static int process_register_request(struct sk_buff *skb, unsigned int protoff,
 	unsigned int expires = 0;
 	int ret;
 
+	if (!ct_sip_info)
+		return NF_DROP;
+
 	/* Expected connections can not register again. */
 	if (ct->status & IPS_EXPECTED)
 		return NF_ACCEPT;
@@ -1421,6 +1436,9 @@ static int process_register_response(struct sk_buff *skb, unsigned int protoff,
 	unsigned int expires = 0;
 	int in_contact = 0, ret;
 
+	if (!ct_sip_info)
+		return NF_DROP;
+
 	/* According to RFC 3261, "UAs MUST NOT send a new registration until
 	 * they have received a final response from the registrar for the
 	 * previous one or the previous REGISTER request has timed out".
@@ -1550,6 +1568,9 @@ static int process_sip_request(struct sk_buff *skb, unsigned int protoff,
 	union nf_inet_addr addr;
 	__be16 port;
 
+	if (!ct_sip_info)
+		return NF_DROP;
+
 	/* Many Cisco IP phones use a high source port for SIP requests, but
 	 * listen for the response on port 5060.  If we are the local
 	 * router for one of these phones, save the port number from the
diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index 9fbfc6bff0c2..b1931202825b 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -106,6 +106,9 @@ static int map_addr(struct sk_buff *skb, unsigned int protoff,
 	union nf_inet_addr newaddr;
 	__be16 newport;
 
+	if (!ct_sip_info)
+		return 0;
+
 	if (nf_inet_addr_cmp(&ct->tuplehash[dir].tuple.src.u3, addr) &&
 	    ct->tuplehash[dir].tuple.src.u.udp.port == port) {
 		newaddr = ct->tuplehash[!dir].tuple.dst.u3;
@@ -158,6 +161,9 @@ static unsigned int nf_nat_sip(struct sk_buff *skb, unsigned int protoff,
 	__be16 port;
 	int request, in_header;
 
+	if (!ct_sip_info)
+		return NF_DROP;
+
 	/* Basic rules: requests and responses. */
 	if (strncasecmp(*dptr, "SIP/2.0", strlen("SIP/2.0")) != 0) {
 		if (ct_sip_parse_request(ct, *dptr, *datalen,
@@ -390,6 +396,9 @@ static unsigned int nf_nat_sip_expect(struct sk_buff *skb, unsigned int protoff,
 	char buffer[INET6_ADDRSTRLEN + sizeof("[]:nnnnn")];
 	unsigned int buflen;
 
+	if (!ct_sip_info)
+		return NF_DROP;
+
 	/* Connection will come from reply */
 	if (nf_inet_addr_cmp(&ct->tuplehash[dir].tuple.src.u3,
 			     &ct->tuplehash[!dir].tuple.dst.u3))
-- 
2.47.3

