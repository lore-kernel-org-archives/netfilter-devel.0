From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 25/32]: nf_nat_sip: translate all Contact headers
Date: Tue, 25 Mar 2008 15:15:26 +0100 (MET)
Message-ID: <20080325141525.10539.91430.sendpatchset@localhost.localdomain>
References: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32957 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020AbYCYOP1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:15:27 -0400
In-Reply-To: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_nat_sip: translate all Contact headers

The SIP message may contain multiple Contact: addresses referring to
the NATed endpoint, translate all of them.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 8f15ab436de825574920db877a18917979712df4
tree 062b48ee051c4599b0425722c389c6eea4426b5c
parent eda29246d061965c8943f1a5954b056b3dc189fa
author Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 12:45:16 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 14:09:58 +0100

 net/ipv4/netfilter/nf_nat_sip.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c
index 71a4adc..b443618 100644
--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -101,10 +101,10 @@ static unsigned int ip_nat_sip(struct sk_buff *skb,
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
-	unsigned int matchoff, matchlen;
+	unsigned int dataoff, matchoff, matchlen;
 	union nf_inet_addr addr;
 	__be16 port;
-	int request;
+	int request, in_header;
 
 	/* Basic rules: requests and responses. */
 	if (strnicmp(*dptr, "SIP/2.0", strlen("SIP/2.0")) != 0) {
@@ -187,9 +187,20 @@ static unsigned int ip_nat_sip(struct sk_buff *skb,
 	}
 
 next:
+	/* Translate Contact headers */
+	dataoff = 0;
+	in_header = 0;
+	while (ct_sip_parse_header_uri(ct, *dptr, &dataoff, *datalen,
+				       SIP_HDR_CONTACT, &in_header,
+				       &matchoff, &matchlen,
+				       &addr, &port) > 0) {
+		if (!map_addr(skb, dptr, datalen, matchoff, matchlen,
+			      &addr, port))
+			return NF_DROP;
+	}
+
 	if (!map_sip_addr(skb, dptr, datalen, SIP_HDR_FROM) ||
-	    !map_sip_addr(skb, dptr, datalen, SIP_HDR_TO) ||
-	    !map_sip_addr(skb, dptr, datalen, SIP_HDR_CONTACT))
+	    !map_sip_addr(skb, dptr, datalen, SIP_HDR_TO))
 		return NF_DROP;
 	return NF_ACCEPT;
 }
