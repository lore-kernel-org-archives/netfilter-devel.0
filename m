Return-Path: <SRS0=e21D=3L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B703C33CB6
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jan 2020 21:29:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D090B24673
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jan 2020 21:29:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="IMKvzt5h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbgAVV3b (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Jan 2020 16:29:31 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:33464 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729387AbgAVV31 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Jan 2020 16:29:27 -0500
Received: by mail-lf1-f65.google.com with SMTP id n25so758283lfl.0
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jan 2020 13:29:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f0IkEaXGVt8hUwF5uD44/2Lbilo5B8J7tUK5oD4D1tM=;
        b=IMKvzt5hA/l/NbMQKPL+I7Jyo3nfkoDyZBLi5RRpV+j/tCfVTPajPZF/8GU6ionRxK
         +mQvxp5xyCs/lbcj6fFzQN4Qx1QZwbZnFyqVJt1eXrhrtdv8R8zb6thx4q6gtOe7qdbv
         5E93iQ92ILpO7fxqk7N35pyU4vQtv7jxP2GP0fuciK3ZgZYXrrSxeC+vto4ftrmoX6xE
         BMLerP1Bzr4rimUoCrUubcW9bUpU+oy6tgpr2A1RG4zmzYvb7Ds2n6dNPujUpm52og8K
         3daDlG3WlViN5WCY+t1+i4y8O4eenhXIrO7AMnatPzf7Iv6Jx0Do09fsis7ZX1cIrVTs
         3HLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f0IkEaXGVt8hUwF5uD44/2Lbilo5B8J7tUK5oD4D1tM=;
        b=b9pq8oZ8h8nc+adVXTMwnfIcx63lVWMEjfgfPBdIyCeQ6WCGlsNqAdylO+h5JJOFFU
         k8GlK9wW6P9Y94j5B7o6EORmD5VjD+vBCytXF6GhHXqJEQonDNfTiamcLtplrpP8MSKy
         X/0k+4OPvmO2I/wjyUFp6yFyLPfh/nmOUc/bi8ShnJthHet5dX7SKuhdcohPAZU+RUvM
         kZ1jDpZ+f+zydyCtytgHvmKQLlReAwklIRYVqyS/TYfpWN3ejB2Qul4OfpZ/YaU67inY
         Oc4IgiqgIAWUJjRolcfuHIPH/Ak44W73FfjcY4wun3kXj1gSqACCYWgUM8bRmNWmgmd9
         Qh5Q==
X-Gm-Message-State: APjAAAW/Adxdh/VhW3BpLyeN7u0KviuopT0Uq0FVcNPxu7yl+R6tKqvO
        pkM4PBOt7E53ipMWwzFBDVNnnXG0LZUiQv0MDww4
X-Google-Smtp-Source: APXvYqx6r1SK4hKv8XLYG/rNPUwDn+V7yCGZtcjCRWbKMCH81fFEo/59FQtSCiTTXbrKb1kPr0DggWaePW+geWzK5tI=
X-Received: by 2002:ac2:5f59:: with SMTP id 25mr2754662lfz.193.1579728564136;
 Wed, 22 Jan 2020 13:29:24 -0800 (PST)
MIME-Version: 1.0
References: <cover.1577736799.git.rgb@redhat.com> <6452955c1e038227a5cd169f689f3fd3db27513f.1577736799.git.rgb@redhat.com>
In-Reply-To: <6452955c1e038227a5cd169f689f3fd3db27513f.1577736799.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 22 Jan 2020 16:29:12 -0500
Message-ID: <CAHC9VhRkH=YEjAY6dJJHSp934grHnf=O4RiqLu3U8DzdVQOZkg@mail.gmail.com>
Subject: Re: [PATCH ghak90 V8 13/16] audit: track container nesting
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

