Return-Path: <SRS0=ickv=7I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82945C433DF
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 May 2020 13:37:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58E0A204EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 May 2020 13:37:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uMuPR7nF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729303AbgEZNhH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 May 2020 09:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728126AbgEZNhG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 May 2020 09:37:06 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1A2C03E96D
        for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2020 06:37:06 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id 18so20417213iln.9
        for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2020 06:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vJZOgfruD2sE2Z+pv1SauO+c2pg8/9mKfWnyOu0gu28=;
        b=uMuPR7nFV9QV89EOPdZHZrFWgiFNYflWtPWn7uidR7ySEkq6pv+AE6eiivlGAzRDTp
         7VErFUczFB/GtymHhTqmAaBb0PLytlaKVSVtc9Wc32N+d6ULOv7fTTL+QQGyv4Z2HUpc
         5m0a8Vs5UscjxQ04K55KUosWPrVXaOfgg2TALS0ACtnVQgeqn3EWOFChmcPvTb24pUdV
         f1D70yyuIhSvobPmK0cr9hxOw9krKP4rLtU4heTF1zQRgY9zyPmFBlZwnXGlx5HhD5wQ
         8ei75eAQ/S8KSVpdCgHG3NUUC9ewh2w9cOSqrlcCtj22ec74u3cnveDBMiJryX18Gyc+
         A23w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vJZOgfruD2sE2Z+pv1SauO+c2pg8/9mKfWnyOu0gu28=;
        b=OhDR6sFuF5e8J50fQdAs0jRs2my7kvU5XCZnkYPQEWEcSmB7D+YRMQWqw1SW0v1Odv
         e01jCpWwx+/Y7NAhJ+hYeP4aoWaVEiww16MzQr8/dv3aGGOrI6EAI8GG787Gg7CwjVrL
         8+u9P1eF2B9jvJvw3glSS7Fjfa5bTM+kVbgggJsxqJ/2mreXfwPDWATaI9dX4lQiOhMn
         zIEI/A6xKYSDosCDI8cfPwilhQ2X+/LXzgUbkW+01IAw05clbfiQWqm4b8KKRUlOYi1U
         U4GASZVdx9sOCnT11nlGF1HlgbP7jTUz8atFL78vtrRK+eZPBtEyLWmWf0DOiMZTXgCL
         nuLg==
X-Gm-Message-State: AOAM533+ef1FBfZFD6G2RMn+LBWUYPNlv6aI12oM81L7n7sg521ODKM3
        /ZvQKfWrqC0RqD4J0bf3pJ2mZNpFj6o4nzdGoDtr1kx1
X-Google-Smtp-Source: ABdhPJybThAst3jJMvpmbUUBXNCCNrs2zC1JCi8oFPQTjRklJC1fKtTTUDelvc++foTldM6YAqMP3tGMvJLYywd8UV0=
X-Received: by 2002:a92:9154:: with SMTP id t81mr1126939ild.235.1590500225691;
 Tue, 26 May 2020 06:37:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAOdf3gqGQQCFJ8O8KVM7fVBYcKLy=UCf+AOvEdaoArMAx98ezg@mail.gmail.com>
 <20200506120012.GA21153@salvia> <20200506120909.GA10344@orbyte.nwl.cc> <CAOdf3gr+7SoqF-hzpccqAsN4ejpn+5K_kDP-2bkaqpqh+CLV7Q@mail.gmail.com>
In-Reply-To: <CAOdf3gr+7SoqF-hzpccqAsN4ejpn+5K_kDP-2bkaqpqh+CLV7Q@mail.gmail.com>
From:   Etienne Champetier <champetier.etienne@gmail.com>
Date:   Tue, 26 May 2020 09:36:54 -0400
Message-ID: <CAOdf3gqceU4jSQgd+cdtaT8_Oxqe8Xx0ncRB1VuzBYiRLiobXw@mail.gmail.com>
Subject: Re: iptables 1.8.5 ETA ?
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil and Pablo,

Le mer. 6 mai 2020 =C3=A0 08:40, Etienne Champetier
<champetier.etienne@gmail.com> a =C3=A9crit :
>
> Le mer. 6 mai 2020 =C3=A0 08:09, Phil Sutter <phil@nwl.cc> a =C3=A9crit :
> [...]
> >
> > If above goes well, maybe release next week to leave at least a small
> > margin for any fallout to show up?

Still on track for 1.8.5 this month ?

Best, Etienne


>
> Sounds perfect, I can wait for more fixes :)
> Thanks
>
> > Cheers, Phil
