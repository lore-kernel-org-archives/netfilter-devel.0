Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F7AFC433E6
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Feb 2021 20:56:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DEF164DF0
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Feb 2021 20:56:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbhBLU4a (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 12 Feb 2021 15:56:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42105 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231584AbhBLU4W (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Feb 2021 15:56:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613163294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nefY369XOVTnG731C2OIoEJTJR52Ge56ZdFn8C2MDf4=;
        b=IjFa17L8Cf7laNVkLg0OK+0SAISkpOJy5mbhRp8wCMXkgxk+KuN4IJGqT2Zci8OUWDbdRf
        QiQQPLhGmDJAUFHpWQxwLujvXHSMa8qrjIHLrvRt+3Kcw6PcQ4E2Y2thExfF/zrY9gLFZR
        DTO1ty/+G0VC/DQd1QyAthcsTkRPfDQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-8RZwlGw2O8Wy9U7SbsnMkA-1; Fri, 12 Feb 2021 15:54:52 -0500
X-MC-Unique: 8RZwlGw2O8Wy9U7SbsnMkA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5EE061885783;
        Fri, 12 Feb 2021 20:54:51 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E27E419811;
        Fri, 12 Feb 2021 20:54:42 +0000 (UTC)
Date:   Fri, 12 Feb 2021 15:54:40 -0500
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Phil Sutter <phil@nwl.cc>, Steve Grubb <sgrubb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Ondrej Mosnacek <omosnace@redhat.com>, fw@strlen.de,
        twoerner@redhat.com, Eric Paris <eparis@parisplace.org>,
        tgraf@infradead.org
Subject: Re: [PATCH ghak124 v3] audit: log nftables configuration change
 events
Message-ID: <20210212205440.GM3141668@madcap2.tricolour.ca>
References: <f9da8b5dbf2396b621c77c17b5b1123be5aa484e.1591275439.git.rgb@redhat.com>
 <20210211151606.GX3158@orbyte.nwl.cc>
 <CAHC9VhTNQW9d=8GCW-70vAEMh8-LXviP+JHFC2-YkuitokLLMQ@mail.gmail.com>
 <4087569.ejJDZkT8p0@x2>
 <20210212121112.GA3158@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212121112.GA3158@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2021-02-12 13:11, Phil Sutter wrote:
> Hi,
> 
> On Thu, Feb 11, 2021 at 04:02:55PM -0500, Steve Grubb wrote:
> > On Thursday, February 11, 2021 11:29:34 AM EST Paul Moore wrote:
> > > > If I'm not mistaken, iptables emits a single audit log per table, ipset
> > > > doesn't support audit at all. So I wonder how much audit logging is
> > > > required at all (for certification or whatever reason). How much
> > > > granularity is desired?
> >  
> >   <snip> 
> > 
> > > I believe the netfilter auditing was mostly a nice-to-have bit of
> > > functionality to help add to the completeness of the audit logs, but I
> > > could very easily be mistaken.  Richard put together those patches, he
> > > can probably provide the background/motivation for the effort.
> > 
> > There are certifications which levy requirements on information flow control. 
> > The firewall can decide if information should flow or be blocked. Information 
> > flow decisions need to be auditable - which we have with the audit target. 
> 
> In nftables, this is realized via 'log level audit' statement.
> Functionality should by all means be identical to that of xtables' AUDIT
> target.
> 
> > That then swings in requirements on the configuration of the information flow 
> > policy.
> > 
> > The requirements state a need to audit any management activity - meaning the 
> > creation, modification, and/or deletion of a "firewall ruleset". Because it 
> > talks constantly about a ruleset and then individual rules, I suspect only 1 
> > summary event is needed to say something happened, who did it, and the 
> > outcome. This would be in line with how selinux is treated: we have 1 summary 
> > event for loading/modifying/unloading selinux policy.
> 
> So the central element are firewall rules for audit purposes and
> NETFILTER_CFG notifications merely serve asserting changes to those
> rules are noticed by the auditing system. Looking at xtables again, this
> seems coherent: Any change causes the whole table blob to be replaced
> (while others stay in place). So table replace/create is the most common
> place for a change notification. In nftables, the most common one is
> generation dump - all tables are treated as elements of the same
> ruleset, not individually like in xtables.
> 
> Richard, assuming the above is correct, are you fine with reducing
> nftables auditing to a single notification per transaction then? I guess
> Florian sufficiently illustrated how this would be implemented.

Yes, that should be possible.

> > Hope this helps...
> 
> It does, thanks a lot for the information!
> 
> Thanks, Phil

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

