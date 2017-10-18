From: Florian Westphal <fw@strlen.de>
Subject: nftables and iptables nat coexistence
Date: Wed, 18 Oct 2017 15:56:50 +0200
Message-ID: <20171018135650.GA16796@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:51434 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750775AbdJRN4x (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Oct 2017 09:56:53 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.84_2)
        (envelope-from <fw@strlen.de>)
        id 1e4oq2-0005z6-Ac
        for netfilter-devel@vger.kernel.org; Wed, 18 Oct 2017 15:56:50 +0200
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi.

Couple of month ago I sent 2 RFC patches to allow using nftables and
iptables NAT at same time.

If this is unwanted (there was concern wrt. to the new hooks I had to
add for this), we should at least improve/restrict iptables and nftables
to

1. not allow load if iptable_nat when nft nat hook is active.
2. make it a requirement to register empty nat hook (required for
the reply direction).
3. Do not permit more than one nat type per family/hook.
4. we should probably also add more checks on nat priority
for nftables to reject hooks that can't work due to no-conntrack
information being available at that point.

I think not allowing nft and iptablles nat at the same time is fine
as mixing has problems on its own, especially which transformation
gets precedence, so I suspect the old RFC patches resolve one issue
and add another one :)

So, are the old RFC patches NAKed or not?  If they are, I'd first look at
#1 from the list but before I do some consensus would be welcome.

Thanks,
Florian
