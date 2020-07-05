Return-Path: <SRS0=UuyC=AQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F61FC433DF
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Jul 2020 15:11:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEF7520747
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Jul 2020 15:11:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="amuEfY6Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgGEPLq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Jul 2020 11:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727803AbgGEPLp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Jul 2020 11:11:45 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294E5C08C5E1
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Jul 2020 08:11:45 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id rk21so39777673ejb.2
        for <netfilter-devel@vger.kernel.org>; Sun, 05 Jul 2020 08:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cTmMCRlwM4HQ8oiNse3u7FDYUgevd5poSx17KumY0vY=;
        b=amuEfY6QBDRlEub7AjLbAs3MFoHaZYkgMZoZqni63pTZzRlQH5ZvcCcZqH8Ix5qe2o
         7Sa0goKImYNSmoSxgLc+eYU8KTS1doy1F++Ra5Q2PTRuY5JybgSmnLMI4qeBFJiQ+Ach
         41hAjVX2Lq8fa/Jn+/3lNHk+41i6jTmv4HQGn2e/YPRVjLIbVW1Am7j+4m6XxnELPA//
         Rly5UI+W1g0Fab6yN3LaHKnX4UM5IKMGbcXEn97Ignxj75clEffWqJNucyOExJxI8Eff
         FKJxKLJG+5zsn0jZWuvOTOYMcEZ/zIx6IIWAm6ZYgvJstpi0fMgdBgVQ4Gj00kDqzfg7
         DuAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cTmMCRlwM4HQ8oiNse3u7FDYUgevd5poSx17KumY0vY=;
        b=ayNeuD2iZcONfxQYsuJboE5pRTT+UkxiEdPdP3/WR0uK+vWVLAt6e18WLmc9V++UvQ
         lI6WOXdFliTZcVyvhxE/wY/CoLpOjTgkiZNbvEtItWZQRlYikdf/ikFktqdd3o22mvZP
         pATe1sq6TW6XXniw6KR+n8dxCtLaZfYdo2UB48oYx/oTs1/QJRB4glZ6WMDB8fF0P0QS
         E9o47Jj15sqMW/u87V+gTFTDbQ5xFG1w0UnLDnHvauymOaAIPG6ISZwT58gTC0OHVHFV
         B+U4ekWokc6V0yeZ0uQeqks6PezlWJZjXdP9mv8sC+fPPWuGMxa6RdB7PSYWQju3yyra
         Vmwg==
X-Gm-Message-State: AOAM532fE2FNkKamp7HuMJebCygjkOyF8HfBHcJ2HbWLO047ePzukd6S
        xQBMi7XYmlRFX8UunLGGJZMGoF2mdVlWNL4Ac23L
X-Google-Smtp-Source: ABdhPJzbzoqFDznCDtmzV+i8Jle6Pdv/RYrhTG0ZL3ik10sa7kBVeBjSG5XnXZVxMrvQrksvZHxq1jdy/wlvs+PxtLI=
X-Received: by 2002:a17:906:c1d8:: with SMTP id bw24mr30265666ejb.91.1593961903721;
 Sun, 05 Jul 2020 08:11:43 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1593198710.git.rgb@redhat.com> <01229b93733d9baf6ac9bb0cc243eeb08ad579cd.1593198710.git.rgb@redhat.com>
In-Reply-To: <01229b93733d9baf6ac9bb0cc243eeb08ad579cd.1593198710.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Sun, 5 Jul 2020 11:11:32 -0400
Message-ID: <CAHC9VhT6cLxxws_pYWcL=mWe786xPoTTFfPZ1=P4hx4V3nytXA@mail.gmail.com>
Subject: Re: [PATCH ghak90 V9 11/13] audit: contid check descendancy and nesting
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, Ondrej Mosnacek <omosnace@redhat.com>,
        dhowells@redhat.com, simo@redhat.com,
        Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>,
        mpatel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Jun 27, 2020 at 9:23 AM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> Require the target task to be a descendant of the container
