From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next,RFC 1/3] netfilter: nf_conntrack: add 64-bit
 conntrack ID extension
Date: Tue, 28 Nov 2017 16:44:01 +0100
Message-ID: <20171128154401.GA1444@salvia>
References: <20171128021309.11277-1-pablo@netfilter.org>
 <20171128105451.GF23412@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, richard@nod.at
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60498 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752115AbdK1PoF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Nov 2017 10:44:05 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 88BCE190F70
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Nov 2017 16:44:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 70408DA873
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Nov 2017 16:44:03 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171128105451.GF23412@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 28, 2017 at 11:54:51AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > This patch adds a 64-bit conntrack ID extension that allows userspace to
> > uniquely identify a conntrack object.
> > 
> > The existing 32-bit ID is not good to uniquely identify a conntrack
> > object. Long time ago, this used to be an incremental number that could
> > quickly wrap around. Someone suggested to use 64-bits, back then this
> > was considered to be too much memory for just an ID. So we usually
> > suggested to users that they should combine it with the conntrack tuple
> > to achieve a way to uniquely conntrack objects. This has always
> > generated a bit of controversy since userspace applications needed to
> > deal with extra work.
> > 
> > At some point, someone remove the explicit ct->id field that we used to
> > have to save memory space. This ID was modified to part of its memory
> > address. Howeover, this is a problem because objects can be quickly
> > recycled with the slab-by-rcu approach that we use these days. So even
> > combining this 32-bit ID with the tuple doesn't ensure that this is
> > unique. Moreover, this is leaking the pointer to userspace in 32-bit
> > arches, which is not good.
> > 
> > So let's introduce a 64-bit unique ID that ensures no overlaps. This is
> > only allocated once in the first packet, and never ever again from the
> > hot path, so let's keep this in a separated extension not to grab more
> > cachelines.
> > 
> > ID assignment is lockless: this patch divides the 64-bit space between
> 
> Why do we need an id in the first place?
> Can you elaborate?

It's a userspace thing, for statistics and manipulation via ctnetlink,
eg. delete an entry. To make sure you refer to the same conntrack
entry when polling for statistics and also for events, in case of
event loss, you keep context around in case tear-down and re-creation
happens in little time.

> As far as I know there is no need for this ID at all,
> the netlink attribute is only provided for backwards compat.
> 
> And for that the suggested approach (hash of tuple and memory
> addresses) will work just fine.

It's still possible to land a conntrack with exactly the same tuple on
the same memory address.

Think of a conntrack that is created and teared down very quickly,
then exactly the same conntrack, with same tuples, may be created
again.

I can just keep this patchset back and push the one that randomizes
what we dump to userspace (ie. 3/3), I don't need this now, it's just
a patchset that it's been stuck in my tree for a while.
