Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F478EE14A9
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 22:37:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234860AbjIFWhD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 18:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbjIFWhD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 18:37:03 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBAA419B5
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 15:36:58 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-58d41109351so20277747b3.1
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Sep 2023 15:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1694039818; x=1694644618; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=osTNmGeIUVyBPZ82IYSEFb6rrk2kTTRl+e5O3Tsb0RY=;
        b=UHOtcsPOZJOZON7oEH1CFDog91w8tgYWMpv6CwWfjL/7VGf0zhrr+T7cgrupfMDNJn
         8+12JP1hIRsBHiNnPbSH3pWc61icp2Fz0pJw7DwXrdESL1FI9SNxWNxsE9ZZJaf8zfmA
         MVQbPDfB+qE7VYEQgJTztnouc4xiShpnsAtPCskmc5OqbcfWrWqFCX96TGBnGRAXhbbl
         N3fY62+PFnAOMRaxIzMvuYtL+jzggXuIwzecpNkg7n85oo3U85VNGukslq2CGdEcDcZT
         EPoZRQ1x1zmc082cT07iMX/GZajYmqreXugSr7CK4Yjb+7PLBHE2aN5Z+SPCsoHQKBlG
         79wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694039818; x=1694644618;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=osTNmGeIUVyBPZ82IYSEFb6rrk2kTTRl+e5O3Tsb0RY=;
        b=Ui9fzd/Ug3vgaQvn61WbLJieuG1bOHRLZwqwHtlf47fqjiyTz8RK2PP0VgVgTyiU3z
         So3Vfv7l04OEnS3qFi6eeJBO+mUEQ6gdb7jq7oGIZCE6SueuLDD0QEh0hF/gvuRmX5pa
         qY5LrJqy4+HxuiB2dnRduLUwibWylHcuuuOQxh1NKCj7Su+JgCGiIU4kag7ftx86MKn+
         NImbDAOQmWTspFiL08XQ5Mq1+iywlscBpZ7Ajl1tSOWSxYozDnjP9wfq8tEfxtyzNNWN
         gL6qeeK1kEl60chGwyvOSJgRN3Gb6SNtRUBaR3jAnVfG9HoPG7HbB1pJiqT/4SQPui8y
         tPUA==
X-Gm-Message-State: AOJu0YxAWr4lFuvF0LAsDF4t1IiXq19FTheR3DAQCdp9Y/5YVsrkU/If
        tpHUL627t3qXW6HqjrzovRYBAqBLHn0eOMCojCnWk3zpHzUCg+U=
X-Google-Smtp-Source: AGHT+IFnbsOI68izs5NIwPeV12TT+ELvvXVQkif/qWc+kAie9scCVe0wntRQjIu1eQEcCUn4UoicoEjCVNHWwZzgSCg=
X-Received: by 2002:a0d:db14:0:b0:595:8499:c5f5 with SMTP id
 d20-20020a0ddb14000000b005958499c5f5mr902274ywe.26.1694039817956; Wed, 06 Sep
 2023 15:36:57 -0700 (PDT)
MIME-Version: 1.0
References: <20230906094202.1712-1-pablo@netfilter.org> <ZPhjYkRpUvfqPB9F@orbyte.nwl.cc>
 <ZPhm1mf0GaeQUr0e@calendula> <ZPiyGC+TfRgyOabJ@orbyte.nwl.cc>
 <ZPjJAicFFam5AFIq@calendula> <CAHC9VhQ0n8Ezef8wYC7uV-MHccqHobYxoB3VYoC9TaGiFm9noQ@mail.gmail.com>
 <ZPjxnSg3/gDy25r0@orbyte.nwl.cc>
In-Reply-To: <ZPjxnSg3/gDy25r0@orbyte.nwl.cc>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 6 Sep 2023 18:36:46 -0400
Message-ID: <CAHC9VhQbKFK+8aAeKiFMznXdZUNcwuy-DU-QtC3mkgar5ZKbUQ@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_tables: Unbreak audit log reset
To:     Phil Sutter <phil@nwl.cc>, Paul Moore <paul@paul-moore.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, audit@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 6, 2023 at 5:39=E2=80=AFPM Phil Sutter <phil@nwl.cc> wrote:
> On Wed, Sep 06, 2023 at 03:56:41PM -0400, Paul Moore wrote:
> > On Wed, Sep 6, 2023 at 2:46=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilt=
er.org> wrote:
> > > On Wed, Sep 06, 2023 at 07:08:40PM +0200, Phil Sutter wrote:
> > > [...]
> > > > The last six come from the 'reset rules table t1' command. While on=
 one
> > > > hand it looks like nftables fits only three rules into a single skb=
,
> > > > your fix seems to have a problem in that it doesn't subtract s_idx =
from
> > > > *idx.
> > >
> > > Please, feel free to follow up to refine, thanks.
> >
> > Forgive me if I'm wrong, but it sounds as though Phil was pointing out
> > a bug and not an area of refinement, is that correct Phil?
>
> From my point of view, yes. Though the third parameter "nentries" to
> audit_log_nfcfg() is sometimes used in rather creative ways,
> nf_tables_dump_obj() for instance passes the handle of the object being
> reset instead of a count. So I assume whoever parses audit logs won't
> rely too much upon the 'entries=3DNNN' part, anyway.
>
> > If it is a bug, please submit a fix for this as soon as possible Pablo.
>
> Thanks for your support, but I can take over, too.

That works too.  The only thing I really care about is making sure the
code is correct and the kernel is behaving the way one would expect.
Who gets it back to that state isn't much of a concern, so long as it
does get fixed ;)

> The number of
> notifications emitted even for a small ruleset is not ideal, also.

Understood.  Let's first make sure that the audit records are correct,
then we can work on improving the frequency.

--=20
paul-moore.com
