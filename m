Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656641A9B3F;
	Tue,  8 Apr 2025 16:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744130384; cv=none; b=Urwez9jj28mgnBHbouBRQsZBIaMsP3tkfreRkzHtiduUhUKqhbf8tKz/bRIWhBO3optHYNVqW2UfpYMLFTUiPG4stLcl5KxNLHopFZC5HxxQ4Di8MS9KzYujV2AX/uF7XBI9sA7Fkm1x0oTjfTt7CMvhwTXG+DxzpjuJxCp/ZrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744130384; c=relaxed/simple;
	bh=eVUP9vSGpI5ZXVgI2CJkZzSUa6Y9aJynfJwf/r0BijQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jYvWYha8qUDgISjHInYwvNAencRuQ8RM6Y6TRpTzT2E6Dw3RLlqY5gDcOn86YnncR/S9tUSys9JvTldYx64J65qb87w1x0q9/2tLu7bQkyCyb1G6qj+diB/2lEO0Pu9AjnqcDN5/NRZL2U3jRl9DtNnHGRSZ3/qTHit5UxQ21lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u2Bz1-0004f3-2a; Tue, 08 Apr 2025 18:39:31 +0200
Date: Tue, 8 Apr 2025 18:39:31 +0200
From: Florian Westphal <fw@strlen.de>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: [PATCH v11 nf-next 1/2] netfilter: bridge: Add conntrack double
 vlan and pppoe
Message-ID: <20250408163931.GA11581@breakpoint.cc>
References: <20250408142619.95619-1-ericwouds@gmail.com>
 <20250408142619.95619-2-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250408142619.95619-2-ericwouds@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Eric Woudstra <ericwouds@gmail.com> wrote:
> This adds the capability to conntrack 802.1ad, QinQ, PPPoE and PPPoE-in-Q
> packets that are passing a bridge.

Conntrack is l2 agnostic, so this either requires distinct
ip addresses in the vlans/pppoe tunneled traffic or users
need to configure connection tracking zones manually to
ensure there are no collisions or traffic merges (i.e.,
packet x from PPPoE won't be merged with frag from a vlan).

Actually reading  nf_ct_br_defrag4/6 it seems existing
code already has this bug :/

I currently don't see a fix for this problem.
Can't add L2 addresses to conntrack since those aren't
unique accross vlans/tunnels and they can change anyway
even mid-stream, we can't add ifindexes into the mix
as we'd miss all reply traffic, can't use the vlan tag
since it can be vlan-in-vlan etc.

So likely, we have to live with this.

Maybe refuse to track (i.e. ACCEPT) vlan/8021ad qinq, etc.
traffic if the skb has no template with a zone attached to it?

This would at least push 'address collisions' into the
'incorrect ruleset configuration' domain.
