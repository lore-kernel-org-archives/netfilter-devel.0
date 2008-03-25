From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 12/32]: nf_conntrack_sip: use strlen/strcmp
Date: Tue, 25 Mar 2008 15:15:07 +0100 (MET)
Message-ID: <20080325141507.10539.33331.sendpatchset@localhost.localdomain>
References: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32924 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbYCYOPJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:15:09 -0400
In-Reply-To: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sip: use strlen/strcmp

Replace sizeof/memcmp by strlen/strcmp. Use case-insensitive comparison
for SIP methods and the SIP/2.0 string, as specified in RFC 3261.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7fc3c23d9817c4086c5bff587d614136ba5dfc80
tree 887b6f2cb2f08cfd94c985960f465c45a82a3b02
parent 596c3f5c075a54207dcf8dffb108031e736861ba
author Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 12:44:55 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 14:09:54 +0100

 net/ipv4/netfilter/nf_nat_sip.c  |   12 ++++++------
 net/netfilter/nf_conntrack_sip.c |   12 ++++++------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c
index acaa7d4..dd1b2d8 100644
--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -94,12 +94,12 @@ static int map_sip_addr(struct sk_buff *skb,
 
 	if ((matchlen == map->addr[dir].srciplen ||
 	     matchlen == map->addr[dir].srclen) &&
-	    memcmp(*dptr + matchoff, map->addr[dir].src, matchlen) == 0) {
+	    strncmp(*dptr + matchoff, map->addr[dir].src, matchlen) == 0) {
 		addr    = map->addr[!dir].dst;
 		addrlen = map->addr[!dir].dstlen;
 	} else if ((matchlen == map->addr[dir].dstiplen ||
 		    matchlen == map->addr[dir].dstlen) &&
-		   memcmp(*dptr + matchoff, map->addr[dir].dst, matchlen) == 0) {
+		   strncmp(*dptr + matchoff, map->addr[dir].dst, matchlen) == 0) {
 		addr    = map->addr[!dir].src;
 		addrlen = map->addr[!dir].srclen;
 	} else
@@ -117,20 +117,20 @@ static unsigned int ip_nat_sip(struct sk_buff *skb,
 	enum sip_header_pos pos;
 	struct addr_map map;
 
-	if (*datalen < sizeof("SIP/2.0") - 1)
+	if (*datalen < strlen("SIP/2.0"))
 		return NF_ACCEPT;
 
 	addr_map_init(ct, &map);
 
 	/* Basic rules: requests and responses. */
-	if (strncmp(*dptr, "SIP/2.0", sizeof("SIP/2.0") - 1) != 0) {
+	if (strnicmp(*dptr, "SIP/2.0", strlen("SIP/2.0")) != 0) {
 		/* 10.2: Constructing the REGISTER Request:
 		 *
 		 * The "userinfo" and "@" components of the SIP URI MUST NOT
 		 * be present.
 		 */
-		if (*datalen >= sizeof("REGISTER") - 1 &&
-		    strncmp(*dptr, "REGISTER", sizeof("REGISTER") - 1) == 0)
+		if (*datalen >= strlen("REGISTER") &&
+		    strnicmp(*dptr, "REGISTER", strlen("REGISTER")) == 0)
 			pos = POS_REG_REQ_URI;
 		else
 			pos = POS_REQ_URI;
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 38e1e7a..cf19a70 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -434,15 +434,15 @@ static int sip_help(struct sk_buff *skb,
 	}
 
 	datalen = skb->len - dataoff;
-	if (datalen < sizeof("SIP/2.0 200") - 1)
+	if (datalen < strlen("SIP/2.0 200"))
 		goto out;
 
 	/* RTP info only in some SDP pkts */
-	if (memcmp(dptr, "INVITE", sizeof("INVITE") - 1) != 0 &&
-	    memcmp(dptr, "UPDATE", sizeof("UPDATE") - 1) != 0 &&
-	    memcmp(dptr, "SIP/2.0 180", sizeof("SIP/2.0 180") - 1) != 0 &&
-	    memcmp(dptr, "SIP/2.0 183", sizeof("SIP/2.0 183") - 1) != 0 &&
-	    memcmp(dptr, "SIP/2.0 200", sizeof("SIP/2.0 200") - 1) != 0) {
+	if (strnicmp(dptr, "INVITE", strlen("INVITE")) != 0 &&
+	    strnicmp(dptr, "UPDATE", strlen("UPDATE")) != 0 &&
+	    strnicmp(dptr, "SIP/2.0 180", strlen("SIP/2.0 180")) != 0 &&
+	    strnicmp(dptr, "SIP/2.0 183", strlen("SIP/2.0 183")) != 0 &&
+	    strnicmp(dptr, "SIP/2.0 200", strlen("SIP/2.0 200")) != 0) {
 		goto out;
 	}
 	/* Get address and port from SDP packet. */
