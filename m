Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4844C62
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Apr 2025 12:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745412665; cv=none; b=vBbTjun08f7K5gB0VXTNl3QOaj2JY4es8Dyiwaru3lND6IvCeEP7REWk5SxYoW1zHEK1HaWIDxboYtw9sPK2QqKrOkV1kwcLzkVhzxwnOSmqsWvoIyOuGFX9cBs8YRnzC3q7vfCb87iohWZhaX5GS7cgOJn4I0mCMzqKtxY6dCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745412665; c=relaxed/simple;
	bh=/1pnN00GsfOMSZfXztaj3edvGdlF0kyctOf/n/qWun0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GNtnrsiCzgvO14WaWWR9OTGJizLQ70g8oIBLvIJ2jEPOOtWfaV7OKbFamPp0tUqyJap1UT/ej2qB1SgLvfrfU7hFQuX6fZEjdCCF27cZNdeG3nHhd1Zx0zeSijzEM2iKhcPxAVF1heDrCUtDu8cahWqR5fyQrkHimFVaDwfczrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u7ZZ6-0002Yx-GY; Wed, 23 Apr 2025 14:51:00 +0200
Date: Wed, 23 Apr 2025 14:51:00 +0200
From: Florian Westphal <fw@strlen.de>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: Florian Westphal <fw@strlen.de>,
	Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH ulogd2 2/6] db, IP2BIN: correct `format_ipv6()` output
 buffer sizes
Message-ID: <20250423125100.GC7371@breakpoint.cc>
References: <20250420172025.1994494-1-jeremy@azazel.net>
 <20250420172025.1994494-3-jeremy@azazel.net>
 <20250423112204.GA7371@breakpoint.cc>
 <20250423115153.GA349976@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423115153.GA349976@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)

Jeremy Sowden <jeremy@azazel.net> wrote:
> On 2025-04-23, at 13:22:04 +0200, Florian Westphal wrote:
> > Jeremy Sowden <jeremy@azazel.net> wrote:
> > > `format_ipv6()` formats IPv6 addresses as hex-strings.  However, sizing for the
> > > output buffer is not done quite right.
> > > 
> > > `format_ipv6()` itself uses the size of `struct in6_addr` to verify that the
> > > buffer size is large enough, and the output buffer for the call in util/db.c is
> > > sized the same way.  However, the size that should be used is that of the
> > > `s6_addr` member of `struct in6_addr`, not that of the whole structure.
> > 
> > ?
> > 
> > In what uinverse is sizeof(struct in6_addr) different from
> > sizeof(((struct in6_addr) {}).s6_addr)?
> 
> A POSIX-compliant one? :)
> 
> 	The <netinet/in.h> header shall define the in6_addr structure, which shall include at least the following member:
> 
> 	  uint8_t s6_addr[16]
> 
> I dare say it's hair-splitting, but it's the size of the `s6_addr` member that
> is significant, not the structure as a whole.

I'd argue that sizeof(struct in6_addr) > 128 bits is a bug...

In any case i've never seen a definition of in6_addr where there is any
member that would cause this.

> > First patch looks good, I'll apply it later today.  Still reviewing the
> > rest.

FTR, I applied patches 1 and 3 to uglog2.git.
