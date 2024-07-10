Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7A6194135
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2024 15:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720626860; cv=none; b=T1SvZM/2NBjL7bJlli505w11v3lO/spMSyGeoAfznh/W/NVNlrA30UWJPwbLAAwWzPo89tDD/XAjwh74LU3rC0TFi0BepbKno/x2XDEfK/4sAY7vgE3Vyj8xSz7cZYQEmg4X1O0IXdinJIBm9pReNKkOstlaSKaW4Yjvzo3lpbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720626860; c=relaxed/simple;
	bh=dobWD0j9KjNZat6SnefugKrkSsn2eKSHet8J649Dwzc=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MPGh/ghFbx7GgCFsf80qXv7y25PMcPhEPQT0veaJRaste/JNpYFmhZhOXIFsc9d9TMMJAontmTNfcbCP+RRaU5vH10wJKXsQwBBpCB8Of506WfQ7Zh5n95G0TgNbvtxXnhPYM+8w5iPAWeivhA3Y6Ea7PuAmHGfGGwgrK2+5T9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=40254 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sRZe1-00GkRR-AH; Wed, 10 Jul 2024 17:54:15 +0200
Date: Wed, 10 Jul 2024 17:54:12 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	thaller@redhat.com, jami.maenpaa@wapice.com
Subject: Re: [PATCH nft 1/2] parser_json: use stdin buffer if available
Message-ID: <Zo6upCWqAuV1aFOR@calendula>
References: <20240710152004.11526-1-pablo@netfilter.org>
 <Zo6uNc9oxoqMTwmU@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zo6uNc9oxoqMTwmU@orbyte.nwl.cc>
X-Spam-Score: -1.8 (-)

On Wed, Jul 10, 2024 at 05:52:21PM +0200, Phil Sutter wrote:
> On Wed, Jul 10, 2024 at 05:20:03PM +0200, Pablo Neira Ayuso wrote:
> > Since 5c2b2b0a2ba7 ("src: error reporting with -f and read from stdin")
> > stdin is stored in a buffer, update json support to use it instead of
> > reading from /dev/stdin.
> > 
> > Some systems do not provide /dev/stdin symlink to /proc/self/fd/0
> > according to reporter (that mentions Yocto Linux as example).
> > 
> > Fixes: 935f82e7dd49 ("Support 'nft -f -' to read from stdin")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > v2: remove check for nft_output_json() in nft_run_cmd_from_filename()
> >     as suggested by Phil Sutter, so JSON support does not really use
> >     /dev/stdin.
> 
> Series:
> Acked-by: Phil Sutter <phil@nwl.cc>

Pushed out, thanks
