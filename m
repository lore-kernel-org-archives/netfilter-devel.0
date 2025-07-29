Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5241B22539E
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Jul 2025 10:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753784875; cv=none; b=H1KijtPpm/WkRe1iu61QRIedgzXQbCtzoaUK10jmJOrQAcCdVPYAPJfXavcF/9sUaWAT/golxdfRRnClS1w1kkdc0ZRUFKdU59K5RFe2cxfOrnITryLE+tYKTaxpIowhVCOkvctYcKY4rL2OGTxWEVCGo16pCku3NWWolmWRQPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753784875; c=relaxed/simple;
	bh=d3xBrTsll6YdFTfmDeqyp/E5mN/hxyWN2tWku5kYQ2c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r3JhveAPc2Cz9o1hVMFrjREfVPQFE4l/IWudHm4w71Svo3cc3uTCgiVA9Uy91SXJOK0WclrOQeNKwlBZEvfWtTxkQXBPlJBqAF9Aw8aiwVc0b4wds3FrYugxeT1f0dOg3mVgtcDjD6Cgc9PFArmibg3OhlDo2i2EpJZRWLgYONY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=BoVzB6+c; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=iws1J7Ja; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="BoVzB6+c";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="iws1J7Ja"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 74F256026D; Tue, 29 Jul 2025 12:27:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753784870;
	bh=44hrAerCTmi66PVEJLbJqP5hzxJEtgYFZJJXOEE6Gk0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BoVzB6+cckAE7XDni6Kddbb4KWNdIJ+d1B4e7LEDeRytaLB/PGE1E5t7S/McQi9LS
	 voJ4MJ7wRH6o83YQzJIVHQv8lZ5t2uG1eq0H3XUfTRQjIExIQhbjADpZ9PjArX0hL+
	 T4bSzJ056u8dWjnWdPDECCEPcVE0s+CzDKbodUcJOJOet/eR3SzpKiXpQC1R0pgPcD
	 bxo4EUBYw+warr33baLPM4SCzfIPCqnGIXqklLNKJC3VbMbrfEVpFb+u5bswL+vNx0
	 o0lvPogab80ZXIe/LUFh+gXaGaDbN+7F6U0FpioHpLjJMQ6/4+KyFaw4xKL+cTXDgl
	 aAzgAccHYk5VA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 851FD60265;
	Tue, 29 Jul 2025 12:27:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753784869;
	bh=44hrAerCTmi66PVEJLbJqP5hzxJEtgYFZJJXOEE6Gk0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iws1J7Jah0Lwm2wCX9P5nFL8iBj0TEBpv3SQnmqcFqrt1o4jscTSAf8KaLKgO7pjD
	 hAQzVP6ZgwY6TDuG4bfuKJoYjGHfY31KeGXpOOQcEyF3UJfIa9ohseoST23mvWRQGu
	 StaDqXaG6hn1RbpRlJ0PlOdZMO5HP9MTW2Gw9j000nf2exLGiop14JjIIexRumCbUP
	 LoxXVD5eey9C/LJvaDALNiehsm4ARYX5OVDyAeY0KRSuG8tgTnNQNrBStQsSMXlQva
	 RdusMvoA0ykT/UHFpLsaJcWRDdUeKh1ppc0COvVeYXMKxfcaqS6oHqXBKcLJaY+vca
	 lh6avB9bEDGAQ==
Date: Tue, 29 Jul 2025 12:27:46 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nf-next 0/2] netfilter: nf_tables: make set flush more
 resistant to memory pressure
Message-ID: <aIiiIohMBjyfqT3e@calendula>
References: <20250704123024.59099-1-fw@strlen.de>
 <aIK_aSCR67ge5q7s@calendula>
 <aILOpGOJhR5xQCrc@strlen.de>
 <aINYGACMGoNL77Ct@calendula>
 <aINnTy_Ifu66N8dp@strlen.de>
 <aIOcq2sdP17aYgAE@calendula>
 <aIfrktUYzla8f9dw@strlen.de>
 <6f32ec06-31bf-f765-5fae-5525336900c5@blackhole.kfki.hu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6f32ec06-31bf-f765-5fae-5525336900c5@blackhole.kfki.hu>

Hi Jozsef,

On Tue, Jul 29, 2025 at 09:22:46AM +0200, Jozsef Kadlecsik wrote:
> Hi,
> 
> On Mon, 28 Jul 2025, Florian Westphal wrote:
> 
> > Another option might be to replace a flush with delset+newset
> > internally, but this will get tricky because the set/map still being
> > referenced by other rules, we'd have to fixup the ruleset internally to
> > use the new/empty set while still being able to roll back.
> 
> If "data" of struct nft_set would be a pointer to an allocated memory area,
> then there'd be no need to fixup the references in the rules: it would be
> enough to create-delete the data part. (All non-static, set data related
> attributes could be move to the "data" as well, like nelems, ndeact.) But
> it'd mean a serious redesign.

refcounting on object is needed to detect deletion of chains that are
still in used, rule refer to chains either via direct jump/goto or via
verdict map. When handling the transaction batch is needed to know
what can be deleted or not.
