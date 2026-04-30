Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6869D25A2A4
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2026 11:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777549615; cv=none; b=jyTAyOb1bkFt5HO99NhuJn9gBHkk3S1pDHzNZ5EuSOfnIyVp1b5Dv0sBzkzhaKVhyEZUH2SSjeStI3D2iqEMipYmoiovjzzvdbniUNxSbSU8DXGwZUbB9uFN1BKerN0g+xlx5UByLZDYQ7AUZKwutu954KwvHn7u/2x3NOlqMxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777549615; c=relaxed/simple;
	bh=UuUmGDLXY5vET4/tEhRxCavGwPNo2i2KQeenfOcMep0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Aa7CjPjyv+UJoVw+b+sSWDtsO/4241Am0xclBuDoyqUyFIqDyGj4YXHW7Zzy6Lm1GtMlQEsFlpANaY40ZvPLAc8+oYlCjnbZOY/S4YgUyATdoKYWL//UMVAeCrLvm0N/WIXhDpKUaYTgxLLRkGaIRgns+SisSODmPofp2n6Zr0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tUjTboDJ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tUjTboDJ"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 74A1D600B9;
	Thu, 30 Apr 2026 13:46:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777549611;
	bh=7sn6qrP0dmfFQp7zsYVRU236/XLfwSmCtJzpA7B6Z8I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tUjTboDJWCH/F2M88myMrJYOsc4hQaP7gbqdbeoFNxRUsqP0Nry8CvXL4NGfe3fNT
	 IrpshrCFVtTpdR5Q7ZrAbiNVUy8UKnufI+Y55hYO2fvIRamqIIs2qnr16+5GKjLL58
	 by8XivTAaGbYMJbsoubnR4gEYzUQbIFFQKnt29VtaAtm+wyXMepxdPlTXX+sYm5dao
	 DWX5sOVAuh9f63zUM7P6EcMuW5ssdDoIyTeF/q+Drrtv5S71ru6okdpULps4RfPcKr
	 n0IeMWM1K2Gcm0bmsgWj+28/m0CwGTP9VYa0C+2KYxyEF7+mS7FmYVt9SFqRuR2LNw
	 5Wx1RwbT4EQqw==
Date: Thu, 30 Apr 2026 13:46:49 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	jeremy@azazel.net, phil@nwl.cc
Subject: Re: [PATCH nf v4] netfilter: nft_bitwise: fix dst corruption in same
 register shifts
Message-ID: <afNBKf1YJYKG14_c@chamomile>
References: <20260427092117.4160-2-fmancera@suse.de>
 <afLye0knzKl5IdrY@chamomile>
 <afL2FYLNtqESyEPh@chamomile>
 <afL66Hdt560a2EgL@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <afL66Hdt560a2EgL@strlen.de>

On Thu, Apr 30, 2026 at 08:47:10AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > And probably nft_byteorder needs something similar to check for
> > partial overlaps too for sreg and dreg. Also nft_lookup.
> 
> nft_lookup might be fine.  Key could be larger than result, and vice
> versa.  Userspace could be chaining lookups too.  I think we should not
> restrict nft_lookup.

Agreed.
