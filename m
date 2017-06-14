From: Florian Westphal <fw@strlen.de>
Subject: using nft & iptables nat in parallel
Date: Wed, 14 Jun 2017 11:24:48 +0200
Message-ID: <20170614092448.GB10130@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:52626 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751866AbdFNJZd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Jun 2017 05:25:33 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.84_2)
        (envelope-from <fw@strlen.de>)
        id 1dL4Xg-0001A8-7M
        for netfilter-devel@vger.kernel.org; Wed, 14 Jun 2017 11:24:48 +0200
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi.

As you might know its currently not possible to use iptables
and nft nat at the same time.

I had a look at this and think we should fix this as follows:

1. decouple nat rewrite from nat chain/iptable_nat iteration.

Currently we do this from nf_nat_ipv4/6_fn, so first call (be it nft nat
or ip(6)table_nat) attaches nat translation or a null binding which makes
2nd invocation a no-op.

2. place a l3 protocol independent function that does null binding and
rewrite in nf_nat_core.  It can be independent because nf_nat_info has
the l3 information and we don't need to deal with anything special
except hooking at either NFPROTO_IPV4 or V6.

3. make all the nat expressions/targets call a helper function at
init/destroy time so we can register the new rewrite hooks.
This is easy, all these currently call nf_ct_netns_get/put so we
only need to add nf_nat_netns_get/put which calls nf_ct_netns_get
and registers a nat null-bind/rewrite hook.

The downside is that we need one more hook function at priority
NF_IP_PRI_NAT_SRC/DST + 1 in all places except forward.

Another side effect is that this avoids the need to add (in nft case)
the 'empty' nat base chains to take care of reply translation.

Thoughts?

Otherwise I'll have a go at this.

This would also possibly allow us to add nat hooks in the INET family.
