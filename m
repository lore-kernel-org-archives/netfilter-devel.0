Return-Path: <SRS0=DvnY=7P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5761C433DF
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Jun 2020 00:13:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9183E207D8
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Jun 2020 00:13:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="r3F0Yufx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728948AbgFBANJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Jun 2020 20:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbgFBANI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Jun 2020 20:13:08 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25018C061A0E
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Jun 2020 17:13:06 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id l27so11001467ejc.1
        for <netfilter-devel@vger.kernel.org>; Mon, 01 Jun 2020 17:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qqqITfqOQD5z9QhmRX7NCWEf7tf1iSMF39hGZx9DvEM=;
        b=r3F0YufxGWPJG3Bj5yD80LnnxmvODvTth47rwr7Mk83GwfRJujDbphRXr7xNzT4Sq0
         T1Zmr/DY1olPuV7VBx89UIBY8MaNiVFSNR3m5Hu67Y/iGeH1QeygsND2HS+K4EQH0F6S
         lqhpOl+mOZYOBey6sxiZv9SIUaIaWzmPtLu+PzNyPN1hnDCiahCxBP4kkJdep0nWqxwi
         7nXLqw+O1Bwh4/wMR74z1mnBksFXiOCNb7HvbifC6BuZJ0FtfV2kJr112P2ILhybgYRr
         c7J/M7wRLuevhK57vy/egZ5qqRPi3VXBpObPWow2F5hz4TmcOx5UWr39nyMM6LexRzAq
         PqNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qqqITfqOQD5z9QhmRX7NCWEf7tf1iSMF39hGZx9DvEM=;
        b=O1RZJtyAwCmX2vsJB9kNKXtqKQ/GaY9Jj81FFA8DprtsGIGf4y+tk09cPa+Y7srapo
         x4pxcadbuXco6KZ6oUAvfyYMniWoJHXhYllKP5LWJnU4OpT3E0/8u0c52D4AvhUKlRvL
         DyKkLuVuNQtLFi5PuI5JWTWJ/h4J5CpWEUnJx3FK0VSHaXSXpb0dUlZaxq3QvV4qmihI
         utpcR34l15dJGos65w+JhmQL0Fo7Khv62v6AdygJhGGK8G/bAzLv2Kgc9/1B/4lHWYS3
         yzAlVeeoJDf3PYDPlvHmyqsY6VtEBbhm8xnJTWrc8/bct67LCcscnMw3HHfkk73+UBru
         UzJQ==
X-Gm-Message-State: AOAM533O5hvBzDZDFmQtrXLb+Eyb+2XqEYPt1b6zQ3FuLDMaCpXirLmJ
        qcGS0KoGw15We/m2fLv9J3RvTDz668mLpQXXaw21
X-Google-Smtp-Source: ABdhPJyjo/1xbhembiHYk1bpR6ZYlE+1/8DP46ro6Yi5JVwnRrrFOIjFDqCwcirqjmh5xeb51EgkGN0Phf0wn44S90Y=
X-Received: by 2002:a17:906:e257:: with SMTP id gq23mr2187872ejb.398.1591056784766;
 Mon, 01 Jun 2020 17:13:04 -0700 (PDT)
MIME-Version: 1.0
References: <d45d23ba6d58b1513c641dfb24f009cbc1b7aad6.1590716354.git.rgb@redhat.com>
 <CAHC9VhTuUdc565fPU=P1sXEM8hFm5P+ESm3Bv=kyebb19EsQuQ@mail.gmail.com> <20200601225833.ut2wayc6xqefwveo@madcap2.tricolour.ca>
In-Reply-To: <20200601225833.ut2wayc6xqefwveo@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 1 Jun 2020 20:12:52 -0400
Message-ID: <CAHC9VhRnM78=F7_qd8bi=4cfo=bZj_K9YFe1KM2nYRqJiLbsRQ@mail.gmail.com>
Subject: Re: [PATCH ghak124 v2] audit: log nftables configuration change events
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, sgrubb@redhat.com,
        Ondrej Mosnacek <omosnace@redhat.com>, fw@strlen.de,
        twoerner@redhat.com, Eric Paris <eparis@parisplace.org>,
        tgraf@infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 1, 2020 at 6:58 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-06-01 12:10, Paul Moore wrote:
> > On Thu, May 28, 2020 at 9:44 PM Richard Guy Briggs <rgb@redhat.com> wrote:

...

> > > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > > index 4471393da6d8..7a386eca6e04 100644
> > > --- a/net/netfilter/nf_tables_api.c
> > > +++ b/net/netfilter/nf_tables_api.c
> > > @@ -12,6 +12,7 @@
> > >  #include <linux/netlink.h>
> > >  #include <linux/vmalloc.h>
> > >  #include <linux/rhashtable.h>
> > > +#include <linux/audit.h>
> > >  #include <linux/netfilter.h>
> > >  #include <linux/netfilter/nfnetlink.h>
> > >  #include <linux/netfilter/nf_tables.h>
> > > @@ -693,6 +694,14 @@ static void nf_tables_table_notify(const struct nft_ctx *ctx, int event)
> > >  {
> > >         struct sk_buff *skb;
> > >         int err;
> > > +       char *buf = kasprintf(GFP_KERNEL, "%s:%llu;?:0",
> > > +                             ctx->table->name, ctx->table->handle);
> > > +
> > > +       audit_log_nfcfg(buf,
> > > +                       ctx->family,
> > > +                       ctx->table->use,
> > > +                       audit_nftcfgs[event].op);
> >
> > As an example, the below would work, yes?
> >
> > audit_log_nfcfg(...,
> >  (event == NFT_MSG_NEWTABLE ?
> >   AUDIT_NFT_OP_TABLE_REGISTER :
> >   AUDIT_NFT_OP_TABLE_UNREGISTER)
>
> Ok, I see what you are getting at now...  Yes, it could be done this
> way, but it seems noisier to me.

I'll admit it is not as clean, but it doesn't hide the mapping between
the netfilter operation and the audit operation which hopefully makes
it clear to those modifying the netfilter/nf_tables/etc. code that
there is an audit impact.  I'm basically trying to make sure the code
is as robust as possible in the face of subsystem changes beyond the
audit subsystem.

-- 
paul moore
www.paul-moore.com
