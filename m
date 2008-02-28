From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 13/32]: nf_conntrack_sip: use strlen/strcmp
Date: Thu, 28 Feb 2008 13:00:14 +0100 (MET)
Message-ID: <20080228120005.29267.96435.sendpatchset@localhost.localdomain>
References: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49991 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757115AbYB1MAP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2008 07:00:15 -0500
In-Reply-To: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sip: use strlen/strcmp

Replace sizeof/memcmp by strlen/strcmp. Use case-insensitive comparison
for SIP methods and the SIP/2.0 string, as specified in RFC 3261.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9896edea1c747be496854039a846ad61193ecadd
tree 40d97595577407c336f378eb2ec85390828a5afc
parent ee0b2a3c7a34c1c09e96b5601d8e8ce46861e808
author Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:20 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:20 +0100

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
index b273225..d8e5867 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -443,15 +443,15 @@ static int sip_help(struct sk_buff *skb,
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
