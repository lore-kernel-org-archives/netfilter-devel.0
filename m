From: Florian Westphal <fw@strlen.de>
Subject: nfqueue & bridge netfilter considered broken
Date: Fri, 2 Sep 2016 11:08:48 +0200
Message-ID: <20160902090848.GA506@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:49410 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751643AbcIBJJK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Sep 2016 05:09:10 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.84_2)
        (envelope-from <fw@strlen.de>)
        id 1bfkSu-0000Ol-Ec
        for netfilter-devel@vger.kernel.org; Fri, 02 Sep 2016 11:08:48 +0200
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi.

This is a note to summarize state of bridge + br_netfilter + nfqueue.

TL;DR: I am giving up.  I see no way to fix this in a sane fashion.

What I tried:
I - discard extra nfct entry when cloning.  Works, but obviously not
 compatible in any way (the clones are INVALID).

II - add locking where needed.  It gets out of hand rather quickly,
 it is also pushed on everyone else rather than just those places
 that cause clones with unconfirmed conntrack entries (only places
 that i know of is mcast routing and the bridge).

III - serialize on reinject.
 Idea was to change nfqnl_recv_verdict() to (instead of nf_reinject() )
 call a wrapper, do_nf_reinject, which essentially does:

static void do_nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
{
#if IS_ENABLED(NF_CONNTRACK)
   struct nf_conn *ct = entry->skb->nfct;

  if (!ct || nf_ct_is_confirmed(ct)) {
       nf_reinject(entry, verdict);
       return 0;
  }

  if (skb_cloned(entry->skb)) {
      module_get(THIS_MODULE);
      push_to_work_queue_for_reinject(entry, verdict);
      return;
  }
#endif
  nf_reinject(entry, verdict);
}

The work queue then makes sure that we feed such skb one-by-one.

Aside from this being ugly as f there are two problems:
 1. skb_cloned() being true does NOT mean that we have to serialize, skb->nfct might
    be unique after all, i.e. we again end up pushing work on users/cases
    where this might not be needed at all.

 2. We can't know if all clones get queued via nfqueue, so we could have something like:
    a. clone is created
    b. this clone is sent to userspace for queueing
    c. another clone is created
    d. this clone is NOT queued to userspace and about to continue traversal
    e. at same time, userspace reinjects the older clone on other cpu
    -> we race again despite such 'serializer'.

This leaves option number IV:
 - when cloning in bridge, also make a full copy of ->nfct.
 This has 2 issues:
   1. dependency from bridge to conntrack (yuck)
   2. confirmation will find clash and toss the clones ...
    ... so we will need more clash resolution hacks (double-yuck).

At this point I am considering submitting a patch to
remove nfqueue support for bridge netfilter altogether.
