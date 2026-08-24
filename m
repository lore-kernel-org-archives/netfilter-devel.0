Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99EC49364C
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Aug 2026 22:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787611157; cv=none; b=N1Gv+kiYpm+CYuZPuBjQDfZyOV8NaUmb1TpgSgrhHaicA/wXScA2mDhd3x/pXhNSsKxEmBMAdZIkjnCnqbhFE9foDLrGFFbgylCSF2OBBJ4SquxYJEaRyf7gxReFAXFlnaOiBFSm3W1w6mZrbVAkZKtvwtdKDtvoMecHK1fryMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787611157; c=relaxed/simple;
	bh=Kuop7rOafoyWqU+uH4TuTPr91taVuMn1YROASi104N4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N6hWZ2mA8tw5NVnhUQTBW2rc+0an9SJpL0xVeI9Flt/lThfdygur055RiaqX8yB3FuqvQjfCHyNQOQz67x4ZJ9R4xDP398Eft0c5Dn25WDVPN3URNyLknNGZZ0XISByD7S3XKAbh+wTD7LmJ4C0Juq9c5W/m5JxRXDaiMWw7/+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8281460388; Tue, 25 Aug 2026 00:39:13 +0200 (CEST)
Date: Tue, 25 Aug 2026 00:39:11 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: lwtunnel: expose read-only sysctl
 nf_hooks_lwtunnel for non init-netns
Message-ID: <aozID8YV177fIgql@strlen.de>
References: <20260824221902.96694-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824221902.96694-1-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Expose nf_hooks_lwtunnel sysctl with 0444 mode from non init-netns
> instead of 0644, sashiko reports this is exposing a global static branch
> to modification by unprivileged users.

No objection but I find this report weird.  Why is that an issue in the
first place?

> Fixes: a2225e0250c5 ("netfilter: move the sysctl nf_hooks_lwtunnel into the netfilter core")

AFAICS it was exposed before this too, just via conntrack module and not the core.
