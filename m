From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 18/32]: nf_conntrack_sip: move SDP parsing to seperate function
Date: Tue, 25 Mar 2008 15:15:16 +0100 (MET)
Message-ID: <20080325141515.10539.99388.sendpatchset@localhost.localdomain>
References: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32942 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273AbYCYOPR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:15:17 -0400
In-Reply-To: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sip: move SDP parsing to seperate function

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 19639f6bcaed278e3fbc60d69f573e5c117bc4f2
tree aa2dfd07bf03862400f034b44af3874449b92d52
parent fc9fe43590fd51627254f5c2aab859f23976b383
author Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 12:45:05 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 25 Mar 2008 14:09:56 +0100

 net/netfilter/nf_conntrack_sip.c |   84 +++++++++++++++++++-------------------
 1 files changed, 43 insertions(+), 41 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index f20fa2d..96bedb5 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -565,19 +565,49 @@ static int set_expected_rtp(struct sk_buff *skb,
 	return ret;
 }
 
+static int process_sdp(struct sk_buff *skb,
+		       const char **dptr, unsigned int *datalen)
+{
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
+	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
+	unsigned int matchoff, matchlen;
+	union nf_inet_addr addr;
+	unsigned int port;
+	enum sdp_header_types type;
+
+	/* Get address and port from SDP packet. */
+	type = family == AF_INET ? SDP_HDR_CONNECTION_IP4 :
+				   SDP_HDR_CONNECTION_IP6;
+
+	if (ct_sip_get_sdp_header(ct, *dptr, 0, *datalen,
+				  type, SDP_HDR_UNSPEC,
+				  &matchoff, &matchlen) <= 0)
+		return NF_ACCEPT;
+
+	/* We'll drop only if there are parse problems. */
+	if (!parse_addr(ct, *dptr + matchoff, NULL, &addr, *dptr + *datalen))
+		return NF_DROP;
+
+	if (ct_sip_get_sdp_header(ct, *dptr, 0, *datalen,
+				  SDP_HDR_MEDIA, SDP_HDR_UNSPEC,
+				  &matchoff, &matchlen) <= 0)
+		return NF_ACCEPT;
+
+	port = simple_strtoul(*dptr + matchoff, NULL, 10);
+	if (port < 1024 || port > 65535)
+		return NF_DROP;
+
+	return set_expected_rtp(skb, dptr, datalen, &addr, htons(port));
+}
+
 static int sip_help(struct sk_buff *skb,
 		    unsigned int protoff,
 		    struct nf_conn *ct,
 		    enum ip_conntrack_info ctinfo)
 {
-	int family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
-	union nf_inet_addr addr;
 	unsigned int dataoff, datalen;
 	const char *dptr;
-	int ret = NF_ACCEPT;
-	unsigned int matchoff, matchlen;
-	u_int16_t port;
-	enum sdp_header_types type;
 	typeof(nf_nat_sip_hook) nf_nat_sip;
 
 	/* No Data ? */
@@ -591,56 +621,28 @@ static int sip_help(struct sk_buff *skb,
 		dptr = skb->data + dataoff;
 	else {
 		pr_debug("Copy of skbuff not supported yet.\n");
-		goto out;
+		return NF_ACCEPT;
 	}
 
 	nf_nat_sip = rcu_dereference(nf_nat_sip_hook);
 	if (nf_nat_sip && ct->status & IPS_NAT_MASK) {
-		if (!nf_nat_sip(skb, &dptr, &datalen)) {
-			ret = NF_DROP;
-			goto out;
-		}
+		if (!nf_nat_sip(skb, &dptr, &datalen))
+			return NF_DROP;
 	}
 
 	datalen = skb->len - dataoff;
 	if (datalen < strlen("SIP/2.0 200"))
-		goto out;
+		return NF_ACCEPT;
 
 	/* RTP info only in some SDP pkts */
 	if (strnicmp(dptr, "INVITE", strlen("INVITE")) != 0 &&
 	    strnicmp(dptr, "UPDATE", strlen("UPDATE")) != 0 &&
 	    strnicmp(dptr, "SIP/2.0 180", strlen("SIP/2.0 180")) != 0 &&
 	    strnicmp(dptr, "SIP/2.0 183", strlen("SIP/2.0 183")) != 0 &&
-	    strnicmp(dptr, "SIP/2.0 200", strlen("SIP/2.0 200")) != 0) {
-		goto out;
-	}
-	/* Get address and port from SDP packet. */
-	type = family == AF_INET ? SDP_HDR_CONNECTION_IP4 :
-				   SDP_HDR_CONNECTION_IP6;
-	if (ct_sip_get_sdp_header(ct, dptr, 0, datalen, type, SDP_HDR_UNSPEC,
-				  &matchoff, &matchlen) > 0) {
+	    strnicmp(dptr, "SIP/2.0 200", strlen("SIP/2.0 200")) != 0)
+		return NF_ACCEPT;
 
-		/* We'll drop only if there are parse problems. */
-		if (!parse_addr(ct, dptr + matchoff, NULL, &addr,
-				dptr + datalen)) {
-			ret = NF_DROP;
-			goto out;
-		}
-		if (ct_sip_get_sdp_header(ct, dptr, 0, datalen,
-					  SDP_HDR_MEDIA, SDP_HDR_UNSPEC,
-					  &matchoff, &matchlen) > 0) {
-
-			port = simple_strtoul(dptr + matchoff, NULL, 10);
-			if (port < 1024) {
-				ret = NF_DROP;
-				goto out;
-			}
-			ret = set_expected_rtp(skb, &dptr, &datalen,
-					       &addr, htons(port));
-		}
-	}
-out:
-	return ret;
+	return process_sdp(skb, &dptr, &datalen);
 }
 
 static struct nf_conntrack_helper sip[MAX_PORTS][2] __read_mostly;
