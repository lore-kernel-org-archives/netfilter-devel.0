Return-Path: <SRS0=Pnh4=S5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A8D6C43219
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Apr 2019 09:01:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED4C62077B
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Apr 2019 09:01:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vbCVtfy1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbfD0JBz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 27 Apr 2019 05:01:55 -0400
Received: from mail-ed1-f49.google.com ([209.85.208.49]:34683 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbfD0JBy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 27 Apr 2019 05:01:54 -0400
Received: by mail-ed1-f49.google.com with SMTP id a6so5129407edv.1
        for <netfilter-devel@vger.kernel.org>; Sat, 27 Apr 2019 02:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=itXBdmPUHJ8v6scgZLgfmgaoc6nSGRAANT77sNdCmWY=;
        b=vbCVtfy1QAvt/2qBUOFdUreqe7vG2OzcY00/Ha/nfyrcVcIJdmqqls7JcqFGEyap06
         0SqwUTumm8ftAlYh/+CqAUI3Khx2zAsHJapnsSYmxg2aKeqQezslpOKAHkE2D8b9eRlv
         IfUl66uIMtz08LAUxcCMFUTZ3kdji8DG35J7tL3fn/USywjknBqvXF2Yg8AZ7E4Xvn/W
         n5m+PIbvYWWKaRe9/ljFqlQ/PcfScD2yQlHlp6lXu4S9xrHYJvGh1CzsD6QGDAMA3/OO
         rWf2pTPR+XE4+c++6465CDwvqp4VXvgW1IYNZTByKIW55iRxsmtSkEYCT0e6TuN6QuMA
         cJTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=itXBdmPUHJ8v6scgZLgfmgaoc6nSGRAANT77sNdCmWY=;
        b=gfvNpNMolMHp2BQmtpWH52sLKtL44dRtnzkXURll+JWQs9TzrtHIwLqJYR8/s7Gej4
         /zFFiDZAHZ+hivCz53jmq5776Tjqi3jg1lLgQuVRw+zU0FHFpsKqEB2brkiWZ8chvTlS
         Jp2KZ2Xxv0dIMv4gnGqvb9Y0hgCUTU475AGmDFZJUE/RCZhubYCc96LrRuEyI9kTj1F4
         QWSj/MOugM93h2t12LI+HI3Slg45Gk/DEdsxOYzxkblg/jxewvpy4W364r24UBXLQs9B
         BRw7Y9gdW/Kh+D/R8q697NRKyqv1WjBFu5UybSbOJUK2bx/1Bi50sKiJcRnALDtlGush
         LqWQ==
X-Gm-Message-State: APjAAAUyAYI65J982cLpKhjYh4PVK7u1HWiFM+MQ9aJkXZwbpmm1OY+d
        qI3VT3oMka8lcqflYvOuyPZ9HeQ9YjhTCFNA4N7i2YMX5yc=
X-Google-Smtp-Source: APXvYqwI9EsTPkZC4QZKXb2gZlUeXldrKzyciPpsEgmuecWSCKkCnIF+F5eWZMHrvs4KspKbp/LGGHZQ9kWWj4iPFiQ=
X-Received: by 2002:a17:906:9a9:: with SMTP id q9mr17779747eje.171.1556355712191;
 Sat, 27 Apr 2019 02:01:52 -0700 (PDT)
MIME-Version: 1.0
References: <CABVi_ExMwpQHT57x_tv-1fx2kUgGBfy+k2R-Fbrbki=V-igwrw@mail.gmail.com>
 <CABVi_EwUrvJtE_iXodFXXVn5uqaVjh9fx1qFFqz5fCaLZiE28w@mail.gmail.com>
 <20190425224512.dz2fuwqrrq5hd2x6@salvia> <CABVi_EwbDf_tA8KdXU33nLgVdHpXNYPtqHGb5DadcL0tdVXAfQ@mail.gmail.com>
 <20190426193732.xk3aektc7fb4eg2h@salvia> <CABVi_Ex1KoK22m6cKsnCLaTC1gaFSUqX2a54m3H=dm8DZ9NFFQ@mail.gmail.com>
In-Reply-To: <CABVi_Ex1KoK22m6cKsnCLaTC1gaFSUqX2a54m3H=dm8DZ9NFFQ@mail.gmail.com>
From:   Mojtaba <mespio@gmail.com>
Date:   Sat, 27 Apr 2019 13:31:40 +0430
Message-ID: <CABVi_ExHXzWui4g9YZUx2PdnXXfc-OPv_UY++0rvy3ymurki5w@mail.gmail.com>
Subject: Re: Issue related to conntrack while insert new rule with conntrack
 command in linux
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello Pablo,
Just as better understanding, If i want to update using -U option, How
can i do that?
Suppose there is this rule in conntrack row:
udp      17 29 src=3D192.168.122.242 dst=3D192.168.122.103 sport=3D5070
dport=3D5005 [UNREPLIED] src=3D192.168.122.103 dst=3D192.168.122.242
sport=3D5005 dport
=3D5070 mark=3D0 use=3D1

and i want to update it with this command:
conntrack -U -p udp -s 192.168.122.242 -d 192.168.122.103 --sport 5070
--dport 5005 --dst-nat 192.168.122.1:1111 --src-nat
192.168.122.103:2222 --timeout 30
Actually it was not updated and this issue was raised:
conntrack v1.4.2 (conntrack-tools): 0 flow entries have been updated.

With Best Regards.Mojtaba

On Sat, Apr 27, 2019 at 12:20 AM Mojtaba <mespio@gmail.com> wrote:
>
> Yes, it's perfect. I just forgot to enable ip_forwarding right now.
> the problem was because of it.
> I used this command and it works properly.
> conntrack -I -p udp -s 192.168.122.242 -d 192.168.122.103 --sport 5070
> --dport 5005 --dst-nat 192.168.122.1:1234 --src-nat
> 192.168.122.103:2222 --timeout 30
>
> That's great. Thank you so much Pablo.
> With best regards
>
> On Sat, Apr 27, 2019 at 12:07 AM Pablo Neira Ayuso <pablo@netfilter.org> =
wrote:
> >
> > On Fri, Apr 26, 2019 at 11:53:29PM +0430, Mojtaba wrote:
> > > Thanks again, It works correctly now. But how can i set  port 1111? I
> > > have just tried like this command but i don=E2=80=99t work and i don'=
t get any
> > > packets on port 1111 in 192.168.122.1:
> > > conntrack -I -p udp -s 192.168.122.242 -d 192.168.122.103 --sport 507=
0
> > > --dport 5005 --dst-nat 192.168.122.1:1234 --timeout 30
> > >
> > > The packets that i got  on 192.168.122.1 are either port 5070 or port
> > > 5005 like below:
> > > 23:33:38.520746 IP 192.168.122.242.5070 > 192.168.122.103.5005: UDP, =
length 12
> > > 23:33:38.528807 IP 192.168.122.242.5070 > 192.168.122.103.5005: UDP, =
length 12
> > >
> > >  Actually i would like get packet on 192.168.122.1 on port 1111 like
> > > this. If i set the two rule of iptables in nat table, i could see the
> > > packet on 192.168.122.1 like below,too
> > > 23:33:38.528807 IP 192.168.122.103.2222 > 192.168.122.1.1111: UDP, le=
ngth 12
> > > 23:33:38.528807 IP 192.168.122.103.2222 > 192.168.122.1.1111: UDP, le=
ngth 12
> > >
> > > So how can i set --src-nat to 192.168.122.103 and port 2222, too?
> >
> > Does this work?
> >
> > conntrack -I -p udp -s 192.168.122.242 -d 192.168.122.103 --sport 5070 =
--dport 5005 --dst-nat 192.168.122.1:1234 --timeout 30
>
>
>
> --
> --Mojtaba Esfandiari.S



--=20
--Mojtaba Esfandiari.S
