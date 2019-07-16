Return-Path: <SRS0=/Fuh=VN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F4EC76188
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 06:50:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FE93206C2
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 06:50:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="IJqFn+H8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbfGPGu1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Jul 2019 02:50:27 -0400
Received: from condef-09.nifty.com ([202.248.20.74]:36743 "EHLO
        condef-09.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbfGPGu1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jul 2019 02:50:27 -0400
Received: from conssluserg-05.nifty.com ([10.126.8.84])by condef-09.nifty.com with ESMTP id x6G6jRkb007735
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 15:45:27 +0900
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44]) (authenticated)
        by conssluserg-05.nifty.com with ESMTP id x6G6j0tB024139;
        Tue, 16 Jul 2019 15:45:01 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-05.nifty.com x6G6j0tB024139
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1563259501;
        bh=wyBqa/xowQ1dS9M9LftizJwIfclbEFgIfLTYLfJB+M8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IJqFn+H8zgVOweDNuHmiFrR2maGFtzYYOBvnTsV0ib4Of48hOxzUfCurvHTJqiI5n
         wT66VhUccaFzHUs6wo0aepQc3zn8O4GGcsZI5OBWS536oA5i0IoKYAkFDLOLAWuROC
         lqWkfLPVma/N3H5wgIuKerRlt4RVu8Qtzi5iXpW1jZzTEQIeI/k3AzRcIsHUg72Xmd
         gqjoaWyyZ0eJhDsF2bDQNDnxk77lHm0eWCZzEYN4DJKI2mGKSTJti71kBer5WZ1HDn
         rGiKNPALEUtbHF4sNHHQHf0CxXyeRRgGftdTr5RMP6U7Iy4KoqUG9LNLn1FqpPWKDy
         DgUWwOMPLyiRg==
X-Nifty-SrcIP: [209.85.217.44]
Received: by mail-vs1-f44.google.com with SMTP id y16so13149139vsc.3;
        Mon, 15 Jul 2019 23:45:00 -0700 (PDT)
X-Gm-Message-State: APjAAAVnlfjfppALUh6dxLucoujKdo+yYpZDZ8JCDKWXrRG47CioUcgW
        msKP/MWU/rfETbzlz8/16QJZYCya6NvQ1/lled4=
X-Google-Smtp-Source: APXvYqyva5i1c3JLpOzDL6mI/p6SmANdobabSGbkoOHR30w+QyJIHzQbyt0XY5Hl4LVK4zRwz4VCYNAKeUs/k2lnARY=
X-Received: by 2002:a67:f495:: with SMTP id o21mr18799846vsn.54.1563259499952;
 Mon, 15 Jul 2019 23:44:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190715144848.4cc41e07@canb.auug.org.au> <ccb5b818-c191-2d9e-311f-b2c79b7f6823@infradead.org>
 <CAF90-WirEMg7arNOTmo+tyJ20rt_zeN=nr0OO6Qk0Ss8J4QrUA@mail.gmail.com>
 <20190715173341.zth4na7zekjsesaa@salvia> <CAK7LNAS0rX_SRXqb=N=Td-DFNWd=PytDFje12gYh2pYNRBVAJA@mail.gmail.com>
 <20190715180905.rytaht5kslpbatcy@salvia>
In-Reply-To: <20190715180905.rytaht5kslpbatcy@salvia>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Tue, 16 Jul 2019 15:44:24 +0900
X-Gmail-Original-Message-ID: <CAK7LNATBkx5vH4mgb7GYjOquye0nTRR2+VVJ=y=kk=GyoVVuUw@mail.gmail.com>
Message-ID: <CAK7LNATBkx5vH4mgb7GYjOquye0nTRR2+VVJ=y=kk=GyoVVuUw@mail.gmail.com>
Subject: Re: linux-next: Tree for Jul 15 (HEADERS_TEST w/ netfilter tables offload)
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Laura Garcia <nevola@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 16, 2019 at 3:09 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Tue, Jul 16, 2019 at 02:56:09AM +0900, Masahiro Yamada wrote:
> > On Tue, Jul 16, 2019 at 2:33 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >
> > > On Mon, Jul 15, 2019 at 07:28:04PM +0200, Laura Garcia wrote:
> > > > CC'ing netfilter.
> > > >
> > > > On Mon, Jul 15, 2019 at 6:45 PM Randy Dunlap <rdunlap@infradead.org> wrote:
> > > > >
> > > > > On 7/14/19 9:48 PM, Stephen Rothwell wrote:
> > > > > > Hi all,
> > > > > >
> > > > > > Please do not add v5.4 material to your linux-next included branches
> > > > > > until after v5.3-rc1 has been released.
> > > > > >
> > > > > > Changes since 20190712:
> > > > > >
> > > > >
> > > > > Hi,
> > > > >
> > > > > I am seeing these build errors from HEADERS_TEST (or KERNEL_HEADERS_TEST)
> > > > > for include/net/netfilter/nf_tables_offload.h.s:
> > > > >
> > > > >   CC      include/net/netfilter/nf_tables_offload.h.s
> > > [...]
> > > > > Should this header file not be tested?
> >
> > This means you must endlessly exclude
> > headers that include nf_tables.h
> >
> >
> > > Yes, it should indeed be added.
> >
> > Adding 'header-test-' is the last resort.
>
> OK, so policy now is that all internal headers should compile
> standalone, right?

I would not say that.
I just want to put as much code as possible into the test-coverage.

If there is a good reason to opt out of the header-test, that is OK.
We should take a look at the cause of the error
before blindly adding it into the blacklist.


For this particular case, I just thought some functions
could be localized in net/netfilter/, and would be cleaner.

Having said that, I am not familiar enough with
the netfilter subsystem.
So, this should be reviewed by the experts in the area.


Anyway, CONFIG_NF_TABLES seems mandatory to compile
include/net/netfilter/nf_tables_*.h

So, I will queue the following patch
to suppress the error for now.

diff --git a/include/Kbuild b/include/Kbuild
index 7e9f1acb9dd5..e59605243bca 100644
--- a/include/Kbuild
+++ b/include/Kbuild
@@ -905,10 +905,11 @@ header-test-                      +=
net/netfilter/nf_nat_redirect.h
 header-test-                   += net/netfilter/nf_queue.h
 header-test-                   += net/netfilter/nf_reject.h
 header-test-                   += net/netfilter/nf_synproxy.h
-header-test-                   += net/netfilter/nf_tables.h
-header-test-                   += net/netfilter/nf_tables_core.h
-header-test-                   += net/netfilter/nf_tables_ipv4.h
+header-test-$(CONFIG_NF_TABLES)        += net/netfilter/nf_tables.h
+header-test-$(CONFIG_NF_TABLES)        += net/netfilter/nf_tables_core.h
+header-test-$(CONFIG_NF_TABLES)        += net/netfilter/nf_tables_ipv4.h
 header-test-                   += net/netfilter/nf_tables_ipv6.h
+header-test-$(CONFIG_NF_TABLES)        += net/netfilter/nf_tables_offload.h
 header-test-                   += net/netfilter/nft_fib.h
 header-test-                   += net/netfilter/nft_meta.h
 header-test-                   += net/netfilter/nft_reject.h



This test just landed in upstream,
and will take some time to iron out the issues.

If I am disturbing people too much,
I perhaps need to loosen the policy.
Sorry if this test is too annoying.


Thanks.


--
Best Regards
Masahiro Yamada
