Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A9622094
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2024 13:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720617617; cv=none; b=t5KqamuflQ5fctKO+V0kZWpVMI6brLmNSSjRUauBzmgKlA8RFraedxJisz43FoxH4jh9jyXu1JkyjseQcNV/2QnsCIfoM8+nfLVtX8RkhMCq+2BTZuLrpeV3iGBKy+exLStxHsZbiTqJazQKgcVsvfq0lC7SFWZNphpzdGTthhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720617617; c=relaxed/simple;
	bh=4MYJnv/RwEPMk58wdEe3bPMwSe3tGhlkFs+nfglPF94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p23GpNm0H2PuPh4qTqWVJ/k2m/EGhjvTA0gNXNy8XGX5mcCylMlm2mzxZgtbTCH61VDEsuqhitFUQGkAaXUr683wmVh56CjXfTbHMt6zeEt6r7T5nfENXN6bZYY8qOjoHGf+UqeQR6ofTvFaPB1jmqwg6dT7akv9qcdmuG+hvCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Wq7Vg15Y; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Wq7Vg15Y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+h86FOGlKS+NxGrG/xK6lo/VlmQDl0eqhQ1lbg32xLA=; b=Wq7Vg15YRbO+H/kcdbMNe2sj7o
	8eW97U7sQ1nyvUdcSO8wQqVaH+eRu+yjs9GNKkavu9lXfwEI/VMOu9I0qhoQUuaRo8NYJgLTOQ96h
	D3Rab/QmjelXEqA6pcff+1zBlAAZNUzIGlu6Mi9dzZzB1DQu8xKimqw6rW65VPfsWWa9dKk4fp+Zg
	Lon39YxvDhu32SDlHEbsJrT99IBxu8blmsZnk6d7Evl0ww4noJb1GNianXm1AL0670Z7N/oIxlsu8
	468GUBXw1fyiSs8q9DIk8grTc5+lKnqQVVdy+R0bfS/A9U7Cxm8/mmYnWHqNJmNR5khJ73L7KMLgh
	Wt6opu8w==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sRXEg-000000005yK-1HBb;
	Wed, 10 Jul 2024 15:19:54 +0200
Date: Wed, 10 Jul 2024 15:19:54 +0200
From: Phil Sutter <phil@nwl.cc>
To: Joshua Lant <joshualant@googlemail.com>
Cc: netfilter-devel@vger.kernel.org, Joshua Lant <joshualant@gmail.com>
Subject: Re: [PATCH] xtables: Fix compilation error with musl-libc
Message-ID: <Zo6KepEjo7IHOpWb@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Joshua Lant <joshualant@googlemail.com>,
	netfilter-devel@vger.kernel.org, Joshua Lant <joshualant@gmail.com>
References: <20240709130545.882519-1-joshualant@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240709130545.882519-1-joshualant@gmail.com>

On Tue, Jul 09, 2024 at 01:05:45PM +0000, Joshua Lant wrote:
> Error compiling with musl-libc:
> The commit hash 810f8568f44f5863c2350a39f4f5c8d60f762958 introduces the
> netinet/ether.h header into xtables.h, which causes an error due to the
> redefinition of the ethhdr struct, defined in linux/if_ether.h and
> netinet/ether.h.
> 
> This is is a known issue with musl-libc, with kernel headers providing
> guards against this happening when glibc is used:
> https://wiki.musl-libc.org/faq (Q: Why am I getting “error: redefinition
> of struct ethhdr/tcphdr/etc”?)
> 
> The only value used from netinet/ether.h is ETH_ALEN, which is already set
> manually in libxtables/xtables.c. Move this definition to the header and
> eliminate the inclusion of netinet/if_ether.h.

Man, this crap keeps popping up. Last time we "fixed" it was in commit
0e7cf0ad306cd ("Revert "fix build for missing ETH_ALEN definition"").
There, including netinet/ether.h was OK. Now it's problematic?
Interestingly, linux/if_ether.h has this:

| /* allow libcs like musl to deactivate this, glibc does not implement this. */
| #ifndef __UAPI_DEF_ETHHDR
| #define __UAPI_DEF_ETHHDR               1
| #endif

So it's not like the other party is ignoring musl's needs. Does adding
-D__UAPI_DEF_ETHHDR=0 fix the build? Should we maybe add a configure
option for this instead of shooting the moving target?

Cheers, Phil
