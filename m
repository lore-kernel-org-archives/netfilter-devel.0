Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF67A1A3BC8
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Nov 2024 10:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732183256; cv=none; b=CgS4aeS+q2NNlwz3DmPmY8tFApQ4QfhpqLTL+vSf9xzuJKAgbg4hSDrAoPBQG5V4JC9twkA/2rZSO7n4VMVl0ibT0CvJqIvMHcJFKoNRGepcEFs7JrANVCKR0JkaSdtyJdbwbS7hfVt1FWJ/q09k6Ps53JsCD3lG8pQfEzeVoBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732183256; c=relaxed/simple;
	bh=EKWxEHp1thfftTG3xQTAGVgW5MZ9EhZMn47FGAE029c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oQZjlVFr280OLbLtSpvlpV3IhZdtWJkiKY0q0BGyyOq6asYzFWuSiI/625MZS+y+N2ZXXRkz4f0FE5Mu+9IrEIdHQCRTS+6+hRxfUMgnQz3uU7gHRLq4oG8f7dTbu2NH5LTjo9pvtpAIuawirncfQAx9P+8jHHE6KOlN11ysbok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.39.247] (port=54340 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tE3zR-009IdK-Hv; Thu, 21 Nov 2024 11:00:48 +0100
Date: Thu, 21 Nov 2024 11:00:44 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] debug: include kernel set information on cache
 fill
Message-ID: <Zz8EzBW2kzaq4jXr@calendula>
References: <20241120100221.11001-1-fw@strlen.de>
 <20241120100221.11001-2-fw@strlen.de>
 <Zz5w6NPQ2XsJrpHG@calendula>
 <20241120233854.GB31921@breakpoint.cc>
 <20241121092427.GA12619@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241121092427.GA12619@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Thu, Nov 21, 2024 at 10:24:27AM +0100, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > >         set y {
> > >                 type ipv4_addr
> > >                 size 256        # count 128
> > >                 ...
> > > 
> > > We have to exposed the number of elements counter. I think this can be
> > > exposed if set declaration provides size (or default size is used).
> > 
> > OK,  I will update libnftl then because this means it will need
> > proper getter for nft sake.
> 
> There is a problem with this, shell tests break:
> 
> W: [DUMP FAIL]    9/430 tests/shell/testcases/sets/0057set_create_fails_0
> 
> cat /tmp/nft-test.latest.root/test-tests-shell-testcases-sets-0057set_create_fails_0.11/ruleset-diff
> --- tests/shell/testcases/sets/dumps/0057set_create_fails_0.nft 2024-11-21 09:46:16.888431831 +0100
> +++ /tmp/nft-test.20241121-101956.182.zWvUOZ/test-tests-shell-testcases-sets-0057set_create_fails_0.11/ruleset-after    2024-11-21 10:20:00.046431831 +0100
> @@ -1,7 +1,7 @@
>  table inet filter {
>         set test {
>                 type ipv4_addr
> -               size 65535
> +               size 65535      # count 1
>                 elements = { 1.1.1.1 }
>         }
> 
> As shell tests coud run on old kernel, regen dump file won't work.
> 
> Only options I see is to add a feature test file for this support,
> and then either disabling dump validation if it failed or adding
> additonal/alternative dump file.

Oh right, tests!

Probably tests/shell can be workaround to remove # count X before
comparing output.

It won't look nice, but I think tests/shell can carry on this burden.
This means # count N will not be checked in old and new kernels.

To validate # count N, we can still rely on tests/py and the debug
output as you propose.

Not great, but does this sound sensible to you?

Thanks.
