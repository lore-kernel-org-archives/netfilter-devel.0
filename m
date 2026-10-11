Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B760F459ACC
	for <netfilter-devel@vger.kernel.org>; Sun, 11 Oct 2026 19:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791746047; cv=none; b=VjnSwz8XfZJvpU+9F64+RXxVBou323Q28YvXRGHUQKy8wyCaJ/O3o776rLMfTx3KslHwN+gvIeRHe5JJXclnkMcjwBG8MuxzhRgMnmAQdxFgp2dHCScH/lEG4kYu7gNyZjlZtuNvAMqJJAkNNM5Uy+9jZSbbveNFjt0f0iPA3wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791746047; c=relaxed/simple;
	bh=yimLVBHSTxg4alxR99FNVzY055TcXiZ4aGrIkrxFihI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KGnvi6FYtyzFIuypR0nOaCNJETU/y51PDCU/1encIvDuH1vrvG0DPD4ak5KhDuQKZbjmWrsOtdkNMg4y4WYbB8AXFI0mt3HnBGUjTzRr3sUPe/a4WZBpzar2sCFMqVZlq+1Gsr4ttY8bljdGqTUO1L6I+qc9HZg86M4xj1DXG2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2C7A9602F5; Sun, 11 Oct 2026 21:14:02 +0200 (CEST)
Date: Sun, 11 Oct 2026 21:14:01 +0200
From: Florian Westphal <fw@strlen.de>
To: SaifAllah benMassaoud <saifmassaoudi18@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, security@kernel.org,
	netfilter-devel@vger.kernel.org
Subject: Re: [SECURITY] netfilter: nft_limit byte-rate bypass via unchecked
 u64 multiplication
Message-ID: <asvf-crRnd2ReH9c@strlen.de>
References: <CADikNYAX9Y0kTzdAZ4zNHrxcheN-tQ-DfQJxzmVmwgR9c5FKNw@mail.gmail.com>
 <ass78_hPLuoRO2kW@chamomile>
 <CADikNYCzQRErYLwDLoUPrDs8dmuBB8z+45yxKAaps7QTCrLXXA@mail.gmail.com>
 <asu_nz0tXmnsZIFQ@chamomile>
 <CADikNYBiijxQjptcYf-2+omXj8Mf5PTGVwK-Ho53E7JEe_ehvQ@mail.gmail.com>
 <CADikNYA74Zco-PnTvQOih+=A-Hq6ZCV1oyoC+xszGJy756gzMw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADikNYA74Zco-PnTvQOih+=A-Hq6ZCV1oyoC+xszGJy756gzMw@mail.gmail.com>

SaifAllah benMassaoud <saifmassaoudi18@gmail.com> wrote:
> My security concern is that an administrator may configure this limit to
> protect a service, yet a less-privileged sender could circumvent the
> intended rate enforcement by sending packets of specific sizes, without
> modifying the ruleset.

Why would anyone use 'per week' rates...?

N packets/s.
N packets/minute
N packets/hour.

.. make sense to me.

But even N packets/day is dubious. with that kind of limitation, why
would you even log in the first place?

The byte rate limiting is for traffic policing, i.e. N bytes / second.
The obvious 'fix' for your case is to reject the rule add.

diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -73,6 +73,10 @@ static int nft_limit_init(struct nft_limit_priv *priv,
        if (check_mul_overflow(unit, NSEC_PER_SEC, &priv->nsecs))
                return -EOVERFLOW;

+       if (!pkts &&
+           check_mul_overflow(priv->nsecs, GRO_MAX_SIZE, &tmp))
+               return -EOVERFLOW;
+
        if (tb[NFTA_LIMIT_BURST])

but I agree with Pablo, this is not a security issue.
Consider testing the above and then submitting that as a patch,
targetting nf-next tree.
