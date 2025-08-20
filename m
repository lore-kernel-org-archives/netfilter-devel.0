Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE522DE718
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Aug 2025 13:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755695199; cv=none; b=MGe32Bfds0GDqsp/qXeNrDXO9dWJKmkYDFQKAZCvZc8r7e9uwW3hpApyKUh//fAdVeJnIMbE1bQ8Aq23Hc0XDf++q0WFphPlAMRbIMv71EaHri0xbiozRZl9hdeXDcPSoAKb0z9lRz2jv/m4t7/Yj+B3Meywb3Xks5RbR1LbzAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755695199; c=relaxed/simple;
	bh=SvwKu/QLFDa5EXngRGh9NZ/rrNpNqJbINPZGPTkwGt4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WR0470wL4CfMh71mxCYXxAZC9uj+HaactV4L3HjXGv0drs12lgFbBoJ99Vwi7xC3bYlDnQijjLD55EfSnFhn2gy6MiHLqueOFxduYgmE3gOUilJboGB2r2uwyZMQep6NxKepeNndTCp+239bSJVPbxz3cecm990S/MlJuZzaWJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nGlhO6EW; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gcdhR1JF; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nGlhO6EW";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gcdhR1JF"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 36BCA6026E; Wed, 20 Aug 2025 15:06:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755695195;
	bh=2hFDx36p8MVrxOvrxJYrFwD3SLziXBVAcvHNfdeC1uI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nGlhO6EWA8J4HzHY3GPK7JfHO9D037SuS9g9vs+2ncRw6j1rcg292kGLMPTiD26Tt
	 yB0k81+ig9Jb6Q8JXlp6oUyJ0ucXzi4yJw9Dt2bYmfJJya+xu0F0H8pGpb+48zGtFC
	 h/7NAeEswQQ0n8937Jb8lYJfNKDH3X6s1azi7+F2V/yhKoTzo325BjDG8BuOS5iuky
	 0WonZIykr9BClsxL87ZlznoDpKe8AlFrnf88JDgPPE9e7wbA8M1kIilkXqDVZv0PfY
	 0B2Ef7D/xR7YPD5jDA3HDYhi6YRwPXp9zkB1NsjOs3BiY1EkyICJUBw0dVSzqtKoZu
	 8ubIBCZcEh73A==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1E9DF6026E;
	Wed, 20 Aug 2025 15:06:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755695194;
	bh=2hFDx36p8MVrxOvrxJYrFwD3SLziXBVAcvHNfdeC1uI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gcdhR1JFa5F0zt5ZCL5Pg8L0NdMM4uBuOiOr47pzr/IggYvnbnNkn+OFOMNJltOVp
	 umKgiiUS0FZcsGUqVZpEZSogtoWKn62IO3eeyJLyZjqpkQFdxjZ8fRCiBsjJTOwKQG
	 bD8KqeZ+ZLKRElKXTE8lY4f6OvtN8paihQ4HXracR50iTuhLEvQH9tqZ4agotjtNwL
	 Rq6SANyGmmiRK2e8yr+Pa65TrvlTLyOSepB3PjE/TLadK/rgZtXE7d3VkDx/XdhUGo
	 6/yeQmaYk0RJCrrXRe0ZhAPTGK6XzNQxCxxy6wbjoJAz3RPBDto3kDQ2QM8u/VYn9b
	 vSD6Zst8PN/6g==
Date: Wed, 20 Aug 2025 15:06:31 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jan Engelhardt <jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org, phil@nwl.cc, eric@garver.life
Subject: Re: [nftables PATCH v3] tools: add a systemd unit for static rulesets
Message-ID: <aKXIV7dEmZUfXE5O@calendula>
References: <20250417145055.2700920-1-jengelh@inai.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250417145055.2700920-1-jengelh@inai.de>

On Thu, Apr 17, 2025 at 04:48:33PM +0200, Jan Engelhardt wrote:
> There is a customer request (bugreport) for wanting to trivially load a ruleset
> from a well-known location on boot, forwarded to me by M. Gerstner. A systemd
> service unit is hereby added to provide that functionality. This is based on
> various distributions attempting to do same, for example,
> 
> https://src.fedoraproject.org/rpms/nftables/tree/rawhide
> https://gitlab.alpinelinux.org/alpine/aports/-/blob/master/main/nftables/nftables.initd
> https://gitlab.archlinux.org/archlinux/packaging/packages/nftables
> 
> ---
> v2->v3:
>  * ExecStart uses `nft flush ruleset`
>  * flush command thus no longer needed in the .nft file,
>    which allows for just redirecting `nft list` output
>  * Manpage mentions `nft list ... >main.nft`

Applied, thanks.

I made a small change to display ${unitdir} path in the ./configure
log, to provide a hint to users that systemd unit file is being added.
