Return-Path: <SRS0=JGmF=W2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0A7CC3A5A4
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Aug 2019 09:22:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABFDA23426
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Aug 2019 09:22:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hFOmsp/j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbfH3JWA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Aug 2019 05:22:00 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37146 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbfH3JWA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Aug 2019 05:22:00 -0400
Received: by mail-lj1-f195.google.com with SMTP id t14so5838644lji.4
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Aug 2019 02:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=tRIeVnvETC6NjXDsJ4Lr4ZfSK5WWA0WOEp6eXc6ux5M=;
        b=hFOmsp/jxvP+FMIIueDFzaLpvEtalI4lcoz703tdlLB2UrYCeDq2UnEZFdih48YIKF
         A227bpWIGtbIl0qNJKQDY6H/woR00LBsY1v9wbfW/T6d/pBtT8D3WDx67Z3OLs2XKmuf
         2BnYSVnkzVqjhbDIiWr3e+Px9J82AL6xv6OCk46kHDCoBAVE9D1TJhhKUlX964shpeB/
         PkwTP0ceLhZuwia/GYzdYhGwSGl6DH2RyVFQ393S0VNxnetU6UhrlUQY7TAxAUOrO191
         l3nPd8HHslmQfpTRQw+/gZziZFe0AiueguPJIVWeayzk+7ssoEdgaK6jp81BSDT/YJzY
         3ymQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=tRIeVnvETC6NjXDsJ4Lr4ZfSK5WWA0WOEp6eXc6ux5M=;
        b=NGqq8cZriz0qna35MIUcFU/zb4kRREj2L/Q8LeMnetvZmrAuUd3Ct0hPRb5doD1fdf
         FH1eNs0EjbjW+oVImtoLa5FgSbrMDhn7OW8hEnMDl/gwAnAcFdpw98QkrB/2nuU76E6j
         q6IsJOmnvRjs8cI2E1uF1S2X+jQ8kib4roXWI81JHh01A1VhWKSNYeKkCIpbCvZ8UKui
         7gmbTTnsQKVIiDLO/2Bv3MxinhZQ7Tfe5ORz7ZgnA98bSAYgF3uRLuSrHi12dqqL6l3R
         G+79NU45BC320Dud/VqXBFLD3boGOV/zp1y/j/Ryt4XVssNdneGL6dqXP+UmuxG/UnU+
         36mA==
X-Gm-Message-State: APjAAAXj+y0AAg9Crlg6W1TV3qTzFqylxd+JH+reMdeilL59iu3kRtAp
        gWGbIFhrUP/VOgL4fP5sNmw8E6ObM+bhffm5tD8=
X-Google-Smtp-Source: APXvYqxshgANs6rXYYK58CG9SywHm2DIRpfHGQ433dTyOP9nMMTXWTJWGnnpRLzNd4k3zun25dcTk2kIoarG5/+DoGM=
X-Received: by 2002:a2e:80c2:: with SMTP id r2mr8137094ljg.44.1567156918489;
 Fri, 30 Aug 2019 02:21:58 -0700 (PDT)
MIME-Version: 1.0
References: <1567090431-4538-1-git-send-email-alin.nastac@technicolor.com> <20190829163038.hfjqzj6gmaqgarxf@salvia>
In-Reply-To: <20190829163038.hfjqzj6gmaqgarxf@salvia>
From:   =?UTF-8?B?QWxpbiBOxINzdGFj?= <alin.nastac@gmail.com>
Date:   Fri, 30 Aug 2019 11:21:46 +0200
Message-ID: <CAF1oqRCFK1kDa9kfucgJCgt0QCU7ySrnCTujxCVKinP=u0RdwA@mail.gmail.com>
Subject: Re: [PATCH] netfilter: reject: fix ICMP csum verification
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 29, 2019 at 6:30 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Already fixed upstream?
>
> commit 5d1549847c76b1ffcf8e388ef4d0f229bdd1d7e8
> Author: He Zhe <zhe.he@windriver.com>
> Date:   Mon Jun 24 11:17:38 2019 +0800
>
>     netfilter: Fix remainder of pseudo-header protocol 0

Yup, discard my patch pls.
