Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3451BC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Mar 2022 12:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238513AbiCPMUE convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Mar 2022 08:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238166AbiCPMUD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Mar 2022 08:20:03 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A80540E65
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Mar 2022 05:18:48 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nUSc2-0005Y4-2D; Wed, 16 Mar 2022 13:18:46 +0100
Date:   Wed, 16 Mar 2022 13:18:46 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [RFC] conntrack event framework speedup
Message-ID: <20220316121846.GD9936@breakpoint.cc>
References: <20220315120538.GB16569@breakpoint.cc>
 <YjEFXmDfNN6k63+H@salvia>
 <20220315214121.GA9936@breakpoint.cc>
 <YjEK9RsgJuONGyTI@salvia>
 <20220315220748.GC9936@breakpoint.cc>
 <YjGp7pPqw8EzACDL@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <YjGp7pPqw8EzACDL@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Hmmm, I don't think that will work.  The -j CT thing can be used to
> > enable event reporting (including the event type) for particular flows
> > only.
> 
> IIRC, it allows to filter what events are of your interest in a global
> fashion.
> 
> > E.g. users might do:
> > 
> > nf_conntrack_events=0
> > and then only enable destroy events for tcp traffic on port 22, 80, 443
> > (arbitrary example).
> > 
> > If I bump the listen-count, then they will see event reports for
> > for udp timeouts and everything else.
> 
> Are you sure? -j CT sets on the event mask. The explicit -j CT rules
> means userspace want to listen to events, but only those that you
> specified. So it is the same as having a userspace process to listen,
> but the global filtering applies.

The filtering isn't global, its per flow.  Provided
nf_conntrack_events=0, then only flows where the first packet matched
a -j CT rule will generate events, AND only those events that were
specified in its event mask.

So, flows that did not match any CT rule never generate an event, and,
therefore, changes to the kernel should not auto-add the extension for
them.

I don't see how that mechanism can be preserved without the ability to
set nf_conntrack_events=0.

When a new conntrack is generated, the test is (in current kernels):

'add the event cache extension if the template has an event cache
 extension OR if the sysctl is enabled'.

So, changing it to
'add the event cache extension if the template has an event cache
 extension OR if we have a listener' is not the same, unfortunately.

> My understanding is that the listen-count tells that packets should
> follow ct netlink event path.

Yes, thats correct, it tells kernel there is an active subscriber for
events.

> What am I missing?

I can't tell the following two cases apart:

1. templates are active and user wants events ONLY for the chosen flow,
   e.g. tcp.
2. templates are active and user wants only particular events for the
   chosen flows, but all events for the rest.


1) is done by templates + setting the sysctl to 0.
2) is done by templates + setting the sysctl to 1.

With 'assume 1 if listener active', we can only provide functionality of 2).

I finished testing of a prototype and it appears that functionality is ok,
I've pushed this here:
https://git.breakpoint.cc/cgit/fw/nf-next.git/log/?h=nf_ct_events_02

(only the top-most 4 changes are relevant).
