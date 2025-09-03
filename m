Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CEC2F3C22
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Sep 2025 11:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756897457; cv=none; b=aIiPc1csozeADVNyllZ0OdTgsNmczi3O5/469FBSMt8Pt58PmDuif7FF4SSZ0zion0urXi1cbq6uX2ce0YKeeONtawBNogHqjCL6pZMbusW5aRTfDc9MriMAMooLV6sMu3cLM3SvQA7Hew8eF/b6orZRnwjqjv6WmIyS22oIXNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756897457; c=relaxed/simple;
	bh=SAyBuRCMAVPXG/v5LlTyQ2y4b2FErLOCiL58P5OHmEI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o/z7mYTP8RtyQB3oS5kg4TJGiJYqAW4LjgsDUeWwmTOFuibudSwkHg2+1aLSFLk4CLXwMeUud0woLo4zhtTOpqGN31d0O2hzYT+BIC/SxsO5xhja5ZK8sCVqbQ1+DEdTOV8evVo+5SYGw3hrvhXKMp2/YkjKah9ZdDEVRmYjadQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=epQ6WacX; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="epQ6WacX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3m9blO9mzzIT3aN8V0mDTiDVIFPc5NVDSvJUSpQFd04=; b=epQ6WacXV5XfMY5tTJfvtStJF1
	d9ahoZynnmeEKeEWmkPFu0wF6K8uo1SFWqvKEOswkpDqaInhP0RtDR26EMlCF5fb2dIMa4nNsYB65
	QnrjaUqXftgUGu3N/qPvQEIIymOjtz2Q+Fmqx53iAn5+K+URlQlKdnqIinIioyxgnp4XAk9Ucr3Os
	ERfQrJDT0YZFklurNjP/HcY0NPwfbrGhgBPZEiW2qo8GJLfLE5MoKW7nV5+QEI5du//4eEA9XLnJ3
	KIXvueSIWYgYBv7x/uSoHdbmgRsPJ0m3LWUQGi368dRQXpBVuMgJwtOvDJSYFCVJW5KXeLc/5gXk7
	9kr1Gzug==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1utlHb-000000003rV-0rIV;
	Wed, 03 Sep 2025 13:04:07 +0200
Date: Wed, 3 Sep 2025 13:04:07 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2 2/7] tests: monitor: Support running all tests in
 one go
Message-ID: <aLggp4FFR3fN-1dk@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250829155203.29000-1-phil@nwl.cc>
 <20250829155203.29000-3-phil@nwl.cc>
 <aLcCr2YxUkRFH6UH@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLcCr2YxUkRFH6UH@calendula>

On Tue, Sep 02, 2025 at 04:43:59PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Aug 29, 2025 at 05:51:58PM +0200, Phil Sutter wrote:
> > Detect RUN_FULL_TESTSUITE env variable set by automake and do an
> > "unattended" full testrun.
> 
> This test is so small that I think it is better to enable both modes:
> w/json and w/o json by default.

ACK, good point. I just investigated and it is feasible to use the
stored JSON output for testing '--echo --json' as well. So I can extend
the test suite to test echo and monitor mode for both standard and JSON
syntax.

Thanks, Phil
