Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82562E8B98
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2026 15:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777562748; cv=none; b=aO7TkK3yDw+C5CNMiHPQy3D+CjHxZ77aHcEPPNaNpTgMqEVuCiA9+xolamiVPXBvj2h9ieDGPiVzgdrSwn2er9oiayC8neuAQYzyx/tEwxrJLUN0s/PKSG+t1ePabtyfI5ypGQn/Qghvj7me/VQ6nEFLv1u8b2+3x/nDpkJiHgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777562748; c=relaxed/simple;
	bh=IINQZQWrXzp0M1ZkVK0cThYsqV4DIWGlmCrV0iGOc7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WmlMJRNNmyZcCDMV1iLBqeJlD3L4furuNEYgKDS9whTzsycTuEOr7whd+iEjdbvhhU8dMz08gzF+s5Jj89Yey3X4Bv8kYoTaDv3QPz/GeOy5qnxqbFEwlPsCcSiuxy97diFa9ogVyEXezgNNjCBM5tnwirKL5OWedFEBdbVH6mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=uv4EFyez; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="uv4EFyez"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id C990D60179;
	Thu, 30 Apr 2026 17:25:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777562745;
	bh=wtG1hkTooA5UlSq2jwzGHfaTT0QIRO5hq1PopLyd5UQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uv4EFyezk48sqFnztI4KnhwTcrlmwd9pNxPekmvc/4TZ8AWrt9QL8Q6qvfcUJ7zDR
	 BYvbKWLjgB+m3D0sGkvt/8BF/YI1UTsWls8OD7VR42yJV99KcWd/r9rs7wq69yUASp
	 t/MmoD1ommi/tCohgntGrBYsa99to40YJEXQTrC6keuwvT60JfXGNL/unajY9aJYxI
	 IsM4qb2SF2MncYo5PqnaxreAe2UUZrq3afSKkj8NF7PMPd7YLpplQtD6Oh22Vegpi3
	 EKb453D1+p9Bgq+QiVOlLfAeM0qG4KU7dLH9T+J5FIG157ev52WaoUJHedhCMdRYT9
	 VP28kjQsB7Hag==
Date: Thu, 30 Apr 2026 17:25:42 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: rc <rc@rexion.ai>
Cc: fw@strlen.de, security@kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: netfilter: nf_conntrack_irc: port truncation via simple_strtoul
 to u16 enables NAT pinhole
Message-ID: <afN0dilSmWd7FqqT@chamomile>
References: <PXMDJKI85TU4.1D0TDUURTP402@mailcore-6d9c45d7fd-m8dqv>
 <afNz3OrUVkshakQU@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <afNz3OrUVkshakQU@chamomile>

On Thu, Apr 30, 2026 at 05:23:11PM +0200, Pablo Neira Ayuso wrote:
> Cc'ing netfilter-devel@
> 
> On Thu, Apr 30, 2026 at 03:00:20PM +0000, rc wrote:
> > hey,
> >  
> > I would like to report the above security issue:
> >  
> >  
> >  Affected versions: all kernels with net/netfilter/nf_conntrack_irc.c 
> > (verified present in 7.1.0-rc1 mainline, code unchanged since initial
> > implementation)
> >  
> >  
> > Description
> > -----------
> >  
> >  
> > parse_dcc() in nf_conntrack_irc.c stores the return value of
> > simple_strtoul() directly into a u_int16_t pointer (line 96):
> >  
> >  
> >  *port = simple_strtoul(data, &data, 10);
> >  
> >  
> > simple_strtoul() returns unsigned long. When the attacker-controlled
> > port string in a DCC command exceeds 65535, the value silently
> > truncates to u16. For example:
> >  
> >  
> >  65558 → u16 = 22 (SSH)
> >  131094 → u16 = 22 (SSH)
> >  65536 → u16 = 0
> >
> > An attacker on an IRC channel can send a crafted DCC SEND message
> > through a Linux NAT gateway running the nf_conntrack_irc helper. The
> > helper parses the port, truncates it, and opens a NAT pinhole
> > (via nf_nat_irc) for the truncated port on the internal host. This
> > bypasses the firewall/NAT to expose arbitrary services (SSH, HTTP,
> > database ports) on internal hosts.
> 
> You don't need truncation to open a port via conntrack helper with an
> expectation.
> 
> Tighening the conntrack helper parser is fine, this is net-next
> material:
> 
> 0) There is a document by Eric Leblond already explaining the
>    situation with conntrack helpers, which is old.
> 1) Helper are disabled by default, you have to enable them explicitly
>    via ruleset, for some time already.
> 
> Thanks for your report.

Having said this, patches are welcome for consideration, this is a
project run by volunteers, that is the best way you can contribute.

Thanks.
