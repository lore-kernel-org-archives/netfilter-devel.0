From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3 nf-next 0/12] netfilter: don't copy init ns hooks to
 new namespaces
Date: Fri, 18 Dec 2015 12:42:26 +0100
Message-ID: <20151218114226.GB2091@salvia>
References: <1449136185-4165-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40153 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766AbbLRLtO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Dec 2015 06:49:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1A2DC32F99
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 12:49:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A55C44C348
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 12:49:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EEBA4DA873
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 12:49:05 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1449136185-4165-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Thu, Dec 03, 2015 at 10:49:33AM +0100, Florian Westphal wrote:
> My problem with this patch set is the ridiculous amount of code that needs
> to be added to cover all the 'register the hooks for conntrack' cases.

I spent some time spinning on this, and to be honest I couldn't come
up with any better solution following this automatic hook registration
by infering from the dependencies.

Still my concerns also go in the direction of breaking corner cases,
for example, people polling (no event subscription) from ctnetlink to
retrieve statistics (then send them to some centralized collector)
assuming no rules at all.

> IOW, it might be a much better idea to respin this patch series so
> that it does NOT contain any of the conntrack changes (only 'don't register
> xtables hooks + don't register bridge hooks), and then add
> net.netfilter.nf_conntrack_disable (or whatever), plus -j CT --track.

It would be good to agree on some design for this. Patrick also have
concerns on loose conntrack enabling. That we can probably resolve
through explicit configuration, something like:

-j CT --track --protocols sctp,tcp,udp --unsupported generic

so we explicitly indicate what protocol trackers are on and indicate
that otherwise to use the generic tracker.

> That would also solve this issue, albeit not by default and it leaves
> the question of how we should deal with defragmentation
> (-s 10.2.3.0/24 -p tcp --dport 80 would not work reliably).

IIRC in iptables, we drop this via hotdrop, but in nftables this is an
open issue, a user with no defrag should drop fragments in first place
in his ruleset.

In iptables, we can still register the defragmentation hooks as soon
as we need conntrack, socket or tproxy.

> Perhaps we could attempt to propogate a *conntrack rule active* bit into
> the xtables core and call defrag from there.  Another, simpler alternative
> would be to stick an unconditional 'defrag' call into the raw table.

I couldn't come up so far with any scenario that would break with
unconditional defragmentation. But unconditional stuff makes me feel a
bit nervous as there is usually someone following up with rare
situation that forces us to disable it.

Let me know, thanks Florian.
