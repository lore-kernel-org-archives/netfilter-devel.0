Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D1D34CF9
	for <netfilter-devel@vger.kernel.org>; Thu, 15 May 2025 14:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747320676; cv=none; b=KbS5OskmdwPJD3qNVMs3K5kc+EssmgBVIDupJBcfs0wK+5kaAeWJ5Pv4QBSbvECYC1DhuTyPMgFpuB3mlphUMy9IlVJPwdjIBZG3H7QtexElcdJWhHIJahE9/TB4OXVEt30gWPhs8odaWw95ZXg06S5hQB77/LcgOdOztiCdgck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747320676; c=relaxed/simple;
	bh=NktHSoHRODKhE2PtcqLQllANFXkxTmadJ4PDkJIKd2c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rWFqQb7xHPsDvhJUjGhF+tLHuXJumGpm2oKhVrRpis9L9m92XSbruqUvQTmANQlC2qOtWL64HcvdJ82Hw76PS8kBFoUa1eNYAM3OzumS37KnBhOQv8NG9YtmI1i8e+bRqkt5ySXvkBD7feJ6hX5ImA1c7DR+72dmhK16OsU03F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7DF2560105; Thu, 15 May 2025 16:51:04 +0200 (CEST)
Date: Thu, 15 May 2025 16:49:51 +0200
From: Florian Westphal <fw@strlen.de>
To: Shaun Brady <brady.1345@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Looking for TODO
Message-ID: <aCX_D98jCtRuwwoh@strlen.de>
References: <aCQF1eDdqgmYE3Sx@fedora>
 <aCSF_RwSPS8zkSiS@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCSF_RwSPS8zkSiS@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> Bugzilla mines are good, or look at mailing list for bug reports,
> e.g.
> https://lore.kernel.org/netdev/PH0PR10MB4504888284FF4CBA648197D0ACB82@PH0PR10MB4504.namprd10.prod.outlook.com/
> 
> I'ts been on my list but so far I did not have time to look at it.

FTR, Ido Schimmel sent a patch to fix this:
https://patchwork.kernel.org/project/netdevbpf/patch/20250515084848.727706-1-idosch@nvidia.com/
