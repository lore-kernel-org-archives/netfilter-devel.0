Return-Path: <SRS0=TYlN=YI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 767DEC10F14
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 07:23:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FE1221835
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 07:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbfJOHXJ convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Oct 2019 03:23:09 -0400
Received: from mail.cadcon.de ([62.153.172.90]:58643 "EHLO mail.cadcon.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725710AbfJOHXI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Oct 2019 03:23:08 -0400
From:   "Priebe, Sebastian" <sebastian.priebe@de.sii.group>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
CC:     Jeremy Sowden <jeremy@azazel.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: AW: [PATCH nftables v2 0/2] Add Linenoise support to the CLI.
Thread-Topic: [PATCH nftables v2 0/2] Add Linenoise support to the CLI.
Thread-Index: AQHVcrCNPSPJEaoIW0iz3RuqzQyz/adbbI0Q
Date:   Tue, 15 Oct 2019 07:23:06 +0000
Message-ID: <1017eacb750741c4b9836f3c8e082fec@de.sii.group>
References: <20190924074055.4146-1-jeremy@azazel.net>
In-Reply-To: <20190924074055.4146-1-jeremy@azazel.net>
Accept-Language: de-DE, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.240.16]
x-kse-serverinfo: SPMDEAGV001.CADCON.INTERN, 9
x-kse-attachmentfiltering-interceptor-info: protection disabled
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: Clean, bases: 15.10.2019 05:33:00
x-kse-bulkmessagesfiltering-scan-result: protection disabled
x-pp-proceessed: 21f15ad8-196c-4557-8047-0cdd45d4777c
MIME-Version: 1.0
X-CompuMailGateway: Version: 6.00.4.19051.i686 COMPUMAIL Date: 20191015072306Z
Content-Language: de-DE
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,
I'd really would appreciate if this gets pulled soon.
Are there any objections?

Until now this series was acked-by Phil Sutter.

Greetings,
Sebastian

> -----Ursprüngliche Nachricht-----
> Von: Jeremy Sowden <jeremy@azazel.net>
> Gesendet: Dienstag, 24. September 2019 09:41
> An: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>; Priebe, Sebastian
> <sebastian.priebe@de.sii.group>
> Betreff: [PATCH nftables v2 0/2] Add Linenoise support to the CLI.
>
> Sebastian Priebe [0] requested Linenoise support for the CLI as an alternative
> to Readline, so I thought I'd have a go at providing it.
> Linenoise is a minimal, zero-config, BSD licensed, Readline replacement used
> in Redis, MongoDB, and Android [1].
>
>  0 - https://lore.kernel.org/netfilter-
> devel/4df20614cd10434b9f91080d0862dd0c@de.sii.group/
>  1 - https://github.com/antirez/linenoise/
>
> By default, the CLI continues to be build using Readline, but passing `--with-
> cli=linenoise` instead causes Linenoise to be used instead.
>
> `nft -v` has been extended to display what CLI implementation was built and
> whether mini-gmp was used.
>
> Changes since v1:
>
>  * dropped the linenoise source from the nftables tree and added an
>    `AC_CHECK_LIB` check instead.
>
> Changes since RFC:
>
>  * two tidy-up patches dropped because they have already been applied;
>  * source now added to include/ and src/;
>  * tests/build/run-tests.sh updated to test `--with-cli=linenoise`;
>  * `nft -v` extended.
>
> Jeremy Sowden (2):
>   cli: add linenoise CLI implementation.
>   main: add more information to `nft -v`.
>
>  configure.ac             | 17 ++++++++---
>  include/cli.h            |  2 +-
>  src/Makefile.am          |  3 ++
>  src/cli.c                | 64 ++++++++++++++++++++++++++++++++++------
>  src/main.c               | 28 ++++++++++++++++--
>  tests/build/run-tests.sh |  4 +--
>  6 files changed, 100 insertions(+), 18 deletions(-)
>
> --
> 2.23.0
>




SII Technologies GmbH
Geschäftsführer: Robert Bauer
Sitz der Gesellschaft: 86167 Augsburg
Registergericht: Amtsgericht Augsburg HRB 31802

