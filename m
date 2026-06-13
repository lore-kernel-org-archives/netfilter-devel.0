Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02676334C3C
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Jun 2026 22:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781389555; cv=none; b=OREBc6gaRl8w+pqmYlCyz39vj9lf/ztsNVBrnuBzL8EnKgVpojA0r7nr9HIO9knTR5QI3NqugsQ/+Xxt57aOeLn906UdGUfk/ZOEVAJhi3Fs7Ort4RYdFsKlsuB5TyGAUYy5N0bxwHAkCKzTppuCnrowAuB3jYS3HdXqbQfnC6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781389555; c=relaxed/simple;
	bh=pnjrow4jrFtMhlk6TR2/PbnPUXexJ2jsoP4UnrA6jLg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iPGqQKCzS7sqVOWPL+VfSBS4Orxri1hHeiiYNquRaMgFyrAIc2SkVvjANL8pff236SR2PyAhxxLszjmRS4ZF1SRnDUy+UJNheAbOi3bxzjgnK+QEYba9Wcc0nSDw+16qfCDx4ObL9serhSx+kuejp9fIpNxtTnZMHtjlfQNbni0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 205CC605EE; Sun, 14 Jun 2026 00:25:52 +0200 (CEST)
Date: Sun, 14 Jun 2026 00:25:47 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Ren Wei <n05ec@lzu.edu.cn>, netfilter-devel@vger.kernel.org,
	phil@nwl.cc, yuantan098@gmail.com, yifanwucs@gmail.com,
	tomapufckgml@gmail.com, zcliangcn@gmail.com, bird@lzu.edu.cn,
	bronzed_45_vested@icloud.com
Subject: Re: [PATCH nf 1/1] netfilter: xt_nat: reject unsupported target
 families
Message-ID: <ai3Y68Fqd-V3cpOS@strlen.de>
References: <cover.1781144570.git.bronzed_45_vested@icloud.com>
 <5722ce33544cc22da3f811de77ab57847eb58366.1781144570.git.bronzed_45_vested@icloud.com>
 <ai3MJ2P2MnXLxcmb@strlen.de>
 <ai3TGFyMlkS1m8O3@strlen.de>
 <ai3WcsS00Rbjy61u@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ai3WcsS00Rbjy61u@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > We can only use NFPROTO_BRIDGE targets, never UNSPEC, for NF_BRIDGE
> > caller.
> 
> Maybe it is simply this patch:
> 
> commit b6fe26f86a1649f84e057f3f15605b08eda15497
> Author: Pablo Neira Ayuso <pablo@netfilter.org>
> Date:   Wed Apr 15 12:21:00 2026 +0200
>  
>     netfilter: xtables: restrict several matches to inet family
> 
> which was missing xt_nat.c?

No, ebtables targets are incompatible, they return different
values compared to ip/ip6tables.

We need a nft_target_bridge_validate (or alternative method) that
rejects all targets that are not NFPROTO_BRIDGE.

This is wnat ebtables.c already does which is why this poc would
not work for classic xtables.

That said, this patch (the xt_nat.c patch) might be a good idea
anyway, but I don't think its enough.
