Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856713D3304
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Apr 2026 14:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775657532; cv=none; b=Gfotu8UouCsWIIIt5Nigl95bgzmHchmqg2H4p1exIEd5KiBerDhVNktd+NbZe5Rjhpm9w26Ok4LtLie/soyvRD1SvdMnxS1PsOser68ctT+X/5mkyCQ+mEhTCV0+RqyWU5YO5NBpWkiSO0EmWrFto9fpKnNPGJi94PsrzuUJqUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775657532; c=relaxed/simple;
	bh=K9ieUjYbDBMqZKltftnrsH7MwPRGTVxnwtZS1MSZ+zs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LPp0+9KeUPuNv5fCvCEmT5ct6q30zJ+JLn0B3cA1oHTMtwMnlcrtEqb507IDP8U6i4nP0XbxQmTmU8V/udAvxtwHLPE2naJ1hVdFS/XnuVuQBf6i9NVRjnH/hwdXQ8DAvheUWJbPo0WZFmBDIBdH9NJXv2L3DFpeYdqTfdBEhZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=o0OGah6d; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="o0OGah6d"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 96D2E6017D;
	Wed,  8 Apr 2026 16:12:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1775657525;
	bh=zVpw5f2C8z8g7TLx99LrF4RNqTu3/Oo/ou2fmRS/4t8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o0OGah6drMOITm/3jQAEZ7HIFS8c3Vh7jHAMWjwEB1f1S97VDsAd8VQjvP3xx6l0o
	 f2tMCN4KMFvKlZtPewNewHl2SU44oKrnqQWrW0BsKU2orUuCRtCyrIIyQGU+xmxi6s
	 CR/T9U/mzqpyX2mz4DfE3uXjtYVlxRjqCGOiekIZ4oRAhjciosluIp0D2fPejYbOwb
	 P0IcNucEKnwTkkg0SNgH9chQ4NBRXNOT1vq+Y4hO3VIrTxjek4//fNJAVXWneAa9hE
	 3OTonnTAwRqWnhxAvMcDfXtpAyWEuVl1CnvhiKYeUkglgwXrak2A4Rr5/+vGmk+5kC
	 2X2TIJKQauIsw==
Date: Wed, 8 Apr 2026 16:12:02 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, phil@nwl.cc
Subject: Re: [PATCH nft 1/5] libnftables: report EPERM to non-root users with
 -f/--filename
Message-ID: <adZiMtndiQnSaLZw@chamomile>
References: <20260408115922.48676-1-pablo@netfilter.org>
 <20260408115922.48676-2-pablo@netfilter.org>
 <adZEAkrcCcXEau_1@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <adZEAkrcCcXEau_1@strlen.de>

On Wed, Apr 08, 2026 at 02:03:24PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Similar to 3cfb9e4b3e40 ("src: report EPERM for non-root users").
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  src/libnftables.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/src/libnftables.c b/src/libnftables.c
> > index 66b03a1170bb..e3218da9f48f 100644
> > --- a/src/libnftables.c
> > +++ b/src/libnftables.c
> > @@ -767,8 +767,13 @@ static int __nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename
> >  		nft_optimize(nft, &cmds);
> >  
> >  	rc = nft_evaluate(nft, &msgs, &cmds);
> > -	if (rc < 0)
> > +	if (rc < 0) {
> > +		if (errno == EPERM) {
> > +			fprintf(stderr, "%s (you must be root)\n",
> > +				strerror(errno));
> > +		}
> >  		goto err;
> > +	}
> 
> Hmm, should the library leave stderr alone?

This can be handled instead from src/main.c
