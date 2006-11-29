From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 19/33]: ip_conntrack: fix NAT helper unload races
Date: Wed, 29 Nov 2006 03:09:13 +0100 (MET)
Message-ID: <20061129020913.21082.45221.sendpatchset@localhost.localdomain>
References: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: ip_conntrack: fix NAT helper unload races

The NAT helpr hooks are protected by RCU, but all of the
conntrack helpers test and use the global pointers instead
of copying them first using rcu_dereference()

Also replace synchronize_net() by synchronize_rcu() for clarity
since sychronizing only with packet receive processing is
insufficient to prevent races.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit be8302ed9dba541073030f78208bd96304f13964
tree 1a7bebba0af91b0396af875fd3d4d39a7eb6a310
parent c75fb025856b71ab4a7ceb837f77932c0ccd4b5d
author Patrick McHardy <kaber@trash.net> Tue, 28 Nov 2006 23:13:27 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 29 Nov 2006 02:32:49 +0100

 net/ipv4/netfilter/ip_conntrack_amanda.c      |    9 +
 net/ipv4/netfilter/ip_conntrack_ftp.c         |    8 +
 net/ipv4/netfilter/ip_conntrack_helper_h323.c |  164 +++++++++++++++----------
 net/ipv4/netfilter/ip_conntrack_helper_pptp.c |   29 +++-
 net/ipv4/netfilter/ip_conntrack_irc.c         |   12 +-
 net/ipv4/netfilter/ip_conntrack_sip.c         |   12 +-
 net/ipv4/netfilter/ip_conntrack_tftp.c        |    6 +
 net/ipv4/netfilter/ip_nat_amanda.c            |    9 +
 net/ipv4/netfilter/ip_nat_ftp.c               |    9 +
 net/ipv4/netfilter/ip_nat_helper_h323.c       |   58 ++++-----
 net/ipv4/netfilter/ip_nat_helper_pptp.c       |   27 ++--
 net/ipv4/netfilter/ip_nat_irc.c               |    9 +
 net/ipv4/netfilter/ip_nat_sip.c               |   15 +-
 net/ipv4/netfilter/ip_nat_tftp.c              |    9 +
 net/netfilter/nf_conntrack_ftp.c              |    9 +
 15 files changed, 216 insertions(+), 169 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_amanda.c b/net/ipv4/netfilter/ip_conntrack_amanda.c
index 7fca246..ad246ba 100644
--- a/net/ipv4/netfilter/ip_conntrack_amanda.c
+++ b/net/ipv4/netfilter/ip_conntrack_amanda.c
@@ -92,6 +92,7 @@ static int help(struct sk_buff **pskb,
 	char pbuf[sizeof("65535")], *tmp;
 	u_int16_t port, len;
 	int ret = NF_ACCEPT;
+	typeof(ip_nat_amanda_hook) ip_nat_amanda;
 
 	/* Only look at packets from the Amanda server */
 	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL)
