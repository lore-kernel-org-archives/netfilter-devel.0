From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 17/31] netfilter: conntrack: avoid using ->error callback if possible
Date: Tue,  9 Oct 2018 01:01:11 +0200
Message-ID: <20181008230125.2330-18-pablo@netfilter.org>
References: <20181008230125.2330-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181008230125.2330-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The error() handler gets called before allocating or looking up a
connection tracking entry.

We can instead use direct calls from the ->packet() handlers which get
invoked for every packet anyway.

Only exceptions are icmp and icmpv6, these two special cases will be
handled in the next patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_dccp.c | 98 +++++++++++++++------------------
 net/netfilter/nf_conntrack_proto_sctp.c | 67 +++++++++++-----------
 net/netfilter/nf_conntrack_proto_tcp.c  | 32 ++++-------
 3 files changed, 91 insertions(+), 106 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index fdea305c7aa5..1b9e600f707d 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -435,6 +435,48 @@ static u64 dccp_ack_seq(const struct dccp_hdr *dh)
 		     ntohl(dhack->dccph_ack_nr_low);
 }
 
+static bool dccp_error(const struct dccp_hdr *dh,
+		       struct sk_buff *skb, unsigned int dataoff,
+		       const struct nf_hook_state *state)
+{
+	unsigned int dccp_len = skb->len - dataoff;
+	unsigned int cscov;
+	const char *msg;
+
+	if (dh->dccph_doff * 4 < sizeof(struct dccp_hdr) ||
+	    dh->dccph_doff * 4 > dccp_len) {
+		msg = "nf_ct_dccp: truncated/malformed packet ";
+		goto out_invalid;
+	}
+
+	cscov = dccp_len;
+	if (dh->dccph_cscov) {
+		cscov = (dh->dccph_cscov - 1) * 4;
+		if (cscov > dccp_len) {
+			msg = "nf_ct_dccp: bad checksum coverage ";
+			goto out_invalid;
+		}
+	}
+
+	if (state->hook == NF_INET_PRE_ROUTING &&
+	    state->net->ct.sysctl_checksum &&
+	    nf_checksum_partial(skb, state->hook, dataoff, cscov,
+				IPPROTO_DCCP, state->pf)) {
+		msg = "nf_ct_dccp: bad checksum ";
+		goto out_invalid;
+	}
+
+	if (dh->dccph_type >= DCCP_PKT_INVALID) {
+		msg = "nf_ct_dccp: reserved packet type ";
+		goto out_invalid;
+	}
+	return false;
+out_invalid:
+	nf_l4proto_log_invalid(skb, state->net, state->pf,
+			       IPPROTO_DCCP, "%s", msg);
+	return true;
+}
+
 static int dccp_packet(struct nf_conn *ct, struct sk_buff *skb,
 		       unsigned int dataoff, enum ip_conntrack_info ctinfo,
 		       const struct nf_hook_state *state)
