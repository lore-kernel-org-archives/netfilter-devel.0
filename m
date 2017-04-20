From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/3] netfilter: pptp: attach nat extension when needed
Date: Thu, 20 Apr 2017 10:11:34 +0200
Message-ID: <20170420081135.20812-3-fw@strlen.de>
References: <20170420081135.20812-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46788 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S943482AbdDTILY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Apr 2017 04:11:24 -0400
In-Reply-To: <20170420081135.20812-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

make sure nat extension gets added if the master conntrack is subject to
NAT.  This will be required once the nat core stops adding it by default.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/nf_nat_pptp.c  | 25 +++++++++++++++++++++----
 net/netfilter/nf_conntrack_pptp.c | 12 ++++++++++--
 2 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_pptp.c b/net/ipv4/netfilter/nf_nat_pptp.c
index 211fee5fe59d..8a69363b4884 100644
--- a/net/ipv4/netfilter/nf_nat_pptp.c
+++ b/net/ipv4/netfilter/nf_nat_pptp.c
@@ -49,9 +49,14 @@ static void pptp_nat_expected(struct nf_conn *ct,
 	const struct nf_ct_pptp_master *ct_pptp_info;
 	const struct nf_nat_pptp *nat_pptp_info;
 	struct nf_nat_range range;
+	struct nf_conn_nat *nat;
 
+	nat = nf_ct_nat_ext_add(ct);
+	if (WARN_ON_ONCE(!nat))
+		return;
+
+	nat_pptp_info = &nat->help.nat_pptp_info;
 	ct_pptp_info = nfct_help_data(master);
-	nat_pptp_info = &nfct_nat(master)->help.nat_pptp_info;
 
 	/* And here goes the grand finale of corrosion... */
 	if (exp->dir == IP_CT_DIR_ORIGINAL) {
@@ -120,13 +125,17 @@ pptp_outbound_pkt(struct sk_buff *skb,
 
 {
 	struct nf_ct_pptp_master *ct_pptp_info;
+	struct nf_conn_nat *nat = nfct_nat(ct);
 	struct nf_nat_pptp *nat_pptp_info;
 	u_int16_t msg;
 	__be16 new_callid;
 	unsigned int cid_off;
 
+	if (WARN_ON_ONCE(!nat))
+		return NF_DROP;
+
+	nat_pptp_info = &nat->help.nat_pptp_info;
 	ct_pptp_info = nfct_help_data(ct);
-	nat_pptp_info = &nfct_nat(ct)->help.nat_pptp_info;
 
 	new_callid = ct_pptp_info->pns_call_id;
 
@@ -191,11 +200,15 @@ pptp_exp_gre(struct nf_conntrack_expect *expect_orig,
 	     struct nf_conntrack_expect *expect_reply)
 {
 	const struct nf_conn *ct = expect_orig->master;
+	struct nf_conn_nat *nat = nfct_nat(ct);
 	struct nf_ct_pptp_master *ct_pptp_info;
 	struct nf_nat_pptp *nat_pptp_info;
 
+	if (WARN_ON_ONCE(!nat))
+		return;
+
+	nat_pptp_info = &nat->help.nat_pptp_info;
 	ct_pptp_info = nfct_help_data(ct);
-	nat_pptp_info = &nfct_nat(ct)->help.nat_pptp_info;
 
 	/* save original PAC call ID in nat_info */
 	nat_pptp_info->pac_call_id = ct_pptp_info->pac_call_id;
@@ -223,11 +236,15 @@ pptp_inbound_pkt(struct sk_buff *skb,
 		 union pptp_ctrl_union *pptpReq)
 {
 	const struct nf_nat_pptp *nat_pptp_info;
+	struct nf_conn_nat *nat = nfct_nat(ct);
 	u_int16_t msg;
 	__be16 new_pcid;
 	unsigned int pcid_off;
 
-	nat_pptp_info = &nfct_nat(ct)->help.nat_pptp_info;
+	if (WARN_ON_ONCE(!nat))
+		return NF_DROP;
+
+	nat_pptp_info = &nat->help.nat_pptp_info;
 	new_pcid = nat_pptp_info->pns_call_id;
 
 	switch (msg = ntohs(ctlh->messageType)) {
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 126031909fc7..6959e93063d4 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -263,7 +263,7 @@ static int exp_gre(struct nf_conn *ct, __be16 callid, __be16 peer_callid)
 	goto out_put_both;
 }
 
-static inline int
+static int
 pptp_inbound_pkt(struct sk_buff *skb, unsigned int protoff,
 		 struct PptpControlHeader *ctlh,
 		 union pptp_ctrl_union *pptpReq,
@@ -391,7 +391,7 @@ pptp_inbound_pkt(struct sk_buff *skb, unsigned int protoff,
 	return NF_ACCEPT;
 }
 
-static inline int
+static int
 pptp_outbound_pkt(struct sk_buff *skb, unsigned int protoff,
 		  struct PptpControlHeader *ctlh,
 		  union pptp_ctrl_union *pptpReq,
@@ -523,6 +523,14 @@ conntrack_pptp_help(struct sk_buff *skb, unsigned int protoff,
 	int ret;
 	u_int16_t msg;
 
+#if IS_ENABLED(CONFIG_NF_NAT)
+	if (!nf_ct_is_confirmed(ct) && (ct->status & IPS_NAT_MASK)) {
+		struct nf_conn_nat *nat = nf_ct_ext_find(ct, NF_CT_EXT_NAT);
+
+		if (!nat && !nf_ct_ext_add(ct, NF_CT_EXT_NAT, GFP_ATOMIC))
+			return NF_DROP;
+	}
+#endif
 	/* don't do any tracking before tcp handshake complete */
 	if (ctinfo != IP_CT_ESTABLISHED && ctinfo != IP_CT_ESTABLISHED_REPLY)
 		return NF_ACCEPT;
-- 
2.10.2

