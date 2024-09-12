Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2C619048C
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 20:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726173843; cv=none; b=f9eVxDo7lacmIWtoi5jbbe7g1iSGBJdmV1yzeXJOKvEmE2Uk+x+Q7CAGxNSzXSNULks7oYcwysv7aVB655wed5RMn5XidN5Aj42t0p2vh6AOomtLJbDEmrZfzII2GWbz5cMkTivrk4sfi9cuRitwWAoV3iDogtqs9tulb+xQZ0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726173843; c=relaxed/simple;
	bh=Du1EPGlly5FUuUoagzQfyubnuICfCH5DBJ+pRK8Z8Fo=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FWtDuWaRVZGpmiaiIEtaPVcLqSIn814GX+4gpVrUf/vZQC50Pjd9oJgo4sz9+aLkSaGadja4DO2hrCwt9Oz/p78oDR+wxuKp892GeE5VlmZ2pxsgeqYk0NLS8kiH1S/yUl8HRB8MM8aOdQllTXV7Yd4CVqXp6oImzp1ehIVJiEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1soqfV-0006O5-BC; Thu, 12 Sep 2024 22:43:57 +0200
Date: Thu, 12 Sep 2024 22:43:57 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: Re: [nf-next PATCH v3 11/16] netfilter: nf_tables: chain: Respect
 NETDEV_REGISTER events
Message-ID: <20240912204357.GB23935@breakpoint.cc>
References: <20240912122148.12159-1-phil@nwl.cc>
 <20240912122148.12159-12-phil@nwl.cc>
 <20240912144041.GE2892@breakpoint.cc>
 <ZuMDTL1P-NZ_Ezyk@orbyte.nwl.cc>
 <20240912151203.GA32404@breakpoint.cc>
 <ZuMLnfwhTdyqp90C@orbyte.nwl.cc>
 <20240912160639.GA9554@breakpoint.cc>
 <ZuMV7bQXHC3J3zU8@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZuMV7bQXHC3J3zU8@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> > I.e., if no matching new hook, just unreg, else register new/unregister
> > old.
> 
> I can't bind a device to multiple flowtables of the same family, so I
> can't bind first, then unbind.

I'm dense, why does that not work?
