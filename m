Return-Path: <SRS0=2UWv=XQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33009C4CEC4
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Sep 2019 12:21:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0694B20717
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Sep 2019 12:21:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="Lq2ObE6N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437855AbfIUMVC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 21 Sep 2019 08:21:02 -0400
Received: from kadath.azazel.net ([81.187.231.250]:33098 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437848AbfIUMVC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Sep 2019 08:21:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6NaNsrxU16SDh6FjDULaOTwcyGZuPsObHyGIX8x3b00=; b=Lq2ObE6NXIM0H/v82qCCsfxnoQ
        YiZsgr0/8mHqRaAY+kFf9AqCFY2dR4PzDnpgcvRFqaXsgN3BE8bRVwJRsITv0kNGFZrYAI9f6glbt
        bhQQnkmXRN5XAN4vDW0mZGPsUcLAj/3kCVGU1iFkSOzfms5LmCwY1gZFvjYR0kVwuQI8dLei6ZA61
        N1KTP0C9VNIsvgMNN6JVcLRDot7lBtc48jkG8pplZmRKhwrcCvGWMT4QgeB9ubCyyBx0VUVicDBNL
        HN9wc5/+g0QUfrL48t/ZK7Ao1Pcnw8NzkgLEME3uWDpigovk3NB7YMH3kLBgcSV1j1Ulu0tvpUZ71
        gK0AkBDg==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iBeNo-0000qr-VH; Sat, 21 Sep 2019 13:21:01 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Sebastian Priebe <sebastian.priebe@de.sii.group>
Subject: [PATCH nftables 0/3] Add Linenoise support to the CLI.
Date:   Sat, 21 Sep 2019 13:20:57 +0100
Message-Id: <20190921122100.3740-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Sebastian Priebe [0] requested Linenoise support for the CLI as an
alternative to Readline, so I thought I'd have a go at providing it.
Linenoise is a minimal, zero-config, BSD licensed, Readline replacement
used in Redis, MongoDB, and Android [1].

 0 - https://lore.kernel.org/netfilter-devel/4df20614cd10434b9f91080d0862dd0c@de.sii.group/
 1 - https://github.com/antirez/linenoise/

The upstream repo doesn't contain the infrastructure for building or
installing libraries.  I've taken a look at how Redis and MongoDB handle
this, and they both include the upstream sources in their trees (MongoDB
actually uses a C++ fork, Linenoise NG [2]), so I've done the same.

 2 - https://github.com/arangodb/linenoise-ng

By default, the CLI continues to be build using Readline, but passing
`--with-cli=linenoise` instead causes Linenoise to be used instead.

`nft -v` has been extended to display what CLI implementation was built
and whether mini-gmp was used.

Changes since RFC:

 * two tidy-up patches dropped because they have already been applied;
 * source now added to include/ and src/;
 * tests/build/run-tests.sh updated to test `--with-cli=linenoise`;
 * `nft -v` extended.

Jeremy Sowden (3):
  src, include: add upstream linenoise source.
  cli: add linenoise CLI implementation.
  main: add more information to `nft -v`.

 configure.ac             |   14 +-
 include/Makefile.am      |    1 +
 include/cli.h            |    2 +-
 include/linenoise.h      |   73 +++
 src/Makefile.am          |   12 +
 src/cli.c                |   64 +-
 src/linenoise.c          | 1201 ++++++++++++++++++++++++++++++++++++++
 src/main.c               |   28 +-
 tests/build/run-tests.sh |    4 +-
 9 files changed, 1381 insertions(+), 18 deletions(-)
 create mode 100644 include/linenoise.h
 create mode 100644 src/linenoise.c

-- 
2.23.0

