Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A400F1D4154;
	Mon, 14 Oct 2024 22:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728943243; cv=none; b=K9w7A2tt5NszeY25xUT9ROexLqmiXqsiSesL6LlQV61mx5f5r4O2kKO8lBe90d8l2bxN7TxRyakDgA4kjzyzpIzSHYDHajnfkAtDkYFANeCtwfLQAX9tGEXaFHw/TeVe97GadAbCex1PuZtmSWJsGGHtWJLU5DZawFAHqGLP+Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728943243; c=relaxed/simple;
	bh=lK5pAK2E68CMaTy4EmAUcpJFEZj/0OnHejYDPYJ2LBo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E9tfwlgVN5B3ZNEVPsepu/7WS0X/zPIEXdL5bFR+ksJ0bDhB52mAw4+MGOq2DaDD8RLTOAuTVsK5lxeLW4kpDwq/KUwtebo9bKMMnJUcItZ5JRnKFKFT1E/PRZrPTxi9a71rl0gj7Ujm3CF7iMhrW1NhsMwyQWVoIwKZrGgjN4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=40274 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t0T7C-007QD4-9o; Tue, 15 Oct 2024 00:00:37 +0200
Date: Tue, 15 Oct 2024 00:00:32 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
	edumazet@google.com
Subject: Re: [PATCH net-next 0/9] Netfilter updates for net-net
Message-ID: <Zw2UgAlqi_Zxaphu@calendula>
References: <20241014111420.29127-1-pablo@netfilter.org>
 <20241014131026.18abcc6b@kernel.org>
 <20241014210925.GA7558@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241014210925.GA7558@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Mon, Oct 14, 2024 at 11:09:25PM +0200, Florian Westphal wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
> > > 5) Use kfree_rcu() instead of call_rcu() + kmem_cache_free(), from Julia Lawall.
> > 
> > Hi! Are you seeing any failures in nft_audit? I haven't looked closely
> > but it seems that this PR causes: 
> > 
> > <snip>
> > # testing for cmd: nft reset quotas t1 ... OK
> > # testing for cmd: nft reset quotas t2 ... OK
> > # testing for cmd: nft reset quotas ... OK
> > # testing for cmd: nft delete rule t1 c1 handle 4 ... OK
> > # testing for cmd: nft delete rule t1 c1 handle 5; delete rule t1 c1 handle 6 ... OK
> > # testing for cmd: nft flush chain t1 c2 ... OK
> > # testing for cmd: nft flush table t2 ... OK
> > # testing for cmd: nft delete chain t2 c2 ... OK
> > # testing for cmd: nft delete element t1 s { 22 } ... OK
> > # testing for cmd: nft delete element t1 s { 80, 443 } ... FAIL
> > # -table=t1 family=2 entries=2 op=nft_unregister_setelem
> > # +table=t1 family=2 entries=1 op=nft_unregister_setelem
> > # testing for cmd: nft flush set t1 s2 ... FAIL
> 
> My fault, Pablo, please toss all of my patches.
> 
> I do not know when I will resend, so do not wait.

At quick glance, I can see the audit logic is based in transaction
objects, so now it counts one single entry for the two elements in one
single transaction. I can look into this to fix this.

Florian, are you seing any other issues apart for this miscount?

Thanks.
