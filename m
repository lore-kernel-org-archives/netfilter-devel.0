Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C81F53B78B
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2024 12:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710938291; cv=none; b=qcjI+VcGTCq+gFMU55R3wxVqeEIbZFzMXBeGh/FD0zRyh5AoXk7/94aPw6nshyHj1B2RAMjLU9i6WOLeavE3KLykUZbbvJsPqOcpLu/QDttHfN1Xne7M9AxOMMBpX1qV3KDNddBv8HznmwgUhqF0PndqtkUExmJI+hPidFMLaM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710938291; c=relaxed/simple;
	bh=cd4lOXtpiE8HAt4v0TgPevL0ndgwOpHuZsBlzKRSA/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hkIzs2P6xIv8WldNgLDNB6U0LysSNn5E9a2g9dbv8N9c4ZPaFfwcaZ2ZeC41Dld+eZjWLd89Xxrauvxroa688MXN243O69qMnDekfAH0zMkV10eBVW58eGMW7jLC9wZWgKNHYNZeFGiu44fqRPYqmbvdHzZXU1IOjpX5JzwjhN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Wed, 20 Mar 2024 13:37:58 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Sven Auhagen <sven.auhagen@voleatech.de>
Cc: netfilter-devel@vger.kernel.org, cratiu@nvidia.com, ozsh@nvidia.com,
	vladbu@nvidia.com, gal@nvidia.com, fw@strlen.de
Subject: Re: [PATCH nf] netfilter: flowtable: infer TCP state and timeout
 before flow teardown
Message-ID: <ZfrYpvJFrrajPbHM@calendula>
References: <ZfqiHPpUfFwHI5-h@calendula>
 <lajzqkqbqptfa6m6ntyseutpmbnrrc4yb26x6lwjaxm3aldzvc@u33db2j37rtb>
 <ZfqnTJKyW1VSIOgY@calendula>
 <lderg42fd4jbcwsztkidn3lhnjhufj5yv3zsdu4dpsenzikkta@cya5vq3prnzf>
 <ZfqsAoSNA4DRsVga@calendula>
 <nvslglowbvxntlpftefkumbwn2gz72evwnfvv4q2qencte7wyn@3jejk23urzeg>
 <Zfqxq3HK_nsGRLhx@calendula>
 <xvnywodpmc3eui6k5kt6fnooq35533jsavkeha7af6c2fntxwm@u3bzj57ntong>
 <Zfq-1gES4VJg2zHe@calendula>
 <o7kxkadlzt2ux5bbdcsgxlfxnfedzxv4jlfd3xnhri6qpr5w3n@2vmkj5o3yrek>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qvXAVsoeUackZLl/"
Content-Disposition: inline
In-Reply-To: <o7kxkadlzt2ux5bbdcsgxlfxnfedzxv4jlfd3xnhri6qpr5w3n@2vmkj5o3yrek>


