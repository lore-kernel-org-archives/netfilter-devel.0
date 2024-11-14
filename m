Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E9918D651;
	Thu, 14 Nov 2024 18:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731607726; cv=none; b=NdNW7K9Ez8vcfzXnQGMAC3EDz280rDd51TiHef8PuZHm1tNL/O1Vpyc08O9VP+J0LuLvm19xw2knEWoYMuvA7L01bxaVfMYNJKKhCHm0eg6vSwY/S10qGWax97RHvxxlF6kJa6ER/8nBSqCnbvPpk5qKxddB0ozujs5hm13lhkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731607726; c=relaxed/simple;
	bh=WxwaCdUMXsv8LmwrGxAPPcqpBFfizKZByVclKS/kV9A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MF4uvCDGs2xbfseaMgdr2nv+o3FsMtW8A8oy6zi8Q6Dh3YkmxnfNqI8UXcbXP7cn9WoAGQjEvYbh5+qP22ObAeSeO0Kmc9bYwqGypbLL0ggbgPdEXuoOkCRwm3rEljIcHGhw06tspH/kMr5Pl8orh2nkVi+/uDkqwiHHtokvZ6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=47356 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tBeGj-003azZ-8C; Thu, 14 Nov 2024 19:08:39 +0100
Date: Thu, 14 Nov 2024 19:08:35 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
	fw@strlen.de
Subject: Re: [PATCH net 0/3] Netfilter fixes for net
Message-ID: <ZzY8o3CusAHFVrVf@calendula>
References: <20241114125723.82229-1-pablo@netfilter.org>
 <119bdb03-3caf-4a1a-b5f1-c43b0046bf37@redhat.com>
 <ZzYQpRTItgINeyg4@calendula>
 <bc284081-8df8-42a5-8f19-8cb1e06d3330@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <bc284081-8df8-42a5-8f19-8cb1e06d3330@redhat.com>
X-Spam-Score: -1.8 (-)

On Thu, Nov 14, 2024 at 04:31:48PM +0100, Paolo Abeni wrote:
> On 11/14/24 16:00, Pablo Neira Ayuso wrote:
> > On Thu, Nov 14, 2024 at 03:54:56PM +0100, Paolo Abeni wrote:
> >> On 11/14/24 13:57, Pablo Neira Ayuso wrote:
> >>> The following patchset contains Netfilter fixes for net:
> >>>
> >>> 1) Update .gitignore in selftest to skip conntrack_reverse_clash,
> >>>    from Li Zhijian.
> >>>
> >>> 2) Fix conntrack_dump_flush return values, from Guan Jing.
> >>>
> >>> 3) syzbot found that ipset's bitmap type does not properly checks for
> >>>    bitmap's first ip, from Jeongjun Park.
> >>>
> >>> Please, pull these changes from:
> >>>
> >>>   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-24-11-14
> >>
> >> Almost over the air collision, I just sent the net PR for -rc8. Do any
> >> of the above fixes have a strong need to land into 6.12?
> > 
> > selftests fixes are trivial.
> > 
> > ipset fix would be good to have.
> > 
> > But if this is pushing things too much too the limit on your side,
> > then skip.
> 
> I would need to take back the already shared net PR. I prefer to avoid
> such a thing to avoid confusion with the process, especially for non
> critical stuff.

We can wait, thanks.

> It looks like the ipset fix addresses a quite ancient issue, I
> guess/hope it's not extremely critical.
