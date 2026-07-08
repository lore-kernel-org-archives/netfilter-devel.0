Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5501E3B71C7
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jul 2026 14:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783522596; cv=none; b=Pb1/SpF5PvFshRd9XZIFdldCqoELWtELmem2St/JOPnfiNhEj7Y/urPRZI0fGJrqtDljtuZPFNkG5dHGfkhKVzcESU21FLUQVSCrKTHRZyQoYyzh/HQRjtc6o7jiysVcmTtmTC4HFOfhjPNMuObUfn3MsaX35ayYsP4eE9U6J4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783522596; c=relaxed/simple;
	bh=d53hDIMiIofWRYrOwXy+zbiy518ScHwjHUbpcZj6ewg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gx12Uz8ub6atAPOcoyXo+G0O0fIhCNStm6/JxpqOluDoAbjCoKykH8DJtiM1xC1LLP8WDyNwYLlfmvJnMBEYMnnwFTIy6xHfkAgPJ/09NT3+DaRs071NkC8/lIKhBye4ZSAXr0N7eUAHSOopxaJ/n9uXgIQLDWeW/Rb+dG/8ddw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9130B60F16; Wed, 08 Jul 2026 16:56:32 +0200 (CEST)
Date: Wed, 8 Jul 2026 16:56:31 +0200
From: Florian Westphal <fw@strlen.de>
To: Carlos Grillet <carlos@carlosgrillet.me>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/4] netfilter: replace u_int*_t with kernel int
 types (batch 3)
Message-ID: <ak5lH1UnFth6oreP@strlen.de>
References: <20260707195111.34899-1-carlos@carlosgrillet.me>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707195111.34899-1-carlos@carlosgrillet.me>

Carlos Grillet <carlos@carlosgrillet.me> wrote:
> This patch series replaces POSIX u_int8_t/u_int16_t/u_int32_t with the
> preferred kernel types u8/u16/u32 across several netfilter files and
> updates the corresponding header definition.
> 
> This continues the work started in:
> https://lore.kernel.org/all/20260616182948.96865-1-carlos@carlosgrillet.me
> 
> No functional changes.
> 
> Carlos Grillet (4):
>   netfilter: ip_vs_core: replace u_int32_t with u32

This one is fine, its the only occurence.

>   netfilter: nf_conntrack_sip: replace u_int16_t with u16

No need to send a v2, I "fixed" this locally, but this
could have been
'netfilter: nf_conntrack: replace u_int16_t with u16'

 nf_conntrack_core.c    |    4 ++--
 nf_conntrack_irc.c     |    4 ++--
 nf_conntrack_netlink.c |    6 +++---
 nf_conntrack_pptp.c    |    8 ++++----
 nf_conntrack_sip.c     |    2 +-
 5 files changed, 12 insertions(+), 12 deletions(-)

>   netfilter: nf_nat_amanda: replace u_int16_t with u16
>   netfilter: nfnetlink_osf: replace u_int8_t with u8

I'm not applying these two.  Please find a way to make
larger logical changesets.

These one-lines are just extra churn.
E.g. make one patch for nf_nat.

Or address all of u8/18/u32 in same change.
