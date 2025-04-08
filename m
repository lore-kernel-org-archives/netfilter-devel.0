Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C38E219301
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Apr 2025 11:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112485; cv=none; b=Q0nTNZdIv6fNeUrkn387RuKQjVPG8UH8jcImyCuiwFJMlBXoFCAnmQb0lZC1ExQuwXDV5U3oTJOXwEsG/XqUO3mlAxCH2Fj00/pqMdQUFIWv5kymD/MjH8ZvgcnNZde3garjXWA4pAWd6803RwvfJgxc4x+E8ONFwRkN+EgbVfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112485; c=relaxed/simple;
	bh=8FO9AaxXXzq/bri3bPkXdtUffaaGbKUT2Grzmn9zBog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DD2sy9hp/ddNfgINjA3hr8K9ZxcGV6X55K/t/w0Hhg7YARH1mr5uefIhxbe2vCZhQ92z+Nn/wd2umk/Q34QlwkXiE2emxTL61anzfjz7iEusD614TGViR9sj01NCKNR+YKdsYRRX4hXIM/wMm57rUPGBNh52fI+jigRFdGXdC8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vBcnhBfd; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=hpDiP+hS; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vBcnhBfd";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="hpDiP+hS"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 02CB1603B3; Tue,  8 Apr 2025 13:41:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744112478;
	bh=YIyCQ76i6eZx8L09It0eD1ozeA4HRToA8/NyfKCOpoA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vBcnhBfdBShOA+h42DGH5XZxV5mRgjaYrwDTsdKkPu3nCMFswZNHMWiKVvzB2v/GT
	 tlloTCSsxBUA1ow3LHVlDQ95SeRzycycYJzmX6ywRNII4AUGVgiJl1xr/xbUFCJECY
	 1Oep7zpbV38eHvgq5kwcZ5dZRo8yfe7ZhV9b73dGiviwQCMjqZlOYutdvRQSOHhHQD
	 aebppghAIi3py7GFzBU2ORSKdHFsu4nXJWTJDV6DKOzacwnq+Lq60VT1PwPAuGpILw
	 HvM6J2YJQH/HOojn7rJGiObukjIwOE+8v5W8I9tWNLcHX3HLsMBc1X2HM3eIakR/Qx
	 fnoSQmxORnBcA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0BA9560253;
	Tue,  8 Apr 2025 13:41:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744112477;
	bh=YIyCQ76i6eZx8L09It0eD1ozeA4HRToA8/NyfKCOpoA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hpDiP+hSfO/nb+t9EfchsTAfaKbAh4AWphSkXw3NoobZYn8J4E7GO5rNvE1uzmNVT
	 ASieuWawXx3SrXwVXRAM/uGoqyo7Okhzoua0cZ+B2topsv8BQGdamhasMC5TEMrFhh
	 8Wx4dEbQ18cDaPk6RsW2jnqRSrS/rcLr12RFqhnlE2kDZ3gh+yBwe6lJKmD3Gf3lsJ
	 eDE+qh/tAWob80NGIi2hWa+6bEX+1AykhC2SiJZg98HpgGtn8rOC1IpdFQ//n8/Woh
	 mF+8PTJLn6RnpLI47IrwDzpXlAr8vw2ukH6sW96QASwczEX14pawVwXrgXBweVkH99
	 mvPPkq40xii+w==
Date: Tue, 8 Apr 2025 13:41:14 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Stefano Brivio <sbrivio@redhat.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v3 nf 3/3] nft_set_pipapo: add avx register usage
 tracking for NET_DEBUG builds
Message-ID: <Z_ULWpqOzR1mdt7C@calendula>
References: <20250407174048.21272-1-fw@strlen.de>
 <20250407174048.21272-4-fw@strlen.de>
 <20250408092949.1afdee61@elisabeth>
 <20250408095508.GA536@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250408095508.GA536@breakpoint.cc>

On Tue, Apr 08, 2025 at 11:55:08AM +0200, Florian Westphal wrote:
> Stefano Brivio <sbrivio@redhat.com> wrote:
> > I wonder, by the way, if 1/3 and 2/3 shouldn't be applied meanwhile
> > (perhaps that was the reason for moving this at the end...?).
> 
> Yes, that was one of the reasons.
> 
> Pablo, I will resend this patch later, targeting nf-next.
> I will not resend patches 1 and 2.

OK; then patch 1 and 2 for nf.git and 3 for nf-next.git.

> > Otherwise it's a bit difficult (for me at least) to understand how this
> > macro should be used (without following the whole path). Alternatively,
> > a comment could also fix that I guess.
> 
> I prefer better variable name to comments.
> 
> > Everything else looks good to me, thanks for all the improvements!
> 
> Thanks for reviewing.  I will wait for patches 1 and 2
> to make it to nf, then for nf->nf-next resync and will
> then resend this with all of your change requests included.

OK.
