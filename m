From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 0/7] netfilter: ebtables: CONFIG_COMPAT support
Date: Sun, 7 Feb 2010 23:38:02 +0100
Message-ID: <20100207223802.GA27427@Chamillionaire.breakpoint.cc>
References: <alpine.LSU.2.01.1002050807580.16226@obet.zrqbmnf.qr>
 <20100205140021.GB21611@Chamillionaire.breakpoint.cc>
 <4B6C5231.7040702@pandora.be>
 <20100205.100241.17593999.davem@davemloft.net>
 <4B6D69D3.7050008@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, netfilter-devel@vger.kernel.org
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:59834 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754941Ab0BGWiG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Feb 2010 17:38:06 -0500
Content-Disposition: inline
In-Reply-To: <4B6D69D3.7050008@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bart De Schuymer <bdschuym@pandora.be> wrote:
> I can't tell how many of these systems are running ebtables but
> considering most of the functionality has been working on a
> user32/kernel64 system since 2004 I think it's safe to say that
> Florian's patch will break a few systems.

Yes, I had feared that.
The way I see it we have a couple of alternatives.

One way would be to disable the in-kernel ebt-compat layer for
sparc64. Of course this assumes that this userland-side padding
is only used on the sparc platform.

> I'm not familiar with the way this compat layer works, but is there a
> standard way to ensure that old ebtables binaries don't use the compat
> layer, while a new version of the userspace program would?

It should be possible to figure out if we need to do fixups,
because struct ebt_replace size differs (and the sockopt *len
includes this value).

In some cases this is as simple as "if (*len == sizeof(struct
ebt_replace)". But even in case of EBT_SO_GET_ENTRIES it seems
possible. We can try the "native" getsockopt call first, it should
then error out early due to this check:

if (*len != sizeof(struct ebt_replace) + entries_size +
           (tmp.num_counters? nentries * sizeof(struct ebt_counter): 0)) {
				    sizeof(struct ebt_counter): 0)) {
	/* -EINVAL */

we can then re-try with all the compat fixups.

What do you think?

I'll do some tests with this in the next couple of days;
if everything looks good (and there are no objections) I'll post a revised
patch set.

> If all else fails, we could do this with a special flag in struct
> ebt_replace::valid_hooks, as this member has some unused bits.

Thanks, its good to know there is some kind of "last resort".
But I'd like to avoid any incompatibilities, if possible.

Regards, Florian
