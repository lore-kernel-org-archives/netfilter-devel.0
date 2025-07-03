Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CB61B95B
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Jul 2025 10:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751538083; cv=none; b=QAiR2s9xFaBTqJEtEbeH7C8X+DIWYL1ffuhvW2TgJL7Y46baZarm3Jx9ed3fPBUoqI05Ott8HNYkcLGQ3Gma6SNLUP0Vlc1ErweaiaKwBMk5cCp4AEhNoiTfskjGN7JbG+fFV2MoF9N/dkOFjdFF9t4Oc3AH8MpXXJyCveh09/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751538083; c=relaxed/simple;
	bh=JugRD6G2y7/TA+jkxDgUfS/sGF8Y6M1WSxLlc6MvN4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hsnfd25kXXnpdDqrcFbeVixfYY/paja2zUMGFynml1SVotFpMeR6bBaD+aNDHI1tHO9+dKQ1Aogx4SmpITg6gQ0ERd9mcbi7RRoFTXDSsMaRT2tWuTs+y+R1DiOfcospCQFOsOzb9/RDMU++jn/BQXG5FiuV2TVRxdUpBizrbAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=aoRgXKTd; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="aoRgXKTd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=CRW2arnRfbsBWHFBO130mBqzhcJw/cGkfRjyzDAzA+g=; b=aoRgXKTdRdniQ5GpY+uuLZ/7sM
	QEmCufjds173W/0RN2kbZFhme2qP5GjzNAFi60GK+nAzpi8PWOhzCg5LRbKVAh6ORkFkNEuRnqb9y
	YMOXWp+8opUQ2RHVlA8+5cOblNYJ+XIpd/OzQ0P9ouJtKjifALD27gXlzzFDWUIV2SIQU6vaKmHMQ
	ha54VESx8WLv9q+QFDvzS6IvA6Bw+ogqPCUYhL/iw6zMBM16+OgHwLG8wZpJb7n1INfaRJ3BeJoWV
	gq0Q7eIUXVNJHCyMNi244jIVw8zKFUs03s39UF+zn73Ld0bac6YUItNSv/CMukKxUMJWLYHSNBmCn
	8Ib2rJwQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uXH49-000000006OY-0pQl;
	Thu, 03 Jul 2025 12:21:17 +0200
Date: Thu, 3 Jul 2025 12:21:17 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf-next RFC] netfilter: nf_tables: Feature ifname-based hook
 registration
Message-ID: <aGZZnbgZTXMwo_MS@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250702174725.11371-1-phil@nwl.cc>
 <aGW1JNPtUBb_DDAB@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aGW1JNPtUBb_DDAB@strlen.de>

Hi Florian,

On Thu, Jul 03, 2025 at 12:39:32AM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Require user space to set a flag upon flowtable or netdev-family chain
> > creation explicitly relaxing the hook registration when it comes to
> > non-existent interfaces. For the sake of simplicity, just restore error
> > condition if a given hook does not find an interface to bind to, leave
> > everyting else in place.
> 
> OK, but then this needs to go in via nf.git and:
> 
> Fixes: 6d07a289504a ("netfilter: nf_tables: Support wildcard netdev hook specs")
> 
> tag.  We shouldn't introduce a "error" -> "no error" -> "error" semantic
> change sequence in kernel releases, i.e. this change is urgent; its now
> (before 6.16 release) or never.

Oh, right. So a decision whether this is feasible and if, how it should
behave in detail, is urgent.

> > - A wildcard interface spec is accepted as long as at least a single
> >   interface matches.
> 
> Is there a reason for this? Why are they handled differently?

I wasn't sure if it's "required" to prevent it as well or not. This
patch was motivated by Pablo reporting users would not notice mis-typed
interface names anymore and asking for whether introducing a feature
flag for it was possible. So I went ahead to have something for a
discussion.

Actually, wildcards are not handled differently: If user specifies
"eth123", kernel errors if no "eth123" exists and accepts otherwise. If
user specifies "eth*", kernel errors if no interface with that prefix
exists and accepts otherwise.

I don't know where to go with this. If the flag should turn interface
specs name-based, its absence should fully restore the old behaviour (as
you kindly summarized below). If it's just about the typo, this patch
might be fine.

> > - Dynamic unregistering and re-registering of vanishing/re-appearing
> >   interfaces is still happening.
> 
> You mean, without the flag? AFAIU old behaviour is:
> For netdev chains:
> - auto-removal AND free of device basechain -> no reappearance
> - -ENOENT error on chain add if device name doesn't exist
> For flowtable:
> - device is removed from the list (and list can become empty), flowtable
>   stays 100%, just the device name disappears from the devices list.
>   Doesn't reappear (auto re-added) either.
> - -ENOENT error on flowtable add if even one device doesn't exist
> 
> Neither netdev nor flowtable support "foo*" wildcards.
> 
> nf.git:
> - netdev basechain kept alive, no freeing, auto-reregister (becomes
>   active again if device with same name reappears).
>   No error if device name doesn't exists -> delayed auto-register
>   instead, including multi-reg for "foo*" case.
> - flowtable: same as old BUT device is auto-(re)added if same name
>   (re)appears.
> - No -ENOENT error on flowtable add, even if no single device existed
> 
> Full "foo*" support.
> 
> Now (this patch, without new flag):
> - netdev basechain: same as above.
>   But you do get an error if the device name did not exist.
>   Unless it was for "foo*", thats accepted even if no match is found.

No, this patch has the kernel error also if it doesn't find a match for
the wildcard. It merely asserts that the hook's ops_list is non-empty
after nft_netdev_hook_alloc() (which did the search for matching
interfaces) returns.

>   AFAICS its a userspace/nft change, ie. the new flag is actually
>   provided silently in the "foo*" case?
> - flowtable: same as old BUT device is auto-(re)added if same name
>   (re)appears.
> - -ENOENT error on flowtable add if even one device doesn't exist
>   Except "foo*" case, then its ok even if no match found.
> 
> Maybe add a table that explains the old/new/wanted (this patch) behaviours?
> And an explanation/rationale for the new flag?
> 
> Is there a concern that users depend on old behaviour?
> If so, why are we only concerned about the "add" behaviour but not the
> auto-reregistering?
> 
> Is it to protect users from typos going unnoticed?
> I could imagine "wlp0s20f1" getting misspelled occasionally...

Yes, that was the premise upon which I wrote the patch. I didn't intend
to make the flag toggle between the old interface hooks and the new
interface name hooks.

> > Note that this flag is persistent, i.e. included in ruleset dumps. This
> > effectively makes it "updatable": User space may create a "name-based"
> > flowtable for a non-existent interface, then update the flowtable to
> > drop the flag. What should happen then? Right now this is simply
> > accepted, even though the flowtable still does not bind to an interface.
> 
> AFAIU:
> If we accept off -> On, the flowtable should bind.
> If we accept on -> off, then it looks we should continue to drop devices
> from the list but just stop auto-readding?
> 
> If in doubt the flag should not be updateable (hard error), in
> that case we can refine/relax later.

My statement above was probably a bit confusing: With non-persistent, I
meant for the flag to be recognized upon chain/flowtable creation but
not added to chain->flags or flowtable->data.flags.

Cheers, Phil
