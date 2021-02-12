Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64C53C433E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Feb 2021 12:12:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3123C64DD7
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Feb 2021 12:12:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhBLML6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 12 Feb 2021 07:11:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbhBLML4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Feb 2021 07:11:56 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99880C061574;
        Fri, 12 Feb 2021 04:11:15 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1lAXI0-00055e-7W; Fri, 12 Feb 2021 13:11:12 +0100
Date:   Fri, 12 Feb 2021 13:11:12 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Steve Grubb <sgrubb@redhat.com>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Ondrej Mosnacek <omosnace@redhat.com>, fw@strlen.de,
        twoerner@redhat.com, Eric Paris <eparis@parisplace.org>,
        tgraf@infradead.org
Subject: Re: [PATCH ghak124 v3] audit: log nftables configuration change
 events
Message-ID: <20210212121112.GA3158@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Steve Grubb <sgrubb@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Ondrej Mosnacek <omosnace@redhat.com>, fw@strlen.de,
        twoerner@redhat.com, Eric Paris <eparis@parisplace.org>,
        tgraf@infradead.org
References: <f9da8b5dbf2396b621c77c17b5b1123be5aa484e.1591275439.git.rgb@redhat.com>
 <20210211151606.GX3158@orbyte.nwl.cc>
 <CAHC9VhTNQW9d=8GCW-70vAEMh8-LXviP+JHFC2-YkuitokLLMQ@mail.gmail.com>
 <4087569.ejJDZkT8p0@x2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4087569.ejJDZkT8p0@x2>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu, Feb 11, 2021 at 04:02:55PM -0500, Steve Grubb wrote:
> On Thursday, February 11, 2021 11:29:34 AM EST Paul Moore wrote:
> > > If I'm not mistaken, iptables emits a single audit log per table, ipset
> > > doesn't support audit at all. So I wonder how much audit logging is
> > > required at all (for certification or whatever reason). How much
> > > granularity is desired?
>  
>   <snip> 
> 
> > I believe the netfilter auditing was mostly a nice-to-have bit of
> > functionality to help add to the completeness of the audit logs, but I
> > could very easily be mistaken.  Richard put together those patches, he
> > can probably provide the background/motivation for the effort.
> 
> There are certifications which levy requirements on information flow control. 
> The firewall can decide if information should flow or be blocked. Information 
> flow decisions need to be auditable - which we have with the audit target. 

In nftables, this is realized via 'log level audit' statement.
Functionality should by all means be identical to that of xtables' AUDIT
target.

> That then swings in requirements on the configuration of the information flow 
> policy.
> 
> The requirements state a need to audit any management activity - meaning the 
> creation, modification, and/or deletion of a "firewall ruleset". Because it 
> talks constantly about a ruleset and then individual rules, I suspect only 1 
> summary event is needed to say something happened, who did it, and the 
> outcome. This would be in line with how selinux is treated: we have 1 summary 
> event for loading/modifying/unloading selinux policy.

So the central element are firewall rules for audit purposes and
NETFILTER_CFG notifications merely serve asserting changes to those
rules are noticed by the auditing system. Looking at xtables again, this
seems coherent: Any change causes the whole table blob to be replaced
(while others stay in place). So table replace/create is the most common
place for a change notification. In nftables, the most common one is
generation dump - all tables are treated as elements of the same
ruleset, not individually like in xtables.

Richard, assuming the above is correct, are you fine with reducing
nftables auditing to a single notification per transaction then? I guess
Florian sufficiently illustrated how this would be implemented.

> Hope this helps...

It does, thanks a lot for the information!

Thanks, Phil
