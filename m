From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 21/32]: nf_conntrack_sip: perform NAT after parsing
Date: Thu, 28 Feb 2008 13:00:25 +0100 (MET)
Message-ID: <20080228120016.29267.57076.sendpatchset@localhost.localdomain>
References: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50016 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757329AbYB1MA0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2008 07:00:26 -0500
In-Reply-To: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sip: perform NAT after parsing

Perform NAT last after parsing the packet. This makes no difference
currently, but is needed when dealing with registrations to make
sure we seen the unNATed addresses.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 66f5a5cc25fd9279c23d5e4560c216b8fdd72684
tree 612018ec647e76342f0233f2a7833f97808781ec
parent 76ff8089d5abc23d9cc6b31f7d1a7dcdd9579567
author Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:27 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:27 +0100

 net/ipv4/netfilter/nf_nat_sip.c  |    3 ---
 net/netfilter/nf_conntrack_sip.c |   19 +++++++++++--------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c
index 5b4a5cd..b442810 100644
--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -104,9 +104,6 @@ static unsigned int ip_nat_sip(struct sk_buff *skb,
 	union nf_inet_addr addr;
 	__be16 port;
 
-	if (*datalen < strlen("SIP/2.0"))
-		return NF_ACCEPT;
-
 	/* Basic rules: requests and responses. */
 	if (strnicmp(*dptr, "SIP/2.0", strlen("SIP/2.0")) != 0) {
 		if (ct_sip_parse_request(ct, *dptr, *datalen,
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 93e8565..d0c6b3d 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -709,6 +709,7 @@ static int sip_help(struct sk_buff *skb,
 {
 	unsigned int dataoff, datalen;
 	const char *dptr;
+	int ret;
 	typeof(nf_nat_sip_hook) nf_nat_sip;
 
 	/* No Data ? */
@@ -725,20 +726,22 @@ static int sip_help(struct sk_buff *skb,
 		return NF_ACCEPT;
 	}
 
-	nf_nat_sip = rcu_dereference(nf_nat_sip_hook);
-	if (nf_nat_sip && ct->status & IPS_NAT_MASK) {
-		if (!nf_nat_sip(skb, &dptr, &datalen))
-			return NF_DROP;
-	}
-
 	datalen = skb->len - dataoff;
 	if (datalen < strlen("SIP/2.0 200"))
 		return NF_ACCEPT;
 
 	if (strnicmp(dptr, "SIP/2.0 ", strlen("SIP/2.0 ")) != 0)
-		return process_sip_request(skb, &dptr, &datalen);
+		ret = process_sip_request(skb, &dptr, &datalen);
 	else
-		return process_sip_response(skb, &dptr, &datalen);
+		ret = process_sip_response(skb, &dptr, &datalen);
+
+	if (ret == NF_ACCEPT && ct->status & IPS_NAT_MASK) {
+		nf_nat_sip = rcu_dereference(nf_nat_sip_hook);
+		if (nf_nat_sip && !nf_nat_sip(skb, &dptr, &datalen))
+			ret = NF_DROP;
+	}
+
+	return ret;
 }
 
 static struct nf_conntrack_helper sip[MAX_PORTS][2] __read_mostly;
