Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09D41ABEB4
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Nov 2024 15:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732201964; cv=none; b=a98cCuC6MXYaMpm520Ttri65A9/FaLC5Dcu5LopubRJl3DIGtIei6MS0XiAUOOBS+1b51EumPms1XoUasLSAZ0r2V4Bw8GIymhlA2rw1sLy/23d5fg2VdJGJy0d6m7enKhNWdotP8wjFZSEuiSN+o9+b6Ejoy5pskR4AC7ACnMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732201964; c=relaxed/simple;
	bh=Y0LAWQ10pejoapC+9RjrTrZ97R0/5BBfnd6Lu2R7Mfw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ocYLGKxQVVUmJ9jO6KBTStuZtPgRfZ0RfmHOeOLEmDXHT351Sa5qv53YWKCtEkREQwT+2uygfWuMpZ9EqKHRHO6IGuKUF+2Yq9KXoeq3EZ4J6+wzfBXbaC2smnfnqmxxAW5bTQtvuXj+qR7KZtLJq8uyZ1Kj9kvwucvJCwZLwIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.39.247] (port=40136 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tE8rC-00AkR2-3u; Thu, 21 Nov 2024 16:12:36 +0100
Date: Thu, 21 Nov 2024 16:12:32 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] debug: include kernel set information on cache
 fill
Message-ID: <Zz9N4CmuiLxQpaAH@calendula>
References: <20241120100221.11001-1-fw@strlen.de>
 <20241120100221.11001-2-fw@strlen.de>
 <Zz5w6NPQ2XsJrpHG@calendula>
 <20241120233854.GB31921@breakpoint.cc>
 <20241121092427.GA12619@breakpoint.cc>
 <Zz8EzBW2kzaq4jXr@calendula>
 <20241121120242.GB12619@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241121120242.GB12619@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Thu, Nov 21, 2024 at 01:02:42PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Only options I see is to add a feature test file for this support,
> > > and then either disabling dump validation if it failed or adding
> > > additonal/alternative dump file.
> > 
> > Oh right, tests!
> > 
> > Probably tests/shell can be workaround to remove # count X before
> > comparing output.
> > 
> > It won't look nice, but I think tests/shell can carry on this burden.
> > This means # count N will not be checked in old and new kernels.
> > 
> > To validate # count N, we can still rely on tests/py and the debug
> > output as you propose.
> > 
> > Not great, but does this sound sensible to you?
> 
> 1. Add new feature test
> 2. Update dump files to include "# count xxx"
> 3. when diff -u fails, do postprocess on recorded
>    dump file, i.e. sed s/# count.*//g 
> 4. repeat diff with postprocessed recorded dump
>    if ok -> ok, else dump failure
> 
> Does that sound ok?

OK, still one more aspect I'd like to discuss.

> AFAICS we only need to update < 10 dump files,
> so churn is not too bad.
>
> Alternative is to always store postprocessed
> dumps and then always run sed before diff, but I think
> its better to do the extra mile.

rbtree going leaks a raw count of independent interval values which is
going to be awkward to the user.
