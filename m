Return-Path: <SRS0=Pnh4=S5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA97DC43218
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Apr 2019 11:30:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CC372087C
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Apr 2019 11:30:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g+Uva/8d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726004AbfD0LaW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 27 Apr 2019 07:30:22 -0400
Received: from mail-ed1-f44.google.com ([209.85.208.44]:33471 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfD0LaV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 27 Apr 2019 07:30:21 -0400
Received: by mail-ed1-f44.google.com with SMTP id d55so3438300ede.0
        for <netfilter-devel@vger.kernel.org>; Sat, 27 Apr 2019 04:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y8hDc/Tfxc2qYsqJ6R+s6bQuABMR3Wgpp5ReH1c1bGc=;
        b=g+Uva/8dIQwOB22cZSWlUyj/O4izBbvCYslUnAWn91cGO+5x1YKrdOq38ceT27qd0m
         Jmht7mDMAzwlxivHwbasDQGlD6dm3lCXZO2Pgk15Axl5C7gwMf6H8H+3KdeN+4YMmJJ1
         7lgiprt8t+k2p8IK7t0KsxYRlnD4QpH3oTIp/6e5Y14bO7lt9Y4sKmnExgFa9U1karz1
         q4qGn7sOIrXLraxKW2F8sK948m5qmRAaQrLgOVHLtyMS75aBtBx5wu+4ElSDGOUqR4Q8
         lX3AU+PJMLQTX3HZ6fak4a0njO/0uxQ8JwGph/1uJ8ZgqwXkJFKxF9LnhxEKo42A4DqW
         Lpgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y8hDc/Tfxc2qYsqJ6R+s6bQuABMR3Wgpp5ReH1c1bGc=;
        b=IbqEi7MMVPpAhOyO8mB4YWMRWkZfMfTQnBK9W234rMfxX58PWM/K/Guaf3+KdZv0hF
         6wvCtq9iTVHxaSfc4KwH5sw+T7yxjs4kwYX20wkRTadBW8UZT7lN68PvsCheya+5my0U
         GToZ6Yf6yeZhxkSkk2IuUM/DVuaVv0hknxhI/alrFrZhal6i6JhhCEfBPiFuhEaqmjKi
         62u/PQaeIDt5Ak3qEIYDlqU/PxLZzUk2FbJDqj11nhy4SaejyMWYNleu8+QSWUYk5c8g
         cboXRn9QpMjv9AXXRsvM0ZFIazhGBbqlCZu6rBkuMbuCSr6T6NVve8RZqzbeFEPOhWva
         /3Fw==
X-Gm-Message-State: APjAAAVf0LgFKiIieB2OVoXVxeSCeTr4dgRpaxhlZ9rWq1TTFC+UQjOF
        s7Q0m88GjfxPyomn/Czx7op2DXgpd4DZuwOvIeM=
X-Google-Smtp-Source: APXvYqyCvGG21O9JkOnXOUFDpgyEU1hy1Umi/isAMrlBdzK/y7QHJcxGBFugHtHpVrbXYpC9FaaUx2STIkys+rVmv6w=
X-Received: by 2002:a50:cb4d:: with SMTP id h13mr17897496edi.110.1556364620020;
 Sat, 27 Apr 2019 04:30:20 -0700 (PDT)
MIME-Version: 1.0
References: <CABVi_ExMwpQHT57x_tv-1fx2kUgGBfy+k2R-Fbrbki=V-igwrw@mail.gmail.com>
 <CABVi_EwUrvJtE_iXodFXXVn5uqaVjh9fx1qFFqz5fCaLZiE28w@mail.gmail.com>
 <20190425224512.dz2fuwqrrq5hd2x6@salvia> <CABVi_EwbDf_tA8KdXU33nLgVdHpXNYPtqHGb5DadcL0tdVXAfQ@mail.gmail.com>
 <20190426193732.xk3aektc7fb4eg2h@salvia> <CABVi_Ex1KoK22m6cKsnCLaTC1gaFSUqX2a54m3H=dm8DZ9NFFQ@mail.gmail.com>
 <CABVi_ExHXzWui4g9YZUx2PdnXXfc-OPv_UY++0rvy3ymurki5w@mail.gmail.com> <20190427094323.enhkqeoeow4jgmlk@salvia>
In-Reply-To: <20190427094323.enhkqeoeow4jgmlk@salvia>
From:   Mojtaba <mespio@gmail.com>
Date:   Sat, 27 Apr 2019 16:00:08 +0430
Message-ID: <CABVi_EwEc1x9dspiVHUKjoikvcCUTBMFbknFbR-yg+DaBcpAXw@mail.gmail.com>
Subject: Re: Issue related to conntrack while insert new rule with conntrack
 command in linux
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thanks Pablo,
Actually i need this feature for redirect  RTP-media packet beetwen
two service. I want to optimize resource consumption by using this
feature.
All things works right, But i should find the right place to insert
this rule in my code, Otherwise if the service got the first packet
from end-point while i don't insert the rule,yet. I will face with
problem, becasue of the rule was inserted before.
Thanks with regards. Mojtaba

On Sat, Apr 27, 2019 at 2:13 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Sat, Apr 27, 2019 at 01:31:40PM +0430, Mojtaba wrote:
> > Hello Pablo,
> > Just as better understanding, If i want to update using -U option, How
> > can i do that?
> > Suppose there is this rule in conntrack row:
> > udp      17 29 src=192.168.122.242 dst=192.168.122.103 sport=5070
> > dport=5005 [UNREPLIED] src=192.168.122.103 dst=192.168.122.242
> > sport=5005 dport
> > =5070 mark=0 use=1
> >
> > and i want to update it with this command:
> > conntrack -U -p udp -s 192.168.122.242 -d 192.168.122.103 --sport 5070
> > --dport 5005 --dst-nat 192.168.122.1:1111 --src-nat
> > 192.168.122.103:2222 --timeout 30
> > Actually it was not updated and this issue was raised:
> > conntrack v1.4.2 (conntrack-tools): 0 flow entries have been updated.
>
> You cannot update an existing entry with NATs.
>
> You can probably make your own libnetfilter_queue application that
> allows you to create conntrack entries from packets. If you want to do
> custom NAT handling some certain traffic. You will only need to pass
> the first packet of the flow to userspace to set up the NAT mangling
> you need.
>
> I would need to learn more on your usecase for this.



-- 
--Mojtaba Esfandiari.S
