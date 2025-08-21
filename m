Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF542D7806;
	Thu, 21 Aug 2025 06:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755759477; cv=none; b=Qr3RZZ3v7w8zG5xH0/9FUR6CppzQCfMqq6ZvdkV2TA4c/t4IU/DZTpPmVHfH96zx36FRO5MkWRHUK7cixp+ngXpbpAWiE0MFYV9ugUDs0PBL40vPeDdQOdjY8tC3mA7OrVejCPYSkZ/VFQGX7lLGnHKgxgqg/qYGU7+UbXVevVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755759477; c=relaxed/simple;
	bh=Zsqy658H8dRNDoXaGNLhO3ruTZRx6XDalsMX6lmZMeg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iG1c93LHwCN4NsrKA3lqrcwIqKtq15BMb6fbDATPf2FIc3KZ5Yb9xwG1EfwODmavlY959L0fJJEKxdjXrK8CEH63G5FcJGXMeNbqlU55BLW/UYYo0lNh/PQf2l3GogC2jo3nHQ6o+F0IBkxl32z6pNCXc+0cXjBISwmp9bYSZ4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5AD2E60224; Thu, 21 Aug 2025 08:57:52 +0200 (CEST)
Date: Thu, 21 Aug 2025 08:57:41 +0200
From: Florian Westphal <fw@strlen.de>
To: Wang Liang <wangliang74@huawei.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, razor@blackwall.org,
	idosch@nvidia.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	yuehaibing@huawei.com, zhangchangzhong@huawei.com,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	bridge@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] netfilter: br_netfilter: reread nf_conn from skb
 after confirm()
Message-ID: <aKbDZWHNf4_Nktsm@strlen.de>
References: <20250820043329.2902014-1-wangliang74@huawei.com>
 <aKWyImI9qxi6GDIF@strlen.de>
 <80706fff-ca22-45f5-ac0b-ff84e1ba6a8b@huawei.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <80706fff-ca22-45f5-ac0b-ff84e1ba6a8b@huawei.com>

Wang Liang <wangliang74@huawei.com> wrote:
> 
> 在 2025/8/20 19:31, Florian Westphal 写道:
> > Wang Liang <wangliang74@huawei.com> wrote:
> > > Previous commit 2d72afb34065 ("netfilter: nf_conntrack: fix crash due to
> > > removal of uninitialised entry") move the IPS_CONFIRMED assignment after
> > > the hash table insertion.
> > How is that related to this change?
> > As you write below, the bug came in with 62e7151ae3eb.
> 
> Before the commit 2d72afb34065, __nf_conntrack_confirm() set
> 'ct->status |= IPS_CONFIRMED;' before check hash, the warning will not
> happen, so I put it here.

Oh, right, the problem was concealed before this.

> > There is a second bug here, confirm can return NF_DROP and
> > nfct will be NULL.
> 
> Thanks for your suggestion!
> 
> Do you mean that ct may be deleted in confirm and return NF_DROP, so we can
> not visit it in br_nf_local_in() and need to add 'case NF_DROP:' here?
>
> I cannot find somewhere set skb->_nfct to NULL and return NF_DROP. Can you
> give some hints?

You are right, skb->_nfct isn't set to NULL in case NF_DROP is returned.
However, the warning will trigger as we did not insert the conntrack
entry in that case.

I suggest to remove the warning, I don't think it buys anything.

Thanks.
