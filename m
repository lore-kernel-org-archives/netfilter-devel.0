Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96ABD2F5332
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Sep 2025 11:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756897608; cv=none; b=q0uMlg0q4NDe2e+YR+/NVzSlL7LL9JSvVz2zvbq5rElAFUPJpQcXPZ/x5zY/XfDOUISPBqYD5eL++gvnauO92uhKAe0lA9aJmmfIfrMGOmTfjKnGakJrkCmRkiprWfVOyFu/AC9072gbGwLDz5tAjK96ZfYiIbQcJ7rWjlUNraw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756897608; c=relaxed/simple;
	bh=tlGG5EAXhs0qWqAYvCNaXfwmzzp2yybKgE1FWtbI/pM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oOZtswnfbV19Qgzn3jjyCG3WgzpPj1/26hgrf/umuRcjFvE9gOaA77oXMPMCHzonPqe1qzPUKAZFQvdLpT5G5O0MlsDusn16kL9/MeCzAxZs+Bei34BeXyCUEwI3eAq5PQQoXbNhb+R9oKF1x9tYgKe4jiDCwPJJsbtOY3A2dxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=hAYnC3c9; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="hAYnC3c9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=C/bHhwC91QQXPQc8cMu4cmzHCOpRgRf0fe/mJmEAnjU=; b=hAYnC3c9nVw7C4AskA+ETRkGW9
	jSqdwrd+XF4X+4i4gWyz4vqniptX1nAaaS1b4H6JJyYENYhS+QQ6hv3FJt7arJYb1o8AdpScrbTWv
	Far71zd06zPV9QUvd8ncSz2KlVwDlEwes9+12z6oXt+b2Hkm5XBKE2TCnTyqO/lOZdAFcODYbV+41
	lrPcy6ridKpEQ8llfkW/nkXpws7wsrNiw61kGYdAbHrz/Jifvcqu6+L2UGKwa/K8CZEtDwjqPE3tV
	X6/QuaUVqB7P9zkO4sQq6Aj1HO+rnc7S6iqvGQWJ1NhcyZLK9l4swDzrKu3+9eXvI7tMBc3l2MpO+
	a4v9ahLA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1utlK7-000000003xf-2fcA;
	Wed, 03 Sep 2025 13:06:43 +0200
Date: Wed, 3 Sep 2025 13:06:43 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2 7/7] Makefile: Enable support for 'make check'
Message-ID: <aLghQ7G-fkdvOKLc@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250829155203.29000-1-phil@nwl.cc>
 <20250829155203.29000-8-phil@nwl.cc>
 <aLcDF_OEWQ5KmkZr@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLcDF_OEWQ5KmkZr@calendula>

On Tue, Sep 02, 2025 at 04:45:43PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Aug 29, 2025 at 05:52:03PM +0200, Phil Sutter wrote:
> > Add the various testsuite runners to TESTS variable and have make call
> > them with RUN_FULL_TESTSUITE=1 env var.
> 
> Given you add a env var for every test, would you instead use
> distcheck-hook: in Makefile.am to short circuit the test run and
> display SKIPPED?

I don't follow, sorry. The RUN_FULL_TESTSUITE variable is merely used to
enable "run all variants"-mode in test suites. Test suites are skipped
only if they require root and caller is not - one may still run 'make
check' as root or not, irrespective of the hack to leave 'make
distcheck' alone.

Cheers, Phil
