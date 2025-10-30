Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E004B1A3BD7
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 10:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761819661; cv=none; b=IUI/f7ft/dyBrvq3LuHhz5PtH0hLC/KzueivDU2i05rZ93O/aSVDOtxAPuI0E/5q3seuAI6c/eccM3/R4B5F43yFQ9CahwuPuW6q3dw9FJvAiNGAr905HTn1oJK/+bNztcP9CypKU78Uee0jfLyGMRCGf9BZNprvjI7iPNSlJAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761819661; c=relaxed/simple;
	bh=u/NICECUdSGwz1yLDdlxNqGXBI2Rb3SAhvEE6dxym3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RJpC9Iwm+C9C4qDsZnKc1guoKhyRXgUv7Op23iNPWeFI+Z1GKONvCHitErXkIHs9OTO/GY2IUS9+eQKvFqtOyT+ZomUI+7Uvgb9LOJAo9rpynt27+H73g+zH7ao0Mv0GY9oL4aOvVLbmtcJxG9g1o/8fgibKUT7TS3AhSWqC3RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=UX+DE2J5; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="UX+DE2J5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=EcUx6Q1Oa0N/puOQCvMA4ZccCFGspjGUktn8CVSRqPM=; b=UX+DE2J5f+IIQSGEiBBYax/B/m
	wqYVUnvsNhWERx79+13pBDZ31tMYvxrF7zG4c58sc9/tASiC4hKRnKE833uLTLcXucgy6fq3s+EYN
	xmxK7q+mBt3PtTyER25H9X2oKQRkpliaDQHW6PLTDLx5d5q8DrRqkeeZ02fE7txnKEOLcb5kr84VA
	OrBIKn0yS1ovbz0tsZXLmq74kO7iMhO5PPMeTbfJNdurb4XbHiYLcGR+6jhoKBrcj7tTtD4SynYLI
	0uLe2e53FLv5pF/Ot1W2Yh20yKUGfnZvGe+y3pKJwjvaNUItDQp6HH1IRt7giORWL9h84lK0BC280
	ecQCSSJA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vEPm6-000000000hk-0iuc;
	Thu, 30 Oct 2025 11:20:58 +0100
Date: Thu, 30 Oct 2025 11:20:58 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 13/28] Define string-based data types as Big Endian
Message-ID: <aQM8CuKscWyhWGgq@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20251023161417.13228-1-phil@nwl.cc>
 <20251023161417.13228-14-phil@nwl.cc>
 <aQJbciPngSX4qNpq@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQJbciPngSX4qNpq@calendula>

On Wed, Oct 29, 2025 at 07:22:42PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Oct 23, 2025 at 06:14:02PM +0200, Phil Sutter wrote:
> > Doesn't quite matter internally, but libnftnl should not attempt to
> > convert strings from host byte order when printing.
> > 
> > Fib expression byte order changes with NFT_FIB_RESULT_OIFNAME to Big
> > Endian.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  src/ct.c                  |  2 +-
> >  src/datatype.c            | 10 +++++-----
> >  src/evaluate.c            | 18 +++++++++---------
> >  src/fib.c                 |  5 +++--
> >  src/intervals.c           |  5 -----
> >  src/json.c                |  2 +-
> >  src/meta.c                | 16 ++++++++--------
> >  src/mnl.c                 |  2 +-
> >  src/netlink.c             | 12 +++++-------
> >  src/netlink_delinearize.c | 14 +++++++-------
> >  src/osf.c                 |  3 +--
> >  src/parser_bison.y        | 10 +++++-----
> >  src/parser_json.c         |  4 ++--
> >  src/segtree.c             | 10 +++++-----
> >  14 files changed, 53 insertions(+), 60 deletions(-)
> > 
> > diff --git a/src/ct.c b/src/ct.c
> > index 4edbc0fc2997f..e9333c79dfd42 100644
> > --- a/src/ct.c
> > +++ b/src/ct.c
> > @@ -273,7 +273,7 @@ const struct ct_template ct_templates[__NFT_CT_MAX] = {
> >  					      BYTEORDER_HOST_ENDIAN,
> >  					      4 * BITS_PER_BYTE),
> >  	[NFT_CT_HELPER]		= CT_TEMPLATE("helper",	    &string_type,
> > -					      BYTEORDER_HOST_ENDIAN,
> > +					      BYTEORDER_BIG_ENDIAN,
> 
> No, this is not big endian, this is confusing.

I agree, it is confusing. Maybe we could use BYTEORDER_INVALID for it?
No idea if that would work or not, though. Since string values are
always in the same ordering despite host's byteorder,
BYTEORDER_HOST_ENDIAN is certainly not correct, either.

Cheers, Phil