On Tue, Dec 31, 2019 at 2:51 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> Track the parent container of a container to be able to filter and
> report nesting.
>
> Now that we have a way to track and check the parent container of a
> container, modify the contid field format to be able to report that
> nesting using a carrat ("^") separator to indicate nesting.  The
> original field format was "contid=<contid>" for task-associated records
> and "contid=<contid>[,<contid>[...]]" for network-namespace-associated
> records.  The new field format is
> "contid=<contid>[^<contid>[...]][,<contid>[...]]".

Let's make sure we always use a comma as a separator, even when
recording the parent information, for example:
"contid=<contid>[,^<contid>[...]][,<contid>[...]]"

> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/linux/audit.h |  1 +
>  kernel/audit.c        | 53 +++++++++++++++++++++++++++++++++++++++++++--------
>  kernel/audit.h        |  1 +
>  kernel/auditfilter.c  | 17 ++++++++++++++++-
>  kernel/auditsc.c      |  2 +-
>  5 files changed, 64 insertions(+), 10 deletions(-)

...

> diff --git a/kernel/audit.c b/kernel/audit.c
> index ef8e07524c46..68be59d1a89b 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c

> @@ -492,6 +493,7 @@ void audit_switch_task_namespaces(struct nsproxy *ns, struct task_struct *p)
>                 audit_netns_contid_add(new->net_ns, contid);
>  }
>
> +void audit_log_contid(struct audit_buffer *ab, u64 contid);

If we need a forward declaration, might as well just move it up near
the top of the file with the rest of the declarations.

> +void audit_log_contid(struct audit_buffer *ab, u64 contid)
> +{
> +       struct audit_contobj *cont = NULL, *prcont = NULL;
> +       int h;

It seems safer to pass the audit container ID object and not the u64.

> +       if (!audit_contid_valid(contid)) {
> +               audit_log_format(ab, "%llu", contid);

Do we really want to print (u64)-1 here?  Since this is a known
invalid number, would "?" be a better choice?

> +               return;
> +       }
> +       h = audit_hash_contid(contid);
> +       rcu_read_lock();
> +       list_for_each_entry_rcu(cont, &audit_contid_hash[h], list)
> +               if (cont->id == contid) {
> +                       prcont = cont;

Why not just pull the code below into the body of this if statement?
It all needs to be done under the RCU read lock anyway and the code
would read much better this way.

> +                       break;
> +               }
> +       if (!prcont) {
> +               audit_log_format(ab, "%llu", contid);
> +               goto out;
> +       }
> +       while (prcont) {
> +               audit_log_format(ab, "%llu", prcont->id);
> +               prcont = prcont->parent;
> +               if (prcont)
> +                       audit_log_format(ab, "^");

In the interest of limiting the number of calls to audit_log_format(),
how about something like the following:

  audit_log_format("%llu", cont);
  iter = cont->parent;
  while (iter) {
    if (iter->parent)
      audit_log_format("^%llu,", iter);
    else
      audit_log_format("^%llu", iter);
    iter = iter->parent;
  }

> +       }
> +out:
> +       rcu_read_unlock();
> +}
> +
>  /*
>   * audit_log_container_id - report container info
>   * @context: task or local context for record

...

> @@ -2705,9 +2741,10 @@ int audit_set_contid(struct task_struct *task, u64 contid)
>         if (!ab)
>                 return rc;
>
> -       audit_log_format(ab,
> -                        "op=set opid=%d contid=%llu old-contid=%llu",
> -                        task_tgid_nr(task), contid, oldcontid);
> +       audit_log_format(ab, "op=set opid=%d contid=", task_tgid_nr(task));
> +       audit_log_contid(ab, contid);
> +       audit_log_format(ab, " old-contid=");
> +       audit_log_contid(ab, oldcontid);

This is an interesting case where contid and old-contid are going to
be largely the same, only the first (current) ID is going to be
different; do we want to duplicate all of those IDs?


>         audit_log_end(ab);
>         return rc;
>  }
> @@ -2723,9 +2760,9 @@ void audit_log_container_drop(void)

--
paul moore
www.paul-moore.com
