Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E718219CA8
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Oct 2024 21:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730324302; cv=none; b=cnj4HTDLpTcaXbiqFyodgdos7mZZ9ZI7qn/b9TxXPVL/gc8OWb0ceKjhsj5WpPm7SsdV2TLcDyB7v9nkzrdzyPcq4rVK4/6YCQB5kmFq1T3gn69g+pDs2qlPJVtx5pYbl/PYszLicPAmSqEvfxr6SBYbrQtR3QFVMaJaQIz+g94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730324302; c=relaxed/simple;
	bh=JYelWS0NvG5sezls5gtx/RM47QiJOyf3siLhzXxvfAg=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dC/0ezn41rmKtxPqQeeGXl96XNYivpH6pjaNfdi0hle9fsvIiCwUJjzSI9cy/2lzDGLaMPQGK9AJYN9UcT2XvC4Gwj7+xpUhnC8P1jZ4m42oxg5dhcoAMT7as8LCuCBYFMq8dUHIAAcF2ic0lmK4zuGwHNBnyL7+H1hrHMuPIc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=35156 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t6GOG-00CoD0-Hb; Wed, 30 Oct 2024 22:38:10 +0100
Date: Wed, 30 Oct 2024 22:38:07 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: monitor: fix up test case breakage
Message-ID: <ZyKnPxdGwh1X3AwT@calendula>
References: <20241029201221.17865-1-fw@strlen.de>
 <ZyJ4w02pdiv2LpvW@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZyJ4w02pdiv2LpvW@orbyte.nwl.cc>
X-Spam-Score: -1.9 (-)

On Wed, Oct 30, 2024 at 07:19:47PM +0100, Phil Sutter wrote:
> On Tue, Oct 29, 2024 at 09:12:19PM +0100, Florian Westphal wrote:
> [...]
> > diff --git a/tests/monitor/testcases/set-simple.t b/tests/monitor/testcases/set-simple.t
> > index 8ca4f32463fd..6853a0ebbb0c 100644
> > --- a/tests/monitor/testcases/set-simple.t
> > +++ b/tests/monitor/testcases/set-simple.t
> > @@ -37,9 +37,10 @@ J {"add": {"element": {"family": "ip", "table": "t", "name": "portrange", "elem"
> >  # make sure half open before other element works
> >  I add element ip t portrange { 1024-65535 }
> >  I add element ip t portrange { 100-200 }
> > -O -
> > -J {"add": {"element": {"family": "ip", "table": "t", "name": "portrange", "elem": {"set": [{"range": [1024, 65535]}]}}}}
> > +O add element ip t portrange { 100-200 }
> > +O add element ip t portrange { 1024-65535 }
> >  J {"add": {"element": {"family": "ip", "table": "t", "name": "portrange", "elem": {"set": [{"range": [100, 200]}]}}}}
> > +J {"add": {"element": {"family": "ip", "table": "t", "name": "portrange", "elem": {"set": [{"range": [1024, 65535]}]}}}}
> 
> This is odd: Why does monitor output reverse input? If nft reorders
> input, the test ("make sure half open before other element works") is
> probably moot anyway.

Because elements are collapsed in one single command.

  I add element ip t portrange { 1024-65535 }
  I add element ip t portrange { 100-200 }

and there is qsort() to search for interval overlaps.

this becomes one single command with { 100-200, 1024-65535 }

I have a patch to remove the overlap check using qsort() from
userspace which should remove this reordering, but it seems there is a
overlap case that kernel does not handle yet.
