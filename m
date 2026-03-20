Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FE733DEF3
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2026 12:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774008258; cv=none; b=YeNy6lDxLc60ljmnUXkfncwdR0Z+mszMix/EVj84U9Px+RPumZ40FZIPHkFhH6rWh4jFeVJmYumbnBqkSWl/tWqGX//2VLk52v5VWx12ynbQ6f/neIolwn/3tQSDxHFQkC/kh/odU0nnpjUpI24M1OvrGMgzN7+IpH4bpopfTQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774008258; c=relaxed/simple;
	bh=yFRyjLxNKRnqFl8lhd5bBACnejG2YQqYkJyULlO+i4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E9wEtVYcvDe6DETfiQV9FJsiyu/tduX9B4wkV7YhR0C1B53tLKmqfQLpo3qiut/8yaAZCIH0S5In0ve0gooe+yplHkh+DXZ4rK050eeu3mZDcBDm2znG6w3aHOZYzg/kc1eciKFr5bE5WCMXPxNt8xZWtc2zfIsY37ZtO4en08o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id AA0F26080C; Fri, 20 Mar 2026 13:04:14 +0100 (CET)
Date: Fri, 20 Mar 2026 13:04:14 +0100
From: Florian Westphal <fw@strlen.de>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/1] netfilter: ipset: Fix data race between add and list
 header
Message-ID: <ab03vtQI7WWq9puC@strlen.de>
References: <20260320114041.3486273-1-kadlec@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320114041.3486273-1-kadlec@netfilter.org>

Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> Hi Pablo,
> 
> Please consider applying the next patch:
> 
> * Fix data race between add and list header commands in all hash types 
>   by protecting the list header dumping part as well.

Thanks Jozsef for the quick fix.
Just to be sure, is this nf-next or nf material?

And, what do you make of:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260313180132.75655-1-davidbaum461@gmail.com/
and
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20250722153205.4626-1-phil@nwl.cc/

?

Thanks!
