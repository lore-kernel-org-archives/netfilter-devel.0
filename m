Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB53FC83F10
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Aug 2023 09:41:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245575AbjHaJlA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Aug 2023 05:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231977AbjHaJlA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Aug 2023 05:41:00 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49EC4CF2
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Aug 2023 02:40:57 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id a1e0cc1a2514c-7a294a4ee4bso354746241.0
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Aug 2023 02:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693474856; x=1694079656; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SZqHYqF36xqTce0S2Q/nX6iXYvL6nhQhwVC7ut1ep7Q=;
        b=nnm3iM7TUkQakArBT4rawlXTMOk0GqgB4engFclMK+tYo67+dsjTbD2CSNaPtZp97u
         AJdunrJzKC9yI5kU8nfDYfmX4gDuc+jbalrkRY4q4ZTeHJjpT6tuGtyBdeUdj9AuX2M0
         F+BEq9wUDyDmJ9tL0IsbgdIky5u7R9oSQujb45/311eINYpJF97wtVXwrQWVcTYFmX1K
         yJWPFUwY5K24mmAd3tMsAiGS2CwsP5K4yTSVJPg0V6G/S7DNcnZKA7Q2J9pfObkHUwuS
         ORRW3TEEIc23aIU6ja1EDPO6qOGZajfleBUrgsd/b2J/gxbVQTW1cU8jhywm3QW1hqUi
         FRVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693474856; x=1694079656;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SZqHYqF36xqTce0S2Q/nX6iXYvL6nhQhwVC7ut1ep7Q=;
        b=WlytuJ+/jk8fYMGJlLR9kdjuT0mmvdhZ5xN8imrt3u3hby3+S62tjEGVt8N6+7ibg5
         kQdNJBEwyNTia+OZ4DWcC+Dek8qdEAilc+Ea/GBme0/WR6WlkD4Pfx92mRdt4wcgHbeO
         /bYgjLC/Ljlm+WxKxAIYw3/q+5YJxXsV6igrFc1rui16dqWm9FHAbjTeGXEWfPv1Lt+g
         /f4uteUMTODPRDKEHQSmNSVKWjiDqC4d+CHYWJMmyQxytsctVC7KuxolMfaeSCt6lEPE
         rije2GxB8eLCDPlyf4tgoYF6lg8MhtF906MIZlM8jOLzqeROHnEdRTb/gJiMP3eSrc/o
         wrTA==
X-Gm-Message-State: AOJu0YyD65Qnn0ufvT/HQNlX7c6beChTFdToH09FWtLAHJuWQ1gs8osT
        4S81kf9+e/dGDIEXgEeXvYPAq80FwVowXJLaztY=
X-Google-Smtp-Source: AGHT+IGT2XUHr2D7YZc7S7byvkc9BouQ4tqvenAbhOBLeQMaFAlyil+lBgd2GCE+QtP+NFKjqsNUUwVoBVst+LzvK1Q=
X-Received: by 2002:a67:ee88:0:b0:44d:590d:28a7 with SMTP id
 n8-20020a67ee88000000b0044d590d28a7mr901658vsp.8.1693474856299; Thu, 31 Aug
 2023 02:40:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAA85sZsLFsThq4jz1gx0UZj5ab+6SUbhPxy+gsM1d7o2S49LdA@mail.gmail.com>
 <86o37onn-8431-noor-1p0p-8764n0855n74@vanv.qr>
In-Reply-To: <86o37onn-8431-noor-1p0p-8764n0855n74@vanv.qr>
From:   Ian Kumlien <ian.kumlien@gmail.com>
Date:   Thu, 31 Aug 2023 11:40:45 +0200
Message-ID: <CAA85sZvuN5f4Lf3VxOe1Dj9-gq=gD9z4_DwPN_CedJiNeviNsg@mail.gmail.com>
Subject: Re: MASQ leak?
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 31, 2023 at 11:33=E2=80=AFAM Jan Engelhardt <jengelh@inai.de> w=
rote:
> On Thursday 2023-08-31 11:14, Ian Kumlien wrote:
> >
> >Anyway, it turns out that netfilter masq can leak internal information.
> >
> >It was fixed by doing:
> >table inet filter {
> >...
> >       chain forward {
> >               type filter hook forward priority 0
> >                ct state invalid counter drop # <- this one
> >
> >It just seems odd to me that traffic can go through without being NAT:ed
>
> MASQ requires connection tracking; if tracking is disabled for a connecti=
on,
> addresses cannot be changed.

I don't disable connection tracking - this is most likely a expired
session that is reused and IMHO it should just be added

> >And since i thought it was quite bad to just drop internal traffic
>
> Now you know why drop policies are in place in every serious installation=
.

I have never had to use this to prevent internal traffic from getting
out in a non-nat:ed state.
Not with ipfw, ipchains, iptables - I have never seen this behaviour
before, not in 25 years..
