Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662FC2D3233
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2025 19:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749757876; cv=none; b=DG3BPZtC3yfqwHcE56qCTzjUEHZtlZ2LwoWDPKBygcHhlg1SXvWLiADEHPXe19wy2b/0IsgyF0iSGtLSy22Vhv3jxnzh8ZEHfhJU9vwGbb/oL3fA7NEDhuui3LcS4OwekMihgMsDE0RmdjRYpOQ1InAAgFggWQ4wX67QwchqlFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749757876; c=relaxed/simple;
	bh=Q28qDdy/K7KUDncy/vZy2L/quzbIpWc3X2HtejcC67Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s0JGJUNyIjNAVNHh55xFH90U6jT6b4do9WWY+UYztvTUN9uN9WXK79WImGefoD2Vzy5cB3X3nbIAKD4q9gIqv3Lrvc3xVYana17qVQEXNFAqrEuYkNZBXMdqhBHcS/cyeaa2Fs68N3Cn9ezDW7on+wu2HEV3bYkpBSC48duQrkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Yw6AEKvK; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Yw6AEKvK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kPoj/e6xPPtRl3Ot/tf30LHyZNhzzkrgCt768aUvgaY=; b=Yw6AEKvKiJbmvneBbqgHFbDSVA
	jKi+AzKdOlDgZj8cHyxJ1dlmooj/Z2hO4+0OLWbQOrzRHedQLHMEkie28LK0mMpjz4b0LMCyw83az
	6N+o4AQl8y0djd7quJJmboDjuHl7GgnFox15JPugCdgOi5Kwqiv8dAnzMWr69E+NTv8z7j0Y+MEQ2
	e3Fcw0Ni/mEg2hL4fEOqfprr2Q2Gv5QPxu3TTOhPXPGIkYtBwioigeRjxjuXb2Qt5QzyIopdP7G8e
	ivzP/1IC5eyoPXd/CadAFv3hTeEXdphmUJA6bIWvuOm9Y1k4kPPsgSnzJuv9mDk+zQ4tC57M8mpuR
	lasOVQFw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uPnxA-0000000087E-1plo;
	Thu, 12 Jun 2025 21:51:12 +0200
Date: Thu, 12 Jun 2025 21:51:12 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 6/7] tests: shell: Adjust to ifname-based hooks
Message-ID: <aEsvsLAfl0n3puqJ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250612115218.4066-1-phil@nwl.cc>
 <20250612115218.4066-7-phil@nwl.cc>
 <aEsrkwSJ_sXIgOvi@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aEsrkwSJ_sXIgOvi@calendula>

On Thu, Jun 12, 2025 at 09:33:39PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Jun 12, 2025 at 01:52:17PM +0200, Phil Sutter wrote:
> [...]
> > diff --git a/tests/shell/testcases/transactions/0050rule_1 b/tests/shell/testcases/transactions/0050rule_1
> > deleted file mode 100755
> > index 89e5f42fc9f4d..0000000000000
> > --- a/tests/shell/testcases/transactions/0050rule_1
> > +++ /dev/null
> > @@ -1,19 +0,0 @@
> > -#!/bin/bash
> 
> I would prefer this test does not go away, this is catching for a old
> kernel bug if you take a look at the history, ie. it is an old
> bug reproducer so...
> 
> > -
> > -set -e
> > -
> > -RULESET="table inet filter {
> > -	flowtable ftable {
> > -		hook ingress priority 0; devices = { eno1, eno0, x };
> > -	}
> > -
> > -chain forward {
> > -	type filter hook forward priority 0; policy drop;
> > -
> > -	ip protocol { tcp, udp } ct mark and 1 == 1 counter flow add @ftable
> > -	ip6 nexthdr { tcp, udp } ct mark and 2 == 2 counter flow add @ftable
> > -	ct mark and 30 == 30 ct state established,related log prefix \"nftables accept: \" level info accept
> > -	}
> > -}"
> > -
> > -$NFT -f - <<< "$RULESET" >/dev/null || exit 0
> 
> maybe simply add here:
> 
> $NFT flush ruleset
> 
> to get the same behaviour in old and new kernels.

Ah, good point. It's better to skip the test if ifname_based_hooks
feature is present instead of dropping it.

> I did not look at other tests.
> 
> Please have a look at the history of other tests to check if they are
> also catching very old kernel bugs.

The other two tests I touched merely remove flowtable hooks before
returning.

Thanks, Phil
