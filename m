Return-Path: <SRS0=OoGW=RW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FF2FC43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Mar 2019 07:28:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47B2C20685
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Mar 2019 07:28:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MemVbOq+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbfCSH2I (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 03:28:08 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:38066 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfCSH2I (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 03:28:08 -0400
Received: by mail-io1-f66.google.com with SMTP id v4so15835493ioj.5
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Mar 2019 00:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=em0XZTTvsGlwPjxAW21Pf7BHAVyY61/oSag8BU5/pdY=;
        b=MemVbOq+ZJt1xyRuIZvs7SqhXjW1IMRMBvfPZi0fFUl1P67BurAXz0kuGPrhSQuIoY
         MVP3DbxBHNZXxsc8vyrtoIPnsQdIGIU2hfhv50PH9bU2K78xYTZbtFqOx+Ze8Wk5vBt0
         rwJQKEso7sMkfIX5gnsqdfbhlarFPNzGXIObgHf3rkckxlrlaodcHJKGh7rCwzR1CVsx
         IwqrClg0Ffwq/zuIPP9kHjpQGjnfhl6Eq6E8rtzxhr+uwsCuDzFrj016wO903pssHQya
         bIaoK29itj2Ngv4Cv2iNd2gbqXODboCwpcbDpKGjNeT/Zo0vhxlr7Sn31A9NtPtWfZp8
         aYNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=em0XZTTvsGlwPjxAW21Pf7BHAVyY61/oSag8BU5/pdY=;
        b=Vf+YM9yCCJH9MQMyruxmx/eZF5RqgaVDWlYyozdvoXwMr4KgiUxwZqETsWGmPgS8e/
         AphIdhN0A9lfv/XoxR9RBhmTUKHeOsO/MxaljYpjtQxXuoBqhfpjmwksgTQ5f3tAqVZE
         W+GbQfApd9DsAts+wahQ1d6Z+VnKMI9RKqVKrq5m4TcO7QJTE+tB9X7u5jFSHKA5wtsP
         eZZn8YH1FK2LbQQaj7zuJkVf4wVheNsU2Ho+FVqzCblmhRRN/bXLobTl9Bl7A3SGepcA
         ZduTSM5UCj7tpZfnddokVo0OVDxBUjev6d95zNbtYnXdKtLRE9EO5jxKlIC8DjwsDMyB
         F/uQ==
X-Gm-Message-State: APjAAAUxH0SwoaZ/dOFfEvHrwrpVke8y0QoG7ZyKTxTyq1zJmoKcKzzX
        spqzsvYLAzbO88mX0uHo5w/0OFJdc5h10QrqeG9IfAbDwpY=
X-Google-Smtp-Source: APXvYqxB2jt4yDj6TH0BlGH9GAb9hkjGLFufoITDyOir7YqqJK6a5f4NybosoOnndGBFXORfbc/pv/979z+zBUjadKU=
X-Received: by 2002:a6b:5118:: with SMTP id f24mr544833iob.62.1552980487662;
 Tue, 19 Mar 2019 00:28:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190318094745.GA4394@nebula> <CAHRz_yZMsP2RQPu=8pTigq8SrYz9xYSef3S_d4ORAMkkYDEv4Q@mail.gmail.com>
 <20190318105545.qz5oddbjah4qc4fa@breakpoint.cc> <CAHRz_yYk_Yq5+Tp1J1jT2rVT0pHWjH37-F8Rdi1XCLWj79J6rg@mail.gmail.com>
 <20190318220923.5v64yccan6shhpnq@breakpoint.cc> <CAHRz_yY=yrrMJS98s6cq9sRP_nrSNrv5kKCPxKT+BAj_GGS5hw@mail.gmail.com>
 <20190319071705.lyjjd3dqz2zwc6vm@breakpoint.cc>
In-Reply-To: <20190319071705.lyjjd3dqz2zwc6vm@breakpoint.cc>
From:   Karuna Grewal <karunagrewal98@gmail.com>
Date:   Tue, 19 Mar 2019 12:57:56 +0530
Message-ID: <CAHRz_yZe8j_83vTjYXbBHME69Qd=X0XfoR-5A81KoqKqWKP53g@mail.gmail.com>
Subject: Re: [nftables] tests/py: Add Test for `meta time`
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thanks. I checked that in the userspace the enum nft_meta_keys has
additional values as compared to the linux 5.0.2 's nft_meta_keys but
this isn't the case with the nf-next.
I'll run the tests again with the nf-next kernel tree.
Also, does this mean that I should stick to the nf-next kernel tree
instead of the latest kernel release itself?

On Tue, Mar 19, 2019 at 12:47 PM Florian Westphal <fw@strlen.de> wrote:
>
> Karuna Grewal <karunagrewal98@gmail.com> wrote:
> > On Tue, Mar 19, 2019 at 3:39 AM Florian Westphal <fw@strlen.de> wrote:
> > >
> > > Karuna Grewal <karunagrewal98@gmail.com> wrote:
> > > > command: add rule ip test-ip4 input meta time 100
> > > > Error: Could not process rule: Operation not supported
> > >
> > > This means that nft_meta.c doesn't recognize the TIME key.
> > > You need to run the modified/patched kernel for this to work --
> > > it looks like nft_meta_get_init() hits the "default:" switch label.
> > I'm running the tests against the new modified kernel (I've applied
> > the patch to kernel 5.0.2) and when I logged a debug message it
> > confirms that it's indeed hitting the default switch.
> > But previously running nft against the nf-next fork of the kernel was
> > recognising the `meta time`. This leaves me in a bit of confusion.
> > Meanwhile I'm trying to verify other things, could you please confirm
> > if the kernel tree isn't any issue here.
>
> It looks like kernel and userspace disagree on the TIME_NS meta attribute
> enum value.
