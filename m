Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDB2DC4707F
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 May 2021 20:18:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1747613E1
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 May 2021 20:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhEUUT7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 May 2021 16:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbhEUUTy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 May 2021 16:19:54 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65256C06138C
        for <netfilter-devel@vger.kernel.org>; Fri, 21 May 2021 13:18:29 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id lg14so32198489ejb.9
        for <netfilter-devel@vger.kernel.org>; Fri, 21 May 2021 13:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5nlgh0TQ54JfISjNkuE+6vXCbSzvDn6Db13HObefQGo=;
        b=VXlAiKygqHU4e+y2w1wYEVp8ltO11dQD7mS0i7xMktZsZBOh7IjbrnQlFEHrZgLBPt
         LPPPjKQMK/I6M3Ex7YXV46hB5k15+DVlVHJufjK14ZdmI1A14k2vnsERbsWl1JamCaFB
         BV4HyiVHXHnpCjNocTuao5uTcLbVmP7CWfFvYvYHgys3TZo6Iz/6XstxrABVGgjool74
         2dWU/ilFlcQyXkAXGk9Ta9rB916XDVMw4jU+SiXe/EREXBkEd1W0kq6t4u62HHAJtIbO
         CKMdGPRrSXZNDhkqDJ2Yegsc5YAn3DfPywaDJPGx2psFOqbvrlhyZjzKr66M6y7OF238
         ZVNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5nlgh0TQ54JfISjNkuE+6vXCbSzvDn6Db13HObefQGo=;
        b=UTuinDbsns06hGeTrfPTpEJiGWITSK8RuWpNl/X4cfI5sGBMjJBGAYBsTHYMJxX/gb
         PNJunRDb6lx9UWFOh14Fy4yjtMukNHRYld02dy2St5gXUQuQTdCLbxB+W4BrRLaK3a1S
         si/B2SEESggkryXo993diqpdiaXHtvu7T2zjcRay5eJSfp+4iV94BD+YhKvTvUNlEQNy
         GNwUynVYvO/UZ0P0GXdV04TuY+7ugEtCyz8o++nwvFLOtIzL+AlcIG7R9vQ24eGeSHol
         y97Gk/1GK8sFw1edU9Ojk/htX9p3kkfnT8ZQ/0OCK0xT9I1Q3w7WcyuAN6BgBVs+9ahK
         uN0w==
X-Gm-Message-State: AOAM533I1D8+YZi6QmsP8jLmz9idVVscMR7htNV6QiHt+4+ToZMdUpPl
        vxyVugnlonYHxsR6Ugb340CToWhTAwZyH2giQ6ok
X-Google-Smtp-Source: ABdhPJyuyS2L6lmTp+jUY7WZYbtb0aAruf3WAqiCiM7sDpi5Jow+cezV/k6G8N/8ymdaUuX65MmhhvE9Q5v4Z/UQj8A=
X-Received: by 2002:a17:906:9e21:: with SMTP id fp33mr11995874ejc.488.1621628307963;
 Fri, 21 May 2021 13:18:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210513200807.15910-1-casey@schaufler-ca.com> <20210513200807.15910-9-casey@schaufler-ca.com>
In-Reply-To: <20210513200807.15910-9-casey@schaufler-ca.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 21 May 2021 16:18:16 -0400
Message-ID: <CAHC9VhSZDX3KVzGJQuksDo_mfsg7Qb7Vs+goqbzF9qsF7hRUcg@mail.gmail.com>
Subject: Re: [PATCH v26 08/25] LSM: Use lsmblob in security_secid_to_secctx
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     casey.schaufler@intel.com, James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, keescook@chromium.org,
        john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp,
        Stephen Smalley <sds@tycho.nsa.gov>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, May 13, 2021 at 4:17 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>
> Change security_secid_to_secctx() to take a lsmblob as input
> instead of a u32 secid. It will then call the LSM hooks
> using the lsmblob element allocated for that module. The
> callers have been updated as well. This allows for the
> possibility that more than one module may be called upon
> to translate a secid to a string, as can occur in the
> audit code.
>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-audit@redhat.com
> Cc: netfilter-devel@vger.kernel.org
> To: Pablo Neira Ayuso <pablo@netfilter.org>
> To: Paul Moore <paul@paul-moore.com>
> ---
>  drivers/android/binder.c                | 12 +++++++++-
>  include/linux/security.h                |  5 +++--
>  include/net/scm.h                       |  7 +++++-
>  kernel/audit.c                          | 20 +++++++++++++++--
>  kernel/auditsc.c                        | 28 +++++++++++++++++++----
>  net/ipv4/ip_sockglue.c                  |  4 +++-
>  net/netfilter/nf_conntrack_netlink.c    | 14 ++++++++++--
>  net/netfilter/nf_conntrack_standalone.c |  4 +++-
>  net/netfilter/nfnetlink_queue.c         | 11 +++++++--
>  net/netlabel/netlabel_unlabeled.c       | 30 +++++++++++++++++++++----
>  net/netlabel/netlabel_user.c            |  6 ++---
>  security/security.c                     | 11 +++++----
>  12 files changed, 123 insertions(+), 29 deletions(-)

Acked-by: Paul Moore <paul@paul-moore.com>


--
paul moore
www.paul-moore.com
