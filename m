Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D148BA34
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Jun 2025 18:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748975728; cv=none; b=UKIbo/5UMfPlaHupvYxbaGbRR0GOZeki/JXdblP3w5sL6vdAp8DVBjUJCTrmWFOI4xl6BgriCzCcI8eqn/ot/Q2NamzS9rum8zerIBN78F0TZtE5ccrn7zbazT3TEwJv+htxRFKwweucxy9ORT1TR7AG7dzfeExOIvAbbFS9VSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748975728; c=relaxed/simple;
	bh=575FLBj013ZOFD/dy/njGQ2iX8l/cdLGuOkbCtPkiFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TFvYW0nzkRz/rF0E6ffJJQdsCN2qVL6fD03SM0BPj9fYqairxVOX3Z3sgiQrvLiZjcKiSnWfyEfRBhob9ZybKO1S+zgUWzXsSltLoJFzXxPh9s4eyMf7Q2g9yv1GUgOZDh2lQ8V6ZW5r56aErCxdmrpxNds1aghPPWqb42AUKZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=MeZ7+T1f; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="MeZ7+T1f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=wMsGUUUk6qlg+4JTR9DQCqd38Z7WRQd5pjcSN3GKYtw=; b=MeZ7+T1fBMAmwym6HHKup1Ah2h
	jbub2gMz6q2pe7IwxrxrtN2DVuW3rCo6Lr/rvW9Ms0GCQe+CyW68cRmTdthSJ48VXmdKdXoATO0oD
	4C4cd+eI8witXryuEbZPBAc15RJXv5PBqJliyFqZ4XC5SlDYlvy6V+4wEzSWlX7B5skPPxYgBEYM4
	v7Xs8EBbMJpFYY1nNNWm2Rv1RAACFDvjT14/x/IcjxCl97srboTOoU0JYtPSkWGPXbrAjpqDvpL62
	YZkY96KEW1oKwjGohMoI3Jyg9CXMiJEFabQ8FhlEvw8EpooLX2zuojXeyy3NG3s6cU+LkedbxdqdI
	lSRzbO3Q==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uMW9a-000000007PA-3FLl;
	Tue, 03 Jun 2025 20:14:26 +0200
Date: Tue, 3 Jun 2025 20:14:26 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] json: work around fuzzer-induced assert crashes
Message-ID: <aD87gslgK0kk5qzT@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20250602121254.3469-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250602121254.3469-1-fw@strlen.de>

On Mon, Jun 02, 2025 at 02:12:49PM +0200, Florian Westphal wrote:
> fuzzer can cause assert failures due to json_pack() returning a NULL
> value and therefore triggering the assert(out) in __json_pack macro.
> 
> All instances I saw are due to invalid UTF-8 strings, i.e., table/chain
> names with non-text characters in them.

So these odd strings are supported everywhere else and we only fail to
format them into JSON? According to the spec[1] this should even support
"\uXXXX"-style escapes. Not sure if it helps us, but to me this sounds
like a bug in libjansson. Or are these really binary sequences somehow
entered into nftables wich jansson's utf8_check_string() identifies as
invalid?

> Work around this for now, replace the assert with a plaintext error
> message and return NULL instead of abort().

The old code was active with DEBUG builds, only. If undefined, it would
just call json_pack() itself. Did you test a non-DEBUG build, too? I
wonder if json.c swallows the NULL return or we see at least an error
message.

Thanks, Phil

[1] https://www.json.org/json-en.html
