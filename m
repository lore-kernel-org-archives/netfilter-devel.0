Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D063AF65B
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Apr 2026 13:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775224767; cv=none; b=b+zpdhKrjDrirWkHQfb3sHF6kopWAMQZnViFKNEvgq9KM45G5Kty5yUDbIinoi+LFRD+AanZd5obDqKiJSPUYJ+r79VgPv4N7cIAGe+B9jzQ8uKwGz3X9f60bKNZEqZMIpQIHgETgvcCN2kL4xv5HOQe4pdxcGquJ8FbEJwB7ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775224767; c=relaxed/simple;
	bh=63z81I2FhXg8ObOmxhSpuo9ppjedyhToTSLkmY9KQKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MeSo90VdumexLulHYDHxwLHjE7uclRhxC+Nq8irojfzZNzRmTsUWRZZaeBdraWmQDmniNW/qBJIhp4IjZgzF/fX536QcFZu9SzpcEQtIsZX0Ah3HENjHBMagSu9vKEdYxmEz8fGGaGIRZK5+Uf6ggUZCbQsOnXUrNutpaXOfAHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1392160913; Fri, 03 Apr 2026 15:59:23 +0200 (CEST)
Date: Fri, 3 Apr 2026 15:59:22 +0200
From: Florian Westphal <fw@strlen.de>
To: Scott Mitchell <scott.k.mitch1@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: nfnetlink_queue crashes kernel
Message-ID: <ac_HuuPNrGxpW7CL@strlen.de>
References: <ac-w6e33txkgTRJj@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac-w6e33txkgTRJj@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> 2) a4400a5b343d ("netfilter: nfnetlink_queue: nfqnl_instance GFP_ATOMIC -> GFP_KERNEL_ACCOUNT allocation") should have updated the spinlock to use the _bh variant, if the queue exists we risk deadlock via softirq recursion.

Nope, this one is fine, the instance lock is only taken from process
context, but 1) still stands.
