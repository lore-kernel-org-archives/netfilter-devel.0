Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B43EC433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Feb 2021 20:28:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF77864E15
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Feb 2021 20:28:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbhBKU2O (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Feb 2021 15:28:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36267 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230005AbhBKU2M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Feb 2021 15:28:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613075205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kedDsP6t4VP3mQxBac2ERpSJUqeZHmbTEmxpDibNovU=;
        b=LWf3uN0v3CbAbIhB0ZoJlRLMwBYT1YKR7r+bqjBP7i047Enmgom3BZkXWUXptkwJyDwjdS
        ooK+195f1lVqxX2idxA07OyCCXh4u27HFlTWsyNQCVy+u1j94GcbB0Ybq1l5R9qtdkBfUJ
        pqgK58ay70u60bziZIZ4quJsY0vvWcU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-572--4GrNyaBNIuCrTTI0FGh6g-1; Thu, 11 Feb 2021 15:26:41 -0500
X-MC-Unique: -4GrNyaBNIuCrTTI0FGh6g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5EEB80196E;
        Thu, 11 Feb 2021 20:26:39 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 595AC6F998;
        Thu, 11 Feb 2021 20:26:31 +0000 (UTC)
Date:   Thu, 11 Feb 2021 15:26:28 -0500
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Phil Sutter <phil@nwl.cc>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, sgrubb@redhat.com,
        Ondrej Mosnacek <omosnace@redhat.com>, fw@strlen.de,
        twoerner@redhat.com, Eric Paris <eparis@parisplace.org>,
        tgraf@infradead.org
Subject: Re: [PATCH ghak124 v3] audit: log nftables configuration change
 events
Message-ID: <20210211202628.GP2015948@madcap2.tricolour.ca>
References: <f9da8b5dbf2396b621c77c17b5b1123be5aa484e.1591275439.git.rgb@redhat.com>
 <20210211151606.GX3158@orbyte.nwl.cc>
 <CAHC9VhTNQW9d=8GCW-70vAEMh8-LXviP+JHFC2-YkuitokLLMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhTNQW9d=8GCW-70vAEMh8-LXviP+JHFC2-YkuitokLLMQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2021-02-11 11:29, Paul Moore wrote:
> On Thu, Feb 11, 2021 at 10:16 AM Phil Sutter <phil@nwl.cc> wrote:
> > Hi,
> >
> > On Thu, Jun 04, 2020 at 09:20:49AM -0400, Richard Guy Briggs wrote:
> > > iptables, ip6tables, arptables and ebtables table registration,
> > > replacement and unregistration configuration events are logged for the
> > > native (legacy) iptables setsockopt api, but not for the
> > > nftables netlink api which is used by the nft-variant of iptables in
> > > addition to nftables itself.
> > >
> > > Add calls to log the configuration actions in the nftables netlink api.
> >
> > As discussed offline already, these audit notifications are pretty hefty
> > performance-wise. In an internal report, 300% restore time of a ruleset
> > containing 70k set elements is measured.
> 
> If you're going to reference offline/off-list discussions in a post to
> a public list, perhaps the original discussion shouldn't have been
> off-list ;)  If you don't involve us in the discussion, we have to
> waste a lot of time getting caught up.

Here's part of that discussion:
	https://bugzilla.redhat.com/show_bug.cgi?id=1918013

> > If I'm not mistaken, iptables emits a single audit log per table, ipset
> > doesn't support audit at all. So I wonder how much audit logging is
> > required at all (for certification or whatever reason). How much
> > granularity is desired?
> 
> That's a question for the people who track these certification
> requirements, which is thankfully not me at the moment.  Unless
> somebody else wants to speak up, Steve Grubb is probably the only
> person who tracks that sort of stuff and comments here.
> 
> I believe the netfilter auditing was mostly a nice-to-have bit of
> functionality to help add to the completeness of the audit logs, but I
> could very easily be mistaken.  Richard put together those patches, he
> can probably provide the background/motivation for the effort.

It was added because an audit test that normally produced records from
iptables on one distro stopped producing any records on another.
Investigation led to the fact that on the first it was using
iptables-legacy API and on the other it was using iptables-nft API.

> > I personally would notify once per transaction. This is easy and quick.

This was the goal.  iptables was atomic.  nftables appears to no longer
be so.  If I have this wrong, please show how that works.

> > Once per table or chain should be acceptable, as well. At the very
> > least, we should not have to notify once per each element. This is the
> > last resort of fast ruleset adjustments. If we lose it, people are
> > better off with ipset IMHO.
> >
> > Unlike nft monitor, auditd is not designed to be disabled "at will". So
> > turning it off for performance-critical workloads is no option.

If it were to be disabled "at will" it would defeat the purpose of
audit.  Those records can already be filtered, or audit can be disabled,
but let us look at rationalizing the current nftables records first.

> Patches are always welcome, but it might be wise to get to the bottom
> of the certification requirements first.
> 
> -- 
> paul moore
> www.paul-moore.com
> 
> --
> Linux-audit mailing list
> Linux-audit@redhat.com
> https://www.redhat.com/mailman/listinfo/linux-audit

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

