Return-Path: <SRS0=UyK1=SE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76C68C4360F
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:32:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38C202133D
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:32:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="pKc1/7zP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731326AbfDBNcD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Apr 2019 09:32:03 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45746 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731321AbfDBNcD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Apr 2019 09:32:03 -0400
Received: by mail-lj1-f196.google.com with SMTP id y6so11577554ljd.12
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Apr 2019 06:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d3JS4fLEKtdE2GQn7qN6jh6iLL/AcgQhWUFwsn/eE1Q=;
        b=pKc1/7zPn2D6N+NI9MqaYbX0E6At37La/gcvjcT8KLuSszqHEd/zbWV/wfjpbtXoPA
         sYWRTjfbZAlP17dw04TPu69zXi3tpu+ouf1W3s7PvmEZxRmLrQB8XRZFHEfYC/pT2vdz
         uhpx8wnxw1CED4Ov9KcQzidsGN7QaoQs1TzIKOpa52ZcC2VK6Q+gzcajSr5yQrzPZi3K
         B1RvYlyzT47Ie4Lg+s9EAB5ys1dCCHkmCy/rh0OkpeUaccxw6QEAr5a7ItMshyKHj3hK
         CWp/DFfgIdCQgG73RybHqfffmCEU0ktleLNc2k6GiL6hLYzSlWZtTC4kwEzz3DnlV4TM
         rR1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d3JS4fLEKtdE2GQn7qN6jh6iLL/AcgQhWUFwsn/eE1Q=;
        b=UPd6iPo2pTz4TO8pkD71A9aAZrXeeEyHnibGZWLAsXgFDLkyyYwclGukI7YNB9it+g
         rWafpLtx3L0pVlyYg2N/lrrdIVVflYxnkXuUgIJhy8KaxJGZGyB37igCiO7knianYFfW
         993GNwaQLSaoUj6be5/E/lusjdpGeYSexXkbZcsHYGaRr9xBPcaeD5qjjZ4SQKJC9Wvf
         leMTwH9fzpdn39/mrwafhnver9V+aBUw7AH50TLJJiFC9XjerRP1UdwwA5n3gPf2Dce+
         pivexkd82G1Ijr73zLcSkxI8rG/vV0pv+OAOso9skpa/kXBKD9i7B3n8DhraQrM/MeLF
         nhAw==
X-Gm-Message-State: APjAAAWYrdFRS+faADyZ4TWGumA6MXloUg2t+rn/V1u2EsssCLVapjKK
        alzzkmOGFzUzLYSpwW9VI56qujLYKcI1e9aQFAsT
X-Google-Smtp-Source: APXvYqzBvTSsn/QRxi9I/GDLeRZIJkZXswr8R3qt0Fbcvyh8wUEdePgO1NWzkN5A+hzeWf0G0aRl0BasXk4aA7nGsms=
X-Received: by 2002:a2e:8508:: with SMTP id j8mr5227052lji.26.1554211920782;
 Tue, 02 Apr 2019 06:32:00 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1552665316.git.rgb@redhat.com> <27473c84a274c64871cfa8e3636deaf05603c978.1552665316.git.rgb@redhat.com>
 <CAHC9VhQpk6cFZckQH+LQmQmirVzLm_GH57ZD3-76y-59G=DocQ@mail.gmail.com> <20190402113150.GA17593@hmswarspite.think-freely.org>
