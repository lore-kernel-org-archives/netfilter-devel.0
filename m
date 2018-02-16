From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] inet: don't call skb_orphan if tproxy happens in layer 2
Date: Fri, 16 Feb 2018 12:07:06 +0100
Message-ID: <20180216110706.GM2810@breakpoint.cc>
References: <1518715545-2188-1-git-send-email-gregory.vanderschueren@tessares.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, gregory.detal@tessares.net,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        netdev@vger.kernel.org
To: Gregory Vander Schueren <gregory.vanderschueren@tessares.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:50754 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935119AbeBPLKZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Feb 2018 06:10:25 -0500
Content-Disposition: inline
In-Reply-To: <1518715545-2188-1-git-send-email-gregory.vanderschueren@tessares.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Gregory Vander Schueren <gregory.vanderschueren@tessares.net> wrote:

[ cc netdev ]

> If sysctl bridge-nf-call-iptables is enabled, iptables chains are already
> traversed from the bridging code. In such case, tproxy already happened when
> reaching ip_rcv. Thus no need to call skb_orphan as this would actually undo
> tproxy.

I don't like this because it adds yet another test in fastpath, and for
a use case that has apparently never worked before.

> We noticed issues when using tproxy with net.bridge.bridge-nf-call-iptables
> enabled. In such case, ip_rcv() basically undo tproxy's job. The following
> patch proposes a fix.

I question wheter its a good idea to mix tproxy with bridges.

Tproxy relies on policy routing, but a bridge doesn't route :-)

I guess you use bridge snat mac mangling to force local delivery of
packets that are otherwise bridged?

If yes, can you use ebtables brouting instead?
This would bypass the bridge (so no iptables invocation from bridge
prerouting anymore).

We will try to get rid of nf-call-iptables eventually.

There might be (more complicated) ways to avoid this problem without
adding code in normal network path, but lets check other options first.
