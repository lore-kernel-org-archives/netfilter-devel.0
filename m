Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63619C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Dec 2021 18:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240435AbhLQSr3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 13:47:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240434AbhLQSr3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 13:47:29 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02C0C061574
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Dec 2021 10:47:28 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id u22so4777363lju.7
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Dec 2021 10:47:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ns1.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7mX4Mdb+mFd4RFhU7hY+lzyb1a7xeLhSSqE3WaJyYJs=;
        b=b+LU132ZzmERl1cJbLH1He8zUcY+iNo8ZCHPRuR0EA091jcLNviofx0JQef9GLNekg
         Y5SGHegdC9yF14axap288+HHsu7ibREOUvQ045WZ64PmZT6JlKRSZQ8W/dNyN+8fzPhC
         zV81/yUvFb9lXHLSbLoYN/VzCuBb2DJGhNxryVkJcUS4AkQCM4Wt47ovaEwoG6FhdsWB
         NtKrXC7+uObfHqXfn8su7hxn1s+ngF2UzWqeqX1tbgmxFhV5dcQnn0cgMWlwlfjger/g
         ZlRPV5MeCPS+qAZ/ghOUhivy8GDAS8ewUrWEghHVzFKHbwLkoqCtoXH6cr5/HWMplama
         AImw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7mX4Mdb+mFd4RFhU7hY+lzyb1a7xeLhSSqE3WaJyYJs=;
        b=hRx+HL4++g+Is8t8s5QKZhRv05D9ELGjLR0qDgw8O6Gvhj/7d2mV1zxB1vxJjcoDAL
         ri8fGzeajZKxmIFSLasElbJ2llMlvxe6r5esBF1jo1QNVyHj2Mk6Zg+cbvL4rHU5IxKE
         +z2Jdnu+rQ2wu40y6rW/lV3kJlVEnZvX5q6JM8an0DFjMa12vNAMNmTPVjDOik85eBk7
         tEWs3XdfeNHZnzH9oAQDM2onXLO2HeOgHle6JCXKrKviUVqnMvHlsf2lIFpo391F73sL
         ADdGbIssBtN4rJAJzPisvt15+z/UrIIxQOb1I56TZGwMmi16ckpKi+1Sd9VUXKMnLrTl
         DuKA==
X-Gm-Message-State: AOAM532MGexNIc+k2Ufpl4G42gDCz8kGSL1ejQW8ZuW8NmFjmgdz55Im
        Iu6TnfLPKrkANAg0j0i7PH8RLvAJsD+tiSsMGWp7zc+5f5L7UgpW
X-Google-Smtp-Source: ABdhPJwvdYcZSrR3Wk0N9KwkTtf3nYaDXrpv9cG4Nh7tm9WTyk+DaFRy2rnaAJgcwcrRd0Cbea7Ec/0uLoTjs/pGifQ=
X-Received: by 2002:a05:651c:504:: with SMTP id o4mr3941223ljp.242.1639766846975;
 Fri, 17 Dec 2021 10:47:26 -0800 (PST)
MIME-Version: 1.0
References: <20211209163926.25563-1-fw@strlen.de> <CA+PiBLw3aUEd7X3yt5p7D6=-+EdL3EtFxiqSV8FDb5GuuyyxaQ@mail.gmail.com>
 <20211209171152.GA26636@breakpoint.cc> <CA+PiBLzz6Y0_Ok_dKxK-OUneNu5gxOm6_e2049277NroYoWQmA@mail.gmail.com>
In-Reply-To: <CA+PiBLzz6Y0_Ok_dKxK-OUneNu5gxOm6_e2049277NroYoWQmA@mail.gmail.com>
From:   Vitaly Zuevsky <vzuevsky@ns1.com>
Date:   Fri, 17 Dec 2021 18:47:16 +0000
Message-ID: <CA+PiBLze0Qu-AdAeu_0K++HcHaaN+7p383drNyx3y0RdO2FCuA@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: ctnetlink: remove expired entries first
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian

Do you have any news on this?
Meanwhile I cloned the repo git://git.netfilter.org/conntrack-tools,
ran ./autogen.sh to produce configure, and the latter failed with:

checking for rpc/rpc_msg.h... yes
./configure: line 13329: syntax error near unexpected token `LIBTIRPC,'
./configure: line 13329: `  PKG_CHECK_MODULES(LIBTIRPC, libtirpc >= 0.1)'

Interestingly, PKG_CHECK_MODULES was never defined there. Is that
repository for production code - I am confused?

Thank you.

Br Vitaly

On Thu, Dec 9, 2021 at 6:23 PM Vitaly Zuevsky <vzuevsky@ns1.com> wrote:
>
> On Thu, Dec 9, 2021 at 5:11 PM Florian Westphal <fw@strlen.de> wrote:
> > > > --
> > > > 2.32.0
> > > >
> > >
> > > Florian, thanks for prompt turnaround on this. Seeing
> > > conntrack -C
> > > 107530
> > > mandates the check what flows consume this many entries. I cannot do
> > > this if conntrack -L skips anything while kernel defaults to not
> > > exposing conntrack table via /proc. This server is not supposed to NAT
> > > anything by the way.
> >
> > Then this patch doesn't change anything.
> >
> > Maybe 'conntrack -L unconfirmed' or 'conntrack -L dying' show something?
>
> Are you saying that was a patch? v2.32.0? Mind sharing a link for
> downloading the source and/or packaged release?
> I would like to test it just in case, and if no luck, what do i do to
> file it as a bug?
