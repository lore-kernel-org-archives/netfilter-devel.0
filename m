From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nft: ah expression doesn't work for IPv6
Date: Fri, 3 Mar 2017 18:37:58 +0100
Message-ID: <20170303173758.GA1501@salvia>
References: <20170302195651.GX6099@orbyte.nwl.cc>
 <20170302210129.GA19330@salvia>
 <20170302212522.GA8035@salvia>
 <20170303140157.GB19896@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48842 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751856AbdCCSPq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Mar 2017 13:15:46 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 48AB42D15FD
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Mar 2017 18:38:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 392FEDA84D
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Mar 2017 18:38:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EAC96DA725
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Mar 2017 18:38:02 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170303140157.GB19896@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 03, 2017 at 03:01:57PM +0100, Phil Sutter wrote:
> On Thu, Mar 02, 2017 at 10:25:22PM +0100, Pablo Neira Ayuso wrote:
> > On Thu, Mar 02, 2017 at 10:01:29PM +0100, Pablo Neira Ayuso wrote:
> > > On Thu, Mar 02, 2017 at 08:56:52PM +0100, Phil Sutter wrote:
[...]
> > > If the problem is the inet chain, I would prefer we request explicit
> > > dependencies for ah so we generate the right bytecode depending on the
> > > family. Yes, I mean we would need two different rules for each case by
> > > now.
> 
> Well, in bison there would have to be a common entrance point, which
> checks the scope and then generates either payload expr, exthdr expr or
> an error depending on what it is. Correct?

That's right.

> > > On top of that, do you have a real usecase having both AH traffic for
> > > IPv4 and IPv6 traffic? If you don't I would prefer you just fix what
> > > we have and focus on a different task, we have plenty of work to do
> > > ahead. We can hand over you more useful tasks.
> 
> Not sure if I understand you correctly, but the use-case is matching on
> some AH header field in IPv6 traffic? But sure, if you think that's too
> exotic I could maybe just add some check somewhere which causes an error
> if the family is not specified or not IPv4 and ah expression is being
> used.

As you indicate the AH handling in nft is inconsistent, just like it
happens in iptables and ip6tables, look:

1) in iptables we can do -p ah, then use an extension to match AH
   header from transport.
2) in ip6tables we cannot do -p ah. We use a specific ah extension for
   IPv6 that uses ipv6_find_hdr().

This is a mess.

Please, develop your hybrid idea.
