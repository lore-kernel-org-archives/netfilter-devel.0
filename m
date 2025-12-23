Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA5F36C0C4;
	Tue, 23 Dec 2025 10:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766484754; cv=none; b=pV6V5c+SyGurAiIy6iAco6IiiXSAedR2Iint6SI755rZ7mNoabIIBVeiZbECyAnt+q5waNw3XoK6ifDUFO5f+UJ+cUVjJ7u3J8QQBokzPHIqpX0duIcWlSjwlKCWIDC9H4bMCYF/XjKwYqZ8Lg+AbRpY8prB8teU0xnoPwyCJGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766484754; c=relaxed/simple;
	bh=l7uVr6hxNal7FdWWLigFdjoCDJUOAYZPCJpwh41HyS4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sCT7XnLbFYGBCgV52f/lWR+XE2+K8h03gjnEfK14CYvwjEHLbU3Gv0tQ6qLQQcOPMC9SrlnVe6a6nNCQA3CIsW8P9dSfco0OKyBW0ZV0a45s+cF5WwyKcY9mJr3ssr3NrX9NW20NetZAxBksQEp81oIW1fgatm6MrfTPFJyVDa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id EEBC86024F; Tue, 23 Dec 2025 11:12:24 +0100 (CET)
Date: Tue, 23 Dec 2025 11:12:23 +0100
From: Florian Westphal <fw@strlen.de>
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: Re: [PATCH AUTOSEL 6.18-6.6] netfilter: nf_tables: avoid chain
 re-validation if possible
Message-ID: <aUprB84-pTouDuac@strlen.de>
References: <20251223100518.2383364-1-sashal@kernel.org>
 <20251223100518.2383364-2-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251223100518.2383364-2-sashal@kernel.org>

Sasha Levin <sashal@kernel.org> wrote:
> +	if (WARN_ON_ONCE(!nft_is_base_chain(ctx->chain)))
> +		return false;

This WARN will fire unless you also pick up
a67fd55f6a09 ("netfilter: nf_tables: remove redundant chain validation on register store")

Alternatively, drop the WARN: "if (!nft_is_base_chain...".
