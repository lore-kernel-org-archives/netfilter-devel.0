Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0197747F793
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Oct 2026 11:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791372596; cv=none; b=VcVR++9CQER5g8APKsgWZOk6w43//nnXj11HJhtddmttIIoQBFbdChbQlad1TpfiIAH/q89VLBmJYz9v/0C8nWV3y++gsnc5LJQ+kxuvZVvCcVSHyowXL8TqSgNlhWPb+RX4KzJlE/bDyaT3iiWytYzuwJ1B6qu0S9S06ZfH6ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791372596; c=relaxed/simple;
	bh=wtZtW4YPnvz8ltpWWDPh2ylYzsOo2CWu1cnY98wqjaA=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k6FW0qJ2DW5ICIb0gQgfW1Rs/stoQVWpPu3OAwR/WzvpNtWk4FXXlN9oRwI4wCsW/OkOeCJ4UJ46XqozlUt+i1PeyeWAWRiINCj0sKwj+nOe74gtb5DYlc1s9CzdncEfd0J2tKJbK6Udh/t2c8rGFBKfTsSGyqa+DuIZ7YseMt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 439A26038C; Wed, 07 Oct 2026 13:29:37 +0200 (CEST)
Date: Wed, 7 Oct 2026 13:29:36 +0200
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nft_compat: restrict raw table
 targets/matches
Message-ID: <asYtIDf01NCIlOLf@strlen.de>
References: <20261006231549.5901-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006231549.5901-1-fw@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> xt targets and matches declaring .table = "raw" (CT, NOTRACK) rely on
> only ever running in the legacy raw table's prerouting/output chains,
> ahead of conntrack. nft_compat_chain_validate_dependency() already
> enforces this kind of correspondence for "nat" by requiring the chain
> type to actually be NAT, but did nothing for "raw": a rule wrapping
> the CT target could be loaded into any hook and any priority via
> nft_compat, including after the real conntrack hook has already run.
> 
> The CT target attaches a conntrack template to the skb when none is
> set yet.
>
> Require that a "raw" table dependency actually matches what xtables
> enforces via the implict/builtin table dependency.

https://sashiko.dev/#/patchset/20261006231549.5901-1-fw%40strlen.de

| Does this strict equality check reject legitimate pre-defragmentation
| priorities?

I don't think so.  While its technically allowed, iptables-nft doesn't
support NF_IP_PRI_RAW_BEFORE_DEFRAG / NF_IP6_PRI_RAW_BEFORE_DEFRAG.

| If users recreate this state in nftables by creating a base chain at priority
| -450 and attach the xt_CT target via nft_compat, it seems this check would
| unintentionally reject NF_IP_PRI_RAW_BEFORE_DEFRAG and return -EINVAL.

I don't think that makes sense.  Native nft users would not use
nft_compat.

But if you prefer, I can relax this check to use ">" instead.
