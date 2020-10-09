Return-Path: <SRS0=CfkY=DQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35438C4363D
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Oct 2020 20:02:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5A452225B
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Oct 2020 20:02:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=arista.com header.i=@arista.com header.b="RRUTeULR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388404AbgJIUCw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Oct 2020 16:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388614AbgJIUAd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Oct 2020 16:00:33 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E879AC0613D8
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Oct 2020 13:00:32 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id j3so5337814qvi.7
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Oct 2020 13:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2qC/FqQbzG5/8jBosr6Y+NLl7/pG/587C+U8/pqT5iw=;
        b=RRUTeULREpVOpNCQWXgAIZtaaHU8E5Qq14J1066Xjyg4JyW+HUwF9cBse1Bm1R4yvF
         odnAPK0J/+XH5En6zvKFETGOP1FMbcrshZcR4wRbd0JMtk2CJfn9aGg5UNteTQysd1FJ
         S3euxOGxf2xPj1vwUUU2L+IztRLTks0tkt1bWKWHHOCklQliwV5W67dfYAWKVunbtxfi
         j28syp4AXrV/3kw8gQNOTUgNLA6WjIhFU6TNExHEV6kET3+rFz5mYpN+8kd7pWnBwVoS
         zMXfZjguwobHwKpMm5I/i8fOhAeRaU4YfcBNFouYTO3atevtpgWq6lDkTu7XR39ArfeS
         YDWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2qC/FqQbzG5/8jBosr6Y+NLl7/pG/587C+U8/pqT5iw=;
        b=A7UgEC3vx+jhtpW4ojAXRO4itCCXUDNy1VOiVxxOC+0IHKQNcTGFG8AMrelICTCMBc
         RP6vtXTHWx0CCvNwahUviMtURwfw1mQVl88u/jdlZrIwL0TdxCENwMoBVKt98tMDssJu
         uosrSI1wd4bR/hrajzZRqp5BhuoMNQn06PTVLMKcwkulCVIsVIPAev2hlQWGVbD5kfhf
         lTlRDLuX7b215gC647aFURvCYP5M+E1X+akjSknHAQ6LycydD0oiVU1WxPXSogmUsrkt
         SFO+h9N2UsPv+f8ZLEyiuwgGf5Ba2I3pPoO8zih2zZ765r/TX46Qh1HAvsn3z5raZdUA
         QY3g==
X-Gm-Message-State: AOAM530xWahlFE78TT4z2BVYfK+PWrrCcRuZXDs2kk0N6DkW0vabV3KN
        U5TGcpms5vnxUJTOxbC48MfGN9mpABcjBDGKBM4kDg==
X-Google-Smtp-Source: ABdhPJyt2PbWXX+6xs5+udRRLnk5TTa8q6pvQu2pHMe06wvrZ9hObKg6j7VG+fDE+ZYoNUjjCw7tnImmctdGVpBBmmQ=
X-Received: by 2002:a0c:9a4e:: with SMTP id q14mr14190214qvd.22.1602273632019;
 Fri, 09 Oct 2020 13:00:32 -0700 (PDT)
MIME-Version: 1.0
References: <20201007193252.7009D95C169C@us180.sjc.aristanetworks.com>
 <CA+HUmGhBxBHU85oFfvoAyP=hG17DG2kgO67eawk1aXmSjehOWQ@mail.gmail.com>
 <alpine.DEB.2.23.453.2010090838430.19307@blackhole.kfki.hu>
 <20201009110323.GC5723@breakpoint.cc> <alpine.DEB.2.23.453.2010092035550.19307@blackhole.kfki.hu>
 <20201009185552.GF5723@breakpoint.cc> <alpine.DEB.2.23.453.2010092132220.19307@blackhole.kfki.hu>
In-Reply-To: <alpine.DEB.2.23.453.2010092132220.19307@blackhole.kfki.hu>
From:   Francesco Ruggeri <fruggeri@arista.com>
Date:   Fri, 9 Oct 2020 13:00:21 -0700
Message-ID: <CA+HUmGidgRqPmgCH=g7+H9g+TZAyh1-2y4qfzfZB3DYtHtjdKA@mail.gmail.com>
Subject: Re: [PATCH nf v2] netfilter: conntrack: connection timeout after re-register
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Oct 9, 2020 at 12:49 PM Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> What is the rationale behind "remove the conntrack hooks when there are no
> rule left referring to conntrack"? Performance optimization?

That seems to be the case. See commit 4d3a57f23dec ("netfilter: conntrack:
do not enable connection tracking unless needed").

Francesco
