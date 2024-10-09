Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E601E1E1311;
	Wed,  9 Oct 2024 21:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728509639; cv=none; b=Jh3ndJHREvnaYHk4B1Jks1+nI2Okf09+tZ6xhax118zZDWRsuX20Z5yRIGjmL+U6o2mUk3IkRkG5ZdJ3qRDMQGJ+wY3UmpyVGRUweuOnp4XHwv3D5MiRQKARFcn1rpMvQxFfmcWIXn+38s1vrHNy4nm8ijAVE6u5Ifkz2LUooKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728509639; c=relaxed/simple;
	bh=+Fd0xR/UG+8ioqSUZJZnFf3Xah1mUSdJs3dmN+ho0Ow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RuUfkRlG3mxkwx+s7Xt7oKuZ/Kn+gRA1vJzSh8O976qqbaG983EWlA6WMhuwk/ydYjG7P5Mnu5elzJvhtJQO4IFc7nagn1ksJoSwMBxqR45C03/4PqsdHGWvH7/peD1XXRtvdYhxkqMXfbEP2v8odo6bXzHkBCkIRPURiLYMIR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1syeJV-0001IL-DB; Wed, 09 Oct 2024 23:33:45 +0200
Date: Wed, 9 Oct 2024 23:33:45 +0200
From: Florian Westphal <fw@strlen.de>
To: Richard Weinberger <richard@nod.at>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
	davem@davemloft.net, kadlec@netfilter.org, pablo@netfilter.org,
	rgb@redhat.com, paul@paul-moore.com, upstream+net@sigma-star.at
Subject: Re: [PATCH] netfilter: Record uid and gid in xt_AUDIT
Message-ID: <20241009213345.GC3714@breakpoint.cc>
References: <20241009203218.26329-1-richard@nod.at>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009203218.26329-1-richard@nod.at>
User-Agent: Mutt/1.10.1 (2018-07-13)

Richard Weinberger <richard@nod.at> wrote:
> When recording audit events for new outgoing connections,
> it is helpful to log the user info of the associated socket,
> if available.
> Therefore, check if the skb has a socket, and if it does,
> log the owning fsuid/fsgid.

AFAIK audit isn't namespace aware at all (neither netns nor userns), so I
wonder how to handle this.

We can't reject adding a -j AUDIT rule for non-init-net (we could, but I'm sure
it'll break some setups...).

But I wonder if we should at least skip the uid if the user namespace is
'something else'.

> +	if (sk && sk_fullsock(sk)) {

I.e. check net->user_ns == &init_user_ns too and don't log the uid
otherwise.

I don't think auditd can make sense of the uid otherwise, resp.
its misleading, no?

Alternatively, use this instead?

kuid = sock_net_uid(sock_net(sk), sk);
from_kuid_munged(sock_net(sk)->user_ns, kuid);

There is no need to follow ->file backpointer anymore, see
6acc5c2910689fc6ee181bf63085c5efff6a42bd and
86741ec25462e4c8cdce6df2f41ead05568c7d5e,
"net: core: Add a UID field to struct sock.".

I think we could streamline all the existing paths that fetch uid
from sock->file to not do that and use sock_net_uid() instead as well.
