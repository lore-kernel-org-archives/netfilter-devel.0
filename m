Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26F33DEFF3
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2026 12:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773231130; cv=none; b=MMdrGzKedIKVd8mCaMfe4mceUMmDRALtc3wMnw+zQ+G6Way5lA3m8/lIHblLlN2TKk0OxgjEpTyg7jbIoSXR1BOAZ4tL2l0corwBQOwmySbyl0OYBVzbNPEtAqDnWavCHxrl9kk0trdESm1hybU4yY/R7Bpo/e4Y1esA6lobwsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773231130; c=relaxed/simple;
	bh=Cm1jSPXiGkdfuKWDftaTiXAYjhcPUOmr5zFn9p1vMaA=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IAiFWbiGqikZZpgTPTM3JpfFBim5uCygvEWD5I1IYqDULZGT+Z2t99r5dS26/prCdZo9VYgtpr2NX8v2Kl4xzqD2D0YvHjVpaoWox9xDUPt6WVnQQFPewjtj7f/M039XP3K3v+vHfmOIT0XbVqNTfnHoQg/TcDXFzNjtdBYEhaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CuY+cg2h; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CuY+cg2h"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 50BA16026D;
	Wed, 11 Mar 2026 13:11:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773231119;
	bh=4OhCVtgRorD3RvCv0eC1ngRB3V5wgx16RLNo3eaLeL0=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=CuY+cg2hbSl+KMwYWYDdOeKYe5N9kd5+wXLRzqZFU8Z7JZb0PLeHJS9yerDJ5K4OS
	 5ix8ympQsHG980BRpQYLQu2f1qCnZueqATfnvEjAIOS9s4E3dDCv0Wk1rkdA+pFS5d
	 u0t5VfIjgoO3m+ypb5MXCXm0ze/XsiYEfSY0/Xq5sfoH3SqCnz/DXE1lpDFJfOSrhz
	 T0Ea5q+RvLy+Q9sHfgaObuGDqkSrMOJbcO8CFUHzQQidvEZxamRhOp431Ug95naevw
	 J7LQv9sLIPhios016eKND/CsxOTy/SlXUwkZsKCOVuBvmSkdnYIHInlYoD44TBJIe4
	 dz2tbfSZHKILg==
Date: Wed, 11 Mar 2026 13:11:56 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 2/5] cache: Respect family in all list commands
Message-ID: <abFcDNwnKzer7_r7@chamomile>
References: <20260310231115.25638-1-phil@nwl.cc>
 <20260310231115.25638-3-phil@nwl.cc>
 <abE3Q6E9eZEm4-DZ@chamomile>
 <abFBziaYqOenTfVt@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <abFBziaYqOenTfVt@orbyte.nwl.cc>

On Wed, Mar 11, 2026 at 11:19:58AM +0100, Phil Sutter wrote:
> On Wed, Mar 11, 2026 at 10:34:59AM +0100, Pablo Neira Ayuso wrote:
> > On Wed, Mar 11, 2026 at 12:11:12AM +0100, Phil Sutter wrote:
> > > Some list commands did not set filter->list.family even if one was given
> > > on command line, fix this.
> > > 
> > 
> > Fixes: a1a6b0a5c3c4 ("cache: finer grain cache population for list commands")
> 
> Hmm. At that point, we didn't have 'filter' parameter in
> evaluate_cache_list(). Struct nft_cache_filter was introduced later, in
> commit 3f1d3912c3a6b ("cache: filter out tables that are not
> requested").
> 
> Assuming that Fixes: tags are used for semi-automated backporting (at
> least I do ;), pointing at that commit will cause trouble.

Good point.

Helping identify backporting in a semi-automated way is good,
specially for small fixes like this.

At least for me, it helps me identify if it is an
update/enhancement/feature or fix, it is just a bit more context
information.

> Do you still think we should add that tag?

I get your point that tags need to be right if we use them.
