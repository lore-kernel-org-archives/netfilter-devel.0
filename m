Return-Path: <SRS0=YYk6=R7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AB62C43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Mar 2019 15:46:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AB2820811
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Mar 2019 15:46:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="IXm0uTio"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbfC1Pqc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Mar 2019 11:46:32 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:41306 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726949AbfC1Pqb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Mar 2019 11:46:31 -0400
Received: by mail-lf1-f65.google.com with SMTP id 10so14358175lfr.8
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Mar 2019 08:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J1rFfeVPNUL+mQFkDcYvOnRRpb0BJX1LnqaH9dlaLrA=;
        b=IXm0uTioHR+okF+fTsHaYrYYAekPBiBJMebQE4H7r1z1k5dw+25gNWdvrlgw8xWECT
         ukz7+d49nkLkiKYy91EhGK0XChliJF8I7WM80SM1ozdhrHg2EqzMfmb9WRHIb2ORyegh
         JUYealFUD5PD5TUpL/sJEYJl96SgWUShs7ARIL+M5UVshzTyPsyOoCvlnjSrN6WKRp0w
         H1FWRSpKveXpmv9abc0MHBQsvK2dIhMUZCcW8F5GKuo2U/bwo9jzwQQspVkRvukK0I3k
         jEEhcXTmTpNEEiqYzEmrMp4nrCS60AKGRZ4631QYF6OfxyuyJWpRFIDBxakb5oML78t0
         aUJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J1rFfeVPNUL+mQFkDcYvOnRRpb0BJX1LnqaH9dlaLrA=;
        b=F8P8ojCzwd9zQqUmcu32Bj/yAGjfcIwrvaI93NePK5wygARnK2PpMr2pZtZj84la8M
         UoRqdYdmb+dWIPXP6yhiLP415SesWFyIDooRLixSbq0Cx4h6FcqICbPgPTgAERp0axOp
         HW7o9VGeWqg9qOfd14GujkvNdHJrw/gZpp+FjEkNlCYRvayPfo8g7DKK9jLZ/X0iNBkZ
         1r0B6oh9nNFlRUNALrQ4l/9/bptloD3sa7t3fFRWNVsYo4FvwTyTvh4Fxjs2TAK+TRp5
         xkaCdlr0nvTRj9il+Px/IKeMssZjSxFosddySovDHcKhtoqRqYIDho1zC1BDTaNyVrHj
         IxVA==
X-Gm-Message-State: APjAAAVIGAxJPY51SlXAZMxE5o9fVm4fO389vRHqhzBaGBZeeKqQuLWD
        +pZNdOFDfWHJS/mWthJi4SFP6wX/7pOop7OR/kkk
X-Google-Smtp-Source: APXvYqwfamkxPb14Cc1V2TuMg4flLBeLIGPcDXA/dCCnkaDofWxUeAigJP0pgRGG5dXe3x8C2hdvRTi9ESq6CBnrvP0=
X-Received: by 2002:a19:ee11:: with SMTP id g17mr21733682lfb.117.1553787989146;
 Thu, 28 Mar 2019 08:46:29 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1552665316.git.rgb@redhat.com> <27473c84a274c64871cfa8e3636deaf05603c978.1552665316.git.rgb@redhat.com>
 <CAFqZXNskwTub5Bm_HZqr02VPB4s79CcgAVX8VE2vQYP07-qssg@mail.gmail.com> <20190328011202.6raixwzdimn5b4zk@madcap2.tricolour.ca>
In-Reply-To: <20190328011202.6raixwzdimn5b4zk@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 28 Mar 2019 11:46:17 -0400
Message-ID: <CAHC9VhQYVSrX1Ng7hZejkGSq6ZXtqi+SKmpARASJ4P2_2i3-4w@mail.gmail.com>
Subject: Re: [PATCH ghak90 V5 09/10] audit: add support for containerid to
 network namespaces
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>, nhorman@tuxdriver.com,
        linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Simo Sorce <simo@redhat.com>, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 27, 2019 at 9:12 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> On 2019-03-27 23:42, Ondrej Mosnacek wrote:
> > On Fri, Mar 15, 2019 at 7:35 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > Audit events could happen in a network namespace outside of a task
> > > context due to packets received from the net that trigger an auditing
> > > rule prior to being associated with a running task.  The network
> > > namespace could be in use by multiple containers by association to the
> > > tasks in that network namespace.  We still want a way to attribute
> > > these events to any potential containers.  Keep a list per network
> > > namespace to track these audit container identifiiers.
> > >
> > > Add/increment the audit container identifier on:
> > > - initial setting of the audit container identifier via /proc
> > > - clone/fork call that inherits an audit container identifier
> > > - unshare call that inherits an audit container identifier
> > > - setns call that inherits an audit container identifier
> > > Delete/decrement the audit container identifier on:
> > > - an inherited audit container identifier dropped when child set
> > > - process exit
> > > - unshare call that drops a net namespace
> > > - setns call that drops a net namespace
> > >
> > > See: https://github.com/linux-audit/audit-kernel/issues/92
> > > See: https://github.com/linux-audit/audit-testsuite/issues/64
> > > See: https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > ---
> > >  include/linux/audit.h | 19 ++++++++++++
> > >  kernel/audit.c        | 86 +++++++++++++++++++++++++++++++++++++++++++++++++--
> > >  kernel/nsproxy.c      |  4 +++
> > >  3 files changed, 106 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > > index fa19fa408931..70255c2dfb9f 100644
> > > --- a/include/linux/audit.h
> > > +++ b/include/linux/audit.h
> > > @@ -27,6 +27,7 @@
> > >  #include <linux/ptrace.h>
> > >  #include <linux/namei.h>  /* LOOKUP_* */
> > >  #include <uapi/linux/audit.h>
> > > +#include <linux/refcount.h>
> > >
> > >  #define AUDIT_INO_UNSET ((unsigned long)-1)
> > >  #define AUDIT_DEV_UNSET ((dev_t)-1)
> > > @@ -99,6 +100,13 @@ struct audit_task_info {
> > >
> > >  extern struct audit_task_info init_struct_audit;
> > >
> > > +struct audit_contid {
> > > +       struct list_head        list;
> > > +       u64                     id;
> > > +       refcount_t              refcount;
> >
> > Hm, since we only ever touch the refcount under a spinlock, I wonder
> > if we could just make it a regular unsigned int (we don't need the
> > atomicity guarantees). OTOH, refcount_t comes with some extra overflow
> > checking, so it's probably better to leave it as is...
>
> Since the update is done using rcu-safe methods, do we even need the
> spin_lock?  Neil?  Paul?

As discussed, the refcount field is protected against simultaneous
writes by the spinlock that protects additions/removals from the list
as a whole so I don't believe the refcount_t atomicity is critical in
this regard.

Where it gets tricky, and I can't say I'm 100% confident on my answer
here, is if refcount was a regular int and we wanted to access it
outside of a spinlock (to be clear, it doesn't look like this patch
currently does this).  With RCU, if refcount was a regular int
(unsigned or otherwise), I believe it would be possible for different
threads of execution to potentially see different values of refcount
(assuming one thread was adding/removing from the list).  Using a
refcount_t would protect against this, alternatively, taking the
spinlock should also protect against this.

As we all know, RCU can be tricky at times, so I may be off on the
above; if I am, please provide an explanation so I (and likely others
as well) can learn a little bit more. :)

-- 
paul moore
www.paul-moore.com
