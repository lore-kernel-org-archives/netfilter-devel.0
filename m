From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 17/32]: nf_conntrack_sip: introduce SIP-URI parsing helper
Date: Thu, 28 Feb 2008 13:00:20 +0100 (MET)
Message-ID: <20080228120011.29267.86678.sendpatchset@localhost.localdomain>
References: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50006 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757378AbYB1MAV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2008 07:00:21 -0500
In-Reply-To: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sip: introduce SIP-URI parsing helper

Introduce a helper function to parse a SIP-URI in a header value, optionally
iterating through all headers of this kind.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 517cd32eee04d9bdcfe97160bfd9ecb3a636439b
tree e16f1debde64b8257d878378d03fc5abc4881a55
parent ad68c0360489e4b074598ccdaff30d0651198fb2
author Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:23 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:23 +0100

 include/linux/netfilter/nf_conntrack_sip.h |    5 +
 net/netfilter/nf_conntrack_sip.c           |  107 ++++++++++++++++++++++++++++
 2 files changed, 112 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_sip.h b/include/linux/netfilter/nf_conntrack_sip.h
index fac85c6..080b2a2 100644
--- a/include/linux/netfilter/nf_conntrack_sip.h
+++ b/include/linux/netfilter/nf_conntrack_sip.h
@@ -73,6 +73,11 @@ extern int ct_sip_get_header(const struct nf_conn *ct, const char *dptr,
 			     unsigned int dataoff, unsigned int datalen,
 			     enum sip_header_types type,
 			     unsigned int *matchoff, unsigned int *matchlen);
+extern int ct_sip_parse_header_uri(const struct nf_conn *ct, const char *dptr,
+				   unsigned int *dataoff, unsigned int datalen,
+				   enum sip_header_types type, int *in_header,
+				   unsigned int *matchoff, unsigned int *matchlen,
+				   union nf_inet_addr *addr, __be16 *port);
 
 extern int ct_sip_get_sdp_header(const struct nf_conn *ct, const char *dptr,
 				 unsigned int dataoff, unsigned int datalen,
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index cf35a73..5454ab1 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -199,6 +199,9 @@ EXPORT_SYMBOL_GPL(ct_sip_parse_request);
  * whitespace and the values. Whitespace in this context means any amount of
  * tabs, spaces and continuation lines, which are treated as a single whitespace
  * character.
+ *
+ * Some headers may appear multiple times. A comma seperated list of values is
+ * equivalent to multiple headers.
  */
 static const struct sip_header ct_sip_hdrs[] = {
 	[SIP_HDR_FROM]			= SIP_HDR("From", "f", "sip:", skp_epaddr_len),
@@ -331,6 +334,110 @@ int ct_sip_get_header(const struct nf_conn *ct, const char *dptr,
 }
 EXPORT_SYMBOL_GPL(ct_sip_get_header);
 
+/* Get next header field in a list of comma seperated values */
+static int ct_sip_next_header(const struct nf_conn *ct, const char *dptr,
+			      unsigned int dataoff, unsigned int datalen,
+			      enum sip_header_types type,
+			      unsigned int *matchoff, unsigned int *matchlen)
+{
+	const struct sip_header *hdr = &ct_sip_hdrs[type];
+	const char *start = dptr, *limit = dptr + datalen;
+	int shift = 0;
+
+	dptr += dataoff;
+
+	dptr = ct_sip_header_search(dptr, limit, ",", strlen(","));
+	if (!dptr)
+		return 0;
+
+	dptr = ct_sip_header_search(dptr, limit, hdr->search, hdr->slen);
+	if (!dptr)
+		return 0;
+	dptr += hdr->slen;
+
+	*matchoff = dptr - start;
+	*matchlen = hdr->match_len(ct, dptr, limit, &shift);
+	if (!*matchlen)
+		return -1;
+	*matchoff += shift;
+	return 1;
+}
+
+/* Walk through headers until a parsable one is found or no header of the
+ * given type is left. */
+static int ct_sip_walk_headers(const struct nf_conn *ct, const char *dptr,
+			       unsigned int dataoff, unsigned int datalen,
+			       enum sip_header_types type, int *in_header,
+			       unsigned int *matchoff, unsigned int *matchlen)
+{
+	int ret;
+
+	if (in_header && *in_header) {
+		while (1) {
+			ret = ct_sip_next_header(ct, dptr, dataoff, datalen,
+						 type, matchoff, matchlen);
+			if (ret > 0)
+				return ret;
+			if (ret == 0)
+				break;
+			dataoff += *matchoff;
+		}
+		*in_header = 0;
+	}
+
+	while (1) {
+		ret = ct_sip_get_header(ct, dptr, dataoff, datalen, type,
+					matchoff, matchlen);
+		if (ret > 0)
+			break;
+		if (ret == 0)
+			return ret;
+		dataoff += *matchoff;
+	}
+
+	if (in_header)
+		*in_header = 1;
+	return 1;
+}
+
+/* Locate a SIP header, parse the URI and return the offset and length of
+ * the address as well as the address and port themselves. A stream of
+ * headers can be parsed by handing in a non-NULL datalen and in_header
+ * pointer.
+ */
+int ct_sip_parse_header_uri(const struct nf_conn *ct, const char *dptr,
+			    unsigned int *dataoff, unsigned int datalen,
+			    enum sip_header_types type, int *in_header,
+			    unsigned int *matchoff, unsigned int *matchlen,
+			    union nf_inet_addr *addr, __be16 *port)
+{
+	const char *c, *limit = dptr + datalen;
+	unsigned int p;
+	int ret;
+
+	ret = ct_sip_walk_headers(ct, dptr, dataoff ? *dataoff : 0, datalen,
+				  type, in_header, matchoff, matchlen);
+	WARN_ON(ret < 0);
+	if (ret == 0)
+		return ret;
+
+	if (!parse_addr(ct, dptr + *matchoff, &c, addr, limit))
+		return -1;
+	if (*c == ':') {
+		c++;
+		p = simple_strtoul(c, (char **)&c, 10);
+		if (p < 1024 || p > 65535)
+			return -1;
+		*port = htons(p);
+	} else
+		*port = htons(SIP_PORT);
+
+	if (dataoff)
+		*dataoff = c - dptr;
+	return 1;
+}
+EXPORT_SYMBOL_GPL(ct_sip_parse_header_uri);
+
 /* SDP header parsing: a SDP session description contains an ordered set of
  * headers, starting with a section containing general session parameters,
  * optionally followed by multiple media descriptions.
