Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61732E7BC2
	for <netfilter-devel@vger.kernel.org>; Sat, 16 Aug 2025 15:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755357344; cv=none; b=M8Mt4VFXDpC2s9F9dyWhWAEzZmtEAuM5mpFpXGNovo4uxwz9cW3lJiFnWNpALeta6XjiMomtByM5Egk3dbXXAx0Po/rZ8+0XjD2vtQjBpfoZc8O0jDJFeeDZx8wZZMXsuMkRMeYs6rU+Iu3AtAJ8VM7BBRPnjVY52SNh47oyUE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755357344; c=relaxed/simple;
	bh=8IYsM4EILd53dfEPfPa/qfafV89m4hwWLOpmIIiT5iA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BN7j0ByuNZREZonQOnkvaao3EvmTNQva53SRpnXUWXN3X9KYjBHHz79djQ31c28LpJjStwk75bHpy1y4tlWtjcKkS9zhsnGBF6QGV6brRhlwvgf69JU/oNOBguhGCqTPjOIN25m9xCmTGmg7pEMEhaJ2EF1zqhOi2MHwLD+koTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id EC7BE605B5; Sat, 16 Aug 2025 17:15:40 +0200 (CEST)
Date: Sat, 16 Aug 2025 17:15:40 +0200
From: Florian Westphal <fw@strlen.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH nf-next v2 0/3] netfilter: nft_set_pipapo: Use nested-BH
 locking for nft_pipapo_scratch
Message-ID: <aKCgnJGbYIfkVVJu@strlen.de>
References: <20250815160937.1192748-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250815160937.1192748-1-bigeasy@linutronix.de>

Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> The pipapo set type uses a per-CPU scratch buffer which is protected
> only by disabling BH. This series reworks the scratch buffer handling and
> adds nested-BH locking which is only used on PREEMPT_RT.
> 
> v1…v2: https://lore.kernel.org/all/20250701221304.3846333-1-bigeasy@linutronix.de
>     - rebase on top of nf-next.

FTR, I placed the first two patches in nf-next:testing.
