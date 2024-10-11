Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85CB1C8FD8
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Oct 2024 08:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728635958; cv=none; b=CS0KFkM+p6TR5u51ESyjBddgne1JEkPyVv9/fd/ftxk7/9F1ChU9yD9lC9JJYLT/N3m1Yv0CHxrg31d4D1j8APLm4lcCOP4S82mz2tuPUVZseuGrYPNZq80BTPNtEvw0N2QIkBXLaunRHcllprrwcCjiTsb5nOLW07ZmPWhqQp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728635958; c=relaxed/simple;
	bh=tJnhu+Iz6B9UCsgr+SHGRDoFQO/Y2Kx7jyGwkI0XKdA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NOwiSR9/lmV/PksN/bAqcgvM51JM/HceTUIeOQBgDaZEr0NGNGhTBiBnTiVsGnJ2eAl1Um9KqJQBDP2IR5K443PZBaO3T9Si29NitCLhz/7qTAOJW+RiNrwEZ5f/PYh724SszbTn0S83vlawK1Og5TSWkd1/1khrHjEwtrnoOrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Dl5eAX/G; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Dl5eAX/G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=iQExyOM21jUYoq9Ob8B9ffPVAMgC/zeF0NJ9nP2pnNg=; b=Dl5eAX/G1ci2NH4GerR6mhJ+/I
	sgAH0o/bumnxFaOkrNF/aEWENo0ZFkRph6s2LVPwhVf/36P3Hfjmi33eB/tMkcyyPy91E4Wn3hGWk
	68pgz+/Gdk/oswYkhMerOohctB/gOuFbBS5STOR7jbtIxmwdG35LcCtXRlic9bdibZ/7tEmqeErdz
	CRd6nxvMeolGbRKCIuKhW2lKAN4pLsz+l3teF4vASR9+rmozomt27xaOKJRiNqDKcN1WVqVFyHEO5
	wm4GfmfLGeWzMNZgEaOdx+3WqZck+6nI2BmIvuh7dPXHAdL/EcUMExtlj+7QRVk9ivborLdJU458U
	TURe96kQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1szBAx-000000000xI-2ztB;
	Fri, 11 Oct 2024 10:39:07 +0200
Date: Fri, 11 Oct 2024 10:39:07 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: shell: fix spurious dump failure in vmap
 timeout test
Message-ID: <ZwjkK0IXn0GGVCfm@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20241011003211.4780-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241011003211.4780-1-fw@strlen.de>

On Fri, Oct 11, 2024 at 02:32:08AM +0200, Florian Westphal wrote:
> Blamed commit can update the timeout to 6s, but last line waits
> for 5 seconds and expects that to be enough to have all elements vanish.
> 
> Fix the typo to limit update timeout also to 5 seconds and not 6.
> This fixes spurious dump failures like this one:
> 
> -               elements = { 1.2.3.4 . 22 : jump ssh_input }
> +               elements = { 1.2.3.4 . 22 : jump ssh_input,
> +                            10.0.95.144 . 38023 timeout 6s expires 545ms : jump other_input }
> 
> Fixes: db80037c0279 ("tests: shell: extend vmap test with updates")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  tests/shell/testcases/maps/vmap_timeout | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/shell/testcases/maps/vmap_timeout b/tests/shell/testcases/maps/vmap_timeout
> index 3f0563afacac..6d73f3cc9ae2 100755
> --- a/tests/shell/testcases/maps/vmap_timeout
> +++ b/tests/shell/testcases/maps/vmap_timeout
> @@ -32,7 +32,7 @@ for i in $(seq 1 100) ; do
>  		timeout=$((timeout+1))
>  		expire=$((RANDOM%timeout))
>  		utimeout=$((RANDOM%5))
> -		utimeout=$((timeout+1))
> +		utimeout=$((utimeout+1))

How about merging the statements?

| utimeout=$((RANDOM % 5 + 1))

This applies to three spots in total.

Cheers, Phil
