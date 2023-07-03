Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33CB9C001B1
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Jul 2023 14:42:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbjGCOmx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Jul 2023 10:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbjGCOmu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Jul 2023 10:42:50 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04CE10E0
        for <netfilter-devel@vger.kernel.org>; Mon,  3 Jul 2023 07:42:42 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 41be03b00d2f7-54290603887so2303986a12.1
        for <netfilter-devel@vger.kernel.org>; Mon, 03 Jul 2023 07:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1688395362; x=1690987362;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DrA308we96oVwz/kgmxRDcKXJtyEBbepsNUANAmoIY0=;
        b=Ipef32BA2RNaBK8hQFCP5rn7/iZ5F+7/2ITqgBNoT//Pyxpw5oJDZHImVjcaj/f9cr
         oBov6aTuCU/uWiIANJI0IGAVCGW2NceXrknYsmfRXoEStDWuLTlj0WO1coDT98FpDZpd
         OoSbiBIH1+0SnVorEzx6R15ihrj8UvThvWlRA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688395362; x=1690987362;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DrA308we96oVwz/kgmxRDcKXJtyEBbepsNUANAmoIY0=;
        b=kqDOLWe1C+QQqGdXycSbIb631mo1UdfUZ1Gewbbl6hqW0FxIxr4nglKB5Q7UKCyXnC
         hlFVulXmseD7CJdcyZibf5BZqCHIhCUBih0q8AhpJvy9wn7k3ARWG7kgRAz2H4RPfZxP
         di05EMqhSczYDuCvtpw127hxccT4gXkk203jv6PO8tPuooGB9x9Cb5gDHfj93wLzA19d
         rab37Ii1KkXVPNJh6LSG9Hv0JVf0KaqMUsV3mFL1TRLwKYtGe9I3W39AixmrLgMv965v
         AHdLOCoz0/+nUiYRudgKCxVplieWEbXVhSGqv3QmwN97LOq8H7Crubwlmt//MwOYjs2L
         JIoQ==
X-Gm-Message-State: ABy/qLZSix0NEiItHLygZvpGsRz1UH0QSoL7jdqddSFbZ4wH28yAQDz1
        zOLMl7Bxhp4XkmCYxKDIijiMCv6Zbr1Q1DAl9Spb4w==
X-Google-Smtp-Source: ACHHUZ5mTAPpxbNhYNSgpszF3WnuYH2PV51tm62xSaVgy4bpo+CAIhriuYCoo7xWSfATi1JfQBwW7sG7ccxjqSs1lls=
X-Received: by 2002:a05:6a20:a128:b0:11a:c623:7849 with SMTP id
 q40-20020a056a20a12800b0011ac6237849mr10155512pzk.48.1688395361920; Mon, 03
 Jul 2023 07:42:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230615152918.3484699-1-revest@chromium.org> <ZJFIy+oJS+vTGJer@calendula>
 <CABRcYmJjv-JoadtzZwU5A+SZwbmbgnzWb27UNZ-UC+9r+JnVxg@mail.gmail.com>
 <20230621111454.GB24035@breakpoint.cc> <CABRcYmKeo6A+3dmZd9bRp8W3tO9M5cHDpQ13b8aeMkhYr4L64Q@mail.gmail.com>
 <20230621184738.GG24035@breakpoint.cc>
In-Reply-To: <20230621184738.GG24035@breakpoint.cc>
From:   Florent Revest <revest@chromium.org>
Date:   Mon, 3 Jul 2023 16:42:30 +0200
Message-ID: <CABRcYmKkDyMBqe0C5AGZVihGQhXzCjsQrg5fBhtTX3qjxe7jOA@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: conntrack: Avoid nf_ct_helper_hash uses
 after free
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, kadlec@netfilter.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        lirongqing@baidu.com, daniel@iogearbox.net, ast@kernel.org,
        kpsingh@kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 21, 2023 at 8:47=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> Florent Revest <revest@chromium.org> wrote:
> > > in this case an initcall is failing and I think panic is preferrable
> > > to a kernel that behaves like NF_CONNTRACK_FTP=3Dn.
> >
> > In that case, it seems like what you'd want is
> > nf_conntrack_standalone_init() to BUG() instead of returning an error
> > then ? (so you'd never get to NF_CONNTRACK_FTP or any other if
> > nf_conntrack failed to initialize) If this is the prefered behavior,
> > then sure, why not.
> >
> > > AFAICS this problem is specific to NF_CONNTRACK_FTP=3Dy
> > > (or any other helper module, for that matter).
> >
> > Even with NF_CONNTRACK_FTP=3Dm, the initialization failure in
> > nf_conntrack_standalone_init() still happens. Therefore, the helper
> > hashtable gets freed and when the nf_conntrack_ftp.ko module gets
> > insmod-ed, it calls nf_conntrack_helpers_register() and this still
> > causes a use-after-free.
>
> Can you send a v2 with a slightly reworded changelog?
>
> It should mention that one needs NF_CONNTRACK=3Dy, so that when
> the failure happens during the initcall (as oposed to module insertion),
> nf_conntrack_helpers_register() can fail cleanly without followup splat?

Sure! :) On it.
