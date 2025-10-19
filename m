Received: from panther.cherry.relay.mailchannels.net (panther.cherry.relay.mailchannels.net [23.83.223.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E367426ACC
	for <netfilter-devel@vger.kernel.org>; Sun, 19 Oct 2025 01:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760839096; cv=pass; b=BvhMKzsA7sTxr1t3jhEUz7CoVj8RDSMpnpSMQ44TaMqbHO1aLp00lJqlH53LyNddu03eJCzgwAXWmSaBKPw2/tFPpy/0N/Tiezwir9+VWeSSQR9lt0njgbEy7rJwz/nHLhjdPUGV8mfDEunePrzKQfzoPiboRTR5DYcNbKS8INQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760839096; c=relaxed/simple;
	bh=TpY4IlaGaECVOWMV4KmS0rhgh3pQbJeCYARqyxyhUS4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oAOq/yqr65iVFMIhsuAOTuNKx7luP2nhnLI6NApHK269C3pKTnfCIwuyom1H5GT5QnxfNMOGkSAeY6jhsO7EVDKAvlAlgDYLjYmoObDrheJjzE+Twlz1eAUJSlWtIQjheRo4vGUrAsY9Tu88SD8Zzh4L9wR1qOuJMImeLLqtpE0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=christoph.anton.mitterer.name; dkim=fail (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b=nvuMj6mq reason="key not found in DNS"; arc=pass smtp.client-ip=23.83.223.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b="nvuMj6mq"
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 6E3B7102290;
	Sun, 19 Oct 2025 01:31:42 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (trex-green-9.trex.outbound.svc.cluster.local [100.119.71.185])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 717FF1022B9;
	Sun, 19 Oct 2025 01:31:37 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1760837498; a=rsa-sha256;
	cv=none;
	b=CI7sG2N2fLKfVCI1bsSpFjSuQhS9iDgUQ8G2RBtCcQdHrUVdIH80mSyB7KiRaZ9ub3IDd3
	Ge8fzATLEk5deiRb9TjAqeK3kTEUAvqDuWkW1OcVNA7h9qnzbqOpWc0A4MrsOTBhmU6kvH
	7+WnDeMXx/mLhZKjrt9EOmvZcqvzlK2KQF2Cay3MdYna8fHXX2wGhO3X0Fq4A7WZRMcZ/D
	5bESYOrzO9YxUfmbZvgQsFLe9hXpBxcZGol9VQwyxLIkoGI5yBCBe+wGFy31zZ0LhQQzUj
	3F+YYxxe1YrBEawqLl5xVaFLCrxWYxX0AfZ/Y5HxEVSjPnmL3/fzNWp2ti7R6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1760837498;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hqWKY218HfY3++iCGYNhrkhmHzNqNxW6iwlGQ9aUXrc=;
	b=ExFSEBZ4cgkN1ZoF9CusECq9NoPTq3kTpT0fZ+WFul/km6k5dL+bNUCGzl4dlsbNkYw5LV
	PpZBIiKyUGB8lw2hwfX9+0jQMAYUHGJ/OTxc2RQHkepgza2E1dXGHrtcR6rLwlrp6fluvW
	cN61jDszsb69IQ3jtUvOC1UdbdGirf+BsqibYPrs8XaG98RB52iSlid8o9zVaIDE3/r3K7
	BnP+32/FNXuH/MlboRxgwDjmhfjeaUs21um/rbEky5SQXnlzFkJj+uXIya2B1acHxJJz21
	jgvmEEVmwCSVf/I19ITSAEW9MHqqE2wS1nAzH0+kpUCS6gJRmcfAGZNOOcbwKQ==
ARC-Authentication-Results: i=1;
	rspamd-6c854d7645-7ffz2;
	auth=pass smtp.auth=instrampxe0y3a
 smtp.mailfrom=mail@christoph.anton.mitterer.name
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MC-Relay: Neutral
X-MailChannels-SenderId:
 instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MailChannels-Auth-Id: instrampxe0y3a
X-Juvenile-Industry: 1072a0d673e81c7f_1760837502271_3268739191
X-MC-Loop-Signature: 1760837502271:2897603663
X-MC-Ingress-Time: 1760837502271
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.119.71.185 (trex/7.1.3);
	Sun, 19 Oct 2025 01:31:42 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=christoph.anton.mitterer.name; s=default; h=MIME-Version:
	Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From
	:Subject:Message-ID:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=hqWKY218HfY3++iCGYNhrkhmHzNqNxW6iwlGQ9aUXrc=; b=nvuMj6mqGUhV
	pPPS4KFtqMXKXtCGURw0NiUR/l8OCYhqv7mRrXPnnOIGCss97rG8MHRXLEV2qpZ7IQdV7lxaiWDYE
	Y4B61ysVhEhRPloOby1n8TUy7z3lzmy14JWWHJWWsWxnN6klc3pysYFKkherxCUr3QSvXQkIS4OOQ
	lNEufdKlffdH8qIwwK3qih4vuyoF25Rq1nQ/xiR5cXJmYUEMAmAHb5i6fP3YGlVe3iaTClg+zc26t
	dBdhYL5q3JI2vwzG2WBSKbkF/W2loBBYyb+WdANvxN0EN2ca1JWNuQ1mv2gXRqTgqlchWk5Jzq3zu
	05te5Qnnn6IXrmYC6Cvjfg==;
Received: from [212.104.214.84] (port=11491 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <mail@christoph.anton.mitterer.name>)
	id 1vAIGo-0000000DROe-1DCw;
	Sun, 19 Oct 2025 01:31:35 +0000
Message-ID: <baa47c4b75a89776515f48ab57f276ee3331a2cd.camel@christoph.anton.mitterer.name>
Subject: Re: [PATCH v2 5/7] doc: add some more documentation on bitmasks
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Date: Sun, 19 Oct 2025 03:31:34 +0200
In-Reply-To: <aPOW0GaNACeKqTgX@strlen.de>
References: <6bb455009ebd3a2fe17581dfa74addc9186f33ea.camel@scientia.org>
	 <20251011002928.262644-1-mail@christoph.anton.mitterer.name>
	 <20251011002928.262644-6-mail@christoph.anton.mitterer.name>
	 <aPOW0GaNACeKqTgX@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-5 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-AuthUser: mail@christoph.anton.mitterer.name

On Sat, 2025-10-18 at 15:32 +0200, Florian Westphal wrote:
> > +It should further be noted that *'expression' 'bit'[,'bit']...* is
> > not the same
> > +as *'expression' {'bit'[,'bit']...}*.
>=20
> Maybe add another sentence, something like:
> Note that *'expression' 'bit'[,'bit']...* is not the same
> as *'expression' {'bit'[,'bit']...}*.=C2=A0 The latter constitutes
> a lookup in an anonymous set and will match only if the set
> contains an exact match.

I did that now, with some minor changes (noting that it's the same for
named sets) and changing "an exact match" to "exactly one value that
matches" (which I think makes the differences to bitmask matching a bit
clearer)...
... but that now kinda overlaps with the "See <<SETS>> above." above,
which - before squashing the two patches as you've asked for in the
other mail - was added in:
   doc: describe how values match sets
I still let that in, but added an "also" to it.


> And/or maybe also include an example involving tcp flags to make it
> clear.
Done.

Though I think the two sections SETS and BITMASK now overlap a bit... I
kinda liked it more when BITMASK only mentioned that the two are
different, and referred to SETS for the actual description.
What do you think?

(We should however definitely keep the new example, but then perhaps
also rather in SETS?!)


> Do you=C2=A0 think a reference to "nft describe tcp flags" should be made=
?
> There is normally no reason to muck with the raw values (or even a
> need
> to know that new is 0x1).

With respect to the difference in how sets vs. bitmasks are matched...
I rather don't think it would be necessary.

But I think it would be nice to have it in general, not only for
getting the true integer values (which are arguably only rarely
needed,... perhaps only to check thinks like "which ICMP type is that
actually compared to the RFC)... but also for getting all the symbolic
names.



One more thing that we should perhaps tackle:
LEXICAL CONVENTIONS says:
> Identifiers begin with an alphabetic character (a-z,A-Z), followed by
> zero or more alphanumeric characters (a-z,A-Z,0-9) and the characters
> slash (/), backslash (\), underscore (_) and dot (.).


Not sure if identifiers here mean also e.g. set/var names... but at
least set names also seem to allow '-'.

And as mentioned previously, unlike claimed in the wiki (which says 16
chars is max) set names seem to be allowed pretty long names (I think
I've stopped at 100 chars)... which is actually quite helpful, so
please don't restrict ;-)


> Identifiers using different characters or clashing with a keyword
> need to be enclosed in double quotes (").

Maybe I'm misunderstanding something here... but at least it doesn't
seem to work to create a set like with:
   set "foo@bar" {
   =E2=80=A6
   }


Cheers,
Chris.
