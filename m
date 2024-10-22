Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BEF19ABC2
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Oct 2024 12:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729600262; cv=none; b=XvvdDDEDCGx2YrzgPKne35cp3sHIOXLZzxB6iYRnj8rBB3FFB9cS/aSphYYoi2MuVkJSV2UmaEyx8RBxAt6B3cT/VdXjes0JhfWim2bO1VKUrXYvwF6UycQLJ9Pdo1/shXPjncwMyjmLBghpZ6VbKVZxbEIzWBaCHxY7Fq5SFEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729600262; c=relaxed/simple;
	bh=3+li1n6hgvfyGmjzDGWPjJD2TA+KqGhcyms00zbOHZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lcLB/bbWoOEWdQ2rCwN+QimjCE+DFZbEtKIoLM3OqRct702a5U+ph8OIduCW5edp9DL7mFA/xzQEdwZ7QGozOKDj5B4WOzzIBaVllpFPVPtEsmuGr2YAW7Po6TDiTIWoL7YfyhF78DeNeTadrsOVnmkNM8WlShzuZSoSsngOjZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ZuYSoxFY; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ZuYSoxFY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=URSVfL8N+d+DMho/XfxrDO0SvbjJdeVJp9G8h5TD+lY=; b=ZuYSoxFYjE+BVJzckfCckBhA1n
	GX59Iv+YucKhebp3KPEkfeb600aujOVdOyjc6dTzSJmKrebM2l3npEfApne2o6WYdSr1hQXTXUsex
	biRVg2pJOq+ro+5y54Egg7+fir8lYfn3qvl3dIM3iXfXjY8o1tKlApp1YJvTcA8ue/56sioN5rdw7
	nkSyKkFUPRdoD8gRoET2ewV1oEPeSwIfD0yZBBqGdmJXPlnNuNFV2oPV49ico8md8Yanfml8KhYt8
	eUqQV6ZHpSQD0q7veIiS1xhW51TeMwvwZlmsQYNxopUHbucmoyWIHPDYqs4Fy/PXh45O848f6FpyS
	XtPvsznA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t3E2L-000000006Wv-3kSg;
	Tue, 22 Oct 2024 14:30:58 +0200
Date: Tue, 22 Oct 2024 14:30:57 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH iptables] tests: iptables-test: extend coverage for
 ip6tables
Message-ID: <ZxebAVfZ_aDSNeb4@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20241020224707.69249-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241020224707.69249-1-pablo@netfilter.org>

Hi Pablo,

On Mon, Oct 21, 2024 at 12:47:07AM +0200, Pablo Neira Ayuso wrote:
> Update iptables-test.py to run libxt_*.t both for iptables and
> ip6tables. This update requires changes in the existing tests.

Thanks for working on this! I see a few things we could still improve:

- Output prints libxt tests twice. Maybe append the command name?
- The copying of libxt into libipt and libip6t creates some redundancy
  depending on test content. Maybe keep the non-specific ones in a libxt
  test file?
- I noticed there are some remains of supporting '-4' and '-6' flags in
  iptables-test.py but it is unused and seems broken. One could revive
  it to keep everything in libxt files, prefixing the specific tests
  accordingly. I'll give this a try to see how much work it is to
  implement support for.
- With your patch applied, 20 rules fail (in both variants). Is this
  expected or a bug on my side?

Cheers, Phil
