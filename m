From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/04]: sip: Fix RTP address NAT
Date: Thu,  3 May 2007 03:26:00 +0200 (MEST)
Message-ID: <20070503012441.12818.26845.sendpatchset@localhost.localdomain>
References: <20070503012437.12818.39126.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070503012437.12818.39126.sendpatchset@localhost.localdomain>
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

[NETFILTER]: sip: Fix RTP address NAT

I needed to use this recently to talk to a Cisco server.  In my case
I only did SNAT while the Cisco server used a different address for
RTP traffic than the one for SIP.  I discovered that nf_nat_sip NATed
the RTP address to the SIP one which was unnecessary but OK.  However,
in doing so it did not DNAT the destination address on the RTP traffic
to the Cisco back to the original RTP address.

This patch corrects this by noting down the RTP address and using it
when the expectation fires.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 63ce4c4edbf300cf7c5b1d219feca1e687bdbc4b
tree 105983a8043f83a79b0149eb8acc2c189217288d
parent 08130cb0faa275f6a8290a39942e58c18cec3533
author Herbert Xu <herbert@gondor.apana.org.au> Wed, 02 May 2007 16:17:39 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 03 May 2007 02:51:50 +0200

 net/ipv4/netfilter/nf_nat_sip.c |   26 +++++++++++++++++++++++++-
 1 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_sip.c b/net/ipv4/netfilter/nf_nat_sip.c
index bfd88e4..fac97cf 100644
--- a/net/ipv4/netfilter/nf_nat_sip.c
+++ b/net/ipv4/netfilter/nf_nat_sip.c
@@ -222,6 +222,29 @@ static unsigned int mangle_sdp(struct sk_buff **pskb,
 	return mangle_content_len(pskb, ctinfo, ct, dptr);
 }
 
+static void ip_nat_sdp_expect(struct nf_conn *ct,
+			      struct nf_conntrack_expect *exp)
+{
+	struct nf_nat_range range;
+
+	/* This must be a fresh one. */
+	BUG_ON(ct->status & IPS_NAT_DONE_MASK);
+
+	/* Change src to where master sends to */
+	range.flags = IP_NAT_RANGE_MAP_IPS;
+	range.min_ip = range.max_ip
+		= ct->master->tuplehash[!exp->dir].tuple.dst.u3.ip;
+	/* hook doesn't matter, but it has to do source manip */
+	nf_nat_setup_info(ct, &range, NF_IP_POST_ROUTING);
+
+	/* For DST manip, map port here to where it's expected. */
+	range.flags = (IP_NAT_RANGE_MAP_IPS | IP_NAT_RANGE_PROTO_SPECIFIED);
+	range.min = range.max = exp->saved_proto;
+	range.min_ip = range.max_ip = exp->saved_ip;
+	/* hook doesn't matter, but it has to do destination manip */
+	nf_nat_setup_info(ct, &range, NF_IP_PRE_ROUTING);
+}
+
 /* So, this packet has hit the connection tracking matching code.
    Mangle it, and change the expectation to match the new version. */
 static unsigned int ip_nat_sdp(struct sk_buff **pskb,
@@ -239,13 +262,14 @@ static unsigned int ip_nat_sdp(struct sk_buff **pskb,
 	/* Connection will come from reply */
 	newip = ct->tuplehash[!dir].tuple.dst.u3.ip;
 
+	exp->saved_ip = exp->tuple.dst.u3.ip;
 	exp->tuple.dst.u3.ip = newip;
 	exp->saved_proto.udp.port = exp->tuple.dst.u.udp.port;
 	exp->dir = !dir;
 
 	/* When you see the packet, we need to NAT it the same as the
 	   this one. */
-	exp->expectfn = nf_nat_follow_master;
+	exp->expectfn = ip_nat_sdp_expect;
 
 	/* Try to get same port: if not, try to change it. */
 	for (port = ntohs(exp->saved_proto.udp.port); port != 0; port++) {
