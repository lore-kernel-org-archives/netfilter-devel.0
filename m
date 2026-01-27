Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8787422256F
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2026 22:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769554753; cv=none; b=FlP0otXm1LzpH+IQeZfT81f9HnCgBg/r0xdurzwB7xab8GXKBYGEax0EC8zw+7umxPjdCpKgkM/TAKepIjjmSBVK138/QIUG2VPvd6NpnZ3/EaFijxpMm52OqyZHIRVtvutzNhjS+FhuoYKTm5m22BpvLvYOJ9DsJCDe1OcUO18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769554753; c=relaxed/simple;
	bh=7Q1oGwvV3huHcWDTPIQ+Z+C+qayu0oWpRjJm5Tp2R8U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c0JwTwQ9uwn5oIcrTddlS/E53hS27X/JF98Xzg3OoxRSdGOGIgOBxQ+LfbMBlNbAkTSARscvNcq/czr9igsuHDZ92GLQUQOZmHCTAU1fgMAA25SthsGhYN1s6O98pZ2xK1uei5s7ig30G/XHTNXj+Ctk8QvNkpM5rZpYXX7BTig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=B23/SHOs; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="B23/SHOs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rs0DTCSHywUHgISN4AxRtCjsjbSCMW6AnhvGyRMFA8U=; b=B23/SHOs2VCWNl7Lyub7T30tRE
	wgnRMWLQDNRCP1zQ9I4GI00ilDwrzm2af30oYGvElv9Vapu2aUEu5Qhwymdj4IA5GbjlyxhnwVjZx
	Uz9d0Y8/Wn3GSCcRxNXXyjWa4aLkj2epjV+yUm1uo48n5TkMS7e18aGseGYzLumobQLCpa8OlSD9a
	tnTM6qpcc6tH/DlgK8qooIh4iynjzK6tg92Fv+5hlx6Bc/bu6AhAmFAGSjmvfd5H8C9oy2toEaQE0
	wMDuouFzgkF9ex+EFWP0xNfE7lrms0RUIJEUpE7Pywr1b++DmPEgY3BysdroGdGP6RGes3NrYWx4r
	hM4neYFQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vks1f-000000003Np-0M9j;
	Tue, 27 Jan 2026 23:59:11 +0100
Date: Tue, 27 Jan 2026 23:59:11 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] doc: nft.8: Describe iface_type data type
Message-ID: <aXlDPwtasLIQ9NMg@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20260127221252.27440-1-phil@nwl.cc>
 <aXk5l4AQ4XHvyBrx@strlen.de>
 <aXk-ZPRpYwj_KZ5e@orbyte.nwl.cc>
 <aXlAdFAKM5SVfFfE@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXlAdFAKM5SVfFfE@strlen.de>

On Tue, Jan 27, 2026 at 11:47:16PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > On Tue, Jan 27, 2026 at 11:17:59PM +0100, Florian Westphal wrote:
> > > Phil Sutter <phil@nwl.cc> wrote:
> > > > +INTERFACE TYPE TYPE
> > > > +~~~~~~~~~~~~~~~~~~~
> > > 
> > > TYPE TYPE?
> > 
> > Yes, sadly. ;)
> 
> Ugh.
> 
> > We also have "ICMP TYPE TYPE" and "ICMPV6 TYPE TYPE" - the types
> > themselves are called "icmp_type", "icmpv6_type" and "iface_type". So
> > section titles formed like "<type> type" end up this way. It seems
> > wrong, but "INTERFACE TYPE" is misleading as the type is not called
> > "interface" but "interface type".
> 
> Whats wrong with INTERFACE TYPE?

As said, these headers are all structured as "<typename> TYPE":

- INTEGER TYPE
- BITMASK TYPE
- STRING TYPE
- INTERFACE TYPE TYPE
- LINK LAYER ADDRESS TYPE
- IPV4 ADDRESS TYPE
...
- ICMP TYPE TYPE
- ICMP CODE TYPE
- ICMPV6 TYPE TYPE
...

IMO we could drop the " TYPE" suffix from them all, but only merging the
"TYPE TYPE" cases is inconsistent.

> Its called interface type.
> I'd remove the extra TYPE everywhere, its not many occurences:
> 
> data-types.txt:ICMP TYPE TYPE
> data-types.txt:The ICMP Type type is used to conveniently specify the ICMP header's type field.
> data-types.txt:ICMPV6 TYPE TYPE
> data-types.txt:The ICMPv6 Type type is used to conveniently specify the ICMPv6 header's type field.

Here we at least get a hint from the casing: The type's name is "ICMPv6
Type", so "the type named "ICMPv6 Type" becomes "the ICMPv6 Type type".

I get your point, it looks wrong and sounds odd when reading out loud
but it is formally correct.

Cheers, Phil
