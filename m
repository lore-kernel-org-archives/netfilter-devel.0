Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872D419C57D;
	Thu, 10 Oct 2024 17:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728583171; cv=none; b=NuTQEdwKFwh3Yprl+2M2mlxwO3wCu8d3p+uzkw2uk7ZVC9Fy6WZkcIIq5Fao7R6K+9CqgjnHzRItF+btaiT92VvFFIe7XcrxkBiuaOd5BafYmMSP9XaNWU2ZMGCqm17ePKqzEuChDaI35qUlCVeaPVNVuOOr+UQwgLh6CtnX4bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728583171; c=relaxed/simple;
	bh=qfykBgfbtJOYVMCMJ6rPDAFl8steKNqmHZFQMQv+e9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tZmNtWCmaVrXbz0E5pf6Hq1teB19UUdEEdo0wfTDxVT05fm91fKLsdH6fH2uG/LkchhVo2+Za8gr+Ar7SdVIWk0btROCd7KdFdQuRPUtokRuKMj6rWTr2QVyJhos9SmPBWRaKq4psCMbtIiUssJGldS0GtfU95mMSVZEzGRM7jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1syxRd-0003Og-C8; Thu, 10 Oct 2024 19:59:25 +0200
Date: Thu, 10 Oct 2024 19:59:25 +0200
From: Florian Westphal <fw@strlen.de>
To: Paul Moore <paul@paul-moore.com>
Cc: Florian Westphal <fw@strlen.de>, Richard Weinberger <richard@nod.at>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
	davem@davemloft.net, kadlec@netfilter.org, pablo@netfilter.org,
	rgb@redhat.com, upstream+net@sigma-star.at
Subject: Re: [PATCH] netfilter: Record uid and gid in xt_AUDIT
Message-ID: <20241010175925.GA11964@breakpoint.cc>
References: <20241009203218.26329-1-richard@nod.at>
 <20241009213345.GC3714@breakpoint.cc>
 <CAHC9VhSFHQtg357WLoLrkN8wpPxDRmD_qA55NHOUEwFpE_pbrg@mail.gmail.com>
 <20241009223409.GE3714@breakpoint.cc>
 <CAHC9VhTC=KAXe6w9xTG_rY4zAnNvPv-brQ7cTYftcty866inCw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhTC=KAXe6w9xTG_rY4zAnNvPv-brQ7cTYftcty866inCw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Paul Moore <paul@paul-moore.com> wrote:
> Correct me if I'm wrong, but by using from_kXid(&init_user_ns, Xid) we
> get the ID number that is correct for the init namespace, yes?  If so,
> that's what we want as right now all of the audit records, filters,
> etc. are intended to be set from the context of the initial namespace.

Seems to be the case, from_kuid() kdoc says
'There is always a mapping into the initial user_namespace.'.

I'm confused because of the various means of dealing with this:
9847371a84b0 ("netfilter: Allow xt_owner in any user namespace")

Does: make_kgid(net->user_ns, ... and also rejects rule-add if
net->user_ns != current_user_ns().  As this is for matching userids,
this makes sense to me, any userns will 'just work' for normal uid/gid
matching.

a6c6796c7127 ("userns: Convert cls_flow to work with user namespaces enabled")
Does: from_kuid(&init_user_ns, ... and rejects rule adds if sk_user_ns(NETLINK_CB(in_skb).ssk) != &init_user_ns)

Seems just a more conservative solution to the former one.

8c6e2a941ae7 ("userns: Convert xt_LOG to print socket kuids and kgids as uids and gids")
... which looks like the proposed xt_AUDIT change.

As I do not know what the use case is for xt_AUDIT rules residing in
another, possibly unprivileged network namespace not managed by root-root user,
I can't say if its right, but it should do the right thing.

Sorry for the noise.
