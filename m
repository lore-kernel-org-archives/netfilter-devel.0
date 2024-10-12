Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5A92745B
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 15:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728748493; cv=none; b=joykRZLNnKnXJb3NigyG5ZqgQ0ql/pGeEcQeOyaVWc4MIpTmGf1VH2N97gFa/wbHQDgZavDJKYeVMv56yIcFLBpj4Ij1ixQCZ0fdYyx/883nghhmIRf8jfIIRxiCh+vbbcmTOSFCSxYVWyF2Bp2RdoveTlYA3XggQiQr87yhuGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728748493; c=relaxed/simple;
	bh=092pq89Jr9E5ZBu5askBIUBMnBROc6hbiJpD/jz9DFw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ntNqz4BR6UazAomGfq06JjFOzIQI378hKazB29J4ucjpGkyJiCaeVTcFx4T743AMunNhp11YLZp/oijzm+TrFyWpN2L+bah8eK2zpUueH6aqPylUx6tsa53CTEJhJfftpCdnccfnW0ZF9sa4Y5rcigMLUWAV1CPZdce9AyOMsc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1szeS8-0006pu-D2; Sat, 12 Oct 2024 17:54:48 +0200
Date: Sat, 12 Oct 2024 17:54:48 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/4] netfilter: use skb_drop_reason in more places
Message-ID: <20241012155448.GB21920@breakpoint.cc>
References: <20241002155550.15016-1-fw@strlen.de>
 <ZwqDI5JcQi5fMa46@calendula>
 <20241012144216.GA21920@breakpoint.cc>
 <ZwqY8Rm74MO_UMM8@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwqY8Rm74MO_UMM8@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Or do you mean using a different macro that always sets EPERM?
> 
> Maybe remove SKB_DROP_REASON_NETFILTER_DROP from macro, so line is
> shorter?
> 
>         NF_DROP_REASON(pkt->skb, -EPERM)
> 
> And add a new macro for br_netfilter NF_BR_DROP_REASON which does not
> always sets SKB_DROP_REASON_NETFILTER_DROP? (Pick a better name for
> this new macro if you like).

NF_DROP_REASON is already in the tree and currently most users use
something other than SKB_DROP_REASON_NETFILTER_DROP.

I did not yet add new enum values or a dedicated nf namespace
(enum skb_drop_reason_subsys), because I did not see a reason and
wasn't sure if we'd need sub-subsystems (nf_tables, conntrack, nat,
whatever).

If you like, I can add NF_FREE_SKB(skb, errno) and rework this
set to use that?

