Return-Path: <SRS0=Hnfl=SH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E71B1C4360F
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Apr 2019 02:06:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8ACF52171F
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Apr 2019 02:06:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="H+EapgdZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729641AbfDECGZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Apr 2019 22:06:25 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41943 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728721AbfDECGY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Apr 2019 22:06:24 -0400
Received: by mail-lj1-f193.google.com with SMTP id k8so3798330lja.8
        for <netfilter-devel@vger.kernel.org>; Thu, 04 Apr 2019 19:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i0SVqH/6Kj1962AGBZkuoEdnZ7+ADTw/XymJ0q2hSFA=;
        b=H+EapgdZSZCqlG3kN0Iq1MJhAeBXcbDqnFBx7q55rD4K3WrpLrFwBtIqI2q9Ubuwzu
         ugZd4giYCA0dRsnriQYGjnpRPjMoMt1d0R0WwQ8XaY9kyGJarhl/iGSa3pvZMu5T6KS+
         ROXknsNRefhDEelGjOhvriMhw3ttCiZghJp7yuGel2dAgyYzHFcORnGH8WfcCQ+sEqdi
         Mwx0pYwGOUzv4ioYomUM+J4cSpmI+WVj96bS+kKJ2C/S9hUGCXbs9aSXYSv+G54zeuua
         GpVwMZ1eisfTvvyHNiCVxhwJYC3w+v5Iv0iTun53uqUafP/U6Ea+jf12EgZN1MSkGZVG
         hYkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i0SVqH/6Kj1962AGBZkuoEdnZ7+ADTw/XymJ0q2hSFA=;
        b=L6TX/MaLrHT+hAHa8iN/dM0r+5uVEczWqETmHm3rb0gvyf5TI8HZ7/YZAuecVtbyBE
         hNqC4Iz8Exb58w4QPy2or3jnK9EF4hxAnBWhpzj1Jsl0Ihu6CLLMeAvsGqtsDwotr1zQ
         l0KLi0NgLjdloNL2HjlKuffq36ppZMSCEdEotjzCjhW4ocPzIHVvGtlV0YAApz1Yon+c
         WNhoHGHWoPrZtL2iZBMlXjeSXR+MCASwWGr99QD/kERkhoAeABaDJGmKUplGsR012NbP
         JK9ZLOa0RTMmU1U1MBRVACdOmkKV82ZblOCXfJFkMashABDRQd0OpRUoxKZ27yUCFjD4
         iv7Q==
X-Gm-Message-State: APjAAAWHdthvTnBf0+2sD8ZnmnVY7EqpScE97/W69HT5QBCXQK54EQ23
        yUsV9jBw348386W3oxVufJnCHym/u8mYqksmZ68q
X-Google-Smtp-Source: APXvYqz1tmQ6IcFe3o4dwAvOVFLhNmdAmOTtRiltlBZUAtr14Q4HJPLUStR7tkdUCsbPmWZ0EBI0cBxSj9FeWT3NB8g=
X-Received: by 2002:a05:651c:114:: with SMTP id a20mr5199822ljb.53.1554429982109;
 Thu, 04 Apr 2019 19:06:22 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1552665316.git.rgb@redhat.com> <27473c84a274c64871cfa8e3636deaf05603c978.1552665316.git.rgb@redhat.com>
 <CAHC9VhQpk6cFZckQH+LQmQmirVzLm_GH57ZD3-76y-59G=DocQ@mail.gmail.com>
 <20190402113150.GA17593@hmswarspite.think-freely.org> <20190404214006.jcgmjb4u6iobu42s@madcap2.tricolour.ca>
In-Reply-To: <20190404214006.jcgmjb4u6iobu42s@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 4 Apr 2019 22:06:10 -0400
Message-ID: <CAHC9VhSf_7RH96dNhVhifs3uqEZf0Uq=Qi5TgqdVtUskiqYQ4Q@mail.gmail.com>
Subject: Re: [PATCH ghak90 V5 09/10] audit: add support for containerid to
 network namespaces
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Neil Horman <nhorman@tuxdriver.com>, linux-api@vger.kernel.org,
        containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Apr 4, 2019 at 5:40 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2019-04-02 07:31, Neil Horman wrote:
