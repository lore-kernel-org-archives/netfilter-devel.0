Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D53460EC4;
	Thu, 27 Jun 2024 20:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719518460; cv=none; b=DWhdR6d3GqkdSvTjzLUlnyaTATSzJ4XNQhjDqJtR39rgwYuOSDE5KQ9HMu4d/PZ4qMKkN1dALeOAsF8QEMNP1WFTDSB3+J0kiLAs1Oii9ihaz20tI5Yum7qxzUW+n5CnhDpHoiqfgGPD1Ur3SnTlDGN++qbOJapwqyU0kEoaOjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719518460; c=relaxed/simple;
	bh=evboQ7WIE6MM6hHChdF4SsKYOQlEdGGWnOmmziYT1Ac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eUJYMBQcMHaQx+2oHIV6suDCuVfrqcP0o055hmTkd0rEbQG+AJxnns8RAH1VBkNGeqDQrAbYR6QNU2P7z3pM44h9cTA8/RViyo/Okiv5gOzfnZo7ggXeuQc+dDq7qguIZlZGn+jRFvXZYeW7z5X0DVVfjyF+G7SeI63Lz+C7Pjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sMvIX-0004ym-MI; Thu, 27 Jun 2024 22:00:49 +0200
Date: Thu, 27 Jun 2024 22:00:49 +0200
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	fw@strlen.de
Subject: Re: [PATCH nf-next 00/19] Netfilter/IPVS updates for net-next
Message-ID: <20240627200049.GA18997@breakpoint.cc>
References: <20240627112713.4846-1-pablo@netfilter.org>
 <Zn1M890ZdC1WRekQ@calendula>
 <20240627113202.72569175@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240627113202.72569175@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu, 27 Jun 2024 13:28:51 +0200 Pablo Neira Ayuso wrote:
> > Note for netdev maintainer: This PR is actually targeted at *net-next*.
> > 
> > Please, let me know if you prefer I resubmit.
> 
> Not a big deal, but since you offered I have another ask - looks like
> this series makes the nf_queue test time out in our infra.
> 
> https://netdev.bots.linux.dev/contest.html?test=nft-queue-sh
> 
> Could you take a look before you respin? It used to take 24 sec,
> not it times out after 224 sec..

Looks like its the sctp selftests that got added, I can have a look
tomorrow.
