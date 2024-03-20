Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 989AB1DDD6
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2024 10:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710931677; cv=none; b=cjv9IemPW5hSxwj5q+n7YpCOMjEamjZ4OT+ZJNN9TbYHkzuuHOE1NaHBc0YmpL+UAgu0Ie84U6ryams2831TRBFu5/Pt/f2h9uCMGMFs0aLl0S+MnliKCaO1/g3G+duMwwsUh+9I5Uov8y8S6VYi7i5vWUzuCTeYZm/Ivyzr9ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710931677; c=relaxed/simple;
	bh=xkgsf2rqmnXQI3FAIIhny2SvaK57Yx+tlsqK0a6d7CQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UQVhnexsmEeGBUu0xYXOW1yiwVTMTzbKjLSB1WlmDOKFlavIKgf/x++wmdLTOvu4zA1nsKtW70FngfIG8f/jMJkxMk00rK2G+G0YN5eMsauvNJw6BOd/+dPgGQmxj7BRwpnTDvlAhDddGfnSMkc5i8iVxyg31rY7uBmv2XABAww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Wed, 20 Mar 2024 11:47:50 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Sven Auhagen <sven.auhagen@voleatech.de>
Cc: netfilter-devel@vger.kernel.org, cratiu@nvidia.com, ozsh@nvidia.com,
	vladbu@nvidia.com, gal@nvidia.com, fw@strlen.de
Subject: Re: [PATCH nf] netfilter: flowtable: infer TCP state and timeout
 before flow teardown
Message-ID: <Zfq-1gES4VJg2zHe@calendula>
References: <20240318093915.10358-1-pablo@netfilter.org>
 <zxdruu67c2xs6zrhagjilitxu5ysik5x7zvk3kthzcclype22c@nevv7c7adz7z>
 <ZfqiHPpUfFwHI5-h@calendula>
 <lajzqkqbqptfa6m6ntyseutpmbnrrc4yb26x6lwjaxm3aldzvc@u33db2j37rtb>
 <ZfqnTJKyW1VSIOgY@calendula>
 <lderg42fd4jbcwsztkidn3lhnjhufj5yv3zsdu4dpsenzikkta@cya5vq3prnzf>
 <ZfqsAoSNA4DRsVga@calendula>
 <nvslglowbvxntlpftefkumbwn2gz72evwnfvv4q2qencte7wyn@3jejk23urzeg>
 <Zfqxq3HK_nsGRLhx@calendula>
 <xvnywodpmc3eui6k5kt6fnooq35533jsavkeha7af6c2fntxwm@u3bzj57ntong>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <xvnywodpmc3eui6k5kt6fnooq35533jsavkeha7af6c2fntxwm@u3bzj57ntong>

