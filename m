Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67403363C55
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Jun 2026 15:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780412405; cv=none; b=iO9hd/RJXRwjTkXlL5GIS29OnlIXUp3lEZZwNP4l2tjhISRA7qvozU8lHhyPfDeFm9zKVnNGaTfg2TpcCpO5KEQzOgWQmysvgZRsISlFXSRyJEloQ/kaHLzb3P8TgATNjzRbIleCb1nLAjrb2aoRDmuMMTJbMYGvAkNnmxz/G0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780412405; c=relaxed/simple;
	bh=hM5OYa8eumNRji5MflCe4PTVfGsylfM0RtONzYhZ8aI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B5CjdL5fhyEUeUh2Munl+hH8rOfaxW7EC5w9RpzitTbeIOFiVFrfd8yrz22rPyRiIjQ97VZpw+3Ma9AFx+gzAhgwPIbXmErnouP2vQ9uP3QOvK1bPEdAKhiI+TEDSaKR5MqCsewZGvXq1Qgt5l1lHz5gxGmySg/3gvOPSxaaC/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 252B960337; Tue, 02 Jun 2026 17:00:01 +0200 (CEST)
Date: Tue, 2 Jun 2026 16:59:55 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Ji'an Zhou <eilaimemedsnaimel@gmail.com>, security@kernel.org,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_exthdr: fix register tracking for
 F_PRESENT flag
Message-ID: <ah7v6zAnJU1D_gxB@strlen.de>
References: <20260602074029.2851388-1-eilaimemedsnaimel@gmail.com>
 <ah6XqhKkEvMOlU-4@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ah6XqhKkEvMOlU-4@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Jun 02, 2026 at 07:40:29AM +0000, Ji'an Zhou wrote:

Adding netfilter-devel@, there is no need to keep this 'secret'.
We have some many bugs security@ is overwhelmed anyway.

fib seems to have same issue.
Probably this, please test & submit.

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -532,6 +532,9 @@ static int nft_exthdr_init(const struct nft_ctx *ctx,
                        return err;
        }
 
+       if ((flags & NFT_EXTHDR_F_PRESENT) && len != 1)
+               return -EINVAL;
+
        priv->type   = nla_get_u8(tb[NFTA_EXTHDR_TYPE]);
        priv->offset = offset;
        priv->len    = len;
diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -107,6 +107,9 @@ int nft_fib_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
                return -EINVAL;
        }
 
+       if (priv->flags & NFTA_FIB_F_PRESENT)
+               len = sizeof(u8);
+
        err = nft_parse_register_store(ctx, tb[NFTA_FIB_DREG], &priv->dreg,
                                       NULL, NFT_DATA_VALUE, len);

