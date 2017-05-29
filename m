From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: RFC: Ideas about possible solutions for nfbz#949
Date: Mon, 29 May 2017 19:52:18 +0200
Message-ID: <20170529175218.GA19201@salvia>
References: <20170510153429.GZ20805@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48686 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751053AbdE2Rw0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 May 2017 13:52:26 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5C65BDFE3B
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 19:52:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3BF4618506
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 19:52:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6B00C10218A
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 19:52:12 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170510153429.GZ20805@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Phil,

I'm recovering this RFC that got lost in the pile.

On Wed, May 10, 2017 at 05:34:29PM +0200, Phil Sutter wrote:
> Hi,
> 
> Netfilter Bugzilla #949[1] complains about broken output when trying to
> match icmpv6 message fields. This is a problem in how payload match is
> implemented in nft: The given match (e.g. 'icmp6 id 2') is broken down
> to a simple match of header data at a specific offset. Sadly this does
> not work with ICMP(v6) since header structure depends on the packet's
> ICMP type and on return path there is no information about which type of
> message the user wanted to match against.

Right, this is a longstanding bug.

> My idea was to build something like the protocol dependencies we have
> for e.g. TCP header fields but with ICMP, a given header field might be
> present in multiple message types (e.g. icmp6_id is present in echo
> request as well as reply).

You mean adding more instructions when generating bytecode? This has
runtime overhead, just to provide context for just listing the
ruleset. I would prefer we skip this.

> I already considered inserting a match for icmp6 type against an
> anonymous set (like 'icmp6 type { echo-request, echo-reply }'), but
> having this as an implicit dependency and resolving with previous
> matches, etc. becomes pretty complex.
> 
> Do you think I should try following a different approach (via userdata
> e.g.)?

I think you should try adding some context structure to the
expr_print(), this context can be used to interpret this offset based
on the icmp type.

Someone (Elise?) send me a patch to add this context structure, just
to prepare introduction, but she got stuck in the context update
logic at some point. I can find such patch so you only have to figure
out how to annotate the information we need in this context structure.
