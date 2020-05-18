Return-Path: <SRS0=f4Jo=7A=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7115C433E1
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 May 2020 14:41:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB2B020756
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 May 2020 14:41:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="exGeRrZl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgEROlG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 May 2020 10:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726997AbgEROlF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 May 2020 10:41:05 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DBCEC061A0C
        for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2020 07:41:04 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id i16so4207470edv.1
        for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2020 07:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y82Wa/YXfbo2pFIdBdGJ5l3oNnVnkoqZdsw/qlj3M4k=;
        b=exGeRrZlknyuMB4d2TwhyRGvfIcmzYX8ZarWq9HJJK9k4nZaJ7Xrj16vDEFWeu83W8
         hkNS8h29h4vDwXb053+x4OFUcU/OReXr+AhuP0f3jXh7/H1TvDy8F8fY3H3OcKJYznxG
         u+ioUJkrPAiwwcNbQN+UFn7QhShmOJeLUlxUQkJAFPG7QuECxy7HGe5ZZsDpAI7nhAPn
         xzlNGiLY8GpBjJlJM2RNMuVWumL2ZZT73CRyiHAJrfs0RI1FgU9Ka64T4Fn4lcBb3daz
         e0ejm8YIzbwErMdGA/G59gXqRH+t8zYrMiM1dpHWjAtpoqxyFVAcLqDqtGauGLVfuRCw
         KDGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y82Wa/YXfbo2pFIdBdGJ5l3oNnVnkoqZdsw/qlj3M4k=;
        b=WOseQUUhzVPcTLSF8Q68752MLgufUdWZ5vk7z18gYgKUWew1id+U73VTvbmtrynTpH
         VDChDs2bezj5dERZM6DPTQxxYQO/qjDKFEr7o/NolAbqJz2BjvFZjaYl5bkbK8i3dvzr
         7CQdSWOlUPfvxQp561uxNLkVdDJKzKnkhM98Z88cVSvQHCq83Wm2vw4m+oPOFx6m5//P
         KNb6+5OScLZuhl60adE1Ks1ogoQ+Fw57VFfckmWAxTTyYxv2EVZVWWaxEXH+OYZICFU/
         oDmU52DH4WELih1qlS5sZcfT82NkT4MRC2ysAI0vaGbUYzVzpjAStlRdtxeuihj4u6XR
         YRuQ==
X-Gm-Message-State: AOAM531bEkTvvEKFAqwxT+vKnNECWlH04OA1JONsdltmpCZS3nyBmKyt
        f2U/SyR+Ka7Rkz8ZPKk4kMS7FiWr4gzVTosJ/GUM89K0Bw==
X-Google-Smtp-Source: ABdhPJyHfxZF3XvBBGLabJM0/+o/cd616yVwBWifbH+ohTirews3dIdk9TsgbL7HFPKM75iLATnYzm6t2UWOCMa2+zo=
X-Received: by 2002:aa7:c887:: with SMTP id p7mr13686147eds.269.1589812862499;
 Mon, 18 May 2020 07:41:02 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1587500467.git.rgb@redhat.com> <b8ba40255978a73ea15e3859d5c945ecd5fede8e.1587500467.git.rgb@redhat.com>
 <CAHC9VhR9sNB58A8uQ4FNgAXOgVJ3RaWF4y5MAo=3mcTojaym0Q@mail.gmail.com>
 <20200517141515.qqx3jx5ulb2546tx@madcap2.tricolour.ca> <CAHC9VhQVRyJ7GRHrujW5Ri-pvBRBgFM2Y8+OYQxca1bUyv2eyg@mail.gmail.com>
 <20200518003920.e6vyzhvadyi5wdjd@madcap2.tricolour.ca>
