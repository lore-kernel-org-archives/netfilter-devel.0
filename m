Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 170A1383A1
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2024 09:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710926856; cv=none; b=GaERwvNDD+qULwgXaPUzfP5Pge7YXt2KUfey1QfqnFpnG5S1GxyrSq3NpU/b75zMiw0OOQGwK9x1p4ka0+0ZOR84cBOcE3ZAs+LxpvknyOBhZsBKPiM8Q9e0aORDhmC3u6kzNPDY0uwkinyXfJthznbe2JpteRswBrHE104yP1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710926856; c=relaxed/simple;
	bh=IiXMcra1bIclgmYJoe/e7nWkqfrEzHFH7vu0RQgVcW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YegKUZSJWqP4v+5JjzhTwY8PcQMow1lmPZYXAbw0260xjCfCxfR4PwBIOrVR/yPu3WSt0ReqishiBWAab2plbD/NaM5VDR19zak3PSiLL+scZSKH2qp3pTynqc+K26CSAF94cuA+7uOvxyyqvO8cpgVRlOgfpTUjO9/e8dgFKWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Wed, 20 Mar 2024 10:27:30 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Sven Auhagen <sven.auhagen@voleatech.de>
Cc: netfilter-devel@vger.kernel.org, cratiu@nvidia.com, ozsh@nvidia.com,
	vladbu@nvidia.com, gal@nvidia.com, fw@strlen.de
Subject: Re: [PATCH nf] netfilter: flowtable: infer TCP state and timeout
 before flow teardown
Message-ID: <ZfqsAoSNA4DRsVga@calendula>
References: <20240318093915.10358-1-pablo@netfilter.org>
 <zxdruu67c2xs6zrhagjilitxu5ysik5x7zvk3kthzcclype22c@nevv7c7adz7z>
 <ZfqiHPpUfFwHI5-h@calendula>
 <lajzqkqbqptfa6m6ntyseutpmbnrrc4yb26x6lwjaxm3aldzvc@u33db2j37rtb>
 <ZfqnTJKyW1VSIOgY@calendula>
 <lderg42fd4jbcwsztkidn3lhnjhufj5yv3zsdu4dpsenzikkta@cya5vq3prnzf>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <lderg42fd4jbcwsztkidn3lhnjhufj5yv3zsdu4dpsenzikkta@cya5vq3prnzf>

On Wed, Mar 20, 2024 at 10:20:29AM +0100, Sven Auhagen wrote:
> On Wed, Mar 20, 2024 at 10:07:24AM +0100, Pablo Neira Ayuso wrote:
> > On Wed, Mar 20, 2024 at 09:49:49AM +0100, Sven Auhagen wrote:
> > > On Wed, Mar 20, 2024 at 09:45:16AM +0100, Pablo Neira Ayuso wrote:
> > > > Hi Sven,
> > > > 
> > > > On Wed, Mar 20, 2024 at 09:39:16AM +0100, Sven Auhagen wrote:
> > > > > On Mon, Mar 18, 2024 at 10:39:15AM +0100, Pablo Neira Ayuso wrote:
> > > > [...]
> > > > > > diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> > > > > > index a0571339239c..481fe3d96bbc 100644
> > > > > > --- a/net/netfilter/nf_flow_table_core.c
> > > > > > +++ b/net/netfilter/nf_flow_table_core.c
> > > > > > @@ -165,10 +165,22 @@ void flow_offload_route_init(struct flow_offload *flow,
> > > > > >  }
> > > > > >  EXPORT_SYMBOL_GPL(flow_offload_route_init);
> > > > > >  
> > > > > > -static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
> > > > > > +static s32 flow_offload_fixup_tcp(struct net *net, struct nf_conn *ct,
> > > > > > +				  enum tcp_conntrack tcp_state)
> > > > > >  {
> > > > > > -	tcp->seen[0].td_maxwin = 0;
> > > > > > -	tcp->seen[1].td_maxwin = 0;
> > > > > > +	struct nf_tcp_net *tn = nf_tcp_pernet(net);
> > > > > > +
> > > > > > +	ct->proto.tcp.state = tcp_state;
> > > > > > +	ct->proto.tcp.seen[0].td_maxwin = 0;
> > > > > > +	ct->proto.tcp.seen[1].td_maxwin = 0;
> > > > > > +
> > > > > > +	/* Similar to mid-connection pickup with loose=1.
> > > > > > +	 * Avoid large ESTABLISHED timeout.
> > > > > > +	 */
> > > > > > +	if (tcp_state == TCP_CONNTRACK_ESTABLISHED)
> > > > > > +		return tn->timeouts[TCP_CONNTRACK_UNACK];
> > > > > 
> > > > > Hi Pablo,
> > > > > 
> > > > > I tested the patch but the part that sets the timout to UNACK is not
> > > > > very practical.
> > > > > For example my long running SSH connections get killed off by the firewall
> > > > > regularly now while beeing ESTABLISHED:
> > > > > 
> > > > > [NEW] tcp      6 120 SYN_SENT src=192.168.6.55 dst=192.168.10.22 sport=55582 dport=22 [UNREPLIED] src=192.168.10.22 dst=192.168.6.55 sport=22 dport=55582 mark=16777216
> > > > > [UPDATE] tcp      6 60 SYN_RECV src=192.168.6.55 dst=192.168.10.22 sport=55582 dport=22 src=192.168.10.22 dst=192.168.6.55 sport=22 dport=55582 mark=16777216
> > > > > [UPDATE] tcp      6 86400 ESTABLISHED src=192.168.6.55 dst=192.168.10.22 sport=55582 dport=22 src=192.168.10.22 dst=192.168.6.55 sport=22 dport=55582 [OFFLOAD] mark=16777216
> > > > > 
> > > > > [DESTROY] tcp      6 ESTABLISHED src=192.168.6.55 dst=192.168.10.22 sport=54941 dport=22 packets=133 bytes=13033 src=192.168.10.22 dst=192.168.6.55 sport=22 dport=54941 packets=95 bytes=15004 [ASSURED] mark=16777216 delta-time=1036
> > > > > 
> > > > > I would remove the if case here.
> > > > 
> > > > OK, I remove it and post a v2. Thanks!
> > > 
> > > Thanks and also the hardcoded TCP_CONNTRACK_ESTABLISHED in flow_offload_fixup_ct
> > > should be reverted to the real tcp state ct->proto.tcp.state.
> > 
> > ct->proto.tcp.state contains the state that was observed before
> > handling over this flow to the flowtable, in most cases, this should
> > be TCP_CONNTRACK_ESTABLISHED.
> > 
> > > This way we always set the current TCP timeout.
> > 
> > I can keep it to ct->proto.tcp.state but I wonder if it is better to
> > use a well known state such as TCP_CONNTRACK_ESTABLISHED to pick up from.
> 
> In case of a race condition or if something is off like my TCP_FIN
> that is beeing offloaded again setting to to ESTABLISHED hard coded
> will make the e.g. FIN or CLOSE a very long state.
> It is not guaranteed that we are still in ESTABLISHED when this code
> runs. Also for example we could have seen both FIN already before the
> flowtable gc runs.

OK, I just posted a v2, leave things as is. I agree it is better to
only address the issue you are observing at this time, it is possible
to revisit later.

Thanks!
