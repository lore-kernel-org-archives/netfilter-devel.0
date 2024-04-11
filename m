Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF98F140E3C
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Apr 2024 11:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712835653; cv=none; b=EHAhwbPat7j4/MldF+ZUOJbsW22NFCnYKQ2GCVvay7KqDM933iEPtRxFgCypxniHlOOGJItHcpjhqjY6zl3ZYe7BoW0l2tHsl3Zg/jbOkYC/DOiQxnMu5s389btLjJAGaTY5SLWLEmUZZiUGixUcpVgtWfLU1vnp/BMfZX4f5qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712835653; c=relaxed/simple;
	bh=2bFL/c8pcROHGo5IU5rh6sw6vhkOTTNELw4vfUmc55o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kDOprmNSKjDJG7VypDTzfzXuaAD/Bg6nhw3dKAQtUxBDn0x/bRYTw258VF2sZyTrrpLVO7obgxXjuxfMyB5bv5OCtvRicRdNoB6VvDFb5FGjsmgZeJ4n/oTVwcKfK2rprbuLy6foxHItnOOgvdPJGEUZ+F+s42slK3FH/uVoOUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Thu, 11 Apr 2024 13:40:48 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Sven Auhagen <sven.auhagen@voleatech.de>,
	netfilter-devel@vger.kernel.org, cratiu@nvidia.com, ozsh@nvidia.com,
	vladbu@nvidia.com, gal@nvidia.com
Subject: Re: [PATCH nf] netfilter: flowtable: infer TCP state and timeout
 before flow teardown
Message-ID: <ZhfMQM3KXi9dCBUd@calendula>
References: <Zfqxq3HK_nsGRLhx@calendula>
 <xvnywodpmc3eui6k5kt6fnooq35533jsavkeha7af6c2fntxwm@u3bzj57ntong>
 <Zfq-1gES4VJg2zHe@calendula>
 <o7kxkadlzt2ux5bbdcsgxlfxnfedzxv4jlfd3xnhri6qpr5w3n@2vmkj5o3yrek>
 <ZfrYpvJFrrajPbHM@calendula>
 <x3qvcfxgdmurfnydhrs7ao6fmxxubmhxs2mjk24yn5zjfbo3h5@esbr3eff7bir>
 <ZhUibxdb005sYZNq@calendula>
 <uhn7bt3jdrvmczhlw3dsrinb2opr2qksnbip7asekilgczm35v@hyvzkxrgdhgn>
 <ZhetEIvz_vCB-A5D@calendula>
 <20240411110504.GE18399@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240411110504.GE18399@breakpoint.cc>

On Thu, Apr 11, 2024 at 01:05:04PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > I can also see IP_CT_TCP_FLAG_CLOSE_INIT is not set on when ct->state
> > is adjusted to _FIN_WAIT state in the fixup routine.
> 
> Unrelated to this patch, but I think that there is an increasing and
> disturbing amount of code that attempts to 'fix' the ct state.

I originally started this infrastructure without the fixup, and there
was a bit of fuzz about it because people complained that TCP
connection somewhat becomes stateless and would get stuck too after
fin packet is seen.

There is also connlimit, which would be distorted after the TCP flow
becomes stateless when handing it over to the flowtable.

Another reason is that hardware offload folks need this, otherwise
hardware entry remains too long in the hardware flowtable.

> I don't think its right and I intend to remove all of these "fixups"
> of the conntrack state from flowtable infra.
> 
> I see no reason whatsoever why we need to do this, fin can be passed up
> to conntrack and conntrack can and should handle this without any extra
> mucking with the nf_conn state fields from flowtable infra.

You mean, just let the fin packet go without tearing down the flow
entry?

> The only cases where I see why we need to take action from
> flowtable layer are:
> 
> 1. timeout extensions of nf_conn from gc worker to prevent eviction
> 2. removal of the flowtable entry on RST reception. Don't see why that
>    needs state fixup of nf_conn.

Remove it right away then is what you propose?

> 3. removal of the flowtable entry on hard failure of
>    output routines, e.g. because route is stale.
>    Don't see why that needs any nf_conn changes either.

if dst is stale, packet needs to go back to classic path to get a
fresh route.

> My impression is that all these conditionals paper over some other
> bugs, for example gc_worker extending timeout is racing with the
> datapath, this needs to be fixed first.

That sounds good. But I am afraid some folks will not be happy if TCP
flow becomes stateless again.

> I plan to work on this after the selftest fixups.

Thanks.
