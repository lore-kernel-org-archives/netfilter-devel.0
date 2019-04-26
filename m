Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A44E5C43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 10:23:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 758E5206BA
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 10:23:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dxfHA/9Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbfDZKXA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 06:23:00 -0400
Received: from mail-ed1-f49.google.com ([209.85.208.49]:36641 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbfDZKXA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 06:23:00 -0400
Received: by mail-ed1-f49.google.com with SMTP id a8so662060edx.3
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 03:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yv2E4seGT7rS9bwTBwez03LkUXlo83pC9NmTjS12YeU=;
        b=dxfHA/9Q3ULOVvvP5BcjymkHTQTNdMd2dR9ihkalwZyeXcatxXwT0E056H4KbG+mkR
         AO4ZOEmGwEdvhazatsIoMtubwtxKV5gnL38iefxzuDa9XMc3zm2OJfmRSaFyceDzNje0
         0UqdNnJ1wKiWODqGUsHkkqfIWh/936CU1jTwOmO72WlmyehC1zaa6PN6rKTVzCEgFX+t
         hF0sLTGBACwiYJo9EcxYpufEt9MpZRF4Ihr9tQtv5oIMQ1Sgp6aQkM/T2jeUQanC1nQV
         e4/Y5v66CU3EQyrrp3SeQQZR0dKO4Oo8WXuaID7xZGE4IquATil+wkXvZPdE5u+74j4O
         PJmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yv2E4seGT7rS9bwTBwez03LkUXlo83pC9NmTjS12YeU=;
        b=YnYXq5YCMtfMJL/MMBrmdzHLZ0pIqYBh4Ij9FRV/Udo0G3Qpi1v1mGCl+d7MICISvX
         tnPzmzyLMIsDXYDxmPrIz7pGDPGnaCXuHX2a9yT8zInmvmpuG0ZrSagGxv/F+tQNvGdy
         ryuP5SYUnbLBEa4PiY2nmG3H83g9ru9QawCFUQGG59RC+vx35fLoV858oYnHULNyU7+3
         piHFIIiHOlLdcXGHiGZTWtYFuhXYlMjdEo7l5zOFEGFNuJn7/uKPwGeModH2fyp3VJ3O
         B9GonDAeYKa3fpEhMw9+nIQAbgulKkPoYAyfv+PYCtTfP9ZUyrT5A7z+C5ovZMhTG5++
         0rbQ==
X-Gm-Message-State: APjAAAUXF/t0qB0VLFxfOdWdwwtWBxpaZtRPGlXcHu3bqliO47mQOKOB
        H00fBrzzLji5rsyApeNyN24lXRTxPDYofjbGzi8PvKA3
X-Google-Smtp-Source: APXvYqynJ8boMauYXjyiU3VxdZGepPbSknLOKhrGLwAYx+rjx5SacciuggHsW0LxUePCmyS9+yJtVdqIJHnCKZeBmbU=
X-Received: by 2002:a17:906:1856:: with SMTP id w22mr22650803eje.130.1556274178861;
 Fri, 26 Apr 2019 03:22:58 -0700 (PDT)
MIME-Version: 1.0
References: <CABVi_ExMwpQHT57x_tv-1fx2kUgGBfy+k2R-Fbrbki=V-igwrw@mail.gmail.com>
 <CABVi_EwUrvJtE_iXodFXXVn5uqaVjh9fx1qFFqz5fCaLZiE28w@mail.gmail.com> <20190425224512.dz2fuwqrrq5hd2x6@salvia>
In-Reply-To: <20190425224512.dz2fuwqrrq5hd2x6@salvia>
From:   Mojtaba <mespio@gmail.com>
Date:   Fri, 26 Apr 2019 14:52:47 +0430
Message-ID: <CABVi_EzLiqeOhvimg=BhxWBRZibiYiMQpB0vSg-bAEepLxV+pQ@mail.gmail.com>
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

Thanks, I'll check it out and let you know.
With best regards.Mojtaba

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
