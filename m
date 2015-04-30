From: Patrick McHardy <kaber@trash.net>
Subject: Re: roadmap of the nftables development
Date: Thu, 30 Apr 2015 04:50:56 +0200
Message-ID: <20150430025051.GK7956@acer.localdomain>
References: <874mo8wl00.fsf@klimov-ThinkPad-T530.i-did-not-set--mail-host-address--so-tickle-me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Nikita Klimov <nikita@klimov.us>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48998 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbbD3CvA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Apr 2015 22:51:00 -0400
Content-Disposition: inline
In-Reply-To: <874mo8wl00.fsf@klimov-ThinkPad-T530.i-did-not-set--mail-host-address--so-tickle-me>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 22.04, Nikita Klimov wrote:
> Hello everyone.
> I want to thank the authors of the nftables project. This project solved
> most of the problems that exist for a long time. I am extremely
> interested in the stable release that came out, which can be
> use in production. Therefore, I would like to offer its assistance in
> development. Is there any roadmap for the release of the stable
> release?

We try to think that our releases are stable, but we do have some obvious
missing points, but they are small. F.i. you can't match on the IPv4
version right now, but obviously, that's not important (and fixed soon).
None of the currently visible missing features will require an incompatible
break, it will simply be more features at some point.

So we are of the opinion that we do not break anything and that all
existing features except set intervals are considered stable, but
even those will from a userspace POV with 99% certainty remain as
they are.

So regarding stable - we will not break things unless absolutely
necessary, and in that case you will get an appropriate warning
period at runtime and in the release notes.

Regarding a roadmap, aka a TODO and/or wishlist, I've talked about this
with Pablo last week. We will formulate two lists soon, one consisting
of how to map iptables features to nftables and what is missing, one
about what we want to achieve using nftables.

Cheers,
Patrick
