Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 095C6144D20
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Apr 2024 09:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712827673; cv=none; b=kJD+lEElcHvRvWXcyZCdrZjAkpp0erriXQcyjaKT+C0H7wFfACBKrrgcD21ysp9BSbJilOWSxxTi/FMe/5YuihjgltIWOWTesMLNwa3EbZk3Bxb89/vp0bGgCq/XZGGYQ/OP7qQABoIAG/ZW1F1Tmg/uahIuy94fe9XF+6AIQ1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712827673; c=relaxed/simple;
	bh=TcFhskTUy8Yk5icNTcm0/InMXQgjZvl95WUKlQdDjoo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TRIEO/7aTKY582oxFCBgi4S8hXuY1fOjDbdGB/EwOzflnF1qzHNZ962KW4FuKtCXyg4diQddn/UI0XniATnurEpyL+AF+rycP7bcFox4n2XwUSslawc7rY1SywbVRVF2prptYwRS8bCeCGRtOuilAJQR6pmyyyKt3LKytAcoits=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Thu, 11 Apr 2024 11:27:44 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Sven Auhagen <sven.auhagen@voleatech.de>
Cc: netfilter-devel@vger.kernel.org, cratiu@nvidia.com, ozsh@nvidia.com,
	vladbu@nvidia.com, gal@nvidia.com, fw@strlen.de
Subject: Re: [PATCH nf] netfilter: flowtable: infer TCP state and timeout
 before flow teardown
Message-ID: <ZhetEIvz_vCB-A5D@calendula>
References: <ZfqsAoSNA4DRsVga@calendula>
 <nvslglowbvxntlpftefkumbwn2gz72evwnfvv4q2qencte7wyn@3jejk23urzeg>
 <Zfqxq3HK_nsGRLhx@calendula>
 <xvnywodpmc3eui6k5kt6fnooq35533jsavkeha7af6c2fntxwm@u3bzj57ntong>
 <Zfq-1gES4VJg2zHe@calendula>
 <o7kxkadlzt2ux5bbdcsgxlfxnfedzxv4jlfd3xnhri6qpr5w3n@2vmkj5o3yrek>
 <ZfrYpvJFrrajPbHM@calendula>
 <x3qvcfxgdmurfnydhrs7ao6fmxxubmhxs2mjk24yn5zjfbo3h5@esbr3eff7bir>
 <ZhUibxdb005sYZNq@calendula>
 <uhn7bt3jdrvmczhlw3dsrinb2opr2qksnbip7asekilgczm35v@hyvzkxrgdhgn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nXLpz9MNaYotYXUY"
Content-Disposition: inline
In-Reply-To: <uhn7bt3jdrvmczhlw3dsrinb2opr2qksnbip7asekilgczm35v@hyvzkxrgdhgn>


