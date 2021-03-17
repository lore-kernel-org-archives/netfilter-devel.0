Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93193C433DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Mar 2021 18:21:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6006864F41
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Mar 2021 18:21:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbhCQSVW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Mar 2021 14:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232414AbhCQSVI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Mar 2021 14:21:08 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC934C06174A
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Mar 2021 11:21:07 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id z25so4398798lja.3
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Mar 2021 11:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ai/6fO0HOqJACckmU7WW/5qyKFQ17Eky0/nGQp9UxoA=;
        b=S40m+hfUmrqDJ9GakA54kKmQL4FMUyMAf+CfMjPU8RV8RTOYgc7kP2x/8FWsqjh/5B
         sMjoGlRhqu+E8JQ66FuGsO+AIO+TAhml/fqEbUxl3XhzwCi5SYIPBxkuEuF4VVtUPdr3
         EOLBnXRO7p5jtlu0+IkphHtiEKUR1T8syIzNImzDu5RsYRfWHQSUVckR8QjuHnFndmNe
         k2nxSZKB3todnhpTtSIquDDI5bbJeqc78ZV7pWdEP1lNXTjpdLFCpQGv+bksTWQV4Ei0
         uGBG/H9Fz0NSfFkJM4l8O/1dyLtktvvo5NMY+MsIByStvrHwNzPUqhL7lTBH+Ahyx68h
         4XXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ai/6fO0HOqJACckmU7WW/5qyKFQ17Eky0/nGQp9UxoA=;
        b=IzsCbEemqa+MNMgy2VsD3BdnzpFn9kqcy3UatNA47US0lNs3zq+3uDlLYdWILhoibB
         ymuX96ecrhZo0zaBXeojocVE05wLdEgIHsoJ0XRa/SPj2tmU4yvHRUxkvCoilY2SkN5c
         FqxCNsVKACqdcsBJD124c0DR3A3CyRbGf0btJTj9YO7FWZBfS8lmshr3AHZSroAtgJn4
         GGAXTSw5nWmoReOZkSRXG9wTWv2ndJquOPaBjE4qKPbwNfJj+BrYGL+XMLUBJP7S4n92
         DHsVGuV6aerakR6dq8RGGfBHCgodzpv7QSc+pxsTPkAoWF8l+invSz2qaYW16velPYpn
         afZA==
X-Gm-Message-State: AOAM533PuvHF0CgQ6RhFG8tfYQxiW8Yf6YOvDPSxxbA9hnUi6BklwhxV
        9EpomLZ8TX/vLU+QWruomb2D+y/I+7/H0cGeWgDaJ69WuxvbaQ==
X-Google-Smtp-Source: ABdhPJxKohhW1JD5lxVv4Y603AHJf6BNxNOQD4FVVN9z+eiKaLZqb9/xOZD9zUpm7CNQJROnCvQGYdP+kO7AfrVwOgo=
X-Received: by 2002:a2e:5cc7:: with SMTP id q190mr3030023ljb.37.1616005266234;
 Wed, 17 Mar 2021 11:21:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210129212452.45352-1-mikhail.sennikovskii@cloud.ionos.com>
 <20210129212452.45352-4-mikhail.sennikovskii@cloud.ionos.com> <20210315171209.GA24883@salvia>
In-Reply-To: <20210315171209.GA24883@salvia>
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Date:   Wed, 17 Mar 2021 19:20:55 +0100
Message-ID: <CALHVEJb6dH_RdxvbtLaptN=8-g4QUUtd=+R-p2PrfNBep0XkWA@mail.gmail.com>
Subject: Re: [PATCH v3 3/8] conntrack: per-command entries counters
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Mon, 15 Mar 2021 at 18:12, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> Hi Mikhail,
>
> On Fri, Jan 29, 2021 at 10:24:47PM +0100, Mikhail Sennikovsky wrote:
> > As a multicommand support preparation entry counters need
> > to be made per-command as well, e.g. for the case -D and -I
> > can be executed in a single batch, and we want to have separate
> > counters for them.
>
> How do you plan to use the counters? -F provides no stats though.
Those counters are used to print the number of affected entries for
each command "type" executed.
I.e. prior to the "--load-file" support it was only possible to have a
single command for each conntrack tool invocation,
so a global counter used to print the stats message like
"conntrack v1.4.6 (conntrack-tools): 1 flow entries have been created."
was sufficient.

With the --load-file/-R command support it is possible to have
multiple command types
in a single conntrack tool invocation, e.g. both -I and -D commands as
in example below.

echo "-D -w 123
-I -w 123 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state
LISTEN -u SEEN_REPLY -t 50 " | conntrack -R -

The per-command counters functionality added here makes it possible to print
those stats info for each command "type" separately.
So as a result of the above command something the following would be printed:

conntrack v1.4.6 (conntrack-tools): 1 flow entries have been created.
conntrack v1.4.6 (conntrack-tools): 3 flow entries have been deleted.

Following your request to make the changes more granular, I moved this
functionality
to this separate "preparation" commit.

>
> It should be possible to do some pretty print for stats.
>
> There is also the -I and -D cases, which might fail. In that case,
> this should probably stop processing on failure?
Are you talking about error handling processing ct_cmd entries?
The way it is done currently is that each failure would result in
exit_error to happen.
This logic actually stays unchanged.

>
> I sent another round of patches based on your that gets things closer
> to the batch support.
Thanks, I'll have a look into them.

Regards,
Mikhail
