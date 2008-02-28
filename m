From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 20/32]: nf_conntrack_sip: support method specific request/response handling
Date: Thu, 28 Feb 2008 13:00:24 +0100 (MET)
Message-ID: <20080228120015.29267.90348.sendpatchset@localhost.localdomain>
References: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50014 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757562AbYB1MAZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2008 07:00:25 -0500
In-Reply-To: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sip: support method specific request/response handling

Add support for per-method request/response handlers and perform SDP
parsing for INVITE/UPDATE requests and for all informational and
successful responses.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 76ff8089d5abc23d9cc6b31f7d1a7dcdd9579567
tree 16f31f2ca11985a5ecec3d0e6704647a10b546c4
parent 9a0620a58527f73990638597813e6c759cfbb10c
author Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:26 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:26 +0100

 include/linux/netfilter/nf_conntrack_sip.h |   20 +++++
 net/netfilter/nf_conntrack_sip.c           |  107 +++++++++++++++++++++++++---
 2 files changed, 117 insertions(+), 10 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_sip.h b/include/linux/netfilter/nf_conntrack_sip.h
index 1f518d3..518fdf1 100644
--- a/include/linux/netfilter/nf_conntrack_sip.h
+++ b/include/linux/netfilter/nf_conntrack_sip.h
@@ -11,6 +11,25 @@ enum sip_expectation_classes {
 };
 #define SIP_EXPECT_MAX	(__SIP_EXPECT_MAX - 1)
 
