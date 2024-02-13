Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5DA2C696
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Feb 2024 11:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707822572; cv=none; b=Kb9nJvdX04lpkQt7lLaawmEczJLSP5IJVV9Qyx6x7CGDqLkY8ifaFSmRgI8+wowfueyt7ibJMAMU7bgBCQVZo37VhJtZbt6nZnAqEEm82FLwhe0V57v4UwN9WtH8vadK/yUigjMqgrrW2pvicXODrt+7PKP596CCtX5TpKrfWvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707822572; c=relaxed/simple;
	bh=HDispnH19owpY3w38E0cR5pQ3cvomfFfYSEu0s9ASo4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G/xYuzK2ZoEil5l9MbcwQGl+Mig0T6m8/jBKhQCkFFK7baJfF9qajEpnedQvw2/JgnYpkHKyIgxATKXmSE29IJs9jziiMub6o7V91NgAgJStUe2vshjT9aH1C2io0P4bhY//+HoOzJPFsQCAuAvGgAy/58va+VW15CWM4QBRO20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rZqfB-0007FG-T8; Tue, 13 Feb 2024 12:09:21 +0100
Date: Tue, 13 Feb 2024 12:09:21 +0100
From: Florian Westphal <fw@strlen.de>
To: Stefano Brivio <sbrivio@redhat.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 2/4] netfilter: nft_set_pipapo: do not rely on
 ZERO_SIZE_PTR
Message-ID: <20240213110921.GB5775@breakpoint.cc>
References: <20240212100202.10116-1-fw@strlen.de>
 <20240212100202.10116-3-fw@strlen.de>
 <20240213082007.3f4e689d@elisabeth>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240213082007.3f4e689d@elisabeth>
User-Agent: Mutt/1.10.1 (2018-07-13)

Stefano Brivio <sbrivio@redhat.com> wrote:
> > -	fill_map = kcalloc(m->bsize_max, sizeof(*res_map), GFP_ATOMIC);
> > +	fill_map = kcalloc(m->bsize_max, sizeof(*res_map), GFP_KERNEL);
> 
> I haven't re-checked the whole logic, but can't nft_pipapo_deactivate()
> (hence pipapo_deactivate() and pipapo_get()) be called from the data
> path for some reason?

Not that I know.  Deactivate turns off an element in the next generation
and that concept is tied to the transaction, and that needs the nft
mutex.

> If I recall correctly that's why I used GFP_ATOMIC here, but I'm not
> sure anymore and I guess you know better.

I'll have a look at original version to see if there was a reason
for this, if so I'll update commit message or move this to its own
change.

> > +		if (src->rules > 0) {
> > +			dst->mt = kvmalloc_array(src->rules, sizeof(*src->mt), GFP_KERNEL);
> 
> Nit: equally readable within 80 columns:
> 
> 			dst->mt = kvmalloc_array(src->rules, sizeof(*src->mt),
> 						 GFP_KERNEL);

OK. I'll reformat.
