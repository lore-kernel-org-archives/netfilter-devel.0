Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D9A3E4C7F
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Apr 2026 17:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777050854; cv=none; b=scK4IjgB4QjXoiC7sjurKRIC/poyni/+/sDcZozYiqj+aqDCqqmcvZcwz/IBLe0XU42cc6f3RwwpKrV0FMJWHS/BQUi254XooikAU1+shL1MlLPO7ns9zGPQVEkx5SsRfcs0XCL4/DRcXkAac5M7LH3jDglZP4V4NjzTFccGC4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777050854; c=relaxed/simple;
	bh=avuXtfTr98umn+Vg8Rj8X2RM9t03Uxoa7uJKMV+3qIo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BPCsMwOldSE87TvFwYS3wlqsCzJIsW5DsJpbnRx2uR5MCM+OAH+Gip9tgqkGWwKp3zKGGAFA5KP5cMX343C4Amzr5WEIQEVHyBbalAuSvtS8PBvWXCH/rAWd86VC6UPlHKusnJrMh/bAaMqR9k7sEsNNra/XOfgmoq3OpH47iWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rIR3qCR4; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rIR3qCR4"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 7407B60178;
	Fri, 24 Apr 2026 19:14:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777050849;
	bh=UDrvALqsOBbDBMlCtUU7ekRnxzIgZPpjqiXGIN8H8Ak=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rIR3qCR4hiDWBVzRIJNpRoDfo5DVnunzbL/nYJxt3YFcwz1F0lZ4Z7zY403vHH89j
	 UKZXCFx7aia0UaQQwSed6nWCX+WmhzoPEg8noEGvfCXcmq/KIJeJI1VzZH8H3b98to
	 k5vo2S4dvIMrto2V1wFT9c9SVhvHYSZAqhiQJU4uXETgefNpvv3wVY2i3U9LhUEhaJ
	 cAiTEHBtzYYY/p16794CfDK+vYTbL4MYA2qIWKUzPqfMZpPjrRSy2AxIuXIEx2tv3o
	 54v7321sR8UR47fFx7MH0N6lzSNRAK7XRhsmbs+/GZogEmUk+A7vPpjwQK4qBHkCE/
	 7m1rR0S+PsmuQ==
Date: Fri, 24 Apr 2026 19:14:06 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	jeremy@azazel.net, phil@nwl.cc, fw@strlen.de
Subject: Re: [PATCH nf v3] netfilter: nft_bitwise: fix dst corruption in same
 register shifts
Message-ID: <aeuk3q5KjtHlkt__@chamomile>
References: <20260423155453.7499-1-fmancera@suse.de>
 <aetRiG3x9S3PQHaw@chamomile>
 <a40745d0-ee68-40b8-8eba-70edb89e25a0@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a40745d0-ee68-40b8-8eba-70edb89e25a0@suse.de>

Hi Fernando,

On Fri, Apr 24, 2026 at 05:03:17PM +0200, Fernando Fernandez Mancera wrote:
> On 4/24/26 1:18 PM, Pablo Neira Ayuso wrote:
> > Hi Fernando,
> > 
> > On Thu, Apr 23, 2026 at 05:54:53PM +0200, Fernando Fernandez Mancera wrote:
> > [...]
> > > @@ -201,6 +206,11 @@ static int nft_bitwise_init_shift(struct nft_bitwise *priv,
> > >   		return -EINVAL;
> > >   	}
> > > +	if (priv->sreg != priv->dreg &&
> > > +	    priv->dreg < priv->sreg + n &&
> > > +	    priv->sreg < priv->dreg + n)
> > 
> > Is this enough? Just to make sure we are on the same page.
> > 
> > NFT_REG_1
> > NFT_REG_2
> > NFT_REG_3
> > NFT_REG_4
> > 
> > have a size of 128 bytes.
> > 
> 
> Right but if I am not wrong these registers are mapped/normalized. That
> happens during nft_parse_register() earlier in the init() path.

Indeed, registers has been already normalized by nft_parse_register()
at this stage.

> Therefore we must expect priv->sreg/dreg in the range [4, 19].
> 
> > Then, NFT_REG32_00, NFT_REG32_01, NFT_REG32_02 and NFT_REG32_03
> > basically overlap with NFT_REG_1. They split the 128 bytes of
> > NFT_REG_1 in 4 registers of 32 bytes.
> > 
> > Is this check above enough to deal with the partial overlaps?
> > 
> 
> I am not very good at math but as long as we have the length of the data we
> can calculate the overlap in 4 bytes segments. Of course if from userspace
> you mix both APIs the math should hold up.
> 
> let's say we have NFT_REG_1 as sreg and NFT_REG32_O1 as dreg and length of 8
> bytes.
> 
> That is after normalization:
> 
> sreg: 4 and dreg: 5
> 
> sreg expands through registers 4 and 5
> dreg expands through registers 5 and 6
> 
> The check is able to catch it. Of course, if the length would be 4 bytes,
> the check would pass but that is fine.
> 
> At the end NFT_REG_1 is mapped to 32bits register number 4 while
> NFT_REG32_O1 is mapped to 32 bits register number 5.
> 
> Does this make sense? Anyway, AI suggested if this should be applied XOR,
> OR, AND, etc. I think yes, as the partial overlap could corrupt the result
> there too. So a v4 is needed anyway.

OK, let's do that.

Thanks.
