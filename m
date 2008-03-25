From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 23/32]: nf_conntrack_sip: introduce URI and header parameter parsing helpers
Date: Tue, 25 Mar 2008 15:15:23 +0100 (MET)
Message-ID: <20080325141522.10539.89128.sendpatchset@localhost.localdomain>
References: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32957 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbYCYOPY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:15:24 -0400
In-Reply-To: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sip: introduce URI and header parameter parsing helpers

Introduce URI and header parameter parsing helpers. These are needed
by the conntrack helper to parse expiration values in Contact: header
parameters and by the NAT helper to properly update the Via-header
rport=, received= and maddr= parameters.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2a21cab1320505abe9059adb8d42a130ea36e15b
tree 9dd17f5ddaf115146c65f6c3c2fddbcd88ac8b27
parent 26599b7c1bd613fbb4f397ebfb64fd01a5f34068
author Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 12:45:13 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 14:09:57 +0100

 include/linux/netfilter/nf_conntrack_sip.h |   10 +++++
 net/netfilter/nf_conntrack_sip.c           |   58 ++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_sip.h b/include/linux/netfilter/nf_conntrack_sip.h
index da93e80..87e4028 100644
--- a/include/linux/netfilter/nf_conntrack_sip.h
+++ b/include/linux/netfilter/nf_conntrack_sip.h
@@ -93,6 +93,16 @@ extern int ct_sip_parse_header_uri(const struct nf_conn *ct, const char *dptr,
 				   enum sip_header_types type, int *in_header,
 				   unsigned int *matchoff, unsigned int *matchlen,
 				   union nf_inet_addr *addr, __be16 *port);
+extern int ct_sip_parse_address_param(const struct nf_conn *ct, const char *dptr,
+				      unsigned int dataoff, unsigned int datalen,
+				      const char *name,
+				      unsigned int *matchoff, unsigned int *matchlen,
+				      union nf_inet_addr *addr);
+extern int ct_sip_parse_numerical_param(const struct nf_conn *ct, const char *dptr,
+					unsigned int off, unsigned int datalen,
+					const char *name,
+					unsigned int *matchoff, unsigned int *matchen,
+					unsigned int *val);
 
 extern int ct_sip_get_sdp_header(const struct nf_conn *ct, const char *dptr,
 				 unsigned int dataoff, unsigned int datalen,
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 8e7e5b4..126f308 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -448,6 +448,64 @@ int ct_sip_parse_header_uri(const struct nf_conn *ct, const char *dptr,
 }
 EXPORT_SYMBOL_GPL(ct_sip_parse_header_uri);
 
+/* Parse address from header parameter and return address, offset and length */
+int ct_sip_parse_address_param(const struct nf_conn *ct, const char *dptr,
+			       unsigned int dataoff, unsigned int datalen,
+			       const char *name,
+			       unsigned int *matchoff, unsigned int *matchlen,
+			       union nf_inet_addr *addr)
+{
+	const char *limit = dptr + datalen;
+	const char *start, *end;
+
+	limit = ct_sip_header_search(dptr + dataoff, limit, ",", strlen(","));
+	if (!limit)
+		limit = dptr + datalen;
+
+	start = ct_sip_header_search(dptr + dataoff, limit, name, strlen(name));
+	if (!start)
+		return 0;
+
+	start += strlen(name);
+	if (!parse_addr(ct, start, &end, addr, limit))
+		return 0;
+	*matchoff = start - dptr;
+	*matchlen = end - start;
+	return 1;
+}
+EXPORT_SYMBOL_GPL(ct_sip_parse_address_param);
+
+/* Parse numerical header parameter and return value, offset and length */
+int ct_sip_parse_numerical_param(const struct nf_conn *ct, const char *dptr,
+				 unsigned int dataoff, unsigned int datalen,
+				 const char *name,
+				 unsigned int *matchoff, unsigned int *matchlen,
+				 unsigned int *val)
+{
+	const char *limit = dptr + datalen;
+	const char *start;
+	char *end;
+
+	limit = ct_sip_header_search(dptr + dataoff, limit, ",", strlen(","));
+	if (!limit)
+		limit = dptr + datalen;
+
+	start = ct_sip_header_search(dptr + dataoff, limit, name, strlen(name));
+	if (!start)
+		return 0;
+
+	start += strlen(name);
+	*val = simple_strtoul(start, &end, 0);
+	if (start == end)
+		return 0;
+	if (matchoff && matchlen) {
+		*matchoff = start - dptr;
+		*matchlen = end - start;
+	}
+	return 1;
+}
+EXPORT_SYMBOL_GPL(ct_sip_parse_numerical_param);
+
 /* SDP header parsing: a SDP session description contains an ordered set of
  * headers, starting with a section containing general session parameters,
  * optionally followed by multiple media descriptions.
