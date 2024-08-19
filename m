Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B41018787E
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2024 17:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724088254; cv=none; b=Yt0JYRL+oN5Qz939dJFaS2ANxglQwHjpKwrGqk12tgfFW7DQSq250MFvNe5X6yTi8emafm53ZumHFFLVFNpxuv8D1n6aHx5zv5hlpJszcDtACTDria0BGvDnBneyIva4cVFTToKf7UkbVPexIzXnI4vxOy8NJ3LHKF/7TqQXo7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724088254; c=relaxed/simple;
	bh=6k/W95YvRRi6qAgcJezzseG9RUsaFCrs+eYCOChWjik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X+TnJR/fXidteifNGeicyI7XR4c8ZES3hmfvRgpLWuAkc+I4ZuzZ6a54n9+9Tc0cvXHAIhTzjepv/DFsHzFu1GwcaZ6bs6EjdRrgt7zlTpiji4Ry0MVbhQpLDrs0yT71ExE1hS1A9XGMclvskb34qjvqNKondtMQ5q1ZSnrjUWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=39196 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sg66x-005dME-OQ; Mon, 19 Aug 2024 19:24:10 +0200
Date: Mon, 19 Aug 2024 19:24:06 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Joshua Lant <joshualant@googlemail.com>
Cc: netfilter-devel@vger.kernel.org, Joshua Lant <joshualant@gmail.com>
Subject: Re: [PATCH] xtables: Fix compilation error with musl-libc
Message-ID: <ZsN_trJvTSw05f5W@calendula>
References: <20240709130545.882519-1-joshualant@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240709130545.882519-1-joshualant@gmail.com>
X-Spam-Score: -1.9 (-)

On Tue, Jul 09, 2024 at 01:05:45PM +0000, Joshua Lant wrote:
> Error compiling with musl-libc:
> The commit hash 810f8568f44f5863c2350a39f4f5c8d60f762958 introduces the
> netinet/ether.h header into xtables.h, which causes an error due to the
> redefinition of the ethhdr struct, defined in linux/if_ether.h and
> netinet/ether.h.
> 
> This is is a known issue with musl-libc, with kernel headers providing
> guards against this happening when glibc is used:
> https://wiki.musl-libc.org/faq (Q: Why am I getting “error: redefinition
> of struct ethhdr/tcphdr/etc”?)
> 
> The only value used from netinet/ether.h is ETH_ALEN, which is already set
> manually in libxtables/xtables.c. Move this definition to the header and
> eliminate the inclusion of netinet/if_ether.h.

Any chance that musl headers are being used so this can be autodetected?
Then, no option to pass -D__UAPI_DEF_ETHHDR=0 is required.

thanks
