Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083BF256C6B;
	Mon, 10 Feb 2025 20:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739219229; cv=none; b=D8cvTfgxydW2o+qyBu3EOV4K3OYotACuB4DsN8ZpHAp4Em5R4b1DNu+rmeyLX6Tr1U7NNUItsexQATbLBKjWecirTAWaCTxjCIbXODBM1NAh0C7tnpb66Mx8gsRw1ZK7SjurewbV56Qo4aPIBXVsNCd/wDHlBaNpaw7a8Xy1RXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739219229; c=relaxed/simple;
	bh=AVaZRDDfJNWn1t6RUelfenG5jVFwXaFuNMy4sEriHeQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iSHDkNhTFrtgGyl6dO4rZqfWctWuCjmqPE50z3gTMAet0oM/58RDagyuvsl7maUyEJy9mpY67Gm7S1mUrHwgnEhl1QRKk8qEyu0raf2UiWEcZQiNQpEaXQJZ3JGEMOVjBiUs6KY1Szukuq1t4kYYH6dxn03G8GwTLQDSQ3j3Ne0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1thaMx-0003KB-JO; Mon, 10 Feb 2025 21:27:03 +0100
Date: Mon, 10 Feb 2025 21:27:03 +0100
From: Florian Westphal <fw@strlen.de>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, donald.hunter@gmail.com
Subject: Re: [PATCH v2 net-next] netlink: specs: add conntrack dump and stats
 dump support
Message-ID: <20250210202703.GA12476@breakpoint.cc>
References: <20250210152159.41077-1-fw@strlen.de>
 <20250210103926.3ec4e377@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250210103926.3ec4e377@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Jakub Kicinski <kuba@kernel.org> wrote:
> On Mon, 10 Feb 2025 16:21:52 +0100 Florian Westphal wrote:
> > This adds support to dump the connection tracking table
> > ("conntrack -L") and the conntrack statistics, ("conntrack -S").
> 
> Hi Florian!
> 
> Some unhappiness in the HTML doc generation coming from this spec:
> 
> /home/doc-build/testing/Documentation/networking/netlink_spec/ctnetlink.rst:68: WARNING: duplicate label conntrack-definition-nfgenmsg, other instance in /home/doc-build/testing/Documentation/networking/netlink_spec/conntrack.rst

Looks like the tree has both v1 and v2 appliedto it.

v1 added 'ctnetlink.yaml', I renamed it to 'conntrack.yaml' in v2 as
thats what Donald requested.
