Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9573C1366
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Jul 2024 22:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719873162; cv=none; b=uBNWvO1BsQy9pxuWG8ZNLq5gb/LdgWW9E7inEF0vkNAq2h4RaU+E4y+x6RBGEatbLafo4yB6nyOV61JO7o2EYNNFJ4b7bUIVZXGyOu4sRg8WEiRA9tKROB8NB4iaJy1KvgQ4XwStJmFwevtlrOiAyfas/VPvC3OIdASHNMS4jSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719873162; c=relaxed/simple;
	bh=oZqK8hMgsAtwf/LJlv8Bisaw3Lid6+QxktxrUrXrGV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TO9J1IsRNT3OCNnaPPvtr7v7oV3ikrEK8/E2PdGIPywZJO1mdL0wuMACjWG9EVl/kFLZ17LL7otZJenRnS5zJW1TkGYRJM+4omRjDzunEUo63tu2LkzzNUFxSam8b+tQ88+Ujes08X9NuQr/Yq/5wWXre916HxKrL5+myP5K+JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [31.221.216.127] (port=3090 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sOPZa-00HTYt-9v; Tue, 02 Jul 2024 00:32:36 +0200
Date: Tue, 2 Jul 2024 00:32:32 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [RFC nf-next 3/4] netfilter: nf_tables: insert register zeroing
 instructions for dodgy chains
Message-ID: <ZoMugPfekHpNjGjO@calendula>
References: <20240627135330.17039-1-fw@strlen.de>
 <20240627135330.17039-4-fw@strlen.de>
 <ZoMR2SKHjHJIb1eN@calendula>
 <20240701221830.GB11142@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240701221830.GB11142@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Tue, Jul 02, 2024 at 12:18:30AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > I would not add this patch and keep the reject behaviour, as the
> > > nftables uapi is specifically built around the rule being a standalone
> > > object.  I also question if it makes real sense to do such preload from
> > > userspace, it has little benefit for well-formed (non-repetitive) rulesets.
> > 
> > I am afraid there won't be an easy way to revert this in this future?
> > 
> > Is there any specific concern you have? Buggy validation allowing to
> > access uninitialized registers? In that case, there is a need to
> > improve test infrastructure to exercise this code more.
> 
> Yes, for one thing, but I also do not see how we can ever move to a
> model where registers are re-used by subsequent rules, its incompatible
> with the rule-is-smallest-replaceable-object design.

Yes, incremental updates are an issue. Another possibility is to add
support for static rulesets, so there is a simple way for userspace to
recycle registers (this would be fully performed from userspace).

And users can still inject raw bytecode to make their own programs. We
have been discussing that dumping a listing with bytecode that cannot
be interpreted is an option to deal with "forward compatibility",
similar approach could help deal with this.

If your concern is the register tracking from the kernel, I am not
pursuing that approach anymore and I can make a patch to ditch it
after this series.

> (Meaning: userspace needs to be fully cooperative and aware that
>  it cannot insert a random rule at location x).