In-Reply-To: <20190402113150.GA17593@hmswarspite.think-freely.org>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 2 Apr 2019 09:31:49 -0400
Message-ID: <CAHC9VhRW86NamkX9FcsHEYg_DJehCCAnANUqB8+gv=dxpBkd6w@mail.gmail.com>
Subject: Re: [PATCH ghak90 V5 09/10] audit: add support for containerid to
 network namespaces
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 2, 2019 at 7:32 AM Neil Horman <nhorman@tuxdriver.com> wrote:
> On Mon, Apr 01, 2019 at 10:50:03AM -0400, Paul Moore wrote:
> > On Fri, Mar 15, 2019 at 2:35 PM Richard Guy Briggs <rgb@redhat.com> wrote:
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
> >
> > ...
> >
> > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > index cf448599ef34..7fa3194f5342 100644
> > > --- a/kernel/audit.c
> > > +++ b/kernel/audit.c
> > > @@ -72,6 +72,7 @@
> > >  #include <linux/freezer.h>
> > >  #include <linux/pid_namespace.h>
> > >  #include <net/netns/generic.h>
> > > +#include <net/net_namespace.h>
> > >
> > >  #include "audit.h"
> > >
> > > @@ -99,9 +100,13 @@
> > >  /**
> > >   * struct audit_net - audit private network namespace data
> > >   * @sk: communication socket
> > > + * @contid_list: audit container identifier list
> > > + * @contid_list_lock audit container identifier list lock
> > >   */
> > >  struct audit_net {
> > >         struct sock *sk;
> > > +       struct list_head contid_list;
> > > +       spinlock_t contid_list_lock;
> > >  };
> > >
> > >  /**
> > > @@ -275,8 +280,11 @@ struct audit_task_info init_struct_audit = {
> > >  void audit_free(struct task_struct *tsk)
> > >  {
> > >         struct audit_task_info *info = tsk->audit;
> > > +       struct nsproxy *ns = tsk->nsproxy;
> > >
> > >         audit_free_syscall(tsk);
> > > +       if (ns)
> > > +               audit_netns_contid_del(ns->net_ns, audit_get_contid(tsk));
> > >         /* Freeing the audit_task_info struct must be performed after
> > >          * audit_log_exit() due to need for loginuid and sessionid.
> > >          */
> > > @@ -376,6 +384,73 @@ static struct sock *audit_get_sk(const struct net *net)
> > >         return aunet->sk;
> > >  }
> > >
> > > +void audit_netns_contid_add(struct net *net, u64 contid)
> > > +{
> > > +       struct audit_net *aunet = net_generic(net, audit_net_id);
> > > +       struct list_head *contid_list = &aunet->contid_list;
> > > +       struct audit_contid *cont;
> > > +
> > > +       if (!audit_contid_valid(contid))
> > > +               return;
> > > +       if (!aunet)
> > > +               return;
> >
> > We should move the contid_list assignment below this check, or decide
> > that aunet is always going to valid (?) and get rid of this check
> > completely.
> >
> I'm not sure why that would be needed.  Finding the net_id list is an operation
> of a map relating net namespaces to lists, not contids to lists.  We could do
> it, sure, but since they're unrelated operations, I don't think we experience
> any slowdowns from doing it this way.

In the first line of the function, when aunet is declared, it is also
assigned a value using net_generic():

  struct audit_net *aunet = net_generic(net, audit_net_id);

Later in the function there is check to see if aunet is NULL, yet on
the second line of the function (before the NULL check), there is this
line of code:

  struct list_head *contid_list = &aunet->contid_list;

... which could result in the dereference of a NULL pointer if aunet
is NULL.  My suggestion was either to move this assignment below the
aunet-NULL check or decide that aunet was always going to be valid
(e.g. non-NULL) and do away with the aunet-NULL check completely.
Richard has since replied that the aunet-NULL check has been
demonstrated to be necessary so the proper thing to do would be to
move the assignment.  I believe that is what Richard is planning on
doing.

> > > +       if (cont) {
> > > +               INIT_LIST_HEAD(&cont->list);
> >
> > Unless there is some guidance that INIT_LIST_HEAD() should be used
> > regardless, you shouldn't need to call this here since list_add_rcu()
> > will take care of any list.h related initialization.
>
> There is a corner case that needs it.  list_add_rcu has a check that gets
> called, __list_add_valid.  Its a noop in the regular case, but if
> CONFIG_DEBUG_LIST is defined, its a check to ensure that the next and prev
> pointers getting passed in aren't set to detectable corrupt values.  If we pass
> in garbage, we can get transient false positives on that check, so we need to
> set the list pointers to known good values before hand, either by using kzalloc,
> or INIT_LIST_HEAD, as has been done here.  Given that we expressly set every
> field of this structure, I think this is the right approach, as it uses the list
> macro to expressly set the list values to their proper state.

Good to know, thanks.

-- 
paul moore
www.paul-moore.com
