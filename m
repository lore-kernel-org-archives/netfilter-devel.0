Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502D325524E;
	Fri,  2 Oct 2026 17:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790962522; cv=none; b=tWNiIa1Xzg1jSZLX+haJohrPGsGOExcNUz50CbObNFoGwebRorxJoJ3ezunfARoxe6omtuUCEZkFIMa4tEXP88+a7RXudogd2hidb2HfHp3osHG4yZMryC+CrWsbn241HmqDm9ETZ4zZFRzqRwFNMZjmdZUA/uAwfbXEgdpRwRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790962522; c=relaxed/simple;
	bh=CPkCbiSt35ZRp1TKXcIQZP/hDsEqWnzfII691ZT6m0k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UACi7j4k5gKaSVeIdDqHgTOp+DcmbuLQzCW9ma+Wxyhm4F8ugT/7kBvkYs7q2Dxz+X0Wv+vN3Jp0nabTwwMFH5U2n/0YnDJx5gNYw7TYrkwHBoq1MbDKEbOJpTioRYY6zHkbFy/BRqsFuKAFka4xAj6eKxYrzAfqzkfbnBs/Ijg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6AA0860D1B; Fri, 02 Oct 2026 19:35:17 +0200 (CEST)
Date: Fri, 2 Oct 2026 19:35:17 +0200
From: Florian Westphal <fw@strlen.de>
To: Daehyeon Ko <4ncienth@gmail.com>
Cc: pablo@netfilter.org, phil@nwl.cc, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 net] netfilter: conntrack: reject nested ctnetlink
 master chains
Message-ID: <ar_j7KcFDHntcF39@strlen.de>
References: <20261001180224.1018290-1-4ncienth@gmail.com>
 <20261002165601.1754467-1-4ncienth@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002165601.1754467-1-4ncienth@gmail.com>

Daehyeon Ko <4ncienth@gmail.com> wrote:
> Conntracks created through ctnetlink can reference another conntrack as
> their master.  Userspace can repeat this to build an unbounded chain whose
> recursive destruction exhausts the kernel stack.
> 
> Stop the repeatable userspace paths.  Reject a direct master that already
> has a master, and reject NFQUEUE-attached expectations for such conntracks.
> Keep regular ctnetlink and kernel helper expectations unchanged.
> 
> Fixes: 5faa1f4cb5a1 ("[NETFILTER]: nf_conntrack_netlink: add support to related connections")
> Cc: stable@vger.kernel.org
> Suggested-by: Florian Westphal <fw@strlen.de>
> Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Assisted-by: LLM
> Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>

LGTM.  FWIW I think we should also apply the other patch to
destroy iteratively instead of recursing.

Reviewed-by: Florian Westphal <fw@strlen.de>
