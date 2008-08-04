From: Greg KH <gregkh@suse.de>
Subject: [patch 03/25] netfilter: nf_nat_sip: c= is optional for session
Date: Mon, 4 Aug 2008 14:29:40 -0700
Message-ID: <20080804212940.GC8014@suse.de>
References: <20080804203506.816201392@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Patrick McHardy <kaber@trash.net>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49840 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763741AbYHDVeT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:34:19 -0400
Content-Disposition: inline; filename="netfilter-nf_nat_sip-c-is-optional-for-session.patch"
In-Reply-To: <20080804212725.GA7944@suse.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

netfilter: nf_nat_sip: c= is optional for session

Upstream commit c71529e4:

According to RFC2327, the connection information is optional
in the session description since it can be specified in the
media description instead.

My provider does exactly that and does not provide any connection
information in the session description.  As a result the new
kernel drops all invite responses.

This patch makes it optional as documented.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/netfilter/nf_nat_sip.c |   38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -318,11 +318,11 @@ static int mangle_content_len(struct sk_
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
@@ -330,9 +330,9 @@ static unsigned mangle_sdp_packet(struct
 
 	if (ct_sip_get_sdp_header(ct, *dptr, dataoff, *datalen, type, term,
 				  &matchoff, &matchlen) <= 0)
-		return 0;
+		return -ENOENT;
 	return mangle_packet(skb, dptr, datalen, matchoff, matchlen,
-			     buffer, buflen);
+			     buffer, buflen) ? 0 : -EINVAL;
 }
 
 static unsigned int ip_nat_sdp_addr(struct sk_buff *skb, const char **dptr,
@@ -346,8 +346,8 @@ static unsigned int ip_nat_sdp_addr(stru
 	unsigned int buflen;
 
 	buflen = sprintf(buffer, NIPQUAD_FMT, NIPQUAD(addr->ip));
-	if (!mangle_sdp_packet(skb, dptr, dataoff, datalen, type, term,
-			       buffer, buflen))
+	if (mangle_sdp_packet(skb, dptr, dataoff, datalen, type, term,
+			      buffer, buflen))
 		return 0;
 
 	return mangle_content_len(skb, dptr, datalen);
@@ -381,15 +381,27 @@ static unsigned int ip_nat_sdp_session(s
 
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

-- 