--nXLpz9MNaYotYXUY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Tue, Apr 09, 2024 at 01:35:15PM +0200, Sven Auhagen wrote:
> On Tue, Apr 09, 2024 at 01:11:43PM +0200, Pablo Neira Ayuso wrote:
> > Hi Sven,
> > 
> > On Mon, Apr 08, 2024 at 07:24:43AM +0200, Sven Auhagen wrote:
> > > Hi Pablo,
> > > 
> > > after some testing the problem only happens very rarely now.
> > > I suspect it happens only on connections that are at some point
> > > one way only or in some other way not in a correct state anymore.
> > > Never the less your latest patches are very good and reduce the problem
> > > to an absolute minimum that FIN WAIT is offlodaded and the timeout
> > > is correct now.
> > 
> > Thanks for testing, I am going to submit this patch.
> > 
> > If you have a bit more cycles, I still would like to know what corner
> > case scenario is still triggering this so...
> > 
> > > Here is one example if a flow that still is in FIN WAIT:
> > > 
> > > [NEW] tcp      6 120 SYN_SENT src=fd00::192:168:5:32 dst=2a05:d014:687:ed01::21 sport=58790 dport=443 [UNREPLIED] src=2a05:d014:687:ed01::21 dst=2003:a:c7f:e5e8:a3ae:63f7:7f92:e286 sport=443 dport=60848 mark=16777216
> > > [UPDATE] tcp      6 60 SYN_RECV src=fd00::192:168:5:32 dst=2a05:d014:687:ed01::21 sport=58790 dport=443 src=2a05:d014:687:ed01::21 dst=2003:a:c7f:e5e8:a3ae:63f7:7f92:e286 sport=443 dport=60848 mark=16777216
> > > [UPDATE] tcp      6 86400 ESTABLISHED src=fd00::192:168:5:32 dst=2a05:d014:687:ed01::21 sport=58790 dport=443 src=2a05:d014:687:ed01::21 dst=2003:a:c7f:e5e8:a3ae:63f7:7f92:e286 sport=443 dport=60848 [OFFLOAD] mark=16777216
> > > [UPDATE] tcp      6 120 FIN_WAIT src=fd00::192:168:5:32 dst=2a05:d014:687:ed01::21 sport=58790 dport=443 src=2a05:d014:687:ed01::21 dst=2003:a:c7f:e5e8:a3ae:63f7:7f92:e286 sport=443 dport=60848 [OFFLOAD] mark=16777216
> > > [UPDATE] tcp      6 30 LAST_ACK src=fd00::192:168:5:32 dst=2a05:d014:687:ed01::21 sport=58790 dport=443 src=2a05:d014:687:ed01::21 dst=2003:a:c7f:e5e8:a3ae:63f7:7f92:e286 sport=443 dport=60848 [ASSURED] mark=16777216
> > >  [UPDATE] tcp      6 120 TIME_WAIT src=fd00::192:168:5:32 dst=2a05:d014:687:ed01::21 sport=58790 dport=443 src=2a05:d014:687:ed01::21 dst=2003:a:c7f:e5e8:a3ae:63f7:7f92:e286 sport=443 dport=60848 [ASSURED] mark=16777216
> > >  [DESTROY] tcp      6 TIME_WAIT src=fd00::192:168:5:32 dst=2a05:d014:687:ed01::21 sport=58790 dport=443 packets=15 bytes=1750 src=2a05:d014:687:ed01::21 dst=2003:a:c7f:e5e8:a3ae:63f7:7f92:e286 sport=443 dport=60848 packets=13 bytes=6905 [ASSURED] mark=16777216 delta-time=120
> > 
> > ... could you run conntrack -E -o timestamp? I'd like to know if this is
> > a flow that is handed over back to classic path after 30 seconds, then
> > being placed in the flowtable again.
> 
> Sure here is a fresh output:
> 
> [1712662404.573225]	    [NEW] tcp      6 120 SYN_SENT src=192.168.7.101 dst=157.240.251.61 sport=52717 dport=5222 [UNREPLIED] src=157.240.251.61 dst=87.138.198.79 sport=5222 dport=26886 mark=25165825
> [1712662404.588094]	 [UPDATE] tcp      6 60 SYN_RECV src=192.168.7.101 dst=157.240.251.61 sport=52717 dport=5222 src=157.240.251.61 dst=87.138.198.79 sport=5222 dport=26886 mark=25165825
> [1712662404.591802]	 [UPDATE] tcp      6 86400 ESTABLISHED src=192.168.7.101 dst=157.240.251.61 sport=52717 dport=5222 src=157.240.251.61 dst=87.138.198.79 sport=5222 dport=26886 [OFFLOAD] mark=25165825
> [1712662405.682563]	 [UPDATE] tcp      6 120 FIN_WAIT src=192.168.7.101 dst=157.240.251.61 sport=52717 dport=5222 src=157.240.251.61 dst=87.138.198.79 sport=5222 dport=26886 [OFFLOAD] mark=25165825

It is happening right away, a bit more of 1 second after.

I can also see IP_CT_TCP_FLAG_CLOSE_INIT is not set on when ct->state
is adjusted to _FIN_WAIT state in the fixup routine.

There are also packets that might trigger transitions to sIG
(ignored) in TCP tracking. Probably conntrack -E is misleading because
this does not allow us to see what actual packets are coming after the
fin.

Can you give a try to this untested patch? It applies on top of the
two patches you already have for TCP and UDP.

> [1712662405.689501]	 [UPDATE] tcp      6 30 LAST_ACK src=192.168.7.101 dst=157.240.251.61 sport=52717 dport=5222 src=157.240.251.61 dst=87.138.198.79 sport=5222 dport=26886 [ASSURED] mark=25165825
> [1712662405.704370]	 [UPDATE] tcp      6 120 TIME_WAIT src=192.168.7.101 dst=157.240.251.61 sport=52717 dport=5222 src=157.240.251.61 dst=87.138.198.79 sport=5222 dport=26886 [ASSURED] mark=25165825

