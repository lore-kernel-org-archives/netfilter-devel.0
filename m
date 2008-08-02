From: <gregkh@suse.de>
Subject: patch netfilter-nf_nat_sip-c-is-optional-for-session.patch added to 2.6.26-stable tree
Date: Fri, 01 Aug 2008 17:10:58 -0700
Message-ID: <20080802001701.6871014544DD@imap.suse.de>
References: <48906FCA.1060503@trash.net>
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: herbert@gondor.apana.org.au, davem@davemloft.net, gregkh@suse.de,
	kaber@trash.net, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41360 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbYHBARE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Aug 2008 20:17:04 -0400
In-Reply-To: <48906FCA.1060503@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


This is a note to let you know that we have just queued up the patch titled

    Subject: netfilter: nf_nat_sip: c= is optional for session

to the 2.6.26-stable tree.  Its filename is

    netfilter-nf_nat_sip-c-is-optional-for-session.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From kaber@trash.net  Fri Aug  1 16:50:44 2008
From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Wed, 30 Jul 2008 15:42:34 +0200
Subject: netfilter: nf_nat_sip: c= is optional for session
To: stable@kernel.org
Cc: Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>
Message-ID: <48906FCA.1060503@trash.net>

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


Patches currently in stable-queue which might be from herbert@gondor.apana.org.au are

queue-2.6.26/netfilter-nf_nat_sip-c-is-optional-for-session.patch
