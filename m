Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64F0133423;
	Wed, 24 Jan 2024 20:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706127225; cv=none; b=ZcFyGMobizMB8HT6vfhFw8x5DLITkThnO0nPkQjrsUEbCa8cH9gotrq9Ef94KGDPWfUSXqc2KlOmEVeUod8oL6ILlgVz3wVWshuGDgdljKI5RprC23S2LmxVEPZAdzdWRO7mNRx81pmyRdRym8dd1Rn14Yq3Csdo6WmZqzuXgRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706127225; c=relaxed/simple;
	bh=jvlK1XKPj74FyfW8+IODLDvDmouCVkNHbde8CZTmkXQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YtbGGtpWk+DzIqBUaIvP+SparrJJpXzIcxWjbZfDfdrC+q7MKPW6PZQu4VpKyT7u0od7rEeQ7J7zD37pbL4VQAjkZf81V16eJdP8Xfin66MWU2B4E0PndKxCw2UDE254ebBRljrBOUoIOjn2ud38DU5ufx1Ymdy77+z8xIvYMwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k5MM3NgR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k5MM3NgR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4842AC433F1;
	Wed, 24 Jan 2024 20:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706127224;
	bh=jvlK1XKPj74FyfW8+IODLDvDmouCVkNHbde8CZTmkXQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=k5MM3NgRzoCdmTk9wuznplH/2x151KSSNazUQsDtXh7sML4Eub5gGAdB5RJHDhsDh
	 +4tasUFuIsZv3t1ckuScmU22DETMz6oqnoo11qbDBvu4bbAkZt1n2UNR+/sdcM0b8b
	 pJq9+CJ3lSCuKFUAT+U9xB2MC9lL/ZKnDwtVxZfW4gQDZ6AdyUJnID+8KLr6KhCZpb
	 fcuarrceU9Q11l88l095f1zbirwA+nUQWm0zlLZuyTXIifjl2K1am20uKuVKFtu19t
	 v/6LlecaM2DXvxxhRjqHIkQbk3XGKUuH+aMaijx7JxkWXoyp6hJYsRbzBXc88Re7zy
	 jwQzUBVKJzH6w==
Date: Wed, 24 Jan 2024 12:13:43 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>, David Ahern
 <dsahern@kernel.org>, coreteam@netfilter.org,
 "netdev-driver-reviewers@vger.kernel.org"
 <netdev-driver-reviewers@vger.kernel.org>, Hangbin Liu
 <liuhangbin@gmail.com>, netfilter-devel@vger.kernel.org
Subject: Re: [netfilter-core] [ANN] net-next is OPEN
Message-ID: <20240124121343.6ce76eff@kernel.org>
In-Reply-To: <ZbFsyEfMRt8S+ef1@calendula>
References: <20240122091612.3f1a3e3d@kernel.org>
	<Za98C_rCH8iO_yaK@Laptop-X1>
	<20240123072010.7be8fb83@kernel.org>
	<d0e28c67-51ad-4da1-a6df-7ebdbd45cd2b@kernel.org>
	<65b133e83f53e_225ba129414@willemb.c.googlers.com.notmuch>
	<20240124082255.7c8f7c55@kernel.org>
	<20240124090123.32672a5b@kernel.org>
	<ZbFiF2HzyWHAyH00@calendula>
	<20240124114057.1ca95198@kernel.org>
	<ZbFsyEfMRt8S+ef1@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 Jan 2024 21:02:16 +0100 Pablo Neira Ayuso wrote:
> On Wed, Jan 24, 2024 at 11:40:57AM -0800, Jakub Kicinski wrote:
> > Hm, odd, it's there:
> > 
> > $ ls /lib64/xtables/libxt_conntrack.so
> > /lib64/xtables/libxt_conntrack.so
> >
> > but I set a custom LD_LIBRARY_PATH, let me make sure that /lib64 
> > is in it (normal loaded always scans system paths)!  
> 
> Could you also check your ./configure output for iptables? It shows
> the directory where the .so file are search and found:
> 
>   ...
>   Xtables extension directory:          /usr/lib/xtables

I'm using the OS iptables, I was hoping that for net/ tests
OS iptables should be good enough :S Is there a way to get
the info you're after?

$ iptables -V 
iptables v1.8.8 (nf_tables)

> > > What is the issue?  
> > 
> > A lot of the tests print warning messages like the ones below.
> > Some of them pass some of them fail. Tweaking the kernel config
> > to make sure the right CONFIG_IP_NF_TARGET_* and CONFIG_IP_NF_MATCH_*
> > are included seem to have made no difference, which I concluded was
> > because iptables CLI uses nf_tables here by default..  
> 
> Please, check if the symlink refers to -legacy or -nft via:
> 
> $ ls -la /usr/sbin/iptables

Ah, neat:

$ ls -la /etc/alternatives/iptables
lrwxrwxrwx. 1 root root 22 Jan  7 22:10 /etc/alternatives/iptables -> /usr/sbin/iptables-nft
$ ls -la /usr/sbin/iptables
lrwxrwxrwx. 1 root root 26 Jan  7 22:10 /usr/sbin/iptables -> /etc/alternatives/iptables

> > [435321]$ grep -nrI "Warning: Extension" .
> > ./6-fib-tests-sh/stdout:305:# Warning: Extension MARK revision 0 not supported, missing kernel module?  
> 
> This could come from either legacy or nftables:
> 
> libxtables/xtables.c:                                   "Warning: Extension %s revision 0 not supported, missing kernel module?\n",
> iptables/nft.c:                         "Warning: Extension %s revision 0 not supported, missing kernel module?\n",
> 
> both have the same error.
> 
> if that is the nftables backend, it might be also that .config is
> missing CONFIG_NF_TABLES and CONFIG_NFT_COMPAT there, among other
> options.

FWIW full config:

https://netdev-2.bots.linux.dev/vmksft-net-mp/results/435321/config

CONFIG_NFT_COMPAT was indeed missing! Let's see how it fares with it enabled.
