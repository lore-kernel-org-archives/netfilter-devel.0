From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 07/08: nf_nat_sip: c= is optional for session
Date: Mon, 21 Jul 2008 18:17:32 +0200 (MEST)
Message-ID: <20080721161732.28572.1919.sendpatchset@localhost.localdomain>
References: <20080721161722.28572.97957.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41640 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbYGUQRd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:17:33 -0400
In-Reply-To: <20080721161722.28572.97957.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: nf_nat_sip: c= is optional for session

According to RFC2327, the connection information is optional
in the session description since it can be specified in the
media description instead.

My provider does exactly that and does not provide any connection
information in the session description.  As a result the new
kernel drops all invite responses.

This patch makes it optional as documented.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 414c518048d54280034629edba63b5930cae945c
tree 40fb8fcae32417aa4c114c7fc958069f9b391322
parent 373729398480d3132bb04f8cea368bf4746eee79
author Herbert Xu <herbert@gondor.apana.org.au> Mon, 21 Jul 2008 18:05:58 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 21 Jul 2008 18:05:58 +0200

 net/ipv4/netfilter/nf_nat_sip.c |   38 +++++++++++++++++++++++++-------------
 1 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c
index 4334d5c..1454432 100644
--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -318,11 +318,11 @@ static int mangle_content_len(struct sk_buff *skb,
 			     buffer, buflen);
 }
 
-static unsigned mangle_sdp_packet(struct sk_buff *skb, const char **dptr,
-				  unsigned int dataoff, unsigned int *datalen,
-				  enum sdp_header_types type,
-				  enum sdp_header_types term,
-				  char *buffer, int buflen)
+static int mangle_sdp_packet(struct sk_buff *skb, const char **dptr,
+			     unsigned int dataoff, unsigned int *datalen,
+			     enum sdp_header_types type,
+			     enum sdp_header_types term,
+			     char *buffer, int buflen)
 {
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
@@ -330,9 +330,9 @@ static unsigned mangle_sdp_packet(struct sk_buff *skb, const char **dptr,
 
 	if (ct_sip_get_sdp_header(ct, *dptr, dataoff, *datalen, type, term,
 				  &matchoff, &matchlen) <= 0)
-		return 0;
+		return -ENOENT;
 	return mangle_packet(skb, dptr, datalen, matchoff, matchlen,
-			     buffer, buflen);
+			     buffer, buflen) ? 0 : -EINVAL;
 }
 
 static unsigned int ip_nat_sdp_addr(struct sk_buff *skb, const char **dptr,
@@ -346,8 +346,8 @@ static unsigned int ip_nat_sdp_addr(struct sk_buff *skb, const char **dptr,
 	unsigned int buflen;
 
 	buflen = sprintf(buffer, NIPQUAD_FMT, NIPQUAD(addr->ip));
-	if (!mangle_sdp_packet(skb, dptr, dataoff, datalen, type, term,
-			       buffer, buflen))
+	if (mangle_sdp_packet(skb, dptr, dataoff, datalen, type, term,
+			      buffer, buflen))
 		return 0;
 
 	return mangle_content_len(skb, dptr, datalen);
@@ -381,15 +381,27 @@ static unsigned int ip_nat_sdp_session(struct sk_buff *skb, const char **dptr,
 
 	/* Mangle session description owner and contact addresses */
 	buflen = sprintf(buffer, "%u.%u.%u.%u", NIPQUAD(addr->ip));
-	if (!mangle_sdp_packet(skb, dptr, dataoff, datalen,
+	if (mangle_sdp_packet(skb, dptr, dataoff, datalen,
 			       SDP_HDR_OWNER_IP4, SDP_HDR_MEDIA,
 			       buffer, buflen))
 		return 0;
 
-	if (!mangle_sdp_packet(skb, dptr, dataoff, datalen,
-			       SDP_HDR_CONNECTION_IP4, SDP_HDR_MEDIA,
-			       buffer, buflen))
+	switch (mangle_sdp_packet(skb, dptr, dataoff, datalen,
+				  SDP_HDR_CONNECTION_IP4, SDP_HDR_MEDIA,
+				  buffer, buflen)) {
+	case 0:
+	/*
+	 * RFC 2327:
+	 *
+	 * Session description
+	 *
+	 * c=* (connection information - not required if included in all media)
+	 */
+	case -ENOENT:
+		break;
+	default:
 		return 0;
+	}
 
 	return mangle_content_len(skb, dptr, datalen);
 }
