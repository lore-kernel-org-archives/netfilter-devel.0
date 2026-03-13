Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7675135B644
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Mar 2026 15:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773417478; cv=none; b=iYL8JOGpzYZyCROzezb9mRvew00x+ooSctMBYepA58hpOym6gFLTYDYQ0Rr6ONR6SMYFIHSYaflAxYN0RfITKLHH4LXTh1OWaxyD9XV1nwrbgZzFsSDoryaV7AuRca8cY0x+JqlpUdiJv5XSEB6aIKL7gpH/89B5U+E4Bs/k8Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773417478; c=relaxed/simple;
	bh=NwrdbP7F1+6/y8NoMSOVgcGGaVi1TYhtNXTW/1G/gZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=omVrcqQb6B7VvtfiaR4/P36XjqIk39HkJfZM1Hg5v1oTtS+lNUMqInNj39jSqpAUHgHbXSSyLymYPWmjzzpHkZUJvo7LL7ME3rB1v/Dei6mh4tRtGPsCdooWQRXz/j7kkAunsr61US6ybysRen5zQZ5RbjOun7HgDwFa8XfDeAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=JlFZNJsj; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="JlFZNJsj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=UMsRqlvEAnUZINIQLpOADeXgtQEbRu+c5Rbi3MhDmUg=; b=JlFZNJsj62XXfPDelaHt0OJVhh
	kM6MssQx9bBABXnFUMRHAO8YX1Gj6Kpjhr2cMhWhU57PW8dGXibLmqIVzMtiRXSiNuQG9SurVGt4N
	yv1b/vnlMxJM/Pm71/lSgSeUpmfNNWK8Rz1AyMwMjz7I5O2RuA3DSbM0asX2h71KYkT+LqXNhWeZj
	DhWg7RLjx+Li3z9FizWvAPSWkJ0vLsbcLd5x3J6nYjkZKL/zlWBdUgxeW8Ym9ZQ0sFnz+kthf5j22
	wGC4OblNmoKGF6g+erubm4NsVO9b9CMatW7ac41omGyuJUxH0TUmztvqXOVWHTOqlX63T9yzBo+HJ
	n1SjUGGQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w14tf-000000005aQ-3YXp;
	Fri, 13 Mar 2026 16:57:55 +0100
Date: Fri, 13 Mar 2026 16:57:55 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Jeremy Sowden <jeremy@azazel.net>
Subject: Re: [nft PATCH] Revert "tests: py: use `os.unshare` Python function"
Message-ID: <abQ0A_cRQ3zym1J-@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Jeremy Sowden <jeremy@azazel.net>
References: <20260313104414.21686-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260313104414.21686-1-phil@nwl.cc>

On Fri, Mar 13, 2026 at 11:44:14AM +0100, Phil Sutter wrote:
> This reverts commit c29407ab300f8ed54b5ca27cf4837c0aab920760.
> 
> This change breaks 'time' expression tests in py test suite. It looks
> like with os.unshare, modifications to os.environ are lost. Neither
> unshare module nor unshare command suffer from this problem.
> 
> Fixes: c29407ab300f8 ("tests: py: use `os.unshare` Python function")
> Suggested-by: Jeremy Sowden <jeremy@azazel.net>
> Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
