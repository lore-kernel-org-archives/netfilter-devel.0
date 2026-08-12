Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B738344D8C;
	Wed, 12 Aug 2026 07:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786519211; cv=none; b=UHb7g9DaoTpqVDtxE09xk59hBNG/dV/i9rt49V8P6Ll0C80GMSR4qVW+qM/axRNk+c4lnvLU8sVPyhPjZNJZu7YzJuqCVeb/owQI7Ac78SJG/aTB/reDrGhxZoCdgpiEehVe25AyLDpK0CvHYODN5Rj1tcF1rchW+eBdEpUyJIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786519211; c=relaxed/simple;
	bh=Q0fWdNUIXO+NdzLwydgiGeIINPSosABw/lX+WA5oj3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VGP7E5nSpIm04mDuSvrrXiqCqYvDgeL+4McYVG4z0AzU0eQUFKvd8tgaWP5ADKNSBLDiCafvmGEG+M4psgSoMVY/fQthLcmnbdgOsczrfkT7DlWIgA2pg9177Na4cackxGgfP2t7Gq8MlCLtqlTqULus4Nlicps6yw1B1ovIW/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=mGdtqONd; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="mGdtqONd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786519206;
	bh=as5QtuCxiyfLhwVFPyF/4iffKO+j8e6KNxuFx43OlHw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mGdtqONdwYxr42quvJEtUFtUt2OzeJz8L8iXJk+gegvUyM3bGZl/EKUssSX5VuDEU
	 N8ngKvRuP4fAsQ9ZTM2rjfatSm9rA29nzotaM+pQ/9QtpOmsqWrQpMk2P/p0rjj9XU
	 titrlBC09+7n3BlxZ0d5XSW3T/e2KvVG+QVJabvsV0D+LuY68OI7gS7rpIV4b6Hxiu
	 oQRbUfcUT96Mm7FvZ8Kw09N43Nj7ZIjbSyZob7OaGCxXu4oJpsz5AGl4CnY84LbIHu
	 Wsp8RhEIo9ahVxhFm3FCBi5OO7fxSJ6vUofIEYHU+W6Yxvpq7mzA+bI7GqscST+qMz
	 2TMuI3Bc6hfAA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 0AC4060057;
	Wed, 12 Aug 2026 09:20:06 +0200 (CEST)
Date: Wed, 12 Aug 2026 09:20:03 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net-next 01/12] netfilter: add DEBUG_NET_WARN_ON_ONCE to
 skb_set_nfct()
Message-ID: <anweo4t-nj9305mv@chamomile>
References: <20260810194015.932627-2-pablo@netfilter.org>
 <20260812013441.1673114-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260812013441.1673114-1-kuba@kernel.org>

On Tue, Aug 11, 2026 at 06:34:41PM -0700, Jakub Kicinski wrote:
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> ---
> netfilter: add DEBUG_NET_WARN_ON_ONCE to skb_set_nfct()
> 
> This adds a DEBUG_NET_WARN_ON_ONCE() to skb_set_nfct() that fires when
> skb->_nfct already holds a conntrack pointer, so that nf_ct_set() calls
> overwriting a live ct object are caught.  Several existing nf_ct_set()
> callers in ipvs, conntrack clash resolution, openvswitch and act_ct are
> converted to call nf_reset_ct() first.
> 
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 22eda1d54a0e8..95184183180f6 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -5004,6 +5004,7 @@ static inline unsigned long skb_get_nfct(const struct sk_buff *skb)
> >  static inline void skb_set_nfct(struct sk_buff *skb, unsigned long nfct)
> >  {
> >  #if IS_ENABLED(CONFIG_NF_CONNTRACK)
> > +	DEBUG_NET_WARN_ON_ONCE(skb->_nfct & NFCT_PTRMASK);
> >  	skb->slow_gro |= !!nfct;
> >  	skb->_nfct = nfct;
> >  #endif
> 
> [Severity: High]
> Was nf_ct_bridge_pre() in net/bridge/netfilter/nf_conntrack_bridge.c meant
> to be converted too?

This particular issue is fixed in the nf.git PR.


BTW, I can see these reports from here:

https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260810194015.932627-1-pablo%40netfilter.org

Thanks.
