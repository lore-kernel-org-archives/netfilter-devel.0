Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE4B17F51E
	for <netfilter-devel@vger.kernel.org>; Thu, 30 May 2024 13:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717074820; cv=none; b=WLL3CgcIGeukXfErlHF2I4xE2OAIkg/vmG5cZBXFnnH0dPUKZ/TXLFBYp2+60IS4ji2QDCKYSl11MpiucLtYgbJfuRp9M+xYL3cnvvwUoWETySc8HtR2vk+UkATPJjslQYwZ+BzJF7rV779KRZrNS+pdvQLdd/iwQjNUu9eYGk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717074820; c=relaxed/simple;
	bh=9UdN93OWw9BuMgVkEJzYy5qWO/eM8oviY0ooORi2pL0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I3CCyj5xrs1QRDPMW0BQqee6krbhXxhtN+IAXhJroHC3/zMP/dl2BlnGLBl73WDa2CqLind5zlHcRcINP3UVahj9RV3ftr6XqINKYG0MYl+D8hs5R0Pr9r7CxIAMIA+nQt0dEOWgdY9wagEjhUWJQYCTwppqzwxM+oykspxsIw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sCfb2-0002AE-AT; Thu, 30 May 2024 15:13:32 +0200
Date: Thu, 30 May 2024 15:13:32 +0200
From: Florian Westphal <fw@strlen.de>
To: wangyunjian <wangyunjian@huawei.com>
Cc: Florian Westphal <fw@strlen.de>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"pablo@netfilter.org" <pablo@netfilter.org>,
	"kadlec@netfilter.org" <kadlec@netfilter.org>,
	"kuba@kernel.org" <kuba@kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"coreteam@netfilter.org" <coreteam@netfilter.org>,
	xudingke <xudingke@huawei.com>
Subject: Re: [PATCH net] netfilter: nf_conncount: fix wrong variable type
Message-ID: <20240530131332.GB2041@breakpoint.cc>
References: <1716946829-77508-1-git-send-email-wangyunjian@huawei.com>
 <20240529120238.GA12043@breakpoint.cc>
 <d6a7fe4b75b14cdda1a259c2acb10766@huawei.com>
 <20240530075220.GA19949@breakpoint.cc>
 <fc77f3c83cd3470ba1678f48dcbd172c@huawei.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc77f3c83cd3470ba1678f48dcbd172c@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

wangyunjian <wangyunjian@huawei.com> wrote:
> > Then please quote the exact warning in the commit message and remove the
> > u8 temporary variable in favor of data->keylen.
> 
> OK, I will update it. This is not a bugfix, only considered for net-next?

nf-next, yes.
