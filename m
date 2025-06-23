Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AB927991E
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Jun 2025 17:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750698513; cv=none; b=ZH8eXh0Kid+JXyln4ej0/E9srrsUpMs4PEF5xfnYuHWs/3hIRYjQs/dktGcWxnp3ILBzzd5AMst71CvwlWoeL0/CR6Zcd/RThiFUIEbwqJneNPlgJUD2Atv+XxhfvP0xMHdXAfnoMnhCQaKdnhgHQ/QNrlC5UOHJSzJ572cg4Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750698513; c=relaxed/simple;
	bh=LUDUGbS0AUO1A9izCNaOS7EgYoUyH6wN0+2QHQcjhSE=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YjcQoR2Ohd/P1fTYsfhWhybUoKlyPy0X/nMqQBY024XxhwFhlvclU6xr9/G9LjrGbIK6Wypmyg0ylp3R6IMrW0jJ84IftwNKJx6U7PGM1fPb6fL7uQKxAuloJr+ter4TLdKFvS1+ZLqNuHMU/dWGDseRWPkWPU19I74lv6D+KBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=INnYzebi; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=INnYzebi; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="INnYzebi";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="INnYzebi"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id E6AD160264; Mon, 23 Jun 2025 19:08:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750698508;
	bh=HobQwfrgXmhsNkouR3oy4F76zYKarzLYGe/5veCb1+8=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=INnYzebizmPfEGSgsrq6bit7UYzMVGngo1EewMv8/x1IqZUhecKV+dKMU2wHI1pWp
	 dYs5m/fNzr6p6romkGzr4kuI2iVwm6lGzse+b5i6aSLbFMU0SclTSPPeIyCa+eBRhj
	 jzYpOnAtYY6nYXG85wHcy8Wplx0+2JB2k9J9h6XAj4RpUhWSXoBjFsjlpy8Bctmf6U
	 nweEkCowF9AdUhDuF7lC5wP2McwXo8rx1Ke5azGCTY4hjAnRgSdaVcQc+OcGdNAq5e
	 H3UWZuYN113XzCTFbGUb60bWWAozWQNrPc7rNEyqUxTCTZXQAIApDqhr6qUw8klP6r
	 R93SuvoSsPOdQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8BEB160251
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Jun 2025 19:08:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750698508;
	bh=HobQwfrgXmhsNkouR3oy4F76zYKarzLYGe/5veCb1+8=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=INnYzebizmPfEGSgsrq6bit7UYzMVGngo1EewMv8/x1IqZUhecKV+dKMU2wHI1pWp
	 dYs5m/fNzr6p6romkGzr4kuI2iVwm6lGzse+b5i6aSLbFMU0SclTSPPeIyCa+eBRhj
	 jzYpOnAtYY6nYXG85wHcy8Wplx0+2JB2k9J9h6XAj4RpUhWSXoBjFsjlpy8Bctmf6U
	 nweEkCowF9AdUhDuF7lC5wP2McwXo8rx1Ke5azGCTY4hjAnRgSdaVcQc+OcGdNAq5e
	 H3UWZuYN113XzCTFbGUb60bWWAozWQNrPc7rNEyqUxTCTZXQAIApDqhr6qUw8klP6r
	 R93SuvoSsPOdQ==
Date: Mon, 23 Jun 2025 19:08:25 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 0/5] assorted updates and fixes
Message-ID: <aFmKCa8Sj22YlPvV@calendula>
References: <20250615100019.2988872-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250615100019.2988872-1-pablo@netfilter.org>

On Sun, Jun 15, 2025 at 12:00:14PM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> This batch contains several assorted updates and fixes:
> 
> 1) Skip lookup for mistyped names if handle is used.
> 2) Assert of non-nul name when {table,chain,obj,flowtable}_cache_find()
>    is used to catch for bugs when handle is used.
> 3) Consolidate repetitive cache name hash.
> 4) Restrict reset command to use name only because NFT_MSG_GETSET and
>    NFT_MSG_GETSETELEM is missing lookup by handle in the kernel.
> 5) Allow to delete a map with handle, for consistency with the existing
>    command to delete a set.

Pushed out.
