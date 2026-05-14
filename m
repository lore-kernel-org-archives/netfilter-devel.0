Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274DF3F4129
	for <netfilter-devel@vger.kernel.org>; Thu, 14 May 2026 23:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778801437; cv=none; b=SHNUj/mFVnxpVzL779BEPyU/aHwz/CoM4vqpd98IFpLctKy4MI+wnt8FLksmULjyZnvgHdqxuYHBVVzv61+2zoARyFlJk2jzxAmafJEzXtciH9Ou8dV/ncaXBC6hYhUHUoemYr2PZ+S/A1QgxAQEGp3hlvTOMSPrH3S2xc7yRmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778801437; c=relaxed/simple;
	bh=Tb3UX+4BztwYY/tlBZpRYP9FkYxM1mWDCYBFQtXjYKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mG1JEGgnjlNqjbSTCbRLhq1q/PDk+jGArKhW2hWAFAc1toeE+Q+bCASH08zcU3/hvdEHqTgFxSiWtmXqoWfYoBok3OqOtgAWHOYXHwLcA5SskHD2IpEhb5SA0N8RgZCUu0/cgD4vzBQC2tLgdBK7PuG0/uIkf6u14iuXnOCbosE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KWKWjSdc; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KWKWjSdc"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id C93216017E;
	Fri, 15 May 2026 01:30:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1778801432;
	bh=zNhixw3RcYhsocdMROaS0JBZMNelFW3LWlQJJmL56/4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KWKWjSdcn3OK5jSwfDeQUsC5fRKHcxkPq1KViI0jFfUi7zEJkC3cQ2ZZpLYkzt2XX
	 2NW9o84u/vDxff1aPIdoGCkcMaI5F9JLCtjc2UDQcs36FYGkdXpDwCdajHqiH2/0yk
	 G/4ljSEcdmB4fa732rxb671U2VGb7eDJQo7yQCvEiom8ZoUrSr50dwRiGfMjFQVZUS
	 BA0C4z3WHRLdFpDoOyVzbkPeJ8Vu26dBNWlcb552D9IUOY3gBOY1AGa9KO1TpLk/nA
	 yDAzTiWlzPzB7fWjtYnUUk88W8Xl3abqNaK2XpG611fpSQgI4SYzuNJiFM8ENAgrT4
	 gjP6cnTnn7+UQ==
Date: Fri, 15 May 2026 01:30:30 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v2] netfilter: conntrack: add dead flag to helpers
Message-ID: <agZbFvp_KgGUr2Kw@chamomile>
References: <20260514143016.874811-1-pablo@netfilter.org>
 <agXfhQb8Dcl9p5ce@strlen.de>
 <agXl-3NDpK3YUZiF@chamomile>
 <agXt-m9yN-oayY1G@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <agXt-m9yN-oayY1G@strlen.de>

On Thu, May 14, 2026 at 05:44:58PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, May 14, 2026 at 04:43:17PM +0200, Florian Westphal wrote:
> > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > Add a new NF_CT_HELPER_F_DEAD helper flag to notify the packet path that
> > > > this helper is going away. Thus, helpers are effectively disabled and no
> > > > new expectations are created while removing the expectations created by
> > > > this helper as well as unhelping the existing conntrack entries.
> > > > 
> > > > Add the check for NF_CT_HELPER_F_DEAD in the packet path to:
> > > > - Conntrack confirmation path which invokes the helper callback.
> > > > - Propagation of helper to conntrack via expectation.
> > > > - OVS ct helper invocation.
> > > 
> > > Not sure this is enough.  New conntracks are not in any hash table /
> > > unreachable, and synchronize_rcu() doesn't guarantee they get confirmed
> > > (can get queued).
> > 
> > nf_ct_iterate_destroy() calls nf_queue_nf_hook_drop() for each netns.
> 
> But is that enough?  Consider:
> 
> cpu0						cpu1
> 						recieves verdict
> 						unlink from nfqueue list
> drop_queued_packets (misses unlinked)
> 						... going on ..

This looks like a general problem with nf_queue_nf_hook_drop().

> I think to properly resolve this, there is a need to check
> for this new dead flag after queueing to userspace (after its on list)
> and again when receiving the verdict.
>
> Arguably this is kind of different bug, because this comment is wrong:
> 
> /* a skb w. unconfirmed conntrack could have been reinjected just
>  * before we called nf_queue_nf_hook_drop().
>  *
>  * This makes sure its inserted into conntrack table.
>  */
>  synchronize_net();
> 
> (it could have been requeued).
>
> I think a more generic fix is to add a seqcnt to nf_queue_entry.
> When queueing, record current seqcnt.
>
> On reinject, drop if unconfirmed and seqcnt_now != entry->seqcnt.
> Not nice, but I don't see a better way ATM.

But you would need to check right before enqueueing (adding to the
hashtable/list), so the race would still be there? 

> The seqcnt can be pernet and it can be restricted to nfnetlink_queue.
> 
> Any better idea?

Maybe add a helper_id which is set at helper registration time. Then
nf_conn_help stores this helper_id field.  Unconfirmed conntrack on
reinject use this helper_id to re-lookup the helper when reinjecting.
This would force a slow path for unconfirmed conntracks, to
re-validate if the helper is still there.

cttimeout would need this too, a lookup to check if the timeout policy
is still around.
