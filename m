Return-Path: <SRS0=hCoj=ZA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ADF2FA372C
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Nov 2019 18:26:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE90F215EA
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Nov 2019 18:26:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="y1K0awVa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbfKHS0d (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Nov 2019 13:26:33 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33388 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbfKHS0c (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Nov 2019 13:26:32 -0500
Received: by mail-lj1-f194.google.com with SMTP id t5so7249521ljk.0
        for <netfilter-devel@vger.kernel.org>; Fri, 08 Nov 2019 10:26:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yfrqk4oAZSRdxNXU7NWHV3s/qknksusoqMId/97+bh8=;
        b=y1K0awVaPkO46sJakcQS8uKieCdS/hCTRRGdp7q5Dcku0FUI40wj7F+zld2UORzEbf
         t8YG8QSWNop4/suFu+5p6OBsjDlLmTswYjH/3bLUmv9AcOoVfZDeOxZjGeOYnoTXA6HQ
         J8aMPm2axVmOGDf5xSwuijEvUOv5sKpFh9JUyrH0Kqx/t6feWNf2IUF+xYaJPauhde4n
         IuGvkCufzn9sVUy4WXyW1gLblbgYB8D+aexe4RpGSB9pg3OV5iGRR2py7xDoNKIYBlIc
         PZTrGRMZIlhMNrWif9jD4E8iCrXApMODQRFEsPi4vx5MLLJacWWpJdjOsLxXzD9bVAd1
         r26w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yfrqk4oAZSRdxNXU7NWHV3s/qknksusoqMId/97+bh8=;
        b=aIFq+nMlAUFf0UXXN3fisx2jNirJJ3Wo6Q9707TnMgr3m7tXYX4o+HF9C1rm/s+dXF
         DezvIu/b08FO7bDEo2C89XxWeSOf/VQNj6FowwpuJFjuWUiWe5qVizi+eWFVH4QRCDeC
         pDNyIQalz2Wi1NYmklmTqKBwn5FhLpUbIugq/iLh9EgUVK+hl3qVgxFIh9dxGvJ7TP4e
         RBj1Be1vTRbpfFECjDtzE4nMT2dUZ2zhKltmSVK3vZvTE2dwTwKab1ia7MAoE9iKUXXR
         uzXz5Qiv4yfWEaGa7D0XS61Ri3z7/jMD3bogfqGpuDqO5hVjnhJoycmuKYb1NasGiFqC
         YeWw==
X-Gm-Message-State: APjAAAUyvpbg8cq7IHD4aR9hSeSoJ78JOMi9EFQmxSf/JtFE8YojZmtd
        08z8gtIFDHVASMcdu0+Qi+sjC4dVx8Igtom/xyqY
X-Google-Smtp-Source: APXvYqw1CojLXlLXhi44VGUdhNOsRF4p9i8B7yLeQIjTFUXYF7RTFSwfHA6RC+gtdGcnk7X56NGlBF0xrTDt5/lxnqc=
X-Received: by 2002:a2e:85d5:: with SMTP id h21mr7824291ljj.243.1573237589836;
 Fri, 08 Nov 2019 10:26:29 -0800 (PST)
MIME-Version: 1.0
References: <cover.1568834524.git.rgb@redhat.com> <6fb4e270bfafef3d0477a06b0365fdcc5a5305b5.1568834524.git.rgb@redhat.com>
 <CAHC9VhS2111YTQ_rbHKe6+n9coPNbcTJqf5wnBx9LYHSf69THA@mail.gmail.com> <20191025210004.jzkenjg6jrka22ak@madcap2.tricolour.ca>
In-Reply-To: <20191025210004.jzkenjg6jrka22ak@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 8 Nov 2019 13:26:18 -0500
Message-ID: <CAHC9VhRMJkeC7HkAMr1TwymtT7eHOB_B=_28R6zVfQQk-gW-DA@mail.gmail.com>
Subject: Re: [PATCH ghak90 V7 04/21] audit: convert to contid list to check
 for orch/engine ownership
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>,
        mpatel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Oct 25, 2019 at 5:00 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2019-10-10 20:38, Paul Moore wrote:
> > On Wed, Sep 18, 2019 at 9:24 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > Store the audit container identifier in a refcounted kernel object that
> > > is added to the master list of audit container identifiers.  This will
> > > allow multiple container orchestrators/engines to work on the same
> > > machine without danger of inadvertantly re-using an existing identifier.
> > > It will also allow an orchestrator to inject a process into an existing
> > > container by checking if the original container owner is the one
> > > injecting the task.  A hash table list is used to optimize searches.
> > >
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > ---
> > >  include/linux/audit.h | 26 ++++++++++++++--
> > >  kernel/audit.c        | 86 ++++++++++++++++++++++++++++++++++++++++++++++++---
> > >  kernel/audit.h        |  8 +++++
> > >  3 files changed, 112 insertions(+), 8 deletions(-)
> >
> > One general comment before we go off into the weeds on this ... I can
> > understand why you wanted to keep this patch separate from the earlier
> > patches, but as we get closer to having mergeable code this should get
> > folded into the previous patches.  For example, there shouldn't be a
> > change in audit_task_info where you change the contid field from a u64
> > to struct pointer, it should be a struct pointer from the start.
>
> I should have marked this patchset as RFC even though it was v7 due to a
> lot of new ideas/code that was added with uncertainties needing comment
> and direction.
>
> > It's also disappointing that idr appears to only be for 32-bit ID
> > values, if we had a 64-bit idr I think we could simplify this greatly.
>
> Perhaps.  I do still see value in letting the orchestrator choose the
> value.

