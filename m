Received: from mail-06.mail-europe.com (mail-06.mail-europe.com [85.9.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EEB39B48D
	for <netfilter-devel@vger.kernel.org>; Sun, 18 Oct 2026 05:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.9.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792301017; cv=none; b=nMMnifpQWRktb2uj0CYB9kw3XWeVGDD/Iwv7byNN89Av7Zhlcwg1OJUKXNnaSx380Bk3YIx21C/ClHVwzPlOgw0ZrrjLiGUs4HUQlNrq+jINqgXr4yw2k/U2HelICny+8qrrPNaqBqwHD9Dr0eUm/jYysDydqrjoeFu106Oq/5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792301017; c=relaxed/simple;
	bh=Nzvjq8zNOEf0oWeHgR+CLNT6/KslMBF4SUzQ/gIlT5k=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n1/AbSDI6t2vM5rx8AcHzEW91BKT8nyprRPs27R53KWuJv9MuRlP+o0/jZdkuhCi/Vmp2dR3umUqbltP0hDv7spjeISjjRU5gLh/v9asbg3/qziPeDNpuMsSLP401nZ41y+d13rm+BDo6lknUID5slph4L4Qwrj5zlF9dmEaBss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=000ty.net; spf=pass smtp.mailfrom=000ty.net; dkim=pass (2048-bit key) header.d=000ty.net header.i=@000ty.net header.b=wS4hi4fK; arc=none smtp.client-ip=85.9.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=000ty.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=000ty.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=000ty.net header.i=@000ty.net header.b="wS4hi4fK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=000ty.net;
	s=protonmail2; t=1792300996; x=1792560196;
	bh=Nzvjq8zNOEf0oWeHgR+CLNT6/KslMBF4SUzQ/gIlT5k=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=wS4hi4fKlVgB2EUWboqlfakfUGRMx76HhtV4juQO+7ZG2y9m079QDjYlBooUyEk1L
	 NNpwSzzQ1d1ytaDQgb4TGHLUPE8I9L01EY07wGRVdUszo7hHge0V/65oWRstPdcX/a
	 B9Xx8lSsT79v/dZiLhKShG5kT5xZDnom3mwuDpBTAkE8+NR6NUYp/YweHjAiDALPJI
	 v4J6F0IJQkur6dCimz2wWvF6qqN/uLhXLdrWbkqabVq3bF35CKAlmrEat2gZs9+lL+
	 BjjCcEk8QEPoPA+27J5rG4vIfDmmDCycDuVs8jzmtkSmYkvxtoRlBzVFMcBPt39Sw1
	 ePnTncJhvVl7g==
Date: Sun, 18 Oct 2026 05:23:10 +0000
To: fw@strlen.de
From: Tamaki Yanagawa <ty@000ty.net>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, phil@nwl.cc, coreteam@netfilter.org, linux-kernel@vger.kernel.org, ty@000ty.net
Subject: Re: [PATCH nf] netfilter: ipset: restore element before rescanning cidrs on seqcount retry
Message-ID: <20261018052302.29330-1-ty@000ty.net>
In-Reply-To: <atRROQfgdeGSIU5s@strlen.de>
References: <20261018035205.1008-1-ty@000ty.net> <atRROQfgdeGSIU5s@strlen.de>
Feedback-ID: 168296199:user:proton
X-Pm-Message-ID: 0196e58bf501f01a747e4ee5d0476a807cac6e88
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Florian Westphal <fw@strlen.de> wrote:
> Is this a real world encountered bug or an LLM finding?

An LLM finding (Claude, hence the Assisted-by tag), I haven't hit it in
production. I did confirm it on a KVM guest though: a hash:net set with
10.0.0.0/29 and 11.0.0.0/8, an "iptables -m set --match-set s dst" rule,
a loop adding and deleting 172.16.0.0/12, and UDP traffic to 10.200.3.4.
70 out of ~9.5M packets matched the rule in 60 seconds without the fix,
none with it.

> Why do we need to do this instead of not masking @d in place to begin
> with?

No good reason, your version is cleaner. I'll send a v2 that works on a
local copy and constifies the reset_elem helpers.

Thanks,
Tamaki