> orchestrator/engine.
>
> You would only change the audit container ID from one set or inherited
> value to another if you were nesting containers.
>
> If changing the contid, the container orchestrator/engine must be a
> descendant and not same orchestrator as the one that set it so it is not
> possible to change the contid of another orchestrator's container.
>
> Since the task_is_descendant() function is used in YAMA and in audit,
> remove the duplication and pull the function into kernel/core/sched.c
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/linux/sched.h    |  3 +++
>  kernel/audit.c           | 23 +++++++++++++++++++++--
>  kernel/sched/core.c      | 33 +++++++++++++++++++++++++++++++++
>  security/yama/yama_lsm.c | 33 ---------------------------------
>  4 files changed, 57 insertions(+), 35 deletions(-)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 2213ac670386..06938d0b9e0c 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2047,4 +2047,7 @@ static inline void rseq_syscall(struct pt_regs *regs)
>
>  const struct cpumask *sched_trace_rd_span(struct root_domain *rd);
>
> +extern int task_is_descendant(struct task_struct *parent,
> +                             struct task_struct *child);
> +
>  #endif
> diff --git a/kernel/audit.c b/kernel/audit.c
> index a862721dfd9b..efa65ec01239 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -2713,6 +2713,20 @@ int audit_signal_info(int sig, struct task_struct *t)
>         return audit_signal_info_syscall(t);
>  }
>
> +static bool audit_contid_isnesting(struct task_struct *tsk)
> +{
> +       bool isowner = false;
> +       bool ownerisparent = false;
> +
> +       rcu_read_lock();
> +       if (tsk->audit && tsk->audit->cont) {
> +               isowner = current == tsk->audit->cont->owner;
> +               ownerisparent = task_is_descendant(tsk->audit->cont->owner, current);

I want to make sure I'm understanding this correctly and I keep
mentally tripping over something: it seems like for a given audit
container ID a task is either the owner or a descendent, there is no
third state, is that correct?

Assuming that is true, can the descendent check simply be a negative
owner check given they both have the same audit container ID?

> +       }
> +       rcu_read_unlock();
> +       return !isowner && ownerisparent;
> +}
> +
>  /*
>   * audit_set_contid - set current task's audit contid
>   * @task: target task
> @@ -2755,8 +2769,13 @@ int audit_set_contid(struct task_struct *task, u64 contid)
>                 rc = -EBUSY;
>                 goto unlock;
>         }
> -       /* if contid is already set, deny */
> -       if (audit_contid_set(task))
> +       /* if task is not descendant, block */
> +       if (task == current || !task_is_descendant(current, task)) {

I'm also still fuzzy on why we can't let a task set it's own audit
container ID, assuming it meets all the criteria established in patch
2/13.  It somewhat made sense when you were tracking inherited vs
explicitly set audit container IDs, but that doesn't appear to be the
case so far in this patchset, yes?

> +               rc = -EXDEV;

I'm fairly confident we had a discussion about not using all these
different error codes, but that may be a moot point given my next
comment.

> +               goto unlock;
> +       }
> +       /* only allow contid setting again if nesting */
> +       if (audit_contid_set(task) && !audit_contid_isnesting(task))
>                 rc = -EEXIST;

It seems like what we need in audit_set_contid() is a check to ensure
that the task being modified is only modified by the owner of the
audit container ID, yes?  If so, I would think we could do this quite
easily with the following, or similar logic, (NOTE: assumes both
current and tsk are properly setup):

  if ((current->audit->cont != tsk->audit->cont) ||
(current->audit->cont->owner != current))
    return -EACCESS;

This is somewhat independent of the above issue, but we may also want
to add to the capability check.  Patch 2 adds a
"capable(CAP_AUDIT_CONTROL)" which is good, but perhaps we also need a
"ns_capable(CAP_AUDIT_CONTROL)" to allow a given audit container ID
orchestrator/owner the ability to control which of it's descendants
can change their audit container ID, for example:

  if (!capable(CAP_AUDIT_CONTROL) ||
      !ns_capable(current->nsproxy->user_ns, CAP_AUDIT_CONTROL))
    return -EPERM;

--
paul moore
www.paul-moore.com