> > On Mon, Apr 01, 2019 at 10:50:03AM -0400, Paul Moore wrote:
> > > On Fri, Mar 15, 2019 at 2:35 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > Audit events could happen in a network namespace outside of a task
> > > > context due to packets received from the net that trigger an auditing
> > > > rule prior to being associated with a running task.  The network
> > > > namespace could be in use by multiple containers by association to the
> > > > tasks in that network namespace.  We still want a way to attribute
> > > > these events to any potential containers.  Keep a list per network
> > > > namespace to track these audit container identifiiers.
> > > >
> > > > Add/increment the audit container identifier on:
> > > > - initial setting of the audit container identifier via /proc
> > > > - clone/fork call that inherits an audit container identifier
> > > > - unshare call that inherits an audit container identifier
> > > > - setns call that inherits an audit container identifier
> > > > Delete/decrement the audit container identifier on:
> > > > - an inherited audit container identifier dropped when child set
> > > > - process exit
> > > > - unshare call that drops a net namespace
> > > > - setns call that drops a net namespace
> > > >
> > > > See: https://github.com/linux-audit/audit-kernel/issues/92
> > > > See: https://github.com/linux-audit/audit-testsuite/issues/64
> > > > See: https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> > > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > > ---
> > > >  include/linux/audit.h | 19 ++++++++++++
> > > >  kernel/audit.c        | 86 +++++++++++++++++++++++++++++++++++++++++++++++++--
> > > >  kernel/nsproxy.c      |  4 +++
> > > >  3 files changed, 106 insertions(+), 3 deletions(-)

...

> > > > +               list_for_each_entry_rcu(cont, contid_list, list)
> > > > +                       if (cont->id == contid) {
> > > > +                               refcount_inc(&cont->refcount);
> > > > +                               goto out;
> > > > +                       }
> > > > +       cont = kmalloc(sizeof(struct audit_contid), GFP_ATOMIC);
> > >
> > > If you had to guess, what do you think is going to be more common:
> > > bumping the refcount of an existing entry in the list, or adding a new
> > > entry?  I'm asking because I always get a little nervous when doing
> > > allocations while holding a spinlock.  Yes, you are doing it with
> > > GFP_ATOMIC, but it still seems like something to try and avoid if this
> > > is going to approach 50%.  However, if the new entry is rare then the
> > > extra work of always doing the allocation before taking the lock and
> > > then freeing it afterwards might be a bad tradeoff.
> > >
> > I think this is another way of asking, will multiple processes exist in the same
> > network namespace?  That is to say, will we expect a process to create a net
> > namespace, and then have other processes enter that namespace (thereby
> > triggering multiple calls to audit_netns_contid_add with the same net pointer
> > and cont id).  Given that the kubernetes notion of a pod is almost by definition
> > multiple containers sharing a network namespace, I think the answer is that we
> > will be strongly biased towards the refcount_inc case, rather than the kmalloc
> > case.  I could be wrong, but I think this is likely already in the optimized
> > order.
>
> I had a stab at doing a GFP_KERNEL alloc before the spinlock and releasing it
> after if it wasn't needed (in Patch#1 below).  I also went one step further and
> converted it to kmem_cache (in Patch#2 below).
>
> > > My gut feeling says we might do about as many allocations as refcount
> > > bumps, but I could be thinking about this wrong.
> > >
> > > Moving the allocation outside the spinlock might also open the door to
> > > doing this as GFP_KERNEL, which is a good thing, but I haven't looked
> > > at the callers to see if that is possible (it may not be).  That's an
> > > exercise left to the patch author (if he hasn't done that already).
>
> Both appear to work, but after successfully running both the contid test and
> audit_testsuite, once I start to push that test system a bit harder I end up
> with a deadlock warning.
>
> I am having trouble understanding why since it happens both without and with
> the kmem_cache options, so it must be another part of the code that is
> triggering it.  The task_lock is being held at this point in
> audit_set_contid().  I haven't tried changing this alloc over to a GFP_ATOMIC
> to see if that prevents it, just as a debugging check...
> At this point, I'm inclined to leave it as it was without these two patches
> since it works and there doesn't seem to be an obvious best way given the
> uncertainty of the potential workloads.

I'm definitely not a mm expert, but I wonder if you might be able to
get this working using GFP_NOFS, but I see just now that they
recommend you *not* use GFP_NOFS; even if this did solve the problem,
it's probably not the right approach.

I'm okay with leaving it as-is with GFP_ATOMIC.  My original response
to this was more of a question about optimizing for a given use case,
having something that works is far more important.

-- 
paul moore
www.paul-moore.com
