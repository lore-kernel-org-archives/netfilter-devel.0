Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA1E2116EE
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Jun 2025 21:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750886373; cv=none; b=tbSaqkaryMhmCG3CSsTgyLvID8P5tvOgZJTug8FJksr321s21TR4NHMOhNGx4MfInVRKWYFET38MYce4i5mwniPu5HiNL5K4MWzDqXia1jMkglJ8QO+wMc6Q3h/zLhn4mtK5oSbbaBw6u9X15rWOznKlpv4lRd06Xb3ES0yJvg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750886373; c=relaxed/simple;
	bh=RiYpRgW1aYRnYekBg4FEck9PMhHivwHms7yJVETZyQE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qaZmKidHSUe6WkdfY1/15pIM04IMAOmcK+WNpReW6giHxHcXZI3dESihSMJdtoFY6ODspGicSTBf7UQs7ndRvDnl+7emVUIsm1Iz9zbQC0MaJCDmMeUTuRznNQNrAPKh7qIGevXoOu5yDVT03HEm8BdxdIjzZ6TQJOr7FqflMgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nagAi3eu; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gkqwixjD; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nagAi3eu";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gkqwixjD"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 2AB786026C; Wed, 25 Jun 2025 23:19:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750886369;
	bh=YWHG4W+SI4H/p5+icfGR8fQSdnvu9pf/td9zpZML/oo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nagAi3eumiaq78pndVSCH3p9cCRuZaG9SCBPUc5K3pbP3PFucWGJJQKr6bP7bvS7T
	 ZIkElH12jRh9LgDwbMT+kwNoTrW7HCKFcu1ZEBTwArigsYA1ZWMaXh+Svp1pD1NlY/
	 vZGifDmLrqqNWK8bE7qQFyK9LMsTQWueKt2ByvMLbwAk9qKx+BolZmr0jiLIBVq8+s
	 IIFet4ADHTBV4uj1052+gNMX0xYI82JV1ZtQVi3esM6kZVF4WfSSwZETXpo7zjBTr0
	 qSBvWS7FcMvIwCSkp0cjRMy+cDrU/7ozBrAEPHPhG5kaQb9mqxhjvNHVDYJadj26Sp
	 17D75CfgOdX9g==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 861FA6026C;
	Wed, 25 Jun 2025 23:19:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750886368;
	bh=YWHG4W+SI4H/p5+icfGR8fQSdnvu9pf/td9zpZML/oo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gkqwixjDO5IJrzP53NRS6Fl98BvC2maJuQwT0T+EFmQ5zAYlw4tz3Z9i1TCA7k/5J
	 UUHoz2vl8AAYJt5wYZkFf7R2FNXpRFHZUHxtCKrCumHtHGeDjY5y02R5uB0/vKi4zn
	 Plon2UhAnny/5Y6YaNAPbZ4RKFeZoVPre3ZFN9tq1SGTX/w9F+M6V28/SXWDHNvHQg
	 S3wkU6TN32TJIxWTtGS0j2+yUfeO1Ph/F+S3qI8KnMNCcwxy5D0w+ZtEHcBsXBprb2
	 P7I/MqA6H42pEn/al4oymhkYw5fIQGyg/NOlpcVTMaY7Eo/PGOqdAr06PnPTZxn6JO
	 R3lMbtPb1ixuw==
Date: Wed, 25 Jun 2025 23:19:25 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: avoid double-free on error handling of
 bogus objref maps
Message-ID: <aFxn3Q9SFnsOkWYg@calendula>
References: <20250624212101.18722-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250624212101.18722-1-fw@strlen.de>

On Tue, Jun 24, 2025 at 11:20:58PM +0200, Florian Westphal wrote:
> commit 98c51aaac42b ("evaluate: bail out if anonymous concat set defines a non concat expression")
> clears set->init to avoid a double-free.
> 
> Extend this to also handle object maps.
> The included bogon triggers a double-free of set->init expression:
> 
> Error: unqualified type invalid specified in map definition. Try "typeof expression" instead of "type datatype".
> ct helper set ct  saddr map { 1c3:: : "p", dead::beef : "myftp" }
>                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> This might not crash, depending on libc/malloc, but ASAN reports this:
> ==17728==ERROR: AddressSanitizer: heap-use-after-free on address 0x50b0000005e8 at ..
> READ of size 4 at 0x50b0000005e8 thread T0
>     #0 0x7f1be3cb7526 in expr_free src/expression.c:87
>     #1 0x7f1be3cbdf29 in map_expr_destroy src/expression.c:1488
>     #2 0x7f1be3cb74d5 in expr_destroy src/expression.c:80
>     #3 0x7f1be3cb75c6 in expr_free src/expression.c:96
>     #4 0x7f1be3d5925e in objref_stmt_destroy src/statement.c:331
>     #5 0x7f1be3d5831f in stmt_free src/statement.c:56
>     #6 0x7f1be3d583c2 in stmt_list_free src/statement.c:66
>     #7 0x7f1be3d42805 in rule_free src/rule.c:495
>     #8 0x7f1be3d48329 in cmd_free src/rule.c:1417
>     #9 0x7f1be3cd2c7c in __nft_run_cmd_from_filename src/libnftables.c:759
>     #10 0x7f1be3cd340c in nft_run_cmd_from_filename src/libnftables.c:847
>     #11 0x55dcde0440be in main src/main.c:535
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
