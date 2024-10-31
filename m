Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466341C8FD2
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2024 21:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730411964; cv=none; b=gMiNP2eqGOAgpKU+JlOZtEIc2RdIDzVnTvnA6ilw9yzwjoGCYKlKmGrWsmDcjIIFOeLvGsX7f3xOyr1HwKSUL1dVC31G9yEHcMibDiXnGArrc4cWzR6C4WS2p/ivTogM4YUbEd4g5BUMGHGpBy+UCm7Ax46lV+VEbzO+cMvkG2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730411964; c=relaxed/simple;
	bh=/27NwBE57pWoIqxKhlCujuhujLBSWS4KMCWdXTpVi+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mcXu1geRLy0z+WqP+RmU51H6TR7QBgGRzUZHXeZcGYAcjYnjobSycpSW61AXxp76TeeJOMING1hvXG2gHheaNZZKIwfrI1cCAdTfPzHuz9WeMaO0WL6RXFP6YeS/lj3Ym90lxQDAclZTT9sMHx+6YupUmv95D87QbuEyW/Z+gUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=51524 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t6dC9-00H5or-J3; Thu, 31 Oct 2024 22:59:15 +0100
Date: Thu, 31 Oct 2024 22:59:08 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 nf-next 0/7] netfilter: nf_tables: avoid
 PROVE_RCU_LIST splats
Message-ID: <ZyP9rJlHagxOnCum@calendula>
References: <20241030094053.13118-1-fw@strlen.de>
 <ZyP7Q94DCbwBmobU@calendula>
 <20241031215645.GB4460@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241031215645.GB4460@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Thu, Oct 31, 2024 at 10:56:45PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > This targets nf-next because these are long-standing issues.
> > 
> > This series breaks inner matching, I can see tests/shell reports:
> > 
> > I: conf: NFT_TEST_HAVE_inner_matching=n
> 
> Uh, didn't i fix this in v2?  V1 had a bug in patch 6:
> 
> +       if (!type->inner_ops || type->owner) {
> +               err = -EOPNOTSUPP;
> 
> 
> V1 had !type->owner, which causes feature probe to fail and the test to
> skip (it skips builtin instead of module...).
> 
> I re-tested, I get:
> I: conf: NFT_TEST_HAVE_inner_matching=y

Thanks for your quick reply. Let me retry again, perhaps I took the
wrong batch from patchwork. I will keep you posted.
