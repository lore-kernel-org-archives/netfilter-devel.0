Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E20243952
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Mar 2025 14:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741790579; cv=none; b=J9Ufl6CX1Kx9V9Hxs0m1bqulIDbHV8udljqTf16wNMnbSN9qtqKr8bJAXfvo8Kvfzh5gEc69aDFFOgzKNStcEZKgynUkKXT2sqio4HFuK1/LOzIcXtNgK3Se4q8YqJ07ZLZWmBXfe5OD8+XZTi3O1MHpR52r1WBdLXZCe4RcyuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741790579; c=relaxed/simple;
	bh=A4oYP+zSP3v/fCUJwusU1GG7IZbrx/cWTluHNEqeNb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AnTHsYKBPdWbMXwCTqqP94GOb7gPM/aDP4sgYyAf8UvgqzDD5Ltn29wJDcacN2wmxNktX63JmIVbxP8S/Tah9x039GnY7Bcf4Dij/GvFa3YT63vPJZYQ/a+teNEKRzk6qY9Q5nrr9kwhfZMFYLSeC2nYslbNGBB3aj5/dsnCItk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=mKfSYODT; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=mKfSYODT; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="mKfSYODT";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="mKfSYODT"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C82FC6026D; Wed, 12 Mar 2025 15:42:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741790573;
	bh=sfAJpkLI8JdXZaA4zkJadB8bLGJP8yMwftEYYiS1vG8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mKfSYODT4ZUf7qRGGwKiJyEILsGa7uT3Cai9FBR5cVt4zw9H6SerZntUaxw38cjru
	 uM9GDov+Q/ql3313txV7yLSF92ZKXaXApUU+Rj+piktE0x3I7oy+pxdDCosY715VsY
	 U/Zl5x7WVhmGLRWYvgtw6wWszZUqokId6abrWjGlmIu9dZTHPHAG+qskGQjGDV2fEs
	 /Ol2FypomzdBU15rLYVtJVy5inZiqHRl6d7YcAEGh1+y4l/AO5nnENyedGM5w69ZiL
	 UQKBUOfsCTtG/yFViOoMuXqWDJc2lFirAV4D//6DTd4h9IzQAWpB8gSj4wW+CIlULx
	 83FXo32t5sa0w==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 355636026D;
	Wed, 12 Mar 2025 15:42:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741790573;
	bh=sfAJpkLI8JdXZaA4zkJadB8bLGJP8yMwftEYYiS1vG8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mKfSYODT4ZUf7qRGGwKiJyEILsGa7uT3Cai9FBR5cVt4zw9H6SerZntUaxw38cjru
	 uM9GDov+Q/ql3313txV7yLSF92ZKXaXApUU+Rj+piktE0x3I7oy+pxdDCosY715VsY
	 U/Zl5x7WVhmGLRWYvgtw6wWszZUqokId6abrWjGlmIu9dZTHPHAG+qskGQjGDV2fEs
	 /Ol2FypomzdBU15rLYVtJVy5inZiqHRl6d7YcAEGh1+y4l/AO5nnENyedGM5w69ZiL
	 UQKBUOfsCTtG/yFViOoMuXqWDJc2lFirAV4D//6DTd4h9IzQAWpB8gSj4wW+CIlULx
	 83FXo32t5sa0w==
Date: Wed, 12 Mar 2025 15:42:50 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] selftests: netfilter: skip br_netfilter queue tests
 if kernel is tainted
Message-ID: <Z9GdaumsvEDe_q3t@calendula>
References: <20250311115258.8267-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250311115258.8267-1-fw@strlen.de>

On Tue, Mar 11, 2025 at 12:52:45PM +0100, Florian Westphal wrote:
> These scripts fail if the kernel is tainted which leads to wrong test
> failure reports in CI environments when an unrelated test triggers some
> splat.
> 
> Check taint state at start of script and SKIP if its already dodgy.

Applied to nf.git, thanks
