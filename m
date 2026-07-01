Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F559342CBA;
	Wed,  1 Jul 2026 14:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782915477; cv=none; b=tsESK4aIswAJa0qEuSqdyrJ+LD0F6FqPtkTI8UsKqKim2c1GdRUvbtl9cd2+r1YX79gYt9Qzy/jtXZLNS7F5tejF6oc/MNap/htDGy4kTwqGX0zCPMyNJlcZBi5Z02H/ryXKMWtnAe7KdcI08gIiBsT+ywtvLq5oyAjNga8fxnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782915477; c=relaxed/simple;
	bh=k6LECcbTjET81JRiNv3dKbsSJKWjbcnf+gM1BZK6ML0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dpc4K7s4M5O+uKfo9kAeahYGFrDASLlAlE6EL40XAgWK/voJ7jCG1a6het5zOGCnMhZ8IHXvvUfyNk8be+j8inZi3nmawLV4ukHMlsVdgz98L5aV/T23L9nD7nlCDaqRnj4chnOMMIsgKT9sOn7OSvKUFaSb1YbEkm2VgA/sgo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 935F76064B; Wed, 01 Jul 2026 16:17:50 +0200 (CEST)
Date: Wed, 1 Jul 2026 16:17:45 +0200
From: Florian Westphal <fw@strlen.de>
To: xietangxin <xietangxin@h-partners.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	gaoxingwang <gaoxingwang1@huawei.com>,
	huyizhen <huyizhen2@huawei.com>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nf_nat_masquerade: recalculate TCP TS
 offset when port is randomized
Message-ID: <akUhid7_3iHovivd@strlen.de>
References: <20260629093408.3927103-1-xietangxin@h-partners.com>
 <akKN4cywAsFRdefX@strlen.de>
 <0ad60f06-387e-49bc-9e26-3dcebf182cb4@h-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ad60f06-387e-49bc-9e26-3dcebf182cb4@h-partners.com>

xietangxin <xietangxin@h-partners.com> wrote:
> Shifting the helper down to nf_nat_l4proto_unique_tuple() as you suggested
> encounters a structural roadblock. we don't have access to the skb there.
> Adding skb to all intermediate callers (like nf_nat_setup_info, get_unique_tuple)
> would severely pollute the core NAT APIs.

Right, propagating the skb is too much code churn.

> would it be acceptable to place this logic in nf_nat_inet_fn() before do_nat?
> 
>  963 do_nat:
>              ..here

This is hit for every packet, not just the first one after
nf_nat_setup_info().  I suggest a slightly earlier spot in the
same function.

 936                                 ret = e->hooks[i].hook(e->hooks[i].priv, skb,
 937                                                        state);
 938                                 if (ret != NF_ACCEPT)
 939                                         return ret;
 940                                 if (nf_nat_initialized(ct, maniptype))
 941                                         goto do_nat;
 942                         }
 943 null_bind:
 944                         ret = nf_nat_alloc_null_binding(ct, state->hook);
 945                         if (ret != NF_ACCEPT)
 946                                 return ret;

 .... Here.

 947                 } else {

This spot runs only for new connections, right after a nf_nat_setup_info() call.
