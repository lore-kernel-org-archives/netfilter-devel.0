Return-Path: <SRS0=FgsC=SC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7833C43381
	for <netfilter-devel@archiver.kernel.org>; Sun, 31 Mar 2019 02:12:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85B862085A
	for <netfilter-devel@archiver.kernel.org>; Sun, 31 Mar 2019 02:12:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731090AbfCaCMm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Mar 2019 22:12:42 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60375 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731063AbfCaCMm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Mar 2019 22:12:42 -0400
Received: from cpe-2606-a000-111b-405a-9816-2c85-c514-8f7a.dyn6.twc.com ([2606:a000:111b:405a:9816:2c85:c514:8f7a] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hAPxQ-0004uU-D9; Sat, 30 Mar 2019 22:12:32 -0400
Date:   Sat, 30 Mar 2019 22:11:56 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Simo Sorce <simo@redhat.com>, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH ghak90 V5 09/10] audit: add support for containerid to
 network namespaces
Message-ID: <20190330125748.GA2869@hmswarspite.think-freely.org>
References: <cover.1552665316.git.rgb@redhat.com>
 <27473c84a274c64871cfa8e3636deaf05603c978.1552665316.git.rgb@redhat.com>
 <CAFqZXNskwTub5Bm_HZqr02VPB4s79CcgAVX8VE2vQYP07-qssg@mail.gmail.com>
 <20190328011202.6raixwzdimn5b4zk@madcap2.tricolour.ca>
 <CAHC9VhQYVSrX1Ng7hZejkGSq6ZXtqi+SKmpARASJ4P2_2i3-4w@mail.gmail.com>
 <20190328214023.qpszfvxbrjlldmmt@madcap2.tricolour.ca>
 <CAHC9VhQiFw32s9QNK4WQDM6rbWHqOhm1AVa2JvY=19V4S+=YhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhQiFw32s9QNK4WQDM6rbWHqOhm1AVa2JvY=19V4S+=YhA@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 28, 2019 at 06:00:21PM -0400, Paul Moore wrote:
