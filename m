From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nft: ah expression doesn't work for IPv6
Date: Thu, 2 Mar 2017 22:01:29 +0100
Message-ID: <20170302210129.GA19330@salvia>
References: <20170302195651.GX6099@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60630 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751742AbdCBVTg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Mar 2017 16:19:36 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7462912A680
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Mar 2017 22:01:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2D6CCDA80B
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Mar 2017 22:01:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D101ADA7E9
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Mar 2017 22:01:30 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170302195651.GX6099@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 02, 2017 at 08:56:52PM +0100, Phil Sutter wrote:
> Hi,
> 
> There is currently an open issue with nft in that ah expression doesn't
> work for IPv6 since it creates a payload expression which doesn't find
> the AH IPv6 extension header.
> 
> There has been a discussion about this problem off-list in which two
> alternative "solutions" were named, both involve checking the context
> to find out whether one is trying to match an IPv4 or IPv6 packet and
> then create either payload or exthdr expression. Though this solution is
> not optimal, as in (at least) inet table the address family is not given
> per se.
> 
> I had the idea of creating a "real" solution to the problem which
> consists of a payload/exthdr hybrid in kernel space searching for the
> given header in different locations depending on the family of the
> actual package being handled. Ideally this should reuse as much code as
> possible, so maybe "just" create both expressions in user space and in
> kernel space only branch between the two.

If the problem is the inet chain, I would prefer we request explicit
dependencies for ah so we generate the right bytecode depending on the
family. Yes, I mean we would need two different rules for each case by
now.

On top of that, do you have a real usecase having both AH traffic for
IPv4 and IPv6 traffic? If you don't I would prefer you just fix what
we have and focus on a different task, we have plenty of work to do
ahead. We can hand over you more useful tasks.
