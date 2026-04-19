Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD9333987;
	Sun, 19 Apr 2026 08:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776585638; cv=none; b=LBqtXD2RaneOIjDy5cf0okaXdMmaqWzLGfb5Py7a/xDRODUu08WprerB9iOykI/5AQadqWLKUXKnI+YOT4OxXFp+OSiCxHWrzzC9SlAz9gDRda9WmGkKA/Dyl4zWVYq3pLu9dxigbCkDd+TIiDvuZzUgHnW8TYwNQRodPrcQ4ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776585638; c=relaxed/simple;
	bh=Z/bcn2OK8NOgU6UH+vEzzrrUVNXWK29iBoH9LmnHRUo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rNH4La7aDnT88AuCdquBHkSxMR4T5mTi9cjtKGgbioReo/H+Nm+j3YsakRCb2vpFxeLtGGiVfXvXHTbmBtvMQGlmHXnEYQqPYoYdBvZVirupxusePLH7csufuBdv9wBwpXLjkpNMyl1kqeW++yIg5pF4kzAHD8J9fUl12FX+Q18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2891B60420; Sun, 19 Apr 2026 10:00:34 +0200 (CEST)
Date: Sun, 19 Apr 2026 10:00:33 +0200
From: Florian Westphal <fw@strlen.de>
To: Weiming Shi <bestswngs@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Phil Sutter <phil@nwl.cc>, Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH nf] netfilter: xt_TCPMSS: check skb_dst before path-MTU
 clamping
Message-ID: <aeSLoQis9-cUGsvE@strlen.de>
References: <20260418163057.2611503-2-bestswngs@gmail.com>
 <aePiSwmP6YEQ4mNE@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aePiSwmP6YEQ4mNE@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> Weiming Shi <bestswngs@gmail.com> wrote:
> > When TCPMSS with CLAMP_PMTU is used via nft_compat in a non-base
> > chain, par->hook_mask is set to 0, bypassing the checkentry hook
> > validation. The target can then run at PRE_ROUTING where skb_dst is
> > NULL, causing a null-ptr-deref in tcpmss_mangle_packet():
> > 
> >  KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> >  RIP: 0010:tcpmss_mangle_packet (include/net/dst.h:219 net/netfilter/xt_TCPMSS.c:105)
> >   tcpmss_tg4 (net/netfilter/xt_TCPMSS.c:202)
> >   nft_target_eval_xt (net/netfilter/nft_compat.c:87)
> >   nft_do_chain (net/netfilter/nf_tables_core.c:287)
> >   nf_hook_slow (net/netfilter/core.c:623)
> > 
> > Check skb_dst() for NULL before calling dst_mtu().
> 
> FWIW I will apply this patch even though its wrong.
> 
> nft_compat.c is just too broken, I don't see how it can be
> fixed in any reasonable amount of time.

net/netfilter/xt_TCPMSS.c:          (par->hook_mask & ~((1 << NF_INET_FORWARD) |
net/netfilter/xt_addrtype.c:    if (par->hook_mask & ((1 << NF_INET_PRE_ROUTING) |
net/netfilter/xt_devgroup.c:        par->hook_mask & ~((1 << NF_INET_PRE_ROUTING) |
net/netfilter/xt_physdev.c:         par->hook_mask & (1 << NF_INET_LOCAL_OUT)) {
net/netfilter/xt_policy.c:      if (par->hook_mask & ((1 << NF_INET_POST_ROUTING) |
net/netfilter/xt_set.c:              (par->hook_mask & ~(1 << NF_INET_FORWARD |

Look at this I don't see an alternative to mixing nft specific bits into
x_tables, i.e.:

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -187,6 +187,8 @@ struct xt_target {
        /* Should return 0 on success or an error code otherwise (-Exxxx). */
        int (*checkentry)(const struct xt_tgchk_param *);
 
+       int (*nft_validate_chain)(const void *targinfo, unsigned int hook_mask);
+
        /* Called when entry of this type deleted. */
        void (*destroy)(const struct xt_tgdtor_param *);
 #ifdef CONFIG_NETFILTER_XTABLES_COMPAT

.. and then call that from nft_compat.c for TCPSS.
Same for matches.

