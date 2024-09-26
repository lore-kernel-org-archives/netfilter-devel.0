Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DF41494AC
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2024 14:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727361301; cv=none; b=ETWHt9u/Mon+oo+skbPKf8IfT2d/NZARq8CibHvA5Bai6rotC4YUgRCepk4fDp8+3G95PjzrfjhZkt1IllbX4Sy2oWellU4qlwC6Re2y4j98Pi/zp4qdkS0UAj6qyCJB9km1/5IkIKr8dbq5IqttgZaPzag842IE3YSB/PnFGzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727361301; c=relaxed/simple;
	bh=o3kXfzy+MBwkTHtlJ/pG6ba4FQyJPTBEz/7xC/pskyQ=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TvY/wMufuTW2caLCWtsUWpvwuEY4LLOjh/rHuL2fESkKAKUyLBPyLgKPWSGPmSENOsxGxt8tyPJNKOSn4LigmwC0wN6vbc4lZDVxzdr8ZU3rDYKkhPllKx42ubiv+OAuaRR9VeftOCsFKPsLCvuhb4spDW2MhEeXMYPKKOR++/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=41006 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1stpZv-001e0J-ND; Thu, 26 Sep 2024 16:34:50 +0200
Date: Thu, 26 Sep 2024 16:34:46 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v2 5/7] cache: consolidate reset command
Message-ID: <ZvVxBkaE-G0yyIwr@calendula>
References: <20240826085455.163392-1-pablo@netfilter.org>
 <20240826085455.163392-6-pablo@netfilter.org>
 <ZvSTAoV3thoJlKRw@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZvSTAoV3thoJlKRw@orbyte.nwl.cc>
X-Spam-Score: -1.9 (-)

On Thu, Sep 26, 2024 at 12:47:30AM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Mon, Aug 26, 2024 at 10:54:53AM +0200, Pablo Neira Ayuso wrote:
> > Reset command does not utilize the cache infrastructure.
> 
> This commit changes audit log output for some reason. At least I see
> tools/testing/selftests/net/netfilter/nft_audit.sh failing and git
> bisect pointed at it. The relevant kselftest output is:
> 
> # testing for cmd: nft reset rules ... FAIL
> #  table=t1 family=2 entries=3 op=nft_reset_rule
> #  table=t2 family=2 entries=3 op=nft_reset_rule
> #  table=t2 family=2 entries=3 op=nft_reset_rule
> # -table=t2 family=2 entries=180 op=nft_reset_rule
> # +table=t2 family=2 entries=186 op=nft_reset_rule
> #  table=t2 family=2 entries=188 op=nft_reset_rule
> # -table=t2 family=2 entries=135 op=nft_reset_rule
> # +table=t2 family=2 entries=129 op=nft_reset_rule
> 
> I don't know why entries value changes and whether it is expected or
> not. Could you perhaps have a look?

Before my patch, there is a single dump request to the kernel:

  rule_cache_dump table (null) chain (null) rule_handle 0 dump 1 reset 1

the skbuff already contains 6 entries for t1/c1 and t1/c2, which why
180 entries of t2 fit into the skbuff is delivered to userspace:

  table=t2 family=2 entries=180 op=nft_reset_rule

(it seems 186 rule entries can fit into the skbuff).

after my patch, there is one for each table:

  rule_cache_dump table t1 chain (null) rule_handle 0 dump 1 reset 1
  rule_cache_dump table t2 chain (null) rule_handle 0 dump 1 reset 1

the skbuff is empty when dumping t2, so we can fit 6 more entries:

table=t2 family=2 entries=186 op=nft_reset_rule

If you take the number, before patch:

180+188+135=503

after patch:

186+188+129=503

show that is the same number of entries. Behaviour is correct.

I don't know how to fix this test without removing the check for
'reset rules', because it will break between different nftables
versions (due to the different strategies to dump all rules vs. dump
rules per table).

And I don't think it makes sense to revert my userspace update just to
make this test happy.
