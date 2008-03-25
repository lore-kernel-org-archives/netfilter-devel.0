From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 24/32]: nf_nat_sip: translate all Via headers
Date: Tue, 25 Mar 2008 15:15:24 +0100 (MET)
Message-ID: <20080325141524.10539.93523.sendpatchset@localhost.localdomain>
References: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32963 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbYCYOP0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:15:26 -0400
In-Reply-To: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_nat_sip: translate all Via headers

Update maddr=, received= and rport= Via-header parameters refering to
the signalling connection.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit eda29246d061965c8943f1a5954b056b3dc189fa
tree 958772517ac6a2e081c15db10e77c171c508fd8a
parent 2a21cab1320505abe9059adb8d42a130ea36e15b
author Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 12:45:14 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 14:09:57 +0100

 net/ipv4/netfilter/nf_nat_sip.c |   74 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 73 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c
index b442810..71a4adc 100644
--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -100,9 +100,11 @@ static unsigned int ip_nat_sip(struct sk_buff *skb,
 {
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
+	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
 	unsigned int matchoff, matchlen;
 	union nf_inet_addr addr;
 	__be16 port;
+	int request;
 
 	/* Basic rules: requests and responses. */
 	if (strnicmp(*dptr, "SIP/2.0", strlen("SIP/2.0")) != 0) {
@@ -112,11 +114,81 @@ static unsigned int ip_nat_sip(struct sk_buff *skb,
 		    !map_addr(skb, dptr, datalen, matchoff, matchlen,
 			      &addr, port))
 			return NF_DROP;
+		request = 1;
+	} else
+		request = 0;
+
+	/* Translate topmost Via header and parameters */
+	if (ct_sip_parse_header_uri(ct, *dptr, NULL, *datalen,
+				    SIP_HDR_VIA, NULL, &matchoff, &matchlen,
+				    &addr, &port) > 0) {
+		unsigned int matchend, poff, plen, buflen, n;
+		char buffer[sizeof("nnn.nnn.nnn.nnn:nnnnn")];
+
+		/* We're only interested in headers related to this
+		 * connection */
+		if (request) {
+			if (addr.ip != ct->tuplehash[dir].tuple.src.u3.ip ||
+			    port != ct->tuplehash[dir].tuple.src.u.udp.port)
+				goto next;
+		} else {
+			if (addr.ip != ct->tuplehash[dir].tuple.dst.u3.ip ||
+			    port != ct->tuplehash[dir].tuple.dst.u.udp.port)
+				goto next;
+		}
+
+		if (!map_addr(skb, dptr, datalen, matchoff, matchlen,
+			      &addr, port))
+			return NF_DROP;
+
+		matchend = matchoff + matchlen;
+
+		/* The maddr= parameter (RFC 2361) specifies where to send
+		 * the reply. */
+		if (ct_sip_parse_address_param(ct, *dptr, matchend, *datalen,
+					       "maddr=", &poff, &plen,
+					       &addr) > 0 &&
+		    addr.ip == ct->tuplehash[dir].tuple.src.u3.ip &&
+		    addr.ip != ct->tuplehash[!dir].tuple.dst.u3.ip) {
+			__be32 ip = ct->tuplehash[!dir].tuple.dst.u3.ip;
+			buflen = sprintf(buffer, "%u.%u.%u.%u", NIPQUAD(ip));
+			if (!mangle_packet(skb, dptr, datalen, poff, plen,
+					   buffer, buflen))
+				return NF_DROP;
+		}
+
+		/* The received= parameter (RFC 2361) contains the address
+		 * from which the server received the request. */
+		if (ct_sip_parse_address_param(ct, *dptr, matchend, *datalen,
+					       "received=", &poff, &plen,
+					       &addr) > 0 &&
+		    addr.ip == ct->tuplehash[dir].tuple.dst.u3.ip &&
+		    addr.ip != ct->tuplehash[!dir].tuple.src.u3.ip) {
+			__be32 ip = ct->tuplehash[!dir].tuple.src.u3.ip;
+			buflen = sprintf(buffer, "%u.%u.%u.%u", NIPQUAD(ip));
+			if (!mangle_packet(skb, dptr, datalen, poff, plen,
+					   buffer, buflen))
+				return NF_DROP;
+		}
+
+		/* The rport= parameter (RFC 3581) contains the port number
+		 * from which the server received the request. */
+		if (ct_sip_parse_numerical_param(ct, *dptr, matchend, *datalen,
+						 "rport=", &poff, &plen,
+						 &n) > 0 &&
+		    htons(n) == ct->tuplehash[dir].tuple.dst.u.udp.port &&
+		    htons(n) != ct->tuplehash[!dir].tuple.src.u.udp.port) {
+			__be16 p = ct->tuplehash[!dir].tuple.src.u.udp.port;
+			buflen = sprintf(buffer, "%u", ntohs(p));
+			if (!mangle_packet(skb, dptr, datalen, poff, plen,
+					   buffer, buflen))
+				return NF_DROP;
+		}
 	}
 
+next:
 	if (!map_sip_addr(skb, dptr, datalen, SIP_HDR_FROM) ||
 	    !map_sip_addr(skb, dptr, datalen, SIP_HDR_TO) ||
-	    !map_sip_addr(skb, dptr, datalen, SIP_HDR_VIA) ||
 	    !map_sip_addr(skb, dptr, datalen, SIP_HDR_CONTACT))
 		return NF_DROP;
 	return NF_ACCEPT;
