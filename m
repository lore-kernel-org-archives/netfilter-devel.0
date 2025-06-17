Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28B42980AF
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Jun 2025 10:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750155722; cv=none; b=npEpoTfJJvIxc7LBwsHyWoQeemsJhHUm53ZSQPZHdlPIN0H5OiqO7BRsS6n4BP8C19YaU0efoPq3oorDX6vnZo8z2RJYHX7VqCM/PUS0Pi1pLiQIYtDGMdlZei5JBxxZ71YyKWhaInC91zQP7OfYpDkX+2gpmBS01ELfyivti4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750155722; c=relaxed/simple;
	bh=LCk6RggxSxDQHs0pcB2ZlnbfTnSqjCvhogxRsW1QA1E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WBLJLp4+ZaeQ+4CvgUR3mD2vYaLfnZeCm4UUBE7W7smEvgVFaJizJV39/ppbJ+PsU1yQ8KF0Navm2A7iGWG/18x8765YHob/UvHoUxyx92FXot8ujYoKtuWsqHeVKKoeh5g/3YNF4iDK7XG2zJEWaVs4g0wlhWesnH82rWfk188=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=RPcXlhqU; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="RPcXlhqU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=OYMO/eh3sFOp6sCe7zReViPSxYmMvhzpUMtXH/ZqZPs=; b=RPcXlhqUgDVaE9B0luNlJNZkYr
	P8quYqZ70Kxhxl6HpwqkG3L8Y+XhorWKrVRt00BXl8N54JnPexiJ7QrUF2ZkogATcFXue+YCQt/jA
	bEAOgI6QULjrAxv3lPpDHOca+/N1zzlyu012Rt6QaPh2QZ0nE435IM47wgtE/tL9joEevh9g9alRG
	QM+DtRN/LL4YhbYtvxxJS5LmtKPMa6Kox3HT9Wyl6VT8rRA1ricwuFYd4su/kWVd35F9oKL3qacXo
	QPY9U3IDiUNO2K2gjRUPe1l+YaRSfixrLDpolEMAdEES9ev4WCFazab4CuS0r/1Goky4KLq6Ie+cT
	+4jJIuzg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uRTRv-000000002lj-3bbI;
	Tue, 17 Jun 2025 12:21:52 +0200
Date: Tue, 17 Jun 2025 12:21:51 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 3/7] monitor: Correctly print flowtable updates
Message-ID: <aFFBv0XBCWL4dfd_@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250612115218.4066-1-phil@nwl.cc>
 <20250612115218.4066-4-phil@nwl.cc>
 <aE6Wf82Lf09Qo2WK@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aE6Wf82Lf09Qo2WK@calendula>

Hi Pablo,

On Sun, Jun 15, 2025 at 11:47:20AM +0200, Pablo Neira Ayuso wrote:
> On Thu, Jun 12, 2025 at 01:52:14PM +0200, Phil Sutter wrote:
> > An update deleting a hook from a flowtable was indistinguishable from a
> > flowtable deletion.
> 
> tests/monitor fails:
> 
> --- /tmp/tmp.CxT9laP7kj/tmp.qTOOOcfTUY  2025-06-15 11:44:55.690784518 +0200
> +++ /tmp/tmp.CxT9laP7kj/tmp.JdiYcpuAKK  2025-06-15 11:44:56.337658195 +0200
> @@ -1 +1,2 @@
> -delete flowtable ip t ft
> +delete flowtable ip t ft { hook ingress priority 0; devices = { lo }; }
> +# new generation 3 by process 2954068 (nft)

Ah crap, this requires the kernel patch 'netfilter: nf_tables:
Reintroduce shortened deletion notifications'.

I don't see how user space could work around the old kernel behaviour,
so monitor testsuite will fail for old kernels with either this patch
applied or as soon as we add a test for a flowtable update removing a
hook spec.

The only way out I see is to accept the extra data unchecked in monitor
testsuite, i.e. practically disabling the tests for flowtable deletion
or updates, which obviously sucks. No idea how to move forward now.

Sorry, Phil
