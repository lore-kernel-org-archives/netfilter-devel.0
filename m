Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9610194AEB
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Oct 2024 18:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730312393; cv=none; b=GM5BA1rveKW4XXCLmLDJpyzRlAKUB7DPaLvQ9nYK5A+Rpqa+y8R5eqDmZH4FClmejJpLirlGewio11uvdGPdFObUqkkaNcMZoTNMAxCxHgqUMQJmiJZaSNaxnlnpBgzS577fNZrCV15qCYfykHh2T3Sc0k0d4iFEELbKCxhFJk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730312393; c=relaxed/simple;
	bh=WnCw8fssxCghn6bubGw+NeqcHlJ/eCYXrNbndT7pPgQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=juCpEPxFHSUwCF9sNz6LKvLQRqJ8wIRQ/zDXEwyDvbsdHTJ0ZSkxy4ZPw+pxXaRTb01TXSIYU8QxI5DTSnClM8Wi5iGnh5ixyPwH6HEV8/fZVnn8L63XbmlPjINOjpDBtF/j9uubi7bxaRcm0qLjPp/F8hUaJizDYHYc4ZRrrgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=lMQY0CVY; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="lMQY0CVY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=g4bUeoAGUm69ihl2URrDZrTcGavEf4XyNJFkUTINMrI=; b=lMQY0CVYZ0eTrHip6vofMMtlZO
	BpA63Mb2i4cFl/yK0OGQCUWM3KxPkOR1WP5JRaTS3IS2hO4FpHm5AcO5vKpQWKKU5IX9e6esuNF0h
	Y+zi/ZkjgHo3QHR6yF8tq7+bhPDfBx8VSDEh8sUDuREpqzu2hcMIlyawWcg9zTTXaT6/V8uevTs6P
	L9uy2K0HAmVy+5lT9NIMcPrnwYa9LKdVdN6RVMnCKZst+LonlJuQs597h5+P+4Qc8aziVZSMDHCpA
	q2SvfCRc1brpFYJ5d+dQEAnzEY2WfGTOgy3+fZNYn6uLI6ATpsl3oLeA9jWekoOuPvyUH/Ty2lQam
	aMAXZC+g==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t6DIJ-000000004Vo-0LQ1;
	Wed, 30 Oct 2024 19:19:47 +0100
Date: Wed, 30 Oct 2024 19:19:47 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: monitor: fix up test case breakage
Message-ID: <ZyJ4w02pdiv2LpvW@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20241029201221.17865-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241029201221.17865-1-fw@strlen.de>

On Tue, Oct 29, 2024 at 09:12:19PM +0100, Florian Westphal wrote:
[...]
> diff --git a/tests/monitor/testcases/set-simple.t b/tests/monitor/testcases/set-simple.t
> index 8ca4f32463fd..6853a0ebbb0c 100644
> --- a/tests/monitor/testcases/set-simple.t
> +++ b/tests/monitor/testcases/set-simple.t
> @@ -37,9 +37,10 @@ J {"add": {"element": {"family": "ip", "table": "t", "name": "portrange", "elem"
>  # make sure half open before other element works
>  I add element ip t portrange { 1024-65535 }
>  I add element ip t portrange { 100-200 }
> -O -
> -J {"add": {"element": {"family": "ip", "table": "t", "name": "portrange", "elem": {"set": [{"range": [1024, 65535]}]}}}}
> +O add element ip t portrange { 100-200 }
> +O add element ip t portrange { 1024-65535 }
>  J {"add": {"element": {"family": "ip", "table": "t", "name": "portrange", "elem": {"set": [{"range": [100, 200]}]}}}}
> +J {"add": {"element": {"family": "ip", "table": "t", "name": "portrange", "elem": {"set": [{"range": [1024, 65535]}]}}}}

This is odd: Why does monitor output reverse input? If nft reorders
input, the test ("make sure half open before other element works") is
probably moot anyway.

Cheers, Phil
