Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242F7392C42;
	Thu, 26 Feb 2026 09:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772097051; cv=none; b=siQpHy6Iijd1vCyqH2uwnQsxNZwtNrBdnGOsryzrpzceXnSy4ZZOmieShLr54+emwxaRmDLxqmT86LES69jmfYjBqxwd4chfGfFQQrYBV9IT57tHbTUHcI35Tx+tCs8cnOgyf0IQ4nWnYb1Q0tSHY07YvTiT4OwqT0PAMH2gBqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772097051; c=relaxed/simple;
	bh=Fh+b1V9rhAgnVw3VtKVw8I5n9lH9h8HQoZhXzFdWI6k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GeV9dMWY2DQBqnpXh6GHSZaDrQqyHvIdFOP4PS7ZJ+y+vZVZNrSre4L5VU8FOsr5i4/m9T5hC99++w5DMB9j5UiqP4hYkxjHrBecuRTXlIhj+iNmAY+oKj/XZeVaGNPx+aSwmg/eHdfL4YbhwXZKM4Y5MPPTF5JwC9KOyWzqr1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 08EFC60516; Thu, 26 Feb 2026 10:10:48 +0100 (CET)
Date: Thu, 26 Feb 2026 10:10:47 +0100
From: Florian Westphal <fw@strlen.de>
To: netdev@vger.kernel.org
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH net 1/2] netfilter: nf_conntrack_h323: fix OOB read in
 decode_choice()
Message-ID: <aaAOFygrzyyp2a_z@strlen.de>
References: <20260225130619.1248-1-fw@strlen.de>
 <20260225130619.1248-2-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225130619.1248-2-fw@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> From: Vahagn Vardanian <vahagn@redrays.io>
> 
> In decode_choice(), the boundary check before get_len() uses the
> variable `len`, which is still 0 from its initialization at the top of
> the function:
> 

@net maintainers: would you mind applying this patch directly?

I don't know when Pablo can re-spin his fix, and I don't want
to hold up the H323 patch.

It seems silly to send a v2 MR with only one change.

Thanks!
