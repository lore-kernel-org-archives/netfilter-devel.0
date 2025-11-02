Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3670027FB1F
	for <netfilter-devel@vger.kernel.org>; Sun,  2 Nov 2025 12:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762087327; cv=none; b=l38zG0bHhMKj++s3vaha3+y9BK1MIVQlEac6S1hssgpULRyz8X8J1tWqLCS+y8/rbYKeN62rUA1bu2q9lNfk1mXw8+JDVPS5OHGluKPcReju+bLyKhnKLqZ/PNjFmW7y9DGIjqD8ZR12ZeTiu0Inzc5BcOcICFdh2Iep1UvNLUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762087327; c=relaxed/simple;
	bh=v+P479KKbalj2y2D1EcAF3SekoNp1jxmIVnnmWrOnms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WNDY4YX/qEGPUsaFlE3a191BuUzoq5c3BWIx8ysORAlDcZ+Hjl+VCyGTd98m28U4ZZvp/5uYYcGL72qsRHbb42RcsFyAdQ23+eqw6UMpDIwVdVO45wf7XLQSUM7sOWhDH3g9dneKuzDKGgyl4wTYKhbt8RKNwHbJX92M3OFvs4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 213896029A; Sun,  2 Nov 2025 13:41:56 +0100 (CET)
Date: Sun, 2 Nov 2025 13:41:48 +0100
From: Florian Westphal <fw@strlen.de>
To: Alexandre Knecht <knecht.alexandre@gmail.com>
Cc: netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH v2] parser_json: support handle for rule positioning
 in JSON add rule
Message-ID: <aQdRjC4HJmjMStrI@strlen.de>
References: <20251029003044.548224-1-knecht.alexandre@gmail.com>
 <20251029224530.1962783-1-knecht.alexandre@gmail.com>
 <20251029224530.1962783-2-knecht.alexandre@gmail.com>
 <aQNBcGLaZTV8iRB1@strlen.de>
 <aQNNY-Flo9jFcay3@strlen.de>
 <CAHAB8WyByEKOKGropjHYFvz=yprJ4B=nS6kV6xyVLm0PWMWbYQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHAB8WyByEKOKGropjHYFvz=yprJ4B=nS6kV6xyVLm0PWMWbYQ@mail.gmail.com>

Alexandre Knecht <knecht.alexandre@gmail.com> wrote:
 Export/import scenario (handles are metadata):
>   {"add": {"rule": {"family": "inet", "table": "test", "chain": "c",
>                     "handle": 4, "expr": [...]}}}
>   → Handle 4 is ignored, rule appended
> 
> Explicit positioning:
>   {"add": {"rule": {"family": "inet", "table": "test", "chain": "c",
>                     "position": 2, "expr": [...]}}}
>   → Rule added after handle 2
> 
> What do you think about this approach? I can implement it if you agree it's
> the right direction.

I think its a sensible strategy, yes.

Reactivating the handle is a no-go as it will break existing cases.

Could you also add a test case that validates the various relative
positioning outcomes?

i.e. given:

rule handle 1
rule handle 2
rule handle 3

- check that positinging at 1 results in
rule 1
rule N
rule 2
rule 3

- check that positining at rule 1 results in

rule 1
rule N2
rule N
rule 2
rule 3

- check that positinging at rule 1 will fail
in case that rule was already deleted.

- check that positinging at rule 2 will insert
after handle 2 and not N2.

My only question is how "Position" is treated with insert (instead of
add).

It should NOT be ignored, it should either be rejected outright (and
everywhere its not expected) or it should have different meaning, ie.
prepend (insert occurs before the given handle).

