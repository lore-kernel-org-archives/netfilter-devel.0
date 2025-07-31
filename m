Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E483117A2E6;
	Thu, 31 Jul 2025 15:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753977062; cv=none; b=jVlNjfHwxX7TYB0KJmE32euJMzoyJ6bVjGrLxZftZL0OMNHiTqe1obBUlXWvxRdg/wSNuKmBSpdDJ5jN4KVtOTklFsbB8aXoC0wSHxo8VNeLLJ0NUekE8s1dA+pQlFKnxSku+exMK+bpsUoNnOMJMOcuV/ht/NGk4PMGTHBPhYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753977062; c=relaxed/simple;
	bh=gpuLRVZkZgF93ImwxDdLK+qmOrIIYkJ+AogxJ7Hs1Jc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cuy1c9iIXzZKe0dlDtfOn9Rx8lHjc5OYfgMyW78/35Om12cXig6Q1e4DAjMnoMU1+a/08+rIgZZMESrvyhlF/2j8A1onteUGiRj5FVcvaha+qb0BfgdScxtoTnZ5I+cHeQnV+79wvK3S02Bun90KQTUevnyiGwkDtotn1uuJgBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 04C53602B2; Thu, 31 Jul 2025 17:50:58 +0200 (CEST)
Date: Thu, 31 Jul 2025 17:50:59 +0200
From: Florian Westphal <fw@strlen.de>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Arnd Bergmann <arnd@arndb.de>, Simon Horman <horms@kernel.org>,
	Breno Leitao <leitao@debian.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, bridge@lists.linux.dev,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: add back NETFILTER_XTABLES dependencies
Message-ID: <aIuQ4-f267nn4G3P@strlen.de>
References: <20250730214538.466973-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250730214538.466973-1-arnd@kernel.org>

Arnd Bergmann <arnd@kernel.org> wrote:
> 
> Some Kconfig symbols were changed to depend on the 'bool' symbol
> NETFILTER_XTABLES_LEGACY, which means they can now be set to built-in
> when the xtables code itself is in a loadable module:
> 
> x86_64-linux-ld: vmlinux.o: in function `arpt_unregister_table_pre_exit':
> (.text+0x1831987): undefined reference to `xt_find_table'
> x86_64-linux-ld: vmlinux.o: in function `get_info.constprop.0':
> arp_tables.c:(.text+0x1831aab): undefined reference to `xt_request_find_table_lock'
> x86_64-linux-ld: arp_tables.c:(.text+0x1831bea): undefined reference to `xt_table_unlock'
> x86_64-linux-ld: vmlinux.o: in function `do_arpt_get_ctl':
> arp_tables.c:(.text+0x183205d): undefined reference to `xt_find_table_lock'
> x86_64-linux-ld: arp_tables.c:(.text+0x18320c1): undefined reference to `xt_table_unlock'
> x86_64-linux-ld: arp_tables.c:(.text+0x183219a): undefined reference to `xt_recseq'
> 
> Change these to depend on both NETFILTER_XTABLES and
> NETFILTER_XTABLES_LEGACY.

Thanks Arnd.  I thought we could just replace NETFILTER_XTABLES depends
with NETFILTER_XTABLES_LEGACY, but I missed the difference between
tristate and bool.

Acked-by: Florian Westphal <fw@strlen.de>

