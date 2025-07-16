Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49EEF2BFC9B
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Jul 2025 10:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752661564; cv=none; b=aNY4qsVK2Bz8ByNtL+221Lj620+DAL650O3S460RpYdG3nblml/ERj7DA5FlXC7aqTmk8wl6IrVqNaiD42gKge6CCwZHSUD1XTIb7hL0R0IzRKKXYH0mgBO3Hzg0qDyu8n4Fh+d3x1nL0a1JyQPkxdMZ4fk7IC4oTHoy/BKuXvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752661564; c=relaxed/simple;
	bh=B6ZmztsMQ8xCRSww23kAc6F7/9PSIxk1aOU1NJzdvEI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EoLuLnLrpD30Ibku8j1YN1K0Oz98Wg/oU+kkaOkP+yoGe+81nZnVWGzIkJzOonsFZb4AaNVbVrnAL6pPIgfZ9a8rAiR474HbiprHXy+kMYWjbZ/D0ESy/pWncIxNUJNqt03MKg3+OGYf0Aejzynl62rFcGilW8sxm2ibmYBlQww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=qF/El+6w; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="qF/El+6w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=85cz5TEgUPUIdX2E3gbRNWQdt5bgmxAbqCCDPNmjYbI=; b=qF/El+6wdyufLKRj/KoDYe1ym5
	PiCakE1SJBTH8WiZ6XY70Tmi5C2TgSfda0WoG7f0NoNvDgi9RGJjtqQ+uKUqBCs87gnJr0AzazY07
	TyrkvYixLDj3WishH0YHTsdhs8lzm/bgQaiAGcKR22t9dzSdNYiKmpDTIjm4CHWK5hq/LxXC/giEd
	dkat1n43JNnlfAg4XEE6kH6rEs/33drRYVba1n7VVHWDXH0jPb3cG8RDypAzMIdGCqv61n2pFJDmM
	f3ghiyVXfnC/hjqMWOBjkvFV3BA1OMSlG9PvKvSPrig7O3x4hPRjzXm87t8Tpl9F5ZEIXkNaEPhi1
	RzPWk/aQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ubzKq-000000001fZ-1g3W;
	Wed, 16 Jul 2025 12:26:00 +0200
Date: Wed, 16 Jul 2025 12:26:00 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2 1/3] mnl: Support simple wildcards in netdev hooks
Message-ID: <aHd-OJrEXohAOjOo@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250715151538.14882-1-phil@nwl.cc>
 <20250715151538.14882-2-phil@nwl.cc>
 <aHd1HbLSzO3KHI64@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHd1HbLSzO3KHI64@strlen.de>

On Wed, Jul 16, 2025 at 11:47:09AM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > +		len = strlen(dev_array[0].ifname) + 1;
> > +		if (dev_array[0].ifname[len - 2] == '*')
> > +			len -= 2;
> 
> Not obvious to me, is there a guarantee that 'len' is 2?
> And, what if len yields 0 here?

Oh, right. Same goes for the introduced libnftnl helpers.

> > +			if (dev_array[i].ifname[len - 2] == '*')
> > +				len -= 2;
> > +			mnl_attr_put(nlh, NFTA_DEVICE_NAME, len, dev_array[i].ifname);
> >  			mnl_attr_nest_end(nlh, nest_dev);
> >  		}
> >  	}
> > @@ -2084,14 +2090,17 @@ static void mnl_nft_ft_devs_build(struct nlmsghdr *nlh, struct cmd *cmd)
> >  {
> >  	const struct expr *dev_expr = cmd->flowtable->dev_expr;
> >  	const struct nft_dev *dev_array;
> > +	int i, len, num_devs = 0;
> >  	struct nlattr *nest_dev;
> > -	int i, num_devs= 0;
> >  
> >  	dev_array = nft_dev_array(dev_expr, &num_devs);
> >  	nest_dev = mnl_attr_nest_start(nlh, NFTA_FLOWTABLE_HOOK_DEVS);
> >  	for (i = 0; i < num_devs; i++) {
> >  		cmd_add_loc(cmd, nlh, dev_array[i].location);
> > -		mnl_attr_put_strz(nlh, NFTA_DEVICE_NAME, dev_array[i].ifname);
> > +		len = strlen(dev_array[i].ifname) + 1;
> > +		if (dev_array[i].ifname[len - 2] == '*')
> > +			len -= 2;
> > +		mnl_attr_put(nlh, NFTA_DEVICE_NAME, len, dev_array[i].ifname);
> 
> This (test, subtract, put) is a repeating pattern, perhaps this warrants a helper?

It's even there already, (still) named 'mnl_attr_put_ifname' in my
libnftnl patch. I'll export it (with correct prefix) for use in
nftables.

Thanks, Phil
