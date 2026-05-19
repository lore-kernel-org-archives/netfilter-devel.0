Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A593603F7
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 19:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779220516; cv=none; b=CIV4J9nq0dFX+NmTzGk4IxrptJgUmdbsHRwIZd6oI7BRvnFbEE1pzgM6a2hRcHgdWFVtsQ0pExEFrSPAlcd43dL8r8iqKH19u1nVDovYwpMR/u+tjhn/NnTjEUd4/JTSC4x6NyDZxI2SXPRnAAGIFfo3lkEEQll1Be7VMLoYLcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779220516; c=relaxed/simple;
	bh=zK8biS6ueYNg+J1bdkGdqYK82Ry64FL2dC/o/cWYDx0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lp7/VrYgYZXCIPny/XpEf1sf3oxDESc29tTlQQw53vDOinwpu9v+z9TXV0os2yaK/HwZYQrr9Z4ZaKwJNIoEMoagyagBvcwZYdZQmxD03XR+qJmVk1XpEoC+OAuDv4J071DCr3nAH6Skrbc4xVnskulygCWm0GfQkrbtBWw/5s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=X3uT1IhZ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="X3uT1IhZ"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 158C1601AC;
	Tue, 19 May 2026 21:55:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1779220505;
	bh=2SnGJXq3GlKSyqjYXDOxIpb9vFMo/TsiMP+0YL2cUpA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X3uT1IhZZIw3dROasWQsg9qWlxH94BoLr5OxnOqkoWeiTNSa6hAZE1sFZwPgW5lg4
	 gpVLl1OeUBdtSOzmVxlvx2E3QTuwpTeUTf2yda9JlelkQxrB4iVpjgL8gBDILHUMXx
	 1z83edB3xWyZ07/Pr3mTXW3E4ZZFiPyLAtnQNbGQL/UliTRKXIlgZCQu55NP/bJYDK
	 FubSEqs86iMg5LES2dyLxElBActDEt0Cp+k7ufxLOEun1wKrqylhNVB1hfJMqdhsm1
	 cRlImV6TzAIFrCFlrZvtzQory+x82bPns/ZtX4jf5VhVTH5b5VOJMKJcpPZum0cDlv
	 exnXut8/p2ZrA==
Date: Tue, 19 May 2026 21:55:02 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: =?utf-8?Q?=C3=80lex_Fern=C3=A1ndez?= <tomaquet18@protonmail.com>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v4] netfilter: conntrack: fix integer overflow in
 expectation timeout
Message-ID: <agzAFhNpiYNcBeZ5@chamomile>
References: <20260504112300.715192-1-tomaquet18@protonmail.com>
 <agy8JBZYvx54GYfL@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <agy8JBZYvx54GYfL@strlen.de>

On Tue, May 19, 2026 at 09:38:12PM +0200, Florian Westphal wrote:
> Àlex Fernández <tomaquet18@protonmail.com> wrote:
> >  		x->timeout.expires = jiffies +
> > -			ntohl(nla_get_be32(cda[CTA_EXPECT_TIMEOUT])) * HZ;
> > +			(u64)ntohl(nla_get_be32(cda[CTA_EXPECT_TIMEOUT])) * HZ;

Yes, for correctness, fixing this is fine but...

> https://sashiko.dev/#/patchset/20260504112300.715192-1-tomaquet18%40protonmail.com
> 
> Does this fully resolve the overflow on 32-bit architectures?
> The expires field in struct timer_list is an unsigned long, which is 32 bits
> wide on 32-bit systems. Assigning the 64-bit multiplication result directly
> to expires will silently truncate it back to 32 bits, causing the same
> wraparound this patch intends to fix.
> Additionally, does providing a timeout delta larger than INT_MAX break the
> kernel's signed timer comparisons?
> If the delta exceeds INT_MAX, macros like time_after() will evaluate the
> timer as being in the past, causing it to expire immediately.

the submitter claims you can create expectations that expires
inmediately, but what is the issue with this?

> Should the computed timeout delta be explicitly clamped to a safe maximum
> (such as INT_MAX or MAX_JIFFY_OFFSET), similar to the logic used for
> standard conntrack timeouts?

I think this is just a cleanup / nf-next material?
