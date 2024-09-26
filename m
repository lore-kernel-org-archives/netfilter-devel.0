Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CE24D599
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2024 14:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727361625; cv=none; b=JU4tX1jsnzlj10Q2dlAHdoCI7sh9qcekx5RHBNZstqS+Z47RhpKipgcRWj13AuL4arS81hh0lH4jOGmYgBCChB7gmbvPpb34DE1faG+lj5ANxDBiTh0uV9E5b7EVhTjcfcLZKF4VgkPH9CRqP5euhRdlP/s2NZ/nAbdfgGYQ8zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727361625; c=relaxed/simple;
	bh=ZUhFCIarchWhiVhpjfF7lwiUgxAM4cKQgqzt9cj52TE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dFe8gv8XFUwNXBbBCEuatF1QlwyG4lZnpOYsHbAScI223tmdSVF0Mhw9qBVbbbHBSG0pspYgFAT7yUT1UrC7GCKn5HeYqXGzTMy8CJln+B6YhXcDpKHYnXT3tChA5LcwOqxEi3E2bLwtbuPqZIiEv7SLxCu8NNSJzH2J2a2PyqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=STOD722y; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="STOD722y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=soGgPFGwtcEDu2o53rwE8uoxEIqScqU6FBW2omPkUkA=; b=STOD722yXjIIZ5k5MM2E77/Ibd
	SopIIIpbAc96p9DA2nTHhcUna8c0RWWfJTesiBSe1/1YHNzyB32LE9poP2SAnUojHeqpw90YVCDXO
	fx2Nnhx7IJOFwPYshZrPiz3hvL2wQD994si8zxL1wwWMJx9yXEElqoty41VbwTc1XeMpiwXIoTaEm
	cttZYC12Amh4Mv+7Tk7l/Vl/7TvVkAdoXxHt/hVERpbFA5iHIzguSgeQobd6aFN/cRmCEp3e74kl/
	8tHTiw145UearwQob2AXn5xJdTcuBCubkgbi2ihgnaA+4c7skriVa59MatD+fWrF/FVQO2SP1ieY5
	jD24wogA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1stpfI-00000000213-2CMV;
	Thu, 26 Sep 2024 16:40:20 +0200
Date: Thu, 26 Sep 2024 16:40:20 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v2 5/7] cache: consolidate reset command
Message-ID: <ZvVyVNbsDDufmN5v@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20240826085455.163392-1-pablo@netfilter.org>
 <20240826085455.163392-6-pablo@netfilter.org>
 <ZvSTAoV3thoJlKRw@orbyte.nwl.cc>
 <ZvVxBkaE-G0yyIwr@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZvVxBkaE-G0yyIwr@calendula>

On Thu, Sep 26, 2024 at 04:34:46PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Sep 26, 2024 at 12:47:30AM +0200, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Mon, Aug 26, 2024 at 10:54:53AM +0200, Pablo Neira Ayuso wrote:
> > > Reset command does not utilize the cache infrastructure.
> > 
> > This commit changes audit log output for some reason. At least I see
> > tools/testing/selftests/net/netfilter/nft_audit.sh failing and git
> > bisect pointed at it. The relevant kselftest output is:
> > 
> > # testing for cmd: nft reset rules ... FAIL
> > #  table=t1 family=2 entries=3 op=nft_reset_rule
> > #  table=t2 family=2 entries=3 op=nft_reset_rule
> > #  table=t2 family=2 entries=3 op=nft_reset_rule
> > # -table=t2 family=2 entries=180 op=nft_reset_rule
> > # +table=t2 family=2 entries=186 op=nft_reset_rule
> > #  table=t2 family=2 entries=188 op=nft_reset_rule
> > # -table=t2 family=2 entries=135 op=nft_reset_rule
> > # +table=t2 family=2 entries=129 op=nft_reset_rule
> > 
> > I don't know why entries value changes and whether it is expected or
> > not. Could you perhaps have a look?
> 
> Before my patch, there is a single dump request to the kernel:
> 
>   rule_cache_dump table (null) chain (null) rule_handle 0 dump 1 reset 1
> 
> the skbuff already contains 6 entries for t1/c1 and t1/c2, which why
> 180 entries of t2 fit into the skbuff is delivered to userspace:
> 
>   table=t2 family=2 entries=180 op=nft_reset_rule
> 
> (it seems 186 rule entries can fit into the skbuff).
> 
> after my patch, there is one for each table:
> 
>   rule_cache_dump table t1 chain (null) rule_handle 0 dump 1 reset 1
>   rule_cache_dump table t2 chain (null) rule_handle 0 dump 1 reset 1
> 
> the skbuff is empty when dumping t2, so we can fit 6 more entries:
> 
> table=t2 family=2 entries=186 op=nft_reset_rule
> 
> If you take the number, before patch:
> 
> 180+188+135=503
> 
> after patch:
> 
> 186+188+129=503
> 
> show that is the same number of entries. Behaviour is correct.

Thanks for investigating!

> I don't know how to fix this test without removing the check for
> 'reset rules', because it will break between different nftables
> versions (due to the different strategies to dump all rules vs. dump
> rules per table).
> 
> And I don't think it makes sense to revert my userspace update just to
> make this test happy.

Maybe a valid measure is to sum up entries there to make sure the total
remains the same (just like you did above). I'll have a look at making
the test tolerant to both variants.

Thanks, Phil
