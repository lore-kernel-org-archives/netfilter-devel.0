Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDB115A85A
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 01:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770255173; cv=none; b=TJXOK33HbT3BAVkpeNjm+uj8nIYPR05pyNuuJtC10Nx1GlGsMWzxSJ4/94mnGHDRRbCcD84+N0Cf47i9x+g/hx9tcABbelUIHVFKR2KV2Z0ZRMQUWjdVXsd4WGmJp0QXyHCOhIFgn1z3Ky193FvPi9CZ2Ym78RpurBLtH6lG2K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770255173; c=relaxed/simple;
	bh=fvraOWx+84te3AjW4suoFS2bYCny76JOh6D8McuzdoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y5/wByqHksNojodXlgw4Zvil367o9TfK/7URVNPcyDJeKV7kH31Q+BklFM4ZK32xWMq7qfyShf22Z/bMXm+l4z7I/LD9VDSYskH6qfJVKgd3tkRRPyq5axcWbXyWnsu2GaLoGHluEkZ1xmonUNsosYvrEB12AmZSjBIYljrXehw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=a/443nKU; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="a/443nKU"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id C230160876;
	Thu,  5 Feb 2026 02:32:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1770255170;
	bh=+eqyprX2babX9CP337PKUYv1ec2gTmrrI4tmw2Ky4/4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a/443nKUZ30Qp3Zn8RbRL/UANDSJokC8ZbLkW7pZZMc8+vZCSNWiNm5WU9dSz1GW/
	 TH4bMq1VvWtLkhiOhhrqp4+Td+K4T5miwSlEZ96u/Sj84lijzmapmKo7YsSxbmM6Mc
	 g1d5hnywnDqFLKRuL8vbRMua3NqQaoSUxEUJaY2JpFqZcIP3vVWQKF0WzGgRG8SSb1
	 8bpDUpLi12zXpGQayNr/fh3FGHb1/2TTZfYCDikLsmau4mHu0MLO4yW19EYGe1Wht3
	 bKPjvB0IhXm7YA7UHIdcFqbQCAi/lcioJUSbBR41MnN8EtsbJXEPZt8FEODtq7iwke
	 B8srLaKOCwz3w==
Date: Thu, 5 Feb 2026 02:32:48 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] Makefile: Set PKG_CONFIG_PATH env for 'make check'
Message-ID: <aYPzQOgGxpacVYMV@chamomile>
References: <20260127221657.28148-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260127221657.28148-1-phil@nwl.cc>

On Tue, Jan 27, 2026 at 11:15:58PM +0100, Phil Sutter wrote:
> When building nftables git HEAD, I use a script which also builds libmnl
> and libnftnl in their respective repositories and populates
> PKG_CONFIG_PATH variable so nftables is linked against them instead of
> host libraries. This is mandatory as host-installed libraries are
> chronically outdated and linking against them would fail.

How do you use this?

> Same situation exists with build test suite. Luckily the PKG_CONFIG_PATH
> variable value used to build the project is cached in Makefiles and
> Automake supports populating test runners' environment.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Pablo: Could you please confirm this does not break your workflow? I
> recall you relied upon build test suite while it never passed for me due
> to the reasons described above.

Just run `make distcheck' or tests/build/ to check, I think that
should be enough.

> ---
>  Makefile.am | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Makefile.am b/Makefile.am
> index b134330d5ca22..18af82a927dc0 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -450,6 +450,7 @@ tools/nftables.service: tools/nftables.service.in ${top_builddir}/config.status
>  endif
>  
>  if !BUILD_DISTCHECK
> +AM_TESTS_ENVIRONMENT = PKG_CONFIG_PATH=$(PKG_CONFIG_PATH)
>  TESTS = tests/build/run-tests.sh \
>  	tests/json_echo/run-test.py \
>  	tests/monitor/run-tests.sh \
> -- 
> 2.51.0
> 
