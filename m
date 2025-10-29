Received: from bisque.elm.relay.mailchannels.net (bisque.elm.relay.mailchannels.net [23.83.212.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CE223372C
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2025 00:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.212.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761697191; cv=pass; b=mlHsgFULsJHBLr17I8/q4ZOmswIFL9+2vzKA3ahUpbxU40OzyAQA86oWlTLcwK+yFhXoWVDfw2u+gURhMlxcXBxpEAwYaUSMsVMNYdih3ZyUIWszRIq6Oc4xha1X/ewgrfQnNZh70ahJkDUaFs7Ns5+tVwzPv7m3pQO8P03AkTM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761697191; c=relaxed/simple;
	bh=3Bc+4YXRkH3bsKntL+Q2DE7m45nmq5LNBElyaBAL2Sc=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lZIHAwP40OSP1qv60pVJEfcRPrZGoeN8SiPKFf8TtdVzm9ZYal3gBQ9lQUT9o2jl3SYHRI9cH9FT9cqx6bPO1LX7rRT4dGpxbZOeQVdIDBICJw9hglkeKtDqq6T9jfTcMNJPymIEI07mZj2OFXZhKp4KomysRp6Xe7xeVsxrODc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name; spf=pass smtp.mailfrom=christoph.anton.mitterer.name; dkim=fail (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b=NOIcfReQ reason="key not found in DNS"; arc=pass smtp.client-ip=23.83.212.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=christoph.anton.mitterer.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=christoph.anton.mitterer.name header.i=@christoph.anton.mitterer.name header.b="NOIcfReQ"
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id D8D2D8A1354;
	Wed, 29 Oct 2025 00:19:43 +0000 (UTC)
Received: from cpanel-007-fra.hostingww.com (100-120-36-240.trex-nlb.outbound.svc.cluster.local [100.120.36.240])
	(Authenticated sender: instrampxe0y3a)
	by relay.mailchannels.net (Postfix) with ESMTPA id 04AEB8A13B5;
	Wed, 29 Oct 2025 00:19:42 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761697183; a=rsa-sha256;
	cv=none;
	b=Ok2hF6lDfHilM4nzpF1W6mOeLmIA0dPJb40BC0FzQfP9ELXQ/jvqVsOjoRqBsJ2ZFuQE0m
	mD3A7ODeIEmX4Xs105xc23D7DBSsDeNep8H4GU+aR3iIklaX8LGod4WlyYjAWJumwJckFr
	bfMm2qEVPhi6IefX//1u78sBxbpyQ/LZlFC0HIzbpB8QyahdyC0RPXnkKD7acJNY8EmWXE
	y5AuxblkDQXdL6QegVIbd+b5FhsPYl4hFMgN6WIxsHmLrQSRDRVt8fiYY8XZre9kP2t5fV
	2iDDJur3HNyhMrzecglkvIkAkIak1DgST/X1E+Q5DV2gLKN/d3kC4hT6ayhxIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761697183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bJkcyolNuTmg5TVBkOY9t69FiLYTUrSf3a+mSIO6UFg=;
	b=Fx+sEZj8wHgYA3X/xWbL2mKbnCAQN5iXP9tQnuJlXqZ5Y+kJzxjPyD8vtnQ2+TdiJkEOL5
	H2Tdtu4yx4KplnosRIwjzHwHJ0D/fqIqxM+154vlmmMuJKWsbtgNwKl4ekhv7DmhnsM4SE
	R+zNUROoXss+sctYcVMguUEaF1ozQ6fbjxKWJqCxmwQ+ksZk91+tWwhp+WbV7SPnOiH4Lz
	yTdigGjAk56/DsP1lB3a97x+M39H81T2nWexQ11KMhB5BXIFMKHIp9XXiKhmnQ8u7q/Ywz
	qmJOfrOPUeMRNVaVC32TJCI9whkaYFPSgUg0oCkLXVWbrxYJYwFYBbNCiEYkbA==
ARC-Authentication-Results: i=1;
	rspamd-768b565cdb-vxqzd;
	auth=pass smtp.auth=instrampxe0y3a
 smtp.mailfrom=mail@christoph.anton.mitterer.name
X-Sender-Id: instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MC-Relay: Neutral
X-MailChannels-SenderId:
 instrampxe0y3a|x-authuser|mail@christoph.anton.mitterer.name
X-MailChannels-Auth-Id: instrampxe0y3a
X-Suffer-Bitter: 2f8ee99302bd5f5e_1761697183707_3502194979
X-MC-Loop-Signature: 1761697183707:2184418642
X-MC-Ingress-Time: 1761697183706
Received: from cpanel-007-fra.hostingww.com (cpanel-007-fra.hostingww.com
 [3.69.87.180])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.120.36.240 (trex/7.1.3);
	Wed, 29 Oct 2025 00:19:43 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=christoph.anton.mitterer.name; s=default; h=MIME-Version:
	Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:To:From:
	Subject:Message-ID:Sender:Reply-To:Cc:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=bJkcyolNuTmg5TVBkOY9t69FiLYTUrSf3a+mSIO6UFg=; b=NOIcfReQICf5
	BrLIRMdJUqp2ZygaR7h+zDX4Ws8AMTGOSfwPa/aTGHrEsvWswxDbmMJrBn6d+MIHkxLc+7kdw1AL2
	7QLhcJDfNWnViq5y0kk1rG6YPtDgoeSNQUpaUMAtVqbfaDIz5woB5Ey+F/eriEIAjdhNSwdzGOtqN
	onj4nLGEcXs71HFgmRBDDHOV1wtyOmIQzwJ+XhFL6qHM0z8Jq7eLD13ojcTnmcb9IdRiHXGSFI2XB
	WKtYztqbG2Se3n2x0MHKdU2j9ATp2rtWU/tW+jAAJQ+wvualCJ33Xuf7dHJHo4KeqjhJo2I/ab92T
	nzaFj4YzTqZRz8ZaGyEQ2A==;
Received: from [212.104.214.84] (port=18538 helo=[10.2.0.2])
	by cpanel-007-fra.hostingww.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <mail@christoph.anton.mitterer.name>)
	id 1vDtuf-0000000DFft-3iGy;
	Wed, 29 Oct 2025 00:19:41 +0000
Message-ID: <0e0112a16c881a1072c3d9dcba4d323b608674b0.camel@christoph.anton.mitterer.name>
Subject: Re: [PATCH nft v6 0/3] doc: miscellaneous improvements
From: Christoph Anton Mitterer <mail@christoph.anton.mitterer.name>
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Date: Wed, 29 Oct 2025 01:19:40 +0100
In-Reply-To: <20251028145436.29415-1-fw@strlen.de>
References: <20251028145436.29415-1-fw@strlen.de>
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

On Tue, 2025-10-28 at 15:54 +0100, Florian Westphal wrote:
> Christoph, let me know if you are ok with this
> and I will apply this some time tomorrow.


regarding:
[PATCH nft v6 1/3] doc: add overall description of the ruleset evaluation

> +* Base chains may call regular chains (via *jump* and *goto*).
> +  Evaluation continues in the called chain.  Regular chains can call
> +  other regular chains.

IMO that makes things a bit more convoluted, first explaining who can
call who, then where evaluation continues, then again explaining who
can call who.
But, simpler sentences, so I don't mind.

> +  Chains residing in a different table cannot be called.
> +* For each hook, the attached base chains are evaluated in order of
> their
> +  priorities.

I intentionally had no "base" in there, because even though not
directly, the regular chains are still (indirectly) evaluated for each
hook.

With respect to the changes to *accept* and *drop*... I see that for an
dev or expert (or even me) your condensed version is enough, yet it
still think the previous more elaborate versions would have been better
for beginners, as it described things more explicitly requiring the
reader (and I presume devs/experts will never really visit the summary
chapter since they know it anyway in flesh and blood) to draw more
conclusions (for which he cannot be sure whether they're really correct
or not.

But, we can probably discuss about this forever and I guess at the
current point it's better to simply get it merged.

I would however suggest to reconsider in prarticular "all traffic will
be blocked".
"all traffic" is... well "all traffic"... but the decision is just
about one packet, ain't it?
Also "blocked" is IMO a bit fuzzy. Is the term used before? I'd rather
interpret it as some generic term that could be either drop or reject
or similar, but here the example was particularly about when any chain
uses drop as policy.


regarding:
[PATCH nft v6 2/3] doc: fix/improve documentation of verdicts:

Some of the minor changes are ok, I guess, other's I'd personally
think explain it now less clear, at leat from a beginners' PoV.
But I guess it's pointless to argue over such wordings preferences
over and over again :-)

With respect to the example that illustrates what it means that the
rule itself is immediately terminated, you refer this now to the
overall summary chapter?
I just wondered because that's merely a summary and it's now kinda
missing in the "detailed" chapter about the verdicts.

IMO it doesn't make things easier for a beginner, if one basically
has to read through everything to find all information.
So I rather have some limited repetition, but that's again of course
merely personal taste.

Als, "or a user-defined", ain't the base chains user-defined,
too?


So merge from my side to get this done with.


Thanks,
Chris.
