Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820101946A0
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Oct 2024 22:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730326894; cv=none; b=WNLaENyNV0oNRVEwpK3JQ5Yjwc/8PvfgWUL0II+1YKF5nssDzAhSliFiIiSEJL1IlSHTqTT38pEGZv3rugoe1bdalQ0m3lQHHKBD/0uF/Gtoq4bg+yCArGCtLztqruYs/fx3AOhbKjtRoMKjw4dW5Za5WSezcLc1etHlv/MWIQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730326894; c=relaxed/simple;
	bh=nMBdfGnUO8m0TjCnEg14iAPLMcIaIfwY7CtgtglAkjE=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tcjAzmpWx0LE1dRTf+vdncW005vbN1I10r/+/hr+/CeOg8WfZRd/Os5IIT/ba/iv+FmMN6Vgk+V/GD3KH0nA1WZFsab0kK66o+0aYcGlQL6q5UP/YKElsQJhJhk3qGt5zdf8Js56P4lHtEFM6lua+Vir4xnwtaVs05t9dFaBdHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=36286 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t6H49-00CwXD-KP; Wed, 30 Oct 2024 23:21:27 +0100
Date: Wed, 30 Oct 2024 23:21:23 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: monitor: fix up test case breakage
Message-ID: <ZyKxY6WZJrKioMDt@calendula>
References: <20241029201221.17865-1-fw@strlen.de>
 <ZyJ4w02pdiv2LpvW@orbyte.nwl.cc>
 <ZyKnPxdGwh1X3AwT@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZyKnPxdGwh1X3AwT@calendula>
X-Spam-Score: -1.9 (-)

On Wed, Oct 30, 2024 at 10:38:11PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Oct 30, 2024 at 07:19:47PM +0100, Phil Sutter wrote:
> > On Tue, Oct 29, 2024 at 09:12:19PM +0100, Florian Westphal wrote:
> > [...]
> > > diff --git a/tests/monitor/testcases/set-simple.t b/tests/monitor/testcases/set-simple.t
> > > index 8ca4f32463fd..6853a0ebbb0c 100644
> > > --- a/tests/monitor/testcases/set-simple.t
> > > +++ b/tests/monitor/testcases/set-simple.t
> > > @@ -37,9 +37,10 @@ J {"add": {"element": {"family": "ip", "table": "t", "name": "portrange", "elem"
> > >  # make sure half open before other element works
> > >  I add element ip t portrange { 1024-65535 }
> > >  I add element ip t portrange { 100-200 }
> > > -O -
> > > -J {"add": {"element": {"family": "ip", "table": "t", "name": "portrange", "elem": {"set": [{"range": [1024, 65535]}]}}}}
> > > +O add element ip t portrange { 100-200 }
> > > +O add element ip t portrange { 1024-65535 }
> > >  J {"add": {"element": {"family": "ip", "table": "t", "name": "portrange", "elem": {"set": [{"range": [100, 200]}]}}}}
> > > +J {"add": {"element": {"family": "ip", "table": "t", "name": "portrange", "elem": {"set": [{"range": [1024, 65535]}]}}}}
> > 
> > This is odd: Why does monitor output reverse input? If nft reorders
> > input, the test ("make sure half open before other element works") is
> > probably moot anyway.
> 
> Because elements are collapsed in one single command.
> 
>   I add element ip t portrange { 1024-65535 }
>   I add element ip t portrange { 100-200 }
> 
> and there is qsort() to search for interval overlaps.
> 
> this becomes one single command with { 100-200, 1024-65535 }
> 
> I have a patch to remove the overlap check using qsort() from
> userspace which should remove this reordering, but it seems there is a
> overlap case that kernel does not handle yet.

I can also revert the patch if you don't like, but it is saving _a
lot_ of memory from userspace for the silly one element per line case.
