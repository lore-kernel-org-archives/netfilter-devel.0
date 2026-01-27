Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1024378F2E
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2026 22:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769554040; cv=none; b=lp40yQN8UUH+f5AX9b9x9KwYd41NxvYcVpAIxSkCM8fYBfB4cB1rsQnDBFiaRzhdmGtHguCPkqI2s6I6y3u0Yqkyf9j214JRLKhtnPokwkGqgSROAm0IFwEmQIgE01dfN74CYFPDXWSg2HSs8m7ZnsoIdLy70rOgJVEnxZUULhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769554040; c=relaxed/simple;
	bh=dPL2X2lDd1R6ot3OFCK5VFulIQy06XBNnN20ROigslc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=No6puOwAgThIGuYKtLbkORW5AZ3gvjVYHKFK+p/PLzQ8xtXSmiC3zcJfs9XLXGjS7Q44XI761RWuzm4I9Tah+oUrhxAdisYxXTVfl2WZADilSBx+a5d4MOH+eVDurVdqGfymqxfV7/AwRu7/frjL3TrBDsK2NdOm8YsEF0vT15M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 466EA602B6; Tue, 27 Jan 2026 23:47:16 +0100 (CET)
Date: Tue, 27 Jan 2026 23:47:16 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] doc: nft.8: Describe iface_type data type
Message-ID: <aXlAdFAKM5SVfFfE@strlen.de>
References: <20260127221252.27440-1-phil@nwl.cc>
 <aXk5l4AQ4XHvyBrx@strlen.de>
 <aXk-ZPRpYwj_KZ5e@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXk-ZPRpYwj_KZ5e@orbyte.nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> On Tue, Jan 27, 2026 at 11:17:59PM +0100, Florian Westphal wrote:
> > Phil Sutter <phil@nwl.cc> wrote:
> > > +INTERFACE TYPE TYPE
> > > +~~~~~~~~~~~~~~~~~~~
> > 
> > TYPE TYPE?
> 
> Yes, sadly. ;)

Ugh.

> We also have "ICMP TYPE TYPE" and "ICMPV6 TYPE TYPE" - the types
> themselves are called "icmp_type", "icmpv6_type" and "iface_type". So
> section titles formed like "<type> type" end up this way. It seems
> wrong, but "INTERFACE TYPE" is misleading as the type is not called
> "interface" but "interface type".

Whats wrong with INTERFACE TYPE?

Its called interface type.
I'd remove the extra TYPE everywhere, its not many occurences:

data-types.txt:ICMP TYPE TYPE
data-types.txt:The ICMP Type type is used to conveniently specify the ICMP header's type field.
data-types.txt:ICMPV6 TYPE TYPE
data-types.txt:The ICMPv6 Type type is used to conveniently specify the ICMPv6 header's type field.
