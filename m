Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA571E8329
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Aug 2025 13:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756389200; cv=none; b=Zi3dBqVN0f5+P4oDsBvJwvOQ0Pyy3ELQ7+oG2t6+QUOSeZaF+y0BZBJ3K7lHwbjIVhQPYgWSdcaBfAhfCOsRFoMgfEIlfqQFcaM7kneTZdVhuU1Vh6sJZ2b2bPSkUytaqfEV1A00v+p0/MEaAts/Te6xFsaPro2qRDBo/bdZZe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756389200; c=relaxed/simple;
	bh=+nCHhELW5TkCKQ2Cm6KkieHgdeUkORj2A/LKbXqYIHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n2ysghkHjbGhWge9Rcln7z/NQrrA/Qf/Sq7FDTbTNWxp2tybaNXsjV8fmOmRTlfmSzf4mb5OsCtPeqs+NU4iw5wK8pq28EtG1se9l9vBllh4vXfMeIgVcf2tvGI4Pd+8ts26pMluzsV62KS+JMwVT3M5zSHA5vjiPRoAZRK99vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=BOGIxNYm; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="BOGIxNYm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4bvooLMdAeR5tWSw6oVl7RABi1TbnaxMlylcOqRNGTE=; b=BOGIxNYmaV4mlKYcxe+Kw41gaZ
	klfIEuciwCNENjDLfcCqsrQMIX6RYjW/RjFtqP0/eT+zDWOOlAo5Zm3qkVZF8VjzRhAypvciNmCn1
	GGr7QxlWOKDaUhaBYiq9e7YkDjs9S4qIOje5g5fVLLZqIfjo/Qa8AHOCA2D2XNZif0ayll2C/hZSY
	MNU9HcAQ6e7e06vGv48R8J+C0eWnXToAJPthTTCPqgZ9s/2UloXwORYcyVLf4agKP1RYb3OdRyVDw
	K41Nb1jFCJB5c8/fBTgg2H655EwqUHjUxqIlVdscoskVexJANlJzgkad0ZUGv/n3Dzz95jJfljQ4N
	AsovKSAA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1urd3y-000000007pi-0obL;
	Thu, 28 Aug 2025 15:53:14 +0200
Date: Thu, 28 Aug 2025 15:53:14 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Dan Winship <danwinship@redhat.com>
Subject: Re: [nft PATCH] table: Embed creating nft version into userdata
Message-ID: <aLBfSlle-zZqLygE@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Dan Winship <danwinship@redhat.com>
References: <20250813170833.28585-1-phil@nwl.cc>
 <aLBRSR5AXpt5M_7x@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLBRSR5AXpt5M_7x@calendula>

On Thu, Aug 28, 2025 at 02:53:29PM +0200, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> I know this is applied, but one late question.
> 
> On Wed, Aug 13, 2025 at 07:07:19PM +0200, Phil Sutter wrote:
> > @@ -806,6 +815,29 @@ static int table_parse_udata_cb(const struct nftnl_udata *attr, void *data)
> >  	return 0;
> >  }
> >  
> > +static int version_cmp(const struct nftnl_udata **ud)
> > +{
> > +	const char *udbuf;
> > +	size_t i;
> > +
> > +	/* netlink attribute lengths checked by table_parse_udata_cb() */
> > +	if (ud[NFTNL_UDATA_TABLE_NFTVER]) {
> > +		udbuf = nftnl_udata_get(ud[NFTNL_UDATA_TABLE_NFTVER]);
> > +		for (i = 0; i < sizeof(nftversion); i++) {
> > +			if (nftversion[i] != udbuf[i])
> > +				return nftversion[i] - udbuf[i];
> > +		}
> > +	}
> > +	if (ud[NFTNL_UDATA_TABLE_NFTBLD]) {
> > +		udbuf = nftnl_udata_get(ud[NFTNL_UDATA_TABLE_NFTBLD]);
> > +		for (i = 0; i < sizeof(nftbuildstamp); i++) {
> > +			if (nftbuildstamp[i] != udbuf[i])
> > +				return nftbuildstamp[i] - udbuf[i];
> > +		}
> > +	}
> 
> One situation I was considering:
> 
> 1.0.6.y (build today) in the host
> 1.1.5 (build n days ago) in the container
> 
> This will display the warning.
> 
> I suggested to use build time only when version is the same?
> 
> If the scenario is nftables in the host injects tables into container,
> then host binary will likely be updated more often.
> 
> IIUC, the build time here will actually determine when the warning is
> emitted, regardless the version.

It should not:

Here's version_cmp() pseudo-code:

| for attr in NFTNL_UDATA_TABLE_NFTVER, NFTNL_UDATA_TABLE_NFTBLD:
| 	for idx in len(attr):
| 		if local_data[idx] != attr[idx]:
| 			return local_data[idx] - attr[idx];

This algorithm considers following bytes only if all previous ones were
identical. Precedence is from highest order version bytes to lowest
order build bytes (data is therefore stored in Big Endian).

So your version 1.1.5 will always be "newer" than 1.0.6.y, no matter the
build date, due to minor version 1 > 0.

Cheers, Phil
