Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11C714F117
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2025 13:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747835647; cv=none; b=jypBkFDqKfIWhD6RCfcx6Fq1x2RPZe2TvwzKAtHSekzV2ODzkS9MGDDSn0JfYwCkMhYNIAB2MmkkoSvPOZprZr/bn3zSXtvj6vg3ZiDltKg5Pv3qB0JoSzC2vSjYDXpMxfBoaKWXX9SquIPZf+s1H3RqNpF8NsFPiqvcDod7mhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747835647; c=relaxed/simple;
	bh=a25HJWRSuL4BGBwbweLTVncXZLMni2YrfZzfz4Tz0Hg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EhKeXHGuBR9n7FuKD8ptm3BzObz/Bvt8QTJJxqlffD+EXN/Z1V+wVJ2A+Gran/XwTFLhCE/9t8I/WDMtPXvFw/30Ccn04E3UkIdc0oBy098d+jtiShINaUNOtKzQWexpYACYCJXeCrjvWWMH/h2SmmbFasew2X2DaY5L5qsobfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gF+hJK8l; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gF+hJK8l; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gF+hJK8l";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gF+hJK8l"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id A57546068E; Wed, 21 May 2025 15:54:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747835643;
	bh=zh4dg5c4OiapDwKlepxnww/q+XsMLdgSMnBXy6NNMec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gF+hJK8lVYRt7SsVOD2LI3ExFbJK9HNcWGtZj4q1DCK5fVX5ee8M9wSNfbDczyPLu
	 TQHHNftniT6mckaPV3o66LRI7Qo9rn52YKOPWPIdtj9IrREVS3fC6Ijof4iAyYHcLU
	 99oVualZa++59suOf9AbF6vBgze/ypS6EW9Yb/6TNlBZKq7BtZf9aabWhLaHzfdV/c
	 tuk5TJLXiDpDakZv1h/w/NPf48oDdEkyWh7Bz9Nacvy9z76uskPKjw1ZtSdvSLxN9o
	 xxJwXclLllMeRzM1o2byATekxhHrPGFR8xsN1ylirk4EzSokQXmr7ek7eG14vaxGD/
	 tnVf42MU6yKXQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1AD4E6032B;
	Wed, 21 May 2025 15:54:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747835643;
	bh=zh4dg5c4OiapDwKlepxnww/q+XsMLdgSMnBXy6NNMec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gF+hJK8lVYRt7SsVOD2LI3ExFbJK9HNcWGtZj4q1DCK5fVX5ee8M9wSNfbDczyPLu
	 TQHHNftniT6mckaPV3o66LRI7Qo9rn52YKOPWPIdtj9IrREVS3fC6Ijof4iAyYHcLU
	 99oVualZa++59suOf9AbF6vBgze/ypS6EW9Yb/6TNlBZKq7BtZf9aabWhLaHzfdV/c
	 tuk5TJLXiDpDakZv1h/w/NPf48oDdEkyWh7Bz9Nacvy9z76uskPKjw1ZtSdvSLxN9o
	 xxJwXclLllMeRzM1o2byATekxhHrPGFR8xsN1ylirk4EzSokQXmr7ek7eG14vaxGD/
	 tnVf42MU6yKXQ==
Date: Wed, 21 May 2025 15:54:00 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v2 0/5] netfilter: resolve fib+vrf issues
Message-ID: <aC3a-BXgVh6E-me6@calendula>
References: <20250521093858.1831-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250521093858.1831-1-fw@strlen.de>

On Wed, May 21, 2025 at 11:38:44AM +0200, Florian Westphal wrote:
> Resent after rebase on latest net-next tree, there are no changes.
> 
> V1 cover letter:
> This series resolves various issues with the FIB expression
> when used with VRFs.
> 
> First patch adds 'fib type' tests.
> Second patch moves a VRF+fib test to nft_fib.sh where it belongs.
> 
> The 3rd patch fixes an inconistency where, in a VRF setup,
> ipv4 and ipv6 fib provide different results for the same address
> type (locally configured); this changes nft_fib_ipv6 to behave like ipv4.
> 
> 4th patch fixes l3mdev handling in FIB, especially 'fib type' insist
> a locally configured addess in the VRF is not local (result is
> 'unicast') unless the 'iif' keyword is given because of conditional
> initialisation of the .l3mdev member.
> 
> Last patch adds more type and oif fib tests for VRFs, both when incoming
> interface is part of a VRF and when its not.
> 
> I'm targetting nf-next because we're too late in this cycle.

Applied to nf-next, thanks.
