Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E483017C99B
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Sep 2024 21:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726608452; cv=none; b=qeqZ/aSc7Pf/o8HknfkhiQMjAI7EZZIWS/6frNzx3M1nP6YYjCX3DeTCMgqF4bwpOtbfpiUTnUWj8vN+rqFOpyHNFFpDyKnPRMhQjUQirpGaGwkb78kNbBhAbcOdjyQWA3jJvQXReQsXdILdd5KFELs4tVsZPumgZGk5s8Zd204=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726608452; c=relaxed/simple;
	bh=y1Z0jELrJRvqA4LJ3skhcaimsN//DTEpOD0tQNx9k6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o7iASueYZAC0tJKhzuw+bMkGBWYNUcdXeXUHE0d0kZ/LwLUORxXzm6wHh+mMmbzzFYD7mHxU/UrWAQvLgp32iHK/BQaW8EdkmblQ8kobitoBYLSACy3mtLPnzNE5CQYWoZwPgkCA+eXP8N1GMHuyekC4jo04z7Q++3cbZjOL2BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=TYh0/20w; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="TYh0/20w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=iUDtw4Vzno3l9GtKJmFrL4V6L1MSXOPgWjkkIL2sN0Q=; b=TYh0/20w8TsZYnEoQBnyOyNo5Y
	kxFyDf0ARTi1X/h9orHmGhe1afYAFlEpDuXQdAFCQbK3gX5l10VGp3RnfcR0RKgzY2BU26xV+jK2O
	PmEkjnAOQntW+UgSUG3SjxSPQoFtPI8OtykDI+hgtuLytHpwchoVKL5S51kDKYYUTF7RlNSHLsUiB
	jWkjpDwwrna2k1xn+cMr79d+H7bOrGo6dNbemg4SkhXGOWYPy4g2SS0TvlCfIpIzHnqsJy/QN1i+I
	+B+ctVVSn/aD3EjSH0Oja6vwF327f2u85r1L6uMU7+9+PTgnPrgE7uoQsjZ1Yq0NY6Cg8BtuypCRb
	LuQhotTg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sqfjE-0000000010l-3X8F;
	Tue, 17 Sep 2024 23:27:20 +0200
Date: Tue, 17 Sep 2024 23:27:20 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Jan Engelhardt <jengelh@inai.de>
Subject: Re: [iptables RFC PATCH 8/8] nft: Support compat extensions in rule
 userdata
Message-ID: <Zun0OGdvhX4nLD7i@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Jan Engelhardt <jengelh@inai.de>
References: <20240731222703.22741-1-phil@nwl.cc>
 <20240731222703.22741-9-phil@nwl.cc>
 <Zudb80USN6GGG05T@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zudb80USN6GGG05T@calendula>

Hi Pablo,

On Mon, Sep 16, 2024 at 12:13:07AM +0200, Pablo Neira Ayuso wrote:
> I have no better idea to cope with this forward compatibility
> requirements.

From my point of view, it's the best approach among the bad ones (i.e.,
those not providing compatibility for old binaries out of the box).

> On Thu, Aug 01, 2024 at 12:27:03AM +0200, Phil Sutter wrote:
> > Add a mechanism providing forward compatibility for the current and
> > future versions of iptables-nft (and all other nft-variants) by
> > annotating nftnl rules with the extensions they were created for.
> >
> > Upon nftnl rule parsing failure, warn about the situation and perform a
> > second attempt loading the respective compat extensions instead of the
> > native expressions which replace them.
> 
> OK, so this is last resort to interpret the rule.

It is. I had your concerns regarding crafted compat payload in rules in
mind with this. The downside is that we may make subtle changes to VM
code which the old binary won't detect and ignore. Maybe I could feature
it via flag or env var to prefer the userdata extensions. WDYT?

> > The foundational assumption is that libxtables extensions are stable
> > and thus the VM code created on their behalf does not need to be.
> 
> OK, this requires xtables API becomes frozen forever.

Well, not more than it has been: Take iptables-legacy for instance: An
old version may see a newer extension revision than it has support for,
so will fail just like iptables-nft with native code it can't parse. So
effectively iptables-nft becomes *as compatible as* the same version of
iptables-legacy.
Another perspective to this: Extension development gradually slows down
which we'll leverage while at the same time support increased
development in nftables itself and conversion of extensions to VM code.

> > Since nftnl rule userdata attributes are restricted to 255 bytes, the
> > implementation focusses on low memory consumption. Therefore, extensions
> > which remain in the rule as compat expressions are not also added to
> > userdata. In turn, extensions in userdata are annotated by start and end
> > expression number they are replacing. Also, the actual payload is
> > zipped using zlib.
> 
> Binary layout is better than storing text in the userdata area.
> 
> Is this zlib approach sufficient to cope with ebtables among
> extension? Maybe that one is excluded because it is using the set
> infrastructure since the beginning.

Yes, among is not an issue because ebtables-nft never implemented this
as extension.

> I guess you already checked for worst case to make sure compression
> always allows to make things fit into 255 bytes?

Well, we don't convert too many extensions to nftables anymore since
Florian reverted a bunch as a quick countermeasure against the compat
complaints. Things will certainly get worse, but the question is mostly
how many different extensions will "the largest rule" have. I added some
debug output and in shell testsuite for instance the largest compat_ext
userdata I see is 68 bytes. I was able to craft a rule which uses 159
bytes though:

iptables-nft -A FORWARD \
	-m limit --limit 1000/hour \
	-p udp -m udp --sport 1024:65535 --dport 4:65535 \
	-m mark --mark 0xfeedcafe/0xfeedcafe \
	-j NFLOG --nflog-group 23 \
	         --nflog-prefix "this is a damn long log prefix"

The current implementation calls xtables_error() if nftnl_udata_put()
fails. Maybe a better error path would be to only warn the user and not
add compat_ext to userdata. Guess it depends on whether this should be
enabled by default or only upon request - if user asks for compat_ext,
failing to do so should be fatal.

Cheers, Phil
