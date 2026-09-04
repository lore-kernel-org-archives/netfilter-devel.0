Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6675331EA0;
	Fri,  4 Sep 2026 19:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788550179; cv=none; b=fHzj3fOYrAmdgOTClV2H6dqKnThrSkg2uf0vik8dDVAdK4VMWOZZpJNCWS0Z31doFokRoTMJz1nOKFlvogw7Tnh4nzY91tF4GqoArraAETo5mATsE14UXrfJx2C5Dpw/DeyEZ9oDGvAOFNTp2kUJj3wXRTSbgY26tufFEmEdpIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788550179; c=relaxed/simple;
	bh=LXuT+KvDErlgqjwov+defm8yySVajKvBW5wKnTughrI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PW9SJyDp4hQTKzIBhnTCX/xp1l3nJyo+sriPl3fMq/B37m7eNEJzpZhuNITtry0jYleP7TesxF9UqoymfW0uW+LX8670nljUlZrZTV3OTwcJnVkPcypc8+UlpkNBdww4vvfk+TnJEU4lK07Ho6O2SoDxvyAfYjTTz++Xx+y/zNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A052C60F6F; Fri, 04 Sep 2026 21:29:35 +0200 (CEST)
Date: Fri, 4 Sep 2026 21:29:34 +0200
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH nf-next v4 01/13] rhashtable: add
 rhashtable_flush_and_free helper
Message-ID: <apscHra03hEkw7ty@strlen.de>
References: <20260904185321.30313-1-fw@strlen.de>
 <20260904185321.30313-2-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904185321.30313-2-fw@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> Will be used by upcoming ipset rhashtable conversion.
> 
> "walk rht with unlink+free" triggers LLM reject pattern:
> "possible softirq CPU stall".
> 
> "walk rht with unlink+free + cond_resched" triggers
> "possibly skipped elements".
> 
> Add a helper to detach current hash backend storage from the
> rhashtable, then iterate and flush all contained elements.

As usual, I'm very incompetent and the patch sucks.

So question is merely if this function/idea is desirable/wanted
in the first place.
