Return-Path: <SRS0=BqdC=T5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90B47C28CC2
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 22:40:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68D012429F
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 22:40:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="dQA6HRvG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfE2WkG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 May 2019 18:40:06 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33207 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbfE2WkD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 May 2019 18:40:03 -0400
Received: by mail-lj1-f193.google.com with SMTP id w1so4170235ljw.0
        for <netfilter-devel@vger.kernel.org>; Wed, 29 May 2019 15:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WTgrsrN2kv//1St2pvsmjLA5iqBOgmifLWx+zhYVKFA=;
        b=dQA6HRvG3+wzV5eXemCHoKBPfsIFBFsv2wTeLNycaFR8OykyginbjbUIT+4Y+EKPbn
         66+our2twD97jFo/r1GvJljozn9a2WOhpNKWiSZxPrqe2x55z2gRDo/Hti9obvPDpCxy
         q0/82fxVtQ9NQbtPmOUGCIZVaSmj/O0i9tPpfbwg62BSmDBNpQ/ZDjb6CDHO0eIrG594
         2Khitp6zhlMlPIaB+DbmKsslk5i4gt0fMhdFLXDZTeSG56f4xmZu/LzKkptugoepqPLd
         VsHmw7z6pxW6mEdkM++TXegVXY3pcTca5WN1sgP/IqMPAQ40mQ/JCxGRX5nkVko7dOCt
         eIbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WTgrsrN2kv//1St2pvsmjLA5iqBOgmifLWx+zhYVKFA=;
        b=P+7LkmTCWV59Amv+EBZ/nfHgPoapfpN7Tg92ke89dqMIw1Fxzer7mjorINE8ee6EgA
         M7fCucyOvZdkgpTphrbRnfAylgq43qyGzoZWDhpOqMx8kMWSvYFDFJEhdQY1yVRoS+86
         h0TihnJ+ekcz3KQUaJu+0RyYrma8H3d5k6jUfm3UpvLHhpW8tSFju0Wkj0jcl5Ve0VGw
         PGEgsFbzT7mTgC/CmbmJMhMBaRW6Ic/vDz/vSjB+fPx/3tJw4rCPH4fUece/FJgZjTTY
         5WFXf930+UR8cYZBbV55rWCbUYTu4zpukJwxOAQ9k1YKQyjXgdODLYlP34flBvKM2D5S
         f+lQ==
X-Gm-Message-State: APjAAAV+SRTNmTEd39lC9BMmFYWtnTlZOK3nZc7CDIEI7CdAY+bCJPqN
        2+QcpcNaNH1D++6zgpISLtz+Bo4HkbtzgwwCnFYd
X-Google-Smtp-Source: APXvYqypWUt4sIdwbKkSaqf3h7Xd+EVdB693EwEA/QY8VSfiHNLm7NcciHkAOIz7+KuTVCkWgrvincEsQyEv7l6QF/g=
X-Received: by 2002:a2e:9a97:: with SMTP id p23mr173332lji.160.1559169600002;
 Wed, 29 May 2019 15:40:00 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1554732921.git.rgb@redhat.com> <9edad39c40671fb53f28d76862304cc2647029c6.1554732921.git.rgb@redhat.com>
 <20190529145742.GA8959@cisco> <CAHC9VhR4fudQanvZGYWMvCf7k2CU3q7e7n1Pi7hzC3v_zpVEdw@mail.gmail.com>
 <20190529153427.GB8959@cisco> <CAHC9VhSF3AjErX37+eeusJ7+XRw8yuPsmqBTRwc9EVoRBh_3Tw@mail.gmail.com>
 <20190529222835.GD8959@cisco>
In-Reply-To: <20190529222835.GD8959@cisco>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 29 May 2019 18:39:48 -0400
Message-ID: <CAHC9VhRS66VGtug3fq3RTGHDvfGmBJG6yRJ+iMxm3cxnNF-zJw@mail.gmail.com>
Subject: Re: [PATCH ghak90 V6 02/10] audit: add container id
To:     Tycho Andersen <tycho@tycho.ws>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
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

