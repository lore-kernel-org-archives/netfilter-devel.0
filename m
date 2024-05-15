Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4494F3B79F;
	Wed, 15 May 2024 13:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715779671; cv=none; b=mxetzecij4q8vxOUzOu1RVelIES09fdDD1/0XTt3MmVsm/encvpoenACiYvqJOrSx5R7jYlI8BEiJVrotTXRC7BRwVmqCMt/8Y5twm/u+kB6jTrRokoFETj9olDX+ToFGoOWTrOSPZ+8hl2alWjp7+wF/chmjjWzdXu0YCUaAIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715779671; c=relaxed/simple;
	bh=egar5F40SERIW8+tix9pU35aH67Fm0M69691/Phwv0I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hEysSr4kr5mkFgWY30A14jfaLNH05ZYotngPL42ufSW/oZ1XFPFdddOViVdxdPMxvB1phu/W+T/Nu8Ej+d4uAZzpAi+8aVhisCfO+zT8oh5hBsVo+KT0XvA/VzGFkalTem1VoZh5lND0ugIRI5r7VuNTnw8jVMbcrFDlcaPhoXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1s7EfS-0001Mb-QN; Wed, 15 May 2024 15:27:38 +0200
Date: Wed, 15 May 2024 15:27:38 +0200
From: Florian Westphal <fw@strlen.de>
To: Eric Dumazet <edumazet@google.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	eric.dumazet@gmail.com, syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] netfilter: nfnetlink_queue: acquire rcu_read_lock()
 in instance_destroy_rcu()
Message-ID: <20240515132738.GD13678@breakpoint.cc>
References: <20240515132339.3346267-1-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240515132339.3346267-1-edumazet@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Eric Dumazet <edumazet@google.com> wrote:
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index 00f4bd21c59b419e96794127693c21ccb05e45b0..f1c31757e4969e8f975c7a1ebbc3b96148ec9724 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -169,7 +169,9 @@ instance_destroy_rcu(struct rcu_head *head)
>  	struct nfqnl_instance *inst = container_of(head, struct nfqnl_instance,
>  						   rcu);
>  
> +	rcu_read_lock();
>  	nfqnl_flush(inst, NULL, 0);
> +	rcu_read_unlock();

That works too.  I sent a different patch for the same issue yesterday:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20240514103133.2784-1-fw@strlen.de/

If you prefer Erics patch thats absolutely fine with me, I'll rebase in
that case to keep the selftest around.
