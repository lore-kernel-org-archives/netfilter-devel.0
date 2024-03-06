Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76046605C6
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Mar 2024 15:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709739732; cv=none; b=a8vh7dgpuX+LvH1521hMC57ddONdvBx0RiQRuy+zIVW3vKjSZel7hPjYT5hb3RT/q2BbcQ2QFaREmsw2BrxiHQpQmo2SEjLaPA7GME0B3RrmiSclgjkT7x6oZXkC+xGQK0Rmp4IMxPSejtlermVBRIKb0fUhIiIFeZWnX1YnFQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709739732; c=relaxed/simple;
	bh=0HlUAl/aC0K2jLFsm3436/3Kl9JFn1VQdegYLrxuij0=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hZzCZE7x/WxBv0T1GdApel9qEpGb3GktilUAllo/M6Mme5duAfpzrmMFKqFm25qsjkA0kYsLCWizfxLud3i7cQkKQJoSCuK/o8JMhc17X/sUHtJVsX11hq7mOZMVjN8oi0eaet9pPzFXzUKxcTtgNwD7z7NsX8QePJYlPEXIBOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rhtPD-0007va-Hx; Wed, 06 Mar 2024 16:42:07 +0100
Date: Wed, 6 Mar 2024 16:42:07 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH xtables-nft v2] extensions: xt_socket: add txlate support
 for socket match
Message-ID: <20240306154207.GD4420@breakpoint.cc>
References: <20240306101132.55075-1-fw@strlen.de>
 <ZeiDKkam7FXpCbiU@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZeiDKkam7FXpCbiU@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> On Wed, Mar 06, 2024 at 11:11:25AM +0100, Florian Westphal wrote:
> > +static int socket_mt_xlate(struct xt_xlate *xl, const struct xt_xlate_mt_params *params)
> > +{
> > +	const struct xt_socket_mtinfo3 *info = (const void *)params->match->data;
> > +	const char *space = "";
> 
> The whole "leading space or not" handling is not necessary, I made
> xt_xlate_add() insert leading space automatically if the first
> character is alpha-numeric or a brace.

Perfect, I'll push this out after removing the extra handling.
