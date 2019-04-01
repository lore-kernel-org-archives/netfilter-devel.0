Return-Path: <SRS0=mHk2=SD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 838D4C43381
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Apr 2019 14:50:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48F9A20856
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Apr 2019 14:50:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="GxX7flHy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbfDAOuS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Apr 2019 10:50:18 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:38863 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728641AbfDAOuR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Apr 2019 10:50:17 -0400
Received: by mail-lf1-f67.google.com with SMTP id a6so6524489lfl.5
        for <netfilter-devel@vger.kernel.org>; Mon, 01 Apr 2019 07:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C8yzsIqBBR4fXo9IZnoq+QYSJwLKkb1BMOVkzyPusUw=;
        b=GxX7flHyn5fSE/tWWrG4laQKKUZ+RDWqx1HGNTsuitAGp+ushI1Y0OB9VDcP9ORsgB
         d5l+3K2DYP56cwJaGHpH1pOMMnPb6g5elX99VYNcgBMq61HBw66ZCBl+/1Grt57AEM11
         oR0+UwFH8yYq5QR809Os2jM7SCvugvA7zMJen1q6I5NeT+Uay7T82gPr7qiWCFxSzG1D
         Gi8hdShqogwNfwnl1UzUe6oV82+W02YbINddx1UrZIvB9Hgy4/9M2nOXP6dp0GLqg11V
         r2Aq/SzYe/Kbjuwkei0XqsHpseJZGpEoAL+OpoNVAmn7Q/SjoslCHu8St5EwzVLxHuUt
         Pm1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C8yzsIqBBR4fXo9IZnoq+QYSJwLKkb1BMOVkzyPusUw=;
        b=MoVq5PoCovZsyvpm3NrChq6/X0jt+MRTHlBxpe+PEEdPSAwV3Hpc/38wReBx4Lrixl
         80bHiSPu05zgGOjwyZ4IYYDDHIj8Rj8BJK3gXM1wqqEEGMrVq5VNNTtzjrFlFlz9gXT4
         pxuGfLpEcOOltFMzXTJjoT6evxd9jnocm6CkdNg2eaJ96ADr2hRPjiVSd7WxETnddori
         ETDUC+04hkjIIfyHkPCuHOJiRrW3ddcXPpqXfmlCXiyUbTqSW9TQGTJEY6Zg1h7wLR55
         iJPAyCf8AdozYrzreq+blCxBLiN9pdCDw3OajVspYjNJH9h6EL+MWRBwumLLfMFmkZod
         L3pQ==
X-Gm-Message-State: APjAAAVgNFsj530A5i/x4u9uvRElpeX5n3IAjPjtS51aBTehHs2hQW92
        vDekbMWXCcJyJjGCOzkR/bXu49OFf92P3W/6Iwyk
X-Google-Smtp-Source: APXvYqy/4DJZgsE4k/6k2ZfPXAQIYfbpgunfTeHqf+2qQIwzkmlDcYt1W7p/Pvqce8XAGTsphQdRyO2gVnmqo91mn2U=
X-Received: by 2002:ac2:5205:: with SMTP id a5mr9071316lfl.102.1554130214951;
 Mon, 01 Apr 2019 07:50:14 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1552665316.git.rgb@redhat.com> <27473c84a274c64871cfa8e3636deaf05603c978.1552665316.git.rgb@redhat.com>
In-Reply-To: <27473c84a274c64871cfa8e3636deaf05603c978.1552665316.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 1 Apr 2019 10:50:03 -0400
Message-ID: <CAHC9VhQpk6cFZckQH+LQmQmirVzLm_GH57ZD3-76y-59G=DocQ@mail.gmail.com>
Subject: Re: [PATCH ghak90 V5 09/10] audit: add support for containerid to
 network namespaces
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

