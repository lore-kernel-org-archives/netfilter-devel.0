Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CA84A21
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2024 14:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726237091; cv=none; b=ko0FrZVWlXm+oqKQ5AJKEzPWouFhAbIlzdTzo7+fqFSBvMXiLdyCQvQSOxb7VpGEnijONL3ykUGt8rDO4Qy7X6gDaZz1DLZVJrcUHFK7bQgcfR4GuFXgfbsxJtzV4MXbe808Al7ajo+r/UQ1FDndqMNd2r1/jW2Cxwdl6Dt2YEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726237091; c=relaxed/simple;
	bh=/MZFpi3+UpXOn6l6s5lgtRB+RGm1/AVfc0pcPdC0iU0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UGdXMIjivTINeiFTUA2tnOUTlcF6pd+tJF6qKsMInQmxSFl0pjtKiqY+8kNFfyXozV0OGuoPiWBpZ2A/9cO0HBDAzoDCJt+2db84IH/gYCnQIvl7SH/OpDDIMOK9/JaD+zOAsewODPNemauxTpNQfj/M3TE47V1nMvg25gvxTc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sp77c-0005vq-1l; Fri, 13 Sep 2024 16:18:04 +0200
Date: Fri, 13 Sep 2024 16:18:04 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Phil Sutter <phil@nwl.cc>, Antonio Ojea <antonio.ojea.garcia@gmail.com>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_tproxy: make it terminal
Message-ID: <20240913141804.GA22091@breakpoint.cc>
References: <20240913102023.3948-1-pablo@netfilter.org>
 <20240913102347.GA15700@breakpoint.cc>
 <ZuQT60TznuVOHtZg@calendula>
 <20240913104101.GA16472@breakpoint.cc>
 <ZuQYPr3ugqG-Yz82@calendula>
 <CABhP=tZKgrWo2oH3h=cA8KreLZtYr1TZw7EfqgGwWitWZAPqyw@mail.gmail.com>
 <ZuQg6d9zGDZKbWBO@calendula>
 <ZuQpbnjAoutXEFUj@orbyte.nwl.cc>
 <ZuQx3_x6JJgzA0gS@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZuQx3_x6JJgzA0gS@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Hmm. Looking at nft_nat.c, 'accept' seems consistent with what nat
> > statements do implicitly.
> 
> Yes, and xt_TPROXY does NF_ACCEPT.
> 
> On the other hand, I can see it does NF_DROP it socket is not
> transparent, it does NFT_BREAK instead, so policy keeps evaluating the
> packet.

Yes, this is more flexible since you can log+drop for instance in next
rule(s) to alert that proxy isn't running for example.

> > > is this sufficient in your opinion? If so, I made this quick update
> > > for man nft(8).
> > 
> > Acked-by: Phil Sutter <phil@nwl.cc>
> >
> > In addition to that, I will update tproxy_tg_xlate() in iptables.git to
> > emit a verdict, too.
> 
> Thanks, this is very convenient.

Agreed, it should append accept keyword in the translator.
