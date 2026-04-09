Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37BF3DA7D9
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Apr 2026 14:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775743221; cv=none; b=OpiqcKSei00AJcLREr3GjlKv8FBfd5y+PMAt2xh2SB4Uf2DYJX2t+53+ZERX5VvVVaZftIH75FzY3YgiICmvu3oqdYpTHrNUPrNo5Iau/uNgle0zhoIeYh2BAMA4u2tUiyWEITu+PxfWYGW8WrfdvCpeHppV4M+XwPHZ8hFqJIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775743221; c=relaxed/simple;
	bh=zT7zx6/IH4co/eOfCghNKGS1pWlxRiqq8fSrRT6DCG0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P+wOR0eV2KnsPBOML9/znKMvz5Jipzmh+fQExIY9wRryWFPjPeD+yC/YZqAvfOfyckCjEtQsA/CzxwPUKOg2xlpm4MWWj5By4VR7uZGMo+0RdWKv3xMFd7kW2AbwWWyf4jebwGEwIczNUQXoS3To2l5IbfhfG40FKf6VJ6modxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0D4FF60636; Thu, 09 Apr 2026 16:00:11 +0200 (CEST)
Date: Thu, 9 Apr 2026 16:00:10 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, phil@nwl.cc
Subject: Re: [PATCH nft,v2 1/5] main: consolidate EPERM to non-root users
Message-ID: <adew6v7we9-Oj-vo@strlen.de>
References: <20260409135311.49221-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409135311.49221-1-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Move the check added by 3cfb9e4b3e40 ("src: report EPERM for non-root users")
> to the main function.

Thanks!
