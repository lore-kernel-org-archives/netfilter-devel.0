Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CFA30C60A
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Aug 2025 10:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756377533; cv=none; b=ukPwCh6r24wuW+iFaIIdOCZeqZ17KCJHI9egc7mscEABYpRBaNLxycGcZKBet55YqSG/TGRH3lFqM5vDvlM5qO9L68NB/i+rqwW+ahXhJlEuVpTfKJiwSRZuDvNUGQ3zyg3ttkyRbezEQYjWUPibiSWLhN9V4J2w4aVU2PO5xIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756377533; c=relaxed/simple;
	bh=RZoFOpFf/hOEdguJpa6fF9ZMDGhhjJn8SXx5RZRM77E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fF/Z1CmWO8XKVfXTBt1u9rgLBKW0noSVAr3DfC5XlvTMBnbYm7buc5SNP31u8AZzuQCQWKQ4GW+T1UiFj2+qMAYO8sAnxKc+JN7Y9p24PD5Rbc74NVHeFm6hXPqsAhZcSxJtHVyauqKqNmRD8y3TsTDr5IdEUCkBsmeI9dJ3XiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=F6PrdUCi; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="F6PrdUCi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=RZoFOpFf/hOEdguJpa6fF9ZMDGhhjJn8SXx5RZRM77E=; b=F6PrdUCiXDaOFWPnus/VBaLvPw
	Qs3ScXF9CZXjx6pkFlWvnFTnpApFcNhn06ifqCFVbaARkhBfiQWABnCIrm+8y6xSSndEUQmghYR/V
	mI5XGxCx3Z+NA7xvFQgFugJgxXvN6qujjk1AyWvTsKnRmyCenZyfF+oFEqfnRi2bAO2dbtXQ9FqE1
	8+aEMXLRZ0ypmCNPtxZe0xMVT3KHxGRblh6GG2zmZhDf3Wt/ii71lntBEFn5kvSFedOQv3IRkCwOi
	KVrX3lUliNZCz0GieDf94wRdFFJnm5fU6EDvwELw/nUk7UcMQLlxD4GW+ZpAJ3c4Iot5DTirP1+B/
	PpaQ9zaw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ura1o-000000000Ol-0vhC;
	Thu, 28 Aug 2025 12:38:48 +0200
Date: Thu, 28 Aug 2025 12:38:48 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 6/6] Makefile: Enable support for 'make check'
Message-ID: <aLAxuEXDU1IpqT8G@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250801161105.24823-1-phil@nwl.cc>
 <20250801161105.24823-7-phil@nwl.cc>
 <aJOLPp-1TWYfGCQF@calendula>
 <aJSTLfOz4v-DgQVz@orbyte.nwl.cc>
 <aJSYlVUF9NzKL4FD@calendula>
 <aJSkbu8fZsAqoBTf@orbyte.nwl.cc>
 <aK-P6gvGB-sSKYj8@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aK-P6gvGB-sSKYj8@calendula>

Hi,

On Thu, Aug 28, 2025 at 01:08:26AM +0200, Pablo Neira Ayuso wrote:
[...]
> 'make testrun' sounds nicer than my run-it-all shell script proposal,
> it would be nice to have a short summary at the test run not to scroll
> up to find each individual test result. And I think 'make testrun'
> should continue on errors so it is also useful for testing patches
> under development.

After a second look (and with Jan's distcheck fix patch in mind) I found
a way to distinguish between 'make distcheck' calling 'make check' and a
user doing so. This way we can use 'make check' as it is intended and
leverage automake's test suite integration while at the same time keep
'make distcheck' untouched.

I'll send a new series once I have collected what's really needed for
it.

Cheers, Phil
