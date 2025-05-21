Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAAD221732
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2025 17:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747847963; cv=none; b=BU9G/gOL5bdk25jAVHqtXtYWGPp6/zKKLJAGoMS/fOPfPLjAgjLZI8bTOGbSAp9ZK5PhG0z/7DVcugk7cgjafFZBhwoZ6U6eG1pbmg16b/lY96//4xIgcDy9+s2TFFZUVfJeUscdQ9hB0bQpp+aUn1C+lWr+qVr3kdfy455Vzbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747847963; c=relaxed/simple;
	bh=wAb27xMZ9PTA/OeA7pb5IjbbI2qkr++C5NBspUNbVls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VEVq9JpA8ycZot0ckoV29NX+4rBVm/RiyvJQsojrzpufdgB2Xh/E0HOVaOqIZGTxPENeS+VOa7byBvKkXy378fS8j7H7QZO5htSQ3ynrtStdo0t/DXeGE+nHyiCgPEP9lOm75jLD8tmCOjT+LpE6dCj4TzeX6iV2SG/y2WUnbLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=kp0XY3A9; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="kp0XY3A9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Z9cTN2/6sNnz8FikAIPToPhoWI5Zb5+oyuK0+Flotww=; b=kp0XY3A9lJTGeSg9un9ZIL8LVb
	XE2pSVEK1gGpoo9zBFn2ZZoOFhjdGP6Tq5OpppErbHMESCmQezjXhL96u/kLmBdklr3KIXzwzdN9R
	0Hyi8h0b6iGbaUDcpsvPvDQq21XLQCMS+EVjjiSweCvQYowKGQOeXAAs7FU+fy3+7cctOxX83Pb0V
	7RoHbbS945+ilUiPq3XJ7GbobnNAv8FrDwQEYtK2k0uiXl/hju0Pewnt3/fiRTwSGR38rxrFW6rLQ
	OBLlwY04Aqn08WUCH8P4+sc/OerojmiRs3+pTvL6Yo5KA1oWsMx1V+WyKsitsDEqeHEwBRpv1j70/
	DwRXbwkw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uHn67-000000004uU-0V8i;
	Wed, 21 May 2025 19:19:19 +0200
Date: Wed, 21 May 2025 19:19:19 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 3/4] netlink: Keep going after set element parsing
 failures
Message-ID: <aC4LF_xAVp9WIMLe@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20250521131242.2330-1-phil@nwl.cc>
 <20250521131242.2330-4-phil@nwl.cc>
 <aC3gjbdJ_z8gewqd@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aC3gjbdJ_z8gewqd@calendula>

On Wed, May 21, 2025 at 04:17:49PM +0200, Pablo Neira Ayuso wrote:
> On Wed, May 21, 2025 at 03:12:41PM +0200, Phil Sutter wrote:
> > Print an error message and try to deserialize the remaining elements
> > instead of calling BUG().
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  src/netlink.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/src/netlink.c b/src/netlink.c
> > index 1222919458bae..3221d9f8ffc93 100644
> > --- a/src/netlink.c
> > +++ b/src/netlink.c
> > @@ -1475,7 +1475,9 @@ int netlink_delinearize_setelem(struct netlink_ctx *ctx,
> >  		key->byteorder = set->key->byteorder;
> >  		key->len = set->key->len;
> >  	} else {
> > -		BUG("Unexpected set element with no key\n");
> > +		netlink_io_error(ctx, NULL,
> > +			         "Unexpected set element with no key\n");
> > +		return 0;
> 
> If set element has no key, then something is very wrong. There is
> already one exception that is the catch-all element (which has no
> key).

Yes, in these cases the ruleset parser fails and the output is very
likely broken or at least incomplete. This series merely aligns error
handling: Take netlink_parse_cmp() for instance: If NFTNL_EXPR_CMP_SREG
attribute is missing or bogus, netlink_error() is called and the
function returns (void). No error status propagation happens (which we
could change easily), but most importantly the parser continues to
deserialize as much as possible.

> This is enqueuing an error record, but 0 is returned, I am not sure if
> this is ever going to be printed.

It does: Forcing the code to enter that third branch, listing a set with three
elements looks like this:

% sudo ./src/nft list ruleset
table ip t {
	set s {
		type inet_service
	}
}
netlink: Error: Unexpected set element with no key

netlink: Error: Unexpected set element with no key

netlink: Error: Unexpected set element with no key

> I am not sure this patch works.

Well, that extra newline is indeed a bug. :)

Cheers, Phil
