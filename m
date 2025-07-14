Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F394B2405F9
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Jul 2025 13:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752501108; cv=none; b=VNJFzP19FBRSE28rT7yvD01ZG2YWLKvINJd0BgO2h04EO3GR8LYMbsHh1GI+qBqEbTDEGNexlrmPN5GpFAn8PWeNA8+949eME+6N8HRLGwHFaseeVooTbNht2US8bxCFtffXVZ/MBLav9AwthYAzRWxd+SRq2Gm1wF+TGl15IN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752501108; c=relaxed/simple;
	bh=pZ+Qlle51pF/228v5CcahEUByAEJy5KiCi1nZC0RtAg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NbhOr4tMp4NT49N4YaieiB6KHp7sIRukJQQvaEr/qNx9nU2kfG8k1vET1x8/cIyDGfgNgWk6y+dzhYnTsZBVz1/Zx5LmSjMiJ0j5yIb8+TQPtQWHFitj801Yz9theiiKJJut/90F9OEqSLCaavAJbSgF/0tMSvNIZ/AejdOK/jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=oFRiocwv; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Oi0/tFFT; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="oFRiocwv";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Oi0/tFFT"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 133BA6026B; Mon, 14 Jul 2025 15:51:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752501104;
	bh=/UC+KyWm4bKsogFvIs3XMPgCaBVN7RcOYyX/70H3e+A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oFRiocwvN9myUXHnyMPMVjfJ76jPsBXeHTRj4Hf2UsUDlFP9GbJj2Oem+LJfBORiS
	 bEUtQasqOn+i9CLToyISwCc/T/+oI8AiVg6Ng6js1frA9kF/yWPWGbs/kRobTg49Un
	 0IlQGHfN56qeVW5y+J1n4l0b6g/vvjkI9oItq3aR36v5vxcBDMZCbQ5qlbZdockbHW
	 UG7yPIETVqAerGSF1WWzuEWwHH/mEWtQoP22y/XIVGmEtLGE07LVJqw417v0wq2R5F
	 QSqv/SiuEELIJex4VfIfQjPjAZwane4x2MusXweftudjKPi8MkQSa4lhEtjkmo59uq
	 ntlKk5QtR8n0Q==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 739AE60255;
	Mon, 14 Jul 2025 15:51:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752501103;
	bh=/UC+KyWm4bKsogFvIs3XMPgCaBVN7RcOYyX/70H3e+A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Oi0/tFFTFTt/g83lM8OuixtEkwgfymvgvr3vAF3h3yqH1SjT/177f5NFg5vv3fqhR
	 p6sAQ9ZFRJt0h3OYfwC9/48oLEx0J90AJUbdwoTqoY8Uvs24Oc5AhmhpvvP8gFs28A
	 yut4cUAci4rdCWo/ZyzT57RjmPEaOxB0GaP2sf4TZX3kLxlhrpfzd3jzBKMkkWNkgs
	 MzKH1UwLCkgUIjsSVu7p5a+b1RPMb+58NySKyo4/G4pKDnqFBIKcu0LXt08ienm3s0
	 6RY+cpe7In+A/yxiSRcm8TAK+qlOiuN1pyzuVcaq9GXuxIWJnSbz31VjVqPQnrEIRG
	 HqBv2SHkju6Yw==
Date: Mon, 14 Jul 2025 15:51:41 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 4/4] netfilter: nf_conntrack: fix crash due to removal
 of uninitialised entry
Message-ID: <aHULbUHBCM4bUw8e@calendula>
References: <20250627142758.25664-1-fw@strlen.de>
 <20250627142758.25664-5-fw@strlen.de>
 <aGaLwPfOwyEFmh7w@calendula>
 <aGaR_xFIrY6pwY2b@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aGaR_xFIrY6pwY2b@strlen.de>

On Thu, Jul 03, 2025 at 04:21:51PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Thanks for the description, this scenario is esoteric.
> > 
> > Is this bug fully reproducible?
> 
> No.  Unicorn.  Only happened once.
> Everything is based off reading the backtrace and vmcore.

I guess this needs a chaos money to trigger this bug. Else, can we try to catch this unicorn again?

I would push 1/4 and 3/4 to nf.git to start with. Unless you are 100% sure this fix is needed.

> > > +	/* IPS_CONFIRMED unset means 'ct not (yet) in hash', conntrack lookups
> > > +	 * skip entries that lack this bit.  This happens when a CPU is looking
> > > +	 * at a stale entry that is being recycled due to SLAB_TYPESAFE_BY_RCU
> > > +	 * or when another CPU encounters this entry right after the insertion
> > > +	 * but before the set-confirm-bit below.
> > > +	 */
> > > +	ct->status |= IPS_CONFIRMED;
> > 
> > My understanding is that this bit setting can still be reordered.
> 
> You mean it could be moved before hlist_add? So this is needed?
> 
> - ct->status |= IPS_CONFIRMED;
> + smp_mb__before_atomic();
> + set_bit(IPS_CONFIRMED_BIT, &ct->status) ?
> 
> I can send a v2 with this change.