On Wed, Mar 20, 2024 at 11:29:05AM +0100, Sven Auhagen wrote:
> On Wed, Mar 20, 2024 at 10:51:39AM +0100, Pablo Neira Ayuso wrote:
> > On Wed, Mar 20, 2024 at 10:31:00AM +0100, Sven Auhagen wrote:
> > > On Wed, Mar 20, 2024 at 10:27:30AM +0100, Pablo Neira Ayuso wrote:
> > > > On Wed, Mar 20, 2024 at 10:20:29AM +0100, Sven Auhagen wrote:
> > > > > On Wed, Mar 20, 2024 at 10:07:24AM +0100, Pablo Neira Ayuso wrote:
> > > > > > On Wed, Mar 20, 2024 at 09:49:49AM +0100, Sven Auhagen wrote:
> > > > > > > On Wed, Mar 20, 2024 at 09:45:16AM +0100, Pablo Neira Ayuso wrote:
> > > > > > > > Hi Sven,
> > > > > > > > 
> > > > > > > > On Wed, Mar 20, 2024 at 09:39:16AM +0100, Sven Auhagen wrote:
> > > > > > > > > On Mon, Mar 18, 2024 at 10:39:15AM +0100, Pablo Neira Ayuso wrote:
> > > > > > > > [...]
> > > > > > > > > > diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> > > > > > > > > > index a0571339239c..481fe3d96bbc 100644
> > > > > > > > > > --- a/net/netfilter/nf_flow_table_core.c
> > > > > > > > > > +++ b/net/netfilter/nf_flow_table_core.c
> > > > > > > > > > @@ -165,10 +165,22 @@ void flow_offload_route_init(struct flow_offload *flow,
> > > > > > > > > >  }
> > > > > > > > > >  EXPORT_SYMBOL_GPL(flow_offload_route_init);
> > > > > > > > > >  
> > > > > > > > > > -static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
> > > > > > > > > > +static s32 flow_offload_fixup_tcp(struct net *net, struct nf_conn *ct,
> > > > > > > > > > +				  enum tcp_conntrack tcp_state)
> > > > > > > > > >  {
> > > > > > > > > > -	tcp->seen[0].td_maxwin = 0;
> > > > > > > > > > -	tcp->seen[1].td_maxwin = 0;
> > > > > > > > > > +	struct nf_tcp_net *tn = nf_tcp_pernet(net);
> > > > > > > > > > +
> > > > > > > > > > +	ct->proto.tcp.state = tcp_state;
> > > > > > > > > > +	ct->proto.tcp.seen[0].td_maxwin = 0;
> > > > > > > > > > +	ct->proto.tcp.seen[1].td_maxwin = 0;
> > > > > > > > > > +
> > > > > > > > > > +	/* Similar to mid-connection pickup with loose=1.
> > > > > > > > > > +	 * Avoid large ESTABLISHED timeout.
> > > > > > > > > > +	 */
> > > > > > > > > > +	if (tcp_state == TCP_CONNTRACK_ESTABLISHED)
> > > > > > > > > > +		return tn->timeouts[TCP_CONNTRACK_UNACK];
> > > > > > > > > 
> > > > > > > > > Hi Pablo,
> > > > > > > > > 
> > > > > > > > > I tested the patch but the part that sets the timout to UNACK is not
> > > > > > > > > very practical.
> > > > > > > > > For example my long running SSH connections get killed off by the firewall
> > > > > > > > > regularly now while beeing ESTABLISHED:
> > > > > > > > > 
> > > > > > > > > [NEW] tcp      6 120 SYN_SENT src=192.168.6.55 dst=192.168.10.22 sport=55582 dport=22 [UNREPLIED] src=192.168.10.22 dst=192.168.6.55 sport=22 dport=55582 mark=16777216
> > > > > > > > > [UPDATE] tcp      6 60 SYN_RECV src=192.168.6.55 dst=192.168.10.22 sport=55582 dport=22 src=192.168.10.22 dst=192.168.6.55 sport=22 dport=55582 mark=16777216
> > > > > > > > > [UPDATE] tcp      6 86400 ESTABLISHED src=192.168.6.55 dst=192.168.10.22 sport=55582 dport=22 src=192.168.10.22 dst=192.168.6.55 sport=22 dport=55582 [OFFLOAD] mark=16777216
> > > > > > > > > 
> > > > > > > > > [DESTROY] tcp      6 ESTABLISHED src=192.168.6.55 dst=192.168.10.22 sport=54941 dport=22 packets=133 bytes=13033 src=192.168.10.22 dst=192.168.6.55 sport=22 dport=54941 packets=95 bytes=15004 [ASSURED] mark=16777216 delta-time=1036
> > > > > > > > > 
> > > > > > > > > I would remove the if case here.
> > > > > > > > 
> > > > > > > > OK, I remove it and post a v2. Thanks!
> > > > > > > 
> > > > > > > Thanks and also the hardcoded TCP_CONNTRACK_ESTABLISHED in flow_offload_fixup_ct
> > > > > > > should be reverted to the real tcp state ct->proto.tcp.state.
> > > > > > 
> > > > > > ct->proto.tcp.state contains the state that was observed before
> > > > > > handling over this flow to the flowtable, in most cases, this should
> > > > > > be TCP_CONNTRACK_ESTABLISHED.
> > > > > > 
> > > > > > > This way we always set the current TCP timeout.
> > > > > > 
> > > > > > I can keep it to ct->proto.tcp.state but I wonder if it is better to
> > > > > > use a well known state such as TCP_CONNTRACK_ESTABLISHED to pick up from.
> > > > > 
> > > > > In case of a race condition or if something is off like my TCP_FIN
> > > > > that is beeing offloaded again setting to to ESTABLISHED hard coded
> > > > > will make the e.g. FIN or CLOSE a very long state.
> > > > > It is not guaranteed that we are still in ESTABLISHED when this code
> > > > > runs. Also for example we could have seen both FIN already before the
> > > > > flowtable gc runs.
> > > > 
> > > > OK, I just posted a v2, leave things as is. I agree it is better to
> > > > only address the issue you are observing at this time, it is possible
> > > > to revisit later.
> > > > 
> > > > Thanks!
> > > 
> > > Thanks, I will give it another try.
> > > I think for it to be foolproof we need
> > > to migrate the TCP state as well in flow_offload_teardown_tcp to FIN or CLOSE.
> > 
> > My patch already does it:
> > 
> > +void flow_offload_teardown_tcp(struct flow_offload *flow, bool fin)
> > +{
> > +       enum tcp_conntrack tcp_state;
> > +
> > +       if (fin)
> > +               tcp_state = TCP_CONNTRACK_FIN_WAIT;
> > +       else /* rst */
> > +               tcp_state = TCP_CONNTRACK_CLOSE;
> > +
> > +       flow_offload_fixup_tcp(nf_ct_net(flow->ct), flow->ct, tcp_state);
> > 
> > flow_offload_fixup_tcp() updates the TCP state to FIN / CLOSE state.
> > 
> > > They way thinks are right now we are open to a race condition from the reverse side of the
> > > connection to reoffload the connection while a FIN or RST is not processed by the netfilter code
> > > running after the flowtable code.
> > > The conenction is still in TCP established during that window and another packet can just
> > > push it back to the flowtable while the FIN or RST is not processed yet.
> > 
> > I don't see how:
> > 
> > static void nft_flow_offload_eval(const struct nft_expr *expr,
> >                                   ...
> > 
> >         switch (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum) {
> >         case IPPROTO_TCP:
> >                 tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt),
> >                                           sizeof(_tcph), &_tcph);
> >                 if (unlikely(!tcph || tcph->fin || tcph->rst ||
> >                              !nf_conntrack_tcp_established(ct)))
> >                         goto out;
> > 
> > this would now be either in FIN/CLOSE state.
> > 
> > FIN, RST packet does not trigger re-offload. And ACK packet would find
> > the entry in !nf_conntrack_tcp_established(ct).
> > 
> > What path could trigger re-offload after my latest patch?
> 
> From looking through the nf conntrack tcp code you need to spin_lock
> the TCP state change to avoid a race with another packet.

The flowtable owns the flow, packets belonging the flow cannot update
the TCP state while the flow is offloaded to the flowtable.

Once _TEARDOWN flag is set on, then packets get back to classic
conntrack path.

I don't see how such race can happen.
