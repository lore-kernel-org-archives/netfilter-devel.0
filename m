Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0287A1C2307
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Oct 2024 12:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727786398; cv=none; b=iA+qgQVWcyCPyeQ/uESu1X5eGioRNL9XoG2vxQBEBAgBv26Lfh7g18Oks4s6BeTD4LcSFLzyBoeTPhHjdtDbCS/yTlI/SSvF3RGWwlo1nb1180OOQv+dnlocfHCQMJPQCuwizPMT8FYKYiiJywEUXnf7LntWdIlWz9EgQp7zuks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727786398; c=relaxed/simple;
	bh=cBVA1GZ4LMoNL9WZA5b9dvgQ+BVJPtppZvzjg+GrRJA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NQin1iOu9a4ukUYJw1w9hu12/3JK5pxLy3bTPoeAw3N+ib10M+nRVJkzx0/xT+6nM3NGUdUiZm2EqlaZ1Yy1HaO/a6utvJm2YdfejMeNNqhsnV3U5eYTTl7UMWe1lvfld+PyTW8tusklDaASAh4GYITTpzfIbCM6p61upafcjGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=RmwCs8sp; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="RmwCs8sp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uDBEPnSNbwSpaU2qWFxzVNSacQt7/ufr/QkxEN/fTPk=; b=RmwCs8sp5VjJCG25nWf6lU3p3P
	xJQOPvgnrYTXOM3LTPrK59WNVtb5tfWXJt6tfsrs6TD+jYn9coNkJrZpoFdD3Ci4iQpX4l6VdCV2Y
	tolQigXWY3o+tiQb7aMdBPxTMu6a6vjhgFVPkz66938Rik+B5rlmnQmRb2xEBw4k83jx3Ka7O3wZQ
	R2UyQaMIdgYPBilmBPfz6LfUwwYfJWnrFsPdTFua55cytXwY3B8lv3q5cPLJIdqC4qYvjji/BpUnK
	3HuEx84bh9X8ioaZRbLu3zfTrXjZGtT4IHAsgQpkq6ijGnAbnm+Pwv+EHjWl+NcUwXoeHrTvdtsBh
	LAeXy68A==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1svcAT-000000006s4-04P3;
	Tue, 01 Oct 2024 14:39:53 +0200
Date: Tue, 1 Oct 2024 14:39:52 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH] Partially revert "rule, set_elem: remove
 trailing \n in userdata snprintf"
Message-ID: <ZvvtmN2QKwOfTNp5@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20241001112054.16616-1-phil@nwl.cc>
 <ZvvbzkNjJeEY25Fv@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZvvbzkNjJeEY25Fv@calendula>

Hi Pablo,

On Tue, Oct 01, 2024 at 01:23:58PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Oct 01, 2024 at 01:20:54PM +0200, Phil Sutter wrote:
> > This reverts the rule-facing part of commit
> > c759027a526ac09ce413dc88c308a4ed98b33416.
> > 
> > It can't be right: Rules without userdata are printed with a trailing
> > newline, so this commit made behaviour inconsistent.
> 
> Did you run tests/py with this? It is the primary user for this.

It doesn't cover this because there's no test containing a rule with a
comment. I just added a respective test, but only to notice it does not
matter because nft-test.py compares rules' payload individually per-rule
and thus does not care whether output has a trailing newline or not.

I noticed it when testing the iptables compat ext stuff. You can easily
reproduce it like so:

| # nft --check --debug=netlink 'table t { chain c { accept comment mycomment; accept; accept;};}'
| ip (null) (null) use 0
| ip t c
|   [ immediate reg 0 accept ]
|   userdata = { \x00\x0amycomment\x00 }
| ip t c
|   [ immediate reg 0 accept ]
| 
| ip t c
|   [ immediate reg 0 accept ]

Note the missing empty line after the first rule.

Cheers, Phil
