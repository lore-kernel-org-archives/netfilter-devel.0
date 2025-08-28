Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE9430DD2D;
	Thu, 28 Aug 2025 11:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756378802; cv=none; b=mhaRXviwMvL13HdOOZMUX59fGJPmRjjA21Iegts7pL5pKo1m+x9UMZG3NZwHP5zfbER8yFJbwPD+32u4FJncqnnpbNdUUFT0lmGTSIvF8tAHpuH+hGsSnoBNsbOL17n/TiE8GQX6iDTMVD569rjXXuV0RclhBCq5BlyyFaiHTbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756378802; c=relaxed/simple;
	bh=UBUiURh3+7RGU8Sm6scccZ4GJtuq3hIsrzOstLCzoMI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=spNF2h9nwpN5nzY5w18Fp+O6sQu4EwIiBOclDCsARcpRguVT45tKU/k7znFCAz/9j64zefG7jRwqakV8VaUmkS0GMI7YKor8o4xojtHjgbzwBUSd9AYDaq5d36pINgkdAqoqW1v29P4llljulvBudQqdv4YZyH1EGYusosGX4bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id EF9B5606B7; Thu, 28 Aug 2025 12:59:57 +0200 (CEST)
Date: Thu, 28 Aug 2025 12:59:57 +0200
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Wang Liang <wangliang74@huawei.com>, pablo@netfilter.org,
	kadlec@netfilter.org, razor@blackwall.org, idosch@nvidia.com,
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	horms@kernel.org, yuehaibing@huawei.com, zhangchangzhong@huawei.com,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	bridge@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] netfilter: br_netfilter: do not check confirmed
 bit in br_nf_local_in() after confirm
Message-ID: <aLA2pv5Jb9XtIewI@strlen.de>
References: <20250822035219.3047748-1-wangliang74@huawei.com>
 <aKghV0FQDXa0qodb@strlen.de>
 <20250822071330.4168f0db@kernel.org>
 <aKiC_fDXK0Ln7-oM@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKiC_fDXK0Ln7-oM@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> > flake-atious test for netdev CI currently :( Could you TAL whenever you
> > have some spare cycles?
> 
> I'll look into it on monday.

Sorry, got distracted but I think I see the problem and i expect
to send a fix for this today or tomorrow.

I'll amend the test to deal with this.
