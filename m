From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nat: remove incorrect debug assert
Date: Fri, 3 Mar 2017 13:47:17 +0100
Message-ID: <20170303124717.GA29312@salvia>
References: <20170208221429.3555-1-fw@strlen.de>
 <20170221140909.GA3286@salvia>
 <20170221144019.GD9708@breakpoint.cc>
 <20170303115534.GA13931@salvia>
 <20170303124404.GB29213@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39462 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751853AbdCCNEg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Mar 2017 08:04:36 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 545C765B1C
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Mar 2017 13:47:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 45C68DA80B
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Mar 2017 13:47:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EE3AFDA795
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Mar 2017 13:47:18 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170303124404.GB29213@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 03, 2017 at 01:44:04PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > However, changing test to if (iph->frag_off) return -NF_ACCEPT seems
> > > wrong too because we have enough info to track. OTOH, this only happens
> > > with HDRINCL+raw socket so perhaps we shouldn't care about this and
> > > just change ipv4 l3 tracker to ignore all packets w. iph->frag_off set.
> > 
> > Florian, unless you rise your hand, I'm going to take this patch so we
> > at least fix splats here. I still have the impression that this
> > setsockopt() option and its interaction with netfilter is broken at
> > many levels.
> 
> Hmmm, I think we should disable tracking of all fragmented packets,
> or at least disable NAT of all fragmented packets.
> 
> If we NAT 1st packet only then frag reasm won't complete anyway.

Right. Would you give a shoot at this? If you do, I'd appreciate.
Thanks.
