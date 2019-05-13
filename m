Return-Path: <SRS0=R8c+=TN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B472C04AB1
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 May 2019 06:01:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AF2320879
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 May 2019 06:01:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YQsLCr/l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbfEMGBF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 May 2019 02:01:05 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:40250 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfEMGBF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 May 2019 02:01:05 -0400
Received: by mail-vs1-f65.google.com with SMTP id c24so7254959vsp.7
        for <netfilter-devel@vger.kernel.org>; Sun, 12 May 2019 23:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=f2S/a/HjXEYn+29hCO8NH/dSusH4CPHMyv+HvMpdsk0=;
        b=YQsLCr/loFaS9AqUIlTx3Iv+BfI5ljQWnas/C0INXOGUu1DTnLK6Q0fQPVnoUjn8Dm
         jyddIGVqSHgonNBQ0V5kgBec3j7zle7tRkOJaIPUpToF9PM0wSfGyOCphvySCxRqLa4e
         zB6ufhY5sqVNzBcEFEZmxsR7edubK1jZqC/ROsDSeIIs2F845bGQZNfobkGbXQ08BjrH
         HwREE2htiWhZdDDpcBSFd8BD0QLiJVd3JtZIFclagEWGT5RxIbkC8vOoYK70Ok9SPIhC
         bVp6EAzfrNzQelHHb8KGFHcbEOALBgC97AILK+y5/KS00+XgTxRVqeVpiw7qw7agB+L5
         i66g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=f2S/a/HjXEYn+29hCO8NH/dSusH4CPHMyv+HvMpdsk0=;
        b=X6xWzX0NW0702csLgbmwlCiy1mjbhDsP79YQzGRK2LmeByI+TaRSTm1lJwpL2R+W3M
         U9OkxUbOyvcPH9RKMs8PAC4h/sdbJE+df0VKVnjZWimqDkuHu/Rb+H1o4astAY2RPgeE
         rM8yjqZw8c4i0S3D+UpRdXUkD5hqgoyIx1Ni5vG1hVc1HQ1b7tEp4NKvswGF7kIqu74t
         7P67Clm2con1BksWA/g+ftKP24JVJtmJJMA+jQEUaxc3wQ92PTz0SdTe1ji9EXieb/Ma
         g7kxbf4KBUI8lixdX873SBqC//vv3zqWyfPyjxqWatWSvdRQSTbJJB9Wy7Jl8YK3zxEV
         RDsw==
X-Gm-Message-State: APjAAAUQTlQWZZ70vR4QBI89ynbn5k/ZRr37jfLxSkYRhFF5ZOGrCXEE
        4N+sRKv5uayV/LAWdNPm41GT07syQWCr7HHjwWBVuA==
X-Google-Smtp-Source: APXvYqwg27/Px0oeoV6RTedm/CnIc+IFVkGkyzjsllFuLmcClyddmfCJiT9oltMhtoBJQnppkhMjiJg9RJBxWuAdWLY=
X-Received: by 2002:a67:14c6:: with SMTP id 189mr12996738vsu.203.1557727264127;
 Sun, 12 May 2019 23:01:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190505154016.3505-1-sveyret@gmail.com> <20190505225114.pwpwckz2oauskkrf@salvia>
 <CAFs+hh4Cq3kbJPVtn080KknAP5d3w8V5zcx9AGV800EN8d9G=w@mail.gmail.com> <20190512175651.uiatuot33dtzhglw@salvia>
In-Reply-To: <20190512175651.uiatuot33dtzhglw@salvia>
From:   =?UTF-8?Q?St=C3=A9phane_Veyret?= <sveyret@gmail.com>
Date:   Mon, 13 May 2019 08:00:53 +0200
Message-ID: <CAFs+hh6emDCoyuE_KpxX_2U5kFT=q3CwUUp_dB887Grq8Lcf5g@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nft_ct: add ct expectations support
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le dim. 12 mai 2019 =C3=A0 19:56, Pablo Neira Ayuso <pablo@netfilter.org> a=
 =C3=A9crit :
>
> > But I actually saw today that these values are used in the =C2=AB nftab=
les
> > =C2=BB project. There is a copy of nf_tables.h there. Not sure it is a =
good
> > idea to keep the variables in =C2=AB nftables =C2=BB and not in kernel.
>
> I have just updated the cached copy of nf_tables.h in
> git.netfilter.org:

So now nftables does not compile anymore, does it? What do you think
we should do, then? Add a new variable, out of nf_tables.h, in
nftables project?
