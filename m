Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4E216DC3D
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Aug 2024 10:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725014319; cv=none; b=mr5NSUdssZtbQHoZqxoMHh3C3PPNM5NhEWfLxYDlzmu8In1EoNN1KSNOBjzYxeZxH5HJ0KLiRUMchLTns5+l1h4h/G+Bq8ua0XOdqVAyVUje9N0yg4+LEkcd1a4vON2PRmYwF9nAYUQXotc356UMjjMeS6q9mCKG/KkeRjwhAeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725014319; c=relaxed/simple;
	bh=ta213cQ8FLcn+ZPCUZdxIIXrpWfg5ZDhrcDg1rsqOY8=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SV4oUlkiMTaFGAxhhNM61O4qsQYInZV74X14LSBv0coUK/xBKfCQ3B8cGj0O9XCDFViikAsbYlUSzuFM7ULyEtYOvH3v5xP5wR6/Odpq6V1BcPecr3BymFeVQt5K40QsH8ERF59ZNHgQjaafx3mMEYflFWiD8jBapaTewh3+U5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=48826 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sjz1J-004R5p-Oe; Fri, 30 Aug 2024 12:38:23 +0200
Date: Fri, 30 Aug 2024 12:38:21 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Garver <eric@garver.life>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/5] cache: assert filter when calling
 nft_cache_evaluate()
Message-ID: <ZtGhHZ0_0tU_qkeD@calendula>
References: <20240829113153.1553089-1-pablo@netfilter.org>
 <ZtCHMk2ez3l-JeTt@egarver-mac>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZtCHMk2ez3l-JeTt@egarver-mac>
X-Spam-Score: -1.9 (-)

On Thu, Aug 29, 2024 at 10:35:30AM -0400, Eric Garver wrote:
> On Thu, Aug 29, 2024 at 01:31:49PM +0200, Pablo Neira Ayuso wrote:
> > nft_cache_evaluate() always takes a non-null filter, remove superfluous
> > checks when calculating cache requirements via flags.
> > 
> > Note that filter is still option from netlink dump path, since this can
> > be called from error path to provide hints.
> > 
> > Fixes: 08725a9dc14c ("cache: filter out rules by chain")
> > Fixes: b3ed8fd8c9f3 ("cache: missing family in cache filtering")
> > Fixes: 635ee1cad8aa ("cache: filter out sets and maps that are not requested")
> > Fixes: 3f1d3912c3a6 ("cache: filter out tables that are not requested")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  src/cache.c | 16 +++++++---------
> >  1 file changed, 7 insertions(+), 9 deletions(-)
> 
> Thanks Pablo.
> 
> For the series:
> 
> Tested-by: Eric Garver <eric@garver.life>

Pushed out, thanks
