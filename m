Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C1E4A18;
	Thu,  2 Jan 2025 12:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735821377; cv=none; b=fTXWvF28e0wl/x1JlZYNE5qQt2MRYlVd/fgnn/+WA90fgoQp+beLslJE61vP9ijzDEMlVDWawyqmQWzLy+Ib/R8VMADfLc8wjJ1/7xLR6hkHpXRL/4sDyDVT1a1kLSD7Uw0BSh11uhz/zcCXtBcev1mUFfp1ovvH/VKLnDNtB7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735821377; c=relaxed/simple;
	bh=pp6pQk1Pdfs0Vb4mkIADroQb9HTc81pXv5/P4zS9Oss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LtFWVy5HkKJPaLRksAr4kwmT6iS34OZPxz/Y2fMW6iYak2ZnsJUwxXiSEve5m3KKBtsWXCm9NCOWIk7N1xrVBneIQ0UdsGgqmJ8LGhbyLp5Yeb38859+/Yl6r+oGZl0JlVBWPpeXXzhrVCpKjVT5V0+RQF4ZoUFye3a1xMczWJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tTKQe-0000x5-UZ; Thu, 02 Jan 2025 13:35:56 +0100
Date: Thu, 2 Jan 2025 13:35:56 +0100
From: Florian Westphal <fw@strlen.de>
To: =?utf-8?B?U3rFkWtl?= Benjamin <egyszeregy@freemail.hu>
Cc: Florian Westphal <fw@strlen.de>, pablo@netfilter.org,
	lorenzo@kernel.org, daniel@iogearbox.net, leitao@debian.org,
	amiculas@cisco.com, kadlec@netfilter.org, davem@davemloft.net,
	dsahern@kernel.org, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: uapi: Merge xt_*.h/c and ipt_*.h which has
 same name.
Message-ID: <20250102123556.GC3344@breakpoint.cc>
References: <20250101192015.1577-1-egyszeregy@freemail.hu>
 <20250101224644.GA18527@breakpoint.cc>
 <4ad8fb04-b2d6-493b-978c-7dea46fdc623@freemail.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4ad8fb04-b2d6-493b-978c-7dea46fdc623@freemail.hu>
User-Agent: Mutt/1.10.1 (2018-07-13)

Szőke Benjamin <egyszeregy@freemail.hu> wrote:
> 2025. 01. 01. 23:46 keltezéssel, Florian Westphal írta:
> > egyszeregy@freemail.hu <egyszeregy@freemail.hu> wrote:
> > >   /* match info */
> > > -struct xt_dscp_info {
> > > +struct xt_dscp_match_info {
> > 
> > To add to what Jan already pointed out, such renames
> > break UAPI, please don't do this.
> > 
> > It could be done with compat ifdef'ry but I think its rather ugly,
> > better to keep all uapi structure names as-is.
> 
> If i keep the original, maybe one of them will be in conflict between
> "match" and "target" structs name if i remember well (they go the same
> text).

Did not find an example.  Can you please point me to one?

> By the way original structs name are absolutely not following any
> good clean coding, they will be still ugly and they are hard to understand
> quickly in the code, what goes for "target" and what goes fot "match" codes.
> Why is it bad to step forward and accept a breaking change to gets a better
> clean code?

Breaking changes are not acceptable.

> > >   MODULE_LICENSE("GPL");
> > >   MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
> > > -MODULE_DESCRIPTION("Xtables: TCP MSS match");
> > > +MODULE_DESCRIPTION("Xtables: TCP Maximum Segment Size (MSS) adjustment/match");
> > >   MODULE_ALIAS("ipt_tcpmss");
> > >   MODULE_ALIAS("ip6t_tcpmss");
> > > +MODULE_ALIAS("ipt_TCPMSS");
> > > +MODULE_ALIAS("ip6t_TCPMSS");
> > 
> > I think you should add MODULE_ALIAS("xt_TCPMSS") just in case, same
> > for all other merged (== 'removed') module names, to the respective
> > match (preserved) modules.
> 
> Do you mean in all of xt_*.c source, it can be appended by its own
> MODULE_ALIAS("xt_TCPMSS"), MODULE_ALIAS("xt_RATEEST") ... and so on? Can be
> kept old MODULE_ALIAS() names  or they can be removed?

'modprobe xt_FOO' should continue to work, so if xt_FOO was merged into
xt_foo, then 'modprobe xt_FOO' should load xt_foo.

Makes sense?

Same reason as why we have the ipt_tcpmss etc. aliases, it should load
the xt_ module which does provide the relevant functionality.

So yes, please keep all existing aliases.
