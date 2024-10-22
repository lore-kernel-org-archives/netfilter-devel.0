Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBBB2BCF8
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Oct 2024 13:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729602485; cv=none; b=p1DzjZCzkhNiNwzt8vg/VBjfwBSTNC1Cww6jUQnJ/1mKj8VgduWFLeE/dGsvL1uJKpgIx1f2WVcjSXqNSP1kUIPQItExnpvky4RcJ5gQlTogsotaSebBvNxjGzviw10ShP6oFsyFHiKOWeqRaymRbr3j+aVWehEKQjeEwX23d/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729602485; c=relaxed/simple;
	bh=cD+ku/JUW+f2cMG6fzcNY3Ijx65eIhVJz12vJla2A84=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YZKnXsDTQvrQvJJinecVF3ozgjjkTreo+6mXLEE6uEL8TOJdTeP89pa26SnRi3cNibLDEzeCXn+K9pAfTtvHCxuH7o21vVJ5mLjG3covp3bPNeUhsKpQ5UBAXCnbrf0jatJm8ASYHnpJMRatfMA36ziK3sgkQ+kkCaDmK2SLEsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=A4+QD6SN; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="A4+QD6SN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=z+FqN31JPxucZhIkhtPBpaQ0drW1ZEYOOpABMcNRNqo=; b=A4+QD6SNWQMhHYHhKwwrzcXlVZ
	9dHQ/cN8m0n4R1KyWCCfsC/407sUmmkXO4DDFEJxvycI1nL5Ekm9XwdzT/YElzvUVaTmKai5MjKtU
	lNxTB5n5b57PKGPt91dw2CODTA7L539YVNTJnP+pGtst6Gje60OrUbHiIzuAfdq3kR0iaOUwBiDzF
	e40Z2phE52EEBn1ADVmckLBVUYuYMb6YQfv6v7WMqHA6/Wg/+jSclLedqesyWpd4hX7AngZhMcmpc
	BmyjhctvDBN3IUhy8ZC7n8CnokqYLcZsPacNeXEY+cb48c19ts03DbcDqS0eNTHgj6Ixa+/EjvoS7
	EYxuZvTw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t3EcD-000000007DE-0Mml;
	Tue, 22 Oct 2024 15:08:01 +0200
Date: Tue, 22 Oct 2024 15:08:01 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH iptables] tests: iptables-test: extend coverage for
 ip6tables
Message-ID: <ZxejsR2ph2CSnYjD@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20241020224707.69249-1-pablo@netfilter.org>
 <ZxebAVfZ_aDSNeb4@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxebAVfZ_aDSNeb4@orbyte.nwl.cc>

On Tue, Oct 22, 2024 at 02:30:58PM +0200, Phil Sutter wrote:
[...]
> - With your patch applied, 20 rules fail (in both variants). Is this
>   expected or a bug on my side?

OK, so most failures are caused by my test kernel not having
CONFIG_IP_VS_IPV6 enabled.

Apart from that, there is a minor bug in introduced libip6t_recent.t in
that it undoes commit d859b91e6f3ed ("extensions: recent: New kernels
support 999 hits") by accident. More interesting though, it's reported
twice, once for fast mode and once for normal mode. I'll see how I can
turn off error reporting in fast mode, failing tests are repeated
anyway.

Cheers, Phil
