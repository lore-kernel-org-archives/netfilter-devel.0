Return-Path: <SRS0=Vh4p=6F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07561C54FD0
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Apr 2020 15:15:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBD7F2068F
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Apr 2020 15:15:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fowo7rlg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbgDUPP0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Apr 2020 11:15:26 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:33742 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725902AbgDUPPZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Apr 2020 11:15:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587482122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=04PEf90F+6uRCyLy6Mn+cR2kwE1/6Z45D9X5YBg8bFQ=;
        b=fowo7rlgT/3BwDzvqx/naU8klQWhy74/XWAyClQVYuPMmUmSWTsT3z/MInz9hMIRynpgaB
        SALvRiKRoZlOOv+k15vDEhFgRj8jNQfHdTfigzaN67F8anpnqPedWL4oIRbcyOFdogdqY3
        BUc7RVHhv0V2zZZQXVVPvyrb8T6uY70=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-DnTW3m3TOnWJI0bXu-clzw-1; Tue, 21 Apr 2020 11:15:14 -0400
X-MC-Unique: DnTW3m3TOnWJI0bXu-clzw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5A2218FE867;
        Tue, 21 Apr 2020 15:15:11 +0000 (UTC)
Received: from x2.localnet (ovpn-113-195.phx2.redhat.com [10.3.113.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2781376E92;
        Tue, 21 Apr 2020 15:15:04 +0000 (UTC)
From:   Steve Grubb <sgrubb@redhat.com>
To:     linux-audit@redhat.com
Cc:     Paul Moore <paul@paul-moore.com>,
        Richard Guy Briggs <rgb@redhat.com>, fw@strlen.de,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        twoerner@redhat.com, Eric Paris <eparis@parisplace.org>,
        tgraf@infradead.org
Subject: Re: [PATCH ghak25 v3 3/3] audit: add subj creds to NETFILTER_CFG record to cover async unregister
Date:   Tue, 21 Apr 2020 11:15:02 -0400
Message-ID: <2156032.xcGZvdN1jG@x2>
Organization: Red Hat
In-Reply-To: <CAHC9VhSbbjFbF0A_-saquZ8B85XaF7SWD2e1QcWsXhFSQrUAbQ@mail.gmail.com>
References: <cover.1584480281.git.rgb@redhat.com> <20200318213327.ow22q6nnjn3ijq6v@madcap2.tricolour.ca> <CAHC9VhSbbjFbF0A_-saquZ8B85XaF7SWD2e1QcWsXhFSQrUAbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Friday, April 17, 2020 5:53:47 PM EDT Paul Moore wrote:
> On Wed, Mar 18, 2020 at 5:33 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2020-03-18 17:22, Paul Moore wrote:
> > > On Wed, Mar 18, 2020 at 9:12 AM Richard Guy Briggs <rgb@redhat.com> 
wrote:
> > > > On 2020-03-17 17:30, Richard Guy Briggs wrote:
> > > > > Some table unregister actions seem to be initiated by the kernel to
> > > > > garbage collect unused tables that are not initiated by any
> > > > > userspace actions.  It was found to be necessary to add the subject
> > > > > credentials to cover this case to reveal the source of these
> > > > > actions.  A sample record:
> > > > >   type=NETFILTER_CFG msg=audit(2020-03-11 21:25:21.491:269) :
> > > > >   table=nat family=bridge entries=0 op=unregister pid=153 uid=root
> > > > >   auid=unset tty=(none) ses=unset
> > > > >   subj=system_u:system_r:kernel_t:s0 comm=kworker/u4:2 exe=(null)

If this is the kernel, why is pid not 0? And if pid is 0, then isn't 
exe=/boot/vmlinuz-X.Y.Z-blah?

> > > > Given the precedent set by bpf unload, I'd really rather drop this
> > > > patch that adds subject credentials.

<snip> 

> I'm in the middle of building patches 1/3 and 2/3, assuming all goes
> well I'll merge them into audit/next (expect mail soon), however I'm
> going back and forth on this patch.  Like you I kinda don't like it,
> and with both of us not in love with this patch I have to ask if there
> is certification requirement for this?

Yes, any change to information flow must be auditable.

> I know about the generic
> subj/obj requirements, but in the case where there is no associated
> task/syscall/etc. information it isn't like the extra fields supplied
> in this patch are going to have much information in that regard; it's
> really the *absence* of that information which is telling.

Exactly. But if someone does a search based on the fields, they need to be 
able to find this record. For example, suppose I want to know what actions 
have been performed by kernel_t, I can run a  search and find this event. 

> Which brings me to wonder if simply the lack of any associated records in
> this event is enough?  Before when we weren't associating records into
> a single event it would have been a problem, but the way things
> currently are, if there are no other records (and you have configured
> that) then I think you have everything you need to know.
> 
> Thoughts?

You can't search on the absense of information. There are some fields that 
have meaning. It's OK if they are unset. It happens for daemons, too. But we 
don't remove the fields because of it. It tells part of the story.

-Steve


