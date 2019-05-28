Return-Path: <SRS0=QEZg=T4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38D36C04AB6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 14:15:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09E6221530
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 14:15:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NXPSfe3C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbfE1OPt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 May 2019 10:15:49 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:44899 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfE1OPt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 May 2019 10:15:49 -0400
Received: by mail-oi1-f195.google.com with SMTP id z65so14350088oia.11
        for <netfilter-devel@vger.kernel.org>; Tue, 28 May 2019 07:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=g8zmIhXwHmOwMdeIMEAgo4iqghfndbaGzd7l0HswZ0U=;
        b=NXPSfe3C+6vPduhT9XevxzMF+XpWWq+/02Jdy57qMqpQEjsdUoLNi5suRExQwj4vaf
         BvqlELSHjuvmlQpX/0c086wCJlkQqy1pv2y/71TQjdYhHFROW+6eyH1rrwDxri3hjgTf
         zBpYKF1dA8n/eBF0C6FhVDqdR8f9YhDHF2uA3lfSjqsUfYm81IafGU3bQGJQnoGJqDBU
         QN4+duc42eymoIuYJRDDZM4tUlhBYCb3KtT9sjD5v6Mj6/mDgtNNkz5eQUzWNhQSv/O9
         V56/koIOOfs2xGPKcnvQwmgxKgdLC9lYU6Ne6gI7NedYHV0G+3ERWuf4plUJc2ldUQAI
         0SXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=g8zmIhXwHmOwMdeIMEAgo4iqghfndbaGzd7l0HswZ0U=;
        b=E0geh5jj5y8DDs8VR2P4CxzlER0sUVVmzibG+YdZMrMuynewVs7/80RsntcZmsyVA+
         5b2KTM89ChI+JVSnQ3tDowN8IAbUD4dx4sZjiZuc8Dfa/P7Dsf+TvzPhVepNJc27krQ6
         4JUIIqgkcIj8YlhGy94VeUMS7LAJiaSPd5OLUNvSE0MRE8Jpd5H52+SsySNrtvnhRkvr
         GnJtrzHEZWvhk+9hm9O9JfS2cXk9ta3HSkLpEXh8sr1o9LbWdJA1uuNkH8aUzf0eLZUu
         mFKPJr83Jj+enIiPND7U1Jl4biX8evrdZ8+aq4e1XHhDVM4XzJb6uwXA9CEhhUG1jd6O
         0G4g==
X-Gm-Message-State: APjAAAUxyDaDw0kYnyaterKnFtlOIwQGhsEi9cXkxmXI/nJqELdsoH6C
        goFIaYgVvlBei+83sa7exb3sYv3JnjoW6oyK6lA=
X-Google-Smtp-Source: APXvYqxrmFuzN+VsPzJOOJMb7WM0Zfti9kLwsyRM8cxvchFkdL+AR/kKJyrxwsfEN5BYGrBcd2DJW198gw/9gCfdzpo=
X-Received: by 2002:aca:1014:: with SMTP id 20mr2631831oiq.105.1559052948869;
 Tue, 28 May 2019 07:15:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190524184950.468164-1-shekhar250198@gmail.com> <20190528140956.yumy2xfl4edypdba@egarver.localdomain>
In-Reply-To: <20190528140956.yumy2xfl4edypdba@egarver.localdomain>
From:   shekhar sharma <shekhar250198@gmail.com>
Date:   Tue, 28 May 2019 19:45:34 +0530
Message-ID: <CAN9XX2rYE2haL5u6P+19rMFcDe5VcdCJuAyvHRNQgiNRrhLwXg@mail.gmail.com>
Subject: Re: [PATCH nft v1 ] py: nftables.py: fix python3
To:     Eric Garver <eric@garver.life>,
        Shekhar Sharma <shekhar250198@gmail.com>,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 28, 2019 at 7:40 PM Eric Garver <eric@garver.life> wrote:
>
> On Sat, May 25, 2019 at 12:19:50AM +0530, Shekhar Sharma wrote:
> > This patch converts the 'nftables.py' file (nftables/py/nftables.py) to run on both python2 and python3.
> >
> >
> > Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
> > ---
> >  py/nftables.py | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/py/nftables.py b/py/nftables.py
> > index 33cd2dfd..badcfa5c 100644
> > --- a/py/nftables.py
> > +++ b/py/nftables.py
> > @@ -297,7 +297,7 @@ class Nftables:
> >          val = self.nft_ctx_output_get_debug(self.__ctx)
> >
> >          names = []
> > -        for n,v in self.debug_flags.items():
> > +        for n,v in list(self.debug_flags.items()):
> >              if val & v:
> >                  names.append(n)
> >                  val &= ~v
>
> Are you fixing an issue here? I don't think the conversion to list is
> necessary. The dictionary view can still be iterated. The dictionary is
> not being modified.

Yes, when i compiled the code with python3 in my computer, it ran
without the conversion to list
but when i used an online compiler, it complained about it and i read
online that methods like .items and .keys()
do not return iterables in python3 as they do in python2.
I think the conversion is not necessary. We can omit it.

Shekhar
