Return-Path: <SRS0=TR/Z=U2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 013A9C48BD6
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 15:42:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1F3E20656
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 15:42:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LpXi13AF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfF0PmZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jun 2019 11:42:25 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:42894 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfF0PmZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jun 2019 11:42:25 -0400
Received: by mail-ot1-f68.google.com with SMTP id l15so2725762otn.9
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2019 08:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=qyxseQmmTvWlSqOeNW9JwHVZ7ZeibwGbqOoH0asGO1o=;
        b=LpXi13AFq8njmQGLtjcBaTUMI48gufg+HbfFMeX3T/81QS1pUg6TJzhqIwkWWBIxL9
         C18Y0irDQp7atpxljVxBR/sclsPoNYg5w3sqHEYViztfJqhITFlb8sfJjY9QEiGGIhGP
         KrhHF17aiU+ulvQifiJRSMPOpARsS1mGpzkVJV7ursUv3keImGZgYX9MiZYeS1glZAGy
         gdu4Q0OI9R0YN5U7hMvFFiDIs8S4Opnvk7hS1pBTOfPf4hYEDgeZ5S1zgqeHLqZlbHhz
         C3CSI6MApTZ92lhoTtkbstEsuw9QYhk//3l+WFsMQooOcEYZHcMsdIv/xOrFaNFjGMwT
         BF6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=qyxseQmmTvWlSqOeNW9JwHVZ7ZeibwGbqOoH0asGO1o=;
        b=RI9iJ/sbHTpFyixn46cxxvHvlpAFRVjDYsADJQN35TpREyzTTAfvX3nPPpCZYNAx80
         JGB7Ab0dhqKF9nZ+ADVYv+QD5zmiPxj6wzGqbq32HETboix96423dLX3IjiqXBqvZKE6
         FUwsNoxyPDTvHGgMlEHNM3/y/GC5rqr8+5BXEvakzTxDUwog+zqkI0jHke6gGVYmQcdf
         MrGDLYoB99ID7P9nM2nXU/IUMIDUzAXmcP49WE5zQKM/J6iPwdgJfQIuRE5f/v1xaPiJ
         6fKIcLzeHnGYT+f4LZMFz3r+45Zo8u2UnPlMfeegYA1SlNxWdNM1+JO+7i81fV1umeAT
         OW0w==
X-Gm-Message-State: APjAAAWno6S8UKoMJm9Ibrt4UXJNJN2noab65k7ZS7jie348hYMzV3Ii
        m3hgQ+qMGyUmZLZHhToIIjMeJ2ut/sxnQCFYAf8=
X-Google-Smtp-Source: APXvYqxIgLBECallvCmg1nTzDXxoZAvmlC9JskSu4vAW8C3k8FsRrfH1F06m6Ra9r4kwd+CaxuHK5hdJY2ZoVWsdq/g=
X-Received: by 2002:a9d:2f26:: with SMTP id h35mr4092251otb.183.1561650144579;
 Thu, 27 Jun 2019 08:42:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190619175741.22411-1-shekhar250198@gmail.com> <20190627123752.qrlbym6bcnuhtoci@egarver.localdomain>
In-Reply-To: <20190627123752.qrlbym6bcnuhtoci@egarver.localdomain>
From:   shekhar sharma <shekhar250198@gmail.com>
Date:   Thu, 27 Jun 2019 21:12:13 +0530
Message-ID: <CAN9XX2rXKDVkddE0Bcpuy5dH24cGXCA-nbtD4RGi4g0JTVmuLw@mail.gmail.com>
Subject: Re: [PATCH nft v9]tests: py: fix pyhton3
To:     Eric Garver <eric@garver.life>,
        Shekhar Sharma <shekhar250198@gmail.com>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 27, 2019 at 6:07 PM Eric Garver <eric@garver.life> wrote:
>
> On Wed, Jun 19, 2019 at 11:27:41PM +0530, Shekhar Sharma wrote:
> > This patch changes the file to run on both python2 and python3.
> >
> > The tempfile module has been imported and used.
> > Although the previous replacement of cmp() by eric works,
> > I have replaced cmp(a,b) by ((a>b)-(a<b)) which works correctly.
> >
> > Thanks!
> >
> >
> > Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
> > ---
>
> The patch Subject has a typo, "pyhton3". Please fix it on next revision.
Oops! Will correct it.
