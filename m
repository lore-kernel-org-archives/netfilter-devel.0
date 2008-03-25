From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 19/32]: nf_conntrack_sip: support method specific request/response handling
Date: Tue, 25 Mar 2008 15:15:17 +0100 (MET)
Message-ID: <20080325141516.10539.13331.sendpatchset@localhost.localdomain>
References: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32944 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbYCYOPS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:15:18 -0400
In-Reply-To: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sip: support method specific request/response handling

Add support for per-method request/response handlers and perform SDP
parsing for INVITE/UPDATE requests and for all informational and
successful responses.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 607087bf4071e8b15660d0ef2dbed696697a4516
tree cdebc3c60b5346536a993586c2004d7215d4f5ed
parent 19639f6bcaed278e3fbc60d69f573e5c117bc4f2
author Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 12:45:06 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 14:09:56 +0100

 include/linux/netfilter/nf_conntrack_sip.h |   20 +++++
 net/netfilter/nf_conntrack_sip.c           |  107 +++++++++++++++++++++++++---
 2 files changed, 117 insertions(+), 10 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_sip.h b/include/linux/netfilter/nf_conntrack_sip.h
index 68a0d6a..da93e80 100644
--- a/include/linux/netfilter/nf_conntrack_sip.h
+++ b/include/linux/netfilter/nf_conntrack_sip.h
@@ -5,6 +5,25 @@
 #define SIP_PORT	5060
 #define SIP_TIMEOUT	3600
 
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
@@ -35,6 +54,7 @@ struct sip_header {
 	__SIP_HDR(__name, NULL, __search, __match)
 
 enum sip_header_types {
+	SIP_HDR_CSEQ,
 	SIP_HDR_FROM,
 	SIP_HDR_TO,
 	SIP_HDR_CONTACT,
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 96bedb5..1be949f 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -212,6 +212,7 @@ EXPORT_SYMBOL_GPL(ct_sip_parse_request);
  * equivalent to multiple headers.
  */
 static const struct sip_header ct_sip_hdrs[] = {
+	[SIP_HDR_CSEQ]			= SIP_HDR("CSeq", NULL, NULL, digits_len),
 	[SIP_HDR_FROM]			= SIP_HDR("From", "f", "sip:", skp_epaddr_len),
 	[SIP_HDR_TO]			= SIP_HDR("To", "t", "sip:", skp_epaddr_len),
 	[SIP_HDR_CONTACT]		= SIP_HDR("Contact", "m", "sip:", skp_epaddr_len),
@@ -566,7 +567,8 @@ static int set_expected_rtp(struct sk_buff *skb,
 }
 
 static int process_sdp(struct sk_buff *skb,
-		       const char **dptr, unsigned int *datalen)
+		       const char **dptr, unsigned int *datalen,
+		       unsigned int cseq)
 {
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
@@ -600,6 +602,96 @@ static int process_sdp(struct sk_buff *skb,
 
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
@@ -634,15 +726,10 @@ static int sip_help(struct sk_buff *skb,
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
