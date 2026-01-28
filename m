Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556F62877E8
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Jan 2026 12:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769602296; cv=none; b=W8EvpQaw5Ux33FkVTnwcFlSSGsqGjjQz1Xb9Jid/rBlvv3VWdSzsVokkwB+yu7cqTb0wYOGZEKZZSj1R5T3tkkeHS98a78FhnTJWM7zzVsXawWw0wRC1k5w+hyqrVLuFZ65KwZzBL0dS7YAwvDgfN+hbPP+3npEOMSFBPmbzXMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769602296; c=relaxed/simple;
	bh=12XU9Qh6TNoi/c3UmoYQS+f1bT4FZBVPn+O/juNVWXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HRRarjlh8++NMIszWNzj9T2RE87t/7YyYkcCNnzAI9y+fttNLUT6zIwlTdB6fcHXE1DabKmOEWgDkm6iOlXiFzeFWsfyM8wAmvsY0XHQGiwsweAsl8+N51nDT2+V885mXqcIu4vG7rab96160dvgeZtg1fT9yKA157vkyesJAv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=lDchUcjN; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="lDchUcjN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7/ISuZhOhQ+yxuGh3GVZjVFNC4N0Q0T2Ot74o3woGV8=; b=lDchUcjNbOBg6jP+E/BcMxPiX4
	imLrsNuO2hDAzgEODq1ITte3vqeJEjcnG/Skti0S9s4sCF/vJrJjOzMyclY6fyVxQPxrsvYJbRpNy
	U0u0uwV2eUvw1ZnXU8Lun192xm2ci/NZXLYgOf19M5rIm1GwEzijRv8nyAfyvlEqgl3kaa0FaMZBl
	i4ghr58FBFJ6SLZTYZbYKNeVXW95NgMm8px49BfbbO7L53Y9ktoQ9crXQNEv38qgVcKIj0l88fTDg
	/IumVVLOx/nbLKbdAAzRQtMgnLR04MC9w3aXVtDckoz1q+Xk+bdXttHvkIooqxVGjNa0buSMeeiRq
	UpQS+QSg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vl4OT-000000003CT-2tsD;
	Wed, 28 Jan 2026 13:11:33 +0100
Date: Wed, 28 Jan 2026 13:11:33 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2 02/11] mergesort: Fix sorting of string values
Message-ID: <aXn89RA9apxGSXd_@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20251114002542.22667-1-phil@nwl.cc>
 <20251114002542.22667-3-phil@nwl.cc>
 <aXlKECq5p9SUYuJO@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXlKECq5p9SUYuJO@chamomile>

On Wed, Jan 28, 2026 at 12:28:16AM +0100, Pablo Neira Ayuso wrote:
> On Fri, Nov 14, 2025 at 01:25:33AM +0100, Phil Sutter wrote:
> > Sorting order was obviously wrong, e.g. "ppp0" ordered before "eth1".
> > Moreover, this happened on Little Endian only so sorting order actually
> > depended on host's byteorder. By reimporting string values as Big
> > Endian, both issues are fixed: On one hand, GMP-internal byteorder no
> > longer depends on host's byteorder, on the other comparing strings
> > really starts with the first character, not the last.
> > 
> > Fixes: 14ee0a979b622 ("src: sort set elements in netlink_get_setelems()")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  src/mergesort.c                               |  7 +++
> >  tests/py/any/meta.t.json.output               | 54 -------------------
> >  tests/py/any/queue.t.json.output              |  4 +-
> >  tests/py/inet/osf.t.json.output               | 54 +++++++++++++++++++
> >  .../testcases/maps/dumps/0012map_0.json-nft   | 20 +++----
> >  .../shell/testcases/maps/dumps/0012map_0.nft  |  8 +--
> >  .../maps/dumps/named_ct_objects.json-nft      |  4 +-
> >  .../testcases/maps/dumps/named_ct_objects.nft |  4 +-
> >  .../sets/dumps/sets_with_ifnames.json-nft     |  4 +-
> >  .../sets/dumps/sets_with_ifnames.nft          |  2 +-
> >  10 files changed, 84 insertions(+), 77 deletions(-)
> > 
> > diff --git a/src/mergesort.c b/src/mergesort.c
> > index a9cba614612ed..97e36917280f3 100644
> > --- a/src/mergesort.c
> > +++ b/src/mergesort.c
> > @@ -37,6 +37,13 @@ static mpz_srcptr expr_msort_value(const struct expr *expr, mpz_t value)
> >  	case EXPR_RANGE:
> >  		return expr_msort_value(expr->left, value);
> >  	case EXPR_VALUE:
> > +		if (expr_basetype(expr)->type == TYPE_STRING) {
> > +			char buf[expr->len];
> > +
> > +			mpz_export_data(buf, expr->value, BYTEORDER_HOST_ENDIAN, expr->len);
> > +			mpz_import_data(value, buf, BYTEORDER_BIG_ENDIAN, expr->len);
> > +			return value;
> > +		}
> 
> This is also used for automerge, not only get_setelems().
> 
> Are you sure this is correct?

If it isn't, we don't have test coverage for the broken code-path.

Cheers, Phil
