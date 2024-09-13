Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8902C80
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2024 12:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726228851; cv=none; b=AV/anWUiFQxiTABFKktAVFzDil9NJz72ZlwDJ2cbz9VXzE9TdHV28PqDkVT8F12hCRXtkBjAwpUHD9IacyOuFbJQx0ZWUaEQ7168DROAVm28RQlcBeiLbljil6rYaXPUTojKPO+BwJ7yBaVDYkTcFj1Lm92CMtyV5OHYx2lSd1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726228851; c=relaxed/simple;
	bh=rb3FEqrxoH6ztWNkDhnKZzvNPDYF5ZxafbpFNUsXelc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KacGxIEWgf7kME+xAtcq65eIUsnCPXbfM03bvrd+VCVHfPCvcBDu6DNvQS4+kztv3W4ox10fm/umYbSypuRigoBUZdjyB7G5KawFjsFF6GJLRtj/J9YXPlayM78i6z46KVq/xDWDVMIC4iu8ATMUJKrhaLCXPMm5HlvPMwo/Mi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=YHaMIJJW; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="YHaMIJJW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nKt/tPlXlyVPZ/lrutQjyND1Isav2R8hmcB/PkiLXDA=; b=YHaMIJJWdCXdeYjusu+uu43Prv
	1uT6/+jwf1ejdfrrZECRav7B7qQRy1zKgfGtED8IbUSFDLUDIm1phLRprzV+iOjszK2rollFubDQw
	dwyJh81znGnB/vWTeEFKoYIA6pmDAXipZjfS3A/c3G/PEQ1P1f3BcYnEHqDNhmTOhPK9r3XANDFnd
	rKDm6qX4PLOASnHaYu0lq0JzLSatdzePUs3oqZcqxbFz8RoVe5CzpLRIg8aBYmbDn1imQ0CQ6wxSK
	GxoXrhtSWg5Za59t0+XmumVurOko+J9zJXD5P/mXCchyPZJoSkUSqmZPZDfxhTWU1N3K4mn3YKp4n
	96/m5R5Q==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sp4yk-000000000ck-3zoQ;
	Fri, 13 Sep 2024 14:00:46 +0200
Date: Fri, 13 Sep 2024 14:00:46 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Antonio Ojea <antonio.ojea.garcia@gmail.com>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_tproxy: make it terminal
Message-ID: <ZuQpbnjAoutXEFUj@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Antonio Ojea <antonio.ojea.garcia@gmail.com>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20240913102023.3948-1-pablo@netfilter.org>
 <20240913102347.GA15700@breakpoint.cc>
 <ZuQT60TznuVOHtZg@calendula>
 <20240913104101.GA16472@breakpoint.cc>
 <ZuQYPr3ugqG-Yz82@calendula>
 <CABhP=tZKgrWo2oH3h=cA8KreLZtYr1TZw7EfqgGwWitWZAPqyw@mail.gmail.com>
 <ZuQg6d9zGDZKbWBO@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZuQg6d9zGDZKbWBO@calendula>

Hi,

On Fri, Sep 13, 2024 at 01:24:25PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Sep 13, 2024 at 01:02:02PM +0200, Antonio Ojea wrote:
> > On Fri, 13 Sept 2024 at 12:47, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >
> > > On Fri, Sep 13, 2024 at 12:41:01PM +0200, Florian Westphal wrote:
> > > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > > On Fri, Sep 13, 2024 at 12:23:47PM +0200, Florian Westphal wrote:
> > > > > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > > > > tproxy action must be terminal since the intent of the user to steal the
> > > > > > > traffic and redirect to the port.
> > > > > > > Align this behaviour to iptables to make it easier to migrate by issuing
> > > > > > > NF_ACCEPT for packets that are redirect to userspace process socket.
> > > > > > > Otherwise, NF_DROP packet if socket transparent flag is not set on.
> > > > > >
> > > > > > The nonterminal behaviour is intentional. This change will likely
> > > > > > break existing setups.
> > > > > >
> > > > > > nft add rule filter divert tcp dport 80 tproxy to :50080 meta mark set 1 accept
> > > > > >
> > > > > > This is a documented example.
> > > > >
> > > > > Ouch. Example could have been:
> > > > >
> > > > >   nft add rule filter divert tcp dport 80 socket transparent meta set 1 tproxy to :50080
> > > >
> > > > Yes, but its not the same.
> > > >
> > > > With the statements switched, all tcp dport 80 have the mark set.
> > > > With original example, the mark is set only if tproxy found a
> > > > transparent sk.
> > >
> > > Indeed, thanks for correcting me.
> > >
> > > I'm remembering now why this was done to provide to address the ugly
> > > mark hack that xt_TPROXY provides.
> > >
> > > While this is making harder to migrate, making it non-terminal is
> > > allowing to make more handling such as ct/meta marking after it.
> > >
> > > I think we just have to document this in man nft(8).
> > 
> > I think that at this point in time the current state can not be broken
> > based on this discussion, I just left the comment in the bugzilla
> > about the possibility but it is clear now that people that have
> > already started using this feature with nftables must not experience a
> > disruption.
> > On the other side, users that need to migrate will have to adapt more
> > things so I don't think it should be a big deal.
> > What I really think is that users should have a way to terminate
> > processing to avoid other rules to interfere with the tproxy
> > functionality
> 
> It is possible to add an explicit 'accept' verdict as the example
> above displays:
> 
>         tcp dport 80 tproxy to :50080 meta mark set 1 accept
>                                                       ^^^^^^

I wonder if this is sufficient: The packet will still appear in
following chains, etc. So shouldn't one use 'drop' verdict instead or
does that prevent the proxying somehow?

Hmm. Looking at nft_nat.c, 'accept' seems consistent with what nat
statements do implicitly.

> is this sufficient in your opinion? If so, I made this quick update
> for man nft(8).

Acked-by: Phil Sutter <phil@nwl.cc>

In addition to that, I will update tproxy_tg_xlate() in iptables.git to
emit a verdict, too.

Also I should update the respective wiki article[1] once more with added
translation testsuite links - at least the one for TPROXY is missing.

Cheers, Phil
