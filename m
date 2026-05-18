Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DCF3F44CF;
	Mon, 18 May 2026 13:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779111571; cv=none; b=qwkWBWeEMXfCTz9ppGjx11IKRMBeVo8KuOfCVpBeOS+PjliQmGmIUYyqHZUricKaD1uuNFnwyNVR2SZlg8wVENc6IpMV4bZyci818yZZ7lI52AggZei7IPMqKXjxdttpQtlBxd1ad81VjO8rBNWizlZFbQaqglaLERxTvPsXAAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779111571; c=relaxed/simple;
	bh=Hir8hmBKYGNMjJzZBtqB1RYzJK/DlWgUxnz/DMurzv8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tVnNC6ITRyHibQq8iP59F6DkREgVvcOjCE/ZjJFfqUYppbUb0LF+d9lSirajduj28PKIiOXtoSdcFOojQxO8kUjbmOrbKuU2iYJfyq/LkAK1JzdoLAMOlzQ6dfoaYqKB0kq+6p7hWz8+VZ850Lss7g08rY7MQcC+QMD5W2dvLIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8E56B607E9; Mon, 18 May 2026 15:39:21 +0200 (CEST)
Date: Mon, 18 May 2026 15:39:18 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Qi Tang <tpluszz77@gmail.com>, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, herbert@gondor.apana.org.au,
	michael.bommarito@gmail.com, lyutoon@gmail.com
Subject: Re: [RFC] netfilter: disable payload mangling in userns
Message-ID: <agsWhgktcApPkJY7@strlen.de>
References: <20260515100411.3141-1-fw@strlen.de>
 <20260515114848.1105927-1-tpluszz77@gmail.com>
 <agcWBZNugohelNp6@strlen.de>
 <agr9ry_EKdTfgoaj@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agr9ry_EKdTfgoaj@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > I think we have to update nfqueue to do rudimentary header revalidation
> > and drop the packet on failure, e.g. at least making sure tot_len is not
> > past skb->len.
> 
> Agreed, nfqueue has been there for long time and such parser would
> validate the packet is correct from stack POV.
> 
> But if a new function to validate that the IP header mangling is not
> valid is feasible, then why not simply apply the same sanitization
> from inet hooks to nft_payload/nft_exthdr?

Ok, I will have a look.  Thanks for the feedback.
