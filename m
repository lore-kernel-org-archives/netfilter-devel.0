Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5747255F3F
	for <netfilter-devel@vger.kernel.org>; Tue, 20 May 2025 10:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747737028; cv=none; b=eB3XeuhqxP7xteVTVtr9fl4jYb3ZJjx4FqtEmV93vU6LSTG9t99gXATh0IhPBmxqPJQXYCY9YScKvFUeZGHWODLe7tS1QtK8icl8tg7zlqkeC0aLk0kxlw0tjSimbAD0/SmZcPfOYDT10l1C6PsWpG90dvDmQcYS/Wblp/o9o2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747737028; c=relaxed/simple;
	bh=bj8djwkx798hDy4HV0SSqwU80tBn17A/gnot4I8XifQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dkypnPPNvVEfEACSKhzjJ+Q3UjYIDRZTB8Hn1X1RiJEpidrfPxk4B1MG3di6YmeKBKOLOydlKBhJUYTMDMrqSEFWpvpqFA8Mk+wJ3W17/zaoH/J0133N8qS5P4oQL9jlpnXdJkwUrc0DBxIkeo0Ls6btqpoDmBeoJnA4zoxkYv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3724A6014F; Tue, 20 May 2025 12:30:24 +0200 (CEST)
Date: Tue, 20 May 2025 12:29:31 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next,v2 1/2] netfilter: nf_tables: honor EINTR in
 ruleset validation from commit/abort path
Message-ID: <aCxZi2f6gqj8YNfP@strlen.de>
References: <20250520092029.190588-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250520092029.190588-1-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Do not return EAGAIN to replay the transaction if table validation
> reports EINTR. Abort the transaction and report EINTR error instead.

Acked-by: Florian Westphal <fw@strlen.de>
