Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8819B34572B;
	Fri, 10 Apr 2026 10:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775817105; cv=none; b=rlkcSLmX7MqmcNpYeTVM7EmQGw2ih4u61xcd4d67sHnTGQaXp8UaVjJUXba2Appj9cQqONamLwdDA4mkZdavATH2wcaB42w/mOmWQ9RBLU97g7kF5eT3qrFGeTZZ/mS3RwRPSqJu8/ztqIjX530GjbhduK1YWvDrKeouTZwO9Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775817105; c=relaxed/simple;
	bh=TEMszoT24S5Fp2NWULGdBLvJaraVJqOg9DNqqM6UkMc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FyhcW0PAo4tGM9JbzXLeWaA7exGuLQfULCqIzAvD0kTXWKu14SaM4XG0AYcal8PW/Yab/gYER7hSTHm8xUSFbqZUSjgX4epBqSvQBX1CN/lZBQNJo9416hO7jOjy0Hm8GyvmqxKM5AqAM6cGB3n8P5gHKd69v9XgjMzqMVOthKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 030996065C; Fri, 10 Apr 2026 12:31:35 +0200 (CEST)
Date: Fri, 10 Apr 2026 12:31:36 +0200
From: Florian Westphal <fw@strlen.de>
To: Weiming Shi <bestswngs@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Phil Sutter <phil@nwl.cc>, Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH nf] netfilter: nf_tables: use RCU-safe list primitives
 for basechain hook list
Message-ID: <adjRiG_Bp3WpRYOz@strlen.de>
References: <20260410101321.915190-2-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410101321.915190-2-bestswngs@gmail.com>

Weiming Shi <bestswngs@gmail.com> wrote:
> NFT_MSG_GETCHAIN runs as an NFNL_CB_RCU callback, so chain dumps
> traverse basechain->hook_list under rcu_read_lock() without holding
> commit_mutex. Meanwhile, nft_delchain_hook() mutates that same live
> hook_list with plain list_move() and list_splice(), and the commit/abort
> paths splice hooks back with plain list_splice(). None of these are
> RCU-safe list operations.
> 
> A concurrent GETCHAIN dump can observe partially updated list pointers,
> follow them into stack-local or transaction-private list heads, and
> crash when container_of() produces a bogus struct nft_hook pointer.

Right, but this is broken by design.

> Replace list_move() in nft_delchain_hook() with list_del_rcu() plus an
> intermediate pointer array, followed by synchronize_rcu() before the
> deleted hooks' list pointers are reused to link them into the
> transaction's private list. In the error paths, put hooks back with
> list_add_tail_rcu() which is safe for concurrent RCU readers (they
> either continue to the original successor or see the list head and
> terminate the walk).

I don't understand the existing code.

I don't even understand why
we have a difference between the 'update delete' and chain delete cases.

I think its wrong to unlink and then relink on abort.
What prevents nft_delchain_hook() from using the normal approach done
by nft_delchain()...?

This existing code appears to be way too complex.
