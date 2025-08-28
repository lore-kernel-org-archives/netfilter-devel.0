Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1335256C6C
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Aug 2025 15:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756393840; cv=none; b=FST15KfcJ2t0RdVtzIbE1+/LOG9LDK2etgyjVW7kRO3vBdUpU1rxdQ9edYnw33utvr9nOwSYI9P/pn0qKBN0rpu2wHQn7Hp9I07U9LLZav20kl+vhhnV5siKM9dPAACKmp097jYfZ//zhafz4pfDf8XfW5LUoJFY/hDHUIXxRsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756393840; c=relaxed/simple;
	bh=AeVLxoCYHof86vMZfcwwWRkCowMLMT5FB6dKUzuZebs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QO+BU2Pha/H/4DiL0TMAURikulAk7TfARxHKwBxVVnEiLgr4Z8h5FNHMWuvUEo0Wblbs4uTBWZuWiWBLI9SCQ7yfl3tZB/zfSKYYHEE9zPEW0rXTiFXuSHatsXhPjvWLNS3I2mzh1SweLaAjUvhn/h54+MXzXDRiyOo1sQ6lXWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id AFCFB601EB; Thu, 28 Aug 2025 17:10:35 +0200 (CEST)
Date: Thu, 28 Aug 2025 17:10:35 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Sven Auhagen <Sven.Auhagen@belden.com>
Subject: Re: [PATCH nf-next v2 1/2] netfilter: nf_tables: allow iter
 callbacks to sleep
Message-ID: <aLBxa0V0b5QbTZzC@strlen.de>
References: <20250822081542.27261-1-fw@strlen.de>
 <20250822081542.27261-2-fw@strlen.de>
 <aLBn8Q3hgcqCvk4D@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLBn8Q3hgcqCvk4D@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > +		if (iter->count < iter->skip) {
> > +			iter->count++;
> > +			continue;
> > +		}
> 
> Not causing any harm, but is iter->count useful for this
> NFT_ITER_UPDATE variant?
>
> I think iter->count is only used for netlink dumps, to resume from the
> last netlink message.

Yes. Should I just remove the above or also add a WARN_ON_ONCE(iter->skip) ...

> > +	switch (iter->type) {
> > +	case NFT_ITER_UPDATE:

... here?
