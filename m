Return-Path: <SRS0=YYk6=R7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC157C43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Mar 2019 22:00:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D03A2184E
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Mar 2019 22:00:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="uO0zwFg1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbfC1WAn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Mar 2019 18:00:43 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34959 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727935AbfC1WAf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Mar 2019 18:00:35 -0400
Received: by mail-lj1-f194.google.com with SMTP id t4so215598ljc.2
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Mar 2019 15:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ydwqILf+lzcgNiOhfVooHaxoKMfjMG8RcB/4lBwPLkA=;
        b=uO0zwFg1gSIla5jytxwzZTQbLiu9J8tvNhcGYH9n1RIWUWmsTPdj29lsqZbhhCD3rq
         ryKYS2UriTUQS7d5Cpl7UKHsjUSV+HQDG8moWqK6NT+yYmf1SKbKEcR0oU6iE9dSHcFQ
         6na/nDSR9MnIxYtH4nq9Tyt3j+IZilJ6mYxoXdJTjC7c2ZRZiH1ox0H2xeuh9nQEyY02
         dTEnO3RHcyy97vM3Qh2K3c7DJeZlx1aOnKB/HMpzaJkgEsJE0hxxAFBa4SirqnuD2dyD
         mytYIafIa1ykpkbDY/26h58cwgNBreE437K8CfHmzWkfI5afyYoUsZ//eAbjaYb8d2I1
         RtwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ydwqILf+lzcgNiOhfVooHaxoKMfjMG8RcB/4lBwPLkA=;
        b=ZIoJeVkbyii6H8tIiAxZQOL8qanXxJyMNjxJymXQBuXp6mnSVA8lCJ2w67XaMuoOMe
         ellPoxszGMrAoW7HoPgj25umbAkOGKtHaNfH/wdNxeLYsnejYF9ZEt8RIShWbbP6p7cl
         bIqAka5Hyi2Rl+ogZ39aKey1sX1D8WlSJOpiJmEmS5hwwx/T/yFlOi+Y0bypXZpk9xBA
         ypXNmlPqhyJrgxpmF7IAqEMHu0Pb7DmnX6FvEE3kVQkRpyD5of4c4M9djPAejHqIVTgQ
         xAgCnepSzZFDI7cBZVyfKxp6ds2C6z/hGD0D2W7QUTyKtYuQCd6GXfv6BLOiepdX/UJT
         ZyNw==
X-Gm-Message-State: APjAAAVLzVpJjgPeIWTpzcJ5W7bmwmoDykIldfaRM8yJXeK1M/SYOFU+
        PrUa4yNh4hpYyYYu3tqps9bjmbC52VyTeRFyMqfh
X-Google-Smtp-Source: APXvYqz1I+9cWRNojMB3dutdCHdrH3oxaE4B86JEJSjvGnXN/iDqwpfIrsgL/INXz+Ms8ClkdP4cASn8B+1ZjyYi5Y0=
X-Received: by 2002:a2e:1510:: with SMTP id s16mr9542663ljd.196.1553810432805;
 Thu, 28 Mar 2019 15:00:32 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1552665316.git.rgb@redhat.com> <27473c84a274c64871cfa8e3636deaf05603c978.1552665316.git.rgb@redhat.com>
 <CAFqZXNskwTub5Bm_HZqr02VPB4s79CcgAVX8VE2vQYP07-qssg@mail.gmail.com>
 <20190328011202.6raixwzdimn5b4zk@madcap2.tricolour.ca> <CAHC9VhQYVSrX1Ng7hZejkGSq6ZXtqi+SKmpARASJ4P2_2i3-4w@mail.gmail.com>
 <20190328214023.qpszfvxbrjlldmmt@madcap2.tricolour.ca>
In-Reply-To: <20190328214023.qpszfvxbrjlldmmt@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 28 Mar 2019 18:00:21 -0400
Message-ID: <CAHC9VhQiFw32s9QNK4WQDM6rbWHqOhm1AVa2JvY=19V4S+=YhA@mail.gmail.com>
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

