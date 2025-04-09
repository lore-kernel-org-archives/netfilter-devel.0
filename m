Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414622550C5;
	Wed,  9 Apr 2025 10:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744195543; cv=none; b=ujdYMVB7hGpVQMYDkUxCvi98mJ2tLPO5hdjFAGNet7F3wKXys8n4bW35Msd6dozFjMNjXFKUUkPQJ83TFfcL0AwS8ukxZa/OXEVFi0qLGOnRYMmRWAMkhCicHMIoAXiS557hpZTZmOanImIgbyuoW2tr3RlTavqnMXngwjiAuyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744195543; c=relaxed/simple;
	bh=Zd42bH/iKPNHGtL2PyAIzxQXMD0Ub6g/t7/nY59Wno4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KElfBFiGs04KQ/6oqFbJS3Q7LpVly5WN4lvL6skkNKNYV9OpKBGRPF0quOXb/l4ATZe/pOtw8LiATVm8jKK029oaeZK/8TMgsGwfiKcLZUh30v0xvFJJ92bY07jnMikYvax0n3AQZzzV1HriIbcrKfh1Zvs5Unh9mfqgrnSSI6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u2Svt-0005gk-4E; Wed, 09 Apr 2025 12:45:25 +0200
Date: Wed, 9 Apr 2025 12:45:25 +0200
From: Florian Westphal <fw@strlen.de>
To: Yang =?utf-8?B?SHVhamlhbu+8iOadqOWNjuWBpe+8iQ==?= <huajianyang@asrmicro.com>
Cc: Florian Westphal <fw@strlen.de>,
	"pablo@netfilter.org" <pablo@netfilter.org>,
	"kadlec@netfilter.org" <kadlec@netfilter.org>,
	"razor@blackwall.org" <razor@blackwall.org>,
	"idosch@nvidia.com" <idosch@nvidia.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"dsahern@kernel.org" <dsahern@kernel.org>,
	"edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>,
	"horms@kernel.org" <horms@kernel.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"coreteam@netfilter.org" <coreteam@netfilter.org>,
	"bridge@lists.linux.dev" <bridge@lists.linux.dev>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIG5ldDog?=
 =?utf-8?Q?Expand_headroo?= =?utf-8?Q?m?= to send fragmented packets in
 bridge fragment forward
Message-ID: <20250409104525.GC17911@breakpoint.cc>
References: <20250409073336.31996-1-huajianyang@asrmicro.com>
 <20250409091821.GA17911@breakpoint.cc>
 <0a711412f54c4dc6a7d58f4fa391dc0f@exch03.asrmicro.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0a711412f54c4dc6a7d58f4fa391dc0f@exch03.asrmicro.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Yang Huajian（杨华健） <huajianyang@asrmicro.com> wrote:
> > if (skb_headroom(skb) < ll_rs)
> >	goto expand_headroom;
> 
> > ... but I'm not sure what the actual problem is.
> 
> Yes, your guess is correct!
> 
> Actual problem: I think it is unreasonable to directly drop skb with insufficient headroom.
> 
> > Why does this need to make a full skb copy?
> > Should that be using skb_expand_head()?
> 
> Using skb_expand_head has the same effect.
 
> > Actually, can't you just (re)use the slowpath for the skb_headroom < ll_rs case instead of adding headroom expansion?
> 
> I tested it just now, reuse the slowpath will successed.
> But maybe this change cannot resolve all cases if the netdevice really needs this headroom.

The slowpath considers headroom requirements, see ip_frag_next():

        skb2 = alloc_skb(len + state->hlen + state->ll_rs, GFP_ATOMIC);

You should wait for more feedback and then send a v2 tomorrow.

Thanks!
