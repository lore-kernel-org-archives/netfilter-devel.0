Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91939C433DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 00:51:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65433619CB
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 00:51:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbhCaAvH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Mar 2021 20:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232978AbhCaAug (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Mar 2021 20:50:36 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F8FC061574
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Mar 2021 17:50:36 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id j3so20215381edp.11
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Mar 2021 17:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kl/VN0YgAEhgx4FFK1e1sErce6wVUQp5L+zl5YHWmRs=;
        b=Aq93nxWWXoI+PtP+UXmi6cq6B1Mo5+tsVZddLjswYsmqBnWzY+A4iFt8gN90eQ1SpI
         TYNbAkLLP+X1IyOqeAez1zOziqS1ArscOCfdC4rcvY66zNGZxQAMUNRAkyd1+BW4VqE5
         /+PogSR1ChJBCLIeZzWmQg4SVVisgq3feaAL8bK8IpodM6r40Sr4zfN/7lRRPWi47Epu
         lIviq7hpappEMj06QQPPrHwcndho7SGcutrprEV3o04tvYCg8+pc/HAKFAR6iqYz11Uf
         YbGs2hLmxhwnLXh+isZb1SJDwQCv0Ng2ChAnTPVdNLmSbLvU2ABaPgxmtNeFX+vNQqAU
         etSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kl/VN0YgAEhgx4FFK1e1sErce6wVUQp5L+zl5YHWmRs=;
        b=WTvvCc/rg16XKTNR1PVmBylH6EQywesfv020VWGu9famUQxbYRvnivgA6vzRWOx9ml
         JaLIn5ZcPxP3ykiPxEVN11efCjcBQjH1fJtq1DU/5iWIPK1ojYg0NKX1WVLpF3duusy+
         p53a1wR5YVUrflpDhjOswE3hkOQnCJDIfMY1cYiEgxlTGAawxRw5kHbsMpyXTHJkc6II
         h4n9U/9VdxO7dbCTvNYTfm4cQvhzMycmtK3MyDgDXb4x2/PdQCxAHvuORjKtjfK+9Zq5
         yPmJtRu6Bumj98yJJSA74aop+vSwQL4WjhJEN/VLaJVlCw0eyaJut4ZH/uzGuYqli4bU
         81hg==
X-Gm-Message-State: AOAM533ypLA5Gd+SbMtHI9HAtz3jpAV7vM4TdKU0FYjz6o9IQB9pwXwP
        RZrWfXyZzYsu40W5sr0xyAIAjdmknpEfiUJMLut5
X-Google-Smtp-Source: ABdhPJw9M6RwLo3+aDyMmER1z64Dh4C0RtAwgkcFzscLWBocKqR8IJC3UZALFLB0IrXRowz5dREtEg+3nrdhbxFALbg=
X-Received: by 2002:aa7:db4f:: with SMTP id n15mr646594edt.12.1617151834810;
 Tue, 30 Mar 2021 17:50:34 -0700 (PDT)
MIME-Version: 1.0
References: <28de34275f58b45fd4626a92ccae96b6d2b4e287.1616702731.git.rgb@redhat.com>
 <CAHC9VhRo62vCJL0d_YiKC-Mq9S3P5rNN3yoiF+NBu7oeeeU9rw@mail.gmail.com> <20210330225339.GA14421@salvia>
In-Reply-To: <20210330225339.GA14421@salvia>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 30 Mar 2021 20:50:23 -0400
Message-ID: <CAHC9VhSLQ0+_gE1OKpd5z4wQ3RY2j1dd3VjXFA0UDVieR0BMdQ@mail.gmail.com>
Subject: Re: [PATCH v5] audit: log nftables configuration change events once
 per table
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>,
        Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
        twoerner@redhat.com, tgraf@infradead.org, dan.carpenter@oracle.com,
        Jones Desougi <jones.desougi+netfilter@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Mar 30, 2021 at 6:53 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sun, Mar 28, 2021 at 08:50:45PM -0400, Paul Moore wrote:
> [...]
> > Netfilter folks, were you planning to pull this via your tree/netdev
> > or would you like me to merge this via the audit tree?  If the latter,
> > I would appreciate it if I could get an ACK from one of you; if the
> > former, my ACK is below.
> >
> > Acked-by: Paul Moore <paul@paul-moore.com>
>
> I'll merge this one into nf-next, this might simplify possible
> conflict resolution later on.

Yep, I think that's the best choice.  Thanks.

-- 
paul moore
www.paul-moore.com
