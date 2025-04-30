Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F63188A0E;
	Wed, 30 Apr 2025 07:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745999838; cv=none; b=pGwxjDbNo6rIx8yCpKHLsmaH1HhpEApEboWKqJ8GVyDxTNwjWc03TcTb/Oss7y9wvEoIASjDm0LwxmgW60hJXtu33LACf8q59ed4lTS9HoPg0NWPRWSimbDx3R788LcArdD+eS5DOHJWIjlpHsXc/pYQ8XWxPCNE8ZEW21FoIAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745999838; c=relaxed/simple;
	bh=71DGGON2HSVDxxVvFtqOfUMtLQSWnvqMF0YLMh8MmaY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r+LCjw2zsYh/TLSdhOcXKyvwJLaoTYRPHZLMXi4bHiUtUd0OMWeKMvT9Mx4VqLn9IStouV8c9aD39GF/CHLBmIIXQXScRg+Srf7DLftPlwk5XUTJEnShwRt2nz/VeJgyxBdq4J8wlxLrLXuATpIn1pFcqNm2dYsgI7aucg+hovg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1uA2Jb-0007zd-S0; Wed, 30 Apr 2025 09:57:11 +0200
Date: Wed, 30 Apr 2025 09:57:11 +0200
From: Florian Westphal <fw@strlen.de>
To: avimalin@gmail.com
Cc: vimal.agrawal@sophos.com, linux-kernel@vger.kernel.org,
	pablo@netfilter.org, netfilter-devel@vger.kernel.org, fw@strlen.de,
	anirudh.gupta@sophos.com
Subject: Re: [PATCH v3] nf_conntrack: sysctl: expose gc worker scan interval
 via sysctl
Message-ID: <20250430075711.GA30698@breakpoint.cc>
References: <20250430071140.GA29525@breakpoint.cc>
 <20250430072810.63169-1-vimal.agrawal@sophos.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250430072810.63169-1-vimal.agrawal@sophos.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

avimalin@gmail.com <avimalin@gmail.com> wrote:
> From: Vimal Agrawal <vimal.agrawal@sophos.com>
> 
> Default initial gc scan interval of 60 secs is too long for system
> with low number of conntracks causing delay in conntrack deletion.
> It is affecting userspace which are replying on timely arrival of
> conntrack destroy event. So it is better that this is controlled
> through sysctl

Acked-by: Florian Westphal <fw@strlen.de>

