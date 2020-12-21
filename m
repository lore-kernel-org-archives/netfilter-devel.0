Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F6DC433DB
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Dec 2020 18:17:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBFFB22D08
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Dec 2020 18:17:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgLUSRc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Dec 2020 13:17:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbgLUSRb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Dec 2020 13:17:31 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A075C0613D3
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Dec 2020 10:16:51 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id o17so25935535lfg.4
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Dec 2020 10:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RDT3CMWkb5v4KlAY6bNjmDFLqwN6ZEiRSV+Z6DSzr0s=;
        b=jrj8LYfQ+G2abRBjq/EQNO52IGqX1ROGqjr73asfsMUx2io1t/Kj5vaWeNRQ05QBws
         7ORYHBk1SfigU2h39+yGI1Lk3AhN50Cgw2pM71/m4zP1hwb+ikD3+K55GDIFL6cu4N9x
         ZXqkVEqq4e9zYCD39Pgl2Yl2UyuINtmv3u1EhVxYVIV2oRUT+oNTfNWmFPJ0oiSuI1AA
         DmducotL7D+1FUZXOZvqHAm9lf7QMa82bUozYx7IzidUTWK7x6Iib27Ho/jYH5ne0Z0S
         Of1Dbmmu0Q124UefwB1rJjBdPSQEFSj36Hggs/J2Zs9T0HFyX0niq795BUINRYC4pEQ5
         L9qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RDT3CMWkb5v4KlAY6bNjmDFLqwN6ZEiRSV+Z6DSzr0s=;
        b=kSgAq9Glyzs1BIroCND3kLCBHyDAl0vjC6ZLil5tRUYhaY0Hw0tMLhCt4NRxB0CyZI
         62QuI0hRZd1/2/aOz9QvFaxMb5I6nWZI49wAeT1eMLtalY7NGR4RLK9NoJnDpIGi61Mq
         1nggmwUp4DRXVWjc/w8iAA41XODzLfAfAUTd2viOGlcQLmIEkDM4VhnjMcA1ioHRVs8G
         8iYyyqbIhP6b3U3KLPrM72h8QrdCL0MiwUC1q+J4OQ/GkK/d0kPE3+bTJUpYe0+UmdmI
         7VMoc8kUXCI8qKrlT5k7oaNLVB74gKMw64Oofc5VqneBNu9Aigdk5JMd+tsnu0hARY+X
         dwjg==
X-Gm-Message-State: AOAM533W1xHadY2GDIjzR7O41wgNMpeJns4y8MtaX+kPjRMlfG9fmJIv
        fPMIhbHaBXsP7sdmv+LUPoDmLNjwZ0eON4ik/QueBsfcMg==
X-Google-Smtp-Source: ABdhPJwPBtlia5uDw63ingozAyc7AR0jROeP8m6nydP3bWYSBIMRH20XUWt+8TeXFSZsv23dBiOY4HZ+Ga0eJQoO4Vg=
X-Received: by 2002:a17:907:d9e:: with SMTP id go30mr15735065ejc.488.1608570889830;
 Mon, 21 Dec 2020 09:14:49 -0800 (PST)
MIME-Version: 1.0
References: <cover.1608225886.git.rgb@redhat.com> <982b9adffbd32264a853fe7f4f06f0d0a882c11d.1608225886.git.rgb@redhat.com>
In-Reply-To: <982b9adffbd32264a853fe7f4f06f0d0a882c11d.1608225886.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 21 Dec 2020 12:14:38 -0500
Message-ID: <CAHC9VhSTuBJ3LXxMY=nD7qBzmKLDjXY0V3hsuN34_siq_xRrig@mail.gmail.com>
Subject: Re: [PATCH ghak90 v10 01/11] audit: collect audit task parameters
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux Containers List <containers@lists.linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        Linux FSdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux NetDev Upstream Mailing List <netdev@vger.kernel.org>,
        Netfilter Devel List <netfilter-devel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Simo Sorce <simo@redhat.com>,
        Eric Paris <eparis@parisplace.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Dec 21, 2020 at 11:57 AM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> The audit-related parameters in struct task_struct should ideally be
> collected together and accessed through a standard audit API and the audit
> structures made opaque to other kernel subsystems.
>
> Collect the existing loginuid, sessionid and audit_context together in a
> new opaque struct audit_task_info called "audit" in struct task_struct.
>
> Use kmem_cache to manage this pool of memory.
> Un-inline audit_free() to be able to always recover that memory.
>
> Please see the upstream github issues
> https://github.com/linux-audit/audit-kernel/issues/81
> https://github.com/linux-audit/audit-kernel/issues/90
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>

Did Neil and Ondrej really ACK/Review the changes that you made here
in v10 or are you just carrying over the ACK/Review?  I'm hopeful it
is the former, because I'm going to be a little upset if it is the
latter.

> ---
>  fs/io-wq.c            |   8 +--
>  fs/io_uring.c         |  16 ++---
>  include/linux/audit.h |  49 +++++---------
>  include/linux/sched.h |   7 +-
>  init/init_task.c      |   3 +-
>  init/main.c           |   2 +
>  kernel/audit.c        | 154 +++++++++++++++++++++++++++++++++++++++++-
>  kernel/audit.h        |   7 ++
>  kernel/auditsc.c      |  24 ++++---
>  kernel/fork.c         |   1 -
>  10 files changed, 205 insertions(+), 66 deletions(-)

-- 
paul moore
www.paul-moore.com