On Thu, Mar 28, 2019 at 5:40 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2019-03-28 11:46, Paul Moore wrote:
> > On Wed, Mar 27, 2019 at 9:12 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > >
> > > On 2019-03-27 23:42, Ondrej Mosnacek wrote:
> > > > On Fri, Mar 15, 2019 at 7:35 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > > Audit events could happen in a network namespace outside of a task
> > > > > context due to packets received from the net that trigger an auditing
> > > > > rule prior to being associated with a running task.  The network
> > > > > namespace could be in use by multiple containers by association to the
> > > > > tasks in that network namespace.  We still want a way to attribute
> > > > > these events to any potential containers.  Keep a list per network
> > > > > namespace to track these audit container identifiiers.
> > > > >
> > > > > Add/increment the audit container identifier on:
> > > > > - initial setting of the audit container identifier via /proc
> > > > > - clone/fork call that inherits an audit container identifier
> > > > > - unshare call that inherits an audit container identifier
> > > > > - setns call that inherits an audit container identifier
> > > > > Delete/decrement the audit container identifier on:
> > > > > - an inherited audit container identifier dropped when child set
> > > > > - process exit
> > > > > - unshare call that drops a net namespace
> > > > > - setns call that drops a net namespace
> > > > >
> > > > > See: https://github.com/linux-audit/audit-kernel/issues/92
> > > > > See: https://github.com/linux-audit/audit-testsuite/issues/64
> > > > > See: https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> > > > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > > > ---
> > > > >  include/linux/audit.h | 19 ++++++++++++
> > > > >  kernel/audit.c        | 86 +++++++++++++++++++++++++++++++++++++++++++++++++--
> > > > >  kernel/nsproxy.c      |  4 +++
> > > > >  3 files changed, 106 insertions(+), 3 deletions(-)
> > > > >
> > > > > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > > > > index fa19fa408931..70255c2dfb9f 100644
> > > > > --- a/include/linux/audit.h
> > > > > +++ b/include/linux/audit.h
> > > > > @@ -27,6 +27,7 @@
> > > > >  #include <linux/ptrace.h>
> > > > >  #include <linux/namei.h>  /* LOOKUP_* */
> > > > >  #include <uapi/linux/audit.h>
> > > > > +#include <linux/refcount.h>
> > > > >
> > > > >  #define AUDIT_INO_UNSET ((unsigned long)-1)
> > > > >  #define AUDIT_DEV_UNSET ((dev_t)-1)
> > > > > @@ -99,6 +100,13 @@ struct audit_task_info {
> > > > >
> > > > >  extern struct audit_task_info init_struct_audit;
> > > > >
> > > > > +struct audit_contid {
> > > > > +       struct list_head        list;
> > > > > +       u64                     id;
> > > > > +       refcount_t              refcount;
> > > >
> > > > Hm, since we only ever touch the refcount under a spinlock, I wonder
> > > > if we could just make it a regular unsigned int (we don't need the
> > > > atomicity guarantees). OTOH, refcount_t comes with some extra overflow
> > > > checking, so it's probably better to leave it as is...
> > >
> > > Since the update is done using rcu-safe methods, do we even need the
> > > spin_lock?  Neil?  Paul?
> >
> > As discussed, the refcount field is protected against simultaneous
> > writes by the spinlock that protects additions/removals from the list
> > as a whole so I don't believe the refcount_t atomicity is critical in
> > this regard.
> >
> > Where it gets tricky, and I can't say I'm 100% confident on my answer
> > here, is if refcount was a regular int and we wanted to access it
> > outside of a spinlock (to be clear, it doesn't look like this patch
> > currently does this).  With RCU, if refcount was a regular int
> > (unsigned or otherwise), I believe it would be possible for different
> > threads of execution to potentially see different values of refcount
> > (assuming one thread was adding/removing from the list).  Using a
> > refcount_t would protect against this, alternatively, taking the
> > spinlock should also protect against this.
>
> Ok, from the above it isn't clear to me if you are happy with the
> current code or would prefer any changes, or from below that you still
> need to work it through to make a pronouncement.  It sounds to me you
> would be ok with *either* spinlock *or* refcount_t, but don't see the
> need for both.

To be fair you didn't ask if I was "happy" with the approach above,
you asked if we needed the spinlock/refcount_t.  I believe I answered
that question as comprehensively as I could, but perhaps you wanted a
hard yes or no?  In that case, since refcount_t is obviously safer, I
would stick with that for now just to limit the number of possible
failures.  If someone smarter than you or I comes along and
definitively says you are 100% safe to use an int, then go ahead and
use an int.

Beyond that, I'm still in the process of reviewing your patches, but I
haven't finished yet, so no "pronouncement" or whatever you want to
call it.

-- 
paul moore
www.paul-moore.com
