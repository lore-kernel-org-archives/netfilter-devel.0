From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: [PATCH net-next 1/1] sip: introduce nf_nat_sip_hooks
Date: Mon, 30 Sep 2013 15:51:51 +0200
Message-ID: <20130930135559.077109518@eitzenberger.org>
References: <20130930135150.440707982@eitzenberger.org>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:61426 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab3I3N4F (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:56:05 -0400
Content-Disposition: inline; filename=sip-introduce-nf_nat_sip_hooks.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There are currently seven different NAT hooks used in both
nf_conntrack_sip and nf_nat_sip, each of the hooks is exported in
nf_conntrack_sip, then set from the nf_nat_sip NAT helper.

And because each of them is exported there is quite some overhead
introduced due of this.

By introducing nf_nat_sip_hooks I am able to reduce both text/data
somewhat.  For nf_conntrack_sip e. g. I get

        text             data              bss              dec
old    15243             5256               32            20531
new    15010             5192               32            20234

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: net-next/net/netfilter/nf_conntrack_sip.c
===================================================================
--- net-next.orig/net/netfilter/nf_conntrack_sip.c
+++ net-next/net/netfilter/nf_conntrack_sip.c
@@ -52,66 +52,8 @@ module_param(sip_direct_media, int, 0600
 MODULE_PARM_DESC(sip_direct_media, "Expect Media streams between signalling "
 				   "endpoints only (default 1)");
 
-unsigned int (*nf_nat_sip_hook)(struct sk_buff *skb, unsigned int protoff,
-				unsigned int dataoff, const char **dptr,
-				unsigned int *datalen) __read_mostly;
-EXPORT_SYMBOL_GPL(nf_nat_sip_hook);
-
-void (*nf_nat_sip_seq_adjust_hook)(struct sk_buff *skb, unsigned int protoff,
-				   s16 off) __read_mostly;
-EXPORT_SYMBOL_GPL(nf_nat_sip_seq_adjust_hook);
-
-unsigned int (*nf_nat_sip_expect_hook)(struct sk_buff *skb,
-				       unsigned int protoff,
-				       unsigned int dataoff,
-				       const char **dptr,
-				       unsigned int *datalen,
-				       struct nf_conntrack_expect *exp,
-				       unsigned int matchoff,
-				       unsigned int matchlen) __read_mostly;
-EXPORT_SYMBOL_GPL(nf_nat_sip_expect_hook);
-
-unsigned int (*nf_nat_sdp_addr_hook)(struct sk_buff *skb, unsigned int protoff,
-				     unsigned int dataoff,
-				     const char **dptr,
-				     unsigned int *datalen,
-				     unsigned int sdpoff,
-				     enum sdp_header_types type,
-				     enum sdp_header_types term,
-				     const union nf_inet_addr *addr)
-				     __read_mostly;
-EXPORT_SYMBOL_GPL(nf_nat_sdp_addr_hook);
-
-unsigned int (*nf_nat_sdp_port_hook)(struct sk_buff *skb, unsigned int protoff,
-				     unsigned int dataoff,
-				     const char **dptr,
-				     unsigned int *datalen,
-				     unsigned int matchoff,
-				     unsigned int matchlen,
-				     u_int16_t port) __read_mostly;
-EXPORT_SYMBOL_GPL(nf_nat_sdp_port_hook);
-
-unsigned int (*nf_nat_sdp_session_hook)(struct sk_buff *skb,
-					unsigned int protoff,
-					unsigned int dataoff,
-					const char **dptr,
-					unsigned int *datalen,
-					unsigned int sdpoff,
-					const union nf_inet_addr *addr)
-					__read_mostly;
-EXPORT_SYMBOL_GPL(nf_nat_sdp_session_hook);
-
-unsigned int (*nf_nat_sdp_media_hook)(struct sk_buff *skb, unsigned int protoff,
-				      unsigned int dataoff,
-				      const char **dptr,
-				      unsigned int *datalen,
-				      struct nf_conntrack_expect *rtp_exp,
-				      struct nf_conntrack_expect *rtcp_exp,
-				      unsigned int mediaoff,
-				      unsigned int medialen,
-				      union nf_inet_addr *rtp_addr)
-				      __read_mostly;
-EXPORT_SYMBOL_GPL(nf_nat_sdp_media_hook);
+const struct nf_nat_sip_hooks *nf_nat_sip_hooks;
+EXPORT_SYMBOL_GPL(nf_nat_sip_hooks);
 
 static int string_len(const struct nf_conn *ct, const char *dptr,
 		      const char *limit, int *shift)
@@ -914,8 +856,7 @@ static int set_expected_rtp_rtcp(struct
 	int direct_rtp = 0, skip_expect = 0, ret = NF_DROP;
 	u_int16_t base_port;
 	__be16 rtp_port, rtcp_port;
-	typeof(nf_nat_sdp_port_hook) nf_nat_sdp_port;
-	typeof(nf_nat_sdp_media_hook) nf_nat_sdp_media;
+	const struct nf_nat_sip_hooks *hooks;
 
 	saddr = NULL;
 	if (sip_direct_media) {
@@ -972,10 +913,10 @@ static int set_expected_rtp_rtcp(struct
 	rtcp_port = htons(base_port + 1);
 
 	if (direct_rtp) {
-		nf_nat_sdp_port = rcu_dereference(nf_nat_sdp_port_hook);
-		if (nf_nat_sdp_port &&
-		    !nf_nat_sdp_port(skb, protoff, dataoff, dptr, datalen,
-				     mediaoff, medialen, ntohs(rtp_port)))
+		hooks = rcu_dereference(nf_nat_sip_hooks);
+		if (hooks &&
+		    !hooks->nsh_sdp_port(skb, protoff, dataoff, dptr, datalen,
+					 mediaoff, medialen, ntohs(rtp_port)))
 			goto err1;
 	}
 
@@ -996,11 +937,11 @@ static int set_expected_rtp_rtcp(struct
 	nf_ct_expect_init(rtcp_exp, class, nf_ct_l3num(ct), saddr, daddr,
 			  IPPROTO_UDP, NULL, &rtcp_port);
 
-	nf_nat_sdp_media = rcu_dereference(nf_nat_sdp_media_hook);
-	if (nf_nat_sdp_media && ct->status & IPS_NAT_MASK && !direct_rtp)
-		ret = nf_nat_sdp_media(skb, protoff, dataoff, dptr, datalen,
-				       rtp_exp, rtcp_exp,
-				       mediaoff, medialen, daddr);
+	hooks = rcu_dereference(nf_nat_sip_hooks);
+	if (hooks && ct->status & IPS_NAT_MASK && !direct_rtp)
+		ret = hooks->nsh_sdp_media(skb, protoff, dataoff, dptr,
+					   datalen, rtp_exp, rtcp_exp,
+					   mediaoff, medialen, daddr);
 	else {
 		if (nf_ct_expect_related(rtp_exp) == 0) {
 			if (nf_ct_expect_related(rtcp_exp) != 0)
@@ -1053,13 +994,12 @@ static int process_sdp(struct sk_buff *s
 	unsigned int caddr_len, maddr_len;
 	unsigned int i;
 	union nf_inet_addr caddr, maddr, rtp_addr;
+	const struct nf_nat_sip_hooks *hooks;
 	unsigned int port;
 	const struct sdp_media_type *t;
 	int ret = NF_ACCEPT;
-	typeof(nf_nat_sdp_addr_hook) nf_nat_sdp_addr;
-	typeof(nf_nat_sdp_session_hook) nf_nat_sdp_session;
 
-	nf_nat_sdp_addr = rcu_dereference(nf_nat_sdp_addr_hook);
+	hooks = rcu_dereference(nf_nat_sip_hooks);
 
 	/* Find beginning of session description */
 	if (ct_sip_get_sdp_header(ct, *dptr, 0, *datalen,
@@ -1127,11 +1067,12 @@ static int process_sdp(struct sk_buff *s
 		}
 
 		/* Update media connection address if present */
-		if (maddr_len && nf_nat_sdp_addr && ct->status & IPS_NAT_MASK) {
-			ret = nf_nat_sdp_addr(skb, protoff, dataoff,
-					      dptr, datalen, mediaoff,
-					      SDP_HDR_CONNECTION, SDP_HDR_MEDIA,
-					      &rtp_addr);
+		if (maddr_len && hooks && ct->status & IPS_NAT_MASK) {
+			ret = hooks->nsh_sdp_addr(skb, protoff, dataoff,
+						  dptr, datalen, mediaoff,
+						  SDP_HDR_CONNECTION,
+						  SDP_HDR_MEDIA,
+						  &rtp_addr);
 			if (ret != NF_ACCEPT) {
 				nf_ct_helper_log(skb, ct, "cannot mangle SDP");
 				return ret;
@@ -1141,10 +1082,11 @@ static int process_sdp(struct sk_buff *s
 	}
 
 	/* Update session connection and owner addresses */
-	nf_nat_sdp_session = rcu_dereference(nf_nat_sdp_session_hook);
-	if (nf_nat_sdp_session && ct->status & IPS_NAT_MASK)
-		ret = nf_nat_sdp_session(skb, protoff, dataoff,
-					 dptr, datalen, sdpoff, &rtp_addr);
+	hooks = rcu_dereference(nf_nat_sip_hooks);
+	if (hooks && ct->status & IPS_NAT_MASK)
+		ret = hooks->nsh_sdp_session(skb, protoff, dataoff,
+					     dptr, datalen, sdpoff,
+					     &rtp_addr);
 
 	return ret;
 }
@@ -1244,11 +1186,11 @@ static int process_register_request(stru
 	unsigned int matchoff, matchlen;
 	struct nf_conntrack_expect *exp;
 	union nf_inet_addr *saddr, daddr;
+	const struct nf_nat_sip_hooks *hooks;
 	__be16 port;
 	u8 proto;
 	unsigned int expires = 0;
 	int ret;
-	typeof(nf_nat_sip_expect_hook) nf_nat_sip_expect;
 
 	/* Expected connections can not register again. */
 	if (ct->status & IPS_EXPECTED)
@@ -1311,9 +1253,9 @@ static int process_register_request(stru
 	exp->helper = nfct_help(ct)->helper;
 	exp->flags = NF_CT_EXPECT_PERMANENT | NF_CT_EXPECT_INACTIVE;
 
-	nf_nat_sip_expect = rcu_dereference(nf_nat_sip_expect_hook);
-	if (nf_nat_sip_expect && ct->status & IPS_NAT_MASK)
-		ret = nf_nat_sip_expect(skb, protoff, dataoff, dptr, datalen,
+	hooks = rcu_dereference(nf_nat_sip_hooks);
+	if (hooks && ct->status & IPS_NAT_MASK)
+		ret = hooks->nsh_expect(skb, protoff, dataoff, dptr, datalen,
 					exp, matchoff, matchlen);
 	else {
 		if (nf_ct_expect_related(exp) != 0) {
@@ -1517,7 +1459,7 @@ static int process_sip_msg(struct sk_buf
 			   unsigned int protoff, unsigned int dataoff,
 			   const char **dptr, unsigned int *datalen)
 {
-	typeof(nf_nat_sip_hook) nf_nat_sip;
+	const struct nf_nat_sip_hooks *hooks;
 	int ret;
 
 	if (strnicmp(*dptr, "SIP/2.0 ", strlen("SIP/2.0 ")) != 0)
@@ -1526,9 +1468,9 @@ static int process_sip_msg(struct sk_buf
 		ret = process_sip_response(skb, protoff, dataoff, dptr, datalen);
 
 	if (ret == NF_ACCEPT && ct->status & IPS_NAT_MASK) {
-		nf_nat_sip = rcu_dereference(nf_nat_sip_hook);
-		if (nf_nat_sip && !nf_nat_sip(skb, protoff, dataoff,
-					      dptr, datalen)) {
+		hooks = rcu_dereference(nf_nat_sip_hooks);
+		if (hooks && !hooks->nsh_msg(skb, protoff, dataoff,
+									dptr, datalen)) {
 			nf_ct_helper_log(skb, ct, "cannot NAT SIP message");
 			ret = NF_DROP;
 		}
@@ -1548,7 +1490,6 @@ static int sip_help_tcp(struct sk_buff *
 	s16 diff, tdiff = 0;
 	int ret = NF_ACCEPT;
 	bool term;
-	typeof(nf_nat_sip_seq_adjust_hook) nf_nat_sip_seq_adjust;
 
 	if (ctinfo != IP_CT_ESTABLISHED &&
 	    ctinfo != IP_CT_ESTABLISHED_REPLY)
@@ -1612,9 +1553,11 @@ static int sip_help_tcp(struct sk_buff *
 	}
 
 	if (ret == NF_ACCEPT && ct->status & IPS_NAT_MASK) {
-		nf_nat_sip_seq_adjust = rcu_dereference(nf_nat_sip_seq_adjust_hook);
-		if (nf_nat_sip_seq_adjust)
-			nf_nat_sip_seq_adjust(skb, protoff, tdiff);
+		const struct nf_nat_sip_hooks *hooks;
+
+		hooks = rcu_dereference(nf_nat_sip_hooks);
+		if (hooks)
+			hooks->nsh_seq_adjust(skb, protoff, tdiff);
 	}
 
 	return ret;
Index: net-next/include/linux/netfilter/nf_conntrack_sip.h
===================================================================
--- net-next.orig/include/linux/netfilter/nf_conntrack_sip.h
+++ net-next/include/linux/netfilter/nf_conntrack_sip.h
@@ -107,55 +107,65 @@ enum sdp_header_types {
 	SDP_HDR_MEDIA,
 };
 
-extern unsigned int (*nf_nat_sip_hook)(struct sk_buff *skb,
+struct nf_nat_sip_hooks {
+	unsigned int (* nsh_msg)(struct sk_buff *skb,
+				 unsigned int protoff,
+				 unsigned int dataoff,
+				 const char **dptr,
+				 unsigned int *datalen);
+
+	void (* nsh_seq_adjust)(struct sk_buff *skb,
+				unsigned int protoff, s16 off);
+
+	unsigned int (* nsh_expect)(struct sk_buff *skb,
+				    unsigned int protoff,
+				    unsigned int dataoff,
+				    const char **dptr,
+				    unsigned int *datalen,
+				    struct nf_conntrack_expect *exp,
+				    unsigned int matchoff,
+				    unsigned int matchlen);
+
+	unsigned int (* nsh_sdp_addr)(struct sk_buff *skb,
+				      unsigned int protoff,
+				      unsigned int dataoff,
+				      const char **dptr,
+				      unsigned int *datalen,
+				      unsigned int sdpoff,
+				      enum sdp_header_types type,
+				      enum sdp_header_types term,
+				      const union nf_inet_addr *addr);
+
+	unsigned int (* nsh_sdp_port)(struct sk_buff *skb,
+				      unsigned int protoff,
+				      unsigned int dataoff,
+				      const char **dptr,
+				      unsigned int *datalen,
+				      unsigned int matchoff,
+				      unsigned int matchlen,
+				      u_int16_t port);
+
+	unsigned int (* nsh_sdp_session)(struct sk_buff *skb,
+					 unsigned int protoff,
+					 unsigned int dataoff,
+					 const char **dptr,
+					 unsigned int *datalen,
+					 unsigned int sdpoff,
+					 const union nf_inet_addr *addr);
+
+	unsigned int (* nsh_sdp_media)(struct sk_buff *skb,
 				       unsigned int protoff,
 				       unsigned int dataoff,
 				       const char **dptr,
-				       unsigned int *datalen);
-extern void (*nf_nat_sip_seq_adjust_hook)(struct sk_buff *skb,
-					  unsigned int protoff, s16 off);
-extern unsigned int (*nf_nat_sip_expect_hook)(struct sk_buff *skb,
-					      unsigned int protoff,
-					      unsigned int dataoff,
-					      const char **dptr,
-					      unsigned int *datalen,
-					      struct nf_conntrack_expect *exp,
-					      unsigned int matchoff,
-					      unsigned int matchlen);
-extern unsigned int (*nf_nat_sdp_addr_hook)(struct sk_buff *skb,
-					    unsigned int protoff,
-					    unsigned int dataoff,
-					    const char **dptr,
-					    unsigned int *datalen,
-					    unsigned int sdpoff,
-					    enum sdp_header_types type,
-					    enum sdp_header_types term,
-					    const union nf_inet_addr *addr);
-extern unsigned int (*nf_nat_sdp_port_hook)(struct sk_buff *skb,
-					    unsigned int protoff,
-					    unsigned int dataoff,
-					    const char **dptr,
-					    unsigned int *datalen,
-					    unsigned int matchoff,
-					    unsigned int matchlen,
-					    u_int16_t port);
-extern unsigned int (*nf_nat_sdp_session_hook)(struct sk_buff *skb,
-					       unsigned int protoff,
-					       unsigned int dataoff,
-					       const char **dptr,
-					       unsigned int *datalen,
-					       unsigned int sdpoff,
-					       const union nf_inet_addr *addr);
-extern unsigned int (*nf_nat_sdp_media_hook)(struct sk_buff *skb,
-					     unsigned int protoff,
-					     unsigned int dataoff,
-					     const char **dptr,
-					     unsigned int *datalen,
-					     struct nf_conntrack_expect *rtp_exp,
-					     struct nf_conntrack_expect *rtcp_exp,
-					     unsigned int mediaoff,
-					     unsigned int medialen,
-					     union nf_inet_addr *rtp_addr);
+				       unsigned int *datalen,
+				       struct nf_conntrack_expect *rtp_exp,
+				       struct nf_conntrack_expect *rtcp_exp,
+				       unsigned int mediaoff,
+				       unsigned int medialen,
+				       union nf_inet_addr *rtp_addr);
+};
+extern const struct nf_nat_sip_hooks *nf_nat_sip_hooks;
+
 
 extern int ct_sip_parse_request(const struct nf_conn *ct,
 				const char *dptr, unsigned int datalen,
Index: net-next/net/netfilter/nf_nat_sip.c
===================================================================
--- net-next.orig/net/netfilter/nf_nat_sip.c
+++ net-next/net/netfilter/nf_nat_sip.c
@@ -625,33 +625,26 @@ static struct nf_ct_helper_expectfn sip_
 
 static void __exit nf_nat_sip_fini(void)
 {
-	RCU_INIT_POINTER(nf_nat_sip_hook, NULL);
-	RCU_INIT_POINTER(nf_nat_sip_seq_adjust_hook, NULL);
-	RCU_INIT_POINTER(nf_nat_sip_expect_hook, NULL);
-	RCU_INIT_POINTER(nf_nat_sdp_addr_hook, NULL);
-	RCU_INIT_POINTER(nf_nat_sdp_port_hook, NULL);
-	RCU_INIT_POINTER(nf_nat_sdp_session_hook, NULL);
-	RCU_INIT_POINTER(nf_nat_sdp_media_hook, NULL);
+	RCU_INIT_POINTER(nf_nat_sip_hooks, NULL);
+
 	nf_ct_helper_expectfn_unregister(&sip_nat);
 	synchronize_rcu();
 }
 
+static const struct nf_nat_sip_hooks sip_hooks = {
+	.nsh_msg = nf_nat_sip,
+	.nsh_seq_adjust = nf_nat_sip_seq_adjust,
+	.nsh_expect = nf_nat_sip_expect,
+	.nsh_sdp_addr = nf_nat_sdp_addr,
+	.nsh_sdp_port = nf_nat_sdp_port,
+	.nsh_sdp_session = nf_nat_sdp_session,
+	.nsh_sdp_media = nf_nat_sdp_media,
+};
+
 static int __init nf_nat_sip_init(void)
 {
-	BUG_ON(nf_nat_sip_hook != NULL);
-	BUG_ON(nf_nat_sip_seq_adjust_hook != NULL);
-	BUG_ON(nf_nat_sip_expect_hook != NULL);
-	BUG_ON(nf_nat_sdp_addr_hook != NULL);
-	BUG_ON(nf_nat_sdp_port_hook != NULL);
-	BUG_ON(nf_nat_sdp_session_hook != NULL);
-	BUG_ON(nf_nat_sdp_media_hook != NULL);
-	RCU_INIT_POINTER(nf_nat_sip_hook, nf_nat_sip);
-	RCU_INIT_POINTER(nf_nat_sip_seq_adjust_hook, nf_nat_sip_seq_adjust);
-	RCU_INIT_POINTER(nf_nat_sip_expect_hook, nf_nat_sip_expect);
-	RCU_INIT_POINTER(nf_nat_sdp_addr_hook, nf_nat_sdp_addr);
-	RCU_INIT_POINTER(nf_nat_sdp_port_hook, nf_nat_sdp_port);
-	RCU_INIT_POINTER(nf_nat_sdp_session_hook, nf_nat_sdp_session);
-	RCU_INIT_POINTER(nf_nat_sdp_media_hook, nf_nat_sdp_media);
+	BUG_ON(nf_nat_sip_hooks != NULL);
+	RCU_INIT_POINTER(nf_nat_sip_hooks, &sip_hooks);
 	nf_ct_helper_expectfn_register(&sip_nat);
 	return 0;
 }

