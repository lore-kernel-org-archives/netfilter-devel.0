Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF95E1581F9
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Mar 2025 20:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741637973; cv=none; b=tNZXzh5XER6TdIt41KvzwpMkQxtXJoYgRw1JqTN6ScCxeDgoZKuEFWCJx2MAaaFcddHjsorYDkJUkLh7TCvXrjJmt/Ap2heLRSF7RwIBy2o2bCWnpSNxBHApM9CHQJ21WxZw3yrXmkBUiwD928Oy7jUDC39d54l/YxhtxFISWKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741637973; c=relaxed/simple;
	bh=I/gfstKftTSngnTtewE83ptliuvJJkLKvGMg87OQrwM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F/T3Xv1uFhg/H7LUBtzreMosvpOj55xoXUvs9ocNSEkFUN1QDXgB0DJyW93y5OHRuccChGCyiS027XPknSvRy/9ts0opHj4Ktsp2AOJSZVU+bGqGZ+OdH+h9KaRVnbdjU6ItVSErjyr0cN0/UKWdDihfAuBIyhoqa1adRQrpUNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CPC53nPc; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CPC53nPc; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CPC53nPc";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CPC53nPc"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id CFA276026F; Mon, 10 Mar 2025 21:19:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741637968;
	bh=ltkUFtLaUV6TdAwm6PlHGGiU90F0ppnKSvqUDPiyk6o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CPC53nPc370T7xlZ5TGUGs/vtt/APCQIkKA3I5WOxdMid2M6Tf0WRZ0crW/48WR2p
	 mVIfnMeXPr5VK5V7Ba2lJPUOHmbMyPyi+czC+wRUMZVcHvhQ8sSNepU6Mrjb94KsR4
	 oaYqE1U8nV6gdUy/6qCfdRsIu8UWBNOLZIiNzRoMgRfAGOCmJmN4DhR/oUrF5hOzgA
	 q43W+NfUL/k/dau4h05Zn8WFvJZTxGMahIMHzyvGSnrSS9VXhj3Hwpc1p7g3HK4f7J
	 J5GTRUEWC1diHvlVNvLh5ymXMDGNEERCSiyrON8kHWWkrfFam7zKNHvsw7Lyy1yToH
	 l2S8zljwK9wew==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 403D76026F;
	Mon, 10 Mar 2025 21:19:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741637968;
	bh=ltkUFtLaUV6TdAwm6PlHGGiU90F0ppnKSvqUDPiyk6o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CPC53nPc370T7xlZ5TGUGs/vtt/APCQIkKA3I5WOxdMid2M6Tf0WRZ0crW/48WR2p
	 mVIfnMeXPr5VK5V7Ba2lJPUOHmbMyPyi+czC+wRUMZVcHvhQ8sSNepU6Mrjb94KsR4
	 oaYqE1U8nV6gdUy/6qCfdRsIu8UWBNOLZIiNzRoMgRfAGOCmJmN4DhR/oUrF5hOzgA
	 q43W+NfUL/k/dau4h05Zn8WFvJZTxGMahIMHzyvGSnrSS9VXhj3Hwpc1p7g3HK4f7J
	 J5GTRUEWC1diHvlVNvLh5ymXMDGNEERCSiyrON8kHWWkrfFam7zKNHvsw7Lyy1yToH
	 l2S8zljwK9wew==
Date: Mon, 10 Mar 2025 21:19:25 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_log] autoconf: don't curl build script
Message-ID: <Z89JTXmVyzC0tYF5@calendula>
References: <20250309105529.42132-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250309105529.42132-1-fw@strlen.de>

On Sun, Mar 09, 2025 at 11:55:19AM +0100, Florian Westphal wrote:
> This is a bad idea; cloning repo followed by "./autogen.sh" brings
> repository into a changed state.
> 
> Partial revert of 74576db959cb
> ("build: doc: `make` generates requested documentation")

Please, apply this. Thanks.

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  autogen.sh | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/autogen.sh b/autogen.sh
> index 93e2a23135d4..5e1344a85402 100755
> --- a/autogen.sh
> +++ b/autogen.sh
> @@ -1,12 +1,4 @@
>  #!/bin/sh -e
>  
> -BUILD_MAN=doxygen/build_man.sh
> -
> -# Allow to override build_man.sh url for local testing
> -# E.g. export NFQ_URL=file:///usr/src/libnetfilter_queue
> -curl ${NFQ_URL:-https://git.netfilter.org/libnetfilter_queue/plain}/$BUILD_MAN\
> -  -o$BUILD_MAN
> -chmod a+x $BUILD_MAN
> -
>  autoreconf -fi
>  rm -Rf autom4te.cache
> -- 
> 2.48.1
> 
> 
