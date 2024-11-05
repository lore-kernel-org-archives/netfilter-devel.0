Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FB7383
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Nov 2024 23:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730847671; cv=none; b=cRM9eUQeiSz1GNT3RA0CPQQHFvlYpKiucD7xdqyumawx3rcjMKBMzGaPeB4vT5QhQSB5eBAYRisMbIOB+9A9zaGYAO+KITl8lUq0IkDCsjnOMvTPNiCBOJ98TGkPtf9Zl1hb1qIDhlRsRJTFEdxxmALfwp4GGUuVjEdtG1+6Z/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730847671; c=relaxed/simple;
	bh=WdmORGOKEA+BUruFsUDNpxCIwtVkPTkSnXnycp2hDpU=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ilXILqewGHX3Ry/ZrttFouajJeS4cPYwSHKYSrZ+F9oqOXC2m4o/eYN2UE20kRS+4HmmSptjDULf0Jd5TTUgxlDiLp8yW48YSknVwHnon+Yr+wFBipTitp1qmhNbLemdDInqeTHyrkNqv0DuXRLfHBzLx2IczZN30090IMhvIwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ngpE/BJr; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ngpE/BJr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3R+jHNvD0Y/4bdTd1x99NEP6mjHSLFyBLjgKAAURtN4=; b=ngpE/BJrE47dy5eo+D6NjCw+fE
	ofAWUZXdrPdDg9rwyNqLfoFPLhN7+SG+YkZaohPRdZUpFc1pU4w6MyDc7qkdJxj4MGcigaP9J0ij4
	/O7zBM4Go+D4IqjBoItVnsmfI5HEju8lcORy2ECFo3DBkIWyj8DdSWrXXdPkU1O3VGUdj9P17TtUw
	FPwQHFelKVWwWzANP/D9IiZaUMqHfXTDuUf98DsdXeWgWahxF4sS75fOGjuXuh0trkdVD0V/1k6qV
	fD51ig8ltG8tFyF6ZB5RpuqrKukSfmWLxY6L9tgtSEDC2S1BlcHSALgxXvQS9RxWaXHZX+BRf63dV
	qpYuLHEg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t8SXq-000000005IQ-3Ybe;
	Wed, 06 Nov 2024 00:01:06 +0100
Date: Wed, 6 Nov 2024 00:01:06 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH iptables] tests: iptables-test: extend coverage for
 ip6tables
Message-ID: <ZyqjsgRn32CFlWNm@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20241020224707.69249-1-pablo@netfilter.org>
 <ZxebAVfZ_aDSNeb4@orbyte.nwl.cc>
 <ZxejsR2ph2CSnYjD@orbyte.nwl.cc>
 <ZxetHFXRj08Jipu0@calendula>
 <Zxe85R9YnoOL-pzg@orbyte.nwl.cc>
 <Zxe_rez8MZN-ieN8@calendula>
 <ZxjX7nqs8g1gBemh@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxjX7nqs8g1gBemh@orbyte.nwl.cc>

On Wed, Oct 23, 2024 at 01:03:10PM +0200, Phil Sutter wrote:
> On Tue, Oct 22, 2024 at 05:07:25PM +0200, Pablo Neira Ayuso wrote:
> > On Tue, Oct 22, 2024 at 04:55:33PM +0200, Phil Sutter wrote:
> > > On Tue, Oct 22, 2024 at 03:48:12PM +0200, Pablo Neira Ayuso wrote:
> > > > On Tue, Oct 22, 2024 at 03:08:01PM +0200, Phil Sutter wrote:
> > > > > On Tue, Oct 22, 2024 at 02:30:58PM +0200, Phil Sutter wrote:
> > > > > [...]
> > > > > > - With your patch applied, 20 rules fail (in both variants). Is this
> > > > > >   expected or a bug on my side?
> > > > > 
> > > > > OK, so most failures are caused by my test kernel not having
> > > > > CONFIG_IP_VS_IPV6 enabled.
> > > > > 
> > > > > Apart from that, there is a minor bug in introduced libip6t_recent.t in
> > > > > that it undoes commit d859b91e6f3ed ("extensions: recent: New kernels
> > > > > support 999 hits") by accident. More interesting though, it's reported
> > > > > twice, once for fast mode and once for normal mode. I'll see how I can
> > > > > turn off error reporting in fast mode, failing tests are repeated
> > > > > anyway.
> > > > 
> > > > Would you point me to the relevant line in the libip6t_recent.t?
> > > 
> > > It is in line 7, I had changed the supposed-to-fail --hitcount value of
> > > 999 to 65536.
> > 
> > This was already fixed in v2, correct?
> 
> Ah, you're right. I didn't notice your v2.
> 
> If you're OK with it, I'll apply your v3 with the following changes:
> - Describe 'iptables' param in _run_test_file()
> - Drop duplicate 'endswith' test from _run_test_file()
> - Print results with command name suffixed for libxt tests (it is more
>   consistent wrt. tests count)

Patch applied with mentioned changes. Thanks!
