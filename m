Return-Path: <SRS0=mHk2=SD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9B5AC43381
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Apr 2019 18:57:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DF00206DD
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Apr 2019 18:57:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="VmoLYqOd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbfDAS5x (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Apr 2019 14:57:53 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43208 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728863AbfDAS5w (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Apr 2019 14:57:52 -0400
Received: by mail-lj1-f193.google.com with SMTP id f18so9186690lja.10
        for <netfilter-devel@vger.kernel.org>; Mon, 01 Apr 2019 11:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OG3K/weV3XtavI0+FRqMauSdv1yTiVdKp7cI8yqJMVI=;
        b=VmoLYqOd9sBOa4qVc2Cv+v3SS9L2pZl7L12WgBXrhIoQb1aTyxkfrpGy+r8R01SHxs
         u+g7rMqwp6TxxoKZ6XtBADWzBw9O7IMCTeSuFnvhHOcPkM4pWJg8kbJVssXLPx1zgP8p
         Zxks+WxnpFjUiJgsLTYoU2/e2ZtgaMxYc65XLh4rq+7zRkfMC7xYa6mLIInd6NKA90VK
         vGr98dRfked97bwGv4K+HF/bupiA6ZKklTfx6mpoiwEHAH1uAMBpcCBjt15ty/BjqeJT
         M1ehNf+gSoo7PIr0N5uLwEmwyi3KkkFSr0Y8JllO41ZMahAnJv0hmOqd19lqtw5s60Qr
         Cu2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OG3K/weV3XtavI0+FRqMauSdv1yTiVdKp7cI8yqJMVI=;
        b=FB1/wyk7JJCtuebQWD8bNczjltp4n1nqxOotZ4QNXFb/rzM3FPN1UTXfTn364cT2AO
         2yvx6oRGkOurwXxdYYLydvIozkv0PDSKp48q0hC7ie3G6bcif0A34EGuaLH/0pdQogBd
         MGQ9a+ITtxAkRYimJYPCN+QYrK+Ycy1M/Udh3fa/Oa0gNCOXqxpZVNBJplR20D+Uz6eK
         4ExoNA8WZ1LOX+H9Lj5k0OcNjA+mjyNQADFsCtTKgFG5MtpX5BYHjSnMMO5QhdM02Rwc
         dXCpl+fMyZZrNG1Mg1B6ON/VIQsZ21OPWE75RGML6HrYa+6AyRH681GKlJSami3Flno6
         p+Bg==
X-Gm-Message-State: APjAAAU1C13oI1/Jo2aJzykPkoqFVzNtWN03yeFh6I6znWl0ogVAQd0I
        73uQeV6UvQZHFzgPibXyCuAkKkO02ABA/mk52ei0
X-Google-Smtp-Source: APXvYqzZTCmYYMmiZzBrxg5Ye2yEkEkTVeBsjiuhi46ic7qvkKj57eiftzomk3wmRubyS/f37cBTe/S79dQ8UA9Nlag=
X-Received: by 2002:a2e:7114:: with SMTP id m20mr4729758ljc.120.1554145070271;
 Mon, 01 Apr 2019 11:57:50 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1552665316.git.rgb@redhat.com> <700e4313571f86cc0cdcb7310fbe060f02c7c2db.1552665316.git.rgb@redhat.com>
 <CAHC9VhRWUvG6DwiPn4o+vt=fgGfY+JmG8m78M8CeyGYxF2yRXQ@mail.gmail.com> <20190401174432.fjnvotpvdrfujoy7@madcap2.tricolour.ca>
In-Reply-To: <20190401174432.fjnvotpvdrfujoy7@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 1 Apr 2019 14:57:39 -0400
Message-ID: <CAHC9VhTL=zSQ2tO440w+vvX3TPsGtwqL6dWwUHVe0WnHVKqVpA@mail.gmail.com>
Subject: Re: [PATCH ghak90 V5 06/10] audit: add support for non-syscall
 auxiliary records
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 1, 2019 at 1:44 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2019-04-01 10:49, Paul Moore wrote:
> > On Fri, Mar 15, 2019 at 2:34 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > Standalone audit records have the timestamp and serial number generated
> > > on the fly and as such are unique, making them standalone.  This new
> > > function audit_alloc_local() generates a local audit context that will
> > > be used only for a standalone record and its auxiliary record(s).  The
> > > context is discarded immediately after the local associated records are
> > > produced.
> > >
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > Acked-by: Serge Hallyn <serge@hallyn.com>
> > > ---
> > >  include/linux/audit.h |  8 ++++++++
> > >  kernel/audit.h        |  1 +
> > >  kernel/auditsc.c      | 35 ++++++++++++++++++++++++++++++-----
> > >  3 files changed, 39 insertions(+), 5 deletions(-)
> >
> > ...
> >
> > > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > > index ebd6625ca80e..6db5aba7cc01 100644
> > > --- a/include/linux/audit.h
> > > +++ b/include/linux/audit.h
> > > @@ -285,6 +285,8 @@ static inline void audit_log_contid(struct audit_context *context, u64 contid)
> > >
> > >  /* These are defined in auditsc.c */
> > >                                 /* Public API */
> > > +extern struct audit_context *audit_alloc_local(gfp_t gfpflags);
> > > +extern void audit_free_context(struct audit_context *context);
> > >  extern void __audit_syscall_entry(int major, unsigned long a0, unsigned long a1,
> > >                                   unsigned long a2, unsigned long a3);
> > >  extern void __audit_syscall_exit(int ret_success, long ret_value);
> > > @@ -512,6 +514,12 @@ static inline void audit_fanotify(unsigned int response)
> > >  extern int audit_n_rules;
> > >  extern int audit_signals;
> > >  #else /* CONFIG_AUDITSYSCALL */
> > > +static inline struct audit_context *audit_alloc_local(gfp_t gfpflags)
> > > +{
> > > +       return NULL;
> > > +}
> > > +static inline void audit_free_context(struct audit_context *context)
> > > +{ }
> > >  static inline void audit_syscall_entry(int major, unsigned long a0,
> > >                                        unsigned long a1, unsigned long a2,
> > >                                        unsigned long a3)
> > > diff --git a/kernel/audit.h b/kernel/audit.h
> > > index c5ac6436317e..2a1a8b8a8019 100644
> > > --- a/kernel/audit.h
> > > +++ b/kernel/audit.h
> > > @@ -111,6 +111,7 @@ struct audit_proctitle {
> > >  struct audit_context {
> > >         int                 dummy;      /* must be the first element */
> > >         int                 in_syscall; /* 1 if task is in a syscall */
> > > +       bool                local;      /* local context needed */
> >
> > It's very possible I've missed it, but "local" never gets used in any
> > meaningful way in this patchset does it?
>
> It is used in audit_alloc_local() to signal to audit_get_stamp() that in
> absence of a syscall flag, check for a local flag to continue rather
> than return.

I'm guessing you meant auditsc_get_stamp()?  If so, okay.

-- 
paul moore
www.paul-moore.com