Can you also enable -o id,timestamp? The id should tell us if we are
always talking on the same object.

> [1712662451.967906]	[DESTROY] tcp      6 ESTABLISHED src=192.168.6.122 dst=52.98.243.2 sport=52717 dport=443 packets=14 bytes=4134 src=52.98.243.2 dst=37.24.174.42 sport=443 dport=20116 packets=17 bytes=13712 [ASSURED] mark=16777216 delta-time=140

--nXLpz9MNaYotYXUY
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="adjust-ct-tcp-flags.patch"

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 8507deed6b1f..2388c4fe99a0 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -293,7 +293,7 @@ int nf_flow_table_init(struct nf_flowtable *flow_table);
 void nf_flow_table_free(struct nf_flowtable *flow_table);
 
 void flow_offload_teardown(struct flow_offload *flow);
-void flow_offload_teardown_tcp(struct flow_offload *flow, bool fin);
+void flow_offload_teardown_tcp(struct flow_offload *flow, bool fin, int dir);
 
 void nf_flow_snat_port(const struct flow_offload *flow,
 		       struct sk_buff *skb, unsigned int thoff,
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 16068ef04490..e3a7d8eff727 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -350,18 +350,21 @@ void flow_offload_teardown(struct flow_offload *flow)
 }
 EXPORT_SYMBOL_GPL(flow_offload_teardown);
 
-void flow_offload_teardown_tcp(struct flow_offload *flow, bool fin)
+void flow_offload_teardown_tcp(struct flow_offload *flow, bool fin, int dir)
 {
+	struct nf_conn *ct = flow->ct;
 	enum tcp_conntrack tcp_state;
 
-	if (fin)
+	if (fin) {
 		tcp_state = TCP_CONNTRACK_FIN_WAIT;
-	else /* rst */
+		ct->proto.tcp.seen[dir].flags |= IP_CT_TCP_FLAG_CLOSE_INIT;
+	} else { /* rst */
 		tcp_state = TCP_CONNTRACK_CLOSE;
+	}
 
-	flow_offload_fixup_tcp(nf_ct_net(flow->ct), flow->ct, tcp_state);
+	flow_offload_fixup_tcp(nf_ct_net(ct), ct, tcp_state);
 	smp_mb__before_atomic();
-	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
+	clear_bit(IPS_OFFLOAD_BIT, &ct->status);
 	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
 }
 EXPORT_SYMBOL_GPL(flow_offload_teardown_tcp);
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 9840ab5e3ae6..04fabfa9ff7e 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -20,7 +20,7 @@
 #include <linux/udp.h>
 
 static int nf_flow_state_check(struct flow_offload *flow, int proto,
-			       struct sk_buff *skb, unsigned int thoff)
+			       struct sk_buff *skb, unsigned int thoff, int dir)
 {
 	struct tcphdr *tcph;
 
@@ -29,7 +29,7 @@ static int nf_flow_state_check(struct flow_offload *flow, int proto,
 
 	tcph = (void *)(skb_network_header(skb) + thoff);
 	if (unlikely(tcph->fin || tcph->rst)) {
-		flow_offload_teardown_tcp(flow, tcph->fin);
+		flow_offload_teardown_tcp(flow, tcph->fin, dir);
 		return -1;
 	}
 
@@ -379,7 +379,7 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 
 	iph = (struct iphdr *)(skb_network_header(skb) + ctx->offset);
 	thoff = (iph->ihl * 4) + ctx->offset;
-	if (nf_flow_state_check(flow, iph->protocol, skb, thoff))
+	if (nf_flow_state_check(flow, iph->protocol, skb, thoff, dir))
 		return 0;
 
 	if (!nf_flow_dst_check(&tuplehash->tuple)) {
@@ -658,7 +658,7 @@ static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
 
 	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + ctx->offset);
 	thoff = sizeof(*ip6h) + ctx->offset;
-	if (nf_flow_state_check(flow, ip6h->nexthdr, skb, thoff))
+	if (nf_flow_state_check(flow, ip6h->nexthdr, skb, thoff, dir))
 		return 0;
 
 	if (!nf_flow_dst_check(&tuplehash->tuple)) {

--nXLpz9MNaYotYXUY--
