From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] inet: don't call skb_orphan if tproxy happens in layer 2
Date: Fri, 16 Feb 2018 12:28:45 +0100
Message-ID: <20180216112845.vkqam67eq4cmeu3q@salvia>
References: <1518715545-2188-1-git-send-email-gregory.vanderschueren@tessares.net>
 <20180216110706.GM2810@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Gregory Vander Schueren <gregory.vanderschueren@tessares.net>,
        netfilter-devel@vger.kernel.org, gregory.detal@tessares.net,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        netdev@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58014 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965024AbeBPL2t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Feb 2018 06:28:49 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 25D4C2519B4
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Feb 2018 12:28:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 108A3DA249
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Feb 2018 12:28:47 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180216110706.GM2810@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 16, 2018 at 12:07:06PM +0100, Florian Westphal wrote:
> Gregory Vander Schueren <gregory.vanderschueren@tessares.net> wrote:
> 
> [ cc netdev ]
> 
> > If sysctl bridge-nf-call-iptables is enabled, iptables chains are already
> > traversed from the bridging code. In such case, tproxy already happened when
> > reaching ip_rcv. Thus no need to call skb_orphan as this would actually undo
> > tproxy.
> 
> I don't like this because it adds yet another test in fastpath, and for
> a use case that has apparently never worked before.
> 
> > We noticed issues when using tproxy with net.bridge.bridge-nf-call-iptables
> > enabled. In such case, ip_rcv() basically undo tproxy's job. The following
> > patch proposes a fix.
> 
> I question wheter its a good idea to mix tproxy with bridges.
> 
> Tproxy relies on policy routing, but a bridge doesn't route :-)
> 
> I guess you use bridge snat mac mangling to force local delivery of
> packets that are otherwise bridged?
> 
> If yes, can you use ebtables brouting instead?
> This would bypass the bridge (so no iptables invocation from bridge
> prerouting anymore).
> 
> We will try to get rid of nf-call-iptables eventually.
> 
> There might be (more complicated) ways to avoid this problem without
> adding code in normal network path, but lets check other options first.

Agreed.

If there's a fix for this, that should be away from the fast path, not
in ip_rcv().
