Return-Path: <SRS0=YpbV=TC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51BECC43219
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 May 2019 06:45:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19EAD208C4
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 May 2019 06:45:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A9DaJi/W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbfEBGpF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 May 2019 02:45:05 -0400
Received: from mail-vs1-f43.google.com ([209.85.217.43]:39119 "EHLO
        mail-vs1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbfEBGpF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 May 2019 02:45:05 -0400
Received: by mail-vs1-f43.google.com with SMTP id g127so740463vsd.6
        for <netfilter-devel@vger.kernel.org>; Wed, 01 May 2019 23:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3cgqssgyvZR1CboLIt4r3AgfpT6cFjGDc9UcN4vubXA=;
        b=A9DaJi/WtZg5FW1qI9QwilLN1zc5WzDFMaOl13ofjxjAqjS2pWzzaowwktUrEUgUm8
         +oAOS0H51XyuuhDSRnEZAJ18LsTLQnZMTmPlUkrRdUh6sDBWgfbr5DN+xLYLuVNqL1qC
         UqR3ub+5wEDXAoT1WryZfXvM0inS0bPwGy3AiJG8P7VMAx1F86YI2kHcsydUQd8MsRoF
         g4VeRZ9lbnkV8McE6EX5Eutb2roG8WF/Zm2pbMaJ6dbF1Hc6xPO9MVExsa2j9qE401Ab
         yxkCd2OxttujXz+NvUcW3/OHy5F8UR0GEkef5rcuO/P2oBDexIJ5ZvGP12zf9Y0zcLVE
         sIIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3cgqssgyvZR1CboLIt4r3AgfpT6cFjGDc9UcN4vubXA=;
        b=bMS+byVCf09hJAA4/YLLI4yApk7kV4oHYwqDI3i2kWS/lVxUFxryP5T48RNfSYaEKd
         C5DeqKtlshP7bABpAFV0Uq5d7TfxWjP4uLV0hndTWmS/baMzZRvfWkb71ZV7n95J5WU/
         mmlkUvmGyMGZM2rKOEzCDEXf+gyxCXpUPmn0lkYSs6Ewd97BsW5+oqUk5Xqtsn65e+wQ
         wezXAHEpj78qiYA4UcSq6oMU0zmx6T6LBytFcQgh1541/3f+7nwS71X9WpoCME6YYnT8
         KBkhNHbKvr0wp4HlH1A011oERFlum2l1pDtKV5GgBHozBAGvgHwgVIt+vIFp6xKdjNs8
         Esfg==
X-Gm-Message-State: APjAAAXHPn+8LzZ1u5qAjiXevLeEg1N7UEiGZcfo+mQF2WzAD5BWz6ru
        W77P1QjsVp/rUbgPiv3RUxs9hhSBsJjmG/x9nfB7bqRc
X-Google-Smtp-Source: APXvYqxZDfENj2Ro7l1OIhPtiJTCzcEEDBBiHv/oZD7GqxgSzG9Km8mCyBxlW2kHV8ki9g/0+4rzrukIc2xscc8JXlM=
X-Received: by 2002:a67:f249:: with SMTP id y9mr1042933vsm.118.1556779504341;
 Wed, 01 May 2019 23:45:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAFs+hh5aHv_Xy2H2g9Bgsa-BYNY-uvE442Ws37vYtF484nZanQ@mail.gmail.com>
 <20180309120324.GB19924@breakpoint.cc> <CAFs+hh42HuoQh4Js7yyopVqofD-6YXkOVvrx=XjYm43igaaRLg@mail.gmail.com>
 <20180312112547.GA8844@breakpoint.cc> <CAFs+hh61B0+qx3uyr2TwKWCNKqPn5YgN33RjmOMafTESYsmyjQ@mail.gmail.com>
 <20180312155357.GC8844@breakpoint.cc>
In-Reply-To: <20180312155357.GC8844@breakpoint.cc>
From:   =?UTF-8?Q?St=C3=A9phane_Veyret?= <sveyret@gmail.com>
Date:   Thu, 2 May 2019 08:44:52 +0200
Message-ID: <CAFs+hh79dGTpW8OvUuGZ==YqVFXKs1q=NLE7oMnLjqJW5ZUHww@mail.gmail.com>
Subject: Re: Port triggering
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello Florian, hello all,

More than a year has past since I asked all those questions about
adding expectation attribute to nf_tables, and I finally have time to
work on it. But I find it difficult to understand the way it is
written, and therefore have questions. Here are the first ones (see
below).

Le lun. 12 mars 2018 =C3=A0 16:53, Florian Westphal <fw@strlen.de> a =C3=A9=
crit :
> > > Something like:
> > >
> > > chain postrouting {
> > >         type filter hook postrouting priority 0;
> > >         # tell kernel to install an expectation
> > >         # arriving on udp ports 6970-7170
> > >         # expectation will follow whatever NAT transformation
> > >         # is active on master connection
> > >         # expectation is removed after 5 minutes
> > >         # (we could of course also allow to install an expectation
> > >         # for 'foreign' addresses as well but I don't think its neede=
d
> > >         # yet
> > >         ip dport 554 ct expectation set udp dport 6970-7170 timeout 5=
m
> > > }
> >
> > It may be what I'm looking for. But I couldn't find any documentation
> > about this =E2=80=9Cct expectation=E2=80=9D command. Or do you mean I s=
hould create a
> > conntrack helper module for that?
>
> Right, this doesn't exist yet.
>
> I think we (you) should consider to extend net/netfilter/nft_ct.c, to
> support a new NFT_CT_EXPECT attribute in nft_ct_set_eval() function.
>
> This would then install a new expectation based on what userspace told
> us.
>
> You can look at
> net/netfilter/nf_conntrack_ftp.c
> and search for nf_ct_expect_alloc() to see where the ftp helper installs
> the expectation.
>
> The main difference would be that with nft_ct.c, most properties of
> the new expectation would be determined by netlink attributes which were
> set by the nftables ruleset.

Does this mean I should create a new structure containing expectation
data, as required by the nf_ct_expect_init function, and that I should
expect to find this structure at &regs->data[priv->sreg] in
nft_ct_set_eval?
When all this is done, I will have to also update the nftables
command. Will I also need to update the nftables library?

Thank you.
