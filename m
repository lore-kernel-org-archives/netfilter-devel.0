Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8C39C43218
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 19:50:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D7BC2077B
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 19:50:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eBYc3KJF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbfDZTur (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 15:50:47 -0400
Received: from mail-ed1-f41.google.com ([209.85.208.41]:42325 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbfDZTur (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 15:50:47 -0400
Received: by mail-ed1-f41.google.com with SMTP id l25so4113486eda.9
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 12:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RmXU1aBvHqdUQiWR/D4+fq+cidp4c2V9x0+zAdMTzdg=;
        b=eBYc3KJFRti8nGaIJPf7Hr5eTaSm2a9APEa5OcX7mPGZ//6NX+6WiNnuh4r12kc6cN
         5oVwBeYp9lR0vR+agKOhgIQmS3OqUOkb9uj9W/UvbbvM8vQYgSz0eE2U6m+Kii2xcizz
         klBfUa1D5E4n3LHyOHsrjDvWFrFBG/G8QEtjBRO8VUndha1KaYUW0crLtl04qfwlFZd8
         mLydsd3B27v822ZQVxGDmUJOK1BSajrxlJEb5uvSv3EPSTm54m4suTAAGCLVj29fq7YJ
         3zVShTE/OFag9daMc6YIVDPRHYyd6PjWv5zPTzMjKQGn06y+F2nma29tiQvgo/7A44v0
         RwmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RmXU1aBvHqdUQiWR/D4+fq+cidp4c2V9x0+zAdMTzdg=;
        b=dEn8cRJHlVAmFVgJxv1BR6QnFIM+vbmUYYzSy3P3fiYN8zIyllKj+ELSkTJAyI98VZ
         WbIbmI2Xo6TXD9oSy4ms8XRxeTzcH+72Sim1l03huBfaNNx1MDRAbz/lU9UnrB950xGI
         ZXVSuui5cTXBhNJDur7iTSOU5gupJGUxT7ENrXjUrjHPu4eoaJV5g81FxFuQGJMP1mAk
         BX00I7dcydy+2Ml/Cw5XNKEHcLFx583kCHg3wxsfHvgyV79IE42bdT9xtaMFV2pbo8c9
         5cZn9GlSmhNU/QCKQC+21S+hkiqy7tjMVfDb/aV8rkyr2e675q8NcdfhW6RPHb3smpSq
         mwZQ==
X-Gm-Message-State: APjAAAWz2Mfi/nGXO3QOyxt5sNlJdmztWwqCoFWyBnM3iluPigJuGYCL
        EJ5ugKR1HPw1X9fZynV7gy+aZaQTTnIXubioIZs=
X-Google-Smtp-Source: APXvYqxB4BcdKQ9oWvVu3VA3Cjfl/OMrP3tQF7gj1jG7UDmbZcoPNlX10skQS+9wXh+90iQUPasSdUNjgcFeWp8W160=
X-Received: by 2002:a17:906:9a9:: with SMTP id q9mr16312900eje.171.1556308244952;
 Fri, 26 Apr 2019 12:50:44 -0700 (PDT)
MIME-Version: 1.0
References: <CABVi_ExMwpQHT57x_tv-1fx2kUgGBfy+k2R-Fbrbki=V-igwrw@mail.gmail.com>
 <CABVi_EwUrvJtE_iXodFXXVn5uqaVjh9fx1qFFqz5fCaLZiE28w@mail.gmail.com>
 <20190425224512.dz2fuwqrrq5hd2x6@salvia> <CABVi_EwbDf_tA8KdXU33nLgVdHpXNYPtqHGb5DadcL0tdVXAfQ@mail.gmail.com>
 <20190426193732.xk3aektc7fb4eg2h@salvia>
In-Reply-To: <20190426193732.xk3aektc7fb4eg2h@salvia>
From:   Mojtaba <mespio@gmail.com>
Date:   Sat, 27 Apr 2019 00:20:33 +0430
Message-ID: <CABVi_Ex1KoK22m6cKsnCLaTC1gaFSUqX2a54m3H=dm8DZ9NFFQ@mail.gmail.com>
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

Yes, it's perfect. I just forgot to enable ip_forwarding right now.
the problem was because of it.
I used this command and it works properly.
conntrack -I -p udp -s 192.168.122.242 -d 192.168.122.103 --sport 5070
--dport 5005 --dst-nat 192.168.122.1:1234 --src-nat
192.168.122.103:2222 --timeout 30

That's great. Thank you so much Pablo.
With best regards

On Sat, Apr 27, 2019 at 12:07 AM Pablo Neira Ayuso <pablo@netfilter.org> wr=
ote:
>
> On Fri, Apr 26, 2019 at 11:53:29PM +0430, Mojtaba wrote:
> > Thanks again, It works correctly now. But how can i set  port 1111? I
> > have just tried like this command but i don=E2=80=99t work and i don't =
get any
> > packets on port 1111 in 192.168.122.1:
> > conntrack -I -p udp -s 192.168.122.242 -d 192.168.122.103 --sport 5070
> > --dport 5005 --dst-nat 192.168.122.1:1234 --timeout 30
> >
> > The packets that i got  on 192.168.122.1 are either port 5070 or port
> > 5005 like below:
> > 23:33:38.520746 IP 192.168.122.242.5070 > 192.168.122.103.5005: UDP, le=
ngth 12
> > 23:33:38.528807 IP 192.168.122.242.5070 > 192.168.122.103.5005: UDP, le=
ngth 12
> >
> >  Actually i would like get packet on 192.168.122.1 on port 1111 like
> > this. If i set the two rule of iptables in nat table, i could see the
> > packet on 192.168.122.1 like below,too
> > 23:33:38.528807 IP 192.168.122.103.2222 > 192.168.122.1.1111: UDP, leng=
th 12
> > 23:33:38.528807 IP 192.168.122.103.2222 > 192.168.122.1.1111: UDP, leng=
th 12
> >
> > So how can i set --src-nat to 192.168.122.103 and port 2222, too?
>
> Does this work?
>
> conntrack -I -p udp -s 192.168.122.242 -d 192.168.122.103 --sport 5070 --=
dport 5005 --dst-nat 192.168.122.1:1234 --timeout 30



--=20
--Mojtaba Esfandiari.S