> On Thu, Mar 28, 2019 at 5:40 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2019-03-28 11:46, Paul Moore wrote:
> > > On Wed, Mar 27, 2019 at 9:12 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > >
> > > > On 2019-03-27 23:42, Ondrej Mosnacek wrote:
> > > > > On Fri, Mar 15, 2019 at 7:35 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > > > Audit events could happen in a network namespace outside of a task
> > > > > > context due to packets received from the net that trigger an auditing
> > > > > > rule prior to being associated with a running task.  The network
> > > > > > namespace could be in use by multiple containers by association to the
> > > > > > tasks in that network namespace.  We still want a way to attribute
> > > > > > these events to any potential containers.  Keep a list per network
> > > > > > namespace to track these audit container identifiiers.
> > > > > >
> > > > > > Add/increment the audit container identifier on:
> > > > > > - initial setting of the audit container identifier via /proc
> > > > > > - clone/fork call that inherits an audit container identifier
> > > > > > - unshare call that inherits an audit container identifier
> > > > > > - setns call that inherits an audit container identifier
> > > > > > Delete/decrement the audit container identifier on:
> > > > > > - an inherited audit container identifier dropped when child set
> > > > > > - process exit
> > > > > > - unshare call that drops a net namespace
> > > > > > - setns call that drops a net namespace
> > > > > >
> > > > > > See: https://github.com/linux-audit/audit-kernel/issues/92
> > > > > > See: https://github.com/linux-audit/audit-testsuite/issues/64
> > > > > > See: https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> > > > > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > > > > ---
> > > > > >  include/linux/audit.h | 19 ++++++++++++
> > > > > >  kernel/audit.c        | 86 +++++++++++++++++++++++++++++++++++++++++++++++++--
> > > > > >  kernel/nsproxy.c      |  4 +++
> > > > > >  3 files changed, 106 insertions(+), 3 deletions(-)
> > > > > >
> > > > > > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > > > > > index fa19fa408931..70255c2dfb9f 100644
> > > > > > --- a/include/linux/audit.h
> > > > > > +++ b/include/linux/audit.h
> > > > > > @@ -27,6 +27,7 @@
> > > > > >  #include <linux/ptrace.h>
> > > > > >  #include <linux/namei.h>  /* LOOKUP_* */
> > > > > >  #include <uapi/linux/audit.h>
> > > > > > +#include <linux/refcount.h>
> > > > > >
> > > > > >  #define AUDIT_INO_UNSET ((unsigned long)-1)
> > > > > >  #define AUDIT_DEV_UNSET ((dev_t)-1)
> > > > > > @@ -99,6 +100,13 @@ struct audit_task_info {
> > > > > >
> > > > > >  extern struct audit_task_info init_struct_audit;
> > > > > >
> > > > > > +struct audit_contid {
> > > > > > +       struct list_head        list;
> > > > > > +       u64                     id;
> > > > > > +       refcount_t              refcount;
> > > > >
> > > > > Hm, since we only ever touch the refcount under a spinlock, I wonder
> > > > > if we could just make it a regular unsigned int (we don't need the
> > > > > atomicity guarantees). OTOH, refcount_t comes with some extra overflow
> > > > > checking, so it's probably better to leave it as is...
> > > >
> > > > Since the update is done using rcu-safe methods, do we even need the
> > > > spin_lock?  Neil?  Paul?
> > >
> > > As discussed, the refcount field is protected against simultaneous
> > > writes by the spinlock that protects additions/removals from the list
> > > as a whole so I don't believe the refcount_t atomicity is critical in
> > > this regard.
> > >
> > > Where it gets tricky, and I can't say I'm 100% confident on my answer
> > > here, is if refcount was a regular int and we wanted to access it
> > > outside of a spinlock (to be clear, it doesn't look like this patch
> > > currently does this).  With RCU, if refcount was a regular int
> > > (unsigned or otherwise), I believe it would be possible for different
> > > threads of execution to potentially see different values of refcount
> > > (assuming one thread was adding/removing from the list).  Using a
> > > refcount_t would protect against this, alternatively, taking the
> > > spinlock should also protect against this.
> >
> > Ok, from the above it isn't clear to me if you are happy with the
> > current code or would prefer any changes, or from below that you still
> > need to work it through to make a pronouncement.  It sounds to me you
> > would be ok with *either* spinlock *or* refcount_t, but don't see the
> > need for both.
> 
> To be fair you didn't ask if I was "happy" with the approach above,
> you asked if we needed the spinlock/refcount_t.  I believe I answered
> that question as comprehensively as I could, but perhaps you wanted a
> hard yes or no?  In that case, since refcount_t is obviously safer, I
> would stick with that for now just to limit the number of possible
> failures.  If someone smarter than you or I comes along and
> definitively says you are 100% safe to use an int, then go ahead and
> use an int.
> 
> Beyond that, I'm still in the process of reviewing your patches, but I
> haven't finished yet, so no "pronouncement" or whatever you want to
> call it.
> 

We definately need the spinlock, as its not meant to protect the refcount
alterations, its meant to protect parallel modifications to the list pointers.
Without the spinlock, the list can become corrupted (protecting the refcount is
just a byproduct).

Because of that byproduct, the atomicity of the refcount isn't required, and so
we could modify it to be an int or some other non-atomic ordinal type, but as I
noted, I don't think thats a good idea.  The refcount type helps denote clearly
what the variable is used for, making it more readable, and given the relative
non-performance critical path that the reference count is read/written in, and
the relatively more expensive locking we are already doing there, I think there
is more value in using the refcount to make the code legible than making
marginally more performant by altering it to be an int type.

Neil

> -- 
> paul moore
> www.paul-moore.com
> 
