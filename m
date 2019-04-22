Return-Path: <SRS0=3cJm=SY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE48C282E2
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 09:16:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EB7B20674
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Apr 2019 09:16:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UXFv+ty/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbfDVJQU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Apr 2019 05:16:20 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:40339 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726724AbfDVJQU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Apr 2019 05:16:20 -0400
Received: by mail-vs1-f68.google.com with SMTP id f22so5883347vso.7;
        Mon, 22 Apr 2019 02:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FGKzBtbWtSdMT4CQBSYq3CFTSOZD9sxtfUIsyvEVOMU=;
        b=UXFv+ty/yvtRzOlUvVMN5M4XAywS79EK7vzcMvu7p20RoOzhiLZh+PJXSPtmHcQYtN
         fwHGpBvP6fAliRdZ2g/mfmooKz/iouuWWNkJ+QuAwKhbRjU/FCKsXz5i0wXk1FxMjqE7
         hZh4vWjhXqyDQUpBeXWqO8pKfAXTxpJ5fQKs9IgnnDrXjva6Z/nBPqJkZRYYkkm/bIi0
         V0SLcPewxOInirsaJ4S22GdAkvE4NbOLiBbiZN6BRu7pUkPnomv7wOdPFj0tQkga9gqL
         EKDcqtH/cyPCKzuV277yikhzFO1kwz2dRKpfO/kOhmtfMgmSExMKSvVlknXFCfJLYNzv
         HY4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FGKzBtbWtSdMT4CQBSYq3CFTSOZD9sxtfUIsyvEVOMU=;
        b=mmSiR5MlnAxCZaGdU5ttk7cbxYmLqcFTnTPwLHAtWb48JPWMEqVQfC+a6CeHjGHIK/
         oBQSwQFbN8b52grvjQcP3MlJtLKY/cu2/nwEXaZsF1ZB+EPGMzhuZ8gXdK7L9tCABC/B
         QiYlutOOWUhbvYyicuDFoGqeL6cn27wA9quQuz3/eQmmcml4010mmmj/+PxZeSiw8hGJ
         imYogeXn1w26uzJBr7eYWGyT480CWgwEzNmmRxAlqWKQVBefS7/2suQp8+XtAOyUkVtw
         QXtFCXkh+IT9MUv88u7rlY4p2KREL/fbSc7brtY1fo05Uz4xhdhKsGr+ezMAAxVFobTt
         rkhA==
X-Gm-Message-State: APjAAAVw0icskHNBmSvOagw84xammJvG0ivdmkwlmqCBDdZ0C3fMx9lU
        pK6fC8cJHE1YspCagoCM1mjH6Y7HFa+8PzKHhQ==
X-Google-Smtp-Source: APXvYqyjfURkPVWRuOBTLlTWPvS+h7cQQfafSRORFM7X22mFuitRJE3p60ncOMw8uUNLdZALqfwkL7WcxFAipFD1xR8=
X-Received: by 2002:a67:7404:: with SMTP id p4mr9559676vsc.45.1555924578833;
 Mon, 22 Apr 2019 02:16:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190409065612.32652-1-rdong.ge@gmail.com> <20190422083339.ptkxqb66pombgy5g@salvia>
In-Reply-To: <20190422083339.ptkxqb66pombgy5g@salvia>
From:   Rundong Ge <rdong.ge@gmail.com>
Date:   Mon, 22 Apr 2019 17:16:07 +0800
Message-ID: <CAN1Lvyo1CVopsB7iV=e-dAN9JDFg-SmQ8g6H6RrgD7qACAd4hQ@mail.gmail.com>
Subject: Re: [PATCH] netfilter: fix dangling pointer access of fake_rtable
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     kadlec@blackhole.kfki.hu, fw@strlen.de,
        Roopa Prabhu <roopa@cumulusnetworks.com>, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

br_nf_pre_routing will call the NF_INET_PRE_ROUTING hooks, at this
time both entry->state.in and entry->state.out are not bridge device.

NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING, state->net, state->sk, skb,
skb->dev, NULL,
br_nf_pre_routing_finish);

Pablo Neira Ayuso <pablo@netfilter.org> =E4=BA=8E2019=E5=B9=B44=E6=9C=8822=
=E6=97=A5=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=884:34=E5=86=99=E9=81=93=EF=BC=
=9A
>
> On Tue, Apr 09, 2019 at 06:56:12AM +0000, Rundong Ge wrote:
> [...]
> > diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_=
queue.c
> > index 0dcc359..57eb02d 100644
> > --- a/net/netfilter/nfnetlink_queue.c
> > +++ b/net/netfilter/nfnetlink_queue.c
> > @@ -905,13 +905,25 @@ static void free_entry(struct nf_queue_entry *ent=
ry)
> >  dev_cmp(struct nf_queue_entry *entry, unsigned long ifindex)
> >  {
> >  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
> > -     int physinif, physoutif;
> > +     struct net_device *physindev, *physoutdev;
> > +     struct net_bridge_port *port;
> >
> > -     physinif =3D nf_bridge_get_physinif(entry->skb);
> > -     physoutif =3D nf_bridge_get_physoutif(entry->skb);
> > -
> > -     if (physinif =3D=3D ifindex || physoutif =3D=3D ifindex)
> > -             return 1;
> > +     physindev =3D nf_bridge_get_physindev(entry->skb);
> > +     physoutdev =3D nf_bridge_get_physoutdev(entry->skb);
> > +     if (physindev) {
> > +             if (physindev->ifindex =3D=3D ifindex)
> > +                     return 1;
> > +             port =3D br_port_get_rcu(physindev);
> > +             if (port && port->br->dev->ifindex =3D=3D ifindex)
> > +                     return 1;
> > +     }
> > +     if (physoutdev) {
> > +             if (physoutdev->ifindex =3D=3D ifindex)
> > +                     return 1;
> > +             port =3D br_port_get_rcu(physoutdev);
> > +             if (port && port->br->dev->ifindex =3D=3D ifindex)
> > +                     return 1;
> > +     }
>
> Either entry->state.in and entry->state.out point to the bridge
> device, after this #endif.
>
> >  #endif
> >       if (entry->state.in)
> >               if (entry->state.in->ifindex =3D=3D ifindex)
> > --
> > 1.8.3.1
> >
