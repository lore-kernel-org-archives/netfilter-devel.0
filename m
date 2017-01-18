From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: ctnetlink: make more information
 available in DESTROY events
Date: Wed, 18 Jan 2017 17:03:35 +0100
Message-ID: <20170118160335.GB29902@salvia>
References: <1484751272-5489-1-git-send-email-fw@strlen.de>
 <20170118150118.GA23289@salvia>
 <20170118150745.GG12001@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Jarno Rajahalme <jarno@ovn.org>,
        Victor Julien <lists@inliniac.net>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57350 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753210AbdARQEE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2017 11:04:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3AB9B11ADD2
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 17:03:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2AB15DA8F5
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 17:03:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0DCFAFF126
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 17:03:36 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170118150745.GG12001@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 18, 2017 at 04:07:45PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Wed, Jan 18, 2017 at 03:54:32PM +0100, Florian Westphal wrote:
> > > destroy events currently don't contain the tcp state info and no
> > > secmark and conntrack labels.
> > > 
> > > Quoting Victor:
> > >  "I was hoping to get the last TCP state in a conntrack destroy event,
> > >   however it seems to be unavailable."
> > > 
> > > Quoting Jarno:
> > >  "I have a use case where we want to log terminating connections, but
> > >  only if a specific label bit is set."
> > > 
> > > While at it, also include SECMARK in destroy events if one is available.
> > 
> > I'm fine with this.
> > 
> > But to remember the original problem is that netlink bandwidth is
> > limited, so the more we load the netlink message, the more chances we
> > have to hit ENOBUFS.
> > 
> > connlabel is optional, so you only get it if needed.
> 
> Yes, and only if there was a label change or at least one label bit is
> set.
> 
> > But the protoinfo thing, I would prefer we just dump the state given
> > this the usecase we have now.
> > 
> > Probably extend ->to_nlattr() to have a bool that indicates if this is
> > a dump?
> 
> Could do that by it only avoids 4 attributes (so we only save 32bytes
> per message).

IIRC, the destroy message is rather small. Moreover, think of
thousands of messages in that queue, that makes a difference. And I
cannot think of anything useful people can do with window scale and
flags at that stage, right?
