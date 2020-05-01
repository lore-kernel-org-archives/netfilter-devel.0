Return-Path: <SRS0=Z556=6P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B118C47258
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 May 2020 16:23:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B5362166E
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 May 2020 16:23:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="Zvn4tyvf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729461AbgEAQX2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 May 2020 12:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728947AbgEAQX2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 May 2020 12:23:28 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29F4C061A0E
        for <netfilter-devel@vger.kernel.org>; Fri,  1 May 2020 09:23:27 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id d16so7631246edq.7
        for <netfilter-devel@vger.kernel.org>; Fri, 01 May 2020 09:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jfkQqP4P46nAK7oHXekeHfYjV+lTMmLOA7ipwLh/Dr8=;
        b=Zvn4tyvfjCwJZ4OUXbaZPdeUosydRCUvEPtuDiMRQpLR4Lt1iBBN6upWwzblLJEBt7
         DC8Kwix4abLHUDib+LHkkSs5i7qxPasdEY0sZRZw9fareW+qLioVXXvY7J90+WTOqSCr
         KP3FzIgAp/z6w0Z2zvjoZCK4QVNc2k10LZFzL9i2qpc7qKX9lKA2mbhFHpYmEvgWAq/x
         BttAwm4H7hbo9DPXsPKU1gbl2gNZA4FrIo8F05isaYZqNS+j/gOrY02+dblEz6//nwDe
         wrOUKMMBmTF/VPdoL5ub21/7574RN3HHihWiPlLtpNk1F3ssOwvCRXE4ZnTNKz4wfMYo
         GCqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jfkQqP4P46nAK7oHXekeHfYjV+lTMmLOA7ipwLh/Dr8=;
        b=C5mkXfxV4cd8qNJSTd9fz7feeHJCApTt6AdInsv4squWUj3l4NFJ7VCZVXyP3y5dg5
         WW6sFnkwlO1UAjCZQPeumhZ0hESNLisxSavHdPNyCq7nwTWCkR6Q4VSTRMxINJNJ1MYS
         z3RQfMaSbADW3ZD80vBvUbAOU8JAHPOI48jPjPpowk+Ldc5OKX40Pc86Amw068hzeh1/
         PPPq7VEEOVTheUU8mzgxbaqDR8YFrWeiG+4FTiynd+a0kBDgtP1cpMhCxbdSbB6ZXwYg
         R29Y1xpWxEpMEwmlXvm59FDyKq2U0ypiKfc1N410zckEGcQAh7psscYLRjkSb9c1ftSO
         QboA==
X-Gm-Message-State: AGi0PubHiftWFm80K41+bAwKPvT3T9RopjvxozvOH8XEwsIyDDn+a4W8
        rfleoVJEuh7g/RpLMcg0w9BSlkoDG8SYd3yJAqfg
X-Google-Smtp-Source: APiQypK825QibI3Ui9tCm2G1lExv4S+wdR3Bg+ka7wXCBeYqlb2bim0M0WRbqiTf2qPAhN/AhIew2jU+IiK7WSk1z7A=
X-Received: by 2002:aa7:cb0f:: with SMTP id s15mr4169202edt.164.1588350206362;
 Fri, 01 May 2020 09:23:26 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1587500467.git.rgb@redhat.com> <CAHC9VhR9sNB58A8uQ4FNgAXOgVJ3RaWF4y5MAo=3mcTojaym0Q@mail.gmail.com>
 <20200429143146.3vlcmwvljo74ydb4@madcap2.tricolour.ca> <3348737.k9gCtgYObn@x2>
 <20200429213247.6ewxqf66i2apgyuz@madcap2.tricolour.ca>
In-Reply-To: <20200429213247.6ewxqf66i2apgyuz@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 1 May 2020 12:23:15 -0400
Message-ID: <CAHC9VhRv4GdaBm5ooi5D-j4CBvoOD5L9ab+QPgxhLudtwG=Nsw@mail.gmail.com>
Subject: Re: [PATCH ghak25 v4 3/3] audit: add subj creds to NETFILTER_CFG
 record to cover async unregister
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Steve Grubb <sgrubb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, omosnace@redhat.com, fw@strlen.de,
        twoerner@redhat.com, Eric Paris <eparis@parisplace.org>,
        ebiederm@xmission.com, tgraf@infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 29, 2020 at 5:33 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-04-29 14:47, Steve Grubb wrote:
> > On Wednesday, April 29, 2020 10:31:46 AM EDT Richard Guy Briggs wrote:
> > > On 2020-04-28 18:25, Paul Moore wrote:
> > > > On Wed, Apr 22, 2020 at 5:40 PM Richard Guy Briggs <rgb@redhat.com>
> > wrote:
> > > > > Some table unregister actions seem to be initiated by the kernel to
> > > > > garbage collect unused tables that are not initiated by any userspace
> > > > > actions.  It was found to be necessary to add the subject credentials
> > > > > to  cover this case to reveal the source of these actions.  A sample
> > > > > record:
> > > > >   type=NETFILTER_CFG msg=audit(2020-03-11 21:25:21.491:269) : table=nat
> > > > >   family=bridge entries=0 op=unregister pid=153 uid=root auid=unset
> > > > >   tty=(none) ses=unset subj=system_u:system_r:kernel_t:s0
> > > > >   comm=kworker/u4:2 exe=(null)>
> > > > [I'm going to comment up here instead of in the code because it is a
> > > > bit easier for everyone to see what the actual impact might be on the
> > > > records.]
> > > >
> > > > Steve wants subject info in this case, okay, but let's try to trim out
> > > > some of the fields which simply don't make sense in this record; I'm
> > > > thinking of fields that are unset/empty in the kernel case and are
> > > > duplicates of other records in the userspace/syscall case.  I think
> > > > that means we can drop "tty", "ses", "comm", and "exe" ... yes?
> > >
> > > From the ghak28 discussion, this list and order was selected due to
> > > Steve's preference for the "kernel" record convention, so deviating from
> > > this will create yet a new field list.  I'll defer to Steve on this.  It
> > > also has to do with the searchability of fields if they are missing.
> > >
> > > I do agree that some fields will be superfluous in the kernel case.
> > > The most important field would be "subj", but then "pid" and "comm", I
> > > would think.  Based on this contents of the "subj" field, I'd think that
> > > "uid", "auid", "tty", "ses" and "exe" are not needed.
> >
> > We can't be adding deleting fields based on how its triggered. If they are
> > unset, that is fine. The main issue is they have to behave the same.
>
> I don't think the intent was to have fields swing in and out depending
> on trigger.  The idea is to potentially permanently not include them in
> this record type only.  The justification is that where they aren't
> needed for the kernel trigger situation it made sense to delete them
> because if it is a user context event it will be accompanied by a
> syscall record that already has that information and there would be no
> sense in duplicating it.

Yes, exactly.

-- 
paul moore
www.paul-moore.com
