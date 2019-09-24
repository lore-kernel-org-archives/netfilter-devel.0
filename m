Return-Path: <SRS0=Dg9R=XT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C29FDC432C1
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Sep 2019 06:38:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F15120665
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Sep 2019 06:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393277AbfIXGi7 convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Sep 2019 02:38:59 -0400
Received: from mail.cadcon.de ([62.153.172.90]:37431 "EHLO mail.cadcon.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389156AbfIXGi6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Sep 2019 02:38:58 -0400
From:   "Priebe, Sebastian" <sebastian.priebe@de.sii.group>
To:     Jeremy Sowden <jeremy@azazel.net>
CC:     Jan Engelhardt <jengelh@inai.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: AW: [PATCH nftables 1/3] src, include: add upstream linenoise source.
Thread-Topic: [PATCH nftables 1/3] src, include: add upstream linenoise
 source.
Thread-Index: AQHVcHrFL1uTBlr0U06uXWwXMBVFUqc2YHaAgADGYQCAAa3JAIAAC0AAgACTUICAAO/cQA==
Date:   Tue, 24 Sep 2019 06:38:55 +0000
Message-ID: <af6fddd931ee498e9f5d706986567fe1@de.sii.group>
References: <20190921122100.3740-1-jeremy@azazel.net>
 <20190921122100.3740-2-jeremy@azazel.net>
 <nycvar.YFH.7.76.1909212114010.6443@n3.vanv.qr>
 <20190922070924.uzfjofvga3nufulb@salvia>
 <nycvar.YFH.7.76.1909231041310.14433@n3.vanv.qr>
 <20190923092756.p5563jdmp2wljnex@salvia> <20190923181511.GE28617@azazel.net>
In-Reply-To: <20190923181511.GE28617@azazel.net>
Accept-Language: de-DE, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.240.16]
x-kse-serverinfo: SPMDEAGV001.CADCON.INTERN, 9
x-kse-attachmentfiltering-interceptor-info: protection disabled
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: Clean, bases: 24.09.2019 04:45:00
x-kse-bulkmessagesfiltering-scan-result: protection disabled
x-pp-proceessed: 21f15ad8-196c-4557-8047-0cdd45d4777c
MIME-Version: 1.0
X-CompuMailGateway: Version: 6.00.4.19051.i686 COMPUMAIL Date: 20190924063856Z
Content-Language: de-DE
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello Jeremy,

I just wanted to thank you for picking up my feature request. I really appreciate your work.

I would also vote for the AC_CHECK_LIB([linenoise], ...) variant instead of including the source.
SQLite also does it this way.
Furthermore we already have a linenoise library in our BSP. This way we can reuse it for nftables.

I'm looking forward for the next release including the support.

Thx
Sebastian

> -----Ursprüngliche Nachricht-----
> Von: Jeremy Sowden <jeremy@azazel.net>
> Gesendet: Montag, 23. September 2019 20:15
> An: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Jan Engelhardt <jengelh@inai.de>; Netfilter Devel <netfilter-
> devel@vger.kernel.org>; Priebe, Sebastian <sebastian.priebe@de.sii.group>
> Betreff: Re: [PATCH nftables 1/3] src, include: add upstream linenoise source.
>
> On 2019-09-23, at 11:27:56 +0200, Pablo Neira Ayuso wrote:
> > On Mon, Sep 23, 2019 at 10:47:40AM +0200, Jan Engelhardt wrote:
> > > On Sunday 2019-09-22 09:09, Pablo Neira Ayuso wrote:
> > > >> > src/linenoise.c     | 1201
> +++++++++++++++++++++++++++++++++++++++++++
> > > >>
> > > >> That seems like a recipe to end up with stale code. For a
> > > >> distribution, it's static linking worsened by another degree.
> > > >>
> > > >> (https://fedoraproject.org/wiki/Bundled_Libraries?rd=Packaging:Bu
> > > >> ndled_Libraries)
> > > >
> > > >I thought this is like mini-gmp.c? Are distributors packaging this
> > > >as a library?
> > >
> > > Yes; No.
> > >
> > > After an update to a static library, a distro would have to rebuild
> > > dependent packages and then distribute that. Doable, but cumbersome.
> > >
> > > But bundled code evades even that. If there is a problem, all
> > > instances of the "static library" would need updating. Doable, but
> > > even more cumbersome.
> > >
> > > Basically the question is: how is NF going to guarantee that
> > > linenoise (or mini-gmp for that matter) are always up to date?
> >
> > It seems to me that mini-gmp.c was designed to be used like we do.
> >
> > For the linenoise case, given that there's already a package in
> > Fedora, I'm fine to go for AC_CHECK_LIB([linenoise], ...) and _not_
> > including the copy in our tree.
>
> Righto.  Will send out v2 in a bit.
>
> > Probably other distributions might provide a package soon for this
> > library.
>
> I've nearly finished a package for Debian.  Will see if anyone fancies
> sponsoring it.
>
> J.



SII Technologies GmbH
Geschäftsführer: Robert Bauer
Sitz der Gesellschaft: 86167 Augsburg
Registergericht: Amtsgericht Augsburg HRB 31802

