Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8221376BF2;
	Wed,  7 Oct 2026 22:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791411562; cv=none; b=ELg4mOy9WVvzneNHWneopnKBsIONuJNnaiRMARKkv03ygKJlN0pJTC0dZ7xM3tmg287AaBG2JkEeu86cerZK7QM3eb2aAUt85FtFOmZjbtbccbZ6GLAMO6CrL7yOpAj4Nofh3v2hI+Gh5VqA5ouGUEHOjM5aBizm7RgU8ZHvC9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791411562; c=relaxed/simple;
	bh=1TYk2LTDQNIu0X4PFF2bx0a2fLDunpsigFQO+YnUcuw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XF3jARK5gbFYmmnV66SHy9CzRlW/Q+HUTO7k8zUCjm2bM2sKIDpzV9/W4Y6kkmT06sL8hImnFB3UkwraeiGcyha3x7IUwEdAfBm3Ds6Nh3eCbeXOiEyCO2SRjSS0kfGWGqPhUQdaZjIc9OOVl3mCJSWL0GAdgTMbTbbquNXV5M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gQBZzN5R; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gQBZzN5R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791411558;
	bh=wJPX2OeTNwA3f1MhX5h7+TMB/ObQzIELfiRuBoJuB78=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gQBZzN5R/cHZwYij6q0hJD52N5JpZTofqYYS4xY5tUUGnQljzR0nJRNijaBgJVK2Y
	 4HYrgoijbXBaZwmtzdwCyYzXmYWgV5v7C1212pvmXUJn79YySi4oPqRvbTvdcdBtpx
	 OhlvCQdVn3BXZScAay71Y9zzIejDGzMpJElN10hLHDaANfQ/mFpRhsLFQJEU2KyMHV
	 0Ia/+JLr2H3Ab9FzsF/bSSIHgpwvKS2tLUGq3oEXOJVHv4o7gJOxFwqvQILCM/R63U
	 lj/LfovkGxYIdif4REY/kLjRcwZs+GVl+RWX8ZCho/9LA9WndXGQv62TiiuhwscFtR
	 qBx3iAUeNosQA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 7EAEA6005F;
	Thu,  8 Oct 2026 00:19:18 +0200 (CEST)
Date: Thu, 8 Oct 2026 00:19:15 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: =?utf-8?B?SsOpcsOpbXk=?= Jean <jeremy.jean@oss.cyber.gouv.fr>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_set_rbtree: reject expired interval
 ends
Message-ID: <asbFYylvsv50kA3T@chamomile>
References: <20261005200404.3544062-2-Jeremy.Jean@oss.cyber.gouv.fr>
 <asQtPfgYhK1uxMpR@chamomile>
 <9a9f2587b7bd37c8d03d0105cf968b25@oss.cyber.gouv.fr>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9a9f2587b7bd37c8d03d0105cf968b25@oss.cyber.gouv.fr>

On Tue, Oct 06, 2026 at 03:17:06PM +0200, Jérémy Jean wrote:
> On 2026-10-06 01:05, Pablo Neira Ayuso wrote:
[...]
> > Can you test this fix instead? Thanks
> 
> Hello Pablo,
> 
> Thanks for this improved fix. I replayed the reproducer I had that triggers
> the
> bug on the kernel that includes your patch, and I confirm that it fixes the
> UAF.

Thanks for testing, I posted a patch for submission here:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20261007220358.1140284-1-pablo@netfilter.org/
