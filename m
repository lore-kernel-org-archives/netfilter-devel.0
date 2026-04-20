Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B62336EC0
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2026 17:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776707989; cv=none; b=t4IGfLcdN3w4AkdOr2aDLZHduE9aJkf0uOJxzg6PYw5yN6ZJSvy/bbPqG6SvAK0s1m5taLsv58+5I/UK0OoB9dso+OgZyDyQjYG6brsy1rMlCRNQ/lZd8vbWwUH23LpNCFwbaxflfIGuw1XJhCqGosDpuZ4Depc4yZMsZoGTtlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776707989; c=relaxed/simple;
	bh=n+MoRSBLbQcDX5EnPfdSzCcHI594EAszfh1XJtzcbfk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tCOABgJtFkib7B4wxlJZ9Xm8eqEoc/89NAeTuxaD4q8xDDRcNeDmzaWr7DNIX5RCKKW+PZ8PRY9QVBQYBdTpW2BCA2/tUdvF02vt+aKuCl2YIGSARVFFi3XTIowdV9EQMla99whXFzu7oR4yr4AZOeH5MhoEDB4OXQzJh4cyXIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=HVd1+u0Q; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="HVd1+u0Q"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id DE9E260251;
	Mon, 20 Apr 2026 19:59:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776707987;
	bh=b9r5tKZxpj2XvGdc3uUVQj5hcoi+n4W1An6UVwPgDnQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HVd1+u0Qifkw5cWg3Db4SjCqg6vQngY6qYL3OtqXx/67a6nv6a6fNENDdlAqmIvIg
	 QrqGNrE6CCpHFyokF12odpBOhKKhO6RqRIi8VgzqVDFRJ9Bm2Sby76+fsc3ekQUlt5
	 3GX8EGj1k53P+r1RJpueuGMd69yFz3kQgIoI46XzLp3wTeTprWnbb31H+roN0h95s+
	 zQtsjwdSQz6jLs56fNmlplNnbF7vzC/2l+NCaklwsCmHoq3cVNYQTaWK/aVSfh9FK5
	 NQZ3SJx2DQ4317sfXWKCXbQAvn2vejQRTlvbeHZykjYMjOkugy7eToDthLy4Qs5lZg
	 8xlvJM/oACrlA==
Date: Mon, 20 Apr 2026 19:59:43 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_compat: run checkentry() from .validate
Message-ID: <aeZpj9r368paudyZ@chamomile>
References: <20260420174227.13087-1-pablo@netfilter.org>
 <aeZoiqyPFP0NJkz9@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aeZoiqyPFP0NJkz9@strlen.de>

On Mon, Apr 20, 2026 at 07:55:22PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Several matches and one target check that the hook is correct from
> > checkentry(), however, the basechain is only available from
> > nft_table_validate().
> > 
> > This patch calls checkentry() for matches and targets from the
> > nft_compat expression .validate path for the following matches/target:
> 
> I worry that this is fragile.  Not all ->checkentry callbacks are pure.
> Some create /proc entries or bump reference counts.

xt_set does bump the reference count. This calls xt.destroy to restore it.
I am only calling them for the list of expression you mentioned.

> > +		if (!strcmp(target->name, "TCPMSS")) {
> 
> This is missing "SET".

I can add this.