--qvXAVsoeUackZLl/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Wed, Mar 20, 2024 at 12:15:51PM +0100, Sven Auhagen wrote:
> On Wed, Mar 20, 2024 at 11:47:50AM +0100, Pablo Neira Ayuso wrote:
> > On Wed, Mar 20, 2024 at 11:29:05AM +0100, Sven Auhagen wrote:
> > > On Wed, Mar 20, 2024 at 10:51:39AM +0100, Pablo Neira Ayuso wrote:
> > > > On Wed, Mar 20, 2024 at 10:31:00AM +0100, Sven Auhagen wrote:
> > > > > On Wed, Mar 20, 2024 at 10:27:30AM +0100, Pablo Neira Ayuso wrote:
> > > > > > On Wed, Mar 20, 2024 at 10:20:29AM +0100, Sven Auhagen wrote:
> > > > > > > On Wed, Mar 20, 2024 at 10:07:24AM +0100, Pablo Neira Ayuso wrote:
> > > > > > > > On Wed, Mar 20, 2024 at 09:49:49AM +0100, Sven Auhagen wrote:
> > > > > > > > > On Wed, Mar 20, 2024 at 09:45:16AM +0100, Pablo Neira Ayuso wrote:
> > > > > > > > > > Hi Sven,
> > > > > > > > > > 
> > > > > > > > > > On Wed, Mar 20, 2024 at 09:39:16AM +0100, Sven Auhagen wrote:
> > > > > > > > > > > On Mon, Mar 18, 2024 at 10:39:15AM +0100, Pablo Neira Ayuso wrote:
> > > > > > > > > > [...]
> > > > > > > > > > > > diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> > > > > > > > > > > > index a0571339239c..481fe3d96bbc 100644
> > > > > > > > > > > > --- a/net/netfilter/nf_flow_table_core.c
> > > > > > > > > > > > +++ b/net/netfilter/nf_flow_table_core.c
> > > > > > > > > > > > @@ -165,10 +165,22 @@ void flow_offload_route_init(struct flow_offload *flow,
> > > > > > > > > > > >  }
> > > > > > > > > > > >  EXPORT_SYMBOL_GPL(flow_offload_route_init);
> > > > > > > > > > > >  
> > > > > > > > > > > > -static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
> > > > > > > > > > > > +static s32 flow_offload_fixup_tcp(struct net *net, struct nf_conn *ct,
> > > > > > > > > > > > +				  enum tcp_conntrack tcp_state)
> > > > > > > > > > > >  {
> > > > > > > > > > > > -	tcp->seen[0].td_maxwin = 0;
> > > > > > > > > > > > -	tcp->seen[1].td_maxwin = 0;
> > > > > > > > > > > > +	struct nf_tcp_net *tn = nf_tcp_pernet(net);
> > > > > > > > > > > > +
> > > > > > > > > > > > +	ct->proto.tcp.state = tcp_state;
> > > > > > > > > > > > +	ct->proto.tcp.seen[0].td_maxwin = 0;
> > > > > > > > > > > > +	ct->proto.tcp.seen[1].td_maxwin = 0;
> > > > > > > > > > > > +
> > > > > > > > > > > > +	/* Similar to mid-connection pickup with loose=1.
> > > > > > > > > > > > +	 * Avoid large ESTABLISHED timeout.
> > > > > > > > > > > > +	 */
> > > > > > > > > > > > +	if (tcp_state == TCP_CONNTRACK_ESTABLISHED)
> > > > > > > > > > > > +		return tn->timeouts[TCP_CONNTRACK_UNACK];
> > > > > > > > > > > 
> > > > > > > > > > > Hi Pablo,
> > > > > > > > > > > 
> > > > > > > > > > > I tested the patch but the part that sets the timout to UNACK is not
> > > > > > > > > > > very practical.
> > > > > > > > > > > For example my long running SSH connections get killed off by the firewall
> > > > > > > > > > > regularly now while beeing ESTABLISHED:
> > > > > > > > > > > 
> > > > > > > > > > > [NEW] tcp      6 120 SYN_SENT src=192.168.6.55 dst=192.168.10.22 sport=55582 dport=22 [UNREPLIED] src=192.168.10.22 dst=192.168.6.55 sport=22 dport=55582 mark=16777216
> > > > > > > > > > > [UPDATE] tcp      6 60 SYN_RECV src=192.168.6.55 dst=192.168.10.22 sport=55582 dport=22 src=192.168.10.22 dst=192.168.6.55 sport=22 dport=55582 mark=16777216
> > > > > > > > > > > [UPDATE] tcp      6 86400 ESTABLISHED src=192.168.6.55 dst=192.168.10.22 sport=55582 dport=22 src=192.168.10.22 dst=192.168.6.55 sport=22 dport=55582 [OFFLOAD] mark=16777216
> > > > > > > > > > > 
> > > > > > > > > > > [DESTROY] tcp      6 ESTABLISHED src=192.168.6.55 dst=192.168.10.22 sport=54941 dport=22 packets=133 bytes=13033 src=192.168.10.22 dst=192.168.6.55 sport=22 dport=54941 packets=95 bytes=15004 [ASSURED] mark=16777216 delta-time=1036
> > > > > > > > > > > 
> > > > > > > > > > > I would remove the if case here.
> > > > > > > > > > 
> > > > > > > > > > OK, I remove it and post a v2. Thanks!
> > > > > > > > > 
> > > > > > > > > Thanks and also the hardcoded TCP_CONNTRACK_ESTABLISHED in flow_offload_fixup_ct
> > > > > > > > > should be reverted to the real tcp state ct->proto.tcp.state.
> > > > > > > > 
> > > > > > > > ct->proto.tcp.state contains the state that was observed before
> > > > > > > > handling over this flow to the flowtable, in most cases, this should
> > > > > > > > be TCP_CONNTRACK_ESTABLISHED.
> > > > > > > > 
> > > > > > > > > This way we always set the current TCP timeout.
> > > > > > > > 
> > > > > > > > I can keep it to ct->proto.tcp.state but I wonder if it is better to
> > > > > > > > use a well known state such as TCP_CONNTRACK_ESTABLISHED to pick up from.
> > > > > > > 
> > > > > > > In case of a race condition or if something is off like my TCP_FIN
> > > > > > > that is beeing offloaded again setting to to ESTABLISHED hard coded
> > > > > > > will make the e.g. FIN or CLOSE a very long state.
> > > > > > > It is not guaranteed that we are still in ESTABLISHED when this code
> > > > > > > runs. Also for example we could have seen both FIN already before the
> > > > > > > flowtable gc runs.
> > > > > > 
> > > > > > OK, I just posted a v2, leave things as is. I agree it is better to
> > > > > > only address the issue you are observing at this time, it is possible
> > > > > > to revisit later.
> > > > > > 
> > > > > > Thanks!
> > > > > 
> > > > > Thanks, I will give it another try.
> > > > > I think for it to be foolproof we need
> > > > > to migrate the TCP state as well in flow_offload_teardown_tcp to FIN or CLOSE.
> > > > 
> > > > My patch already does it:
> > > > 
> > > > +void flow_offload_teardown_tcp(struct flow_offload *flow, bool fin)
> > > > +{
> > > > +       enum tcp_conntrack tcp_state;
> > > > +
> > > > +       if (fin)
> > > > +               tcp_state = TCP_CONNTRACK_FIN_WAIT;
> > > > +       else /* rst */
> > > > +               tcp_state = TCP_CONNTRACK_CLOSE;
> > > > +
> > > > +       flow_offload_fixup_tcp(nf_ct_net(flow->ct), flow->ct, tcp_state);
> > > > 
> > > > flow_offload_fixup_tcp() updates the TCP state to FIN / CLOSE state.
> > > > 
> > > > > They way thinks are right now we are open to a race condition from the reverse side of the
> > > > > connection to reoffload the connection while a FIN or RST is not processed by the netfilter code
> > > > > running after the flowtable code.
> > > > > The conenction is still in TCP established during that window and another packet can just
> > > > > push it back to the flowtable while the FIN or RST is not processed yet.
> > > > 
> > > > I don't see how:
> > > > 
> > > > static void nft_flow_offload_eval(const struct nft_expr *expr,
> > > >                                   ...
> > > > 
> > > >         switch (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum) {
> > > >         case IPPROTO_TCP:
> > > >                 tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt),
> > > >                                           sizeof(_tcph), &_tcph);
> > > >                 if (unlikely(!tcph || tcph->fin || tcph->rst ||
> > > >                              !nf_conntrack_tcp_established(ct)))
> > > >                         goto out;
> > > > 
> > > > this would now be either in FIN/CLOSE state.
> > > > 
> > > > FIN, RST packet does not trigger re-offload. And ACK packet would find
> > > > the entry in !nf_conntrack_tcp_established(ct).
> > > > 
> > > > What path could trigger re-offload after my latest patch?
> > > 
> > > From looking through the nf conntrack tcp code you need to spin_lock
> > > the TCP state change to avoid a race with another packet.
> > 
> > The flowtable owns the flow, packets belonging the flow cannot update
> > the TCP state while the flow is offloaded to the flowtable.
> > 
> > Once _TEARDOWN flag is set on, then packets get back to classic
> > conntrack path.
> 
> Hmm alright, something is going wrong somewhere and it looks a lot like
> a race condition :)

This check is racy, another packet could alter the ct state right
after it evaluates true.

         switch (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum) {
         case IPPROTO_TCP:
                 tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt),
                                           sizeof(_tcph), &_tcph);
                 if (unlikely(!tcph || tcph->fin || tcph->rst ||
                              !nf_conntrack_tcp_established(ct))) <-------
                         goto out;

