Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389BAEC0
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Mar 2025 03:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741233144; cv=none; b=k/SaKYG4fyespI6+d4La0O9VLJm8kqjkMoWlFa+gTAMmnSjwfgwU7/6KUqn+NDPrWIVtwcibYdYIQmvvztHd5TkHE7Vj0elJ1hHcyKIr+9/7gg9LxYer+l/bifWPvKZ+YZdqsl42hxtC3DOG645IrsI66rfQ+icYFPg76P+xNlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741233144; c=relaxed/simple;
	bh=6vJ5pgC1J/uNAbYD5ItQ4kbUtxTkSpYIybPhQrwihog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fwF1dBM9vh7jsYUTRVVBvSELa9mxWM2EVTNyX7VmP2xmcl3zwcPmHB5dJzl2F3YbycuDWtqQm8HTc9OLFc+4MXTPwqCXiRxfi012+nzL2xL1BKzmktMDRlmSxSFey0iXDQMrPVwQn8Sqby+SD2mKYZvmI3G80feoUHCdn2qAXIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tq2HU-0006pG-B8; Thu, 06 Mar 2025 04:52:20 +0100
Date: Thu, 6 Mar 2025 04:52:20 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] segtree: fix string data initialisation
Message-ID: <20250306035220.GA26082@breakpoint.cc>
References: <20250305150154.19494-1-fw@strlen.de>
 <Z8jMXkcOOKzsyELF@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8jMXkcOOKzsyELF@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Mar 05, 2025 at 04:01:48PM +0100, Florian Westphal wrote:
> > This uses the wrong length.  This must re-use the length of the datatype,
> > not the string length.
> > 
> > The added test cases will fail without the fix due to erroneous
> > overlap detection, which in itself is due to incorrect sorting of
> > the elements.
> > 
> > Example error:
> >  netlink: Error: interval overlaps with an existing one
> >  add element inet testifsets simple_wild {  "2-1" } failed.
> >  table inet testifsets {
> >       ...       elements = { "1-1", "abcdef*", "othername", "ppp0" }
> > 
> > ... but clearly "2-1" doesn't overlap with any existing members.
> > The false detection is because of the "acvdef*" wildcard getting sorted
> > at the beginning of the list which is because its erronously initialised
> > as a 64bit number instead of 128 bits (16 bytes / IFNAMSIZ).
> 
> One question here.
> 
> > Fixes: 5e393ea1fc0a ("segtree: add string "range" reversal support")
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  src/segtree.c                                |  2 +-
> >  tests/shell/testcases/sets/sets_with_ifnames | 62 ++++++++++++++++++++
> >  2 files changed, 63 insertions(+), 1 deletion(-)
> > 
> > diff --git a/src/segtree.c b/src/segtree.c
> > index 2e32a3291979..11cf27c55dcb 100644
> > --- a/src/segtree.c
> > +++ b/src/segtree.c
> > @@ -471,7 +471,7 @@ static struct expr *interval_to_string(struct expr *low, struct expr *i, const m
> >  
> >  	expr = constant_expr_alloc(&low->location, low->dtype,
> >  				   BYTEORDER_HOST_ENDIAN,
> > -				   (str_len + 1) * BITS_PER_BYTE, data);
> > +				   len * BITS_PER_BYTE, data);
> 
> BTW, is this also needed?
> 
> diff --git a/src/segtree.c b/src/segtree.c
> index 2e32a3291979..b7a89383fae0 100644
> --- a/src/segtree.c
> +++ b/src/segtree.c
> @@ -453,7 +453,7 @@ static struct expr *interval_to_string(struct expr *low, struct expr *i, const m
>  {
>         unsigned int len = div_round_up(i->len, BITS_PER_BYTE);
>         unsigned int prefix_len, str_len;
> -       char data[len + 2];
> +       char data[len + 2] = {};
>         struct expr *expr;
>  
>         prefix_len = expr_value(i)->len - mpz_scan0(range, 0);
> 
> otherwise uninitialized data could be send to the kernel?

No, I don't think so, data is filled with len bytes:

       mpz_export_data(data, expr_value(low)->value, BYTEORDER_BIG_ENDIAN, len);

So I don't see the reimport to fetch anything that was onstack garbage.
