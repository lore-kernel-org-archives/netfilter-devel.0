Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581AC31A60
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Sep 2024 21:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726434726; cv=none; b=fsADCgsh+5qXO3wHMJDp+B3+BsIKh/I84xbPN5OoFz1QVapZPKJZSokWZcwQMgWUTIix4DbVqHYq2uJ5IrMtLCLkcRTecUYTEiULIViGfrQJlaxkn3B43qUc1/AFRmUM21AVpg9Jd5p8mlb+9ChIS4nX8Wx1hOBtSRhPkC4L5yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726434726; c=relaxed/simple;
	bh=xTPV1SB6c/yyGUkUHj990kZXI0bwa+AtLHehuTb/BrM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YkVV4h4pYBoPKj7RPFvT6NGGeny3Ytw6GeoOg560CP7hyRxv/Bp63uZEio/blvCL81R6CqyJ1dYtUqrF6+eLTqrlDQGdkwFfBqqt1WyuW1sTHVVSWYqj1zwZwvfkIXvshTSfAB6cryPvSML2toFqzfji+XSsnfuzAuGIb1+R1xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=56424 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1spwXI-00EIqZ-DU; Sun, 15 Sep 2024 23:12:02 +0200
Date: Sun, 15 Sep 2024 23:11:59 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/3] netfilter: conntrack: clash resolution for
 reverse collisions
Message-ID: <ZudNn7T7bKcJNTh9@calendula>
References: <20240910093821.4871-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240910093821.4871-1-fw@strlen.de>
X-Spam-Score: -1.9 (-)

Hi Florian,

On Tue, Sep 10, 2024 at 11:38:13AM +0200, Florian Westphal wrote:
> This series resolves an esoteric scenario.
> 
> Given two tasks sending UDP packets to one another, NAT engine
> can falsely detect a port collision if it happens to pick up
> a reply packet as 'new' rather than 'reply'.
> 
> First patch adds extra code to detect this and suppress port
> reallocation in this case.
> 
> Second patch extends clash resolution logic to detect such
> a reverse clash (clashing conntrack is reply to existing entry).
> 
> Patch 3 adds a test case.
> 
> Since this has existed forever and hasn't been reported in two
> decades I'm submitting this for -next.

-next is now closed, my plan is to place this series in nf.git for the
next PR.

nf-next will remain open in this cycle so hopefully we can merge your
updates to reduce memory footprint in the next -rc.

I cannot go any faster.
