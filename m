Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671271CC16B
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2024 22:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730412842; cv=none; b=jGTPUaI4Ccrxz0UBUGj7iEbyoFbMpEaxuv4XUfqkqY/pUQTCrl4IwzK2h3K4JpWmIfDiCY853ssND5w+zWCBURPTRBySiGBPDIzURqrV/uGt47OszZqjPff3J78Rzw7dDoJnw7Y3Y0NBZQsRjhceuAsa4LsJ/VFE69faZSlhmuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730412842; c=relaxed/simple;
	bh=/W2Ak2uJcmGrebSUg6DjbXWzWGPmH7jfIYDZCdTLFxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SmQe9JEnKdsBtXyLUHWt0Bh/3MioIJMuxI4Vx0mzWsii/+/jw/a+iNa6DI1mdxfAXBBUwhLQCPjvuslohaIRR0MLTYHYIX9JqHjWebjEOjJFuQhIOjNfEQP7f6gkDnaw7hv3dWyaF2yKZocg/usbbDk/LXkoZFv93jCJ8MUNk5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=52468 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t6dQK-00H97u-5D; Thu, 31 Oct 2024 23:13:54 +0100
Date: Thu, 31 Oct 2024 23:13:47 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 0/9] Support wildcard netdev hooks and events
Message-ID: <ZyQBG7GkMEhBvoGH@calendula>
References: <20241002193853.13818-1-phil@nwl.cc>
 <20241031220823.GA5312@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241031220823.GA5312@breakpoint.cc>
X-Spam-Score: -1.8 (-)

On Thu, Oct 31, 2024 at 11:08:23PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > This series is the second (and last?) step of enabling support for
> > name-based and wildcard interface hooks in user space. It depends on the
> > previously sent series for libnftnl.
> > 
> > Patches 1-4 are fallout, fixing for deficits in different areas.
> 
> These look good, happy to see typeof support on json side, feel free to
> push them out.

Ack for 1-4 in this series, thanks.
