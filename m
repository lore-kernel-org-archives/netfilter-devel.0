Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F42181DF75B
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Dec 2025 15:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765898924; cv=none; b=LE3UPQ/5wjbJVJ4stNYrt7SjdUFn+8kgXQhZYYA647W5PN1mbGayv0idyNpzS9zNLmFJL9Lo6t034xLCSHHQuqMHVhHuqdwlhp4POWbbRGHoGp17a0AzjkgHCbdH05aDhVSOSv1w308DJOOFUbIRdSb3ShLqt+GeV4uO+Xhf6uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765898924; c=relaxed/simple;
	bh=D9tx5ZSY4YESh051a9QH+mzxiaITv/EmTc6GXAHBTeQ=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QGXoNe2yi4KFUKtUoA7D9ohbVlTwUg5/mAjffzNM5WK8bTU9kzmR76/DXtJWIvCqV6Fp+/0ja2dLYyQ7X8a2H9qrIvup+WDFWj3PxeikNdPyi6SiJplJ+ha38W4r+FBE7ZPyynIcCN0IdL3JjXUgQLyv45UM/dIjjMz8EJvYGRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=eCuunF5I; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="eCuunF5I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0hDp9lybxUb7edMNQiujdecmHLaFPglcf0XISXPJFCw=; b=eCuunF5IVk9G8hH74Atmxhit7H
	jt9c7rzVs25iSo0Sld435qXHkLvyUKQfKHWDKpgmf8939rU4E2dCD3OZexTqmV23n/rTGDdZq+hNc
	ZkwYP/vTRlXUOSD17jZEe9vUMR88jCAcM3F0XPmEWcY5pwO/l8uuWRinKA8HcUndfnaAcZm/9B5cd
	SQSqt82I8DBKH5v03wmslbCY9Euju4w+AdJL1HrQjU4iRW8K2PBifVpLB/moc4jH1hCO6ikzcESXY
	gfuZPdtsqyQsbdqm6MAbYRyFttI5kQFwI1GElf/XUuEhKJKlL390iBG5AH9EVxGIkOx/Od5mgVOUR
	BdT8DH6A==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vVWyd-000000000Vo-3ucV
	for netfilter-devel@vger.kernel.org;
	Tue, 16 Dec 2025 16:28:40 +0100
Date: Tue, 16 Dec 2025 16:28:39 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests: monitor: Fix for out-of-path call
Message-ID: <aUF6p6aa37OZFDY5@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
References: <20251216144613.10873-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216144613.10873-1-phil@nwl.cc>

On Tue, Dec 16, 2025 at 03:46:13PM +0100, Phil Sutter wrote:
> When called from another directory without specifying test cases, an
> incorrect regexp was used to glob all tests and no test was run at all:
> 
> | # ./tests/monitor/run-tests.sh
> | echo: running tests from file *.t
> | ./tests/monitor/run-tests.sh: line 201: testcases/*.t: No such file or directory
> | monitor: running tests from file *.t
> | ./tests/monitor/run-tests.sh: line 201: testcases/*.t: No such file or directory
> | json-echo: running tests from file *.t
> | ./tests/monitor/run-tests.sh: line 201: testcases/*.t: No such file or directory
> | json-monitor: running tests from file *.t
> | ./tests/monitor/run-tests.sh: line 201: testcases/*.t: No such file or directory
> 
> Fixes: 83eaf50c36fe8 ("tests: monitor: Become $PWD agnostic")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
