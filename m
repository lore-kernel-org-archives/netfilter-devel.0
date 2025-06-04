Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769A71624DD
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Jun 2025 15:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749051654; cv=none; b=m5Eb22w/Nr/T9dTE3LKBobSbwkS2LJNF/VTRpCj5QRMA1fWgmj/thoiuv+e1eN1IXtFLH0KZvE7MjA+skiPgSxT20KWC5I8uQVKczjLDcpakILjyiehmjmwcUwu6OYD2edeWopLVK6WcUAFnFRb5OxBOUKfvJ7X9UQHhiFEeUvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749051654; c=relaxed/simple;
	bh=QzJt+g/egkBYNzSw6YBnyky3nr1aQwOPkaCXsBGqujU=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YElEi7mrHRWaNsh5lZTx3v3GypjJv//U84qoovswQ2Hz9jgKGRJOvbRaUunHBtBHqwIbqqmkXfBpA+8wqx+qzoKqUJJ5TWw+o3nt4SqZ8+jSWFNqWiFxHSZrOxFQDnXfmoCwfcRGTtzJ74lpmoznKSLPaqktUNAluBfPCTU4NLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=hUyxsE5K; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="hUyxsE5K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ymVcIoC0hGy0ICXUBjGqQ3bEezDOd7N90ffqqitrl7Q=; b=hUyxsE5Kij98Fww+yFZZMy7OE8
	Nm6SkX6aMIPUXeP9t+FmIE5RSqk5vkirNrk2jA3ZvTE0WgHzjQmIRngYkuWmKRqvWeW5pDr1D3hE7
	0CADtE4UH+9qaUL7fOUgNaIyuDQ3lm27eui2SapRij19nXbg9iJa4u+ljbQ0XqgQGy/I3dMX1vRpr
	kF2iFQTjvYI2TPGoj6+tOBOayWw9OHTy2VH4oBJ11HJAV7IfEYITROyoxXvqFFeQ0YlmUrejizRG1
	0K6TDh31lExwCI3wCR5PIcPI+GrXMJmIFQ+unIutZEN6J7f4KHYAeH0UXbfuOE0ApZzL+oc+qlKr7
	PNn5LrPg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uMqET-000000005Zk-1J3z;
	Wed, 04 Jun 2025 17:40:49 +0200
Date: Wed, 4 Jun 2025 17:40:49 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] json: work around fuzzer-induced assert crashes
Message-ID: <aEBpAUZBwuQn1Imn@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20250602121254.3469-1-fw@strlen.de>
 <aD87gslgK0kk5qzT@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aD87gslgK0kk5qzT@orbyte.nwl.cc>

Hi,

On Tue, Jun 03, 2025 at 08:14:26PM +0200, Phil Sutter wrote:
> On Mon, Jun 02, 2025 at 02:12:49PM +0200, Florian Westphal wrote:
> > fuzzer can cause assert failures due to json_pack() returning a NULL
> > value and therefore triggering the assert(out) in __json_pack macro.
> > 
> > All instances I saw are due to invalid UTF-8 strings, i.e., table/chain
> > names with non-text characters in them.
> 
> So these odd strings are supported everywhere else and we only fail to
> format them into JSON? According to the spec[1] this should even support
> "\uXXXX"-style escapes. Not sure if it helps us, but to me this sounds
> like a bug in libjansson. Or are these really binary sequences somehow
> entered into nftables wich jansson's utf8_check_string() identifies as
> invalid?
> 
> > Work around this for now, replace the assert with a plaintext error
> > message and return NULL instead of abort().
> 
> The old code was active with DEBUG builds, only. If undefined, it would
> just call json_pack() itself. Did you test a non-DEBUG build, too? I
> wonder if json.c swallows the NULL return or we see at least an error
> message.

So for testing purposes, I built a json_pack() wrapper which
occasionally returns NULL (and does not assert()). This causes almost
all py testsuite tests to fail, obviously due to JSON dump differences.

Piping the non-empty ruleset-after.json files into json_pp shows no
errors, i.e. if we get any JSON output it is valid at least.

Looking at testout.log of those tests with rc-failed-dump status, I
don't see error messages related to JSON output. So catching the NULL
return is definitely necessary, also with non-DEBUG builds. Hence:

Acked-by: Phil Sutter <phil@nwl.cc>

Thanks, Phil
