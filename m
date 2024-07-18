Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9508488;
	Thu, 18 Jul 2024 07:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721286020; cv=none; b=FAqULGD8Dzls1zfRoVDhvNpyyl7UhoPYt/IRZkO5CP2uAiRnzcfYKyFGYqX7+AQoyp8Fx8qQAtBoZHZmqe3ut8DlUb7/hwSrHVEub6LjfnXcFuPzqbDqPYyY/LwsK0JmmR/i2QxNJ5KaJ8ZGFwoRSCBrtFafkFJTtwKowzitT4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721286020; c=relaxed/simple;
	bh=ma/JWn43M31h0h+6mD53fuaBr/7kmS/P+I9sLH+1Kxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hC0yIqrxxCYmhpoBg33GA7QmYskvvFGDwK1cSzNkzxRKmxDO8Lxng3FV5whWw3TzG3R53mGB+UWDvGl6DeyqH1pfk1WC80qgAeBHggWj52fGV8xFaXcTdyL6SMrxSsMwgqgwwflkd++AH9H/A3O7I0u2Plwwd5IbdUQ9jpr3hDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sUL7X-0006Z6-TX; Thu, 18 Jul 2024 09:00:07 +0200
Date: Thu, 18 Jul 2024 09:00:07 +0200
From: Florian Westphal <fw@strlen.de>
To: Xin Long <lucien.xin@gmail.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	network dev <netdev@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>, davem@davemloft.net,
	kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>, Pravin B Shelar <pshelar@ovn.org>,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>
Subject: Re: [PATCH nf-next] netfilter: move nf_ct_netns_get out of
 nf_conncount_init
Message-ID: <20240718070007.GA24862@breakpoint.cc>
References: <7380c37e2d58a93164b7f2212c90cd23f9d910f8.1721268584.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7380c37e2d58a93164b7f2212c90cd23f9d910f8.1721268584.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Xin Long <lucien.xin@gmail.com> wrote:
> This patch is to move nf_ct_netns_get() out of nf_conncount_init()
> and let the consumers of nf_conncount decide if they want to turn
> on netfilter conntrack.
> 
> It makes nf_conncount more flexible to be used in other places and
> avoids netfilter conntrack turned on when using it in openvswitch
> conntrack.

Reviewed-by: Florian Westphal <fw@strlen.de>

