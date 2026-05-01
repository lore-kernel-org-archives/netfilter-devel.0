Received: from mta1.formilux.org (mta1.formilux.org [51.159.59.229])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663CF2D97BB
	for <netfilter-devel@vger.kernel.org>; Fri,  1 May 2026 05:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.59.229
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777611627; cv=none; b=CF5oRijvyeMn/7oSrXMP38P9iHnBrXsyYuBgmHLV1Pw38e321rwDGf922PYI8XR9PAnRAAIOnQEPs2qzyx3z/FBiEk9TZyue8TuyYsU3X8YT7SHoeGLKdX53Gv1//HVP5sjxz9+d7rMLb+/ZZNMswwxr5DQ33USaLO5wAoie51I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777611627; c=relaxed/simple;
	bh=p6ZzItV3eWl+7ewRVq/T++3Dn2IlCZDqhpXw6IncNds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RFxRghvl9sHQsesA1yjC2ayX3kvgdC3v8efHdGCmt3/h4aq/yMly9QD+hG7L9K8X+DwkioruLOTSm6D5JZm7DzyuVDf6R2J3ps97jJoXCajy3Ohshp/UAj5KbxxPqfHTeeQvzPp4pcFtnrTYuWrJL/mWIJdZvN/GJfDW/yw/yHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=1wt.eu; spf=pass smtp.mailfrom=1wt.eu; dkim=pass (1024-bit key) header.d=1wt.eu header.i=@1wt.eu header.b=e/Ui3cxg; arc=none smtp.client-ip=51.159.59.229
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=1wt.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=1wt.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=1wt.eu header.i=@1wt.eu header.b="e/Ui3cxg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1wt.eu; s=mail;
	t=1777611612; bh=mHtoYe0sM8wYfX3OU6AI39u8RqiVPAxWsH2dxo3ZaKI=;
	h=From:Message-ID:From;
	b=e/Ui3cxgSI81/LyeZe0YIsP3J5bMMDwhcN8dItMMjB7yOmKdJ2X5gLyWcyM9NjCuS
	 y1i/ZTAmo01VNuJWFQiAERnp2Ujn0ZK46C7NNpvRmUB5GxAlwI/CoWH4uF5jc7gE5+
	 vESfK0ledUF7+A0V7g+3Mvpz7boa6H38rE4mc3Uc=
Received: from 1wt.eu (ded1.1wt.eu [163.172.96.212])
	by mta1.formilux.org (Postfix) with ESMTP id C46F9C0A7D;
	Fri, 01 May 2026 07:00:12 +0200 (CEST)
Date: Fri, 1 May 2026 07:00:02 +0200
From: Willy Tarreau <w@1wt.eu>
To: rc <rc@rexion.ai>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, fw@strlen.de, security@kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: netfilter: nf_conntrack_irc: port truncation via simple_strtoul
 to u16 enables NAT pinhole
Message-ID: <afQzUtDLyz2AVMcM@1wt.eu>
References: <PXMDJKI85TU4.1D0TDUURTP402@mailcore-6d9c45d7fd-m8dqv>
 <afNz3OrUVkshakQU@chamomile>
 <afN0dilSmWd7FqqT@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afN0dilSmWd7FqqT@chamomile>

On Thu, Apr 30, 2026 at 05:25:42PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Apr 30, 2026 at 05:23:11PM +0200, Pablo Neira Ayuso wrote:
> > Cc'ing netfilter-devel@
> > 
> > On Thu, Apr 30, 2026 at 03:00:20PM +0000, rc wrote:
> > > hey,
> > >  
> > > I would like to report the above security issue:
> > >  
> > >  
> > >  Affected versions: all kernels with net/netfilter/nf_conntrack_irc.c 
> > > (verified present in 7.1.0-rc1 mainline, code unchanged since initial
> > > implementation)
> > >  
> > >  
> > > Description
> > > -----------
> > >  
> > >  
> > > parse_dcc() in nf_conntrack_irc.c stores the return value of
> > > simple_strtoul() directly into a u_int16_t pointer (line 96):
> > >  
> > >  
> > >  *port = simple_strtoul(data, &data, 10);
> > >  
> > >  
> > > simple_strtoul() returns unsigned long. When the attacker-controlled
> > > port string in a DCC command exceeds 65535, the value silently
> > > truncates to u16. For example:
> > >  
> > >  
> > >  65558 -> u16 = 22 (SSH)
> > >  131094 -> u16 = 22 (SSH)
> > >  65536 -> u16 = 0
> > >
> > > An attacker on an IRC channel can send a crafted DCC SEND message
> > > through a Linux NAT gateway running the nf_conntrack_irc helper. The
> > > helper parses the port, truncates it, and opens a NAT pinhole
> > > (via nf_nat_irc) for the truncated port on the internal host. This
> > > bypasses the firewall/NAT to expose arbitrary services (SSH, HTTP,
> > > database ports) on internal hosts.
> > 
> > You don't need truncation to open a port via conntrack helper with an
> > expectation.
> > 
> > Tighening the conntrack helper parser is fine, this is net-next
> > material:
> > 
> > 0) There is a document by Eric Leblond already explaining the
> >    situation with conntrack helpers, which is old.
> > 1) Helper are disabled by default, you have to enable them explicitly
> >    via ruleset, for some time already.
> > 
> > Thanks for your report.
> 
> Having said this, patches are welcome for consideration, this is a
> project run by volunteers, that is the best way you can contribute.

Rahul, could you please turn your proposed fix into a regular patch ready
to be applied as per Documentation/process/submitting-patches.rst ? This
will save some maintainers' time and is the best way for you to be credited
for finding and fixing this bug, if accepted.

Thanks,
Willy
