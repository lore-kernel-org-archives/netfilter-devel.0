Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D99FCC31E51
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 09:51:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8A982070B
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 09:51:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nfware-com.20150623.gappssmtp.com header.i=@nfware-com.20150623.gappssmtp.com header.b="kTeXw9ua"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbfFRJv0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 05:51:26 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41128 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729268AbfFRJv0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 05:51:26 -0400
Received: by mail-wr1-f67.google.com with SMTP id c2so13201832wrm.8
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 02:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nfware-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uSvNAj/7E9bdyAkRZvsr+LHqWu66xmk6gwC+bAPccvQ=;
        b=kTeXw9uabxAQgF9GAzWZwnNai8+atKKtqGOHfgEtws9HDxrzJJcvAlpTJiZvO57wPw
         9PeyuBWlb6V77wweTEXKqjqGkGaQVytjlEUt5sHYDxoUvfis9OyV0SkqYZSTY15BKEG7
         o44YXnPX2Ih7dqB11kuI7t3lcVNOJAzAfeJTX2gpQ89jY5fpcDddSTm7Iy5Qvu/mRjSN
         Rp7BQgOwzRDzsDa60Y5grD0ki5u1vdaVxoM2j6fj/TtmxIbeJSNE3vMxj1vdgSLm0hVb
         Ni27ed77s5HSc4mhOFuXi2lh2YMsGUB+RGsHcO5NWG6SO4PVdPmNzOHaifsrgwe3WE7y
         kooA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uSvNAj/7E9bdyAkRZvsr+LHqWu66xmk6gwC+bAPccvQ=;
        b=j7EZ2JyQdsbjkhgagvcuS3aXUe77qI/lXFKsB/hKXpjTS/SVOMJhK0WZ8GdukJf/UY
         N5Wx6MJ7AR5tlhQPgdLQvyerzt1h8VRNhksE5DHqi9nw5GW+NgqSqnTPwOoL0Z0sYcV1
         ZBvgp3tSNGbJTkQHQSaBf3bLKOdhfLxj3T4ivC97G0eTOZ7EZ62vGFXLD1gEZ3bWPa0C
         Kr3UeDNSDCrFQkGH9vY4jNm/gAl2NW6NK/JrWusGQ1jXp9zs/PUGJyG+7Gc2TLgj9xHw
         ETZyJOmiatB7r1t+/WdNSIBn7r9tuEOWBs5EqpEaFIYU8X1mEyd3bLZ6VJUNdG5FyD3i
         qRHg==
X-Gm-Message-State: APjAAAXswvMw8wiFrirrk1ZJF6FjgcRLIRwydm1CXpw0XCecNVNfqMeu
        As37+gXhd374AmABRk3wKkUCGmZuu036Ai9r7Yeq18pslPRFMQ==
X-Google-Smtp-Source: APXvYqxiO73ccuUcT6+LRN9yilblofcPoR85cb2ZKM8T8583QjBsGnD5Sy0l3vhdHzZNQM/2YNUAmeVw8El3DLNDmm8=
X-Received: by 2002:a5d:6a90:: with SMTP id s16mr16488890wru.288.1560851483939;
 Tue, 18 Jun 2019 02:51:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190605093240.23212-1-iryzhov@nfware.com> <20190617222507.tzizsd6dfxm6zozs@salvia>
In-Reply-To: <20190617222507.tzizsd6dfxm6zozs@salvia>
From:   Igor Ryzhov <iryzhov@nfware.com>
Date:   Tue, 18 Jun 2019 12:51:13 +0300
Message-ID: <CAF+s_Fx=b07S54_Nr7PpKjHYtwkf55Tw+WztZks5SZXtkxWLHg@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nf_conntrack_sip: fix ct_sip_walk_headers
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

This issue can be seen in the scenario when there are multiple
Contact headers and the first one is using a hostname and other
headers use IP addresses. In this case, ct_sip_walk_headers will
work the following way:

The first ct_sip_get_header call to will find the first Contact header
but will return -1 as the header uses a hostname. But matchoff will
be changed to the offset of this header. After that, dataoff should be
set to matchoff, so that the next ct_sip_get_header call find the next
Contact header. But instead of assigning dataoff to matchoff, it is
incremented by it, which is not correct, as matchoff is an absolute
value of the offset. So on the next call to the ct_sip_get_header,
dataoff will be incorrect, and the next Contact header may not be
found at all.

Best regards,
Igor


On Tue, Jun 18, 2019 at 1:25 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Wed, Jun 05, 2019 at 12:32:40PM +0300, Igor Ryzhov wrote:
> > ct_sip_next_header and ct_sip_get_header return an absolute
> > value of matchoff, not a shift from current dataoff.
> > So dataoff should be assigned matchoff, not incremented by it.
>
> Could we get a more detailed description of this bug? A description of
> the simplified scenario / situation that help you found it would help
> here.
>
> Thanks.
>
> > Signed-off-by: Igor Ryzhov <iryzhov@nfware.com>
> > ---
> >  net/netfilter/nf_conntrack_sip.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
> > index c30c883c370b..966c5948f926 100644
> > --- a/net/netfilter/nf_conntrack_sip.c
> > +++ b/net/netfilter/nf_conntrack_sip.c
> > @@ -480,7 +480,7 @@ static int ct_sip_walk_headers(const struct nf_conn *ct, const char *dptr,
> >                               return ret;
> >                       if (ret == 0)
> >                               break;
> > -                     dataoff += *matchoff;
> > +                     dataoff = *matchoff;
> >               }
> >               *in_header = 0;
> >       }
> > @@ -492,7 +492,7 @@ static int ct_sip_walk_headers(const struct nf_conn *ct, const char *dptr,
> >                       break;
> >               if (ret == 0)
> >                       return ret;
> > -             dataoff += *matchoff;
> > +             dataoff = *matchoff;
> >       }
> >
> >       if (in_header)
> > --
> > 2.21.0
> >
