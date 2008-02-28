From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 28/32]: nf_conntrack_sip: allow media expectations with wildcard source address
Date: Thu, 28 Feb 2008 13:00:34 +0100 (MET)
Message-ID: <20080228120025.29267.20169.sendpatchset@localhost.localdomain>
References: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50033 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757611AbYB1MAf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2008 07:00:35 -0500
In-Reply-To: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sip: allow media expectations with wildcard source address

Media streams can come from anywhere, add a module parameter which
controls whether wildcard expectations or expectations between the
two signalling endpoints are created.

Since the same media description sent on multiple connections may
results in multiple identical expections when using a wildcard source,
we need to check whether a similar expectation already exists for a
different connection before attempting to register it.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ab0caf103dbec8328e88d4598bdfadda4083c57d
tree d15aac94c9ec2091bef09ea8a920b898127f991f
parent 7446ec09d8df7385419cdd3008c4261c2fec7474
author Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:34 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 28 Feb 2008 12:08:34 +0100

 net/netfilter/nf_conntrack_sip.c |   45 +++++++++++++++++++++++++++++++++++---
 1 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 2f21d0c..be4dcb3 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -42,6 +42,11 @@ module_param(sip_direct_signalling, int, 0600);
 MODULE_PARM_DESC(sip_direct_signalling, "expect incoming calls from registrar "
 					"only (default 1)");
 
+static int sip_direct_media __read_mostly = 1;
+module_param(sip_direct_media, int, 0600);
+MODULE_PARM_DESC(sip_direct_media, "Expect Media streams between signalling "
+				   "endpoints only (default 1)");
+
 unsigned int (*nf_nat_sip_hook)(struct sk_buff *skb,
 				const char **dptr,
 				unsigned int *datalen) __read_mostly;
@@ -665,21 +670,53 @@ static void flush_expectations(struct nf_conn *ct, int media)
 
 static int set_expected_rtp(struct sk_buff *skb,
 			    const char **dptr, unsigned int *datalen,
-			    union nf_inet_addr *addr, __be16 port)
+			    union nf_inet_addr *daddr, __be16 port)
 {
 	struct nf_conntrack_expect *exp;
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
+	union nf_inet_addr *saddr;
+	struct nf_conntrack_tuple tuple;
 	int family = ct->tuplehash[!dir].tuple.src.l3num;
-	int ret;
+	int skip_expect = 0, ret;
 	typeof(nf_nat_sdp_hook) nf_nat_sdp;
 
+	saddr = NULL;
+	if (sip_direct_media) {
+		if (!nf_inet_addr_cmp(daddr, &ct->tuplehash[dir].tuple.src.u3))
+			return NF_ACCEPT;
+		saddr = &ct->tuplehash[!dir].tuple.src.u3;
+	}
+
+	/* We need to check whether the registration exists before attempting
+	 * to register it since we can see the same media description multiple
+	 * times on different connections in case multiple endpoints receive
+	 * the same call.
+	 */
+	memset(&tuple, 0, sizeof(tuple));
+	if (saddr)
+		tuple.src.u3 = *saddr;
+	tuple.src.l3num		= family;
+	tuple.dst.protonum	= IPPROTO_UDP;
+	tuple.dst.u3		= *daddr;
+	tuple.dst.u.udp.port	= port;
+
+	spin_lock_bh(&nf_conntrack_lock);
+	exp = __nf_ct_expect_find(&tuple);
+	if (exp && exp->master != ct &&
+	    nfct_help(exp->master)->helper == nfct_help(ct)->helper &&
+	    exp->class == SIP_EXPECT_AUDIO)
+		skip_expect = 1;
+	spin_unlock_bh(&nf_conntrack_lock);
+
+	if (skip_expect)
+		return NF_ACCEPT;
+
 	exp = nf_ct_expect_alloc(ct);
 	if (exp == NULL)
 		return NF_DROP;
-	nf_ct_expect_init(exp, SIP_EXPECT_AUDIO, family,
-			  &ct->tuplehash[!dir].tuple.src.u3, addr,
+	nf_ct_expect_init(exp, SIP_EXPECT_AUDIO, family, saddr, daddr,
 			  IPPROTO_UDP, NULL, &port);
 
 	nf_nat_sdp = rcu_dereference(nf_nat_sdp_hook);
