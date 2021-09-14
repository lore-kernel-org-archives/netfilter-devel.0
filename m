Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64A3EC4321E
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Sep 2021 11:49:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B14E60F12
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Sep 2021 11:49:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbhINLue (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 07:50:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21353 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232617AbhINLuV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 07:50:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631620143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1DzY4yDydre1L5B2hE92LmX2FfdQJaCgioSZB8SSYtw=;
        b=AkeMLwtBFAL+9K8opEoFdzw545ZsgVm7QCGv82UvkTPCnyVRvElyZugs7KZ4KUDX7owKmu
        Q/ZHgHpQSHZn0ULanJCTw4zwW2fWlVlrkPAMIK9afKaq0B5+s1qjl9wVAj0eHTgKf6lQLl
        y++xOgGUCAQo4Xa2R2H2KF+coOZKT/Y=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-55-K3yNzX3hM2a01ip_jJ_Fcw-1; Tue, 14 Sep 2021 07:49:02 -0400
X-MC-Unique: K3yNzX3hM2a01ip_jJ_Fcw-1
Received: by mail-wr1-f72.google.com with SMTP id i16-20020adfded0000000b001572ebd528eso3841432wrn.19
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Sep 2021 04:49:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :user-agent:date:message-id:mime-version:content-transfer-encoding;
        bh=1DzY4yDydre1L5B2hE92LmX2FfdQJaCgioSZB8SSYtw=;
        b=Ly4ZDF01OkadFWSypFcJ2DAG240HOoSOY7aQIfwKkNnpG9J6AFAs1Dk/skcmAYMQoc
         fi2su4RL4oKaYEYCHp5vhmFDFBB3onRRmlNjP+gZvG440d/MPL8LFK0jjFg9yORfuUs6
         yCYC/s0A3b0e2eegUm/2LRTbtb7DrbrXh7G1yGSJ+K3mzEy61Q5qHs509BE2agnAZHZx
         L3UOmb5W0h0eLk7Hyjd5AdXbCFwlcYtgY9StE7MMyTb/hoUeycKJUJBw/XyBu/lG9Eot
         5LcQbHrN8KiReQmd7QwiDmg6MROyKIQVpTX+EIkNgzw5D8HiwInJR79h8zOECaMhPhEu
         XVtQ==
X-Gm-Message-State: AOAM5313DpgiHew2VKEqyJf3n40PCU6WhgjAyjl88FXPlkObjHjWx/6W
        zUz6L4yUctprseuTFZZApCpQUSoc9A9vN+7V4zQ1n+4XLgEodqJEFR8mBp1pTpH0o+M4dVyecX6
        lQtjqtAQWYLtCT+XsWnZMLgXqkejI
X-Received: by 2002:adf:f8d2:: with SMTP id f18mr18121707wrq.140.1631620141482;
        Tue, 14 Sep 2021 04:49:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyYPYZtEfOr6LtyvMv1R6krIJ0atg/3xjfISWNPyUGmY5kEnglZZ0nHKTsL2vx3MJ9nH+HDXA==
X-Received: by 2002:adf:f8d2:: with SMTP id f18mr18121696wrq.140.1631620141286;
        Tue, 14 Sep 2021 04:49:01 -0700 (PDT)
Received: from localhost ([185.112.167.47])
        by smtp.gmail.com with ESMTPSA id n4sm10598269wra.37.2021.09.14.04.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 04:49:00 -0700 (PDT)
From:   =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] iptables-test.py: print with color escapes
 only when stdout isatty
In-Reply-To: <20210914112516.GA26723@orbyte.nwl.cc>
References: <20210902113307.2368834-1-snemec@redhat.com>
 <20210903125250.GK7616@orbyte.nwl.cc>
 <20210903164441+0200.281220-snemec@redhat.com>
 <20210903153420.GM7616@orbyte.nwl.cc>
 <20210906110438+0200.839986-snemec@redhat.com>
 <20210913150533.GA22465@orbyte.nwl.cc>
 <20210914110342+0200.713702-snemec@redhat.com>
 <20210914112516.GA26723@orbyte.nwl.cc>
User-Agent: Notmuch/0.32.3 (https://notmuchmail.org) Emacs/28.0.50
 (x86_64-pc-linux-gnu)
Date:   Tue, 14 Sep 2021 13:49:26 +0200
Message-ID: <20210914134926+0200.802182-snemec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 14 Sep 2021 13:25:16 +0200
Phil Sutter wrote:

> Printing errors to stderr is useful to compare failing tests against an
> expected set of failures - it is simply a task of comparing output on
> stderr with a recorded one.

I see. I'm still not sure the expected convenience factor (avoiding some
grep-like post processing? but couldn't you compare the combined output
just the same?) outweighs the weirdness / least surprise factor (having
two variations of the same diagnostic message split on two separate
output streams).

> To not overcomplicate things, maybe the easiest fix would be to print
> colors only if both stdout and stderr are a tty. What do you think?

Yes, if the split has to stay, I don't have a better suggestion.

Thanks,

  =C5=A0t=C4=9Bp=C3=A1n

