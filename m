Return-Path: <SRS0=f4Jo=7A=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E58C433E1
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 May 2020 00:40:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A82A4207ED
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 May 2020 00:40:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VgwR4MKS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgERAkK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 17 May 2020 20:40:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49807 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726700AbgERAkK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 17 May 2020 20:40:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589762408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ldgf5qCz+KPm0qgqX51insh5mQ/IcQUyFZCFAsumpxs=;
        b=VgwR4MKSp2Sj2e9HS/3rB4HhC9ceMi9zb8aczURoj/ZTXEhAPVcRzoDrVD4icPCiInrHAs
        MxzjVmTAQGRffzgJXHzCirqfwFZ+rErV23m+1fbI2oAbykdkreypiRr58m3Y1Rv6ktt3nm
        uMfYB41BLWLpWFfQzbad1D4ZXFPJbbU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-fyxGpy4-PmylBpGtDqWUaA-1; Sun, 17 May 2020 20:40:04 -0400
X-MC-Unique: fyxGpy4-PmylBpGtDqWUaA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3266ABFC7;
        Mon, 18 May 2020 00:39:51 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.46])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C55460C81;
        Mon, 18 May 2020 00:39:22 +0000 (UTC)
Date:   Sun, 17 May 2020 20:39:20 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     fw@strlen.de, LKML <linux-kernel@vger.kernel.org>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        twoerner@redhat.com, Eric Paris <eparis@parisplace.org>,
        tgraf@infradead.org
Subject: Re: [PATCH ghak25 v4 3/3] audit: add subj creds to NETFILTER_CFG
 record to cover async unregister
Message-ID: <20200518003920.e6vyzhvadyi5wdjd@madcap2.tricolour.ca>
References: <cover.1587500467.git.rgb@redhat.com>
 <b8ba40255978a73ea15e3859d5c945ecd5fede8e.1587500467.git.rgb@redhat.com>
 <CAHC9VhR9sNB58A8uQ4FNgAXOgVJ3RaWF4y5MAo=3mcTojaym0Q@mail.gmail.com>
 <20200517141515.qqx3jx5ulb2546tx@madcap2.tricolour.ca>
 <CAHC9VhQVRyJ7GRHrujW5Ri-pvBRBgFM2Y8+OYQxca1bUyv2eyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhQVRyJ7GRHrujW5Ri-pvBRBgFM2Y8+OYQxca1bUyv2eyg@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2020-05-17 17:50, Paul Moore wrote:
> On Sun, May 17, 2020 at 10:15 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2020-04-28 18:25, Paul Moore wrote:
> > > On Wed, Apr 22, 2020 at 5:40 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > Some table unregister actions seem to be initiated by the kernel to
> > > > garbage collect unused tables that are not initiated by any userspace
> > > > actions.  It was found to be necessary to add the subject credentials to
> > > > cover this case to reveal the source of these actions.  A sample record:
> > > >
> > > >   type=NETFILTER_CFG msg=audit(2020-03-11 21:25:21.491:269) : table=nat family=bridge entries=0 op=unregister pid=153 uid=root auid=unset tty=(none) ses=unset subj=system_u:system_r:kernel_t:s0 comm=kworker/u4:2 exe=(null)
> > >
> > > [I'm going to comment up here instead of in the code because it is a
> > > bit easier for everyone to see what the actual impact might be on the
> > > records.]
> > >
> > > Steve wants subject info in this case, okay, but let's try to trim out
> > > some of the fields which simply don't make sense in this record; I'm
> > > thinking of fields that are unset/empty in the kernel case and are
> > > duplicates of other records in the userspace/syscall case.  I think
> > > that means we can drop "tty", "ses", "comm", and "exe" ... yes?
> > >
> > > While "auid" is a potential target for removal based on the
> > > dup-or-unset criteria, I think it falls under Steve's request for
> > > subject info here, even if it is garbage in this case.
> >
> > Can you explain why auid falls under this criteria but ses does not if
> > both are unset?
> 
> "While "auid" is a potential target for removal based on the
> dup-or-unset criteria, I think it falls under Steve's request for
> subject info here, even if it is garbage in this case."
> 
> It's a concession to Steve.  As I mentioned previously, I think the
> subject info is bogus in this case; either it is valid and we get it
> from the SYSCALL record or it simply isn't present in any meaningful
> way.

Sorry for being so dense.  I still don't follow your explanation.  You've
repeated the same paragraph that didn't make sense to me the first time.

What definition of "subject info" are you working with?  I had assumed
it was the set of fields that contain information that came from that
task's struct task_struct.  Some of those fields contain information
that isn't helpful.  Why not remove them all rather than keep one that
still contains no useful information?  Or is it a matter of keeping one
key field that contains no useful information that proves that the rest
is bogus?  Steve said that daemons leave no useful information in auid
as well, so I don't see how keeping this field helps us.  My
understanding is that the subj field's "...:kernel_t:..." is the key
here and that pid and comm give us a bit more of a clue that it is a
kernel thread.  Is that correct?  What use does including auid serve
here?

I suppose that the uid field is somewhat useful, since the kernel could
conceivably switch to a particular user to run a kernel thread.  Is that
even currently possible?

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

