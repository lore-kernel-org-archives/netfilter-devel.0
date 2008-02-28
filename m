From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 31/32]: nf_conntrack_sip: support multiple media channels
Date: Thu, 28 Feb 2008 13:00:38 +0100 (MET)
Message-ID: <20080228120029.29267.33206.sendpatchset@localhost.localdomain>
References: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50035 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757658AbYB1MAj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2008 07:00:39 -0500
In-Reply-To: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sip: support multiple media channels

Add support for multiple media channels and use it to create
expectations for video streams when present.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f6dadb448bba21aaeb55b48ac60407a8a63e05a4
tree 9c17ba8d60f960db270037bbd5865b77a61a68d3
parent 9661c24d47ff1e8f17663146f3d57761fd810f5f
author Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:37 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:37 +0100

 include/linux/netfilter/nf_conntrack_sip.h |   14 +++
 include/net/netfilter/nf_conntrack.h       |    2 
 net/netfilter/nf_conntrack_sip.c           |  121 +++++++++++++++++++++-------
 3 files changed, 105 insertions(+), 32 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_sip.h b/include/linux/netfilter/nf_conntrack_sip.h
index eca3ad3..71fa3eb 100644
--- a/include/linux/netfilter/nf_conntrack_sip.h
+++ b/include/linux/netfilter/nf_conntrack_sip.h
@@ -12,10 +12,24 @@ struct nf_ct_sip_master {
 enum sip_expectation_classes {
 	SIP_EXPECT_SIGNALLING,
 	SIP_EXPECT_AUDIO,
+	SIP_EXPECT_VIDEO,
 	__SIP_EXPECT_MAX
 };
 #define SIP_EXPECT_MAX	(__SIP_EXPECT_MAX - 1)
 
+struct sdp_media_type {
+	const char			*name;
+	unsigned int			len;
+	enum sip_expectation_classes	class;
+};
+
+#define SDP_MEDIA_TYPE(__name, __class)					\
+{									\
+	.name	= (__name),						\
+	.len	= sizeof(__name) - 1,					\
+	.class	= (__class),						\
+}
+
 struct sip_handler {
 	const char	*method;
 	unsigned int	len;
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 4a4f870..a3567a7 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -78,7 +78,7 @@ do {									\
 struct nf_conntrack_helper;
 
 /* Must be kept in sync with the classes defined by helpers */
-#define NF_CT_MAX_EXPECT_CLASSES	2
+#define NF_CT_MAX_EXPECT_CLASSES	3
 
 /* nf_conn feature for connections that have a helper */
 struct nf_conn_help {
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 9ced70f..a12be9b 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -112,6 +112,21 @@ static int digits_len(const struct nf_conn *ct, const char *dptr,
 	return len;
 }
 
+/* get media type + port length */
+static int media_len(const struct nf_conn *ct, const char *dptr,
+		     const char *limit, int *shift)
+{
+	int len = string_len(ct, dptr, limit, shift);
+
+	dptr += len;
+	if (dptr >= limit || *dptr != ' ')
+		return 0;
+	len++;
+	dptr++;
+
+	return len + digits_len(ct, dptr, limit, shift);
+}
+
 static int parse_addr(const struct nf_conn *ct, const char *cp,
                       const char **endp, union nf_inet_addr *addr,
                       const char *limit)
@@ -572,7 +587,7 @@ static const struct sip_header ct_sdp_hdrs[] = {
 	[SDP_HDR_CONNECTION_IP4]	= SDP_HDR("c=", "IN IP4 ", epaddr_len),
 	[SDP_HDR_OWNER_IP6]		= SDP_HDR("o=", "IN IP6 ", epaddr_len),
 	[SDP_HDR_CONNECTION_IP6]	= SDP_HDR("c=", "IN IP6 ", epaddr_len),
-	[SDP_HDR_MEDIA]			= SDP_HDR("m=", "audio ", digits_len),
+	[SDP_HDR_MEDIA]			= SDP_HDR("m=", NULL, media_len),
 };
 
 /* Linear string search within SDP header values */
@@ -714,6 +729,7 @@ static void flush_expectations(struct nf_conn *ct, int media)
 static int set_expected_rtp_rtcp(struct sk_buff *skb,
 				 const char **dptr, unsigned int *datalen,
 				 union nf_inet_addr *daddr, __be16 port,
+				 enum sip_expectation_classes class,
 				 unsigned int mediaoff, unsigned int medialen)
 {
 	struct nf_conntrack_expect *exp, *rtp_exp, *rtcp_exp;
@@ -752,7 +768,7 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb,
 	exp = __nf_ct_expect_find(&tuple);
 	if (exp && exp->master != ct &&
 	    nfct_help(exp->master)->helper == nfct_help(ct)->helper &&
-	    exp->class == SIP_EXPECT_AUDIO)
+	    exp->class == class)
 		skip_expect = 1;
 	spin_unlock_bh(&nf_conntrack_lock);
 
@@ -766,13 +782,13 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb,
 	rtp_exp = nf_ct_expect_alloc(ct);
 	if (rtp_exp == NULL)
 		goto err1;
-	nf_ct_expect_init(rtp_exp, SIP_EXPECT_AUDIO, family, saddr, daddr,
+	nf_ct_expect_init(rtp_exp, class, family, saddr, daddr,
 			  IPPROTO_UDP, NULL, &rtp_port);
 
 	rtcp_exp = nf_ct_expect_alloc(ct);
 	if (rtcp_exp == NULL)
 		goto err2;
-	nf_ct_expect_init(rtcp_exp, SIP_EXPECT_AUDIO, family, saddr, daddr,
+	nf_ct_expect_init(rtcp_exp, class, family, saddr, daddr,
 			  IPPROTO_UDP, NULL, &rtcp_port);
 
 	nf_nat_sdp_media = rcu_dereference(nf_nat_sdp_media_hook);
@@ -794,6 +810,28 @@ err1:
 	return ret;
 }
 
+static const struct sdp_media_type sdp_media_types[] = {
+	SDP_MEDIA_TYPE("audio ", SIP_EXPECT_AUDIO),
+	SDP_MEDIA_TYPE("video ", SIP_EXPECT_VIDEO),
+};
+
+static const struct sdp_media_type *sdp_media_type(const char *dptr,
+						   unsigned int matchoff,
+						   unsigned int matchlen)
+{
+	const struct sdp_media_type *t;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(sdp_media_types); i++) {
+		t = &sdp_media_types[i];
+		if (matchlen < t->len ||
+		    strncmp(dptr + matchoff, t->name, t->len))
+			continue;
+		return t;
+	}
+	return NULL;
+}
+
 static int process_sdp(struct sk_buff *skb,
 		       const char **dptr, unsigned int *datalen,
 		       unsigned int cseq)
@@ -805,13 +843,16 @@ static int process_sdp(struct sk_buff *skb,
 	unsigned int mediaoff, medialen;
 	unsigned int sdpoff;
 	unsigned int caddr_len, maddr_len;
+	unsigned int i;
 	union nf_inet_addr caddr, maddr, rtp_addr;
 	unsigned int port;
 	enum sdp_header_types c_hdr;
-	int ret;
+	const struct sdp_media_type *t;
+	int ret = NF_ACCEPT;
 	typeof(nf_nat_sdp_addr_hook) nf_nat_sdp_addr;
 	typeof(nf_nat_sdp_session_hook) nf_nat_sdp_session;
 
+	nf_nat_sdp_addr = rcu_dereference(nf_nat_sdp_addr_hook);
 	c_hdr = family == AF_INET ? SDP_HDR_CONNECTION_IP4 :
 				    SDP_HDR_CONNECTION_IP6;
 
@@ -831,41 +872,55 @@ static int process_sdp(struct sk_buff *skb,
 				  &matchoff, &matchlen, &caddr) > 0)
 		caddr_len = matchlen;
 
-	if (ct_sip_get_sdp_header(ct, *dptr, sdpoff, *datalen,
-				  SDP_HDR_MEDIA, SDP_HDR_UNSPEC,
-				  &mediaoff, &medialen) <= 0)
-		return NF_ACCEPT;
+	mediaoff = sdpoff;
+	for (i = 0; i < ARRAY_SIZE(sdp_media_types); ) {
+		if (ct_sip_get_sdp_header(ct, *dptr, mediaoff, *datalen,
+					  SDP_HDR_MEDIA, SDP_HDR_UNSPEC,
+					  &mediaoff, &medialen) <= 0)
+			break;
 
-	port = simple_strtoul(*dptr + mediaoff, NULL, 10);
-	if (port < 1024 || port > 65535)
-		return NF_DROP;
+		/* Get media type and port number. A media port value of zero
+		 * indicates an inactive stream. */
+		t = sdp_media_type(*dptr, mediaoff, medialen);
+		if (!t) {
+			mediaoff += medialen;
+			continue;
+		}
+		mediaoff += t->len;
+		medialen -= t->len;
 
-	/* The media description overrides the session description. */
-	maddr_len = 0;
-	if (ct_sip_parse_sdp_addr(ct, *dptr, mediaoff, *datalen,
-				  c_hdr, SDP_HDR_MEDIA,
-				  &matchoff, &matchlen, &maddr) > 0) {
-		maddr_len = matchlen;
-		memcpy(&rtp_addr, &maddr, sizeof(rtp_addr));
-	} else if (caddr_len)
-		memcpy(&rtp_addr, &caddr, sizeof(rtp_addr));
-	else
-		return NF_DROP;
+		port = simple_strtoul(*dptr + mediaoff, NULL, 10);
+		if (port == 0)
+			continue;
+		if (port < 1024 || port > 65535)
+			return NF_DROP;
 
-	ret = set_expected_rtp_rtcp(skb, dptr, datalen, &rtp_addr, htons(port),
-				    mediaoff, medialen);
-	if (ret != NF_ACCEPT)
-		return ret;
+		/* The media description overrides the session description. */
+		maddr_len = 0;
+		if (ct_sip_parse_sdp_addr(ct, *dptr, mediaoff, *datalen,
+					  c_hdr, SDP_HDR_MEDIA,
+					  &matchoff, &matchlen, &maddr) > 0) {
+			maddr_len = matchlen;
+			memcpy(&rtp_addr, &maddr, sizeof(rtp_addr));
+		} else if (caddr_len)
+			memcpy(&rtp_addr, &caddr, sizeof(rtp_addr));
+		else
+			return NF_DROP;
+
+		ret = set_expected_rtp_rtcp(skb, dptr, datalen,
+					    &rtp_addr, htons(port), t->class,
+					    mediaoff, medialen);
+		if (ret != NF_ACCEPT)
+			return ret;
 
-	/* Update media connection address if present */
-	if (maddr_len) {
-		nf_nat_sdp_addr = rcu_dereference(nf_nat_sdp_addr_hook);
-		if (nf_nat_sdp_addr && ct->status & IPS_NAT_MASK) {
+		/* Update media connection address if present */
+		if (maddr_len && nf_nat_sdp_addr && ct->status & IPS_NAT_MASK) {
 			ret = nf_nat_sdp_addr(skb, dptr, mediaoff, datalen,
 					      c_hdr, SDP_HDR_MEDIA, &rtp_addr);
 			if (ret != NF_ACCEPT)
 				return ret;
 		}
+		i++;
 	}
 
 	/* Update session connection and owner addresses */
@@ -1219,6 +1274,10 @@ static const struct nf_conntrack_expect_policy sip_exp_policy[SIP_EXPECT_MAX + 1
 		.max_expected	= 2 * IP_CT_DIR_MAX,
 		.timeout	= 3 * 60,
 	},
+	[SIP_EXPECT_VIDEO] = {
+		.max_expected	= 2 * IP_CT_DIR_MAX,
+		.timeout	= 3 * 60,
+	},
 };
 
 static void nf_conntrack_sip_fini(void)
