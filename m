Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23709C43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 19:23:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFA6C2086A
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 19:23:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RNuIJT3C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbfDZTXn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 15:23:43 -0400
Received: from mail-ed1-f54.google.com ([209.85.208.54]:44686 "EHLO
        mail-ed1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbfDZTXn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 15:23:43 -0400
Received: by mail-ed1-f54.google.com with SMTP id i13so4038549edf.11
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 12:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xd0Bib7iGBsaM/iLQOaUsfW5B5Nf6G+lcWqArLTEz1k=;
        b=RNuIJT3Cnq54weYvaFvMcwzK6X962irgqJuGaGgNB5iPjqxat4Ipw7CuRE/SFXWPI7
         B3osu9dAkl1gFoyT3zIYSEcDotTyr+WQM6ZJAmvYSSFlTvzEUqdyOhEIht3cXnN8JVNj
         0r83BfRBRZeHLoRlJJ24WbNH4LT91/kR/nKNLD7gYZRbdMtK69X/2rXFUpl6PAeC4hwC
         Cn+f0utP0Kal0f0sQQL3mK66c35HfOnbj2ggQBuwAsd8OaS9DPSLhblIq/DAL0JrEoM6
         QrKrLJurBjlAtqIJhWmw+4+x1ZpcveRJyqf+vRmtH8rYAzcLNOIwf/sRFJKRZ6a9qAhD
         NSjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xd0Bib7iGBsaM/iLQOaUsfW5B5Nf6G+lcWqArLTEz1k=;
        b=ppJpgf8S8nIDzJA/YhKAlyD5lzgQjFQrGsC3m4LysltRrd2iWNjH770vfplL9lknhp
         08hIqrTO3EGj28fiGL4b6U947VZ3BpU8si8CKr+NpPqtuHV+nGk382D77xviKPXuTjXs
         3R9iR/2qLRCyrGUxhw4jeJv+k02L9cj34VxsE6VOUjSV7zAq1oKRMuMyr+fQXetRysGM
         Jm19miIVna2INmiSmMAq4kIOvW55VcXyHbbrEYonXFzZshq5WI3arzPWpnIZfJm6xqOJ
         jJHqpF3/bEppxEhU1Uug0w3ENStglmLCF49FHF11cXNb2znFQENeKZURxltO4iykm6dr
         8EZg==
X-Gm-Message-State: APjAAAWBpzAdmGeWahUdLE2dS687w7x6cJiuWG/Irpxbwj3c3wQ9soxf
        uyI/5/g5M1Am8kwBEpGp9GLFkf6limW86HxgbXA=
X-Google-Smtp-Source: APXvYqxGqUcvIk2PUVLNT5Sm7R3+eGf7f+mujNByej4EmnQNlttC+lVrZHch9O9wcKTULt6gIowNdlvU/D5P4/LQuE4=
X-Received: by 2002:a17:906:43c4:: with SMTP id j4mr13816500ejn.262.1556306621384;
 Fri, 26 Apr 2019 12:23:41 -0700 (PDT)
MIME-Version: 1.0
References: <CABVi_ExMwpQHT57x_tv-1fx2kUgGBfy+k2R-Fbrbki=V-igwrw@mail.gmail.com>
 <CABVi_EwUrvJtE_iXodFXXVn5uqaVjh9fx1qFFqz5fCaLZiE28w@mail.gmail.com> <20190425224512.dz2fuwqrrq5hd2x6@salvia>
In-Reply-To: <20190425224512.dz2fuwqrrq5hd2x6@salvia>
From:   Mojtaba <mespio@gmail.com>
Date:   Fri, 26 Apr 2019 23:53:29 +0430
Message-ID: <CABVi_EwbDf_tA8KdXU33nLgVdHpXNYPtqHGb5DadcL0tdVXAfQ@mail.gmail.com>
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

Thanks again, It works correctly now. But how can i set  port 1111? I
have just tried like this command but i don=E2=80=99t work and i don't get =
any
packets on port 1111 in 192.168.122.1:
conntrack -I -p udp -s 192.168.122.242 -d 192.168.122.103 --sport 5070
--dport 5005 --dst-nat 192.168.122.1:1234 --timeout 30

The packets that i got  on 192.168.122.1 are either port 5070 or port
5005 like below:
23:33:38.520746 IP 192.168.122.242.5070 > 192.168.122.103.5005: UDP, length=
 12
23:33:38.528807 IP 192.168.122.242.5070 > 192.168.122.103.5005: UDP, length=
 12

 Actually i would like get packet on 192.168.122.1 on port 1111 like
this. If i set the two rule of iptables in nat table, i could see the
packet on 192.168.122.1 like below,too
23:33:38.528807 IP 192.168.122.103.2222 > 192.168.122.1.1111: UDP, length 1=
2
23:33:38.528807 IP 192.168.122.103.2222 > 192.168.122.1.1111: UDP, length 1=
2

So how can i set --src-nat to 192.168.122.103 and port 2222, too?
With Best Regards. Mojtaba

On Fri, Apr 26, 2019 at 3:15 AM Pablo Neira Ayuso <pablo@netfilter.org> wro=
te:
>
> On Thu, Apr 25, 2019 at 07:38:20PM +0430, Mojtaba wrote:
> > Hello all
> > I read man conntrack document guide. That is great.
> > I have a issue while i am working on it. For example i just want to ins=
ert
> > new rule in conntrack table like this:
> > conntrack -I -p udp -s 192.168.122.242 -d 192.168.122.103 --sport 5070
> > --dport 5005 -r 192.168.122.1 -q 192.168.122.103 --reply-port-src 1111
> > --reply-port-dst 2222 --timeout 30
> >
> > it successfully inserted but doesn=E2=80=99t work and traffic will be g=
o to INPUT chain.
> > if i insert these two rules in iptables, the same above rules will be i=
nserted
> > in conntrack table automatically and works correctly.(the traffic will
> > be traversed to 192.168.122.1 host)
> > iptables -t nat -A PREROUTING -i eth0 -p udp -s 192.168.122.242
> > --dport 5005 -j DNAT --to 192.168.122.1:1111
> >
> > iptables -t nat -A POSTROUTING -p udp --dport 1111 -j SNAT --to
> > 192.168.122.103:2222
>
> Have a look at --dst-nat option, eg.
>
> conntrack -I -p udp -s 192.168.122.242 -d 192.168.122.103 --sport 5070 --=
dport 5005 --dst-nat 192.168.122.1 --timeout 30



--=20
--Mojtaba Esfandiari.S
