Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5262B9A8
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Mar 2025 16:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743438716; cv=none; b=LJQvD9KCNJUyfzfzRRqoAG3WwCsodQaxbTeOnYENBNccs9yzLGKu45v55hZDjHK9cNQn3Z09Kjn8wvjqnXY9UhtEVS+WFDQQX3K48s+zhOrFAJHjwnAFHRhjwplRnKWiZfUwkr7SlWJxI9EDSGjlnTc+svkj2xbHnEDXwF7c6MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743438716; c=relaxed/simple;
	bh=jwOt+64G6wHKFPa+1uMg4Z4vWXnGNyiifNqTZ6bwbsI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tsBQliFhFh7PLvuTtHjc1yilFrhStQhgA03t+tyGZkXWhRpE4bxjKwn2JczI08JWUv+KwsGEjAAsouLZgkuA8hRjH4thloTe9GU4DaiR8PWw8JevHokpLagmvsZmb96BJnFiVVM1SjaWzXdHN5kpo25DpE5dSvnWE8QUuFTi7+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=JA159cLA; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=R/9UbIbn; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="JA159cLA";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="R/9UbIbn"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id F17F160579; Mon, 31 Mar 2025 18:31:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743438711;
	bh=dUVStz6idntPK1NnFn3WNTJdf8zBzXv9dOVV0v2CO/E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JA159cLAY9rIAzN2dgaYJMo5ew/0Get6lhVpwwzSArvGonEl+PKkjvAYPPjFdbxjW
	 Ts3GteZ6+JzlCjgcfXdxlkmy0q/oXigfTrEez7zLkNvaAWFzXmBLHjFF/P9ceQ5nA2
	 35ymPdmIwoiPlu2UDmKWBAm/TWOqIqiY0PfevyCa7mQfvhfZ56gFPJ8TLVYxzDE7fa
	 ZYAJCnawCPmidSQeqVmnbbIt5EGKFdSrz74XVA/DegOmR8mu/vn95K29ovtL/P4hRt
	 mtvuA7T1VCEh6kQ/h6ZAP6RhnJIoApwB94stHa7GMTBWQWoXMmbLMhzWRk4k0si4a1
	 3a0VpAT/JiIgg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A094660571;
	Mon, 31 Mar 2025 18:31:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743438710;
	bh=dUVStz6idntPK1NnFn3WNTJdf8zBzXv9dOVV0v2CO/E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R/9UbIbnzbx5CRi40h23T1A103CVBVBDctL8evv9zP1ujX+wvF9SpQmSDKdnQ7sWh
	 b1yjdpgW+B5t/1Ddf/hKfP780IJQ+D4/cJXe/MoesN3A3zyxS5W53fCH5dc6ReG2ZN
	 hf1GAOo0e5Xs2zT4J4ZxcF4esb0/A2m6Pu5Z/lfDYLJ7a25IbhheQfdq/RmE82HqgD
	 Drx7towssQMcPT+1GyBfPbz86LTc+eUFVjtcnIcV4883a/W6d1cBgjYYIET1Di4Fhn
	 4Zy/tICZvq3ek9vmSvM3xnZD6OWPX00e4IT1+GEVSvcTLwPr4d546BFdpPp6yP1q0A
	 zOmkgR/momODw==
Date: Mon, 31 Mar 2025 18:31:47 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] evaluate: only allow stateful statements in set
 and map definitions
Message-ID: <Z-rDc1mdZSBif80q@calendula>
References: <20250331152323.31093-1-fw@strlen.de>
 <20250331152323.31093-2-fw@strlen.de>
 <20250331161530.GA19247@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250331161530.GA19247@breakpoint.cc>

On Mon, Mar 31, 2025 at 06:15:30PM +0200, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > The bison parser doesn't allow this to happen due to grammar
> > restrictions, but the json input has no such issues.
> > 
> > The bogon input assigns 'notrack' which triggers:
> > BUG: unknown stateful statement type 19
> > nft: src/netlink_linearize.c:1061: netlink_gen_stmt_stateful: Assertion `0' failed.
> > 
> > After patch, we get:
> > Error: map statement must be stateful
> 
> On the same subject of 'do I fix this in evaluate.c or parser_json.c':
> 
> cat bla
> table t {
>         set sc {
>                 type inet_service . ifname
>         }
> 
>         chain c {
>                 tcp dport . bla* @sc accept
>         }
> }
> nft -f bla
> BUG: unknown expression type prefix
> nft: src/netlink_linearize.c:914: netlink_gen_expr: Assertion `0' failed.
> Aborted (core dumped)
> 
> I can either fix this in evaluate.c, or I try to rework both
> parser_bison.y and parser_json.c to no longer allow prefix expressions
> when specifying the lookup key.

It is probably too complex from the parser in this case.

> I suspect that fixing it in evaluate.c is going to be a lot simpler.

I agree.

But for things that are obviously incorrect at parsing stage and that
are simple to reject, like the empty string case for goto/jump in
verdict map, then it is easy to reject early. The json parser already
rejects unexisting/unsupported keys, the parser is already making a
first pass in validating the input.

I don't think it is a matter of picking between validating _only_ from
parser or from evaluation, I think tightening from parser (when
trivial) and evaluation for more complex invalid input is fine.

> We can't disable prefixes in concatenations, its valid for set element
> keys, but I suspect that we can use recursion counter to figure out if
> the concatenation is on the RHS of something else (such as part of
> EXPR_SET_ELEM).
> 
> I'll work on it tomorrow.

Thanks!
