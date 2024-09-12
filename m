Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF87F20E3
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 13:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726148304; cv=none; b=joEqkMxv9I6bulyDX9+27cjNEOiqWiHjVqGP3FzzPnEEMLN3ybqOPUoxcR/cci2WbNw8IDhdYPWNv9YT4LKSCRmRPwFED/8ZRAfl3hBDGQp+3iaaddYUs5F+18CUGEHAx07YmBQvUsvlsBbj9OW5JZJH1cRlw99mL71MciBJpKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726148304; c=relaxed/simple;
	bh=4o1jQAFKEKspRr68G4nxQbHRil5mbU1ZrFzJB1e522Y=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r8UG+gOOzDgjMtyRI0g6CvHlE3O354Yv5ANgWQZN9/5cyRpu6nNIPFwJptC9KNNJiUsncpA3l489+fRpini3m0OWYJ12zd+6pBFtM5kUZWl5cfvfQuqKExINykJ9ygXT+BwrluIHUJIhcq4NVqMMiZWm1WrRqBylgTkVeoGYTrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sok1b-0001Ze-UZ; Thu, 12 Sep 2024 15:38:19 +0200
Date: Thu, 12 Sep 2024 15:38:19 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v3 03/16] netfilter: nf_tables: Store
 user-defined hook ifname
Message-ID: <20240912133819.GC2892@breakpoint.cc>
References: <20240912122148.12159-1-phil@nwl.cc>
 <20240912122148.12159-4-phil@nwl.cc>
 <20240912125641.GA2892@breakpoint.cc>
 <ZuLsFhYzWH5ql-k2@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZuLsFhYzWH5ql-k2@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> > I'd suggest to move the if (nla_type(tmp) != NFTA_DEVICE_NAME)
> > test from nf_tables_parse_netdev_hooks() into nft_netdev_hook_alloc
> > so nft_chain_parse_netdev() also has this test.
> 
> I fear this won't work, because nft_chain_parse_netdev() may call
> nft_netdev_hook_alloc() directly, passing tb[NFTA_HOOK_DEV]. For
> NFTA_HOOK_DEVS though, it calls nf_tables_parse_netdev_hooks() and thus
> the nested attribute type check in there applies.

Ouch, you are right, it can be called with either attribute :-(

> > Then,
> > > -     nla_strscpy(ifname, attr, IFNAMSIZ);
> > 
> > Into:
> > 
> > 	err = nla_strscpy(ifname, attr, IFNAMSIZ)
> > 	if (err < 0)
> > 		goto err_hook_dev;
> > 
> > so we validate that
> > a) attr is NFTA_DEVICE_NAME
> 
> As said above, it may be NFTA_HOOK_DEV as well.

Yes, my bad.

> > b) length doesn't exceed IFNAMSIZ.
> 
> ACK. I think a) is already being asserted in spots where NFTA_HOOK_DEV
> is not expected (which in turn has a policy).

Yes, I did not see that this is using different attributes.

> > ATM this check is implicit because nla_strscpy() always
> > null-terminates and the next line will check that the
> > device with this name actually exists.
> > 
> > But that check is removed later.
> > This patch can then set
> > 
> >  hook->ifnamelen = err
> > 
> > without risk that nla_len() returns 0xfff0 or some other bogus
> > value.
> 
> Ah, nice!
> 
> From my perspective, all it takes is the nla_strscpy() return value
> check in this patch to cover everything. Right?

Yes, right.  So no extra patch is needd.
