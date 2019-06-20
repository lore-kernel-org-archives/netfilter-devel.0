Return-Path: <SRS0=UCdS=UT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFF86C43613
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jun 2019 17:38:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B541E206BA
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jun 2019 17:38:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pR/m5erP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbfFTRib (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jun 2019 13:38:31 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:33309 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfFTRia (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jun 2019 13:38:30 -0400
Received: by mail-ot1-f68.google.com with SMTP id i4so3625882otk.0
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jun 2019 10:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U/EZJPhu/yinqyk+iVh3V3UyUvvQIfxBK8wGcKE7EJM=;
        b=pR/m5erPoYvu8qWtr0NyxzXoYV1rJDwKtt9zRC5OFL882lZFzkuUjhgGpJ5yGJF02Z
         Q2+1RcMfoKt8iRv6BMHxiAqob7rpjYYbx7naOe/cmSETbeK1HeJuPLXPbmjj0KELIfHM
         unUXPVViOT4fUNdRzdSYaqr4Eq1CnQMtK0tTmHUQiERvjdYnp0ilsQFPb4fOBR9+8BNZ
         6UiNVpdNIfvEE0CPBbWa2ZqhkDnM9OW9FRoinJEIn7NYkfQCzjZHQCFjwhZDwEeFHM2M
         aV4rt4S1g0zQTO8ezHIMAodfTaC+MvQpAYVrbKbytuxK3ZxJpC19dkkI/cXQemYuE0BH
         Ld4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U/EZJPhu/yinqyk+iVh3V3UyUvvQIfxBK8wGcKE7EJM=;
        b=VgxkjHvzX3Ey5kuOGLLlpaTyByk4U1ZHR34UPDUcN+Z989Lx5ZKr2X++N30asVMyYi
         4cEYOg0mZ6zfH7FFkLY9LFShxpWqcdLUb5XeSIq35qt4Ca80hfgHkfKz4Y736otlEhzh
         4mNlsCSfOFi6MLJr2Ci1Gp4FcNGGK5sVTsNIqr506uNyWk25fQlZJOJNQaZA/ilRRkOm
         gjF5uBcxhaMPDLRiV9uUGvLgVTh397I0xcvn6kTQeMurZyAbBGBY0VjbMLTBxYTS/e58
         efKh+JQ4PYlJvSnu3ICxbkyz8pVLuzl8HyDlOf7vFU3orp6EmY613zbHBPmwz91QDGBB
         I3ug==
X-Gm-Message-State: APjAAAUEsF0/l4O04Wa59Rb1nnVI4kB+1phfAr7IJvKhk4M7yzawuvfB
        +0r3dCfcGqO80VMtTk09ZTRMuc/nqptLL98qwdtTl1pg
X-Google-Smtp-Source: APXvYqz9pXJ8CBVhNjn9DkwHLHyAi5RWBy08Mm7zCMXNPQN0Tb2hr5upAKQLMhMiigvUFDsIbI8pVLS+gJCrvlaeKX4=
X-Received: by 2002:a05:6830:1394:: with SMTP id d20mr14409458otq.155.1561052309816;
 Thu, 20 Jun 2019 10:38:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190619175741.22411-1-shekhar250198@gmail.com> <20190620143731.jfnty672zi7rcxgs@salvia>
In-Reply-To: <20190620143731.jfnty672zi7rcxgs@salvia>
From:   shekhar sharma <shekhar250198@gmail.com>
Date:   Thu, 20 Jun 2019 23:08:18 +0530
Message-ID: <CAN9XX2r6FK6gn7X7i6krWOwaFTiad5OVQybT+qMYbuW1iFY1qQ@mail.gmail.com>
Subject: Re: [PATCH nft v9]tests: py: fix pyhton3
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Eric Garver <eric@garver.life>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 20, 2019 at 8:07 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Wed, Jun 19, 2019 at 11:27:41PM +0530, Shekhar Sharma wrote:
> > This patch changes the file to run on both python2 and python3.
> >
> > The tempfile module has been imported and used.
> > Although the previous replacement of cmp() by eric works,
> > I have replaced cmp(a,b) by ((a>b)-(a<b)) which works correctly.
>
> Any reason not to use Eric's approach? This ((a>b)-(a<b)) is
> confusing.

No, Eric's approach is also working nicely. I read on a website
that cmp(a,b) of python2 can be replaced by ((a>b)-(a<b)) in python3.

> > Thanks!
>
> BTW, strictly place your patch description here.
>
> Things like "Thanks!" to someone specifically and the cmp()
> explanation should go below the --- marker, like versioning.
>
OK. Will take care of that in the future.

> BTW, Cc Eric Garver in your patches, he's helping us with reviewing :-)
Sure :-)

Shekhar
