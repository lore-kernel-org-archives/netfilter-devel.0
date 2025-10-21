Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37FD222565
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Oct 2025 10:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761043554; cv=none; b=D0ii9rZjMm8Uj2cXJwkrEGEFw0KOIafEwZw9y4i2Q7FfKytjrr3KcHNQqxgjpZhlqyEXV2F+mtp8o1gMKab3ILL3NzNNfWhHlSvV7wsy3RBzO+/KJDI3J42kgLDTJ8ZqoWAaBYX8d9V6D8xpIEB5CB+hAOYfJu1rD/kpuM6Tjlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761043554; c=relaxed/simple;
	bh=RcRhb954aCNZQ4ImS1ZbBkQIU05WBVPrbJAx7c3Rp4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K10u0SV4LTWSEarbZgqr5GgvlwMdxJSFDI/gXsPSWnJ5DKE9jEfRtsMDn6Q6rDTAI1Ru91sw0gk/wgxFbc+F8NdWGtubY4kBjqZZDDTL7BeoHc87d1/XQ7WlkufUKB4K1xhlLuoY8jSQOuc9UASbAqhmJiRVkm6Gh4yyPSsH5fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A4081602F8; Tue, 21 Oct 2025 12:45:49 +0200 (CEST)
Date: Tue, 21 Oct 2025 12:45:49 +0200
From: Florian Westphal <fw@strlen.de>
To: Antonio Ojea <aojea@google.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Eric Dumazet <edumazet@google.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] selftests: nft_queue: conntrack expiration requeue
Message-ID: <aPdkVOTuUElaFKZZ@strlen.de>
References: <20251020200805.298670-1-aojea@google.com>
 <aPah2y2pdhIjwHBU@strlen.de>
 <CAAdXToT14bjkvCrP=tG4V4XJhhyGMfuJz+FdfTO+xJ10Z-RezA@mail.gmail.com>
 <aPay1RM9jdkEnPbM@strlen.de>
 <CAAdXToQs8wPYyf=GEnNnmGXVTHQM0bkDfHGqVbLhber04AyM_w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAdXToQs8wPYyf=GEnNnmGXVTHQM0bkDfHGqVbLhber04AyM_w@mail.gmail.com>

Antonio Ojea <aojea@google.com> wrote:
> ct mark 0x66000000 ct state established,related accept
> queue flags bypass to 98
> 
> So I just need to set the mark/label on the verdict and clear the mark
> or the label via netlink and it gets requeued.
> 
> I can make it work with connmark very easily but labels seem a better
> fit because they allow me to set different values and avoid
> compatibility issues.
> However, I'm not able to make this work with labels, I do not know if
> it is a problem on my side, I'm not able to use the userspace
> conntrack tool too.
> I think I'm setting the label correctly but the output of conntrack -L
> or conntrack -L -o labels do not show anything.
> If I try to set the label manually it also fails with ENOSPC
> 
> conntrack -U -d 10.244.2.2 --label-add net
> conntrack v1.4.8 (conntrack-tools): Operation failed: No space left on device

No space for the label extension.

Does it start to work for new flows when you add a rule like
'ct label foo'?
