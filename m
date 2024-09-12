Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40E1126C0E
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 16:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726158322; cv=none; b=cEPkRwO1ijSU0m/zzMslfv+i3609KUEVCEH1BSNCVTgtvtI/pWCtS5Ui07dKROtj01QxpD3PPagvG3cEaNSEAbLkRzvBNC1f/j9Q52tUIlKDtI/wccx49cvDJSfNMi67pNb6bgdDHDz8mMzLYuwoWxeY1eRNk4VS1ZD/4Tk/7M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726158322; c=relaxed/simple;
	bh=FcHX+2lL5FANAENQyYq4hurIx32QC2yjVHSn6XCMMuc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sv2JPlNhSeAhMImJAo6jM9K/WNVHZZevO3n04Hv3M3SZRyjin7WCGyXhrgAJRsYlejnyNdEcGqIddMb3ST75fepka/Av0stRHYCy0X2547iWbZXtVwbviS/dpE+WBFKeZxYmET291aaficvX+nZTgeBqO9hEi8cbWzAQOJynQkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=jedL3SeQ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="jedL3SeQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Pb8gamFnt0sCcQQYD7Tz/IdgL9rF6V3r5axqGdxAmBQ=; b=jedL3SeQQnn9PhRnNwQx8J53jG
	+cVBnqNiGTW+U/jnEO+9vXCLjPJ7mcaKloahRjDH7Y/kkfG5RkmSOTAgU3flTcwxYV1iqPeW5f8GF
	OCHH5hzDLJT3cIG9JJuNBMotOVZDa37F9hcC9b/bHkJtZwSqZtU1Dvegqqe3QgDwXldws5+I4EYcg
	f5D5jbtrPeaFDnUnk8WkwcUfb3kU8Hy44YfURnTYKZ99L+oEIE0Jmrsnpfkh/kSVcbnugxC811yVu
	6mgYjcgt+YBw7EUIo9qo90bKP1G95++lqrVZkX2Z2J4m0AWIV4V69FtbO990ZdJbifWYI7lW92We+
	mUUnz45Q==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1somdB-000000007vY-3HoG;
	Thu, 12 Sep 2024 18:25:17 +0200
Date: Thu, 12 Sep 2024 18:25:17 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v3 11/16] netfilter: nf_tables: chain: Respect
 NETDEV_REGISTER events
Message-ID: <ZuMV7bQXHC3J3zU8@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
References: <20240912122148.12159-1-phil@nwl.cc>
 <20240912122148.12159-12-phil@nwl.cc>
 <20240912144041.GE2892@breakpoint.cc>
 <ZuMDTL1P-NZ_Ezyk@orbyte.nwl.cc>
 <20240912151203.GA32404@breakpoint.cc>
 <ZuMLnfwhTdyqp90C@orbyte.nwl.cc>
 <20240912160639.GA9554@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240912160639.GA9554@breakpoint.cc>

On Thu, Sep 12, 2024 at 06:06:39PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > So it is possible that ops are still used somewhere after
> > nf_unregister_net_hook() returns? I don't quite get that code, with all
> > the RCU-bells and ONCE-whistles.
> 
> Not ops, but other core could still run the hookfn that
> is being unregistered, i.e.:
> 
> cpu 0
>  unreg hookfn                      nf_hook_slow
>                                       runs hookfn
> if nf_hook() fetched the hook blob (struct nf_hook_entries *)
> before unreg path called its rcu_assign_pointer with the updated
> incarnation.
> 
> That said, this might be a special case as entire nf_hook_entries blob
> is tied to device that is going down, so packet flow might have stopped
> already.
> 
> From a brief glance the device is already disabled at NETDEV_UNREGISTER
> time, no packets are flowing anymore.

This seems like a relief, but doesn't apply to NETDEV_CHANGENAME case.
At least I can't handle it like UNREG && REG - or vice versa, have to
consider the above for UNREG.

> > > Device is the same, so maybe its enough to update the name
> > > in nft_hooks structure?
> > 
> > You're putting the cart before the horse here: The user sets
> > hook->ifname and we bind to whatever device matches that.
> > 
> > Now with a device being renamed, there are two options:
> > 
> > A) Unbind if the name doesn't match hook->ifname anymore and search for
> >    another, matching hook. This is what I had (tried to) implement.
> > 
> > B) Just leave the interface in place as long as it exists. This is how
> >    the old code behaves.
> > 
> > For users, I find (A) more intuitive.
> 
> Yes, that makes sense to me.  But can't you defer the unbind until after
> you've figured out if there is a matching hook or not?
> 
> I.e., if no matching new hook, just unreg, else register new/unregister
> old.

I can't bind a device to multiple flowtables of the same family, so I
can't bind first, then unbind.

> Otherwise, we might unreg, then fail to re-register?

Assuming I can't bind to the new flowtable while still bound to the old
one, I can only try to roll back. Which means trying to bind to the old
flowtable again in error case which might still fail. I could return
NOTIFY_BAD then, but it won't help - the transaction is broken.

Cheers, Phil
