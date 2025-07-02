Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18741D2F42
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Jul 2025 22:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751495991; cv=none; b=aL2r47lXB+op+AamZZSCeQtpte6BKFdJIlSWCMRyEjZgINDza6zHxjchzUkat0HPZVcBScYgG/GeeCxcSWcY10fCLIRlXD1BI4xR2JnWbyQZ1pSNHJwxeYNbOthsEj2kEhuI6FZCtaQi6PBlmtWYKheNLxwAG1lwGWABi/upSog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751495991; c=relaxed/simple;
	bh=A3dtXmitFUUSo3yr11qN88j+bWCRTIfub1yy+o7Ai0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ovlig1JiBgR8MGam0zBJR/fHW579RvFpnN25CBiUr70inIpRBZQa2Uss2DffDxLe4LkT3XtA5hkHDpDpouvPZa57+6vNS73hGTB1VUbLU7Oqdh1hiTc9qajOjE1TIxH8KVNZdc12TuOZzqZkg464prbU1iQvO5FfJJECVO10Mug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0DF13607AC; Thu,  3 Jul 2025 00:39:40 +0200 (CEST)
Date: Thu, 3 Jul 2025 00:39:32 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf-next RFC] netfilter: nf_tables: Feature ifname-based hook
 registration
Message-ID: <aGW1JNPtUBb_DDAB@strlen.de>
References: <20250702174725.11371-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250702174725.11371-1-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> Require user space to set a flag upon flowtable or netdev-family chain
> creation explicitly relaxing the hook registration when it comes to
> non-existent interfaces. For the sake of simplicity, just restore error
> condition if a given hook does not find an interface to bind to, leave
> everyting else in place.

OK, but then this needs to go in via nf.git and:

Fixes: 6d07a289504a ("netfilter: nf_tables: Support wildcard netdev hook specs")

tag.  We shouldn't introduce a "error" -> "no error" -> "error" semantic
change sequence in kernel releases, i.e. this change is urgent; its now
(before 6.16 release) or never.

> - A wildcard interface spec is accepted as long as at least a single
>   interface matches.

Is there a reason for this? Why are they handled differently?

> - Dynamic unregistering and re-registering of vanishing/re-appearing
>   interfaces is still happening.

You mean, without the flag? AFAIU old behaviour is:
For netdev chains:
- auto-removal AND free of device basechain -> no reappearance
- -ENOENT error on chain add if device name doesn't exist
For flowtable:
- device is removed from the list (and list can become empty), flowtable
  stays 100%, just the device name disappears from the devices list.
  Doesn't reappear (auto re-added) either.
- -ENOENT error on flowtable add if even one device doesn't exist

Neither netdev nor flowtable support "foo*" wildcards.

nf.git:
- netdev basechain kept alive, no freeing, auto-reregister (becomes
  active again if device with same name reappears).
  No error if device name doesn't exists -> delayed auto-register
  instead, including multi-reg for "foo*" case.
- flowtable: same as old BUT device is auto-(re)added if same name
  (re)appears.
- No -ENOENT error on flowtable add, even if no single device existed

Full "foo*" support.

Now (this patch, without new flag):
- netdev basechain: same as above.
  But you do get an error if the device name did not exist.
  Unless it was for "foo*", thats accepted even if no match is found.
  AFAICS its a userspace/nft change, ie. the new flag is actually
  provided silently in the "foo*" case?
- flowtable: same as old BUT device is auto-(re)added if same name
  (re)appears.
- -ENOENT error on flowtable add if even one device doesn't exist
  Except "foo*" case, then its ok even if no match found.

Maybe add a table that explains the old/new/wanted (this patch) behaviours?
And an explanation/rationale for the new flag?

Is there a concern that users depend on old behaviour?
If so, why are we only concerned about the "add" behaviour but not the
auto-reregistering?

Is it to protect users from typos going unnoticed?
I could imagine "wlp0s20f1" getting misspelled occasionally...

> Note that this flag is persistent, i.e. included in ruleset dumps. This
> effectively makes it "updatable": User space may create a "name-based"
> flowtable for a non-existent interface, then update the flowtable to
> drop the flag. What should happen then? Right now this is simply
> accepted, even though the flowtable still does not bind to an interface.

AFAIU:
If we accept off -> On, the flowtable should bind.
If we accept on -> off, then it looks we should continue to drop devices
from the list but just stop auto-readding?

If in doubt the flag should not be updateable (hard error), in
that case we can refine/relax later.