@@ -449,6 +491,9 @@ static int dccp_packet(struct nf_conn *ct, struct sk_buff *skb,
 	if (!dh)
 		return NF_DROP;
 
+	if (dccp_error(dh, skb, dataoff, state))
+		return -NF_ACCEPT;
+
 	type = dh->dccph_type;
 	if (!nf_ct_is_confirmed(ct) && !dccp_new(ct, skb, dh))
 		return -NF_ACCEPT;
@@ -529,57 +574,6 @@ static int dccp_packet(struct nf_conn *ct, struct sk_buff *skb,
 	return NF_ACCEPT;
 }
 
-static int dccp_error(struct nf_conn *tmpl,
-		      struct sk_buff *skb, unsigned int dataoff,
-		      const struct nf_hook_state *state)
-{
-	struct dccp_hdr _dh, *dh;
-	unsigned int dccp_len = skb->len - dataoff;
-	unsigned int cscov;
-	const char *msg;
-
-	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &_dh);
-	if (dh == NULL) {
-		msg = "nf_ct_dccp: short packet ";
-		goto out_invalid;
-	}
-
-	if (dh->dccph_doff * 4 < sizeof(struct dccp_hdr) ||
-	    dh->dccph_doff * 4 > dccp_len) {
-		msg = "nf_ct_dccp: truncated/malformed packet ";
-		goto out_invalid;
-	}
-
-	cscov = dccp_len;
-	if (dh->dccph_cscov) {
-		cscov = (dh->dccph_cscov - 1) * 4;
-		if (cscov > dccp_len) {
-			msg = "nf_ct_dccp: bad checksum coverage ";
-			goto out_invalid;
-		}
-	}
-
-	if (state->hook == NF_INET_PRE_ROUTING &&
-	    state->net->ct.sysctl_checksum &&
-	    nf_checksum_partial(skb, state->hook, dataoff, cscov,
-				IPPROTO_DCCP, state->pf)) {
-		msg = "nf_ct_dccp: bad checksum ";
-		goto out_invalid;
-	}
-
-	if (dh->dccph_type >= DCCP_PKT_INVALID) {
-		msg = "nf_ct_dccp: reserved packet type ";
-		goto out_invalid;
-	}
-
-	return NF_ACCEPT;
-
-out_invalid:
-	nf_l4proto_log_invalid(skb, state->net, state->pf,
-			       IPPROTO_DCCP, "%s", msg);
-	return -NF_ACCEPT;
-}
-
 static bool dccp_can_early_drop(const struct nf_conn *ct)
 {
 	switch (ct->proto.dccp.state) {
@@ -852,7 +846,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp4 = {
 	.l3proto		= AF_INET,
 	.l4proto		= IPPROTO_DCCP,
 	.packet			= dccp_packet,
-	.error			= dccp_error,
 	.can_early_drop		= dccp_can_early_drop,
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
 	.print_conntrack	= dccp_print_conntrack,
@@ -884,7 +877,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp6 = {
 	.l3proto		= AF_INET6,
 	.l4proto		= IPPROTO_DCCP,
 	.packet			= dccp_packet,
-	.error			= dccp_error,
 	.can_early_drop		= dccp_can_early_drop,
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
 	.print_conntrack	= dccp_print_conntrack,
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index ea16c1c58483..7d7eb18f658b 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -330,6 +330,37 @@ sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
 	return true;
 }
 
+static bool sctp_error(struct sk_buff *skb,
+		       unsigned int dataoff,
+		       const struct nf_hook_state *state)
+{
+	const struct sctphdr *sh;
+	const char *logmsg;
+
+	if (skb->len < dataoff + sizeof(struct sctphdr)) {
+		logmsg = "nf_ct_sctp: short packet ";
+		goto out_invalid;
+	}
+	if (state->hook == NF_INET_PRE_ROUTING &&
+	    state->net->ct.sysctl_checksum &&
+	    skb->ip_summed == CHECKSUM_NONE) {
+		if (!skb_make_writable(skb, dataoff + sizeof(struct sctphdr))) {
+			logmsg = "nf_ct_sctp: failed to read header ";
+			goto out_invalid;
+		}
+		sh = (const struct sctphdr *)(skb->data + dataoff);
+		if (sh->checksum != sctp_compute_cksum(skb, dataoff)) {
+			logmsg = "nf_ct_sctp: bad CRC ";
+			goto out_invalid;
+		}
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+	}
+	return false;
+out_invalid:
+	nf_l4proto_log_invalid(skb, state->net, state->pf, IPPROTO_SCTP, "%s", logmsg);
+	return true;
+}
+
 /* Returns verdict for packet, or -NF_ACCEPT for invalid. */
 static int sctp_packet(struct nf_conn *ct,
 		       struct sk_buff *skb,
@@ -347,6 +378,9 @@ static int sctp_packet(struct nf_conn *ct,
 	unsigned int *timeouts;
 	unsigned long map[256 / sizeof(unsigned long)] = { 0 };
 
+	if (sctp_error(skb, dataoff, state))
+		return -NF_ACCEPT;
+
 	sh = skb_header_pointer(skb, dataoff, sizeof(_sctph), &_sctph);
 	if (sh == NULL)
 		goto out;
@@ -466,37 +500,6 @@ static int sctp_packet(struct nf_conn *ct,
 	return -NF_ACCEPT;
 }
 
-static int sctp_error(struct nf_conn *tpl, struct sk_buff *skb,
-		      unsigned int dataoff,
-		      const struct nf_hook_state *state)
-{
-	const struct sctphdr *sh;
-	const char *logmsg;
-
-	if (skb->len < dataoff + sizeof(struct sctphdr)) {
-		logmsg = "nf_ct_sctp: short packet ";
-		goto out_invalid;
-	}
-	if (state->hook == NF_INET_PRE_ROUTING &&
-	    state->net->ct.sysctl_checksum &&
-	    skb->ip_summed == CHECKSUM_NONE) {
-		if (!skb_make_writable(skb, dataoff + sizeof(struct sctphdr))) {
-			logmsg = "nf_ct_sctp: failed to read header ";
-			goto out_invalid;
-		}
-		sh = (const struct sctphdr *)(skb->data + dataoff);
-		if (sh->checksum != sctp_compute_cksum(skb, dataoff)) {
-			logmsg = "nf_ct_sctp: bad CRC ";
-			goto out_invalid;
-		}
-		skb->ip_summed = CHECKSUM_UNNECESSARY;
-	}
-	return NF_ACCEPT;
-out_invalid:
-	nf_l4proto_log_invalid(skb, state->net, state->pf, IPPROTO_SCTP, "%s", logmsg);
-	return -NF_ACCEPT;
-}
-
 static bool sctp_can_early_drop(const struct nf_conn *ct)
 {
 	switch (ct->proto.sctp.state) {
@@ -763,7 +766,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp4 = {
 	.print_conntrack	= sctp_print_conntrack,
 #endif
 	.packet 		= sctp_packet,
-	.error			= sctp_error,
 	.can_early_drop		= sctp_can_early_drop,
 	.me 			= THIS_MODULE,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
@@ -796,7 +798,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp6 = {
 	.print_conntrack	= sctp_print_conntrack,
 #endif
 	.packet 		= sctp_packet,
-	.error			= sctp_error,
 	.can_early_drop		= sctp_can_early_drop,
 	.me 			= THIS_MODULE,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 0c3e1f2f9013..14a1a9348fcc 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -725,27 +725,18 @@ static void tcp_error_log(const struct sk_buff *skb,
 }
 
 /* Protect conntrack agaist broken packets. Code taken from ipt_unclean.c.  */
-static int tcp_error(struct nf_conn *tmpl,
-		     struct sk_buff *skb,
-		     unsigned int dataoff,
-		     const struct nf_hook_state *state)
+static bool tcp_error(const struct tcphdr *th,
+		      struct sk_buff *skb,
+		      unsigned int dataoff,
+		      const struct nf_hook_state *state)
 {
-	const struct tcphdr *th;
-	struct tcphdr _tcph;
 	unsigned int tcplen = skb->len - dataoff;
-	u_int8_t tcpflags;
-
-	/* Smaller that minimal TCP header? */
-	th = skb_header_pointer(skb, dataoff, sizeof(_tcph), &_tcph);
-	if (th == NULL) {
-		tcp_error_log(skb, state, "short packet");
-		return -NF_ACCEPT;
-	}
+	u8 tcpflags;
 
 	/* Not whole TCP header or malformed packet */
 	if (th->doff*4 < sizeof(struct tcphdr) || tcplen < th->doff*4) {
 		tcp_error_log(skb, state, "truncated packet");
-		return -NF_ACCEPT;
+		return true;
 	}
 
 	/* Checksum invalid? Ignore.
@@ -757,17 +748,17 @@ static int tcp_error(struct nf_conn *tmpl,
 	    state->hook == NF_INET_PRE_ROUTING &&
 	    nf_checksum(skb, state->hook, dataoff, IPPROTO_TCP, state->pf)) {
 		tcp_error_log(skb, state, "bad checksum");
-		return -NF_ACCEPT;
+		return true;
 	}
 
 	/* Check TCP flags. */
 	tcpflags = (tcp_flag_byte(th) & ~(TCPHDR_ECE|TCPHDR_CWR|TCPHDR_PSH));
 	if (!tcp_valid_flags[tcpflags]) {
 		tcp_error_log(skb, state, "invalid tcp flag combination");
-		return -NF_ACCEPT;
+		return true;
 	}
 
-	return NF_ACCEPT;
+	return false;
 }
 
 static noinline bool tcp_new(struct nf_conn *ct, const struct sk_buff *skb,
@@ -863,6 +854,9 @@ static int tcp_packet(struct nf_conn *ct,
 	if (th == NULL)
 		return -NF_ACCEPT;
 
+	if (tcp_error(th, skb, dataoff, state))
+		return -NF_ACCEPT;
+
 	if (!nf_ct_is_confirmed(ct) && !tcp_new(ct, skb, dataoff, th))
 		return -NF_ACCEPT;
 
@@ -1548,7 +1542,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4 =
 	.print_conntrack 	= tcp_print_conntrack,
 #endif
 	.packet 		= tcp_packet,
-	.error			= tcp_error,
 	.can_early_drop		= tcp_can_early_drop,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.to_nlattr		= tcp_to_nlattr,
@@ -1582,7 +1575,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp6 =
 	.print_conntrack 	= tcp_print_conntrack,
 #endif
 	.packet 		= tcp_packet,
-	.error			= tcp_error,
 	.can_early_drop		= tcp_can_early_drop,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.nlattr_size		= TCP_NLATTR_SIZE,
-- 
2.11.0
