Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD3618754F
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Oct 2024 12:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727786833; cv=none; b=AeupKeUEQNamG3Jb/l+8B6/arFoyPcn48J+gVNiQsZzOLdyOBzDAqatdFQTfZK98cgtUo8J81CQ/uHYYLFakkb0Y8QBgwjpbQ0wX+Qjf7AhP++6ij2359u6yosxoJaq50n5zwXj4dOm/pxPgB2H+NShk2n1D0+dHMvZuDzKUij0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727786833; c=relaxed/simple;
	bh=+d2pxKMmNYmTImpZT+OuPgpTa4FJoM9xeYZswgzqaa0=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I0+fnkyv0KrMTxkw0B3FxnNqYZokL1/ZspXvQ3WzWD8HQ0oKqrHbnq2hduYpC0R3DcPgH9k8NpQgkwX5DtQYD2Tx5wrEeN2lF6ZbRSFUW5qyTPTqzbT4o4gulMtO5GUrtYC6ATHr7DYmqe4jWS0modfHS9HSu3cpnIcT1N8qp5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=59676 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1svcHO-009qLa-I9; Tue, 01 Oct 2024 14:47:04 +0200
Date: Tue, 1 Oct 2024 14:47:01 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH] Partially revert "rule, set_elem: remove
 trailing \n in userdata snprintf"
Message-ID: <ZvvvRQm8N-qKBD4G@calendula>
References: <20241001112054.16616-1-phil@nwl.cc>
 <ZvvbzkNjJeEY25Fv@calendula>
 <ZvvtmN2QKwOfTNp5@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZvvtmN2QKwOfTNp5@orbyte.nwl.cc>
X-Spam-Score: -1.9 (-)

On Tue, Oct 01, 2024 at 02:39:52PM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Tue, Oct 01, 2024 at 01:23:58PM +0200, Pablo Neira Ayuso wrote:
> > On Tue, Oct 01, 2024 at 01:20:54PM +0200, Phil Sutter wrote:
> > > This reverts the rule-facing part of commit
> > > c759027a526ac09ce413dc88c308a4ed98b33416.
> > > 
> > > It can't be right: Rules without userdata are printed with a trailing
> > > newline, so this commit made behaviour inconsistent.
> > 
> > Did you run tests/py with this? It is the primary user for this.
> 
> It doesn't cover this because there's no test containing a rule with a
> comment. I just added a respective test, but only to notice it does not
> matter because nft-test.py compares rules' payload individually per-rule
> and thus does not care whether output has a trailing newline or not.
> 
> I noticed it when testing the iptables compat ext stuff. You can easily
> reproduce it like so:
> 
> | # nft --check --debug=netlink 'table t { chain c { accept comment mycomment; accept; accept;};}'
> | ip (null) (null) use 0
> | ip t c
> |   [ immediate reg 0 accept ]
> |   userdata = { \x00\x0amycomment\x00 }
> | ip t c
> |   [ immediate reg 0 accept ]
> | 
> | ip t c
> |   [ immediate reg 0 accept ]
> 
> Note the missing empty line after the first rule.

None of the existing libnftnl _snprintf functions terminate string
with line break, right?. I mean, for consistency with other existing
_snprintf functions. Maybe fix nft instead?
