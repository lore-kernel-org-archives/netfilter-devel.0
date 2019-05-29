Return-Path: <SRS0=BqdC=T5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76833C28CC1
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 22:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42E1423B17
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 22:17:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="IhDJTlpc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfE2WRW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 May 2019 18:17:22 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35563 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfE2WRV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 May 2019 18:17:21 -0400
Received: by mail-lf1-f66.google.com with SMTP id a25so3382771lfg.2
        for <netfilter-devel@vger.kernel.org>; Wed, 29 May 2019 15:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fIvU+ha0PviU/sibSkvPHyTumVcfp/XuVnG8TGWl1tg=;
        b=IhDJTlpcamR/KqtIXXIXgJdfXAsLI2C+ZEXAuUNYlKWGn6wHjE6fpIPNIeDhT7ycQ8
         57igNJrmJ5BNTBnviUUG/OZd+IF7VgnoVis5ZCCvJxb17ZrBByYBXhXN+ZRYNnc3FRIy
         brSYU1jvKSGa+TNQ8WETswSfhGeqztSbfJ7L/bGXevP+zB/TZdI4CXbRsu2J41G+yDwo
         qMRxFM1D7xND12GCJwbw+whugNAe6MnXELtdl7/PWacMAbHfg0mkPJsrxG4ICI+/4Bgd
         Umpf4FN+xj/KrTwt5uEEEDaa00hFCmx8k3DNIvdAxi+WqGo7sS1kO5oJBoew7DOwAn5i
         7ioA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fIvU+ha0PviU/sibSkvPHyTumVcfp/XuVnG8TGWl1tg=;
        b=ZdotXjPOkOC9R3I+v4Efe7gAae5zNdtUJwVjnCgmaikGSstoXQdZPPUefiqjBBqIm5
         23TULyYufCBEBsXMQAcIv0aq//9RUQTzIzHMEJsy3FT3K+0j4wl3CTD/VwYo069GeskA
         01aYzZKZDh24g8beZ/AgAmzu17+o/vkjYKYtjYP8fdZjnPe4o4Jf2bAMBA12Mpo/RkfK
         t4cA2C/jFIRNHOyf0F4jZ6NEkeo307prY6JtqNtNI0Kg/MERMeF7+Ix0rt0HhVAsTcIn
         bn+AxaRgYZ8QAka1J4sDWHcFDyXF3lPLpXrYzHdjOHWcuTnu0X6WCGSa2V2nnvM1vSsl
         5KAg==
X-Gm-Message-State: APjAAAUORcoo7Ww8BaZSQEy2zMQ5q+AGLgbIeX9X2cyfu7U5L9HDFdUM
        8FzDZDkyuG5TIuSoCmrUbCP/y9vormvheyNRPVb4
X-Google-Smtp-Source: APXvYqyxrQhJxL6YTK1IQrRGp/CVZ4FR/LfHLvH12rSsobg2OWRzTR6O4bHJaXr5UpPyFchEPI025JnE2t3cIS5I/r8=
X-Received: by 2002:a19:c301:: with SMTP id t1mr140375lff.137.1559168239261;
 Wed, 29 May 2019 15:17:19 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1554732921.git.rgb@redhat.com> <423ed5e5c5e4ed7c3e26ac7d2bd7c267aaae777c.1554732921.git.rgb@redhat.com>
In-Reply-To: <423ed5e5c5e4ed7c3e26ac7d2bd7c267aaae777c.1554732921.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 29 May 2019 18:17:08 -0400
Message-ID: <CAHC9VhQ9t-mvJGNCzArjg+MTGNXcZbVrWV4=RUD5ML_bHqua1Q@mail.gmail.com>
Subject: Re: [PATCH ghak90 V6 09/10] audit: add support for containerid to
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

On Mon, Apr 8, 2019 at 11:41 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>
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
> Please see the github audit kernel issue for contid net support:
>   https://github.com/linux-audit/audit-kernel/issues/92
> Please see the github audit testsuiite issue for the test case:
>   https://github.com/linux-audit/audit-testsuite/issues/64
> Please see the github audit wiki for the feature overview:
>   https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> ---
>  include/linux/audit.h | 19 +++++++++++
>  kernel/audit.c        | 88 +++++++++++++++++++++++++++++++++++++++++++++++++--
>  kernel/nsproxy.c      |  4 +++
>  3 files changed, 108 insertions(+), 3 deletions(-)

...

> diff --git a/kernel/audit.c b/kernel/audit.c
> index 6c742da66b32..996213591617 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -376,6 +384,75 @@ static struct sock *audit_get_sk(const struct net *net)
>         return aunet->sk;
>  }
>
> +void audit_netns_contid_add(struct net *net, u64 contid)
> +{
> +       struct audit_net *aunet;
> +       struct list_head *contid_list;
> +       struct audit_contid *cont;
> +
> +       if (!net)
> +               return;
> +       if (!audit_contid_valid(contid))
> +               return;
> +       aunet = net_generic(net, audit_net_id);
> +       if (!aunet)
> +               return;
> +       contid_list = &aunet->contid_list;
> +       spin_lock(&aunet->contid_list_lock);
> +       list_for_each_entry_rcu(cont, contid_list, list)
> +               if (cont->id == contid) {
> +                       refcount_inc(&cont->refcount);
> +                       goto out;
> +               }
> +       cont = kmalloc(sizeof(struct audit_contid), GFP_ATOMIC);
> +       if (cont) {
> +               INIT_LIST_HEAD(&cont->list);

I thought you were going to get rid of this INIT_LIST_HEAD() call?

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
