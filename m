Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD4D17A305;
	Sun, 19 Apr 2026 10:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776594309; cv=none; b=ZX/RsmkQQVNOt93INlM46UFrjJ1AtoVSKuHCuMRUuRhAtbdApEoanhq+h0ze+qVMSQ8GaLCcQT2Weh+1llGD80TCiY34D0X/bFq63vYmUTASHCDCuCoZKCs4wQvAM2uaBtW/1erxM5Ze2vD5gFbHqG1jseh3wzzyM0Oc2tx0oTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776594309; c=relaxed/simple;
	bh=1AETEye2n5BqQfWpwqwE3uKRWeF6PjS/uvoyZ2bBZUQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JFIRixMocW4ITpg86dPg4Nv7iEBIt02G/bc4MGaY1uG8V/2AIei5cpWJqug58kfwVCWSZqqmfSpfL9ARYfZjlGBb5m72APCuWStW974KIAPbRB3lrLrT19aiZhQcjaMdfPSNUh8UxBR5fbRytXPLCPlJ3I4r5OzWFNoi4mI+c5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OLyHmMPN; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OLyHmMPN"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id DF58960179;
	Sun, 19 Apr 2026 12:24:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776594297;
	bh=vbQW3CZlEvB4l+2tXDghlNC9xoerUt/G4afV7MdnnvI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OLyHmMPNp+8/18uXiLZRSmBka8ONYm6A2ztEKD1tFaZb9nn0jWjpGl5Uv43W/JRD0
	 0VH/Jyc7USkJeXHpNs/U9UUeGMrTnEO8SJKQIvGk25dj0Nmi5lNZJTglBziRUXcqG8
	 yL0T0ZE2qtRWU3qQeTMYsyJ46zLAOw2aM11Gktbp5CYefIa1XYf+cMnhkIAjYKRoZ3
	 3RdpUCB/dbuRQg6k/tG2U4cYJKoM/BkVfBW+lC26nwbKpxcPxDYa3L78TbKSDUN3Vs
	 H9Q+1bCQ1lf5bfhh8f9UHjRfeblOa0GtgdEUMKnvkTkl51n6WbyucuSOj73kT9OoxR
	 nwcPhRyUQ7dbA==
Date: Sun, 19 Apr 2026 12:24:54 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Weiming Shi <bestswngs@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Phil Sutter <phil@nwl.cc>, Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH nf] netfilter: xt_TCPMSS: check skb_dst before path-MTU
 clamping
Message-ID: <aeStdnf-xEbtFVkb@chamomile>
References: <20260418163057.2611503-2-bestswngs@gmail.com>
 <aePiSwmP6YEQ4mNE@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aePiSwmP6YEQ4mNE@strlen.de>

On Sat, Apr 18, 2026 at 09:58:03PM +0200, Florian Westphal wrote:
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
> 
> validation is done too early, at expression instantiation
> time.
> 
> This doesn't work because we have incomplete graph, it has
> to be done at final table validation time.

I remember this used to work, maybe it broke with recent updates on
the chain graph detection?

Once the non-basechain is added it should consider the basechain where
this can be reached.

> But then all required compat info (xtables hints) is gone
> and no longer available.

What?

> AFAICS the only way to resolve this is to cache the info in
> the nft_expr priv area (WHERE IS ABSOLUTELY DOESN'T BELONG!)
> because thats the only storage thewre is.

No.
