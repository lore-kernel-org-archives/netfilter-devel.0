Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B53E2E426A
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Oct 2025 13:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760622761; cv=none; b=lXG83mLQeC97+YS4qha+B/HpDYZnHDwsXON8PSy91hk7PW6apGwlhi7pJbjFCaDaY7HZ6/Ji8RvbUUGOKwZkIVL3eKzlIFDL2nDzvNeeVlxuMcZu3XQE857d26Zwt+h63o78QR6sx2xAM7xh+YO7419qw3Ex27KyeoKHBwTZ+hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760622761; c=relaxed/simple;
	bh=lGSpjSF5rxwvvRNwoLweA+5Q+HX7xL2sQdN/H7XuE6I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B2u2EwTpFl/GAk7S/QKkr5+ZAjv2oZcZF35mUYuI7b6/XrLby4yOAV8aY64achHuOlYirCQnkYJq20DoO0hUH6BlrfT91h6LoWaJPSTvZMzkfDuYZPnYJOnLh/Flk3l9Flf76oA2rGeI++JYRDplZwR/UFJ0nllTeerNxD26RIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QcKqUdCp; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QcKqUdCp; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QcKqUdCp";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QcKqUdCp"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C54ED6026F; Thu, 16 Oct 2025 15:52:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1760622749;
	bh=acneQzlj1Yb7FYqRF9ugu6D+vUKBdjAACdevc7Pznb4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QcKqUdCpX0cfuHB/6FNwf87rQ1W3DfbFesMcNmrY25Pad/bgAh1WQV0h1tkAWU1xV
	 pqaygDy2OqY/GEnsOwAGjH8T7JRaiUn7d/YoQD13XPxQ5T6fuKBGzEcNsfNGbpFfSg
	 c2LOvbp1QXyg3iizcZy9Y6LlWbVjV7/DUkWrSg3RwYy/AN10waoRWd7LEZVrJtNgzG
	 Tx9n782jbKOLrTKryxNapnoUM4zXo1JJYYhTQejhlYs413oNACmkTbn/ifHeioWLiA
	 VTMFba/TxhpnkRnXtVIVFwekpr8ZZmfq9tZ9gWCQ6vY6YIcgwEILSTOcHml+ljon1I
	 JEhaGUApRizxg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E3E6A6026B;
	Thu, 16 Oct 2025 15:52:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1760622749;
	bh=acneQzlj1Yb7FYqRF9ugu6D+vUKBdjAACdevc7Pznb4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QcKqUdCpX0cfuHB/6FNwf87rQ1W3DfbFesMcNmrY25Pad/bgAh1WQV0h1tkAWU1xV
	 pqaygDy2OqY/GEnsOwAGjH8T7JRaiUn7d/YoQD13XPxQ5T6fuKBGzEcNsfNGbpFfSg
	 c2LOvbp1QXyg3iizcZy9Y6LlWbVjV7/DUkWrSg3RwYy/AN10waoRWd7LEZVrJtNgzG
	 Tx9n782jbKOLrTKryxNapnoUM4zXo1JJYYhTQejhlYs413oNACmkTbn/ifHeioWLiA
	 VTMFba/TxhpnkRnXtVIVFwekpr8ZZmfq9tZ9gWCQ6vY6YIcgwEILSTOcHml+ljon1I
	 JEhaGUApRizxg==
Date: Thu, 16 Oct 2025 15:52:26 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH] utils: Introduce nftnl_parse_str_attr()
Message-ID: <aPD4mgdtY4DjLrEH@calendula>
References: <20251015202436.17486-1-phil@nwl.cc>
 <aPDQljEef_EXGmFy@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aPDQljEef_EXGmFy@strlen.de>

On Thu, Oct 16, 2025 at 01:01:42PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Wrap the common parsing of string attributes into a function. Apart from
> > slightly reducing code size, this unifies callers in conditional freeing
> > of the field in case it was set before (missing in twelve spots) and
> > error checking for failing strdup()-calls (missing in four spots).
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  include/utils.h         |  3 +++
> >  src/chain.c             | 33 +++++++++------------------------
> >  src/expr/dynset.c       | 12 +++++-------
> >  src/expr/flow_offload.c | 12 +++++-------
> >  src/expr/log.c          | 13 ++++---------
> >  src/expr/lookup.c       | 12 +++++-------
> >  src/expr/objref.c       | 18 ++++++++----------
> >  src/flowtable.c         | 24 ++++++++----------------
> >  src/object.c            | 14 ++++++--------
> >  src/rule.c              | 22 ++++++----------------
> >  src/set.c               | 22 ++++++----------------
> >  src/set_elem.c          | 38 +++++++++++++-------------------------
> >  src/table.c             | 11 +++--------
> >  src/trace.c             | 28 ++++++++++------------------
> >  src/utils.c             | 15 +++++++++++++++
> >  15 files changed, 106 insertions(+), 171 deletions(-)
> 
> Nice compaction.
> 
> Acked-by: Florian Westphal <fw@strlen.de>

I started different infrastructure to compact this, I can rebase at
some point on top this if Phil is having time to make cleanups.