On Wed, May 29, 2019 at 6:28 PM Tycho Andersen <tycho@tycho.ws> wrote:
> On Wed, May 29, 2019 at 12:03:58PM -0400, Paul Moore wrote:
> > On Wed, May 29, 2019 at 11:34 AM Tycho Andersen <tycho@tycho.ws> wrote:
> > >
> > > On Wed, May 29, 2019 at 11:29:05AM -0400, Paul Moore wrote:
> > > > On Wed, May 29, 2019 at 10:57 AM Tycho Andersen <tycho@tycho.ws> wrote:
> > > > >
> > > > > On Mon, Apr 08, 2019 at 11:39:09PM -0400, Richard Guy Briggs wrote:
> > > > > > It is not permitted to unset the audit container identifier.
> > > > > > A child inherits its parent's audit container identifier.
> > > > >
> > > > > ...
> > > > >
> > > > > >  /**
> > > > > > + * audit_set_contid - set current task's audit contid
> > > > > > + * @contid: contid value
> > > > > > + *
> > > > > > + * Returns 0 on success, -EPERM on permission failure.
> > > > > > + *
> > > > > > + * Called (set) from fs/proc/base.c::proc_contid_write().
> > > > > > + */
> > > > > > +int audit_set_contid(struct task_struct *task, u64 contid)
> > > > > > +{
> > > > > > +     u64 oldcontid;
> > > > > > +     int rc = 0;
> > > > > > +     struct audit_buffer *ab;
> > > > > > +     uid_t uid;
> > > > > > +     struct tty_struct *tty;
> > > > > > +     char comm[sizeof(current->comm)];
> > > > > > +
> > > > > > +     task_lock(task);
> > > > > > +     /* Can't set if audit disabled */
> > > > > > +     if (!task->audit) {
> > > > > > +             task_unlock(task);
> > > > > > +             return -ENOPROTOOPT;
> > > > > > +     }
> > > > > > +     oldcontid = audit_get_contid(task);
> > > > > > +     read_lock(&tasklist_lock);
> > > > > > +     /* Don't allow the audit containerid to be unset */
> > > > > > +     if (!audit_contid_valid(contid))
> > > > > > +             rc = -EINVAL;
> > > > > > +     /* if we don't have caps, reject */
> > > > > > +     else if (!capable(CAP_AUDIT_CONTROL))
> > > > > > +             rc = -EPERM;
> > > > > > +     /* if task has children or is not single-threaded, deny */
> > > > > > +     else if (!list_empty(&task->children))
> > > > > > +             rc = -EBUSY;
> > > > > > +     else if (!(thread_group_leader(task) && thread_group_empty(task)))
> > > > > > +             rc = -EALREADY;
> > > > > > +     read_unlock(&tasklist_lock);
> > > > > > +     if (!rc)
> > > > > > +             task->audit->contid = contid;
> > > > > > +     task_unlock(task);
> > > > > > +
> > > > > > +     if (!audit_enabled)
> > > > > > +             return rc;
> > > > >
> > > > > ...but it is allowed to change it (assuming
> > > > > capable(CAP_AUDIT_CONTROL), of course)? Seems like this might be more
> > > > > immediately useful since we still live in the world of majority
> > > > > privileged containers if we didn't allow changing it, in addition to
> > > > > un-setting it.
> > > >
> > > > The idea is that only container orchestrators should be able to
> > > > set/modify the audit container ID, and since setting the audit
> > > > container ID can have a significant effect on the records captured
> > > > (and their routing to multiple daemons when we get there) modifying
> > > > the audit container ID is akin to modifying the audit configuration
> > > > which is why it is gated by CAP_AUDIT_CONTROL.  The current thinking
> > > > is that you would only change the audit container ID from one
> > > > set/inherited value to another if you were nesting containers, in
> > > > which case the nested container orchestrator would need to be granted
> > > > CAP_AUDIT_CONTROL (which everyone to date seems to agree is a workable
> > > > compromise).
> > >
> > > But then don't you want some kind of ns_capable() instead (probably
> > > not the obvious one, though...)? With capable(), you can't really nest
> > > using the audit-id and user namespaces together.
> >
> > You want capable() and not ns_capable() because you want to ensure
> > that the orchestrator has the rights in the init_ns as changes to the
> > audit container ID could have an auditing impact that spans the entire
> > system.
>
> Ok but,
>
> > > > The current thinking
> > > > is that you would only change the audit container ID from one
> > > > set/inherited value to another if you were nesting containers, in
> > > > which case the nested container orchestrator would need to be granted
> > > > CAP_AUDIT_CONTROL (which everyone to date seems to agree is a workable
> > > > compromise).
>
> won't work in user namespaced containers, because they will never be
> capable(CAP_AUDIT_CONTROL); so I don't think this will work for
> nesting as is. But maybe nobody cares :)

That's fun :)

To be honest, I've never been a big fan of supporting nested
containers from an audit perspective, so I'm not really too upset
about this.  The k8s/cri-o folks seem okay with this, or at least I
haven't heard any objections; lxc folks, what do you have to say?

-- 
paul moore
www.paul-moore.com