On Fri, Mar 15, 2019 at 2:35 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> Audit events could happen in a network namespace outside of a task
> context due to packets received from the net that trigger an auditing
> rule prior to being associated with a running task.  The network
> namespace could be in use by multiple containers by association to the
> tasks in that network namespace.  We still want a way to attribute
> these events to any potential containers.  Keep a list per network
> namespace to track these audit container identifiiers.
>
> Add/increment the audit container identifier on:
> - initial setting of the audit container identifier via /proc
> - clone/fork call that inherits an audit container identifier
> - unshare call that inherits an audit container identifier
> - setns call that inherits an audit container identifier
> Delete/decrement the audit container identifier on:
> - an inherited audit container identifier dropped when child set
> - process exit
> - unshare call that drops a net namespace
> - setns call that drops a net namespace
>
> See: https://github.com/linux-audit/audit-kernel/issues/92
> See: https://github.com/linux-audit/audit-testsuite/issues/64
> See: https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/linux/audit.h | 19 ++++++++++++
>  kernel/audit.c        | 86 +++++++++++++++++++++++++++++++++++++++++++++++++--
>  kernel/nsproxy.c      |  4 +++
>  3 files changed, 106 insertions(+), 3 deletions(-)

...

> diff --git a/kernel/audit.c b/kernel/audit.c
> index cf448599ef34..7fa3194f5342 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -72,6 +72,7 @@
>  #include <linux/freezer.h>
>  #include <linux/pid_namespace.h>
>  #include <net/netns/generic.h>
> +#include <net/net_namespace.h>
>
>  #include "audit.h"
>
> @@ -99,9 +100,13 @@
>  /**
>   * struct audit_net - audit private network namespace data
>   * @sk: communication socket
> + * @contid_list: audit container identifier list
> + * @contid_list_lock audit container identifier list lock
>   */
>  struct audit_net {
>         struct sock *sk;
> +       struct list_head contid_list;
> +       spinlock_t contid_list_lock;
>  };
>
>  /**
> @@ -275,8 +280,11 @@ struct audit_task_info init_struct_audit = {
>  void audit_free(struct task_struct *tsk)
>  {
>         struct audit_task_info *info = tsk->audit;
> +       struct nsproxy *ns = tsk->nsproxy;
>
>         audit_free_syscall(tsk);
> +       if (ns)
> +               audit_netns_contid_del(ns->net_ns, audit_get_contid(tsk));
>         /* Freeing the audit_task_info struct must be performed after
>          * audit_log_exit() due to need for loginuid and sessionid.
>          */
> @@ -376,6 +384,73 @@ static struct sock *audit_get_sk(const struct net *net)
>         return aunet->sk;
>  }
>
> +void audit_netns_contid_add(struct net *net, u64 contid)
> +{
> +       struct audit_net *aunet = net_generic(net, audit_net_id);
> +       struct list_head *contid_list = &aunet->contid_list;
> +       struct audit_contid *cont;
> +
> +       if (!audit_contid_valid(contid))
> +               return;
> +       if (!aunet)
> +               return;

We should move the contid_list assignment below this check, or decide
that aunet is always going to valid (?) and get rid of this check
completely.

> +       spin_lock(&aunet->contid_list_lock);
> +       if (!list_empty(contid_list))

We don't need the list_empty() check here do we?  I think we can just
call list_for_each_entry_rcu(), yes?

> +               list_for_each_entry_rcu(cont, contid_list, list)
> +                       if (cont->id == contid) {
> +                               refcount_inc(&cont->refcount);
> +                               goto out;
> +                       }
> +       cont = kmalloc(sizeof(struct audit_contid), GFP_ATOMIC);

If you had to guess, what do you think is going to be more common:
bumping the refcount of an existing entry in the list, or adding a new
entry?  I'm asking because I always get a little nervous when doing
allocations while holding a spinlock.  Yes, you are doing it with
GFP_ATOMIC, but it still seems like something to try and avoid if this
is going to approach 50%.  However, if the new entry is rare then the
extra work of always doing the allocation before taking the lock and
then freeing it afterwards might be a bad tradeoff.

My gut feeling says we might do about as many allocations as refcount
bumps, but I could be thinking about this wrong.

Moving the allocation outside the spinlock might also open the door to
doing this as GFP_KERNEL, which is a good thing, but I haven't looked
at the callers to see if that is possible (it may not be).  That's an
exercise left to the patch author (if he hasn't done that already).

> +       if (cont) {
> +               INIT_LIST_HEAD(&cont->list);

Unless there is some guidance that INIT_LIST_HEAD() should be used
regardless, you shouldn't need to call this here since list_add_rcu()
will take care of any list.h related initialization.

> +               cont->id = contid;
> +               refcount_set(&cont->refcount, 1);
> +               list_add_rcu(&cont->list, contid_list);
> +       }
> +out:
> +       spin_unlock(&aunet->contid_list_lock);
> +}

-- 
paul moore
www.paul-moore.com
