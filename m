Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A7A22A808
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Jul 2025 22:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753394801; cv=none; b=hhPlEa5ivoTQKqm3M+1h/zSSXcUb4JwOJP/bgWY+9xd39lPuvkPswc5M63Kb1vUJZ8v77+dfruFVHMAsFwLbOLIlTiwLa/KPu92UJW2Krv6mxa4XXJf1eHkLMlcyTZ66N+j0CRBIJiWVyAlh93J7xmhSHVsMwY1U2mZL/ufk8ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753394801; c=relaxed/simple;
	bh=V0peJ6URUvypiKYqOVDJDVn6YD+1dTgKcg/FUhtRQ+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rkg52wi8llxPi1AoVInTGIcQpb0PmKCrpI1yUCbrV0TBAIPsiHo4Nezz5nME+qgOJ+iDB+b48DLcaN83khG/lNIKJsQnl5TEHTtvGRnosrpQnuvKMfjvY4cJQyHOKzUiuXcMqkZ2Kv4cnHl0t54N9GyTPUuHiaspdvM9A6DIksk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 44DE96048A; Fri, 25 Jul 2025 00:06:37 +0200 (CEST)
Date: Fri, 25 Jul 2025 00:06:36 +0200
From: Florian Westphal <fw@strlen.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH nf-next 0/3] netfilter: nft_set_pipapo: Use nested-BH
 locking for nft_pipapo_scratch
Message-ID: <aIKubJyzokB9-_rx@strlen.de>
References: <20250701221304.3846333-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250701221304.3846333-1-bigeasy@linutronix.de>

Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> The pipapo set type uses a per-CPU scratch buffer which is protected
> only by disabling BH. This series reworks the scratch buffer handlingand
> adds nested-BH locking which is only used on PREEMPT_RT.
> 
> This series requires a reworked __local_lock_nested_bh() which can be
> pulled in via
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git local-lock-for-net

Whats your plan here?  This commit is neither in nf-next nor net-next,
so applying your series breaks the build.

Which trees do you intend your series to go through?
