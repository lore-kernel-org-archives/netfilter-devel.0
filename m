Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE9221C174;
	Wed, 20 Aug 2025 14:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755698691; cv=none; b=JszeB6pJVgZrdJWqC6g8kn0g/5gV/NQkUcI/wVlCW2oncRRYcoy+705hHbHR6MC4GenDAk9U0BV9CGj3cyEq+eEQkOlPJKFflLl5T0QvVwKnVzR2t6satl/oW2q9lATWJgtAFsQpFGdLOEJgW1/bsLUvAmCedM6n4A5+KETFFKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755698691; c=relaxed/simple;
	bh=SPJ+BBwAbAmnGlLEH9Y5m02OS4ByPeGPck4jVufiez8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oinev7hbcabUPwYh6B4bPpk0WV1ciWA8n1Xw/EHh4FQYjQRmpcxGLC99c8K8ETzAa8F6U0A32ONpe21NX+0anwxm3M1Fj02fEZTtwl1VqxowEpCcxoxgsVz4+rq+XOXTf7JI5fMPhPzl0T62fP8c8TxDBpTBn96Ic6D4x9FG7P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A641D602F8; Wed, 20 Aug 2025 16:04:47 +0200 (CEST)
Date: Wed, 20 Aug 2025 16:04:47 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nf_reject: don't leak dst refcount for
 loopback packets
Message-ID: <aKXV_3J4iDkhQ06R@strlen.de>
References: <20250820123707.10671-1-fw@strlen.de>
 <aKXKpE35H7KBzdBa@calendula>
 <aKXLsoLkSdnEU_at@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKXLsoLkSdnEU_at@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Instead of checking hook just check if the skb already has a route
> > > attached to it.
> > 
> > Quick question: does inconditional route lookup work for br_netfilter?
> 
> Never mind, it should be fine, the fake dst get attached to the skb.

Good point, this changes behaviour for br_netfilter case, we no
longer call nf_reject_fill_skb_dst() then due to the fake dst.

I don't think br_netfilter is supposed to do anything (iptables
-j REJECT doesn't work in PRE_ROUTING), and we should not encourage
use of br_netfilter with nftables.

What about adding a followup patch, targetting nf, that adds:

if (hook == NF_INET_PRE_ROUTING && nf_bridge_info_exists(oldskb))
	return;

?

After all, there is no guarantee that we have the needed routing
info on a bridge in the first place.
