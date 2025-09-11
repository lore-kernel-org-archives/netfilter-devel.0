Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23ACC353365
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Sep 2025 16:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757606747; cv=none; b=CODF0LBEIGDs4f0YQQaV5ZC0AJv5+jvJtsj0TLo9PZW+MqvJ8xzo+x5On6EhzG88hlj1nTyPZlY0nyXKPevG/qZV+b/OTGHAKQ1FuA+qffbXu8Lm4zQMkrVXPTrY0/knkwX0M7Xdcx4WKaBHBKF0QQ8HlXkmlDmKBL+JPG4fTQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757606747; c=relaxed/simple;
	bh=VzcjTjbYfLR6ie7vFLeP//uAq4jHNG0n6eizCqEESts=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=teQntkoz/oSUaT2Fam08ZtZh9ZjDqLBahnoLSXETJhod71SQlsZ5kokDZdz/GwcpbX2nYMOUNta2KkCC1nYUR82EZ9M/QbYJQsadLlw/bhoZCTb+epnxZQaSBEpyMN6znSr4yX+qpBimbO89AD4mjl29RZEkkJcrzkEfs1IhrCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=oPU61htY; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="oPU61htY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=u5jlGkD8AB89qYw7pwjYsGhjP9MEF/KxIVO/sRK8qEY=; b=oPU61htYRqnmuziyXU2+lXJ5CF
	bWZkAilKvHqrMTCarLEf6EuRGqeGZTkmJ1g49lN5+GuWqx8RytP0Jhjce0tuqMkXCN0cWYaXH07EN
	AQ4cXecEJ3+vCfJJzJ3/1RfeNPx+qGUrOepX/eOWcXK5+3P2Cp6bJ3EqkUCKg8rjioiuA3mjD0JFT
	6OYXXt0z6y42ot59dtS5x6DiI6+E0N+KS8n7yt4J6kRNa7Ca6RdnJRsN70htrN31ikvcaqVDimmhK
	BKv7qXJZKlO4ubxYM5iu5h+/NmrHEYojuCa/YCYL6HgwBaIlQZNIDRkoFQ1PFf5l9gqSmkv/WNmy4
	z1FKPwrg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uwjnr-000000008Nc-0jWE;
	Thu, 11 Sep 2025 18:05:43 +0200
Date: Thu, 11 Sep 2025 18:05:43 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 0/5] Fixes (and fallout) from running tests/monitor
 in JSON mode
Message-ID: <aMLzV3XIPFEwR4kZ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250829142513.4608-1-phil@nwl.cc>
 <aLbNs-lZch_9BB01@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLbNs-lZch_9BB01@orbyte.nwl.cc>

On Tue, Sep 02, 2025 at 12:57:55PM +0200, Phil Sutter wrote:
> On Fri, Aug 29, 2025 at 04:25:08PM +0200, Phil Sutter wrote:
> > The reported problem of object deletion notifications with bogus data is
> > resolved in patch four. It seems only object notifications were
> > affected. Patch 6 extends test suite coverage for tables and chains a
> > bit.
> > 
> > Patch one is an unrelated trivial fix, patches two and three cover for
> > oddities noticed while working on the actual problem.
> > 
> > Phil Sutter (5):
> >   tools: gitignore nftables.service file
> >   monitor: Quote device names in chain declarations, too
> 
> Applied these two unrelated trivial fixes.
> 
> >   mnl: Allow for updating devices on existing inet ingress hook chains
> >   monitor: Inform JSON printer when reporting an object delete event
> >   tests: monitor: Extend testcases a bit

Applied the remaining three patches as well after:

* Adding the proposed minimal chain_del_evaluate() to the first one
* Adding a Fixes: tag to the second one
