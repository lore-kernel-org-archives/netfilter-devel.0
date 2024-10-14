Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E81F13C3D3
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Oct 2024 11:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728904841; cv=none; b=qm1ylokU/ZUWv3bVuOXX40laSWv6KgQxVV6QbI+CukSfDf2wDabXyUVq6Xl4aplgcGYqI6jpGAEGllKabHC+3fwrJKyzixSo0Cmezqq7wDWc8zr/TxEMUYqHyNC36zf+0Y24Etllg7lAcNajEmU3u5Oh4+TyYCjHZkIHBOrA3xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728904841; c=relaxed/simple;
	bh=Diu2sa6mv15hdd8aDr/GZT+W2NFecHexL9IvioAT/fg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EtkpFfKzX3xqjKt9nIIOYDoYcHJ85IriUdXDHbu+30j/WG6zBWYzkXdZJT+ZeLx71+eKuCTaY0K5if4rCBe9KxuFTb9IY7OU1I8DS9FsziVhbENL8jL8/+KRt3vDkokaI017/b1IbIFpL38L4sH1kCem2s1CqnZyltcoJX4OvfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=43674 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t0J7k-006GcA-PE; Mon, 14 Oct 2024 13:20:31 +0200
Date: Mon, 14 Oct 2024 13:20:27 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jan Engelhardt <ej@inai.de>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libmnl] build: do not build documentation automatically
Message-ID: <Zwz-e5ef9uyTG6Yv@calendula>
References: <20241012171521.33453-1-pablo@netfilter.org>
 <ZwzOgRoMzOiNfgn0@slk15.local.net>
 <ZwzRn6EQpRJWxYA-@calendula>
 <n4r27125-61q3-r7p2-ns82-77334r0oo3s3@vanv.qr>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <n4r27125-61q3-r7p2-ns82-77334r0oo3s3@vanv.qr>
X-Spam-Score: -1.8 (-)

On Mon, Oct 14, 2024 at 01:12:02PM +0200, Jan Engelhardt wrote:
[...]
> Having worked extensively with wxWidgets (also doxygenated) in the past 
> however, I found that when the API is large, needs frequent lookup, 
> documentation has many pages, and online retrieval latency becomes a 
> factor, I prefer a local copy as a quality-of-live improvement.

For reference, there is one online available at:

https://www.netfilter.org/projects/libmnl/doxygen/html/

for the current release.

[...]
> Removals are a powerful action that is seldomly undone at the distro
> levels, so it can be regarded as the final say (well, in "95% of
> cases").
[...]
> Hiding stuff behind a configure knob is not a removal though,
> so it is not too big a deal.

Exactly.

> >Moreover, documentation is specifically designed for developers who
> >are engaged in the technical aspects. Most users of this software are
> >building it because it is a dependency for their software.
>                                             ^^^^^^^^^^^^^^
> 
> The way it's phrased makes those users users of the libmnl API (i.e.
> developers), and documentation is warranted.
> 
> (The following statement would be more accurate:
> 
> >Most users of this software are
> >building it because it is a dependency for someone else's software
> >they want to utilize.

That sounds more precise, yes.
