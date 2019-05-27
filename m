Return-Path: <SRS0=Tdmq=T3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11763C04AB3
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 May 2019 22:06:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC0CF2081C
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 May 2019 22:06:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e3KdQf74"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbfE0WGg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 May 2019 18:06:36 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:42025 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbfE0WGg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 May 2019 18:06:36 -0400
Received: by mail-oi1-f193.google.com with SMTP id w9so12774693oic.9
        for <netfilter-devel@vger.kernel.org>; Mon, 27 May 2019 15:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=E0AF4FVQn3II6jPQBRZqDgvR8X78NB7Ozg9CUl8FFV8=;
        b=e3KdQf74II50K1xU3Qua3kNEgdhhPSpRSl1iLNo5Il9sA8APYF04v3X+PWm9kLDIpF
         pnydPlnm/tPUOAOqFbjKPYw2jxIez218SBmKnNGqQpDgHvZg5C8GyMkB220JRMpsT2Ol
         CiTDyU+ncXye5Q/MwUXTkJ5acQS74K5mi0KGLurZXBZMjrolmZbQy2CnXiYGQDR6lEDR
         HyV49pCAcJ4VVM5z9WULb1XA4RYsYKPm7DrCHS0XPzpHyOUrQRRT5fW2TwKWaFcUhPkX
         1UOlMiqo0yt6u5taUzNhBOwxQH644F1F0eXNDKCdsLBvagxXV+bQ+fE9aUTkuLZTVV6M
         oyWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=E0AF4FVQn3II6jPQBRZqDgvR8X78NB7Ozg9CUl8FFV8=;
        b=p8a7c7HR17dUW9DpXMqPBYS8ahNW1pw3MvAttME1Y9zk+nRt51Wdf9CKyZbFP8isO2
         5tSFCX4WsKvx3Jzbf7lJ+F8bazDu+zJBwI2opXvOAssWnUGaoBfBAJ8V4Ayddf6X5CNj
         5GsV4SWvuei+bEg791952avv06tpB/qqV4j0iZs3v+j1bapyoIRq0TL65ke80OcnpQaB
         bNaHpzL0n5cvDtLC5D+UYWvAbPzosLNIG4AQqbh/sQy4wySGJ4RB/BKUh1bS+rkr2xGc
         1GJpkSb3w9GEgwlb+7rOKMbEhF9CQOcZ4I5gf9VXwSpzmP7gJULKpQw4sVXaZvrDoTkY
         JFIA==
X-Gm-Message-State: APjAAAUY8RjusmQT/5m4Xokh7HxXVfU5Ak/TESST9iJrzJEGYCF6xJc3
        WEGTaVzIIZjhyi8NAgY+E+Mo46spjeO5iF/gkxj2vozm
X-Google-Smtp-Source: APXvYqzr2vu6j6ob7KCz1o4KOY1xVaqjG5DxjQlrPKE9VrgjPSedcU0Uusj3rkMRJ5+7azU5rRs/h0axDoWs3MDzFY0=
X-Received: by 2002:aca:4202:: with SMTP id p2mr707966oia.85.1558994795302;
 Mon, 27 May 2019 15:06:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190524200206.484692-1-shekhar250198@gmail.com> <20190527160415.GZ31548@orbyte.nwl.cc>
In-Reply-To: <20190527160415.GZ31548@orbyte.nwl.cc>
From:   shekhar sharma <shekhar250198@gmail.com>
Date:   Tue, 28 May 2019 03:36:23 +0530
Message-ID: <CAN9XX2oh4ZYwuO1o-fWNzAUAP6gsyq8pvgJ8F1mHzB7Boj=C6Q@mail.gmail.com>
Subject: Re: [PATCH iptables v1] iptables-test.py: fix python3
To:     Phil Sutter <phil@nwl.cc>,
        Shekhar Sharma <shekhar250198@gmail.com>,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Mon, May 27, 2019 at 9:34 PM Phil Sutter <phil@nwl.cc> wrote:
>
> Hi,
>
> On Sat, May 25, 2019 at 01:32:06AM +0530, Shekhar Sharma wrote:
> > This patch converts the 'iptables-test.py' file (iptables/iptables-test.py) to run on
> > both python 2 and python3.
> >
> > Do we need to add an argument for 'version' in the argument parser?
>
> You should insert questions between the '---' marker below and the
> diffstat. This way they won't end up in the commit message.
>
Sorry, will write the questions like that from now on.


> Regarding your question: Assuming that iptables-test.py really is
> version agnostic, why should users care which interpreter version is
> used? Do you have a use-case in mind which justifies making the
> interpreter version selectable via parameter?
>

True.
I don't have a use-case in mind right now.

> [...]
> > @@ -79,7 +80,7 @@ def run_test(iptables, rule, rule_save, res, filename, lineno, netns):
> >
> >      cmd = iptables + " -A " + rule
> >      if netns:
> > -            cmd = "ip netns exec ____iptables-container-test " + EXECUTEABLE + " " + cmd
> > +            cmd = "ip netns exec ____iptables-container-test " + EXECUTEABLE + "  {}".format(cmd)
>
> Please respect the max column limit of 80 characters, even if the old
> code exceeded it already.
>
Sorry, will correct it.

> Thanks, Phil

Thank you for your comments!
Shekhar
