Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2AD86348
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Aug 2025 12:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756297368; cv=none; b=n/a+LRwnPypbvjYp8oPpuXNtRe9JWAlhrYHS5zQ3bdNErs4UF8L+CMdtFYE6ZZ0PXas4Zh0e3NtKzyRmUmlYOlUvSY5cKZhe0GpEWxTDTOsK+v/axSwnmVCixtUSznIv5u/+w5k5joDToQ7h4HtuhZiWqzOvvTRdP4j95txzlzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756297368; c=relaxed/simple;
	bh=h640VnS7FHl9XJxipO+DRjDAoH5LfBWpKwN0X61GoEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WVrbnA+K3AVzw45lWJ//9H6RllE2NArZjXegxBXZG62Ed7RZkaHK0ll6O4doPApS3zrUeNp7B118w7JtxYxqQgP9a/7/8EAurqB6nNkjNbofNDWx7OUuXHoC8W04MIeDeTDpjwSBLJ8YdtY2NT19Akm/lSyoR6CuJUfB+Sytn2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=eRCRbf3X; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=hIJuCrwK; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="eRCRbf3X";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="hIJuCrwK"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 1A7E960265; Wed, 27 Aug 2025 14:22:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756297356;
	bh=1zzkIwDK9FcJK/mXFo9Nu8PRwVjlq0r30n5DnbQ4bAQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eRCRbf3XothIyA844p3AVD9P8RwCz4qkFpxwwo3vGNyodStoFzhInOiFH/t7nkn02
	 /eGqYis3f4Hf/dZp/B3/qG29zW/9FNGqACbDsYlOswsgXVuVzHf2kEJvk2adc3hAYn
	 50Yk8O8oBHgjGYbHnwQP2LdsU6fG6Qhidv0aH8zxcouEKvjSbs1sMSFCRy7W6OMfoP
	 2+wvJA3b71otbzwWGPvwfRLNnktMlpRJ5Ube2cjL12QBZqnceZKyudfZ1972CwKpT1
	 ne8rBs8iXTuMr+UkQjAzR6u7VPT+9vd1VUyNkAKzJN6U3Tw+tOS5k7gmOoauyorsQ1
	 3MkHu9gu68+Og==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2F23360254;
	Wed, 27 Aug 2025 14:22:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756297355;
	bh=1zzkIwDK9FcJK/mXFo9Nu8PRwVjlq0r30n5DnbQ4bAQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hIJuCrwK1pQfgKTLquk84XEAFeIK77QEZHtHOc5nipDGFaDlInaw94K/Gwk7ektft
	 NN1UJQuPdF5yfrCRVgdov5uBpwkW/FzAv7VbcnboiFhNcGcTViYaFUiked7d4G3drQ
	 Magrjcb91Bx8hnbR2UDjth7uHMuretp+/At7Szu6rSzJt4aJYx/A8WiB2LIC+GmjRc
	 IRBSofSaINcFIQ5bQq9I+DHViBsFfu7M8Wd1Oj0qW1Qg+nyZZK5BSTexzaEjo1Wqpg
	 9qMKHyS3h+jeuOIX2oiRqwokoE5p0hPvei1ZtShvqz0NzdIicFsdx1ld8UYfjpg5XS
	 3tqKYqmfQmGAw==
Date: Wed, 27 Aug 2025 14:22:32 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Jan Engelhardt <ej@inai.de>
Subject: Re: [nft PATCH] Makefile: Fix for 'make distcheck'
Message-ID: <aK74iFRHm3WTCEbq@calendula>
References: <20250826170643.3362-1-phil@nwl.cc>
 <aK4N56uzuIWgBiG5@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aK4N56uzuIWgBiG5@calendula>

On Tue, Aug 26, 2025 at 09:41:27PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Aug 26, 2025 at 07:06:43PM +0200, Phil Sutter wrote:
> > Make sure the files in tools/ are added to the tarball and that the
> > created nftables.service file is removed upon 'make clean'.
> > 
> > Fixes: c4b17cf830510 ("tools: add a systemd unit for static rulesets")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> 
> Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

I was preparing the release, however, this fix is not enough.

When I run:

        make distcheck

 /usr/bin/mkdir -p '/lib/systemd/system'
 /usr/bin/install -c -m 644 tools/nftables.service '/lib/systemd/system'
/usr/bin/install: cannot create regular file '/lib/systemd/system/nftables.service': Permission denied

This is not regarding the _inst directory, ie. nftables-x.y.z/_inst/
that make distcheck creates as non-root.

This needs a fix.
