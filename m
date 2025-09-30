Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035952222C0
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Sep 2025 10:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759229439; cv=none; b=gKmFlKQMp1zdAB1Zd6mL3nFSnbIIA6EAJalwIIwmGTgcsbJF8aqA9o3sK1aepbSlaxp8qulVk7Mz5MUniCLI+ryZTd9aopImmyMRtgGBIpQ6pU/U8UzQa7dvKZERLiHSRxQpFAY56pVVmVVIhB5IZgQJ6PSAWg95eo+9uImmGc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759229439; c=relaxed/simple;
	bh=DXS4VnDuNwF2xxVezU/MP0/AgU92RzpeS8du2mYYBYM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p7Yx1o3Oy624B0aq/zvFfTiPF9QtRroxn17gNiu3vXjdfcaraaxnJXGLZA3UFXXtD7mjCa/lJHN0to45kqBZ1hgRY2tLIhKZ0vWnXiHFkTGuq9FC+sH/ootDtUvr6nU9e8jxupjeuydIgLT7OMcXkVwL4Ej4k/BgRPSUIjff4VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BA6C860326; Tue, 30 Sep 2025 12:50:34 +0200 (CEST)
Date: Tue, 30 Sep 2025 12:50:34 +0200
From: Florian Westphal <fw@strlen.de>
To: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/7] doc: fix/improve documentation of verdicts
Message-ID: <aNu1-kwUzXGXyNLJ@strlen.de>
References: <aNTwsMd8wSe4aKmz@calendula>
 <20250926021136.757769-1-mail@christoph.anton.mitterer.name>
 <20250926021136.757769-3-mail@christoph.anton.mitterer.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250926021136.757769-3-mail@christoph.anton.mitterer.name>

Christoph Anton Mitterer <mail@christoph.anton.mitterer.name> wrote:
> -*accept* and *drop* are absolute verdicts -- they terminate ruleset evaluation immediately.
> +*accept* and *drop*/*reject* are absolute verdicts, which immediately terminate

This isn't correct, strictly speaking, as 'reject' is not a verdict.
The only verdicts accessible from userspace are accept and drop.
(and queue, but thats a historic wart that should not be mentioned).

'reject' is also not the only statement that ends rule/basechain evaluation,
other examples are redirect/dnat/snat/masquerade which will internally
issue an accept verdict.  Or synproxy, which will drop internally to
consume the incoming packet.

> +.*counter* will get executed:
> +------------------------------
> +… counter accept
> +------------------------------
> +
> +.*counter* won’t get executed:
> +------------------------------
> +… accept counter
> +------------------------------

Thanks, this is a big improvement.

> +*drop*/*reject*:: Terminate ruleset evaluation and drop/reject the packet. This
> +occurs instantly, no further chains of any hooks are evaluated and it is thus
> +not possible to again accept the packet in a later chain, as those are not
> +evaluated anymore for the packet.

As above, reject isn't a verdict, it will 'drop' internally. Its also
not a 'drop' alias (it sends a reply packet).

Maybe the 'REJECT STATEMENT' section can be extended a little, but I
think its ok as-is.

> +*return*:: In a regular chain that was called via *jump*, end evaluation of that
> + chain and return to the calling chain, continuing evaluation there at the rule
> + after the calling rule.


Maybe we should mention that 'return' is the implicit thing at the end
of a user-created non-base chain?

Or do you think thats self-evident?

> + In a regular chain that was called via *goto* or in a base chain, the *return*
> + verdict is equivalent to the base chain’s policy.

No, its not.
I think this warrants an example.

chain two { ... }
chain one {
	...
	goto two
	ip saddr ..   # never matched
}

chain in {
	hook input type filter ...
	jump one
	ip saddr .. # evaluated for all packets not dropped/accepted yet
}

-> base chain calls 'one' and remembers this location
-> 'one' calls 'two', but doesn't place it on chain stack.
-> at the end of 'two' / on 'return', we resume after 'jump one', not
   after 'goto'.

The sentence wrt. base chain policy is valid in case 'chain in' would
contain 'goto one', as it doesn't remember the origin location,
end-of-one / return is equal to explicit 'return' from the base chain.

> +*jump* 'CHAIN':: Continue evaluation at the first rule of 'CHAIN'. The position
> + in the current chain is remembered and evaluation will continue there with the
> + next rule when 'CHAIN' is entirely evaluated or a *return* verdict is issued in
> + 'CHAIN' itself.
> + In case an absolute verdict is issued by a rule in 'CHAIN', evaluation
> + terminates as described above.
> +*goto* 'CHAIN':: Similar to *jump*, but the position in the current chain is not
> + remembered and evaluation will neihter return at the current chain when 'CHAIN'
> + is entirely evaluated nor when a *return* verdict is issued in 'CHAIN' itself.

Maybe it should say that it will instead resume after the last jump (if
there was any?, or not at all (base chain policy executes?)
