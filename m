Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC79A4AA008;
	Wed,  7 Oct 2026 11:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791373565; cv=none; b=OHHORHgS10ovDw7IvDE813O2ndNkX8FfVNRmOcZS1X2874QK70eEY26KBmQeFbp20QgPGObApWcAAicRCX4AXyWJzSdBfdkPI9AvhmqWW/so+dmUQUFguZ/OYtaY1bAOf5HJguQQQHH58y9neDgJvTcpVWgfdhiAgiduwROwEok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791373565; c=relaxed/simple;
	bh=A6tOIZbTY7Ir2yMBpECPAf35YzauEeh8Ul/eEaRDFio=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iGn9Qio7E+6Y/osMudM+XECrwDKbXgjmlb3k8PKzHRWwimRyI5ylKQ/J/6MkUFakNqQjllapnEveFyuSoxJom0wAiGWGIqLCy5W6PSBL0ysYs8vX1W3KgZ9kqLAdqpwB6YLRT/nftCOxdcrNsiY8FVaM2P1l1pFxFzLTB7RqElo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TFdedxco; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TFdedxco"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791373551;
	bh=AIOYN1lNQIGwAoqoixkSzTyR/REwoiCMp77/f+DhiGY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TFdedxcoRROhtHPYDHkxi5WiwtnndH4OztOPCYyrLL91djjMklyAgHIL7lGM5Pora
	 ZBIVIC2Dm4pQpGacHyPnUYgCbcJ3DqmnTw55a4vc6HC9bMUrEBKjOBKsVh+NjDmFmN
	 ubOF2mnoR8gZqhGFCjOIxXob9cx0KB4fMscXOk2nnvKiDDWR3RCjgGYE6UO0O96a2S
	 cjO7ajTPlz74J5kCLUsr1Gew2EOi0/hFOUOyKAuO2vvqIjRStaIfs+YngoVhmMn6ju
	 11V00vQvdciQoOGvYwz4niRFsvso+QNix2a+VqIYgQYOaX4pIk70gBzynxSJkflGWq
	 aB63Pey0dGrAw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 327DC60051;
	Wed,  7 Oct 2026 13:45:51 +0200 (CEST)
Date: Wed, 7 Oct 2026 13:45:48 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Daehyeon Ko <4ncienth@gmail.com>, phil@nwl.cc,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net v3] netfilter: conntrack: avoid recursive master
 destruction
Message-ID: <asYw7Pn4qcYt4F0D@chamomile>
References: <20261007014802.2615503-1-4ncienth@gmail.com>
 <asYHaUFdxo0flpAe@strlen.de>
 <asYf2b03D78kWdkZ@chamomile>
 <asYsY-yLXNVFc_Rv@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <asYsY-yLXNVFc_Rv@strlen.de>

On Wed, Oct 07, 2026 at 01:26:27PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > That said, ignoring the source of the problem is not good.
> > > 
> > > I see no point whatsoever for a expected connection to have a
> > > non-control connection as its master.
> > 
> > I would prefer if chain length is limited too, ie. tighten this
> > interface based on the LLM feedback.
> 
> Thanks, working on this now.  Tentative plan:
> 
> #define NF_CT_MAX_EXPECT_CHAIN_LEN     4

4 is a reasonable number, but I think 2 is just enough, which is what
H.323 and SIP need, in case you consider tightening this even further
Userspace helpers are simple, they don't use this feature. It is true
that conntrackd needs this feature for flow synchronization as the LLM
suggests.

> static inline bool nf_ct_master_acceptable(const struct nf_conn *m)
> {
>        unsigned int depth = 0;
> 
>        while (m->master) {
>                if (++depth > NF_CT_MAX_EXPECT_CHAIN_LEN)
>                        return false;
>                m = m->master;
>        }
> 
>        return true;
> }
> 
>  struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me)
>  {
>         struct nf_conntrack_expect *new;
>  
> +       if (!nf_ct_master_acceptable(me))
> +               return NULL;
> +
> 
> I'll make an independent submission for this.

Thanks Florian.