+struct sip_handler {
+	const char	*method;
+	unsigned int	len;
+	int		(*request)(struct sk_buff *skb,
+				   const char **dptr, unsigned int *datalen,
+				   unsigned int cseq);
+	int		(*response)(struct sk_buff *skb,
+				    const char **dptr, unsigned int *datalen,
+				    unsigned int cseq, unsigned int code);
+};
+
+#define SIP_HANDLER(__method, __request, __response)			\
+{									\
+	.method		= (__method),					\
+	.len		= sizeof(__method) - 1,				\
+	.request	= (__request),					\
+	.response	= (__response),					\
+}
+
 struct sip_header {
 	const char	*name;
 	const char	*cname;
@@ -41,6 +60,7 @@ struct sip_header {
 	__SIP_HDR(__name, NULL, __search, __match)
 
 enum sip_header_types {
+	SIP_HDR_CSEQ,
 	SIP_HDR_FROM,
 	SIP_HDR_TO,
 	SIP_HDR_CONTACT,
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 556f7f6..93e8565 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -221,6 +221,7 @@ EXPORT_SYMBOL_GPL(ct_sip_parse_request);
  * equivalent to multiple headers.
  */
 static const struct sip_header ct_sip_hdrs[] = {
+	[SIP_HDR_CSEQ]			= SIP_HDR("CSeq", NULL, NULL, digits_len),
 	[SIP_HDR_FROM]			= SIP_HDR("From", "f", "sip:", skp_epaddr_len),
 	[SIP_HDR_TO]			= SIP_HDR("To", "t", "sip:", skp_epaddr_len),
 	[SIP_HDR_CONTACT]		= SIP_HDR("Contact", "m", "sip:", skp_epaddr_len),
@@ -575,7 +576,8 @@ static int set_expected_rtp(struct sk_buff *skb,
 }
 
 static int process_sdp(struct sk_buff *skb,
-		       const char **dptr, unsigned int *datalen)
+		       const char **dptr, unsigned int *datalen,
+		       unsigned int cseq)
 {
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
@@ -609,6 +611,96 @@ static int process_sdp(struct sk_buff *skb,
 
 	return set_expected_rtp(skb, dptr, datalen, &addr, htons(port));
 }
+static int process_invite_response(struct sk_buff *skb,
+				   const char **dptr, unsigned int *datalen,
+				   unsigned int cseq, unsigned int code)
+{
+	if ((code >= 100 && code <= 199) ||
+	    (code >= 200 && code <= 299))
+		return process_sdp(skb, dptr, datalen, cseq);
+
+	return NF_ACCEPT;
+}
+
+static int process_update_response(struct sk_buff *skb,
+				   const char **dptr, unsigned int *datalen,
+				   unsigned int cseq, unsigned int code)
+{
+	if ((code >= 100 && code <= 199) ||
+	    (code >= 200 && code <= 299))
+		return process_sdp(skb, dptr, datalen, cseq);
+
+	return NF_ACCEPT;
+}
+
+static const struct sip_handler sip_handlers[] = {
+	SIP_HANDLER("INVITE", process_sdp, process_invite_response),
+	SIP_HANDLER("UPDATE", process_sdp, process_update_response),
+};
+
+static int process_sip_response(struct sk_buff *skb,
+				const char **dptr, unsigned int *datalen)
+{
+	static const struct sip_handler *handler;
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
+	unsigned int matchoff, matchlen;
+	unsigned int code, cseq, dataoff, i;
+
+	if (*datalen < strlen("SIP/2.0 200"))
+		return NF_ACCEPT;
+	code = simple_strtoul(*dptr + strlen("SIP/2.0 "), NULL, 10);
+	if (!code)
+		return NF_DROP;
+
+	if (ct_sip_get_header(ct, *dptr, 0, *datalen, SIP_HDR_CSEQ,
+			      &matchoff, &matchlen) <= 0)
+		return NF_DROP;
+	cseq = simple_strtoul(*dptr + matchoff, NULL, 10);
+	if (!cseq)
+		return NF_DROP;
+	dataoff = matchoff + matchlen + 1;
+
+	for (i = 0; i < ARRAY_SIZE(sip_handlers); i++) {
+		handler = &sip_handlers[i];
+		if (handler->response == NULL)
+			continue;
+		if (*datalen < dataoff + handler->len ||
+		    strnicmp(*dptr + dataoff, handler->method, handler->len))
+			continue;
+		return handler->response(skb, dptr, datalen, cseq, code);
+	}
+	return NF_ACCEPT;
+}
+
+static int process_sip_request(struct sk_buff *skb,
+			       const char **dptr, unsigned int *datalen)
+{
+	static const struct sip_handler *handler;
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
+	unsigned int matchoff, matchlen;
+	unsigned int cseq, i;
+
+	for (i = 0; i < ARRAY_SIZE(sip_handlers); i++) {
+		handler = &sip_handlers[i];
+		if (handler->request == NULL)
+			continue;
+		if (*datalen < handler->len ||
+		    strnicmp(*dptr, handler->method, handler->len))
+			continue;
+
+		if (ct_sip_get_header(ct, *dptr, 0, *datalen, SIP_HDR_CSEQ,
+				      &matchoff, &matchlen) <= 0)
+			return NF_DROP;
+		cseq = simple_strtoul(*dptr + matchoff, NULL, 10);
+		if (!cseq)
+			return NF_DROP;
+
+		return handler->request(skb, dptr, datalen, cseq);
+	}
+	return NF_ACCEPT;
+}
 
 static int sip_help(struct sk_buff *skb,
 		    unsigned int protoff,
@@ -643,15 +735,10 @@ static int sip_help(struct sk_buff *skb,
 	if (datalen < strlen("SIP/2.0 200"))
 		return NF_ACCEPT;
 
-	/* RTP info only in some SDP pkts */
-	if (strnicmp(dptr, "INVITE", strlen("INVITE")) != 0 &&
-	    strnicmp(dptr, "UPDATE", strlen("UPDATE")) != 0 &&
-	    strnicmp(dptr, "SIP/2.0 180", strlen("SIP/2.0 180")) != 0 &&
-	    strnicmp(dptr, "SIP/2.0 183", strlen("SIP/2.0 183")) != 0 &&
-	    strnicmp(dptr, "SIP/2.0 200", strlen("SIP/2.0 200")) != 0)
-		return NF_ACCEPT;
-
-	return process_sdp(skb, &dptr, &datalen);
+	if (strnicmp(dptr, "SIP/2.0 ", strlen("SIP/2.0 ")) != 0)
+		return process_sip_request(skb, &dptr, &datalen);
+	else
+		return process_sip_response(skb, &dptr, &datalen);
 }
 
 static struct nf_conntrack_helper sip[MAX_PORTS][2] __read_mostly;
