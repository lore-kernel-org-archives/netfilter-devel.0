Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7242E62B4;
	Wed, 20 Aug 2025 16:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755705682; cv=none; b=rGUMT8hUSmPjEE5CXkdFLeyeoJYJ4scudwxsY5H0AR9obZwl+K+q7TGNgko62K2vx4B0azgxBQ5iRQbuS1NKGaHwHElRiY6yrRYOSKy86w2og24n9Iz+/JhSMoVB3JLl/9bgQHHToE7IwirlTtquuhzQvqeKPeAtMgJNQy1Lbd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755705682; c=relaxed/simple;
	bh=wpY5/xr0Or/2wJ0S0TufDbrIupEsqisK4z2vqka6EOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FQRUL1DBhZWJHh4LSIdrhVbe8IZGeEtooq3fIlQvr8xR1CzGUp5e6wDwbgIaIW3/YUf7VJ0Xcfd4ix8erv9bYA5HMZc1g8/pv3nAzlJRJaP+pvXEnwgA0cmQLZoHvxo+yLjyq32RVhk/2+z/ToRNiXWr7RvRf7HNEPlYWLG5S+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=fRr4xsLl; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=NcFeJ7nv; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="fRr4xsLl";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="NcFeJ7nv"
Date: Wed, 20 Aug 2025 18:01:14 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1755705676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kKUzIIiQ88EZtHaua0or7dWZ09bA6MxiSU3FX1Da/Ow=;
	b=fRr4xsLlR/uNZOKRQ3RU/O8fwZNkHT1Ne++39yHepmkwpyQJ3TcLxfj4rlutD2LxQ9HI97
	c7v1Ymrm7NKtidUzC6aDew/2hWVTXAl4iweqLuftvNul3eOJ1u62Ju77HrcxEwsNy4p7/h
	dtXevpnlMe01jKZoIn+4i9JByCOvazcZXdyeAjmfAswzCVc0S+Vh4ug6VXh1IB5AvZTD+2
	tK4dOhyk3Z2+VtNtBIjJmDSgk9HApLhvm0n9q2bt9ysvhX7JUizxQZnUIH3o5iTXepD3nY
	DAhFqY8N58WDrph25T3V1pAyxXwkGgJKvnrdGGPrcskMs8YZ3Bs7WCIRrxCanw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1755705676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kKUzIIiQ88EZtHaua0or7dWZ09bA6MxiSU3FX1Da/Ow=;
	b=NcFeJ7nvBRJ5IMYCH6L/yzDaDPdHpy7Ph7FMugBL/tpvDK9/6uMA2G2+7PqGBLIB+/lTXd
	OMojDG/e1e5dM/AQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Stefano Brivio <sbrivio@redhat.com>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH net-next 5/6] netfilter: nft_set_pipapo: Store real
 pointer, adjust later.
Message-ID: <20250820160114.LI90UJWx@linutronix.de>
References: <20250820144738.24250-1-fw@strlen.de>
 <20250820144738.24250-6-fw@strlen.de>
 <20250820174401.5addbfc1@elisabeth>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250820174401.5addbfc1@elisabeth>

On 2025-08-20 17:44:01 [+0200], Stefano Brivio wrote:
> On Wed, 20 Aug 2025 16:47:37 +0200
> Florian Westphal <fw@strlen.de> wrote:
> 
> > From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > 
> > The struct nft_pipapo_scratch is allocated, then aligned to the required
> > alignment and difference (in bytes) is then saved in align_off. The
> > aligned pointer is used later.
> > While this works, it gets complicated with all the extra checks if
> > all member before map are larger than the required alignment.
> > 
> > Instead of saving the aligned pointer, just save the returned pointer
> > and align the map pointer in nft_pipapo_lookup() before using it. The
> > alignment later on shouldn't be that expensive.
> 
> The cost of doing the alignment later was the very reason why I added
> this whole dance in the first place though. Did you check packet
> matching rates before and after this?

how? There was something under selftest which I used to ensure it still
works.
On x86 it should be two additional opcodes (and + lea) and that might be
interleaved. Do you remember a rule of thumb of your improvement?
As far as I remember the alignment code expects that the "hole" at the
begin does not exceed a certain size and the lock there exceeds it.

Sebastian
