Return-Path: <SRS0=ANAP=CK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	HK_RANDOM_FROM,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C143C433E7
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Sep 2020 17:29:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 147A120866
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Sep 2020 17:29:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jAYS2ZZc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731298AbgIAR3v (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Sep 2020 13:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728739AbgIAR3n (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Sep 2020 13:29:43 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6EBC061247
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Sep 2020 10:29:42 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id d19so1032576pgl.10
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Sep 2020 10:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FW5La7opiv4KWG16c7XYpf3DTcgrj7Pdfd83aUNKNrc=;
        b=jAYS2ZZc79qZYnTsWwjv1SadjMN4RsSUm73yL30/GRwcwxgx4b2Nzm1acr8EpXHU9A
         boOwDj4V+fB5mPRPo+Bphq2QhUwtv9CGHRTG0Mst/tBdwp4NX2vO6i7ag2MSCNrd/HIi
         AZQ+fBRYvWGIFiYzyOdjiuLJEwGDoPjfTasrm4iP6Bxhunex1Odsdg877c+L2oeUIjyl
         BvD61dtjU9PXUL0yTB3RKH36Q/pHpRkVTcfkriR5wU0n1ydpyKxsMdyKoKf2KiK0Wrgh
         jFGMvRTtmQI4gSn4b684qUrpZw/MICxUnYbOWXjmbDcERxcrngcctPQze1oDKK2bpbTD
         aFyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FW5La7opiv4KWG16c7XYpf3DTcgrj7Pdfd83aUNKNrc=;
        b=gYVjLg0+uHNqRAkqVI153jGr6ec0MT0WLdmfKCnB9QgMpur5AGh7r3fzJ3ftv28vlv
         vDPgimO13n4NsWgcQkis/3eessHKutBZjfK8miWG38hjY/St8dBeIkddm+M8Pxbps+MZ
         Je/RIWpUfV54RjdiIA8mBvyPLm9+vXKdsfoUIUb7S4piPlu1LTilkl7v/55W2rka+h/G
         VSdFNkANU40WSWWq7DGE5GQyY6dPBaXOibHxjjowpl4n7bzr+gKdrlL6ZpirUXbch60Z
         twC7SAnmB7Jzgh/T5wGRjM/pZiG4Nm2pkZ61LOg1cAQGJPcOBehWKUnVSwFP2SoFpqDN
         LB1g==
X-Gm-Message-State: AOAM530CBxlE/cv893dyr1JP6JCZJSMumvk1ozxeHCdb+d/lUpYP0Wjj
        IxrZTi3bMApEm+fy2upPBStNxBUQu+OvnRqbeScp2A==
X-Google-Smtp-Source: ABdhPJy+wnhFDll+mv7LIiKSNfRQ41dAABi9B9GZjw2dwvoiws5enWPEeNCL3N0k/xB5qaMMi/h/yGiXziML8E6Nkz4=
X-Received: by 2002:a63:d62:: with SMTP id 34mr2356233pgn.179.1598981381718;
 Tue, 01 Sep 2020 10:29:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200727175720.4022402-1-willmcvicker@google.com>
 <20200727175720.4022402-2-willmcvicker@google.com> <20200729214607.GA30831@salvia>
 <20200731002611.GA1035680@google.com> <20200731175115.GA16982@salvia>
 <20200731181633.GA1209076@google.com> <20200803183156.GA3084830@google.com>
 <20200804113711.GA20988@salvia> <20200901153607.GC4292@willie-the-truck>
In-Reply-To: <20200901153607.GC4292@willie-the-truck>
From:   William Mcvicker <willmcvicker@google.com>
Date:   Tue, 1 Sep 2020 10:29:25 -0700
Message-ID: <CABYd82ZDVqJo4KUiF0oMX6CW7pC_Y0DB_PdXJMft-yU=c5TCBg@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] netfilter: nat: add a range check for l3/l4 protonum
To:     Will Deacon <will@kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, security@kernel.org,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Will,

Pablo is going to add the latest patch to the nf.git tree. Once that
happens, I'm going to propose the patch in nf.git get cherry-picked to
the -stable branches.

Thanks,
Will


On Tue, Sep 1, 2020 at 8:36 AM Will Deacon <will@kernel.org> wrote:
>
> Hi Will, Pablo,
>
> On Tue, Aug 04, 2020 at 01:37:11PM +0200, Pablo Neira Ayuso wrote:
> > This patch is much smaller and if you confirm this is address the
> > issue, then this is awesome.
>
> Did that ever get confirmed? AFAICT, nothing ended up landing in the stable
> trees for this.
>
> Cheers,
>
> Will
>
>
> > On Mon, Aug 03, 2020 at 06:31:56PM +0000, William Mcvicker wrote:
> > [...]
> > > diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> > > index 31fa94064a62..56d310f8b29a 100644
> > > --- a/net/netfilter/nf_conntrack_netlink.c
> > > +++ b/net/netfilter/nf_conntrack_netlink.c
> > > @@ -1129,6 +1129,8 @@ ctnetlink_parse_tuple(const struct nlattr * const cda[],
> > >     if (!tb[CTA_TUPLE_IP])
> > >             return -EINVAL;
> > >
> > > +   if (l3num >= NFPROTO_NUMPROTO)
> > > +           return -EINVAL;
> >
> > l3num can only be either NFPROTO_IPV4 or NFPROTO_IPV6.
> >
> > Other than that, bail out with EOPNOTSUPP.
> >
> > Thank you.