Agreed.  I was just thinking out loud that it seems like much of what
we need could be a generic library mechanism similar to, but not quite
like, the existing idr code.

> > > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > > index f2e3b81f2942..e317807cdd3e 100644
> > > --- a/include/linux/audit.h
> > > +++ b/include/linux/audit.h
> > > @@ -95,10 +95,18 @@ struct audit_ntp_data {
> > >  struct audit_ntp_data {};
> > >  #endif
> > >
> > > +struct audit_cont {
> > > +       struct list_head        list;
> > > +       u64                     id;
> > > +       struct task_struct      *owner;
> > > +       refcount_t              refcount;
> > > +       struct rcu_head         rcu;
> > > +};
> >
> > It seems as though in most of the code you are using "contid", any
> > reason why didn't stick with that naming scheme here, e.g. "struct
> > audit_contid"?
>
> I was using contid to refer to the value itself and cont to refer to the
> refcounted object.  I find cont a bit too terse, so I'm still thinking
> of changing it.  Perhaps contobj?

Yes, just "cont" is a bit too ambiguous considering we have both
integer values and structures being passed around.  Whatever you
decide on, a common base with separate suffixes seems like a good
idea.

FWIW, I still think the "audit container ID" : "ACID" thing is kinda funny ;)

> > > @@ -203,11 +211,15 @@ static inline unsigned int audit_get_sessionid(struct task_struct *tsk)
> > >
> > >  static inline u64 audit_get_contid(struct task_struct *tsk)
> > >  {
> > > -       if (!tsk->audit)
> > > +       if (!tsk->audit || !tsk->audit->cont)
> > >                 return AUDIT_CID_UNSET;
> > > -       return tsk->audit->contid;
> > > +       return tsk->audit->cont->id;
> > >  }
> >
> > Assuming for a moment that we implement an audit_contid_get() (see
> > Neil's comment as well as mine below), we probably need to name this
> > something different so we don't all lose our minds when we read this
> > code.  On the plus side we can probably preface it with an underscore
> > since it is a static, in which case _audit_contid_get() might be okay,
> > but I'm open to suggestions.
>
> I'm fine with the "_" prefix, can you point to precedent or convention?

Generally kernel functions which are "special"/private/unsafe/etc.
have a one, or two, underscore prefix.  If you don't want to add the
prefix, that's fine, but please change the name as mentioned
previously.

> > > @@ -231,7 +235,9 @@ int audit_alloc(struct task_struct *tsk)
> > >         }
> > >         info->loginuid = audit_get_loginuid(current);
> > >         info->sessionid = audit_get_sessionid(current);
> > > -       info->contid = audit_get_contid(current);
> > > +       info->cont = audit_cont(current);
> > > +       if (info->cont)
> > > +               refcount_inc(&info->cont->refcount);
> >
> > See the other comments about a "get" function, but I think we need a
> > RCU read lock around the above, no?
>
> The rcu read lock is to protect the list rather than the cont object
> itself, the latter of which is protected by its refcount.

What protects you from info->cont going away between when you fetch
the pointer via audit_cont() to when you dereference it in
refcount_inc()?

> > > @@ -2397,8 +2438,43 @@ int audit_set_contid(struct task_struct *task, u64 contid)
> > >         else if (audit_contid_set(task))
> > >                 rc = -ECHILD;
> > >         read_unlock(&tasklist_lock);
> > > -       if (!rc)
> > > -               task->audit->contid = contid;
> > > +       if (!rc) {
> > > +               struct audit_cont *oldcont = audit_cont(task);
> >
> > Previously we held the tasklist_lock to protect the audit container ID
> > associated with the struct, should we still be holding it here?
>
> We held the tasklist_lock to protect access to the target task's
> child/parent/thread relationships.

What protects us in the case of simultaneous calls to audit_set_contid()?

> > Regardless, I worry that the lock dependencies between the
> > tasklist_lock and the audit_contid_list_lock are going to be tricky.
> > It might be nice to document the relationship in a comment up near
> > where you declare audit_contid_list_lock.
>
> I don't think there should be a conflict between the two.
>
> The contid_list_lock doesn't care if the cont object is associated to a
> particular task.

Please document the relationship between the two, I worry we could
easily run into lockdep problems without a clearly defined ordering.

> > > +               struct audit_cont *cont = NULL;
> > > +               struct audit_cont *newcont = NULL;
> > > +               int h = audit_hash_contid(contid);
> > > +
> > > +               spin_lock(&audit_contid_list_lock);
> > > +               list_for_each_entry_rcu(cont, &audit_contid_hash[h], list)
> > > +                       if (cont->id == contid) {
> > > +                               /* task injection to existing container */
> > > +                               if (current == cont->owner) {
> >
> > I understand the desire to limit a given audit container ID to the
> > orchestrator that created it, but are we certain that we can track
> > audit container ID "ownership" via a single instance of a task_struct?
>
> Are you suggesting that a task_struct representing a task may be
> replaced for a specific task?  I don't believe that will ever happen.
>
> >  What happens when the orchestrator stops/restarts/crashes?  Do we
> > even care?
>
> Reap all of its containers?

These were genuine questions, I'm not suggesting anything in
particular, I'm just curious about how we handle an orchestrator that
isn't continuously running ... is this possible?  Do we care?

-- 
paul moore
www.paul-moore.com
