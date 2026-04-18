Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695B13264FD;
	Sat, 18 Apr 2026 07:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776499028; cv=none; b=j2wXoFdkUveP9Qn8xxlvKnJMJyBP4gy6DyqlCXzQlryYoF1XVOYQj3oaHWawzBu06IpmtFkCKHskNAbPhkb9qx6azv9yjF84QHKc5vy2UgldocjZfwOTXtZMw0oYeNxrdk+GiTA96ePxVCTnNv9xud5k6pzrqs2rUcA3vV4rjO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776499028; c=relaxed/simple;
	bh=sXZNcQN5qLEfGINhffRofI6HShQsmu52RA/Om0mCraA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O2KRbLMLeS92pBV2MuF5fiiB/IilVr9kIP89ehRsSnI+Npm1BImfYIOnsUTTgKQ5PP06stXEuYFxp/KSVK8ewcoVCkpQLbKukMVyNnE34kYFmU5+jD8JdFBVUaLkpknTO3NiLY2wKxaXdHuhZFc5/RHmpHheaPp+sVUoXUH4VkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ma5lA0yo; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ma5lA0yo"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 857E960177;
	Sat, 18 Apr 2026 09:57:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776499025;
	bh=dxmc6OWY8WPYOEe1da+mGgVbJbb7u1BKfcC7XZPciUo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ma5lA0yoOqMTqGIC1E2NWjFb7lmCCuGS3z5DZxOpU/z0s9dhwNBgykNM9hks+f/nf
	 5qHGxkG16cis0U5np0HnbTBVhxQ922fEvuH8ftuGqEU5jIjEd6ZeZK41hJAjhcavSf
	 WRFjIeP94HphJE8CTyeZgfjLq+Z6fM7zocNZicbgFYZTgOyWIq1+fOpDUTwaFmhkzX
	 Wdhc8FxQ2z41f4sJoUfJ2QUZpIDpaA1Ys/SPdBijDJ+YNYoe7ZRf+ich09KaXlkJSc
	 cqImBABDyJ0AK2p5t6vvAzVfd6+xOmvvDzUPKF0lXaIx4z2EJUJsFCJKZmFIHUQZXm
	 YQjXAllEAatmg==
Date: Sat, 18 Apr 2026 09:57:02 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	coreteam@netfilter.org, fw@strlen.de, phil@nwl.cc
Subject: Re: [PATCH 1/2 nf] netfilter: nfnetlink_osf: fix out-of-bounds read
 on option matching
Message-ID: <aeM5TqWUHDo_Xjv0@chamomile>
References: <20260417162057.3732-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260417162057.3732-1-fmancera@suse.de>

On Fri, Apr 17, 2026 at 06:20:56PM +0200, Fernando Fernandez Mancera wrote:
> In nf_osf_match(), the nf_osf_hdr_ctx structure is initialized once
> and passed by reference to nf_osf_match_one() for each fingerprint
> checked. During TCP option parsing, nf_osf_match_one() advances the
> shared ctx->optp pointer.
> 
> If a fingerprint perfectly matches, the function returns early without
> restoring ctx->optp to its initial state. If the user has configured
> NF_OSF_LOGLEVEL_ALL, the loop continues to the next fingerprint.
> However, because ctx->optp was not restored, the next call to
> nf_osf_match_one() starts parsing from the end of the options buffer.
> This causes subsequent matches to read garbage data and fail
> immediately, making it impossible to log more than one match or logging
> incorrect matches.
> 
> Instead of using a shared ctx->optp pointer, pass the context as a
> constant pointer and use a local pointer (optp) for TCP option
> traversal. This makes nf_osf_match_one() strictly stateless from the
> caller's perspective, ensuring every fingerprint check starts at the
> correct option offset.
> 
> Fixes: 1a6a0951fc00 ("netfilter: nfnetlink_osf: add missing fmatch check")
> Suggested-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
