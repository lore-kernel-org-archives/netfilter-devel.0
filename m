Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20DDAC433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Mar 2021 18:30:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDCA864F4F
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Mar 2021 18:30:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhCQS3a (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Mar 2021 14:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbhCQS3M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Mar 2021 14:29:12 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA124C06174A
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Mar 2021 11:29:11 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id j11so397954lfg.12
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Mar 2021 11:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0b1SQv3NEQ8AQ/Dw7YQwtnBH+o5QIz5jekwYvnM1aoE=;
        b=MteRb/JIlqpYMNLkmncA34F6w2g3AnWLsUFpQLs07nMcDQZv/hZ1+/uNz/AZlinsyF
         8e2HMtSJfLuqdinwMvu7fOmmqYXXlic4RFJW797iW1xuopdUp5hV7efg8/JVrp4askzo
         +jAMLF7fA7RF0Ypq7XQI+A00GygkENDId4RrJfFmc7Pl37N59Unjw+9WCYIw2ULB/A//
         0/CJxqO7bbBuSwEzY0QjZPIq4J0fgvC0/154HS/CnI4iBivvkTeReUUx3qi3qntoMyWc
         4gL/o9jBZR5JR/BOMn9UBbOZbOqxDl5Iw3h2nplb7CaDkPo8uGS7h7o1BHPASVcQ1l0E
         I/Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0b1SQv3NEQ8AQ/Dw7YQwtnBH+o5QIz5jekwYvnM1aoE=;
        b=iBjwlb+oJ3QyTX97CC4i4KLtFlYR1a+kpOoMAQ+GObiMd9rYzA5tD6hrAu20Sfxa+0
         5OjOjvoDbsQqLKnn8dOvXXUvc/sjWOsai+L8WI05z8f/h6vD88Ic3owVT0vdyJ6y3Jt4
         lfh6EZuIzhl9Q3mh/lDEAbWITwtvTf48723sx40bOQHmcdxO7kuFwjNAwjLELu0IcuVH
         f7OEqWWu1uYrPKqafe3J8PLsXE1hyjbXgaFZGFwcSvOnvYUYXUrGRGZdc1itzbrXF9mU
         5Wqkdrl8KLz6VR49//hJjc9a7bKCmZVXW4WXBQPg45RFQDZbY7wnEffAOfZPu5w85b8a
         rjcA==
X-Gm-Message-State: AOAM530HPoP4ynnVpBHL38D3w9pFxzWDaOC6yz9f0GzXQzO1z7FiHicB
        hptLmitTrIV7xyii338I40vD85QpQQ3UyevkNxiBVGS+0gLk4w==
X-Google-Smtp-Source: ABdhPJyK7cKPz5LnPQJEChcP6//sMzCG8IOu5SSCZdeSw63JwSrU3xNu0pahOQTYI/Wx1MCCmj53NzE2HEku3kDRIlw=
X-Received: by 2002:ac2:4d9b:: with SMTP id g27mr3047062lfe.113.1616005750189;
 Wed, 17 Mar 2021 11:29:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210129212452.45352-1-mikhail.sennikovskii@cloud.ionos.com>
 <20210129212452.45352-5-mikhail.sennikovskii@cloud.ionos.com> <20210315171731.GA24971@salvia>
In-Reply-To: <20210315171731.GA24971@salvia>
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Date:   Wed, 17 Mar 2021 19:28:59 +0100
Message-ID: <CALHVEJbgBdW+5M+dxYkbcHU-ML9E444kTPHakSHkqwgFbdrGGg@mail.gmail.com>
Subject: Re: [PATCH v3 4/8] conntrack: introduce ct_cmd_list
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Mon, 15 Mar 2021 at 18:17, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Fri, Jan 29, 2021 at 10:24:48PM +0100, Mikhail Sennikovsky wrote:
> > As a multicommand support preparation, add support for the
> > ct_cmd_list, which represents a list of ct_cmd elements.
> > Currently only a single entry generated from the command line
> > arguments is created.
> >
> > Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
> > ---
> >  src/conntrack.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 66 insertions(+), 3 deletions(-)
> >
> > diff --git a/src/conntrack.c b/src/conntrack.c
> > index 4783825..1719ca9 100644
> > --- a/src/conntrack.c
> > +++ b/src/conntrack.c
> > @@ -598,6 +598,19 @@ static unsigned int addr_valid_flags[ADDR_VALID_FLAGS_MAX] = {
> >       CT_OPT_REPL_SRC | CT_OPT_REPL_DST,
> >  };
> >
> > +#define CT_COMMANDS_LOAD_FILE_ALLOWED ( 0 \
> > +                                             | CT_CREATE       \
> > +                                             | CT_UPDATE_BIT   \
>
> This should CT_UPDATE.
>
> > +                                             | CT_DELETE       \
> > +                                             | CT_FLUSH        \
> > +                                             | EXP_CREATE      \
> > +                                             | EXP_DELETE      \
> > +                                             | EXP_FLUSH       \
>
> Do you need expectations too? The expectation support for the
> conntrack command line tool is limited IIRC.
Actually I do not need expectations, and I agree they can be removed for now.

> I would probably collapse patch 4/8 and 5/8, it should be easy to
> review, it all basically new code to support for the batching mode.
I could squash the 3/ 4/ and 5/8 for sure.
Again the goal was to make the changes more granular and easier for
review, since all these parts are independent.
So the 3/, 4/ and 5/8 are kind of "preparation" commits for the "real"
--load-file functionality.
If you say it's better to squash them, I can surely do it.

Regards,
Mikhail
