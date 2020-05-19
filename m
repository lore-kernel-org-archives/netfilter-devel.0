Return-Path: <SRS0=LRg4=7B=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF7CC433E1
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 May 2020 19:45:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACA2A206C3
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 May 2020 19:45:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IxGpow3H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgESTpR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 May 2020 15:45:17 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42023 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726059AbgESTpQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 May 2020 15:45:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589917514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3ZPhjMhc2ZD+ukMEY/C5pv2YZILivCrJg0ecgtUq++g=;
        b=IxGpow3HcBKLgSZd1TvPAsozO8ihEukkatMB/viAjVyXQ4WmGIF5PSp0XLIzh+RSWtVKuk
        pk9Pk65n/hSmY43wogFPy5kmGe++A7hGlBfF0aA9XK1cBv0peUG7iBStudB+fh3imj0U3+
        tC2SD8wdS1IVOxSAuoXllc4l77wrbFs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-yF7nVU6VMq6xX2AWMNpA2Q-1; Tue, 19 May 2020 15:45:12 -0400
X-MC-Unique: yF7nVU6VMq6xX2AWMNpA2Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C27219200C0;
        Tue, 19 May 2020 19:45:11 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.46])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E4BD460BEC;
        Tue, 19 May 2020 19:44:59 +0000 (UTC)
Date:   Tue, 19 May 2020 15:44:57 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, sgrubb@redhat.com,
        Ondrej Mosnacek <omosnace@redhat.com>, fw@strlen.de,
        twoerner@redhat.com, Eric Paris <eparis@parisplace.org>,
        tgraf@infradead.org
Subject: Re: [PATCH ghak25 v5] audit: add subj creds to NETFILTER_CFG record
 to cover async unregister
Message-ID: <20200519194457.nouzteqv2vpcqnta@madcap2.tricolour.ca>
References: <2794b22c0b88637a4270b346e52aeb8db7f59457.1589853445.git.rgb@redhat.com>
 <CAHC9VhQYUooJbZ9tcOOwb=48LTjtnfo0g11vQuyLzoxdetaxnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhQYUooJbZ9tcOOwb=48LTjtnfo0g11vQuyLzoxdetaxnw@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2020-05-19 15:18, Paul Moore wrote:
> On Tue, May 19, 2020 at 11:31 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > Some table unregister actions seem to be initiated by the kernel to
> > garbage collect unused tables that are not initiated by any userspace
> > actions.  It was found to be necessary to add the subject credentials to
> > cover this case to reveal the source of these actions.  A sample record:
> >
> > The tty, ses and exe fields have not been included since they are in the
> > SYSCALL record and contain nothing useful in the non-user context.
> >
> >   type=NETFILTER_CFG msg=audit(2020-03-11 21:25:21.491:269) : table=nat family=bridge entries=0 op=unregister pid=153 uid=root auid=unset subj=system_u:system_r:kernel_t:s0 comm=kworker/u4:2
> 
> Based on where things were left in the discussion on the previous
> draft, I think it would be good if you could explain a bit why the uid
> and auid fields are useful here.

They aren't really useful here.  I was hoping to remove them given your
reasoning, but I was having trouble guessing what you wanted even after
asking for clarity.  Can you clarify what you would prefer to see in
this patch?  I was hoping to skip this extra patch revision which took
longer than hoped due to trying to guess what you wanted while working
yesterday during a public holiday to get this patch out in time for the
merge window.

A UID of 0="root" is really a bit misleading since while it is the most
trusted user running the most privileged level, the event wasn't
triggered by a user.  It is the default value of that field.  I did
think aloud that uid could be set by the kernel to run under a
particular user's id (like a daemon dropping capabilities and switching
user after setup to limit abuse), but the kernel is just a tracker for
these IDs and doesn't really know what they mean other than root.  I saw
no reply to that idea.  It was set to "root" which isn't unset or
unexpected, but granted is useless in this case.

You had offered that keeping auid was a concession to Steve so I kept it
in since I had the impression that is what you wanted to see.  That
explanation seems pretty thin to include in a patch description if what
you are getting at in your sentence above.

I am willing to purge both if that is what you would prefer to accept in
the patch.

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

