Return-Path: <SRS0=Vh4p=6F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62474C54FC9
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Apr 2020 20:20:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 450F5206B8
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Apr 2020 20:20:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gDF5fzIr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbgDUUUH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Apr 2020 16:20:07 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34576 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726168AbgDUUUG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Apr 2020 16:20:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587500404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EqwDhsb0LCzxwEp0N46fUM7Jiee3HrTDQZIAQEZpzC4=;
        b=gDF5fzIrK7k+7JcpB/tlkyEjr3DtcrP25d4agwns+tFwpvnlkmXe27HcM49YjtO3uvsuLY
        1SEx6FFDRJ8h4aA4tNPp4G8AIxsFHOiu5cUzAcaugWuWK+YS/GV/4Gd6ZXlYJI4dfwofRE
        7j7q8ryaIQq/WS685Oz/HE87rACoAuE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-6mw8GRbXMZaLRTiXi98PdQ-1; Tue, 21 Apr 2020 16:19:57 -0400
X-MC-Unique: 6mw8GRbXMZaLRTiXi98PdQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10F89107ACC9;
        Tue, 21 Apr 2020 20:19:56 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.3.128.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5540660BEC;
        Tue, 21 Apr 2020 20:19:48 +0000 (UTC)
Date:   Tue, 21 Apr 2020 16:19:45 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, twoerner@redhat.com,
        Eric Paris <eparis@parisplace.org>, fw@strlen.de,
        ebiederm@xmission.com, tgraf@infradead.org
Subject: Re: [PATCH ghak25 v3 3/3] audit: add subj creds to NETFILTER_CFG
 record to cover async unregister
Message-ID: <20200421201945.spw3ec4duusijswl@madcap2.tricolour.ca>
References: <cover.1584480281.git.rgb@redhat.com>
 <13ef49b2f111723106d71c1bdeedae09d9b300d8.1584480281.git.rgb@redhat.com>
 <20200318131128.axyddgotzck7cit2@madcap2.tricolour.ca>
 <CAHC9VhTdLZop0eT11H4uSXRj5M=kBet=GkA8taDwGN_BVMyhrQ@mail.gmail.com>
 <20200318213327.ow22q6nnjn3ijq6v@madcap2.tricolour.ca>
 <CAHC9VhSbbjFbF0A_-saquZ8B85XaF7SWD2e1QcWsXhFSQrUAbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhSbbjFbF0A_-saquZ8B85XaF7SWD2e1QcWsXhFSQrUAbQ@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2020-04-17 17:53, Paul Moore wrote:
> On Wed, Mar 18, 2020 at 5:33 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2020-03-18 17:22, Paul Moore wrote:
> > > On Wed, Mar 18, 2020 at 9:12 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > On 2020-03-17 17:30, Richard Guy Briggs wrote:
> > > > > Some table unregister actions seem to be initiated by the kernel to
> > > > > garbage collect unused tables that are not initiated by any userspace
> > > > > actions.  It was found to be necessary to add the subject credentials to
> > > > > cover this case to reveal the source of these actions.  A sample record:
> > > > >
> > > > >   type=NETFILTER_CFG msg=audit(2020-03-11 21:25:21.491:269) : table=nat family=bridge entries=0 op=unregister pid=153 uid=root auid=unset tty=(none) ses=unset subj=system_u:system_r:kernel_t:s0 comm=kworker/u4:2 exe=(null)
> > > >
> > > > Given the precedent set by bpf unload, I'd really rather drop this patch
> > > > that adds subject credentials.
> > > >
> > > > Similarly with ghak25's subject credentials, but they were already
> > > > present and that would change an existing record format, so it isn't
> > > > quite as justifiable in that case.
> > >
> > > Your comments have me confused - do you want this patch (v3 3/3)
> > > considered for merging or no?
> >
> > I would like it considered for merging if you think it will be required
> > to provide enough information about the event that happenned.  In the
> > bpf unload case, there is a program number to provide a link to a
> > previous load action.  In this case, we won't know for sure what caused
> > the table to be unloaded if the number of entries was empty.  I'm still
> > trying to decide if it matters.  For the sake of caution I think it
> > should be included.  I don't like it, but I think it needs to be
> > included.
> 
> I'm in the middle of building patches 1/3 and 2/3, assuming all goes
> well I'll merge them into audit/next (expect mail soon), however I'm
> going back and forth on this patch.  Like you I kinda don't like it,
> and with both of us not in love with this patch I have to ask if there
> is certification requirement for this?  I know about the generic
> subj/obj requirements, but in the case where there is no associated
> task/syscall/etc. information it isn't like the extra fields supplied
> in this patch are going to have much information in that regard; it's
> really the *absence* of that information which is telling.  Which
> brings me to wonder if simply the lack of any associated records in
> this event is enough?  Before when we weren't associating records into
> a single event it would have been a problem, but the way things
> currently are, if there are no other records (and you have configured
> that) then I think you have everything you need to know.
> 
> Thoughts?

I'm good dropping that third patch, but Steve's perspective is more
authoritative here.

I'll respin patch 1/3 and 2/3 to fix the checkpatch.pl errors if you
prefer (was erroneously mentioned in ghak28 feedback).

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

