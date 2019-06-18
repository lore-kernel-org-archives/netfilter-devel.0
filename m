Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3F8CC31E51
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 10:25:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97D222070B
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 10:25:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DVe6zefL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbfFRKZA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 06:25:00 -0400
Received: from mail-ed1-f47.google.com ([209.85.208.47]:42413 "EHLO
        mail-ed1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfFRKZA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 06:25:00 -0400
Received: by mail-ed1-f47.google.com with SMTP id z25so20900061edq.9
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 03:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AcVsDuaZcx98n+R1MCmOmyDoG34FF0x7gPQqSzRJFgw=;
        b=DVe6zefLA9hCZzbA0WsYWKZiHz80t3f589fhRsI9UBibaPLHSUNxc8Abh8aIBWgavb
         zaAsyyQ2JehzfFAdQRLoZR3JMusoMeZL+fiK0SWg5nTSnP1OvlnpDatO1teoiA11p+KL
         w+di0R0C0IkTxa+DKpsgC+aogxk3LQr43w2z9/xpdnwW+WZSQjMDw15RfceiXZKBmDsy
         ypNR0LLtycz8SzX5XqAzb8qzNmHzzna5vRwz14fKZoYsfGIw45BVJAhrF4+YRXfWhFmh
         /cztjeNvLB62a/wghfKP3XBv0DEk4oeMC4J1efg9D4X3iO3jtKq2ihUo3R62h87ACKK5
         A3Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AcVsDuaZcx98n+R1MCmOmyDoG34FF0x7gPQqSzRJFgw=;
        b=MRbDvEvjZMEgJhOWU3qj8+heaJqeGdq1YEcXaVUQxu0jGQ6xBKG0lWqf4chyoeOCPP
         s8kdIo5bM6HQS5Ql0L1MOCrjFIZkpZcMtWhmaimqUVw0Y36uB4fyfnndcsSrhJ/WJZCj
         Ur40dLAP2cao99V6S5hgg6n5PU2EoHOtjg3MyfYDHsVYc4xPIRW1omXg61U9uIT5SkTo
         PlOKpqZDehIgvD616JbqLQDHiaKSDTBrz8SMBLE2VmArL09/DbxAiPmcFVDU+MP8uv/7
         D3VSj0NPV6W8xjhbH4j1DroEDUjC2wTodHiiSfqVVDNZCTmO9I7Lk8BwtGg1cdOWH9zr
         lw4A==
X-Gm-Message-State: APjAAAU0zcyOJuWiGske72TOijmVr4NM6sqh0CGUHUtTK2d14y0RtTIK
        QoWWiG3cTlVD416VYRr1cMZCSpKFWmmqkpU6nETw/fGC7yQ=
X-Google-Smtp-Source: APXvYqyrb2t8ZjgXncHkZiNBz9GM1QBtHz7gBfOFuX4XW4j7ygujmRKU8C1z+E1kdaLlZbnsR2Bl4b05HGE7EiU8KII=
X-Received: by 2002:a50:cac1:: with SMTP id f1mr122316341edi.97.1560853498347;
 Tue, 18 Jun 2019 03:24:58 -0700 (PDT)
MIME-Version: 1.0
References: <CABVi_Eyws89e+y_4tGJNybGRdL4AarHG6GkNB0d0MGgLABuv3w@mail.gmail.com>
 <20190618095021.doh6pc7gzah3bnra@breakpoint.cc>
In-Reply-To: <20190618095021.doh6pc7gzah3bnra@breakpoint.cc>
From:   Mojtaba <mespio@gmail.com>
Date:   Tue, 18 Jun 2019 14:54:46 +0430
Message-ID: <CABVi_EwXyE3zzZBCs-iXY_JsK2Xpgi6iabgG6WJPsqoEcbg0qg@mail.gmail.com>
Subject: Re: working with libnetfilter_queue and linbetfilter_contrack
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Yes, For this reason, i should add conntrack entry before the kernel
do in my userspace project. Because i have to forward the packet to
another destination, i used --src-nat and --dst-nat options while
adding new  conntrack entry. Just like as obvious in below code:
nfct_set_attr_u8(ct, ATTR_L3PROTO, AF_INET);
nfct_set_attr_u32(ct, ATTR_IPV4_SRC, inet_addr("192.168.133.140"));
nfct_set_attr_u32(ct, ATTR_IPV4_DST, inet_addr("192.168.133.108"));
nfct_set_attr_u8(ct, ATTR_L4PROTO, IPPROTO_UDP);
nfct_set_attr_u16(ct, ATTR_PORT_SRC, htons(6000));
nfct_set_attr_u16(ct, ATTR_PORT_DST, htons(5005));
nfct_setobjopt(ct, NFCT_SOPT_SETUP_REPLY);
nfct_set_attr_u32(ct, ATTR_TIMEOUT, 60);
nfct_set_attr_u32(ct, ATTR_SNAT_IPV4, inet_addr("192.168.133.108"));
nfct_set_attr_u32(ct, ATTR_DNAT_IPV4, inet_addr("192.168.133.150"));
nfct_set_attr_u16(ct, ATTR_SNAT_PORT, htons(5070));
nfct_set_attr_u16(ct, ATTR_DNAT_PORT, htons(6000));

As far as i know, it is possible to delegate verdict of packets to
user-space, Here is the main point that is deriving me confused.
Suppose i used this rule in IPTABLE:
iptables -A INPUT -p udp --dport 5005  -j NQUEUE --queue-num 0
Then how we could make verdict to forward the packet to another
destination?  Do i could implement my solution in this way or i have
to use libnetfilter_contrack like as above sample code?
WIth Best Regards.Mojtaba


On Tue, Jun 18, 2019 at 2:20 PM Florian Westphal <fw@strlen.de> wrote:
>
> Mojtaba <mespio@gmail.com> wrote:
> > I am working for a while on two projects (libnetfilter_queue and
> > linbetfilter_contrack) to get the decision of destined of packets that
> > arrived in our project. It greats to get the control of all packets.
> > But I confused a little.
> > In my solution i just want to forward all packets that are in the same
> > conditions (for example: all packets are received from specific
> > IP:PORT address) to another destination. I could add simply add new
> > rule in llinbetfilter_contrack list (like the samples that are exist
> > in linbetfilter_contrack/utility project).
> > But actually i want to use NFQUEUE to get all packets in my user-space
> > and then add new rule in linbetfilter_contrack list. In other words,
> > the verdict in my sulotions is not ACCEPT or DROP the packet, it
> > should add new rule in linbetfilter_contrack list if it is not exist.
> > Is it possible?
>
> Yes, but that doesn't make sense because the kernel will add a conntrack
> entry itself if no entry existed.
> Or are you dropping packets in NEW state?
> Or are you talking about conntrack expectations?
>
> A conntrack entry itself doesn't accept or forward a packet.
>
> It just means that next packet of same flow will find the entry and
> rules like iptables ... -m conntrack --ctstate NEW/ESTABLISHED etc.
> will match.



-- 
--Mojtaba Esfandiari.S