@@ -161,9 +162,11 @@ static int help(struct sk_buff **pskb,
 		exp->mask.dst.protonum = 0xFF;
 		exp->mask.dst.u.tcp.port = htons(0xFFFF);
 
-		if (ip_nat_amanda_hook)
-			ret = ip_nat_amanda_hook(pskb, ctinfo, off - dataoff,
-						 len, exp);
+		/* RCU read locked by nf_hook_slow */
+		ip_nat_amanda = rcu_dereference(ip_nat_amanda_hook);
+		if (ip_nat_amanda)
+			ret = ip_nat_amanda(pskb, ctinfo, off - dataoff,
+					    len, exp);
 		else if (ip_conntrack_expect_related(exp) != 0)
 			ret = NF_DROP;
 		ip_conntrack_expect_put(exp);
diff --git a/net/ipv4/netfilter/ip_conntrack_ftp.c b/net/ipv4/netfilter/ip_conntrack_ftp.c
index 93dcf96..0410c99 100644
--- a/net/ipv4/netfilter/ip_conntrack_ftp.c
+++ b/net/ipv4/netfilter/ip_conntrack_ftp.c
@@ -310,6 +310,7 @@ static int help(struct sk_buff **pskb,
 	struct ip_conntrack_expect *exp;
 	unsigned int i;
 	int found = 0, ends_in_nl;
+	typeof(ip_nat_ftp_hook) ip_nat_ftp;
 
 	/* Until there's been traffic both ways, don't look in packets. */
 	if (ctinfo != IP_CT_ESTABLISHED
@@ -433,9 +434,10 @@ static int help(struct sk_buff **pskb,
 
 	/* Now, NAT might want to mangle the packet, and register the
 	 * (possibly changed) expectation itself. */
-	if (ip_nat_ftp_hook)
-		ret = ip_nat_ftp_hook(pskb, ctinfo, search[dir][i].ftptype,
-				      matchoff, matchlen, exp, &seq);
+	ip_nat_ftp = rcu_dereference(ip_nat_ftp_hook);
+	if (ip_nat_ftp)
+		ret = ip_nat_ftp(pskb, ctinfo, search[dir][i].ftptype,
+				 matchoff, matchlen, exp, &seq);
 	else {
 		/* Can't expect this?  Best to drop packet now. */
 		if (ip_conntrack_expect_related(exp) != 0)
diff --git a/net/ipv4/netfilter/ip_conntrack_helper_h323.c b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
index a06b340..aabfe1c 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_h323.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
@@ -237,6 +237,7 @@ static int expect_rtp_rtcp(struct sk_buf
 	u_int16_t rtp_port;
 	struct ip_conntrack_expect *rtp_exp;
 	struct ip_conntrack_expect *rtcp_exp;
+	typeof(nat_rtp_rtcp_hook) nat_rtp_rtcp;
 
 	/* Read RTP or RTCP address */
 	if (!get_h245_addr(*data, addr, &ip, &port) ||
@@ -279,11 +280,11 @@ static int expect_rtp_rtcp(struct sk_buf
 	rtcp_exp->flags = 0;
 
 	if (ct->tuplehash[dir].tuple.src.ip !=
-	    ct->tuplehash[!dir].tuple.dst.ip && nat_rtp_rtcp_hook) {
+	    ct->tuplehash[!dir].tuple.dst.ip &&
+	    (nat_rtp_rtcp = rcu_dereference(nat_rtp_rtcp_hook))) {
 		/* NAT needed */
-		ret = nat_rtp_rtcp_hook(pskb, ct, ctinfo, data, dataoff,
-					addr, port, rtp_port, rtp_exp,
-					rtcp_exp);
+		ret = nat_rtp_rtcp(pskb, ct, ctinfo, data, dataoff,
+				   addr, port, rtp_port, rtp_exp, rtcp_exp);
 	} else {		/* Conntrack only */
 		rtp_exp->expectfn = NULL;
 		rtcp_exp->expectfn = NULL;
@@ -328,6 +329,7 @@ static int expect_t120(struct sk_buff **
 	__be32 ip;
 	u_int16_t port;
 	struct ip_conntrack_expect *exp = NULL;
+	typeof(nat_t120_hook) nat_t120;
 
 	/* Read T.120 address */
 	if (!get_h245_addr(*data, addr, &ip, &port) ||
@@ -350,10 +352,11 @@ static int expect_t120(struct sk_buff **
 	exp->flags = IP_CT_EXPECT_PERMANENT;	/* Accept multiple channels */
 
 	if (ct->tuplehash[dir].tuple.src.ip !=
-	    ct->tuplehash[!dir].tuple.dst.ip && nat_t120_hook) {
+	    ct->tuplehash[!dir].tuple.dst.ip &&
+	    (nat_t120 = rcu_dereference(nat_t120_hook))) {
 		/* NAT needed */
-		ret = nat_t120_hook(pskb, ct, ctinfo, data, dataoff, addr,
-				    port, exp);
+		ret = nat_t120(pskb, ct, ctinfo, data, dataoff, addr,
+			       port, exp);
 	} else {		/* Conntrack only */
 		exp->expectfn = NULL;
 		if (ip_conntrack_expect_related(exp) == 0) {
@@ -651,6 +654,7 @@ static int expect_h245(struct sk_buff **
 	__be32 ip;
 	u_int16_t port;
 	struct ip_conntrack_expect *exp = NULL;
+	typeof(nat_h245_hook) nat_h245;
 
 	/* Read h245Address */
 	if (!get_h225_addr(*data, addr, &ip, &port) ||
@@ -673,10 +677,11 @@ static int expect_h245(struct sk_buff **
 	exp->flags = 0;
 
 	if (ct->tuplehash[dir].tuple.src.ip !=
-	    ct->tuplehash[!dir].tuple.dst.ip && nat_h245_hook) {
+	    ct->tuplehash[!dir].tuple.dst.ip &&
+	    (nat_h245 = rcu_dereference(nat_h245_hook))) {
 		/* NAT needed */
-		ret = nat_h245_hook(pskb, ct, ctinfo, data, dataoff, addr,
-				    port, exp);
+		ret = nat_h245(pskb, ct, ctinfo, data, dataoff, addr,
+			       port, exp);
 	} else {		/* Conntrack only */
 		exp->expectfn = ip_conntrack_h245_expect;
 
@@ -712,6 +717,7 @@ static int expect_callforwarding(struct 
 	__be32 ip;
 	u_int16_t port;
 	struct ip_conntrack_expect *exp = NULL;
+	typeof(nat_callforwarding_hook) nat_callforwarding;
 
 	/* Read alternativeAddress */
 	if (!get_h225_addr(*data, addr, &ip, &port) || port == 0)
@@ -759,10 +765,11 @@ static int expect_callforwarding(struct 
 	exp->flags = 0;
 
 	if (ct->tuplehash[dir].tuple.src.ip !=
-	    ct->tuplehash[!dir].tuple.dst.ip && nat_callforwarding_hook) {
+	    ct->tuplehash[!dir].tuple.dst.ip &&
+	    (nat_callforwarding = rcu_dereference(nat_callforwarding_hook))) {
 		/* Need NAT */
-		ret = nat_callforwarding_hook(pskb, ct, ctinfo, data, dataoff,
-					      addr, port, exp);
+		ret = nat_callforwarding(pskb, ct, ctinfo, data, dataoff,
+					 addr, port, exp);
 	} else {		/* Conntrack only */
 		exp->expectfn = ip_conntrack_q931_expect;
 
@@ -793,6 +800,7 @@ static int process_setup(struct sk_buff 
 	int i;
 	__be32 ip;
 	u_int16_t port;
+	typeof(set_h225_addr_hook) set_h225_addr;
 
 	DEBUGP("ip_ct_q931: Setup\n");
 
@@ -803,8 +811,10 @@ static int process_setup(struct sk_buff 
 			return -1;
 	}
 
+	set_h225_addr = rcu_dereference(set_h225_addr_hook);
+
 	if ((setup->options & eSetup_UUIE_destCallSignalAddress) &&
-	    (set_h225_addr_hook) &&
+	    (set_h225_addr) &&
 	    get_h225_addr(*data, &setup->destCallSignalAddress, &ip, &port) &&
 	    ip != ct->tuplehash[!dir].tuple.src.ip) {
 		DEBUGP("ip_ct_q931: set destCallSignalAddress "
@@ -812,17 +822,17 @@ static int process_setup(struct sk_buff 
 		       NIPQUAD(ip), port,
 		       NIPQUAD(ct->tuplehash[!dir].tuple.src.ip),
 		       ntohs(ct->tuplehash[!dir].tuple.src.u.tcp.port));
-		ret = set_h225_addr_hook(pskb, data, dataoff,
-					 &setup->destCallSignalAddress,
-					 ct->tuplehash[!dir].tuple.src.ip,
-					 ntohs(ct->tuplehash[!dir].tuple.src.
-					       u.tcp.port));
+		ret = set_h225_addr(pskb, data, dataoff,
+				    &setup->destCallSignalAddress,
+				    ct->tuplehash[!dir].tuple.src.ip,
+				    ntohs(ct->tuplehash[!dir].tuple.src.
+					  u.tcp.port));
 		if (ret < 0)
 			return -1;
 	}
 
 	if ((setup->options & eSetup_UUIE_sourceCallSignalAddress) &&
-	    (set_h225_addr_hook) &&
+	    (set_h225_addr) &&
 	    get_h225_addr(*data, &setup->sourceCallSignalAddress, &ip, &port)
 	    && ip != ct->tuplehash[!dir].tuple.dst.ip) {
 		DEBUGP("ip_ct_q931: set sourceCallSignalAddress "
@@ -830,11 +840,11 @@ static int process_setup(struct sk_buff 
 		       NIPQUAD(ip), port,
 		       NIPQUAD(ct->tuplehash[!dir].tuple.dst.ip),
 		       ntohs(ct->tuplehash[!dir].tuple.dst.u.tcp.port));
-		ret = set_h225_addr_hook(pskb, data, dataoff,
-					 &setup->sourceCallSignalAddress,
-					 ct->tuplehash[!dir].tuple.dst.ip,
-					 ntohs(ct->tuplehash[!dir].tuple.dst.
-					       u.tcp.port));
+		ret = set_h225_addr(pskb, data, dataoff,
+				    &setup->sourceCallSignalAddress,
+				    ct->tuplehash[!dir].tuple.dst.ip,
+				    ntohs(ct->tuplehash[!dir].tuple.dst.
+					  u.tcp.port));
 		if (ret < 0)
 			return -1;
 	}
@@ -1231,6 +1241,7 @@ static int expect_q931(struct sk_buff **
 	__be32 ip;
 	u_int16_t port;
 	struct ip_conntrack_expect *exp;
+	typeof(nat_q931_hook) nat_q931;
 
 	/* Look for the first related address */
 	for (i = 0; i < count; i++) {
@@ -1258,9 +1269,9 @@ static int expect_q931(struct sk_buff **
 	exp->mask.dst.protonum = 0xFF;
 	exp->flags = IP_CT_EXPECT_PERMANENT;	/* Accept multiple calls */
 
-	if (nat_q931_hook) {	/* Need NAT */
-		ret = nat_q931_hook(pskb, ct, ctinfo, data, addr, i,
-				    port, exp);
+	nat_q931 = rcu_dereference(nat_q931_hook);
+	if (nat_q931) {	/* Need NAT */
+		ret = nat_q931(pskb, ct, ctinfo, data, addr, i, port, exp);
 	} else {		/* Conntrack only */
 		exp->expectfn = ip_conntrack_q931_expect;
 
@@ -1288,11 +1299,14 @@ static int process_grq(struct sk_buff **
 		       enum ip_conntrack_info ctinfo,
 		       unsigned char **data, GatekeeperRequest * grq)
 {
+	typeof(set_ras_addr_hook) set_ras_addr;
+
 	DEBUGP("ip_ct_ras: GRQ\n");
 
-	if (set_ras_addr_hook)	/* NATed */
-		return set_ras_addr_hook(pskb, ct, ctinfo, data,
-					 &grq->rasAddress, 1);
+	set_ras_addr = rcu_dereference(set_ras_addr_hook);
+	if (set_ras_addr)	/* NATed */
+		return set_ras_addr(pskb, ct, ctinfo, data,
+				    &grq->rasAddress, 1);
 	return 0;
 }
 
@@ -1362,6 +1376,7 @@ static int process_rrq(struct sk_buff **
 {
 	struct ip_ct_h323_master *info = &ct->help.ct_h323_info;
 	int ret;
+	typeof(set_ras_addr_hook) set_ras_addr;
 
 	DEBUGP("ip_ct_ras: RRQ\n");
 
@@ -1371,10 +1386,11 @@ static int process_rrq(struct sk_buff **
 	if (ret < 0)
 		return -1;
 
-	if (set_ras_addr_hook) {
-		ret = set_ras_addr_hook(pskb, ct, ctinfo, data,
-					rrq->rasAddress.item,
-					rrq->rasAddress.count);
+	set_ras_addr = rcu_dereference(set_ras_addr_hook);
+	if (set_ras_addr) {
+		ret = set_ras_addr(pskb, ct, ctinfo, data,
+				   rrq->rasAddress.item,
+				   rrq->rasAddress.count);
 		if (ret < 0)
 			return -1;
 	}
@@ -1397,13 +1413,15 @@ static int process_rcf(struct sk_buff **
 	int dir = CTINFO2DIR(ctinfo);
 	int ret;
 	struct ip_conntrack_expect *exp;
+	typeof(set_sig_addr_hook) set_sig_addr;
 
 	DEBUGP("ip_ct_ras: RCF\n");
 
-	if (set_sig_addr_hook) {
-		ret = set_sig_addr_hook(pskb, ct, ctinfo, data,
-					rcf->callSignalAddress.item,
-					rcf->callSignalAddress.count);
+	set_sig_addr = rcu_dereference(set_sig_addr_hook);
+	if (set_sig_addr) {
+		ret = set_sig_addr(pskb, ct, ctinfo, data,
+				   rcf->callSignalAddress.item,
+				   rcf->callSignalAddress.count);
 		if (ret < 0)
 			return -1;
 	}
@@ -1448,13 +1466,15 @@ static int process_urq(struct sk_buff **
 	struct ip_ct_h323_master *info = &ct->help.ct_h323_info;
 	int dir = CTINFO2DIR(ctinfo);
 	int ret;
+	typeof(set_sig_addr_hook) set_sig_addr;
 
 	DEBUGP("ip_ct_ras: URQ\n");
 
-	if (set_sig_addr_hook) {
-		ret = set_sig_addr_hook(pskb, ct, ctinfo, data,
-					urq->callSignalAddress.item,
-					urq->callSignalAddress.count);
+	set_sig_addr = rcu_dereference(set_sig_addr_hook);
+	if (set_sig_addr) {
+		ret = set_sig_addr(pskb, ct, ctinfo, data,
+				   urq->callSignalAddress.item,
+				   urq->callSignalAddress.count);
 		if (ret < 0)
 			return -1;
 	}
@@ -1479,28 +1499,30 @@ static int process_arq(struct sk_buff **
 	int dir = CTINFO2DIR(ctinfo);
 	__be32 ip;
 	u_int16_t port;
+	typeof(set_h225_addr_hook) set_h225_addr;
 
 	DEBUGP("ip_ct_ras: ARQ\n");
 
+	set_h225_addr = rcu_dereference(set_h225_addr_hook);
 	if ((arq->options & eAdmissionRequest_destCallSignalAddress) &&
 	    get_h225_addr(*data, &arq->destCallSignalAddress, &ip, &port) &&
 	    ip == ct->tuplehash[dir].tuple.src.ip &&
-	    port == info->sig_port[dir] && set_h225_addr_hook) {
+	    port == info->sig_port[dir] && set_h225_addr) {
 		/* Answering ARQ */
-		return set_h225_addr_hook(pskb, data, 0,
-					  &arq->destCallSignalAddress,
-					  ct->tuplehash[!dir].tuple.dst.ip,
-					  info->sig_port[!dir]);
+		return set_h225_addr(pskb, data, 0,
+				     &arq->destCallSignalAddress,
+				     ct->tuplehash[!dir].tuple.dst.ip,
+				     info->sig_port[!dir]);
 	}
 
 	if ((arq->options & eAdmissionRequest_srcCallSignalAddress) &&
 	    get_h225_addr(*data, &arq->srcCallSignalAddress, &ip, &port) &&
-	    ip == ct->tuplehash[dir].tuple.src.ip && set_h225_addr_hook) {
+	    ip == ct->tuplehash[dir].tuple.src.ip && set_h225_addr) {
 		/* Calling ARQ */
-		return set_h225_addr_hook(pskb, data, 0,
-					  &arq->srcCallSignalAddress,
-					  ct->tuplehash[!dir].tuple.dst.ip,
-					  port);
+		return set_h225_addr(pskb, data, 0,
+				     &arq->srcCallSignalAddress,
+				     ct->tuplehash[!dir].tuple.dst.ip,
+				     port);
 	}
 
 	return 0;
@@ -1516,6 +1538,7 @@ static int process_acf(struct sk_buff **
 	__be32 ip;
 	u_int16_t port;
 	struct ip_conntrack_expect *exp;
+	typeof(set_sig_addr_hook) set_sig_addr;
 
 	DEBUGP("ip_ct_ras: ACF\n");
 
@@ -1523,10 +1546,10 @@ static int process_acf(struct sk_buff **
 		return 0;
 
 	if (ip == ct->tuplehash[dir].tuple.dst.ip) {	/* Answering ACF */
-		if (set_sig_addr_hook)
-			return set_sig_addr_hook(pskb, ct, ctinfo, data,
-						 &acf->destCallSignalAddress,
-						 1);
+		set_sig_addr = rcu_dereference(set_sig_addr_hook);
+		if (set_sig_addr)
+			return set_sig_addr(pskb, ct, ctinfo, data,
+					    &acf->destCallSignalAddress, 1);
 		return 0;
 	}
 
@@ -1566,11 +1589,14 @@ static int process_lrq(struct sk_buff **
 		       enum ip_conntrack_info ctinfo,
 		       unsigned char **data, LocationRequest * lrq)
 {
+	typeof(set_ras_addr_hook) set_ras_addr;
+
 	DEBUGP("ip_ct_ras: LRQ\n");
 
-	if (set_ras_addr_hook)
-		return set_ras_addr_hook(pskb, ct, ctinfo, data,
-					 &lrq->replyAddress, 1);
+	set_ras_addr = rcu_dereference(set_ras_addr_hook);
+	if (set_ras_addr)
+		return set_ras_addr(pskb, ct, ctinfo, data,
+				    &lrq->replyAddress, 1);
 	return 0;
 }
 
@@ -1629,20 +1655,24 @@ static int process_irr(struct sk_buff **
 		       unsigned char **data, InfoRequestResponse * irr)
 {
 	int ret;
+	typeof(set_ras_addr_hook) set_ras_addr;
+	typeof(set_sig_addr_hook) set_sig_addr;
 
 	DEBUGP("ip_ct_ras: IRR\n");
 
-	if (set_ras_addr_hook) {
-		ret = set_ras_addr_hook(pskb, ct, ctinfo, data,
-					&irr->rasAddress, 1);
+	set_ras_addr = rcu_dereference(set_ras_addr_hook);
+	if (set_ras_addr) {
+		ret = set_ras_addr(pskb, ct, ctinfo, data,
+				   &irr->rasAddress, 1);
 		if (ret < 0)
 			return -1;
 	}
 
-	if (set_sig_addr_hook) {
-		ret = set_sig_addr_hook(pskb, ct, ctinfo, data,
-					irr->callSignalAddress.item,
-					irr->callSignalAddress.count);
+	set_sig_addr = rcu_dereference(set_sig_addr_hook);
+	if (set_sig_addr) {
+		ret = set_sig_addr(pskb, ct, ctinfo, data,
+				   irr->callSignalAddress.item,
+				   irr->callSignalAddress.count);
 		if (ret < 0)
 			return -1;
 	}
diff --git a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
index a5c057b..4d19373 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
@@ -124,6 +124,8 @@ #define PPTP_GRE_STREAM_TIMEOUT 	(5 HOUR
 static void pptp_expectfn(struct ip_conntrack *ct,
 			 struct ip_conntrack_expect *exp)
 {
+	typeof(ip_nat_pptp_hook_expectfn) ip_nat_pptp_expectfn;
+
 	DEBUGP("increasing timeouts\n");
 
 	/* increase timeout of GRE data channel conntrack entry */
@@ -133,7 +135,9 @@ static void pptp_expectfn(struct ip_conn
 	/* Can you see how rusty this code is, compared with the pre-2.6.11
 	 * one? That's what happened to my shiny newnat of 2002 ;( -HW */
 
-	if (!ip_nat_pptp_hook_expectfn) {
+	rcu_read_lock();
+	ip_nat_pptp_expectfn = rcu_dereference(ip_nat_pptp_hook_expectfn);
+	if (!ip_nat_pptp_expectfn) {
 		struct ip_conntrack_tuple inv_t;
 		struct ip_conntrack_expect *exp_other;
 
@@ -153,8 +157,9 @@ static void pptp_expectfn(struct ip_conn
 		}
 	} else {
 		/* we need more than simple inversion */
-		ip_nat_pptp_hook_expectfn(ct, exp);
+		ip_nat_pptp_expectfn(ct, exp);
 	}
+	rcu_read_unlock();
 }
 
 static int destroy_sibling_or_exp(const struct ip_conntrack_tuple *t)
@@ -226,6 +231,7 @@ exp_gre(struct ip_conntrack *ct,
 {
 	struct ip_conntrack_expect *exp_orig, *exp_reply;
 	int ret = 1;
+	typeof(ip_nat_pptp_hook_exp_gre) ip_nat_pptp_exp_gre;
 
 	exp_orig = ip_conntrack_expect_alloc(ct);
 	if (exp_orig == NULL)
@@ -262,8 +268,9 @@ exp_gre(struct ip_conntrack *ct,
 	exp_reply->tuple.dst.u.gre.key = peer_callid;
 	exp_reply->tuple.dst.protonum = IPPROTO_GRE;
 
-	if (ip_nat_pptp_hook_exp_gre)
-		ip_nat_pptp_hook_exp_gre(exp_orig, exp_reply);
+	ip_nat_pptp_exp_gre = rcu_dereference(ip_nat_pptp_hook_exp_gre);
+	if (ip_nat_pptp_exp_gre)
+		ip_nat_pptp_exp_gre(exp_orig, exp_reply);
 	if (ip_conntrack_expect_related(exp_orig) != 0)
 		goto out_put_both;
 	if (ip_conntrack_expect_related(exp_reply) != 0)
@@ -303,6 +310,7 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 	struct ip_ct_pptp_master *info = &ct->help.ct_pptp_info;
 	u_int16_t msg;
 	__be16 cid = 0, pcid = 0;
+	typeof(ip_nat_pptp_hook_inbound) ip_nat_pptp_inbound;
 
 	msg = ntohs(ctlh->messageType);
 	DEBUGP("inbound control message %s\n", pptp_msg_name[msg]);
@@ -402,9 +410,9 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 		goto invalid;
 	}
 
-	if (ip_nat_pptp_hook_inbound)
-		return ip_nat_pptp_hook_inbound(pskb, ct, ctinfo, ctlh,
-						pptpReq);
+	ip_nat_pptp_inbound = rcu_dereference(ip_nat_pptp_hook_inbound);
+	if (ip_nat_pptp_inbound)
+		return ip_nat_pptp_inbound(pskb, ct, ctinfo, ctlh, pptpReq);
 	return NF_ACCEPT;
 
 invalid:
@@ -427,6 +435,7 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 	struct ip_ct_pptp_master *info = &ct->help.ct_pptp_info;
 	u_int16_t msg;
 	__be16 cid = 0, pcid = 0;
+	typeof(ip_nat_pptp_hook_outbound) ip_nat_pptp_outbound;
 
 	msg = ntohs(ctlh->messageType);
 	DEBUGP("outbound control message %s\n", pptp_msg_name[msg]);
@@ -492,9 +501,9 @@ pptp_outbound_pkt(struct sk_buff **pskb,
 		goto invalid;
 	}
 
-	if (ip_nat_pptp_hook_outbound)
-		return ip_nat_pptp_hook_outbound(pskb, ct, ctinfo, ctlh,
-						 pptpReq);
+	ip_nat_pptp_outbound = rcu_dereference(ip_nat_pptp_hook_outbound);
+	if (ip_nat_pptp_outbound)
+		return ip_nat_pptp_outbound(pskb, ct, ctinfo, ctlh, pptpReq);
 	return NF_ACCEPT;
 
 invalid:
diff --git a/net/ipv4/netfilter/ip_conntrack_irc.c b/net/ipv4/netfilter/ip_conntrack_irc.c
index 75f7c3d..91832ec 100644
--- a/net/ipv4/netfilter/ip_conntrack_irc.c
+++ b/net/ipv4/netfilter/ip_conntrack_irc.c
@@ -114,6 +114,7 @@ static int help(struct sk_buff **pskb,
 	u_int16_t dcc_port;
 	int i, ret = NF_ACCEPT;
 	char *addr_beg_p, *addr_end_p;
+	typeof(ip_nat_irc_hook) ip_nat_irc;
 
 	DEBUGP("entered\n");
 
@@ -222,11 +223,12 @@ static int help(struct sk_buff **pskb,
 					{ .tcp = { htons(0xFFFF) } }, 0xFF }});
 			exp->expectfn = NULL;
 			exp->flags = 0;
-			if (ip_nat_irc_hook)
-				ret = ip_nat_irc_hook(pskb, ctinfo, 
-						      addr_beg_p - ib_ptr,
-						      addr_end_p - addr_beg_p,
-						      exp);
+			ip_nat_irc = rcu_dereference(ip_nat_irc_hook);
+			if (ip_nat_irc)
+				ret = ip_nat_irc(pskb, ctinfo,
+						 addr_beg_p - ib_ptr,
+						 addr_end_p - addr_beg_p,
+						 exp);
 			else if (ip_conntrack_expect_related(exp) != 0)
 				ret = NF_DROP;
 			ip_conntrack_expect_put(exp);
diff --git a/net/ipv4/netfilter/ip_conntrack_sip.c b/net/ipv4/netfilter/ip_conntrack_sip.c
index f4f7599..bf423db 100644
--- a/net/ipv4/netfilter/ip_conntrack_sip.c
+++ b/net/ipv4/netfilter/ip_conntrack_sip.c
@@ -308,6 +308,7 @@ static int set_expected_rtp(struct sk_bu
 	struct ip_conntrack_expect *exp;
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
 	int ret;
+	typeof(ip_nat_sdp_hook) ip_nat_sdp;
 
 	exp = ip_conntrack_expect_alloc(ct);
 	if (exp == NULL)
@@ -328,8 +329,9 @@ static int set_expected_rtp(struct sk_bu
 	exp->expectfn = NULL;
 	exp->flags = 0;
 
-	if (ip_nat_sdp_hook)
-		ret = ip_nat_sdp_hook(pskb, ctinfo, exp, dptr);
+	ip_nat_sdp = rcu_dereference(ip_nat_sdp_hook);
+	if (ip_nat_sdp)
+		ret = ip_nat_sdp(pskb, ctinfo, exp, dptr);
 	else {
 		if (ip_conntrack_expect_related(exp) != 0)
 			ret = NF_DROP;
@@ -351,6 +353,7 @@ static int sip_help(struct sk_buff **psk
 	int matchoff, matchlen;
 	__be32 ipaddr;
 	u_int16_t port;
+	typeof(ip_nat_sip_hook) ip_nat_sip;
 
 	/* No Data ? */
 	dataoff = (*pskb)->nh.iph->ihl*4 + sizeof(struct udphdr);
@@ -368,8 +371,9 @@ static int sip_help(struct sk_buff **psk
 		goto out;
 	}
 
-	if (ip_nat_sip_hook) {
-		if (!ip_nat_sip_hook(pskb, ctinfo, ct, &dptr)) {
+	ip_nat_sip = rcu_dereference(ip_nat_sip_hook);
+	if (ip_nat_sip) {
+		if (!ip_nat_sip(pskb, ctinfo, ct, &dptr)) {
 			ret = NF_DROP;
 			goto out;
 		}
diff --git a/net/ipv4/netfilter/ip_conntrack_tftp.c b/net/ipv4/netfilter/ip_conntrack_tftp.c
index fe0b634..ef56de2 100644
--- a/net/ipv4/netfilter/ip_conntrack_tftp.c
+++ b/net/ipv4/netfilter/ip_conntrack_tftp.c
@@ -50,6 +50,7 @@ static int tftp_help(struct sk_buff **ps
 	struct tftphdr _tftph, *tfh;
 	struct ip_conntrack_expect *exp;
 	unsigned int ret = NF_ACCEPT;
+	typeof(ip_nat_tftp_hook) ip_nat_tftp;
 
 	tfh = skb_header_pointer(*pskb,
 				 (*pskb)->nh.iph->ihl*4+sizeof(struct udphdr),
@@ -81,8 +82,9 @@ static int tftp_help(struct sk_buff **ps
 		DEBUGP("expect: ");
 		DUMP_TUPLE(&exp->tuple);
 		DUMP_TUPLE(&exp->mask);
-		if (ip_nat_tftp_hook)
-			ret = ip_nat_tftp_hook(pskb, ctinfo, exp);
+		ip_nat_tftp = rcu_dereference(ip_nat_tftp_hook);
+		if (ip_nat_tftp)
+			ret = ip_nat_tftp(pskb, ctinfo, exp);
 		else if (ip_conntrack_expect_related(exp) != 0)
 			ret = NF_DROP;
 		ip_conntrack_expect_put(exp);
diff --git a/net/ipv4/netfilter/ip_nat_amanda.c b/net/ipv4/netfilter/ip_nat_amanda.c
index 3a88871..85df1a9 100644
--- a/net/ipv4/netfilter/ip_nat_amanda.c
+++ b/net/ipv4/netfilter/ip_nat_amanda.c
@@ -70,15 +70,14 @@ static unsigned int help(struct sk_buff 
 
 static void __exit ip_nat_amanda_fini(void)
 {
-	ip_nat_amanda_hook = NULL;
-	/* Make sure noone calls it, meanwhile. */
-	synchronize_net();
+	rcu_assign_pointer(ip_nat_amanda_hook, NULL);
+	synchronize_rcu();
 }
 
 static int __init ip_nat_amanda_init(void)
 {
-	BUG_ON(ip_nat_amanda_hook);
-	ip_nat_amanda_hook = help;
+	BUG_ON(rcu_dereference(ip_nat_amanda_hook));
+	rcu_assign_pointer(ip_nat_amanda_hook, help);
 	return 0;
 }
 
diff --git a/net/ipv4/netfilter/ip_nat_ftp.c b/net/ipv4/netfilter/ip_nat_ftp.c
index a71c233..913960e 100644
--- a/net/ipv4/netfilter/ip_nat_ftp.c
+++ b/net/ipv4/netfilter/ip_nat_ftp.c
@@ -156,15 +156,14 @@ static unsigned int ip_nat_ftp(struct sk
 
 static void __exit ip_nat_ftp_fini(void)
 {
-	ip_nat_ftp_hook = NULL;
-	/* Make sure noone calls it, meanwhile. */
-	synchronize_net();
+	rcu_assign_pointer(ip_nat_ftp_hook, NULL);
+	synchronize_rcu();
 }
 
 static int __init ip_nat_ftp_init(void)
 {
-	BUG_ON(ip_nat_ftp_hook);
-	ip_nat_ftp_hook = ip_nat_ftp;
+	BUG_ON(rcu_dereference(ip_nat_ftp_hook));
+	rcu_assign_pointer(ip_nat_ftp_hook, ip_nat_ftp);
 	return 0;
 }
 
diff --git a/net/ipv4/netfilter/ip_nat_helper_h323.c b/net/ipv4/netfilter/ip_nat_helper_h323.c
index 4a7d344..bdc99ef 100644
--- a/net/ipv4/netfilter/ip_nat_helper_h323.c
+++ b/net/ipv4/netfilter/ip_nat_helper_h323.c
@@ -563,25 +563,25 @@ static int nat_callforwarding(struct sk_
 /****************************************************************************/
 static int __init init(void)
 {
-	BUG_ON(set_h245_addr_hook != NULL);
-	BUG_ON(set_h225_addr_hook != NULL);
-	BUG_ON(set_sig_addr_hook != NULL);
-	BUG_ON(set_ras_addr_hook != NULL);
-	BUG_ON(nat_rtp_rtcp_hook != NULL);
-	BUG_ON(nat_t120_hook != NULL);
-	BUG_ON(nat_h245_hook != NULL);
-	BUG_ON(nat_callforwarding_hook != NULL);
-	BUG_ON(nat_q931_hook != NULL);
-
-	set_h245_addr_hook = set_h245_addr;
-	set_h225_addr_hook = set_h225_addr;
-	set_sig_addr_hook = set_sig_addr;
-	set_ras_addr_hook = set_ras_addr;
-	nat_rtp_rtcp_hook = nat_rtp_rtcp;
-	nat_t120_hook = nat_t120;
-	nat_h245_hook = nat_h245;
-	nat_callforwarding_hook = nat_callforwarding;
-	nat_q931_hook = nat_q931;
+	BUG_ON(rcu_dereference(set_h245_addr_hook) != NULL);
+	BUG_ON(rcu_dereference(set_h225_addr_hook) != NULL);
+	BUG_ON(rcu_dereference(set_sig_addr_hook) != NULL);
+	BUG_ON(rcu_dereference(set_ras_addr_hook) != NULL);
+	BUG_ON(rcu_dereference(nat_rtp_rtcp_hook) != NULL);
+	BUG_ON(rcu_dereference(nat_t120_hook) != NULL);
+	BUG_ON(rcu_dereference(nat_h245_hook) != NULL);
+	BUG_ON(rcu_dereference(nat_callforwarding_hook) != NULL);
+	BUG_ON(rcu_dereference(nat_q931_hook) != NULL);
+
+	rcu_assign_pointer(set_h245_addr_hook, set_h245_addr);
+	rcu_assign_pointer(set_h225_addr_hook, set_h225_addr);
+	rcu_assign_pointer(set_sig_addr_hook, set_sig_addr);
+	rcu_assign_pointer(set_ras_addr_hook, set_ras_addr);
+	rcu_assign_pointer(nat_rtp_rtcp_hook, nat_rtp_rtcp);
+	rcu_assign_pointer(nat_t120_hook, nat_t120);
+	rcu_assign_pointer(nat_h245_hook, nat_h245);
+	rcu_assign_pointer(nat_callforwarding_hook, nat_callforwarding);
+	rcu_assign_pointer(nat_q931_hook, nat_q931);
 
 	DEBUGP("ip_nat_h323: init success\n");
 	return 0;
@@ -590,16 +590,16 @@ static int __init init(void)
 /****************************************************************************/
 static void __exit fini(void)
 {
-	set_h245_addr_hook = NULL;
-	set_h225_addr_hook = NULL;
-	set_sig_addr_hook = NULL;
-	set_ras_addr_hook = NULL;
-	nat_rtp_rtcp_hook = NULL;
-	nat_t120_hook = NULL;
-	nat_h245_hook = NULL;
-	nat_callforwarding_hook = NULL;
-	nat_q931_hook = NULL;
-	synchronize_net();
+	rcu_assign_pointer(set_h245_addr_hook, NULL);
+	rcu_assign_pointer(set_h225_addr_hook, NULL);
+	rcu_assign_pointer(set_sig_addr_hook, NULL);
+	rcu_assign_pointer(set_ras_addr_hook, NULL);
+	rcu_assign_pointer(nat_rtp_rtcp_hook, NULL);
+	rcu_assign_pointer(nat_t120_hook, NULL);
+	rcu_assign_pointer(nat_h245_hook, NULL);
+	rcu_assign_pointer(nat_callforwarding_hook, NULL);
+	rcu_assign_pointer(nat_q931_hook, NULL);
+	synchronize_rcu();
 }
 
 /****************************************************************************/
diff --git a/net/ipv4/netfilter/ip_nat_helper_pptp.c b/net/ipv4/netfilter/ip_nat_helper_pptp.c
index acf55d8..ec957bb 100644
--- a/net/ipv4/netfilter/ip_nat_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_nat_helper_pptp.c
@@ -315,17 +315,17 @@ static int __init ip_nat_helper_pptp_ini
 	if (ret < 0)
 		return ret;
 
-	BUG_ON(ip_nat_pptp_hook_outbound);
-	ip_nat_pptp_hook_outbound = &pptp_outbound_pkt;
+	BUG_ON(rcu_dereference(ip_nat_pptp_hook_outbound));
+	rcu_assign_pointer(ip_nat_pptp_hook_outbound, pptp_outbound_pkt);
 
-	BUG_ON(ip_nat_pptp_hook_inbound);
-	ip_nat_pptp_hook_inbound = &pptp_inbound_pkt;
+	BUG_ON(rcu_dereference(ip_nat_pptp_hook_inbound));
+	rcu_assign_pointer(ip_nat_pptp_hook_inbound, pptp_inbound_pkt);
 
-	BUG_ON(ip_nat_pptp_hook_exp_gre);
-	ip_nat_pptp_hook_exp_gre = &pptp_exp_gre;
+	BUG_ON(rcu_dereference(ip_nat_pptp_hook_exp_gre));
+	rcu_assign_pointer(ip_nat_pptp_hook_exp_gre, pptp_exp_gre);
 
-	BUG_ON(ip_nat_pptp_hook_expectfn);
-	ip_nat_pptp_hook_expectfn = &pptp_nat_expected;
+	BUG_ON(rcu_dereference(ip_nat_pptp_hook_expectfn));
+	rcu_assign_pointer(ip_nat_pptp_hook_expectfn, pptp_nat_expected);
 
 	printk("ip_nat_pptp version %s loaded\n", IP_NAT_PPTP_VERSION);
 	return 0;
@@ -335,14 +335,13 @@ static void __exit ip_nat_helper_pptp_fi
 {
 	DEBUGP("cleanup_module\n" );
 
-	ip_nat_pptp_hook_expectfn = NULL;
-	ip_nat_pptp_hook_exp_gre = NULL;
-	ip_nat_pptp_hook_inbound = NULL;
-	ip_nat_pptp_hook_outbound = NULL;
+	rcu_assign_pointer(ip_nat_pptp_hook_expectfn, NULL);
+	rcu_assign_pointer(ip_nat_pptp_hook_exp_gre, NULL);
+	rcu_assign_pointer(ip_nat_pptp_hook_inbound, NULL);
+	rcu_assign_pointer(ip_nat_pptp_hook_outbound, NULL);
+	synchronize_rcu();
 
 	ip_nat_proto_gre_fini();
-	/* Make sure noone calls it, meanwhile */
-	synchronize_net();
 
 	printk("ip_nat_pptp version %s unloaded\n", IP_NAT_PPTP_VERSION);
 }
diff --git a/net/ipv4/netfilter/ip_nat_irc.c b/net/ipv4/netfilter/ip_nat_irc.c
index a767123..feb26b4 100644
--- a/net/ipv4/netfilter/ip_nat_irc.c
+++ b/net/ipv4/netfilter/ip_nat_irc.c
@@ -98,15 +98,14 @@ static unsigned int help(struct sk_buff 
 
 static void __exit ip_nat_irc_fini(void)
 {
-	ip_nat_irc_hook = NULL;
-	/* Make sure noone calls it, meanwhile. */
-	synchronize_net();
+	rcu_assign_pointer(ip_nat_irc_hook, NULL);
+	synchronize_rcu();
 }
 
 static int __init ip_nat_irc_init(void)
 {
-	BUG_ON(ip_nat_irc_hook);
-	ip_nat_irc_hook = help;
+	BUG_ON(rcu_dereference(ip_nat_irc_hook));
+	rcu_assign_pointer(ip_nat_irc_hook, help);
 	return 0;
 }
 
diff --git a/net/ipv4/netfilter/ip_nat_sip.c b/net/ipv4/netfilter/ip_nat_sip.c
index 71fc273..9fad980 100644
--- a/net/ipv4/netfilter/ip_nat_sip.c
+++ b/net/ipv4/netfilter/ip_nat_sip.c
@@ -230,18 +230,17 @@ static unsigned int ip_nat_sdp(struct sk
 
 static void __exit fini(void)
 {
-	ip_nat_sip_hook = NULL;
-	ip_nat_sdp_hook = NULL;
-	/* Make sure noone calls it, meanwhile. */
-	synchronize_net();
+	rcu_assign_pointer(ip_nat_sip_hook, NULL);
+	rcu_assign_pointer(ip_nat_sdp_hook, NULL);
+	synchronize_rcu();
 }
 
 static int __init init(void)
 {
-	BUG_ON(ip_nat_sip_hook);
-	BUG_ON(ip_nat_sdp_hook);
-	ip_nat_sip_hook = ip_nat_sip;
-	ip_nat_sdp_hook = ip_nat_sdp;
+	BUG_ON(rcu_dereference(ip_nat_sip_hook));
+	BUG_ON(rcu_dereference(ip_nat_sdp_hook));
+	rcu_assign_pointer(ip_nat_sip_hook, ip_nat_sip);
+	rcu_assign_pointer(ip_nat_sdp_hook, ip_nat_sdp);
 	return 0;
 }
 
diff --git a/net/ipv4/netfilter/ip_nat_tftp.c b/net/ipv4/netfilter/ip_nat_tftp.c
index 94a7801..6047935 100644
--- a/net/ipv4/netfilter/ip_nat_tftp.c
+++ b/net/ipv4/netfilter/ip_nat_tftp.c
@@ -55,15 +55,14 @@ static unsigned int help(struct sk_buff 
 
 static void __exit ip_nat_tftp_fini(void)
 {
-	ip_nat_tftp_hook = NULL;
-	/* Make sure noone calls it, meanwhile. */
-	synchronize_net();
+	rcu_assign_pointer(ip_nat_tftp_hook, NULL);
+	synchronize_rcu();
 }
 
 static int __init ip_nat_tftp_init(void)
 {
-	BUG_ON(ip_nat_tftp_hook);
-	ip_nat_tftp_hook = help;
+	BUG_ON(rcu_dereference(ip_nat_tftp_hook));
+	rcu_assign_pointer(ip_nat_tftp_hook, help);
 	return 0;
 }
 
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 05cb78c..2d23501 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -369,9 +369,9 @@ static int help(struct sk_buff **pskb,
 	struct ip_ct_ftp_master *ct_ftp_info = &nfct_help(ct)->help.ct_ftp_info;
 	struct nf_conntrack_expect *exp;
 	struct nf_conntrack_man cmd = {};
-
 	unsigned int i;
 	int found = 0, ends_in_nl;
+	typeof(nf_nat_ftp_hook) nf_nat_ftp;
 
 	/* Until there's been traffic both ways, don't look in packets. */
 	if (ctinfo != IP_CT_ESTABLISHED
@@ -520,9 +520,10 @@ static int help(struct sk_buff **pskb,
 
 	/* Now, NAT might want to mangle the packet, and register the
 	 * (possibly changed) expectation itself. */
-	if (nf_nat_ftp_hook)
-		ret = nf_nat_ftp_hook(pskb, ctinfo, search[dir][i].ftptype,
-				      matchoff, matchlen, exp, &seq);
+	nf_nat_ftp = rcu_dereference(nf_nat_ftp_hook);
+	if (nf_nat_ftp)
+		ret = nf_nat_ftp(pskb, ctinfo, search[dir][i].ftptype,
+				 matchoff, matchlen, exp, &seq);
 	else {
 		/* Can't expect this?  Best to drop packet now. */
 		if (nf_conntrack_expect_related(exp) != 0)
