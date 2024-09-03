Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918D81AD25F
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Sep 2024 08:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725352978; cv=none; b=LBt4RRNkRnICI/SbW8xAd+4kJF1PtoJ372H6aAtim9A5f1McLSAu0kKMiBTculDVdRExtnWd500WBlyjJboyqOakYTNKZbjUyBp2xgONL87K+n61v1+oGRzvtC3JRtYDf4clt9ijIsFNKwGhkZGLgUFPCvhViVEGH6nI427HFKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725352978; c=relaxed/simple;
	bh=zuNfb91tmMwRwQl0dUyCxRZ5RZne/tZCbwAOybtECvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I2Q7P7Tlut/fuZu4idqBHCJvJtO+Cv3Ue/Z4uYGjAZEhXGJHsTEQEG1oLa5+BqVhfLvKQXzCOrXaD2whtpiVHIp3w1PbUV2zkB1/Sne087+B+CbbiA6oWwx6uw2mrVREVy4G8N1Br/2NmLsB3X/l5sJG+LA/QEEZvflhZkZaokI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=47208 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1slP7j-00AEzG-0B; Tue, 03 Sep 2024 10:42:53 +0200
Date: Tue, 3 Sep 2024 10:42:49 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_tables: drop unused 3rd argument
 from validate callback ops
Message-ID: <ZtbMCR0HhIG69E1t@calendula>
References: <20240828093409.2792-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240828093409.2792-1-fw@strlen.de>
X-Spam-Score: -1.9 (-)

On Wed, Aug 28, 2024 at 11:34:02AM +0200, Florian Westphal wrote:
> Since commit a654de8fdc18 ("netfilter: nf_tables: fix chain dependency validation")
> the validate() callback no longer needs the return pointer argument.

Applied nf-next, thanks Florian