Sequence would be:

1) flow expires (after 30 seconds), goes back to conntrack in established state
2) packet re-offloads the flow and nf_conntrack_tcp_established(ct) evaluates true.
3) FIN packet races to update conntrack getting to FIN_WAIT while re-offloading
   the flow.

then you see FIN_WAIT and offload, it could happen with an expired
flow that goes back to conntrack.

But I am not sure yet if this is the case you're observing there.

> I mean just in theory it is not guaranteed that both directions send all
> packets through the flowtable just because it is offloaded.
> A variety of error checks might send a packet back to the slow path.

There is the mtu check that is lacking the teardown, but that should
only affect UDP traffic. A patch from Felix decided has cached the mtu
in the flow entry. That is also probably convenient to have, but it
looks like a different issue, I will also post a patch for this issue.

--qvXAVsoeUackZLl/
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="x.patch"

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 13b6c453d8bc..627268c32aaa 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -372,8 +372,10 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
 	mtu = flow->tuplehash[dir].tuple.mtu + ctx->offset;
-	if (unlikely(nf_flow_exceeds_mtu(skb, mtu)))
+	if (unlikely(nf_flow_exceeds_mtu(skb, mtu))) {
+		flow_offload_teardown(flow);
 		return 0;
+	}
 
 	iph = (struct iphdr *)(skb_network_header(skb) + ctx->offset);
 	thoff = (iph->ihl * 4) + ctx->offset;
@@ -651,8 +653,10 @@ static int nf_flow_offload_ipv6_forward(struct nf_flowtable_ctx *ctx,
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
 	mtu = flow->tuplehash[dir].tuple.mtu + ctx->offset;
-	if (unlikely(nf_flow_exceeds_mtu(skb, mtu)))
+	if (unlikely(nf_flow_exceeds_mtu(skb, mtu))) {
+		flow_offload_teardown(flow);
 		return 0;
+	}
 
 	ip6h = (struct ipv6hdr *)(skb_network_header(skb) + ctx->offset);
 	thoff = sizeof(*ip6h) + ctx->offset;

--qvXAVsoeUackZLl/--
