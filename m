Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 931692D057
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2024 10:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710930972; cv=none; b=abE9g3qh/0d0H1hCpfWxFos9LdSDeLWQfK76RGxiDOPx0UxacPAKIOpA+U5dxKx1vejcoY3r/b7pz1i4DTaiwaBvxBlRTNrF5qglgmXPyzyZzAFYg/VzKa1GN/Vpkl/69P46mXrrX5zVTNePGbl3NCZhnfGbj6x+rt/fNZOrWr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710930972; c=relaxed/simple;
	bh=QxU7dPIe7Dq4YMQ4MVCzrnoxUkocW4RkTulvlkjbLWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hNQ58xa8PhAHq9x1eP6mkMlr7M3aWtPBH+P4GMraYFgVEcHQ4nBSnOjvLv49essFdvjC8M2BJy3iyaLXNZQE2QxIY3A3OGflXimTCrmAl0kLnJeWnos0hJQ0wKZ3lo5plGQ3NSGWJvnJYjXeWhQHStKjKuZmErB1V8MVqjetSPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Wed, 20 Mar 2024 11:36:05 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Sven Auhagen <sven.auhagen@voleatech.de>
Cc: netfilter-devel@vger.kernel.org, cratiu@nvidia.com, ozsh@nvidia.com,
	vladbu@nvidia.com, gal@nvidia.com, fw@strlen.de
Subject: Re: [PATCH nf] netfilter: flowtable: infer TCP state and timeout
 before flow teardown
Message-ID: <Zfq8FedQ05ZuY9o6@calendula>
References: <20240318093915.10358-1-pablo@netfilter.org>
 <zxdruu67c2xs6zrhagjilitxu5ysik5x7zvk3kthzcclype22c@nevv7c7adz7z>
 <ZfqiHPpUfFwHI5-h@calendula>
 <lajzqkqbqptfa6m6ntyseutpmbnrrc4yb26x6lwjaxm3aldzvc@u33db2j37rtb>
 <ZfqnTJKyW1VSIOgY@calendula>
 <lderg42fd4jbcwsztkidn3lhnjhufj5yv3zsdu4dpsenzikkta@cya5vq3prnzf>
 <ZfqsAoSNA4DRsVga@calendula>
 <nvslglowbvxntlpftefkumbwn2gz72evwnfvv4q2qencte7wyn@3jejk23urzeg>
 <Zfqxq3HK_nsGRLhx@calendula>
 <fcas4qeo45hbbjmu6h2ipryoi4cmhmhtzhudabqdj6egzxidg6@o5kaoqak26io>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fcas4qeo45hbbjmu6h2ipryoi4cmhmhtzhudabqdj6egzxidg6@o5kaoqak26io>

On Wed, Mar 20, 2024 at 11:13:23AM +0100, Sven Auhagen wrote:
> On Wed, Mar 20, 2024 at 10:51:39AM +0100, Pablo Neira Ayuso wrote:
> > On Wed, Mar 20, 2024 at 10:31:00AM +0100, Sven Auhagen wrote:
> > > On Wed, Mar 20, 2024 at 10:27:30AM +0100, Pablo Neira Ayuso wrote:
> > > > On Wed, Mar 20, 2024 at 10:20:29AM +0100, Sven Auhagen wrote:
[...]
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
> 
> Ah you are correct.
> Never the less I can tell you that I still see this problem with the patch attached:
>
>  [UPDATE] tcp      6 120 FIN_WAIT src=192.168.7.105 dst=17.253.57.219 sport=49574 dport=443 src=17.253.57.219 dst=87.138.198.79 sport=443 dport=5078 [OFFLOAD] mark=25165825
>   [UPDATE] tcp      6 30 LAST_ACK src=192.168.7.105 dst=17.253.57.219 sport=49574 dport=443 src=17.253.57.219 dst=87.138.198.79 sport=443 dport=5078 [ASSURED] mark=25165825
>    [UPDATE] tcp      6 10 CLOSE src=192.168.7.105 dst=17.253.57.219 sport=49574 dport=443 src=17.253.57.219 dst=87.138.198.79 sport=443 dport=5078 [ASSURED] mark=25165825
>    [DESTROY] tcp      6 CLOSE src=192.168.7.105 dst=17.253.57.219 sport=49574 dport=443 packets=15 bytes=2688 src=17.253.57.219 dst=87.138.198.79 sport=443 dport=5078 packets=18 bytes=7172 [ASSURED] mark=25165825 delta-time=126

Just to make sure, are you testing with these two patches?

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20240320092638.798076-1-pablo@netfilter.org/
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20240320092638.798076-2-pablo@netfilter.org/
