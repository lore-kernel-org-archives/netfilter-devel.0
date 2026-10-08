Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CE643849F
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2026 10:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791456775; cv=none; b=aMqRqdVosERLckaYSBmxJW5XqCXTseCPtQfUSGbgV0/baLJRRs/+v0/O3h1Hkwnol87LCPJL2h1DYBaO9scP8GZVftIrSMjbmFyyXQ4ZyQVo6fluL7Sy52u7+mM2rIL+EXP/1D+RtT0TMVc1X3knrgyIVp9h5qsO0Hy/7J+eHMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791456775; c=relaxed/simple;
	bh=MPYsCXqPGwp5tA+NLIqh1dywBtQzkPYtNxVAl/82/54=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LV8fdtsTT1YLS9HLc2wrfznKRsVVAngf8TRwEkEnDe7RdXMBxuXjHpPB/lHCFNhjpkEhQSfofZnt8KBd3aK9dZqvzMdTQFCn7cKlpwhyG8f7kYKLcvwxCwSvu8GBZzuxnjhkOsyiiCVXc35Bt25wtAWv30aLLpSA1Gr6XWhzzqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NfTeLcAc; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NfTeLcAc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791456771;
	bh=uClmLcbCJ/xnZRIAnWXTCIY0h9Pk9SaNjEwVVWzv0L8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NfTeLcAchYZVd0tnI2y4VUe5exxMFoYg+uE9WFgbiAkSsuM/zKBRyOrOZaVZAuxRy
	 d+vPF4bfJ8dQqMEXROV9anYWaVITffWby2ngn0Xc/HnBkdQlhIiw4x07bT1xmD/y2i
	 eqecVA5M7FuoSHRCsLCrfLVPO0vcUzp+vhFf53YJTPhx98jpOYRoxKi8DvEPZBo6SE
	 byPSkpLeyR+IeP119m2IVLpNgNwaPD7AXrOG23mLiGeKN9a3CsAKo5VNq6v/8NP2X2
	 DyyyCyCzec7e50M3J2yeXt4NWEpGcj5KRidsTZWNFKa++GpwBFIh1fwZ5cwJ0OtPLG
	 hhZCsTlJ9Bemw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id AA00460076;
	Thu,  8 Oct 2026 12:52:51 +0200 (CEST)
Date: Thu, 8 Oct 2026 12:52:49 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Jeremy.Jean@oss.cyber.gouv.fr
Subject: Re: [PATCH nf] netfilter: nft_set_rbtree: narrow down range
 completion to anonymous sets
Message-ID: <asd2AaXSM9oDeich@chamomile>
References: <20261007220358.1140284-1-pablo@netfilter.org>
 <asc5Bsrgv_w7lVOq@strlen.de>
 <asd18Ow3-mYwVQMS@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <asd18Ow3-mYwVQMS@chamomile>

On Thu, Oct 08, 2026 at 12:52:35PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Oct 08, 2026 at 08:32:54AM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > For anonymous sets, when adjacent ranges are found, the end element is
> > > not added to the set to pack the set representation. Use next start
> > > element to complete this interval.
> > > 
> > > Jérémy Jean says:
> > > 
> > > Consider two ranges in a netfilter verdict map:
> > > * keys 10-19 accept packets, and
> > > * keys 30-39 jump to chain 'victim'.
> > > Now, delete the end marker at 20. The lookup array now uses element 30
> > > as the first range's end, so an INTERVAL_END query for key 15 returns
> > > element 30, including its jump verdict and chain pointer. This can make
> > > KASAN reports a UAF after the GC releases reference chain for 30 that
> > > has expired:
> > 
> > Dumb question: How is it possible to remove an element if the map is
> > anonymous?
> 
> I suspect this is a strange combination which cannot be reached from
> userspace.

I mean, via nft.
