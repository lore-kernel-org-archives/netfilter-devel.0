Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883E213A87C
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Jul 2024 17:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720199893; cv=none; b=VwUZdtyZWt1m1JTHOI4zbjMOLT4ZD/VPpNWcSiLc7/Vf5Ps/xSQEU0ZhKENdVuCagACbT3ea/BOBstowQVCNofcj8nPh4d0Rkht59ZlysKF6alt2mKfKseerNzfmM5Os2KP6lxb+jAMiPr3RZc//jcsIMfNNSlh9p5BV8Nk8wO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720199893; c=relaxed/simple;
	bh=K00VeNuRes+AfXQKz11D2er/fYEmlemA6O2WhHev93g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EYLDDG+lQwLjORNkgXdkM8MfgKXx3KTEeT+5GOXFvtOFphPeJKv6tpgwIZHp0wvz+nRXWyMSpKgRYj/ZH8Kc7jSJMlZMbTSY8pyfZJxC/59mn2vtyP9dJ48eqzSIcV/aupOxXJnnEQ/hks+8qim1RW8ip3Khbr6gRsv5qwgXaOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=YjQDy3Er; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="YjQDy3Er"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=K00VeNuRes+AfXQKz11D2er/fYEmlemA6O2WhHev93g=; b=YjQDy3ErcjL4KWPn/idwMGVERW
	4plIbklGraS4X+v3uQ4L5PuqfzOygspMH0J2gfqb9VpznThlIy33P7iykPkLB5AJG50i8feEuDUTB
	1T9/mA6PnjpcJYDmQ+nWWOrIeMACAU1mcwhHQN+qrTJ3CWE9mjvzmzFCLp3DCDRSFi7KdHPSHdnWW
	SYpu95bBvVk3C5J8Pfd4nfVhyzpAPxvUKPmW0poYTcVpJaeNQnCIJ9QgsZ3IApTqQ3ghuduh0pDYx
	NCZPoMBIfkB/Gy6dvfyki0QEML9u1WQf09GdflVaWWfduj+Zkyp0Ei2ziGcZY+O+33D/oiIrA/TYI
	5xy4mMNQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sPmZT-000000002n5-3laB;
	Fri, 05 Jul 2024 19:18:07 +0200
Date: Fri, 5 Jul 2024 19:18:07 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Fabio <pedretti.fabio@gmail.com>, Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH] man: recent: Adjust to changes around
 ip_pkt_list_tot parameter
Message-ID: <Zogqz6CT2_hpfIok@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, Fabio <pedretti.fabio@gmail.com>,
	Florian Westphal <fw@strlen.de>
References: <20240612151328.2193-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240612151328.2193-1-phil@nwl.cc>

On Wed, Jun 12, 2024 at 05:13:28PM +0200, Phil Sutter wrote:
> The parameter became obsolete in kernel commit abc86d0f9924 ("netfilter:
> xt_recent: relax ip_pkt_list_tot restrictions").

Applied this patch despite the discussion about mentioning a (new) max
value as that has changed recently. I we could follow-up once kernel
commit f4ebd03496f6 ("netfilter: xt_recent: Lift restrictions on max
hitcount value") has landed in a release.

Cheers, Phil