In-Reply-To: <20200518003920.e6vyzhvadyi5wdjd@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 18 May 2020 10:40:51 -0400
Message-ID: <CAHC9VhTRTm3OywsmZfcjQjfU3OytCbFZ_Qa1uO4LCOEhC=3tnQ@mail.gmail.com>
Subject: Re: [PATCH ghak25 v4 3/3] audit: add subj creds to NETFILTER_CFG
 record to cover async unregister
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     fw@strlen.de, LKML <linux-kernel@vger.kernel.org>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        twoerner@redhat.com, Eric Paris <eparis@parisplace.org>,
        tgraf@infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, May 17, 2020 at 8:40 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-05-17 17:50, Paul Moore wrote:
> > On Sun, May 17, 2020 at 10:15 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > On 2020-04-28 18:25, Paul Moore wrote:
> > > > On Wed, Apr 22, 2020 at 5:40 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > > Some table unregister actions seem to be initiated by the kernel to
> > > > > garbage collect unused tables that are not initiated by any userspace
> > > > > actions.  It was found to be necessary to add the subject credentials to
> > > > > cover this case to reveal the source of these actions.  A sample record:
> > > > >
> > > > >   type=NETFILTER_CFG msg=audit(2020-03-11 21:25:21.491:269) : table=nat family=bridge entries=0 op=unregister pid=153 uid=root auid=unset tty=(none) ses=unset subj=system_u:system_r:kernel_t:s0 comm=kworker/u4:2 exe=(null)
> > > >
> > > > [I'm going to comment up here instead of in the code because it is a
> > > > bit easier for everyone to see what the actual impact might be on the
> > > > records.]
> > > >
> > > > Steve wants subject info in this case, okay, but let's try to trim out
> > > > some of the fields which simply don't make sense in this record; I'm
> > > > thinking of fields that are unset/empty in the kernel case and are
> > > > duplicates of other records in the userspace/syscall case.  I think
> > > > that means we can drop "tty", "ses", "comm", and "exe" ... yes?
> > > >
> > > > While "auid" is a potential target for removal based on the
> > > > dup-or-unset criteria, I think it falls under Steve's request for
> > > > subject info here, even if it is garbage in this case.
> > >
> > > Can you explain why auid falls under this criteria but ses does not if
> > > both are unset?
> >
> > "While "auid" is a potential target for removal based on the
> > dup-or-unset criteria, I think it falls under Steve's request for
> > subject info here, even if it is garbage in this case."
> >
> > It's a concession to Steve.  As I mentioned previously, I think the
> > subject info is bogus in this case; either it is valid and we get it
> > from the SYSCALL record or it simply isn't present in any meaningful
> > way.
>
> Sorry for being so dense.  I still don't follow your explanation.  You've
> repeated the same paragraph that didn't make sense to me the first time.
>
> What definition of "subject info" are you working with?

The subject is generally the task which is causing the event to occur,
"subject info" would be any such attribute which describes the
subject; examples include LSM label, the various UIDs/GIDs, etc..

Think "current->cred" and you on the right track.

> I had assumed
> it was the set of fields that contain information that came from that
> task's struct task_struct.  Some of those fields contain information
> that isn't helpful.  Why not remove them all rather than keep one that
> still contains no useful information?

Once again - and I don't know how else to explain this to you - I
think it is pointless to record the subject info in this record as we
either have that info from other records in the event or there is no
valid subject info to record.  As you state in the commit description:

  "Some table unregister actions seem to be initiated by the
   kernel to garbage collect unused tables that are not
   initiated by any userspace actions."

>  Or is it a matter of keeping one
> key field that contains no useful information that proves that the rest
> is bogus?  Steve said that daemons leave no useful information in auid
> as well, so I don't see how keeping this field helps us.  My
> understanding is that the subj field's "...:kernel_t:..." is the key
> here and that pid and comm give us a bit more of a clue that it is a
> kernel thread.  Is that correct?  What use does including auid serve
> here?

As I've mentioned in the thread above, including the auid was done as
a concession to Steve, I don't think it serves any useful purpose.

-- 
paul moore
www.paul-moore.com
