Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A4C1DA0FB
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2024 12:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726231017; cv=none; b=MlE8ZZ4xsMm8D9j6Ilu8VmsP10qNQ9UMJ2TsWShFNNFggQxN1ORDdwpcHn5StrnttnNzOdVPGSs122LUWdjhRBVO9MZZ/rNiSk1yGc36wg+9S08XT2Vk/+/TMKj9Jl/XBQRz/kFLvyv81e3wzF+IeqPfDKA9N8euVDBmvLB4DkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726231017; c=relaxed/simple;
	bh=gDOlQ8VXG/P3c5u7ol2krG/r8PCPTk223jW4lvURYU0=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QmeaBNGSq9GzVIM2x4EC4Fiz9a8rbLa0sGfWkMA3gtXl+SC5u0wvaiWXWCDpB3l3qVGfw8Vt/lz+0qdcH3sADavHTJYVapoTccl3/RUTDtCj1a7IsYc8mIQxg8dvmFJoCaCxDSD0HRyLnmKcR0/688ezYI8q6Afh9PZGyjFwBZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=41952 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sp5Xc-00AOOC-MY; Fri, 13 Sep 2024 14:36:50 +0200
Date: Fri, 13 Sep 2024 14:36:47 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Antonio Ojea <antonio.ojea.garcia@gmail.com>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_tproxy: make it terminal
Message-ID: <ZuQx3_x6JJgzA0gS@calendula>
References: <20240913102023.3948-1-pablo@netfilter.org>
 <20240913102347.GA15700@breakpoint.cc>
 <ZuQT60TznuVOHtZg@calendula>
 <20240913104101.GA16472@breakpoint.cc>
 <ZuQYPr3ugqG-Yz82@calendula>
 <CABhP=tZKgrWo2oH3h=cA8KreLZtYr1TZw7EfqgGwWitWZAPqyw@mail.gmail.com>
 <ZuQg6d9zGDZKbWBO@calendula>
 <ZuQpbnjAoutXEFUj@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZuQpbnjAoutXEFUj@orbyte.nwl.cc>
X-Spam-Score: -1.9 (-)

On Fri, Sep 13, 2024 at 02:00:46PM +0200, Phil Sutter wrote:
> Hi,
> 
> On Fri, Sep 13, 2024 at 01:24:25PM +0200, Pablo Neira Ayuso wrote:
> > On Fri, Sep 13, 2024 at 01:02:02PM +0200, Antonio Ojea wrote:
> > > On Fri, 13 Sept 2024 at 12:47, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > >
> > > > On Fri, Sep 13, 2024 at 12:41:01PM +0200, Florian Westphal wrote:
> > > > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > > > On Fri, Sep 13, 2024 at 12:23:47PM +0200, Florian Westphal wrote:
> > > > > > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > > > > > tproxy action must be terminal since the intent of the user to steal the
> > > > > > > > traffic and redirect to the port.
> > > > > > > > Align this behaviour to iptables to make it easier to migrate by issuing
> > > > > > > > NF_ACCEPT for packets that are redirect to userspace process socket.
> > > > > > > > Otherwise, NF_DROP packet if socket transparent flag is not set on.
> > > > > > >
> > > > > > > The nonterminal behaviour is intentional. This change will likely
> > > > > > > break existing setups.
> > > > > > >
> > > > > > > nft add rule filter divert tcp dport 80 tproxy to :50080 meta mark set 1 accept
> > > > > > >
> > > > > > > This is a documented example.
> > > > > >
> > > > > > Ouch. Example could have been:
> > > > > >
> > > > > >   nft add rule filter divert tcp dport 80 socket transparent meta set 1 tproxy to :50080
> > > > >
> > > > > Yes, but its not the same.
> > > > >
> > > > > With the statements switched, all tcp dport 80 have the mark set.
> > > > > With original example, the mark is set only if tproxy found a
> > > > > transparent sk.
> > > >
> > > > Indeed, thanks for correcting me.
> > > >
> > > > I'm remembering now why this was done to provide to address the ugly
> > > > mark hack that xt_TPROXY provides.
> > > >
> > > > While this is making harder to migrate, making it non-terminal is
> > > > allowing to make more handling such as ct/meta marking after it.
> > > >
> > > > I think we just have to document this in man nft(8).
> > > 
> > > I think that at this point in time the current state can not be broken
> > > based on this discussion, I just left the comment in the bugzilla
> > > about the possibility but it is clear now that people that have
> > > already started using this feature with nftables must not experience a
> > > disruption.
> > > On the other side, users that need to migrate will have to adapt more
> > > things so I don't think it should be a big deal.
> > > What I really think is that users should have a way to terminate
> > > processing to avoid other rules to interfere with the tproxy
> > > functionality
> > 
> > It is possible to add an explicit 'accept' verdict as the example
> > above displays:
> > 
> >         tcp dport 80 tproxy to :50080 meta mark set 1 accept
> >                                                       ^^^^^^
> 
> I wonder if this is sufficient: The packet will still appear in
> following chains, etc. So shouldn't one use 'drop' verdict instead or
> does that prevent the proxying somehow?
>
> Hmm. Looking at nft_nat.c, 'accept' seems consistent with what nat
> statements do implicitly.

Yes, and xt_TPROXY does NF_ACCEPT.

On the other hand, I can see it does NF_DROP it socket is not
transparent, it does NFT_BREAK instead, so policy keeps evaluating the
packet.

> > is this sufficient in your opinion? If so, I made this quick update
> > for man nft(8).
> 
> Acked-by: Phil Sutter <phil@nwl.cc>
>
> In addition to that, I will update tproxy_tg_xlate() in iptables.git to
> emit a verdict, too.

Thanks, this is very convenient.

> Also I should update the respective wiki article[1] once more with added
> translation testsuite links - at least the one for TPROXY is missing.

Great, thanks.

I still have to update wiki to extend set element timeout with the
recent information I provided in netfilter@vger.kernel.org ML too.
